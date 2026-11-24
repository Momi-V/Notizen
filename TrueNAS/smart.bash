mkdir -p /run/smartctl_wrap
mountpoint -q /run/smartctl_wrap || mount -t tmpfs -o size=8m,mode=755,exec tmpfs /run/smartctl_wrap
[ -f /run/smartctl_wrap/smartctl.real ] || cp /usr/sbin/smartctl /run/smartctl_wrap/smartctl.real

cat << 'EOF' > /run/smartctl_wrap/smartctl
#!/bin/bash
for arg in "$@"; do
    if [[ -b "$arg" ]]; then
        dev_name=$(basename "$arg")
        if [[ -e "/sys/block/${dev_name}/device/sas_address" ]]; then
            sdparm --readonly --command=sense "$arg" 2>/dev/null | grep -qi "standby" && exit 2
        else
            hdparm -C "$arg" 2>/dev/null | grep -qiE "standby|sleeping" && exit 2
        fi
        break
    fi
done
exec /run/smartctl_wrap/smartctl.real "$@"
EOF

chmod 755 /run/smartctl_wrap/smartctl
mountpoint -q /usr/sbin/smartctl || mount --bind /run/smartctl_wrap/smartctl /usr/sbin/smartctl
