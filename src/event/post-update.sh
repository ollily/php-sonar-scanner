#!/usr/bin/env bash

echo -e "Running post-update-cmd\n"

ROOT_DIR=$1
VERSION=$2
FULL_WF=1

exitrc() {
    if [ -n "${ERRC}" ]; then
        echo -e "\nExit with '${ERRC}'\n"
        exit 0
    fi
}

getos() {
    case "$(uname -sr)" in
       Darwin*)
         OPSYS='mac'
         ;;
       Linux*Microsoft*)
         OPSYS='wsl'
         ;;
       Linux*)
         OPSYS='lin'
         ;;
       CYGWIN*|MINGW*|MINGW32*|MSYS*)
         OPSYS='win'
         ;;
       *)
         OPSYS='oth' 
         ;;
    esac
}

validate(){
    if [ ! -n "${VERSION}" ]; then
        ERRC="No Version"; exitrc;
    fi
    if [ -n "${ROOT_DIR}" ]; then
        ROOT_DIR=$(realpath ${ROOT_DIR})
        LIB_DIR=${ROOT_DIR}/lib
    else
        ERRC="No root given"; exitrc;
    fi
    if [ ! -d "${ROOT_DIR}" ]; then
        ERRC="Root not existing"; exitrc;
    fi
    if [ -d "${LIB_DIR}" ]; then
        echo -e "Scanner already existing"
        FULL_WF=0
    fi
}

prepare(){
    TARGET_DIR=${ROOT_DIR}/target
    TMP_DIR=${TARGET_DIR}/.tmp

    SONAR_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli
    SONAR_ZIP=sonar-scanner-cli-${VERSION}.zip
    SONAR_FOLDER=sonar-scanner-${VERSION}
    SONAR_EXE=${LIB_DIR}/bin/sonar-scanner
    DL_URL=${SONAR_URL}/${SONAR_ZIP}
}

download(){
    echo ${TMP_DIR}
    if [ -d ${TMP_DIR} ]; then
        rm -rf ${TMP_DIR}
    fi
    mkdir -p ${TMP_DIR}

    cd ${TMP_DIR}
    echo -e "Downloading '${DL_URL}'\n"
    curl --insecure -s -o ${SONAR_ZIP} ${DL_URL}
}

unpack(){
    if [ -s ${SONAR_ZIP} ]; then
        echo -e "Unzipping '${SONAR_ZIP}'\n"
        unzip -q ${SONAR_ZIP}
    else
        ERRC="Nothing to unzip"; exitrc;
    fi
}

provide(){
    cd ${TMP_DIR}
    if [ -d ${SONAR_FOLDER} ]; then
        echo -e "Provide scanner files\n"
        #mkdir -p ${LIB_DIR}
        mv ${SONAR_FOLDER}/* ${ROOT_DIR}
    else 
        ERRC="No library found"; exitrc;
    fi
}

verify(){
    if [ -f ${SONAR_EXE} ]; then
        echo "VERIFY ${OPSYS}"
        eval "${SONAR_EXE} -v"
    else
        ERRC="No scanner found"; exitrc;
    fi
}

finish(){
    echo -e "\nFinished\n"
    exit 0
}

# main
validate
getos
prepare

if [ "${FULL_WF}" = "1" ]; then
    # Full process
    download
    unpack
    provide
#   verify
    finish
else
    # Just check
#    verify
    finish
fi
