#!/usr/bin/env bash
#
# - Downloads the scanner zip-file
# - Unpack it and put the files in the necessary folders
# - Reinstalls, if scanner zip-file already downloaded
#
# Notes
# -----
# - The Sonarsource server doesn't like wget, so curl must be used
# - Could not test the script on Mac OSX
#
# Usage
# -----
# ./post-update.sh [-f]
#
# Options
# -------
# -f    If scanner zip-file already exists, forece a reinstall
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

getos() {
    case "$(uname -sr)" in
       Darwin*)
         OPSYS='macosx-x64'
         ;;
       Linux*Microsoft*)
         OPSYS='windows-x64'
         ;;
       Linux*)
         OPSYS='linux-x64'
         ;;
       CYGWIN*|MINGW*|MINGW32*|MSYS*)
         OPSYS='windows-x64'
         ;;
       *)
         OPSYS='' 
         ;;
    esac
    log "Running on '${OPSYS}'"
}

validate(){
    if [ -n "${WF_FORCE}" ]; then
        log "Force reinstall"
        WF_FORCE="-f"
    fi
    if [ ! -n "${VERSION}" ]; then
        exitrc "No Version"
    fi
    if [ -n "${ROOT_DIR}" ]; then
        ROOT_DIR=$(realpath ${ROOT_DIR})
        LIB_DIR=${ROOT_DIR}/lib
    else
        exitrc "No root given"
    fi
    if [ ! -d "${ROOT_DIR}" ]; then
        exitrc "Root not existing"
    fi
    if [ -d "${LIB_DIR}" ]; then
        log "No download is necessary"
        WF_FULL=0
    fi
}

prepare(){
    TARGET_DIR=${ROOT_DIR}/target
    TMP_DIR=${TARGET_DIR}/.tmp

    SONAR_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli
    if [ -n "${OPSYS}" ]; then
        SONAR_ZIP=sonar-scanner-cli-${VERSION}-${OPSYS}.zip
        SONAR_FOLDER=sonar-scanner-${VERSION}-${OPSYS}
    else
        SONAR_ZIP=sonar-scanner-cli-${VERSION}.zip
        SONAR_FOLDER=sonar-scanner-${VERSION}
    fi
    SONAR_EXE=${LIB_DIR}/bin/sonar-scanner
    DL_URL=${SONAR_URL}/${SONAR_ZIP}
}

download(){
    if [ -f ${TMP_DIR}/${SONAR_ZIP} ]; then
        log "Already existing '${SONAR_ZIP}'"
    else
        if [ -d ${TMP_DIR} ]; then
            rm -rf ${TMP_DIR}
        fi
        mkdir -p ${TMP_DIR}

        cd ${TMP_DIR}
        log "Downloading '${DL_URL}'"
        curl --insecure --parallel -o ${SONAR_ZIP} ${DL_URL}
    fi
}

unpack(){
    cd ${TMP_DIR}
    if [ -s ${SONAR_ZIP} ]; then
        log "Unzipping '${SONAR_ZIP}'"
        unzip -u -q ${SONAR_ZIP}
    else
        exitrc "Nothing to unzip"
    fi
}

provide(){
    cd ${TMP_DIR}
    if [ -d ${SONAR_FOLDER} ]; then
        log "Provide scanner files"
        if [ -d ${LIB_DIR} ]; then
           rm -rf ${LIB_DIR}
           sleep 1
        fi
        mkdir -p ${LIB_DIR}
        mv -f -u ${SONAR_FOLDER}/* ${LIB_DIR}
    else 
        exitrc "No library found"
    fi
}

verify(){
    if [ -f ${SONAR_EXE} ]; then
        eval "${SONAR_EXE} -v"
    else
        exitrc "No scanner found"
    fi
}

finish(){
    exit 0
}

# main
ROOT_DIR="${1}"
VERSION="${2}"
WF_FORCE="${3}"
WF_FULL="1"

getos
validate
prepare

if [ "${WF_FULL}" = "1" ]; then
    # Full process
    download
    unpack
    provide
else
    if [ "${WF_FORCE}" = "-f" ]; then
        # Just reinstall
        unpack
        provide
    fi
fi
    
finish
