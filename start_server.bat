@echo off
REM Starts the FootSnap server. Run from the Anaconda Prompt:  start_server.bat
setlocal
cd /d "%~dp0server"

call conda activate footsnap
if errorlevel 1 (
  echo Run setup_windows.bat first, from the Anaconda Prompt.
  exit /b 1
)

REM ------------------------------------------------------------------------------
REM  Edit these for your computer. Windows paths are fine; no quotes inside the value.
REM ------------------------------------------------------------------------------
if not defined PROJECT set "PROJECT=C:\Research\0003-Depth_Segmentation"
REM  Marigold in its own conda environment (recommended):
REM set "MARIGOLD_PYTHON=%USERPROFILE%\anaconda3\envs\marigold\python.exe"
REM  Several folders of saved Marigold maps are separated with ; on Windows:
REM set "MARIGOLD_MAPS=%PROJECT%\marigold\maps\test;%PROJECT%\marigold\maps\train"
REM  Ask phones for an access code:
REM set "ACCESS_TOKEN=choose-a-code"
REM set "PORT=8000"
REM ------------------------------------------------------------------------------

if not exist model.pt if not defined MODEL_PATH (
  echo model.pt is missing: copy runs\segformer_curvature_seed0\model.pt into %CD%
  exit /b 1
)

echo.
echo Enter one of these addresses in the FootSnap iPhone app ^(add :8000^):
ipconfig | findstr /i /c:"IPv4"
echo.
python server.py
endlocal
