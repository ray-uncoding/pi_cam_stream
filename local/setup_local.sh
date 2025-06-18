#!/bin/bash

# 切換到專案資料夾
cd /home/pi/pi_cam_stream/local

# 安裝 Python 套件
echo "Installing Python packages..."
pip3 install -r local_requirements.txt

# 啟動 local_stream.py
echo "Starting local_stream.py..."
python3 local_stream.py
