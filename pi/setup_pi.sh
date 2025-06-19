#!/bin/bash

# 切換到專案資料夾
cd /home/pi_cam_stream/pi

# 檢查必要文件
if [ ! -f "pi_requirements.txt" ]; then
    echo "pi_requirements.txt 文件不存在，請確認文件已放置於此目錄。"
    exit 1
fi

# 安裝必要的圖形庫
echo "正在檢查並安裝必要的圖形庫..."
sudo apt update
sudo apt install python3-pil python3-pil.imagetk -y

# 安裝 OpenCV
echo "正在安裝 OpenCV..."
sudo apt install python3-opencv -y

# 安裝 Python 套件
echo "正在安裝 Python 套件..."
pip3 install -r pi_requirements.txt
