#!/usr/bin/env bash

# settings

set -o errexit
set -o pipefail
set -o nounset

# file and dir variables

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"

