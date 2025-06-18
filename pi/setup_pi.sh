#!/bin/bash

# 切換到專案資料夾
cd /home/pi/pi_cam_stream

# 更新系統
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# 安裝 Python
echo "Installing Python and pip..."
sudo apt install python3 python3-pip -y

# 安裝必要的系統套件
echo "Installing system dependencies..."
sudo apt install libopencv-dev python3-opencv -y

# 安裝 Python 套件
echo "Installing Python packages..."
pip3 install -r pi_requirements.txt

# 完成
echo "Setup complete! You can now run 'python3 pi_stream.py' to start the application."
