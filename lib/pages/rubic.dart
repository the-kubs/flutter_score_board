import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:scorre_board_flutter/utils/ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _saveScore(String jsonScore) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jsonScoreAll', jsonScore); // Save the JSON string
}

class RubicPage extends StatefulWidget {
  const RubicPage({super.key});

  @override
  State<RubicPage> createState() => _RubicPageState();
}

class _RubicPageState extends State<RubicPage> {
  final RewardedAdManager _adManager = RewardedAdManager();
  // late Map<String, dynamic> args;
  Map<String, dynamic>? args;
  String teamA = "";
  String teamB = "";
  String start = "test";
  bool _tap_down_L = false;
  bool _tap_down_R = false;
  bool standby = false;
  bool btn_reset = false;
  bool game_start = false;
  Timer? _timer;
  Duration remainingTime = Duration.zero;

  void _stopTimer() {
    if (!game_start) return;
    print('apa game stop');
    _timer?.cancel();
    setState(() {
      btn_reset = true;
      game_start = !game_start;
      start = "stop";
    });
  }

  void _standby() {
    print('=============================');
    print('apa game standby${game_start}');
    if (game_start) return;
    print('apa game standby 123');
    if (_tap_down_L && _tap_down_R) {
      setState(() {
        game_start = true;
      });
    }
    print('apa game standby ${game_start}');
    print('++++++++++++++++++++++++++++++++');
  }

  void _startTimer() {
    print('============Start=================');
    print("apa start ${game_start}");

    if (game_start || btn_reset) return;
    game_start = true;
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        remainingTime = remainingTime + const Duration(milliseconds: 1);
      });
    });
    setState(() {
      start = "mulai";
    });
    print("apa start ${game_start}");

    print('++++++++++++++++start++++++++++++++++');
  }

  void _handlePressChange() {
    print('--------------');
    print(
        'apa ${game_start} ---${(game_start == true && (_tap_down_L || _tap_down_R))}  --------------');
    if (_tap_down_L && _tap_down_R) {
      setState(() {
        standby = true;
      });
      if (game_start == true) {
        _stopTimer(); // reset biar tidak terulang
      }
      // kedua tombol ditekan, tunggu sampai salah satu dilepas
      print('Kedua tombol ditekan');
    } else if (game_start == false &&
        standby == true &&
        (_tap_down_L || _tap_down_R)) {
      // salah satu dilepas → mulai stopwatch
      setState(() {
        standby = false;
      });
      _startTimer();
    }
    print('pppppppppppppppppppppppppppppppppppppppppppppppppp');
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = twoDigits(duration.inMilliseconds.remainder(100));
    return "$hours:$minutes:$seconds:$milliseconds";
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop timer when widget is disposed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _adManager.loadRewardedAd();
    _adManager.loadInterstitialAd();
    _adManager.loadBannerAd();

    // print(args['maxScore']);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Set fullscreen (immersive mode)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.black,
            child: Center(
              child: Text(
                "${_formatTime(remainingTime)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Listener(
                      onPointerDown: (event) {
                        setState(() {
                          _tap_down_L = true;
                        });
                        _handlePressChange();
                      },
                      onPointerUp: (event) {
                        setState(() {
                          _tap_down_L = false;
                        });
                        _handlePressChange();
                      },
                      child: GestureDetector(
                        child: Container(
                          color: Colors.black,
                          alignment: Alignment
                              .center, // Menyusun teks di tengah-tengah kontainer
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      _tap_down_L
                                          ? Color(0xff2ecc71)
                                          : Color(
                                              0xFF111111), // hitam tengah (blur efek)
                                      _tap_down_L
                                          ? Color(0xff2ecc71)
                                          : Color(0xFFB0C4B1), // merah pinggir
                                    ],
                                    center: Alignment.center,
                                    radius: 0.8,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _tap_down_L
                                          ? Color(0xff2ecc71).withOpacity(0.6)
                                          : Color(0xFFB0C4B1).withOpacity(0.6),
                                      spreadRadius: 10,
                                      blurRadius: 30,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                    child: Icon(
                                  Icons.front_hand,
                                  size: 125,
                                  color: Colors.white,
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  !btn_reset
                      ? SizedBox()
                      : Container(
                          padding:
                              EdgeInsetsDirectional.symmetric(vertical: 24),
                          alignment: Alignment.topCenter,
                          height: double.infinity,
                          color: Colors.black,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                remainingTime = Duration.zero;
                                btn_reset = false;
                              });
                            },
                            child: Icon(
                              Icons.refresh,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  Expanded(
                    child: Listener(
                      onPointerDown: (event) {
                        setState(() {
                          _tap_down_R = true;
                        });
                        _handlePressChange();
                      },
                      onPointerUp: (event) {
                        setState(() {
                          _tap_down_R = false;
                        });
                        _handlePressChange();
                      },
                      child: Container(
                        color: Colors.black,
                        alignment: Alignment
                            .center, // Menyusun teks di tengah-tengah kontainer
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    _tap_down_R
                                        ? Color(0xff2ecc71)
                                        : Color(
                                            0xFF111111), // hitam tengah (blur efek)
                                    _tap_down_R
                                        ? Color(0xff2ecc71)
                                        : Color(0xFFB0C4B1), // merah pinggir
                                  ],
                                  center: Alignment.center,
                                  radius: 0.8,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _tap_down_R
                                        ? Color(0xff2ecc71).withOpacity(0.6)
                                        : Color(0xFFB0C4B1).withOpacity(0.6),
                                    spreadRadius: 10,
                                    blurRadius: 30,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(3.14),
                                child: const Icon(
                                  Icons.front_hand,
                                  size: 125,
                                  color: Colors.white,
                                ),
                              )),
                            ),
                          ],
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
    );
  }
}
