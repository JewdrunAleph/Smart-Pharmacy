import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_echarts/flutter_echarts.dart'; 
import 'package:intl/intl.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import './utils.dart' as utils;
import 'dart:convert';

class XDhistorypageday extends StatefulWidget {
  XDhistorypageday({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Histroypagestate();
  }
}


class _Histroypagestate extends State<XDhistorypageday> {

  String _temperatureData = "";
  String _humidityData = "";
  String _dateMin = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
  String _dateMax = DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 1))).toString();
  dynamic _temperatureChart;
  dynamic _humidityChart;
  String _prevDate = "";
  String _nextDate = "";

  void _fetchStatisticData() async {
    try {
      final client = http.Client();
      // Get smoking info
      var response = await client.get(Uri.parse('http://${utils.rkIp}:8000/statistic/$_dateMin'));
      Map<String, dynamic> parsed = json.decode(response.body);
      setState(() {
        _prevDate = parsed["prev"];
        _nextDate = parsed["next"];
        _temperatureData = json.encode(parsed["temperature"]);
        _humidityData = json.encode(parsed["humidity"]);
        _temperatureChart = Echarts(
          option: '''
            {
              xAxis: {
                type: 'time',
                min: "$_dateMin 0:00",
                max: "$_dateMax 0:00"
              },
              yAxis: {
                type: 'value',
                min: 0,
                max: 40
              },
              series: [{
                data: $_temperatureData,
                type: 'line',
                symbol: 'none',
                markArea: {
                  silent: true,
                  itemStyle: {
                      color: 'rgba(128, 255, 128, 0.2)'
                  },
                  data: [[{
                      xAxis: '$_dateMin 0:00',
                      yAxis: '10'
                  }, {
                      xAxis: '$_dateMax 0:00',
                      yAxis: '30'
                  }]]
                }
              }]
            }
          ''',
        );
        _humidityChart = Echarts(
          option: '''
            {
              xAxis: {
                type: 'time',
                min: "$_dateMin 0:00",
                max: "$_dateMax 0:00"
              },
              yAxis: {
                type: 'value',
                min: 0,
                max: 100
              },
              series: [{
                data: $_humidityData,
                type: 'line',
                symbol: 'none',
                markArea: {
                  silent: true,
                  itemStyle: {
                      color: 'rgba(128, 255, 128, 0.2)'
                  },
                  data: [[{
                      xAxis: '$_dateMin 0:00',
                      yAxis: '35'
                  }, {
                      xAxis: '$_dateMax 0:00',
                      yAxis: '75'
                  }]]
                }
              }]
            }
          ''',
        );
      });
    }
    catch (e){
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _dateMin = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      _dateMax = DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 1))).toString();
    });
    // Now, get data from RK3399proD.
    _fetchStatisticData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(start: 41.0, end: 41.0),
            Pin(startFraction: 0.2117, endFraction: 0.1641),
            child:
                // Adobe XD layer: '中部' (group)
                Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(start: 0.0, endFraction: 0.5069),
                  child:
                      // Adobe XD layer: '温度图表' (group)
                      Stack(
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 0.0, end: 0.0),
                        Pin(start: 0.0, end: 0.0),
                        // 温度图表，使用 echarts 制图
                        child: _temperatureChart,
                      ),
                      Pinned.fromPins(
                        Pin(size: 59.0, start: 6.0),
                        Pin(size: 26.0, start: 0.0),
                        child:
                            // Adobe XD layer: '文字' (group)
                            Stack(
                          children: <Widget>[
                            Pinned.fromPins(
                              Pin(size: 40.0, end: 0.0),
                              Pin(start: 0.0, end: 0.0),
                              child: Text(
                                '温度',
                                style: TextStyle(
                                  fontFamily: 'Microsoft YaHei',
                                  fontSize: 20,
                                  color: const Color(0xff2a4f83),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(size: 11.0, start: 0.0),
                              Pin(start: 6.0, end: 6.0),
                              child:
                                  // Adobe XD layer: 'ic_play_arrow_24px' (shape)
                                  SvgPicture.string(
                                _svg_8m9lzs,
                                allowDrawingOutsideViewBox: true,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(end: 0.0, startFraction: 0.5087),
                  child:
                      // Adobe XD layer: '湿度图表' (group)
                      Stack(
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 0.0, end: 0.0),
                        Pin(start: 0.0, end: 0.0),
                        // 湿度图表，使用 echarts 制图
                        child: _humidityChart
                      ),
                      Pinned.fromPins(
                        Pin(size: 59.0, start: 6.0),
                        Pin(size: 26.0, start: 0.0),
                        child:
                            // Adobe XD layer: '文字' (group)
                            Stack(
                          children: <Widget>[
                            Pinned.fromPins(
                              Pin(size: 40.0, end: 0.0),
                              Pin(start: 0.0, end: 0.0),
                              child: Text(
                                '湿度',
                                style: TextStyle(
                                  fontFamily: 'Microsoft YaHei',
                                  fontSize: 20,
                                  color: const Color(0xff2a4f83),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(size: 11.0, start: 0.0),
                              Pin(start: 6.0, end: 6.0),
                              child:
                                  // Adobe XD layer: 'ic_play_arrow_24px' (shape)
                                  SvgPicture.string(
                                _svg_8m9lzs,
                                allowDrawingOutsideViewBox: true,
                                fit: BoxFit.fill,
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
            Pin(start: 0.0, end: 0.0),
            Pin(size: 140.0, start: 0.0),
            child:
                // Adobe XD layer: '顶部' (group)
                Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 55.0, end: 55.0),
                  Pin(size: 34.0, end: 0.0),
                  child:
                      // Adobe XD layer: '日周月导航' (group)
                      Stack(
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 0.0, end: 0.0),
                        Pin(start: 0.0, end: 0.0),
                        child:
                            // Adobe XD layer: '背景' (shape)
                            Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: const Color(0xffffffff),
                            border: Border.all(
                                width: 1.0, color: const Color(0xff2a4f83)),
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(start: 0.0, endFraction: 0.6667),
                        Pin(end: 0.0, startFraction: 0.0),
                        child: TextButton(
                          // Adobe XD layer: '日按钮' (group)
                          child: Stack(
                            children: <Widget>[
                              Pinned.fromPins(
                                Pin(startFraction: 0.1, endFraction: 0),
                                Pin(end: 0, startFraction: 0),
                                child: Text(
                                  '前日',
                                  style: TextStyle(
                                    fontFamily: 'Microsoft YaHei',
                                    fontSize: 14,
                                    color: const Color(0xff8d8d8d),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            if (_prevDate != "")
                            {
                              _dateMin = _prevDate;
                              _dateMax = DateFormat("yyyy-MM-dd").format(DateTime.parse('$_prevDate 00:00:00').add(Duration(days: 1))).toString();
                              _fetchStatisticData();
                            }
                          },
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(startFraction: 0.3333, endFraction: 0.3333),
                        Pin(end: 0.0, startFraction: 0.0),
                        child: Stack(
                          children: <Widget>[
                            Pinned.fromPins(
                              Pin(start: 0.0, end: 0.0),
                              Pin(start: 0.0, end: 0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xff2a4f83)),
                                ),
                              ),
                            ),
                            Pinned.fromPins(
                              Pin(startFraction: 0, endFraction: 0),
                              Pin(end: 5.0, startFraction: 0.2871),
                              child: Text(
                                '$_dateMin',
                                style: TextStyle(
                                  fontFamily: 'Microsoft YaHei',
                                  fontSize: 14,
                                  color: const Color(0xff8d8d8d),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(end: 0.0, startFraction: 0.6667),
                        Pin(end: 0.0, startFraction: 0.0),
                        child: TextButton(
                          // Adobe XD layer: '月按钮' (group)
                          onPressed: () {
                            if (_nextDate != "")
                            {
                              _dateMin = _nextDate;
                              _dateMax = DateFormat("yyyy-MM-dd").format(DateTime.parse('$_nextDate 00:00:00').add(Duration(days: 1))).toString();
                              _fetchStatisticData();
                            }
                          },
                          child: Stack(
                            children: <Widget>[
                              Pinned.fromPins(
                                Pin(startFraction: 0, endFraction: 0.1),
                                Pin(end: 0, startFraction: 0),
                                child: Text(
                                  '后日',
                                  style: TextStyle(
                                    fontFamily: 'Microsoft YaHei',
                                    fontSize: 14,
                                    color: const Color(0xff8d8d8d),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
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
                  Pin(start: 0.0, end: 0.0),
                  Pin(size: 90.0, start: 0.0),
                  child:
                      // Adobe XD layer: '标题' (group)
                      Stack(
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 0.0, end: 0.0),
                        Pin(start: 0.0, end: 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff3d67a1),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 165.0, middle: 0.5019),
                        Pin(size: 29.0, end: 10.0),
                        child:
                            // Adobe XD layer: '文字' (text)
                            Text(
                          '    历史数据    ',
                          style: TextStyle(
                            fontFamily: 'Microsoft YaHei',
                            fontSize: 22,
                            color: const Color(0xffffffff),
                            letterSpacing: 2.2,
                            fontWeight: FontWeight.w700,
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

const String _svg_8m9lzs =
    '<svg viewBox="36.0 127.0 11.0 14.0" ><path transform="translate(28.0, 122.0)" d="M 8 5 L 8 19 L 19 12 L 8 5 Z" fill="#2a4f83" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_60x2ey =
    '<svg viewBox="0.0 0.0 106.0 34.0" ><path  d="M 17 0 L 106 0 L 106 34 L 17 34 C 7.61115837097168 34 0 26.38884162902832 0 17 C 0 7.61115837097168 7.61115837097168 0 17 0 Z" fill="#ffffff" stroke="#2a4f83" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';