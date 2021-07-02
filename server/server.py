#-*- coding: UTF-8 -*-
import serial
from threading import Timer
from importlib import reload
import sys
import pickle
import datetime

import uvicorn as uvicorn
from fastapi import FastAPI
from rockx_face_recog import FaceDB, search_face
from rockx import RockX

import cv2
import time

# Global parameters
ENCODING = 'utf-8'
TIME_INTERVAL = 10

# Start serial
if sys.getdefaultencoding() != ENCODING:
    reload(sys)
    sys.setdefaultencoding(ENCODING)

# Start serial
port = "/dev/ttyUSB0"   # Serial
baud_rate = 9600        # Baud rate

# Temporary statistical data
available_temp = False
temperature_temp = -1
humidity_temp = -1
smoke_temp = -1
camera_using = False

statistic = {}
# Permanently statistical data
with open("statistic.bin", "rb") as f:
    statistic = pickle.load(f)

# Start Fastapi
app = FastAPI(debug=True)

def get_sensor_data():
    global temperature_temp, humidity_temp, smoke_temp, available_temp, statistic, port, baud_rate
    ser = serial.Serial(port, baud_rate, timeout=1)
    while True:
        to_send = '2'  # Data to send to Arduino
        ser.write(to_send.encode())
        sentback_string = ser.readline()  # Data sent back by Arduino 
        if (sentback_string != b"" and sentback_string[:5] == b"DATA,"):
            data_raw = sentback_string.decode()
            # Now process the data return from sensors
            data_list = data_raw.strip().split(",")
            temperature = int(data_list[1])
            humidity = int(data_list[2])
            smoke = data_list[3]
            # print(temperature, humidity, smoke)
            if temperature != 0 or humidity != 0:
                break
    temperature_temp = temperature
    humidity_temp = humidity
    available_temp = True
    if datetime.datetime.now().strftime("%Y-%m-%d") not in statistic:
        statistic[datetime.datetime.now().strftime("%Y-%m-%d")] = {}
    statistic[datetime.datetime.now().strftime("%Y-%m-%d")][datetime.datetime.now().strftime("%H:%M")] = (temperature_temp, humidity_temp)
    with open("statistic.bin", "wb") as f:
        pickle.dump(statistic, f)
    # Since the data were collected once every TIME_INTERVAL secs,
    # Now metheds for setting up next round of collection.
    timer = Timer(TIME_INTERVAL, get_sensor_data)
    timer.start()

# Routes for server
@app.get("/sensor/env")
def get_env_data():
    global temperature_temp, humidity_temp, available_temp
    if available_temp == False:
        return {
            "code" : "-1",
            "data" : {}
        }
    return {
        "code" : "0",
        "data" : {
            "temperature" : temperature_temp,
            "humidity" : humidity_temp
        }
    }

@app.get("/sensor/smoke")
def get_smoke():
    global smoke_temp, available_temp
    if available_temp == False:
        return {"smoke" : "0"}
    if smoke_temp < 100:
        return {"smoke" : "0"}
    return {"smoke" : "1"}

@app.get("/statistic/{date}")
def get_statistic(date: str):
    global statistic
    if date not in statistic:
        return []
    date_prev = ""
    date_next = ""
    temperature_list = []
    humidity_list = []
    # Get previous and next day
    date_list = list(statistic)
    if date not in statistic:
        date_prev = statistic[date_list[len(date_list)-1]]
        date_next = ""
    else:
        datepointer = date_list.index(date)
        if datepointer == 0:
            date_prev = ""
        else:
            date_prev = date_list[datepointer-1]
        if datepointer == len(date_list) - 1:
            date_next = ""
        else:
            date_next = date_list[datepointer+1]
    # Get temperature and humidity
    date_list = statistic[date]
    for time in date_list:
        temperature_list.append([date+" "+time, date_list[time][0]])
        humidity_list.append([date+" "+time, date_list[time][1]])
    return {"prev": date_prev, "next": date_next, "temperature" : temperature_list, "humidity": humidity_list}

@app.get("/verify")
def verify_face():
    global camera_using
    if camera_using:
        return {"code": 2}
    camera_using = True

    face_det_handle = RockX(RockX.ROCKX_MODULE_FACE_DETECTION)
    face_landmark5_handle = RockX(RockX.ROCKX_MODULE_FACE_LANDMARK_5)
    face_recog_handle = RockX(RockX.ROCKX_MODULE_FACE_RECOGNIZE)
    face_track_handle = RockX(RockX.ROCKX_MODULE_OBJECT_TRACK)

    face_db = FaceDB("face.db")

    # load face from database
    face_library = face_db.load_face()
    print("load %d face" % len(face_library))

    cap = cv2.VideoCapture(10)
    if cap.isOpened() == False:
        cap.open("/dev/video10")
    print(cap.isOpened())
    cap.set(3, 1280)
    cap.set(4, 720)

    feature_get = False
    time_start=time.time()
    time_cost=0
    show_str=''
    target_name=''
    while not feature_get:
        # Capture frame-by-frame
        ret, frame = cap.read()

        in_img_h, in_img_w = frame.shape[:2]
        ret, results = face_det_handle.rockx_face_detect(frame, in_img_w, in_img_h, RockX.ROCKX_PIXEL_FORMAT_BGR888)

        ret, results = face_track_handle.rockx_object_track(in_img_w, in_img_h, 3, results)

        index = 0
        for result in results:
            # face align
            ret, align_img = face_landmark5_handle.rockx_face_align(frame, in_img_w, in_img_h,
                                                                     RockX.ROCKX_PIXEL_FORMAT_BGR888,
                                                                     result.box, None)

            # get face feature
            if ret == RockX.ROCKX_RET_SUCCESS and align_img is not None:
                ret, face_feature = face_recog_handle.rockx_face_recognize(align_img)

            # search face
            if ret == RockX.ROCKX_RET_SUCCESS and face_feature is not None:
                target_name, diff, target_face = search_face(face_library, face_feature, face_recog_handle)
                print("target_name=%s diff=%s", target_name, str(diff))

            show_str = 'result id is ' + str(result.id) +', index is ' +str(index)+' time cost is '+str(time_cost)
            if target_name is not None:
                feature_get = True
            index += 1
        # Display the resulting frame
        time_end=time.time()
        time_cost = time_end-time_start
        if time_cost>15:
            break
    # When everything done, release the capture
    cap.release()
    cv2.destroyAllWindows()

    face_det_handle.release()
    camera_using = False
    if show_str != '' and target_name is not None:
        return {"code": 0}
    else:
        return {"code": 1}

def main():
    get_sensor_data()

if __name__ == "__main__":
    main()
    uvicorn.run(app=app, host="0.0.0.0", port=8000, debug=True)