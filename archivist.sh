#!/usr/bin/env bash

# settings

set -o errexit
set -o pipefail
set -o nounset

# file and dir variables

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"

# script program variables

argv=("$@")
supported_patterns='tar|gzip|bzip2|zip|xz'

declare -A COLORS=([RED]="\033[1;31m" [UNSET]="\033[0m")

# functions definitions

function err() {

	echo -e "${COLORS[RED]}${__base} : ERROR:${COLORS[UNSET]} $1" >&2
}

# main script

format="$(echo "$(egrep --only-matching --word-regexp ${supported_patterns} <<< \
		"$(file ${argv[0]} | tr '[:upper:]' '[:lower:]')" | head --lines=1)")"

case ${format} in
	"tar")
		tar -xf "${argv[0]}"
		;;
	"gzip")
		gunzip "${argv[0]}"
		;;
	"bzip2")
		bunzip2 "${argv[0]}"
		;;
	"zip")
		unzip "${argv[0]}"
		;;
	"xz")
		cp "${argv[0]}" "${argv[0]}.xz"
		rm "${argv[0]}"
		unxz "${argv[0]}.xz"
		;;
	*)
		err "Unsupported archive type"
		;;
esac
