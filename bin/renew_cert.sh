#!/usr/bin/env bash
set -u

export STORAGE_ROOT=/var/lib/secrets
export CERTS_ROOT="$STORAGE_ROOT/certs"
export STEPPATH="$CERTS_ROOT/step"

step ssh inspect \
    "$CERTS_ROOT/ssh_host_ecdsa_key-cert.pub"

step ssh needs-renewal \
    "$CERTS_ROOT/ssh_host_ecdsa_key-cert.pub" \
    --expires-in 50% &>/dev/null

status=$?

if [ $status -eq 1 ]; then
    echo "Certificate does not need renewal"
elif [ $status -eq 0 ]; then
    echo "Renewing certificate"
    step ssh renew --force \
        "$CERTS_ROOT/ssh_host_ecdsa_key-cert.pub" \
        "$CERTS_ROOT/ssh_host_ecdsa_key"
else
    echo "Unknown error"
    exit 1
fi
