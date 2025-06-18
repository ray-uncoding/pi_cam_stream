@echo off
chcp 65001
REM 切換到專案資料夾
cd /home/pi/pi_cam_stream

REM 檢查必要文件
if not exist "setup_pi.sh" (
    echo setup_pi.sh 文件不存在，請確認文件已放置於此目錄。
    pause
    exit /b
)

if not exist "pi_requirements.txt" (
    echo pi_requirements.txt 文件不存在，請確認文件已放置於此目錄。
    pause
    exit /b
)

REM 執行 setup_pi.sh
echo 正在執行 setup_pi.sh...
bash setup_pi.sh

REM 啟動 pi_stream.py
echo 正在啟動 pi_stream.py...
python3 pi_stream.py
pause
