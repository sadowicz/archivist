#!/usr/bin/env bash

# settings

set -o errexit
set -o pipefail
set -o nounset

# file and dir variables

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"

# functions definitions

# script program variables

argv=("$@")
supported_pattern='tar|gzip|bzip2'

# main script

format="$(egrep --only-matching --word-regexp ${supported_pattern} <<< "$(file ${argv[0]})" |
		head --lines=1)"

case ${format} in
	"tar")
		tar -xf ${argv[0]}
		;;
	"gzip")
		gunzip ${argv[0]}
		;;
	"bzip2")
		bunzip2 ${argv[0]}
		;;
	*)
		echo "ERROR: unsupported archive type" >$2
		;;
esac
