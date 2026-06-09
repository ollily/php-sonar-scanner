@ECHO OFF
setlocal DISABLEDELAYEDEXPANSION
SET BIN_TARGET=%~dp0/../ollily/php-sonar-scanner/bin/sonar-scanner-debug
SET COMPOSER_RUNTIME_BIN_DIR=%~dp0
sh "%BIN_TARGET%" %*
