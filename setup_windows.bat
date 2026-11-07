@echo off
REM FootSnap server setup for Windows. Run from the Anaconda Prompt, in the footsnap folder:
REM     setup_windows.bat
setlocal
cd /d "%~dp0"

where conda >nul 2>nul
if errorlevel 1 (
  echo Please run this from the Anaconda Prompt ^(Start menu ^> Anaconda Prompt^).
  exit /b 1
)

echo === Creating the "footsnap" conda environment ===
call conda env create -f environment.yml
if errorlevel 1 (
  echo Environment exists already - updating it instead.
  call conda env update -n footsnap -f environment.yml --prune
)
call conda activate footsnap
if errorlevel 1 exit /b 1

echo === Installing PyTorch ===
where nvidia-smi >nul 2>nul
if errorlevel 1 (
  echo No NVIDIA GPU driver found: installing the CPU version. Segmentation will be slow.
  python -m pip install torch --index-url https://download.pytorch.org/whl/cpu
) else (
  echo NVIDIA GPU found: installing PyTorch with CUDA 12.6.
  echo ^(RTX 50-series cards: rerun with https://download.pytorch.org/whl/cu128 instead.^)
  python -m pip install torch --index-url https://download.pytorch.org/whl/cu126
)
python -m pip install "transformers>=4.38,<5"

echo === Check ===
python -c "import torch; print('torch', torch.__version__, '| GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'none (CPU)')"
echo.
echo Done. Next: copy model.pt into the server folder, edit start_server.bat, then run start_server.bat
endlocal
