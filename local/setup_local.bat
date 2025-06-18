@echo off
chcp 65001
REM 切換到專案資料夾
cd D:\02_workSpace\03_GitHub\pi_cam_stream\local

REM 檢查必要文件
if not exist "local_requirements.txt" (
    echo local_requirements.txt 文件不存在，請確認文件已放置於此目錄。
    pause
    exit /b
)

REM 安裝 Python 套件
echo 正在安裝 Python 套件...
pip3 install -r local_requirements.txt

REM 啟動 local_stream.py
echo 正在啟動 local_stream.py...
python3 local_stream.py
pause
