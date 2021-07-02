import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import './utils.dart' as utils;
import 'dart:math' as math;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class XDmonitorpage extends StatefulWidget {
  XDmonitorpage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MonitorpageState();
  }
}

class _MonitorpageState extends State<XDmonitorpage> {
  // Reload data once per 10 seconds.
  // ignore: unused_field
  late Timer _reloadTimer;
  int _temperature = -300;
  int _humidity = -1;
  String _smoking = "0";
  String _smokingStateSvg = _svg_bd49d5;
  String _temperatureText = "加载中";
  String _humidityText = "加载中";

  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
     = FlutterLocalNotificationsPlugin();
  bool _envNotification = false;
  bool _smokeNotification = false;
  // The following state just for debugging.
  // int _count = 0;

  void fetchEnvData() async {
    try {
      final client = http.Client();
      // Get smoking info
      var response = await client.get(Uri.parse('http://${utils.rkIp}:8000/sensor/smoke'));
      Map<String, dynamic> parsed = json.decode(response.body);
      _smoking = parsed["smoke"];
      // Get temperature and humidity
      response = await client.get(Uri.parse('http://${utils.rkIp}:8000/sensor/env'));
      parsed = json.decode(response.body);
      if (_smoking == "0") {
        _smokeNotification = false;
      }
      if (_smoking != "0" && _smokeNotification == false) {
        _smokeNotification = true;
        showNotification("检测到有烟雾！请检查医疗场所情况！");
      }
      if (parsed["code"] == "0") {
        // Successfully get data
        setState(() {
          _temperature = parsed["data"]["temperature"];
          _humidity = parsed["data"]["humidity"];
          _temperatureText = "$_temperature℃";
          _humidityText = "$_humidity%";
          if (_temperature >= 10 && _temperature <= 30  && _humidity >= 35 && _humidity <= 75) {
            _envNotification = false;
          }
          if (!(_temperature >= 10 && _temperature <= 30  && _humidity >= 35 && _humidity <= 75) && _envNotification == false) {
            _envNotification = true;
            showNotification("检测到室内环境与要求不符！请及时打开环境调整设备！");
          }
          if (_smoking == "0") {
            _smokingStateSvg = _svg_ou3q9r;
          } else {
            _smokingStateSvg = _svg_g5imij;
          }
        });
      } else {
        // Failed to get data
        Fluttertoast.showToast(
          msg: "获取数据失败！请检查监测设备！",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
        );
        setState(() {
          if (_smoking == "0") {
            _smokingStateSvg = "_svg_ou3q9r";
          } else {
            _smokingStateSvg = "_svg_g5imij";
          }
        });
      }
      //_count += 1;
    }
    catch (e){
      Fluttertoast.showToast(
        msg: "获取数据失败！请检查网络连接和服务器！",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }

  void showNotification(String text) async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Smart Pharmacy 警告', text, platformChannelSpecifics,
        payload: text);
  }
 
