@echo off
setlocal EnableExtensions DisableDelayedExpansion

set "NUGET_API_KEY=PUT_YOUR_NUGET_API_KEY_HERE"

if "%NUGET_API_KEY%"=="PUT_YOUR_NUGET_API_KEY_HERE" (
  echo Please edit %~nx0 and replace PUT_YOUR_NUGET_API_KEY_HERE with your nuget.org API key.
  exit /b 1
)

set "CONFIGURATION=Release"

set "PROJECT_FILE=%~dp0STS2.RitsuLib.ModTemplate.csproj"

if not exist "%PROJECT_FILE%" (
  echo Project file not found: "%PROJECT_FILE%"
  exit /b 1
)

where dotnet >nul 2>nul
if errorlevel 1 (
  echo dotnet CLI was not found in PATH.
  exit /b 1
)

pushd "%~dp0" >nul
dotnet msbuild "%PROJECT_FILE%" ^
  /t:PublishTemplateToNuGet ^
  /p:Configuration="%CONFIGURATION%"
set "EXIT_CODE=%ERRORLEVEL%"
popd >nul

if not "%EXIT_CODE%"=="0" (
  echo NuGet publish failed with exit code %EXIT_CODE%.
  exit /b %EXIT_CODE%
)

echo NuGet package published successfully.
exit /b 0
