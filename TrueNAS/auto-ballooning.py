#!/usr/bin/env python3

import time
from subprocess import Popen, PIPE

LIBVIRT_URI = "qemu+unix:///system?socket=/run/truenas_libvirt/libvirt-sock"
VIRSH = ["virsh", "-c", LIBVIRT_URI]

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

# libvirt uses KiB as base units
MiB = 1024
GiB = 1024 * 1024

TARGET_USABLE  = 1 * GiB    # Amount of free memory to keep in VM
MIN_MEMORY     = 1 * GiB    # Minimum size of total VM memory
INFLATE_FACTOR = 4          # Increase memory more aggressively to prepare for future growth (750MiB free -> 250MiB delta -> 1GiB extra)
ROUND_SIZE     = 256 * MiB  # Round memory size to 256MiB
REDUCE_SIZE    = 256 * MiB  # Decrease memory at most 256MiB per iteration
POLL_INTERVAL  = 10         # seconds

# -----------------------------------------------------------------------------

def run(*args):
    proc = Popen(VIRSH + list(args), stdout=PIPE, stderr=PIPE)
    out, err = proc.communicate()

    if proc.returncode != 0:
        raise RuntimeError(err.decode().strip())

    return out.decode()


def get_domains():
    out = run("list", "--name")
    return [d.strip() for d in out.splitlines() if d.strip()]


def enable_memstats(domain):
    run("dommemstat", domain, "--period", "5")


def get_mem(domain):
    res = {}
    out = run("dommemstat", domain)

    for line in out.splitlines():
        if " " not in line:
            continue
        k, v = line.split(None, 1)
        if v.isdigit():
            res[k] = int(v)

    return res


def get_max(domain):
    out = run("dominfo", domain)

    for line in out.splitlines():
        if ":" in line:
            k, v = line.split(":", 1)
            if k.strip() == "Max memory":
                return int(v.split()[0])

    raise RuntimeError("Max memory not found")


def balloon(domain, target):
    run("setmem", domain, "--size", str(target), "--current")


def round_to(value, step):
    return int(round(value / step) * step)


# -----------------------------------------------------------------------------

print("Auto ballooning running")

while True:

    try:
        domains = get_domains()

        for d in domains:

            try:
                enable_memstats(d)

                mem = get_mem(d)

                if "usable" not in mem or "actual" not in mem:
                    continue

                actual = mem["actual"]
                usable = mem["usable"]
                maximum = get_max(d)

                delta = TARGET_USABLE - usable

                # Be more aggressive giving memory than taking it away
                # positive delta = increase memory size
                if REDUCE_SIZE < ROUND_SIZE:
                    REDUCE_SIZE = ROUND_SIZE
                if delta > 0:
                    delta = delta * INFLATE_FACTOR
                if delta < 0 and abs(delta) > REDUCE_SIZE:
                    delta = -REDUCE_SIZE

                target = actual + delta
                target = round_to(target, ROUND_SIZE)

                if target < MIN_MEMORY:
                    target = MIN_MEMORY

                if target > maximum:
                    target = maximum

                if target != actual:

                    print(
                        f"{d:15} "
                        f"usable={usable//MiB:5} MiB "
                        f"actual={actual//MiB:5} MiB "
                        f"target={target//MiB:5} MiB"
                    )

                    balloon(d, target)

            except Exception as e:
                print(f"{d}: {e}")

    except Exception as e:
        print(f"loop error: {e}")

    time.sleep(POLL_INTERVAL)
