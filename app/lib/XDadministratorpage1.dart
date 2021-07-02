import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import './utils.dart' as utils;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class XDadministratorpage1 extends StatefulWidget {
  XDadministratorpage1({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AdministratorPageState();
  }
}

class _AdministratorPageState extends State<XDadministratorpage1> {
  bool _onVerify = false;
  bool _verified = false;

  void _startVerify() async {
    if (_onVerify) {
      return;
    }
    _onVerify = true;
    try {
      Fluttertoast.showToast(
        msg: "核验中...请将人脸对准摄像头，若核验不能通过，可以尝试微调角度。",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 15,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
      );
      final client = http.Client();
      var response = await client.get(Uri.parse('http://${utils.rkIp}:8000/verify'));
      Map<String, dynamic> parsed = json.decode(response.body);
      if (parsed["code"] == 0)
      {
        setState(() {
          _verified = true;
        });
        Fluttertoast.showToast(
          msg: "核验成功。",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }
      else
      {
        Fluttertoast.showToast(
          msg: "核验失败，请尝试再次核验。",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: "核验失败，请检查网络配置。",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
    _onVerify = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffbed1e2),
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(startFraction: 0.1355, endFraction: 0.1332),
            Pin(size: 453.0, middle: 0.5624),
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(size: 313.0, middle: 0.5),
                  Pin(size: 313.0, end: 140.0),
                  child:
                      // Adobe XD layer: '相机区域' (shape)
                      Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                      color: const Color(0xffffffff),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 80.0, middle: 0.4979),
                  Pin(size: 80.0, end: 0.0),
                  child: TextButton(
                  // Adobe XD layer: '照相按钮' (group)
                    onPressed: () {
                      _startVerify();
                    },
                    child: Stack(
                      children: <Widget>[
                        Pinned.fromPins(
                          Pin(start: 0.0, end: 0.0),
                          Pin(start: 0.0, end: 0.0),
                          child: SvgPicture.string(
                            _svg_lx7j4e,
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(start: 10.0, end: 10.0),
                          Pin(start: 10.0, end: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(9999.0, 9999.0)),
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 313.0, middle: 0.5),
                  Pin(size: 313.0, end: 140.0),
                  child:
                      // Adobe XD layer: '模糊' (shape)
                      Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                      color: const Color(0x4dd3d0d0),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 97.6, middle: 0.5014),
                  Pin(size: 97.6, middle: 0.3039),
                  child:
                      // Adobe XD layer: 'ic_refresh_24px' (shape)
                      SvgPicture.string(
                    _verified ? _svg_vj5n05 : _svg_pwsr2g,
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(start: 0.0, end: 0.0),
            Pin(size: 90.0, start: 0.0),
            child:
                // Adobe XD layer: '顶部' (group)
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
                    '药房管理',
                    style: TextStyle(
                      fontFamily: 'Microsoft YaHei',
                      fontSize: 22,
                      color: const Color(0xffffffff),
                      letterSpacing: 2.2,
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
    );
  }
}

const String _svg_lx7j4e =
    '<svg viewBox="158.9 610.8 80.0 80.0" ><defs><filter id="shadow"><feDropShadow dx="0" dy="3" stdDeviation="6"/></filter></defs><path transform="translate(158.94, 610.81)" d="M 40 0 C 62.09138870239258 0 80 17.90861320495605 80 40.00000381469727 C 80 52.945556640625 73.85025024414062 64.45476531982422 64.11609649658203 71.9154052734375 C 57.57476043701172 76.9305419921875 49.14583206176758 80.00000762939453 40 80.00000762939453 C 17.90860939025879 80.00000762939453 0 62.09139251708984 0 40.00000381469727 C 0 17.90861320495605 17.90860939025879 0 40 0 Z" fill="none" stroke="#ffffff" stroke-width="4" stroke-miterlimit="4" stroke-linecap="butt" filter="url(#shadow)"/></svg>';
const String _svg_pwsr2g =
    '<svg viewBox="166.0 374.0 97.6 97.6" ><path transform="translate(161.99, 370.0)" d="M 87.28103637695312 18.33758735656738 C 78.42891693115234 9.490991592407227 66.28014373779297 4 52.78827667236328 4 C 25.80454254150391 4 4.010000228881836 25.84193992614746 4.010000228881836 52.80879974365234 C 4.010000228881836 79.77565765380859 25.80454254150391 101.6175842285156 52.78827667236328 101.6175842285156 C 75.55961608886719 101.6175842285156 94.54589080810547 86.05979919433594 99.97926330566406 65.01099395751953 L 87.28103637695312 65.01099395751953 C 82.27501678466797 79.2265625 68.72209930419922 89.41539764404297 52.78827667236328 89.41539764404297 C 32.58100891113281 89.41539764404297 16.15877914428711 73.00343322753906 16.15877914428711 52.80879974365234 C 16.15877914428711 32.61416625976562 32.58100891113281 16.20219993591309 52.78827667236328 16.20219993591309 C 62.92243194580078 16.20219993591309 71.95771789550781 20.41196441650391 78.55101776123047 27.06215476989746 L 58.8931884765625 46.70769882202148 L 101.6275863647461 46.70769882202148 L 101.6275863647461 4 L 87.28103637695312 18.33758735656738 Z" fill="#8d8d8d" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_vj5n05 =
    '<svg viewBox="129.0 373.5 169.9 98.0" ><path transform="translate(128.63, 367.91)" d="M 128.9573669433594 15.89424896240234 L 118.6531143188477 5.589998245239258 L 72.32052612304688 51.92258453369141 L 82.62477111816406 62.22683334350586 L 128.9573669433594 15.89424896240234 Z M 159.9431915283203 5.589998245239258 L 82.62477111816406 82.90840911865234 L 52.07742309570312 52.43414306640625 L 41.77316665649414 62.7383918762207 L 82.62477111816406 103.5899887084961 L 170.3205261230469 15.89424896240234 L 159.9431915283203 5.589998245239258 Z M 0.4100000262260437 62.7383918762207 L 41.2616081237793 103.5899887084961 L 51.56586074829102 93.28574371337891 L 10.78733158111572 52.43414306640625 L 0.4100000262260437 62.7383918762207 Z" fill="#3caf90" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
