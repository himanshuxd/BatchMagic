@echo off
setlocal enabledelayedexpansion

REM Create empty files for valid and 404 URLs
type nul > urls_valid.txt
type nul > urls_404.txt

REM Set the timeout value in seconds (adjust as needed)
set TIMEOUT=5

REM Display a message to indicate the start of the process
echo "Checking URLs in urls.txt..."

REM Iterate through all URLs in urls.txt
for /F "tokens=*" %%i in (urls.txt) do (
    REM Use curl to check the HTTP status code with a timeout
    curl -s -o nul -I --max-time %TIMEOUT% -w "%%{http_code}" "%%i" > tmp.txt
    
    REM Read the status code from tmp.txt
    set /p statusCode=<tmp.txt
    
    REM If status code is 200 (OK), append the URL to urls_valid.txt
    if !statusCode! equ 200 (
        echo Valid URL: %%i
        echo %%i >> urls_valid.txt
    ) else (
        REM If status code is 404, append the URL to urls_404.txt
        if !statusCode! equ 404 (
            echo 404 URL: %%i
            echo %%i >> urls_404.txt
        ) else (
            REM If the request timed out or any other status, skip the URL
            echo Skipped URL: %%i (Status Code: !statusCode!)
        )
    )
    
    REM Clean up temporary files
    del tmp.txt
)

REM Display a message to indicate the end of the process
echo "URLs have been checked and segregated into urls_valid.txt and urls_404.txt."
