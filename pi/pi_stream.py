from flask import Flask, Response
from picamera2 import Picamera2
import cv2
import socket
import qrcode
from PIL import Image
import os
import subprocess

app = Flask(__name__)

def release_camera():
    try:
        result = subprocess.run(['lsof', '/dev/video0'], capture_output=True, text=True)
        if result.stdout:
            for line in result.stdout.splitlines():
                if '/dev/video0' in line:
                    pid = line.split()[1]  # 提取進程 ID
                    os.system(f'sudo kill -9 {pid}')
                    print(f"釋放相機資源，已終止進程 {pid}")
        else:
            print("相機資源未被佔用，準備啟用相機。")
    except Exception as e:
        print(f"檢查相機資源時出錯: {e}")

release_camera()

# 初始化 Picamera2（使用 CSI 攝影機）
picam2 = Picamera2()
picam2.configure(picam2.create_video_configuration(main={"size": (640, 480)}))
picam2.start()

# 串流影像
def generate_frames():
    while True:
        # 修改影像處理邏輯，解決顏色問題
        frame = picam2.capture_array()
        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        frame_rgb = cv2.rotate(frame_rgb, cv2.ROTATE_180)
        ret, buffer = cv2.imencode('.jpg', frame_rgb)
        if not ret:
            print("影像編碼失敗，跳過該幀。")
            continue
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + buffer.tobytes() + b'\r\n')

@app.route('/')
def index():
    return "<h1>CSI Camera Streaming</h1><img src='/video'>"

@app.route('/video')
def video():
    return Response(generate_frames(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception as e:
        return "127.0.0.1"  # fallback to localhost

# 生成 QR Code 並顯示
local_ip = get_local_ip()
stream_url = f"http://{local_ip}:5000"
qr = qrcode.QRCode()
qr.add_data(stream_url)
qr.make(fit=True)
img = qr.make_image(fill_color="black", back_color="white")
img.show()

print(f"Stream URL: {stream_url}")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
