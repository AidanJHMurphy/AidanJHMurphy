#!/bin/bash
# Establish hard path of a script directory regardless of how or where the script was called from.
# Call with source ./uniloc.sh to have access to SCRIPT_PATH and SCRIPT_DIR
# If you need to reference uniloc.sh from a script in an unknown location, but with a known relationship to unilo.sh use the relative path.
# For example, a script in the same directory as uniloc.sh would call:
# source "$(dirname -- "$(readlink -f "${BASH_SOURCE}")")"/uniloc.sh
# Credit: https://www.baeldung.com/linux/bash-get-location-within-script
SCRIPT_PATH="${BASH_SOURCE}"
while [ -L "${SCRIPT_PATH}" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "${SCRIPT_PATH}")" >/dev/null 2>&1 && pwd)"
  SCRIPT_PATH="$(readlink "${SCRIPT_PATH}")"
  [[ ${SCRIPT_PATH} != /* ]] && SCRIPT_PATH="${SCRIPT_DIR}/${SCRIPT_PATH}"
done
SCRIPT_PATH="$(readlink -f "${SCRIPT_PATH}")"
SCRIPT_DIR="$(cd -P "$(dirname -- "${SCRIPT_PATH}")" >/dev/null 2>&1 && pwd)"
