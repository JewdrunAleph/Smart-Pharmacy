import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './XDmonitorpage.dart';
import './outcontainer.dart';
import 'dart:async';

class XDlandingpage extends StatefulWidget {
  XDlandingpage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LandingpageState();
  }
}

// Because there's a timer in it, it's stateful widget.
class _LandingpageState extends State<XDlandingpage> {
  late Timer _countTimer;
  int _countDown = 3;

  @override
  void initState() {
    super.initState();
    _funcCountDown();
  }

  // To skip this page after 3 seconds.
  void _funcCountDown() {
    _countTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_countDown < 1)
          {
            // Now, use Navigator to route.
            _countTimer.cancel();
            // Since the landing screen should not be displayed anymore, 
            // here we use "pushReplacement" instead of "push".
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return ContainerPage();
                }
              )
            );
          }
          else
          {
            _countDown -= 1;
          }
        });
      }
    );
  }

  // The layout below is generated by Adobe XD,
  // Designed by Zhou Lisha.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(size: 500.0, middle: 0.5),
            Pin(startFraction: 0.5994, endFraction: 0.2819),
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 9.0, end: 8.0),
                  Pin(startFraction: 0.0, endFraction: 0.3455),
                  child: Text(
                    'SMART',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 60,
                      color: const Color(0xff3d67a1),
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(startFraction: 0.5636, endFraction: 0.0),
                  child: Text(
                    'PHARMACY',
                    style: TextStyle(
                      fontFamily: 'Tahoma',
                      fontSize: 40,
                      color: const Color(0xff7ea6d9),
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(start: 43.0, end: 42.0),
            Pin(startFraction: 0.1955, endFraction: 0.4006),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('icons/logo.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}