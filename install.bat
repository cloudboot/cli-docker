@echo off
set "EXEC_PATH=%USERPROFILE%\.cloudboot\bin"
set "DOCKER_VOLUME=cloudboot_tmp"

REM Create docker volume for persisting gcloud CLI configurations
docker volume inspect %DOCKER_VOLUME% >nul 2>nul
if %errorlevel% neq 0 (
    echo Creating Docker volume: %DOCKER_VOLUME%..
    docker volume create %DOCKER_VOLUME%
) else (
    echo Docker volume %DOCKER_VOLUME% already exists!
)

REM Create cloudboot executable script
rmdir /s /q "%EXEC_PATH%" 2>nul
mkdir "%EXEC_PATH%"

REM Cloudboot executable script content
(
    echo @echo off
    echo if "%~1"=="" (
    echo     docker run --rm -it -v %DOCKER_VOLUME%:/home/bootstrapper/.config -v %cd%:/home/bootstrapper/app cloudboot
    echo     exit /b 0
    echo )
    echo docker run --rm -it -v %DOCKER_VOLUME%:/home/bootstrapper/.config -v %cd%:/home/bootstrapper/app cloudboot %*
) >"%EXEC_PATH%\cloudboot.bat"

echo Excellent! Please try "cloudboot" now!
