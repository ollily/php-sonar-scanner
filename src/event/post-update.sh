#!/usr/bin/env bash
# sonar-scanner-cli-8.1.0.6389.zip

echo -e "Post Update"

OPSYS=
VERSION=8.1.0.6389
#$1

ROOT_DIR=$(realpath $(dirname "${0}")/../..)
LIB_DIR=${ROOT_DIR}/lib
TARGET_DIR=${ROOT_DIR}/target
TMP_DIR=${TARGET_DIR}/.tmp

US_AG="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:140.0) Gecko/20100101 Firefox/140.0"

SONAR_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli
SONAR_ZIP=sonar-scanner-cli-${VERSION}${OPSYS}.zip
SONAR_FOLDER=sonar-scanner-${VERSION}${OPSYS}
DL_URL=${SONAR_URL}/${SONAR_ZIP}

prepare(){
    if [ -d ${TMP_DIR} ]; then
        rm -rf ${TMP_DIR}
    fi
    mkdir -p ${TMP_DIR}
    mkdir -p ${LIB_DIR}
}

dl(){
    cd ${TMP_DIR}
    echo -e "Downloading '${DL_URL}'"
    wget --user-agent="${US_AG}" ${DL_URL}
    #touch ${SONAR_ZIP}
}

unpack(){
    if [ -f ${SONAR_ZIP} ]; then
        echo -e "Unzipping '${SONAR_ZIP}'"
        unzip ${SONAR_ZIP}
        #mkdir ${SONAR_FOLDER}
        #touch ${SONAR_FOLDER}/a.jar
    else
        echo -e "Nothing to unzip"
    fi
}

final(){
    cd ${TMP_DIR}
    if [ -d ${SONAR_FOLDER} ]; then
        mv ${SONAR_FOLDER}/* ${LIB_DIR}
    else 
        echo -e "no scanner found"
    fi
}

# main
prepare
dl
unpack
final

echo -e "Finished"