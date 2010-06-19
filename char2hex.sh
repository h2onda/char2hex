#!/bin/bash
#
# Usage: char2hex.sh [OPTIONS] [STRINGS]
#
# Convert strings to hex expression.
#
# Author: HONDA Hirofumi <h2onda@gmail.com>
#

function to_hex()
{
	iconv_result=$(echo -n $@ |iconv $iconv_options)
	retval=$?
	if [ ${retval} -eq 0 ]; then
		echo -n $iconv_result|hexdump -e '/1 "0x%02x, "'
		echo 0x00
	fi
}

function to_ucs_charmaps()
{
	echo -n $*|iconv -t ucs-4le|hexdump -e '/4 "<U%04X>\n"'
}

function to_entity_reference()
{
	echo -n $*|iconv -t ucs-4le|hexdump -e '/4 "&#x%04x;"'
	echo
}

function usage()
{
	cat <<-EOF
Usage: $(basename $0) [OPTIONS] [STRINGS]

  Convert strings to hex expression.

  -c : convert to hex expression for char[] (default)
  -t : select target encording when use -c option
  -u : convert to UCS expression for /usr/share/i18n/charmaps/*
  -e : convert to entity reference expression for html

	EOF
}

while getopts "cuet:" flag "$@"; do
	case $flag in
		c) action=to_hex ;;
		u) action=to_ucs_charmaps ;;
		e) action=to_entity_reference ;;
		t) iconv_options="-t $OPTARG" ;;
		?|:) usage; exit ;;
	esac
done
shift $(($OPTIND - 1))

${action:=to_hex} $@
