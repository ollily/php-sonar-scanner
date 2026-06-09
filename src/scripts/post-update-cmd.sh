#!/usr/bin/env bash
#
# License
# -------
# This source file is subject to the Apache-2.0 license that is bundled with this source code in the file LICENSE.
#
# Contact  : 426229+ollily@users.noreply.github.com
# Homepage : https://github.com/ollily
#

log() {
    local msg="${1}"
    echo -e "${msg}"
}

exitrc() {
    local ERRC="${1}"
    if [ -n "${ERRC}" ]; then
        echo -e "\nExit with '${ERRC}'\n"
        exit 0
    fi
}

checkCygwin() {
    case "$(uname -sr)" in
       Linux*)
         loval CYGOS='linux'
         ;;
       CYGWIN*)
         local CYGOS='cygwin'
         ;;
       *)
         local CYGOS='' 
         ;;
    esac
    if [ ! -n "${CYGOS}" ]; then
        echo -e "\nWARNING! When running on Windows, you must install Cygwin!\n"
    fi
}

log "post-update-cmd - START"

checkCygwin

SONAR_VERSION=8.1.0.6389
./src/scripts/install-scanner.sh "${1}" "${SONAR_VERSION}"

log "post-update-cmd - END"
