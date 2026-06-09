@ECHO OFF
setlocal DISABLEDELAYEDEXPANSION
SET BIN_TARGET=%~dp0/../lib/bin/sonar-scanner-debug.bat
"%BIN_TARGET%" %*
