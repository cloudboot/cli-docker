# Configuration
$EXEC_PATH = "$env:USERPROFILE\.cloudboot\bin"
$DOCKER_VOLUME = "cloudboot_tmp"

# Create docker volume for persisting gcloud CLI configurations
if (-not (docker volume ls -q -f "name=$DOCKER_VOLUME")) {
    Write-Host "Creating Docker volume: $DOCKER_VOLUME.."
    docker volume create $DOCKER_VOLUME
} else {
    Write-Host "Docker volume $DOCKER_VOLUME already exists!"
}

# Create cloudboot executable script
Remove-Item -Path $EXEC_PATH -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $EXEC_PATH -ItemType Directory | Out-Null

# Cloudboot executable script content
$EXEC_CONTENT = @"
@echo off
if "%~1"=="" (
    docker run --rm -it -v ${DOCKER_VOLUME}:/home/bootstrapper/.config -v "%CD%":/home/bootstrapper/app cloudboot
    exit /b 0
)
docker run --rm -it -v ${DOCKER_VOLUME}:/home/bootstrapper/.config -v "%CD%":/home/bootstrapper/app cloudboot %*
"@

# Save content to the cloudboot script
$EXEC_CONTENT | Set-Content -Path "$EXEC_PATH\cloudboot.bat"

# Get current PATH variable value
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

# Check if the directory is already in the PATH
if ($currentPath -notlike "*$EXEC_PATH*") {
    # Add the directory to the PATH
    [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$EXEC_PATH", [System.EnvironmentVariableTarget]::User)

    Write-Host "Directory added to PATH. Changes will take effect in new sessions."
} else {
    Write-Host "Directory already exists in PATH."
}

Write-Host "Excellent! Please try 'cloudboot' now!"
