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

supported_patterns='tar|gzip|bzip2|zip|xz'

declare -A COLORS=([RED]="\033[1;31m" [UNSET]="\033[0m")

# functions definitions

function err() {

	echo -e "${COLORS[RED]}${__base} : ERROR:${COLORS[UNSET]} $1" >&2
	exit 1
}

function get_args() {

	# Long options to short

	for arg in "$@"; do
		shift
		case "${arg}" in
			"--create")
			set -- "$@" "-c"
			;;
			"--extract")
			set -- "$@" "-x"
			;;
			"--verbose")
			set -- "$@" "-v"
			;;
			"--help")
			set -- "$@" "-h"
			;;
			"--"*)
			err "Invalid program argument ${arg}.\t\n\tCheck ${__base} --help for more info on usage."
			;;
			*)
			set -- "$@" "${arg}"
			;;
		esac
	done

	# Set defaults

	CREATE=false
	EXTRACT=false
	VERBOSE=false
	HELP=false
	FILE=""

	# Parse short options
	
	OPTIND=1
	while getopts ":cxvh" opt; do
		case "${opt}" in
			"c")
			CREATE=true
			;;
			"x")
			EXTRACT=true
			;;
			"v")
			VERBOSE=true
			;;
			"h")
			HELP=true
			;;
			"?")
			err "Invalid program argument -${OPTARG}.\t\n\tCheck ${__base} --help for more info on usage."
			;;

		esac
	done
	
	# Remove optins from positional parmeters

	shift "$((OPTIND-1))"

	FILE=("$@")
	FILE=${FILE[0]}
}

# main script

get_args "$@"

format="$(echo "$(egrep --only-matching --word-regexp ${supported_patterns} <<< \
		"$(file ${FILE} | tr '[:upper:]' '[:lower:]')" | head --lines=1)")"

case ${format} in
	"tar")
		tar -xf "${FILE}"
		;;
	"gzip")
		gunzip "${FILE}"
		;;
	"bzip2")
		bunzip2 "${FILE}"
		;;
	"zip")
		unzip "${FILE}"
		;;
	"xz")
		cp "${FILE}" "${FILE}.xz"
		rm "${FILE}"
		unxz "${FILE}.xz"
		;;
	*)
		err "Unsupported archive type"
		;;
esac
