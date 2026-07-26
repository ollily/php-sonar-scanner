@ECHO OFF
setlocal DISABLEDELAYEDEXPANSION

SET BIN_TARGET=%~dp0..\..\lib\bin\sonar-scanner.bat
SET COMPOSER_RUNTIME_BIN_DIR=%~dp0

IF NOT EXIST %BIN_TARGET% (
    php -f "%~dp0composer\post-update-cmd" "."
)

call "%BIN_TARGET%" %*

endlocal

php "%BIN_TARGET%" %*