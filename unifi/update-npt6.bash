#!/bin/bash

# Set the network interface
EXT_IF="eth4"

# Temporary file to store the last known prefix
LAST_PREFIX_FILE="/tmp/last_ipv6_prefix"

# Detect the first global IPv6 address and prefix length on the external interface
IPV6_RAW=$(ip -6 addr show dev "$EXT_IF" scope global | awk '/inet6/ {print $2; exit}')

# Ensure we found a global IPv6 address
if [[ -z "$IPV6_RAW" ]]; then
    echo "Error: Could not determine a global IPv6 prefix on $EXT_IF" >&2
    exit 1
fi

# Function to expand IPv6 address to long-form
expand_ipv6() {
    local ip="$1"
    python3 -c "import ipaddress; print(ipaddress.IPv6Address('$ip').exploded)"
}

# Extract the prefix length from the IP address
PREFIX_LENGTH="${IPV6_RAW##*/}"

# Expand the IPv6 address to its full form
IPV6_FULL=$(expand_ipv6 "${IPV6_RAW%%/*}")

# Extract the first 4 hextets to fully capture a /56 or /60 prefix
IPV6_PREFIX=$(echo "$IPV6_FULL" | cut -d':' -f1-4)

# Construct the CIDR notation dynamically
EXTERNAL_PREFIX="$IPV6_PREFIX::/$PREFIX_LENGTH"
INTERNAL_PREFIX="f444:db8:11::/$PREFIX_LENGTH"

# Check if the prefix has changed
if [[ -f "$LAST_PREFIX_FILE" ]]; then
    LAST_PREFIX=$(cat "$LAST_PREFIX_FILE")
else
    LAST_PREFIX=""
fi

if [[ "$LAST_PREFIX" == "$EXTERNAL_PREFIX" ]]; then
    echo "No change in IPv6 prefix. Exiting."
    exit 0
fi

echo "Detected IPv6 prefix change: $LAST_PREFIX → $EXTERNAL_PREFIX"
echo "$EXTERNAL_PREFIX" > "$LAST_PREFIX_FILE"

# Load required kernel module
modprobe ip6t_NPT

# Remove only the old NPT rules before applying new ones
if [[ -n "$LAST_PREFIX" ]]; then
    ip6tables -t mangle -D PREROUTING --src-prefix $LAST_PREFIX -j DNPT --dst-prefix $INTERNAL_PREFIX 2>/dev/null
    ip6tables -t mangle -D POSTROUTING --src-prefix $INTERNAL_PREFIX -j SNPT --dst-prefix $LAST_PREFIX 2>/dev/null
fi

# Apply updated NPTv6 translation rules
ip6tables -t mangle -A PREROUTING --src-prefix $EXTERNAL_PREFIX -j DNPT --dst-prefix $INTERNAL_PREFIX
ip6tables -t mangle -A POSTROUTING --src-prefix $INTERNAL_PREFIX -j SNPT --dst-prefix $EXTERNAL_PREFIX

echo "Updated NPTv6 rules successfully!"
