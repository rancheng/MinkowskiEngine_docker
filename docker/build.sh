#!/bin/bash

file_dir=`dirname $0`

# get parameter from system
user=`id -un`
group=`id -gn`
uid=`id -u`
gid=`id -g`

readonly SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE}")")

# Collect proxy environment variables to pass to docker build
function build_args_proxy() {
    # Enable host-mode networking if necessary to access proxy on localhost
    env | grep -iP '^(https?|ftp)_proxy=.*$' | grep -qP 'localhost|127\.0\.0\.1' && {
        echo -n "--network host "
    }
    # Proxy environment variables as "--build-arg https_proxy=https://..."
    env | grep -iP '^(https?|ftp|no)_proxy=.*$' | while read env_proxy; do
        echo -n "--build-arg ${env_proxy} "
    done
}

echo  

# build docker images
docker build $(build_args_proxy) -t ${user}/minkowski-engine-base \
    --build-arg USER=${user} \
    --build-arg UID=${uid} \
    --build-arg GROUP=${group} \
    --build-arg GID=${gid} \
    ${file_dir}