  Future onSelectNotification(String? payload) async {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize the notification system.
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    // Now, get data from RK3399proD.
    fetchEnvData();
    // Set timer to get data once per 10 seconds.
    _reloadTimer = Timer.periodic(
      Duration(seconds: 10),
      (timer) {
        setState(() {
          fetchEnvData();
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbed1e2),
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(start: 32.9, end: 18.9),
            Pin(size: 538.0, middle: 0.5),
            child: Stack(
              // Adobe XD layer: '中部' (group)
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(size: 168.8, middle: 0.4469),
                  child: Stack(
                    // Adobe XD layer: '湿度' (group)
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 0.0, end: 10.2),
                        Pin(start: 9.9, end: 9.9),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: const Color(0xfff7f7f9),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 176.9, end: 0.0),
                        Pin(size: 168.8, middle: 0.5),
                        child: Stack(
                          // Adobe XD layer: '湿度仪表' (group)
                          children: <Widget>[
                            Pinned.fromPins(
                              Pin(size: 127.3, start: 21.1),
                              Pin(size: 64.6, start: 21.7),
                              child: SvgPicture.string(
                                // Adobe XD layer: '底部灰色弧线' (shape)
                                _svg_gpmfd5,
                                allowDrawingOutsideViewBox: true,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(start: 0.0, end: 8.1),
                              Pin(start: 0.0, end: 0.0),
                              child: Stack(
                                children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 17.4, end: 17.4),
                                    Pin(start: 17.4, end: 17.4),
                                    child: Transform.rotate(
                                      angle: math.min(math.max(_humidity/100, 0), 1) * 3.1416 - 1.5708,
                                      child: Stack(
                                        // Adobe XD layer: '湿度指针' (group)
                                        children: <Widget>[
                                          Pinned.fromPins(
                                            Pin(start: 0.0, end: 0.0),
                                            Pin(start: 0.0, end: 0.0),
                                            child: Stack(
                                              // Adobe XD layer: '边缘指针' (group)
                                              children: <Widget>[
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(start: 0.0, end: 0.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.elliptical(
                                                                  9999.0,
                                                                  9999.0)),
                                                      color: const Color(
                                                          0x00ffffff),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(
                                                      size: 131.1,
                                                      start: -28.0),
                                                  Pin(start: 31.8, end: 34.7),
                                                  child: Transform.rotate(
                                                    angle: -1.5708,
                                                    child: Stack(
                                                      // Adobe XD layer: '弧线+圆' (group)
                                                      children: <Widget>[
                                                        Pinned.fromPins(
                                                          Pin(
                                                              start: 0.0,
                                                              end: 2.8),
                                                          Pin(
                                                              start: 0.0,
                                                              end: 2.8),
                                                          child: SvgPicture.string(
                                                            // Adobe XD layer: '弧线' (shape)
                                                            _humidity >=35 && _humidity <= 75 ? _svg_lbk6ja : _svg_fwau98,
                                                            allowDrawingOutsideViewBox:
                                                                true,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        Pinned.fromPins(
                                                          Pin(
                                                              size: 7.6,
                                                              end: 0.0),
                                                          Pin(
                                                              size: 7.6,
                                                              end: 0.0),
                                                          child: Container(
                                                            // Adobe XD layer: '弧线一端的小圆' (shape)
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .elliptical(
                                                                          9999.0,
                                                                          9999.0)),
                                                              color: const Color(
                                                                  0xffffffff),
                                                              border: Border.all(
                                                                  width: 1.0,
                                                                  color: _humidity >=35 && _humidity <= 75 ? const Color(0xff4fe2ba) : const Color(0xffff7a7a),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(start: 14.7, end: 14.7),
                                            Pin(start: 14.7, end: 14.7),
                                            child: Stack(
                                              // Adobe XD layer: '中间指针' (group)
                                              children: <Widget>[
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(start: 0.0, end: 0.0),
                                                  child: Transform.rotate(
                                                    angle: 1.5708 - math.min(math.max(_humidity/100, 0), 1) * 3.1416,
                                                    child: SvgPicture.string(
                                                      _svg_fb028c,
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(size: 14.3, middle: 0.5),
                                                  Pin(size: 14.7, start: 3.2),
                                                  child: SvgPicture.string(
                                                    _svg_6ugjq2,
                                                    allowDrawingOutsideViewBox:
                                                        true,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 16.1, end: 16.0),
                                    Pin(size: 69.3, end: 14.1),
                                    child: SvgPicture.string(
                                      _svg_tovpma,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 60.8, middle: 0.5),
                                    Pin(size: 60.8, middle: 0.508),
                                    child: Stack(
                                      children: <Widget>[
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 0.0),
                                          Pin(start: 0.0, end: 0.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.elliptical(
                                                      9999.0, 9999.0)),
                                              color: const Color(0xffffffff),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0x29000000),
                                                  offset: Offset(0, 1),
                                                  blurRadius: 3,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(
                                              startFraction: 0.0477,
                                              endFraction: 0.0477),
                                          Pin(start: 18.4, end: 18.4),
                                          child: Text(
                                            _humidityText,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 18,
                                              color: const Color(0xff3d67a1),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(size: 27.0, start: 13.3),
                              Pin(size: 16.0, middle: 0.5524),
                              child: Text(
                                '0%    ',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  color: const Color(0xff8d8d8d),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(size: 41.0, end: 0.0),
                              Pin(size: 16.0, middle: 0.5524),
                              child: Text(
                                '100%    ',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  color: const Color(0xff8d8d8d),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 90.0, start: 26.0),
                        Pin(size: 65.0, middle: 0.5),
                        child: Stack(
                          // Adobe XD layer: '湿度文字' (group)
                          children: <Widget>[
                            Pinned.fromPins(
                              Pin(start: 0.0, end: 0.0),
                              Pin(size: 46.0, start: 0.0),
                              child: Text(
                                '湿度',
                                style: TextStyle(
                                  fontFamily: 'Microsoft YaHei',
                                  fontSize: 35,
                                  color: const Color(0xff7ea6d9),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(start: 0.0, end: 1.0),
                              Pin(size: 24.0, end: 0.0),
                              child: Text(
                                'humidity',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  color: const Color(0xff8d8d8d),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Pinned.fromPins(
                  Pin(start: 0.0, end: 5.0),
                  Pin(size: 175.0, start: 0.0),
                  child: Stack(
                    // Adobe XD layer: '温度' (group)
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 0.0, end: 5.2),
                        Pin(start: 13.0, end: 13.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: const Color(0xfff7f7f9),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 175.0, end: 0.0),
                        Pin(size: 175.0, middle: 0.5),
                        child: Stack(
                          // Adobe XD layer: '温度仪表' (group)
                          children: <Widget>[
                            Pinned.fromPins(
                              Pin(start: 24.4, end: 22.4),
                              Pin(size: 63.6, start: 24.8),
                              child: SvgPicture.string(
                                // Adobe XD layer: '底部灰色弧线' (shape)
                                _svg_gpmfd5,
                                allowDrawingOutsideViewBox: true,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(start: 0.0, end: 0.0),
                              Pin(start: 0.0, end: 0.0),
                              child: Stack(
                                children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 20.5, end: 20.5),
                                    Pin(start: 20.5, end: 20.5),
                                    child: Transform.rotate(
                                      angle: math.min(math.max(_temperature/40.0, 0), 1) * 3.1416 - 1.5708,
                                      child: Stack(
                                        // Adobe XD layer: '温度指针' (group)
                                        children: <Widget>[
                                          Pinned.fromPins(
                                            Pin(start: 0.0, end: 0.0),
                                            Pin(start: 0.0, end: 0.0),
                                            child: Stack(
                                              // Adobe XD layer: '边缘指针' (group)
                                              children: <Widget>[
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(start: 0.0, end: 0.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.elliptical(
                                                                  9999.0,
                                                                  9999.0)),
                                                      color: const Color(
                                                          0x00ffffff),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(
                                                      size: 131.1,
                                                      start: -28.0),
                                                  Pin(start: 31.8, end: 34.7),
                                                  child: Transform.rotate(
                                                    angle: -1.5708,
                                                    child:
                                                        // Adobe XD layer: '弧线+圆' (group)
                                                        Stack(
                                                      children: <Widget>[
                                                        Pinned.fromPins(
                                                          Pin(
                                                              start: 0.0,
                                                              end: 2.8),
                                                          Pin(
                                                              start: 0.0,
                                                              end: 2.8),
                                                          child:
                                                              // Adobe XD layer: '弧线' (shape)
                                                              SvgPicture.string(
                                                            _temperature >=10 && _temperature <= 30 ? _svg_lbk6ja : _svg_fwau98,
                                                            allowDrawingOutsideViewBox:
                                                                true,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        Pinned.fromPins(
                                                          Pin(
                                                              size: 7.6,
                                                              end: 0.0),
                                                          Pin(
                                                              size: 7.6,
                                                              end: 0.0),
                                                          child:
                                                              // Adobe XD layer: '小圆' (shape)
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .elliptical(
                                                                          9999.0,
                                                                          9999.0)),
                                                              color: const Color(
                                                                  0xffffffff),
                                                              border: Border.all(
                                                                width: 1.0,
                                                                color: _temperature >=10 && _temperature <= 30 ? const Color(0xff4fe2ba) : const Color(0xffff7a7a)
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(start: 14.7, end: 14.7),
                                            Pin(start: 14.7, end: 14.7),
                                            child:
                                                // Adobe XD layer: '中间指针' (group)
                                                Stack(
                                              children: <Widget>[
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(start: 0.0, end: 0.0),
                                                  child: Transform.rotate(
                                                    angle: 1.5708 - math.min(math.max(_temperature/40.0, 0), 1) * 3.1416,
                                                    child: SvgPicture.string(
                                                      _svg_edb884,
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(size: 14.3, middle: 0.5),
                                                  Pin(size: 14.7, start: 3.2),
                                                  child: SvgPicture.string(
                                                    _svg_6ugjq2,
                                                    allowDrawingOutsideViewBox:
                                                        true,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 19.1, end: 19.1),
                                    Pin(size: 69.3, end: 17.2),
                                    child: SvgPicture.string(
                                      _svg_6l6abo,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 62.8, middle: 0.5),
                                    Pin(size: 62.8, middle: 0.508),
                                    child: Stack(
                                      children: <Widget>[
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 0.0),
                                          Pin(start: 0.0, end: 0.0),
                                          child: Stack(
                                            children: <Widget>[
                                              Pinned.fromPins(
                                                Pin(start: 0.0, end: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.elliptical(
                                                                9999.0,
                                                                9999.0)),
                                                    color:
                                                        const Color(0xffffffff),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(
                                                            0x29000000),
                                                        offset: Offset(0, 1),
                                                        blurRadius: 3,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(
                                                    startFraction: 0.0477,
                                                    endFraction: 0.0477),
                                                Pin(start: 18.4, end: 18.4),
                                                child: Text(
                                                  _temperatureText,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 18,
                                                    color: const Color(0xff3d67a1),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(size: 29.0, start: 16.4),
                              Pin(size: 16.0, middle: 0.5503),
                              child: Text(
                                '0℃    ',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  color: const Color(0xff8d8d8d),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(size: 36.0, end: 0.0),
                              Pin(size: 16.0, middle: 0.5503),
                              child: Text(
                                '40℃    ',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  color: const Color(0xff8d8d8d),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 135.0, start: 24.1),
                        Pin(size: 65.0, middle: 0.5),
                        child:
                            // Adobe XD layer: '温度文字' (group)
                            Stack(
                          children: <Widget>[
                            Pinned.fromPins(
                              Pin(start: 0.0, end: 0.0),
                              Pin(size: 46.0, start: 0.0),
                              child: Text(
                                '温度    ',
                                style: TextStyle(
                                  fontFamily: 'Microsoft YaHei',
                                  fontSize: 35,
                                  color: const Color(0xff7ea6d9),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(start: 0.0, end: 13.0),
                              Pin(size: 24.0, end: 0.0),
                              child: Text(
                                'temperature',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  color: const Color(0xff8d8d8d),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Pinned.fromPins(
                  Pin(start: 0.0, end: 10.2),
                  Pin(size: 92.0, middle: 0.7578),
                  child:
                      // Adobe XD layer: '烟雾' (group)
                      Stack(
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 0.0, end: 0.0),
                        Pin(start: 0.0, end: 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: const Color(0xfff7f7f9),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 70.0, start: 26.0),
                        Pin(size: 65.0, end: 13.0),
                        child:
                            // Adobe XD layer: '文字' (group)
                            Stack(
                          children: <Widget>[
                            Pinned.fromPins(
                              Pin(start: 0.0, end: 0.0),
                              Pin(size: 46.0, start: 0.0),
                              child: Text(
                                '烟雾',
                                style: TextStyle(
                                  fontFamily: 'Microsoft YaHei',
                                  fontSize: 35,
                                  color: const Color(0xff7ea6d9),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(size: 54.0, start: 0.0),
                              Pin(size: 24.0, end: 0.0),
                              child: Text(
                                'smoke',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  color: const Color(0xff8d8d8d),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 50.0, end: 44.9),
                        Pin(size: 50.0, middle: 0.5),
                        child:
                            // Adobe XD layer: 'ic_check_circle_24px' (shape)
                            SvgPicture.string(
                          _smokingStateSvg,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
                /*
                Pinned.fromPins(
                  Pin(start: 0.0, end: 10.2),
                  Pin(size: 92.0, end: 0.0),
                  child:
                      // Adobe XD layer: '二氧化碳' (group)
                      Stack(
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 0.0, end: 0.0),
                        Pin(start: 0.0, end: 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: const Color(0xfff7f7f9),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 120.0, start: 26.0),
                        Pin(size: 60.0, middle: 0.5),
                        child:
                            // Adobe XD layer: '文字' (group)
                            Stack(
                          children: <Widget>[
                            Pinned.fromPins(
                              Pin(start: 0.0, end: 0.0),
                              Pin(size: 40.0, start: 0.0),
                              child: Text(
                                '二氧化碳',
                                style: TextStyle(
                                  fontFamily: 'Microsoft YaHei',
                                  fontSize: 30,
                                  color: const Color(0xff7ea6d9),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(start: 0.0, end: 2.0),
                              Pin(size: 24.0, end: 0.0),
                              child: Text(
                                'carbon dioxide',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  color: const Color(0xff8d8d8d),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 57.9, end: 44.9),
                        Pin(size: 50.0, middle: 0.381),
                        child:
                            // Adobe XD layer: 'ic_warning_24px' (shape)
                            SvgPicture.string(
                          _svg_g5imij,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),*/
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(start: 0.0, end: 0.0),
            Pin(size: 110.0, start: 0.0),
            child:
                // Adobe XD layer: '顶部' (group)
                Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(start: 0.0, end: 0.0),
                  child:
                      // Adobe XD layer: '顶部' (shape)
                      Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffbed1e2),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 165.0, middle: 0.5019),
                  Pin(size: 45.0, end: 8.0),
                  child:
                      // Adobe XD layer: '文字' (group)
                      Stack(
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 16.0, end: 16.0),
                        Pin(start: 0.0, end: 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34.0),
                            color: const Color(0xff2a4f83),
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(start: 0.0, end: 0.0),
                        Pin(size: 29.0, middle: 0.5),
                        child: Text(
                          '    实时监测    ',
                          style: TextStyle(
                            fontFamily: 'Microsoft YaHei',
                            fontSize: 22,
                            color: const Color(0xffffffff),
                            letterSpacing: 2.2,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              )
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_lbk6ja =
    '<svg viewBox="0.0 0.0 128.2 64.6" ><path transform="translate(0.0, 0.0)" d="M 1.901509046554565 64.59529113769531 L 1.900562167167664 64.59529113769531 L 0.001775813056156039 64.59435272216797 L 0.0004422258352860808 64.40492248535156 C 0.0002280227054143324 64.31011962890625 2.077417786312626e-17 64.21514129638672 1.576432528238042e-30 64.11985015869141 C -1.887118679231485e-15 55.46454620361328 1.695058345794678 47.06717681884766 5.038112640380859 39.16099166870117 C 8.26813793182373 31.52535820007324 12.89138793945312 24.66830062866211 18.77942657470703 18.7802791595459 C 24.66855812072754 12.89114761352539 31.52589416503906 8.267901420593262 39.16099166870117 5.038969039916992 C 47.06562805175781 1.69534707069397 55.46300888061523 -6.095893680514806e-15 64.11985015869141 -7.639415562274952e-15 C 72.776123046875 -9.182845964476796e-15 81.17323303222656 1.69534707069397 89.07787322998047 5.038969039916992 C 96.71294403076172 8.267917633056641 103.5703201293945 12.89116191864014 109.4594345092773 18.7802791595459 C 115.3475189208984 24.66835021972656 119.9707565307617 31.52541732788086 123.2007522583008 39.16099166870117 C 126.5443878173828 47.0665283203125 128.2397155761719 55.46391296386719 128.2397155761719 64.11985015869141 C 128.2397155761719 64.27803802490234 128.2390899658203 64.43541717529297 128.2379150390625 64.59339904785156 L 126.3373489379883 64.59435272216797 C 126.3383026123047 64.45317840576172 126.3392105102539 64.30271148681641 126.3392105102539 64.11985015869141 C 126.3392105102539 29.81151962280273 98.42771911621094 1.89966082572937 64.11985015869141 1.89966082572937 C 29.8115234375 1.89966082572937 1.899663925170898 29.81151962280273 1.899663925170898 64.11985015869141 C 1.899663925170898 64.27899932861328 1.900306582450867 64.43547821044922 1.901509046554565 64.59435272216797 L 1.901509046554565 64.59529113769531 Z" fill="#4fe2ba" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_6ugjq2 =
    '<svg viewBox="45.1 3.2 14.3 14.7" ><path transform="matrix(1.0, 0.0, 0.0, 1.0, 45.01, 3.2)" d="M 5.296500205993652 12.80790042877197 C 5.296500205993652 11.72070026397705 6.164100170135498 10.83870029449463 7.23330020904541 10.83870029449463 C 8.302499771118164 10.83870029449463 9.170100212097168 11.72070026397705 9.170100212097168 12.80790042877197 C 9.170100212097168 13.89599990844727 8.302499771118164 14.77710056304932 7.23330020904541 14.77710056304932 C 6.164100170135498 14.77710056304932 5.296500205993652 13.89599990844727 5.296500205993652 12.80790042877197 Z M 1.080000042915344 9.361800193786621 C 0.2304000109434128 9.361800193786621 -0.2322000116109848 8.369100570678711 0.3140999972820282 7.718400001525879 L 6.467400074005127 0.3950999975204468 C 6.867000102996826 -0.08100000023841858 7.599600315093994 -0.08100000023841858 7.999200344085693 0.3950999975204468 L 14.15250015258789 7.718400001525879 C 14.6988000869751 8.369100570678711 14.23710060119629 9.361800193786621 13.38660049438477 9.361800193786621 L 1.080000042915344 9.361800193786621 Z" fill="#3d67a1" stroke="none" stroke-width="1" stroke-linecap="butt" stroke-linejoin="round" /></svg>';
const String _svg_tovpma =
    '<svg viewBox="19.1 88.4 136.8 69.3" ><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 155.89, 157.76)" d="M 12.350661277771 69.34528350830078 L 12.34971714019775 69.34528350830078 L 0.006474463269114494 69.34433746337891 C 0.001810361980460584 68.98960876464844 0 68.67922973632812 0 68.39451599121094 C 0 59.16141128540039 1.808102607727051 50.20426559448242 5.374100685119629 41.77194213867188 C 8.820009231567383 33.62661361694336 13.7515926361084 26.31219863891602 20.03190422058105 20.03188896179199 C 26.31333541870117 13.75045871734619 33.62775039672852 8.819146156311035 41.77194213867188 5.374945640563965 C 50.20356750488281 1.808398008346558 59.16069412231445 0 68.39450836181641 0 C 77.62773895263672 0 86.58457183837891 1.808398008346558 95.01620483398438 5.374945640563965 C 103.1610946655273 8.819816589355469 110.4755020141602 13.7511157989502 116.7562637329102 20.03188896179199 C 123.0365829467773 26.31219863891602 127.9681701660156 33.62661361694336 131.4140625 41.77194213867188 C 134.9806518554688 50.20562744140625 136.7890167236328 59.16275787353516 136.7890167236328 68.39451599121094 C 136.7890167236328 68.70587158203125 136.7868499755859 69.02510833740234 136.7825775146484 69.34341430664062 L 125.387321472168 69.34433746337891 C 125.3883590698242 69.203125 125.3893814086914 69.04794311523438 125.3893814086914 68.8690185546875 C 125.3893814086914 37.70358276367188 100.0344314575195 12.34864711761475 68.86899566650391 12.34864711761475 C 37.70356369018555 12.34864711761475 12.34863090515137 37.70358276367188 12.34863090515137 68.8690185546875 C 12.34863090515137 69.02686309814453 12.34937000274658 69.186767578125 12.350661277771 69.34433746337891 L 12.350661277771 69.34528350830078 Z" fill="#f7f7f9" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_gpmfd5 =
    '<svg viewBox="24.2 23.8 126.3 63.6" ><path transform="translate(24.22, 23.77)" d="M 0.9375602602958679 63.6383056640625 L 0.9366273880004883 63.6383056640625 L 0.001748174196109176 63.63739776611328 L 0.0004422258352860808 63.45078277587891 C 0.0002280227054143324 63.35737228393555 0 63.26379776000977 0 63.16992568969727 C 0 54.64284515380859 1.669955372810364 46.369873046875 4.963479995727539 38.58082580566406 C 8.145647048950195 31.05831718444824 12.70040798187256 24.30284690856934 18.50121307373047 18.50205039978027 C 24.3030948638916 12.70016860961914 31.05884552001953 8.145412445068359 38.58082580566406 4.964316368103027 C 46.36835479736328 1.670229911804199 54.64133453369141 0 63.16991806030273 0 C 71.69795227050781 0 79.97067260742188 1.670229911804199 87.7581787109375 4.964316368103027 C 95.28016662597656 8.145427703857422 102.0359344482422 12.70018291473389 107.8377990722656 18.50205039978027 C 113.6386260986328 24.30289459228516 118.1934051513672 31.05837631225586 121.3755416870117 38.58082580566406 C 124.6696395874023 46.36923599243164 126.3398513793945 54.6422233581543 126.3398513793945 63.16992568969727 C 126.3398513793945 63.32575607299805 126.3392562866211 63.48079681396484 126.3381195068359 63.63644409179688 L 125.4014511108398 63.63739776611328 C 125.4023666381836 63.49950790405273 125.4032592773438 63.34690093994141 125.4032592773438 63.16992568969727 C 125.4032592773438 28.85388565063477 97.48552703857422 0.9357602596282959 63.16991806030273 0.9357602596282959 C 28.85388565063477 0.9357602596282959 0.9357568025588989 28.85388565063477 0.9357568025588989 63.16992568969727 C 0.9357568025588989 63.32491683959961 0.9364407658576965 63.48266220092773 0.9375602602958679 63.63739776611328 L 0.9375602602958679 63.6383056640625 Z" fill="#8d8d8d" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_fwau98 =
    '<svg viewBox="0.0 0.0 128.2 64.6" ><path transform="translate(0.0, 0.0)" d="M 1.901509046554565 64.59529113769531 L 1.900562167167664 64.59529113769531 L 0.001775813056156039 64.59435272216797 L 0.0004422258352860808 64.40492248535156 C 0.0002280227054143324 64.31011962890625 2.077417786312626e-17 64.21514129638672 1.576432528238042e-30 64.11985015869141 C -1.887118679231485e-15 55.46454620361328 1.695058345794678 47.06717681884766 5.038112640380859 39.16099166870117 C 8.26813793182373 31.52535820007324 12.89138793945312 24.66830062866211 18.77942657470703 18.7802791595459 C 24.66855812072754 12.89114761352539 31.52589416503906 8.267901420593262 39.16099166870117 5.038969039916992 C 47.06562805175781 1.69534707069397 55.46300888061523 -6.095893680514806e-15 64.11985015869141 -7.639415562274952e-15 C 72.776123046875 -9.182845964476796e-15 81.17323303222656 1.69534707069397 89.07787322998047 5.038969039916992 C 96.71294403076172 8.267917633056641 103.5703201293945 12.89116191864014 109.4594345092773 18.7802791595459 C 115.3475189208984 24.66835021972656 119.9707565307617 31.52541732788086 123.2007522583008 39.16099166870117 C 126.5443878173828 47.0665283203125 128.2397155761719 55.46391296386719 128.2397155761719 64.11985015869141 C 128.2397155761719 64.27803802490234 128.2390899658203 64.43541717529297 128.2379150390625 64.59339904785156 L 126.3373489379883 64.59435272216797 C 126.3383026123047 64.45317840576172 126.3392105102539 64.30271148681641 126.3392105102539 64.11985015869141 C 126.3392105102539 29.81151962280273 98.42771911621094 1.89966082572937 64.11985015869141 1.89966082572937 C 29.8115234375 1.89966082572937 1.899663925170898 29.81151962280273 1.899663925170898 64.11985015869141 C 1.899663925170898 64.27899932861328 1.900306582450867 64.43547821044922 1.901509046554565 64.59435272216797 L 1.901509046554565 64.59529113769531 Z" fill="#ff7a7a" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_6l6abo =
    '<svg viewBox="19.1 88.4 136.8 69.3" ><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 155.89, 157.76)" d="M 12.35003280639648 69.34510040283203 L 12.34903335571289 69.34510040283203 L 0.006466446910053492 69.34410095214844 C 0.001783113577403128 68.98809814453125 -2.19726558725597e-07 68.67784881591797 -2.19726558725597e-07 68.39459991455078 C -2.19726558725597e-07 59.16046524047852 1.80834972858429 50.20321655273438 5.374799728393555 41.77170181274414 C 8.819399833679199 33.62686538696289 13.75086688995361 26.3126335144043 20.03219985961914 20.03219985961914 C 26.31418228149414 13.75023365020752 33.62839889526367 8.818766593933105 41.77169799804688 5.374800205230713 C 50.20321655273438 1.808350205421448 59.16014862060547 2.014160145336064e-07 68.39369964599609 2.014160145336064e-07 C 77.62815093994141 2.014160145336064e-07 86.5850830078125 1.808350205421448 95.01570129394531 5.374800205230713 C 103.1593856811523 8.818533897399902 110.4739151000977 13.75 116.756103515625 20.03219985961914 C 123.0380630493164 26.31418418884277 127.9695358276367 33.62839889526367 131.4134979248047 41.77170181274414 C 134.9799499511719 50.20318222045898 136.7882995605469 59.16043472290039 136.7882995605469 68.39459991455078 C 136.7882995605469 68.70548248291016 136.7861328125 69.02462005615234 136.7818450927734 69.34311676025391 L 125.3868637084961 69.34410095214844 C 125.3879013061523 69.20413208007812 125.3889007568359 69.04901885986328 125.3889007568359 68.868896484375 C 125.3889007568359 37.70316696166992 100.0341339111328 12.34800052642822 68.868896484375 12.34800052642822 C 37.70316696166992 12.34800052642822 12.34799957275391 37.70316696166992 12.34799957275391 68.868896484375 C 12.34799957275391 69.02678680419922 12.34873294830322 69.18651580810547 12.35003280639648 69.34410095214844 L 12.35003280639648 69.34510040283203 Z" fill="#f7f7f9" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ou3q9r =
    '<svg viewBox="302.1 536.0 50.0 50.0" ><path transform="translate(300.1, 534.0)" d="M 27.00000381469727 2 C 13.19999885559082 2 2 13.19999885559082 2 27.00000381469727 C 2 40.80000305175781 13.19999885559082 52 27.00000381469727 52 C 40.80000305175781 52 52 40.80000305175781 52 27.00000381469727 C 52 13.19999885559082 40.80000305175781 2 27.00000381469727 2 Z M 22 39.50000381469727 L 9.5 27.00000381469727 L 13.02499961853027 23.47499847412109 L 22 32.42499923706055 L 40.97499847412109 13.45000076293945 L 44.5 17 L 22 39.50000381469727 Z" fill="#3caf90" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_g5imij =
    '<svg viewBox="294.2 531.0 57.9 50.0" ><path transform="translate(293.21, 529.0)" d="M 1.00000011920929 52 L 58.89473724365234 52 L 29.94736671447754 2.000000238418579 L 1.00000011920929 52 Z M 32.57894515991211 44.10526275634766 L 27.31578826904297 44.10526275634766 L 27.31578826904297 38.84210586547852 L 32.57894515991211 38.84210586547852 L 32.57894515991211 44.10526275634766 Z M 32.57894515991211 33.57894515991211 L 27.31578826904297 33.57894515991211 L 27.31578826904297 23.05263137817383 L 32.57894515991211 23.05263137817383 L 32.57894515991211 33.57894515991211 Z" fill="#ff7a7a" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_bd49d5 = 
    '<svg xmlns="http://www.w3.org/2000/svg" width="21" height="18" viewBox="0 0 21 18"><path id="ic_settings_backup_restore_24px" d="M14,12a2,2,0,1,0-2,2A2.006,2.006,0,0,0,14,12ZM12,3a9,9,0,0,0-9,9H0l4,4,4-4H5a7,7,0,1,1,2.94,5.7L6.52,19.14A9,9,0,1,0,12,3Z" transform="translate(0 -3)"/></svg>';
const String _svg_edb884 = 
    '<?xml version="1.0" encoding="utf-8"?><!-- Generator: Adobe Illustrator 25.2.1, SVG Export Plug-In . SVG Version: 6.00 Build 0)  --><svg version="1.1" id="图层_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 104.5 104.5" style="enable-background:new 0 0 104.5 104.5;" xml:space="preserve"><path style="fill:#FFFFFF;" d="M52.2,0c6.1,0,11.9,1,17.6,3c20.1,7.1,34.6,26.4,34.6,49.2c0,28.9-23.4,52.2-52.2,52.2S0,81.1,0,52.2S23.4,0,52.2,0z"/><path style="fill:#FFDFC0;" d="M69.9,3c-5.7-2-11.5-3-17.6-3C23.4,0,0,23.4,0,52.2h7.2c0-24.9,20.2-45,45-45c5.2,0,10.3,0.9,15.2,2.6c17.3,6.1,29.8,22.8,29.8,42.4h7.2C104.5,29.5,89.9,10.1,69.9,3z"/><path style="fill:#C0FFC0;" d="M52.2,7.2c5.2,0,10.3,0.9,15.2,2.6c6.3,2.2,12,5.9,16.7,10.5l5.1-5.1C83.8,9.9,77.2,5.6,69.9,3c-5.7-2-11.5-3-17.6-3C37.8,0,24.8,5.8,15.3,15.3l5.1,5.1C28.6,12.3,39.8,7.2,52.2,7.2z"/></svg>';
const String _svg_fb028c = 
    '<?xml version="1.0" encoding="utf-8"?><!-- Generator: Adobe Illustrator 25.2.1, SVG Export Plug-In . SVG Version: 6.00 Build 0)  --><svg version="1.1" id="图层_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 104.5 104.5" style="enable-background:new 0 0 104.5 104.5;" xml:space="preserve"><path style="fill:#FFFFFF;" d="M52.2,0c6.1,0,11.9,1,17.6,3c20.1,7.1,34.6,26.4,34.6,49.2c0,28.9-23.4,52.2-52.2,52.2S0,81.1,0,52.2S23.4,0,52.2,0z"/><path style="fill:#FFDFC0;" d="M69.9,3c-5.7-2-11.5-3-17.6-3C23.4,0,0,23.4,0,52.2h7.2c0-24.9,20.2-45,45-45c5.2,0,10.3,0.9,15.2,2.6c17.3,6.1,29.8,22.8,29.8,42.4h7.2C104.5,29.5,89.9,10.1,69.9,3z"/><path style="fill:#C0FFC0;" d="M69.9,3c-5.7-2-11.5-3-17.6-3c-8.5,0-16.6,2.1-23.7,5.7l3.3,6.4C37.9,9,44.9,7.2,52.2,7.2c5.2,0,10.3,0.9,15.2,2.6c6.3,2.2,12,5.9,16.7,10.5l5.1-5.1C83.8,9.9,77.2,5.6,69.9,3z"/></svg>';