import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

Future<void> _saveScore(String jsonScore) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jsonScoreAll', jsonScore); // Save the JSON string
}

class ChessPage extends StatefulWidget {
  const ChessPage({super.key});

  @override
  State<ChessPage> createState() => _ChessPageState();
}

class _ChessPageState extends State<ChessPage> {
  final AudioPlayer _player = AudioPlayer();
  // late Map<String, dynamic> args;
  Map<String, dynamic>? args;
  String teamB = "Black";
  String teamA = "White";
  bool btn_team_a = true;
  bool game_start = false;
  bool game_ongoing = false;
  bool game_finis = false;
  bool _2_Player = false;
  bool _switch = false;
  bool unlimited_time_a = false;
  bool unlimited_time_b = false;
  String string_remainingTime = '3';
  String string_remainingTime_b = '3';
  int _timer_a = 0;
  int _timer_b = 0;
  Timer? _timer;

  Duration remainingTime = const Duration(minutes: 3);
  Duration remainingTime_b = const Duration(minutes: 3);

  Future<void> _playClickSound() async {
    await _player.play(AssetSource('cliper2.mp4'));
  }

  void _startTimer() {
    print("apa ${btn_team_a}");
    if (!btn_team_a) return;
    print("apa3 ${btn_team_a}");
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        setState(() => game_finis = true);
        print("Waktu habis!");
      }
    });
  }

  void _startTimer_b() {
    print("apa1 ${btn_team_a} ");
    if (btn_team_a) return;
    print("apa2 ${btn_team_a}");

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime_b.inSeconds > 0) {
        setState(() {
          remainingTime_b = remainingTime_b - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        setState(() => game_finis = true);
        print("Waktu habis!");
      }
    });
  }

  Widget buildRadioOption(String label, String value, setModalState) {
    return RadioListTile<String>(
      title: Text('$label Minute'),
      value: value,
      groupValue: string_remainingTime,
      onChanged: (val) {
        if (val == '0') {
          setState(() {
            unlimited_time_a = true;
            if (!_2_Player) {
              unlimited_time_b = true;
            }
          });
        } else {
          setState(() {
            unlimited_time_a = false;
            if (!_2_Player) {
              unlimited_time_b = false;
            }
          });
        }
        setState(() {
          string_remainingTime = val!;
          remainingTime = Duration(minutes: int.parse(val));

          if (!_2_Player) {
            string_remainingTime_b = val!;
            remainingTime_b = Duration(minutes: int.parse(val));
          }
        });
        setModalState(() {
          string_remainingTime = val!;
          remainingTime = Duration(minutes: int.parse(val));
          if (!_2_Player) {
            string_remainingTime_b = val!;
            remainingTime_b = Duration(minutes: int.parse(val));
          }
        });
      },
    );
  }

  Widget buildBtn_W() {
    return GestureDetector(
      onTapDown: (_) async {
        if (btn_team_a && game_start && !game_finis) {
          await _playClickSound();
          if (!unlimited_time_a) {
            _timer?.cancel();
          }
          setState(() {
            _timer_a++;
            btn_team_a = !btn_team_a;
            if (game_start && !unlimited_time_b) {
              _startTimer_b();
            }
          });
        }
      },
      child: Container(
        color: Colors.black,
        alignment: Alignment.center, // Menyusun teks di tengah-tengah kontainer
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              teamA,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    btn_team_a
                        ? Color(0xff2ecc71)
                        : Color(0xFF111111), // hitam tengah (blur efek)
                    btn_team_a
                        ? Color(0xff2ecc71)
                        : Color(0xFFB0C4B1), // merah pinggir
                  ],
                  center: Alignment.center,
                  radius: 0.8,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: btn_team_a
                        ? Color(0xff2ecc71).withOpacity(0.6)
                        : Color(0xFFB0C4B1).withOpacity(0.6),
                    spreadRadius: 10,
                    blurRadius: 30,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  unlimited_time_a ? "" : _formatDuration(remainingTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 46,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBtn_B() {
    return GestureDetector(
      onTapDown: (_) async {
        if (!btn_team_a && game_start && !game_finis) {
          await _playClickSound();
          if (!unlimited_time_b) {
            _timer?.cancel();
          }
          setState(() {
            _timer_b++;
            btn_team_a = !btn_team_a;
            if (game_start && !unlimited_time_a) {
              _startTimer();
            }
          });
        }
      },
      child: Container(
        color: Colors.black,
        alignment:
            Alignment.topLeft, // Menyusun teks di tengah-tengah kontainer
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              teamB,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      !btn_team_a
                          ? Color(0xff2ecc71)
                          : Color(0xFF111111), // hitam tengah (blur efek)
                      !btn_team_a
                          ? Color(0xff2ecc71)
                          : Color(0xFFB0C4B1), // merah pinggir
                    ],
                    center: Alignment.center,
                    radius: 0.8,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: !btn_team_a
                          ? Color(0xff2ecc71).withOpacity(0.6)
                          : Color(0xFFB0C4B1).withOpacity(0.6),
                      spreadRadius: 10,
                      blurRadius: 30,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    unlimited_time_b ? "" : _formatDuration(remainingTime_b),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 46,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRadioOption_B(String label, String value, setModalState) {
    return RadioListTile<String>(
      title: Text('$label Minute'),
      value: value,
      groupValue: string_remainingTime_b,
      onChanged: (val) {
        if (val == '0') {
          setState(() {
            unlimited_time_b = true;
          });
        } else {
          setState(() {
            unlimited_time_b = false;
          });
        }
        setState(() {
          string_remainingTime_b = val!;
          remainingTime_b = Duration(minutes: int.parse(val));
        });
        setModalState(() {
          string_remainingTime_b = val!;
          remainingTime_b = Duration(minutes: int.parse(val));
        });
      },
    );
  }

  void _showScrollModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // agar modal bisa tinggi penuh
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        String _string_remainingTime = '3';
        String _string_remainingTime_b = '3';
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Container(
                                child: const Text(
                                  'Setting',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SwitchListTile(
                                title: Text('Time difference between player'),
                                value: _2_Player,
                                onChanged: (value) {
                                  setState(() {
                                    _2_Player = value;
                                  });
                                  setModalState(() {
                                    _2_Player = value;
                                  });
                                },
                              ),
                              Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24),
                                            width: double.infinity,
                                            child: Text(
                                              _2_Player ? "White" : 'Time',
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          buildRadioOption(
                                              'Unlimited', '0', setModalState),
                                          buildRadioOption(
                                              '1', '1', setModalState),
                                          buildRadioOption(
                                              '3', '3', setModalState),
                                          buildRadioOption(
                                              '5', '5', setModalState),
                                          buildRadioOption(
                                              '10', '10', setModalState),
                                          buildRadioOption(
                                              '30', '30', setModalState),
                                          buildRadioOption(
                                              '60', '60', setModalState),
                                          buildRadioOption(
                                              '90', '90', setModalState),
                                        ],
                                      ),
                                    ),
                                    !_2_Player
                                        ? SizedBox()
                                        : Expanded(
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 24),
                                                  child: Text(
                                                    _2_Player
                                                        ? "Black"
                                                        : 'Time',
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                buildRadioOption_B('Unlimited',
                                                    '0', setModalState),
                                                buildRadioOption_B(
                                                    '1', '1', setModalState),
                                                buildRadioOption_B(
                                                    '3', '3', setModalState),
                                                buildRadioOption_B(
                                                    '5', '5', setModalState),
                                                buildRadioOption_B(
                                                    '10', '10', setModalState),
                                                buildRadioOption_B(
                                                    '30', '30', setModalState),
                                                buildRadioOption_B(
                                                    '60', '60', setModalState),
                                                buildRadioOption_B(
                                                    '90', '90', setModalState),
                                              ],
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
                  ));
            },
          );
        });
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes =
        twoDigits(duration.inMinutes.remainder(60) + duration.inHours * 60);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop timer when widget is disposed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
      body: Container(
        child: Row(
          children: [
            Expanded(child: _switch ? buildBtn_B() : buildBtn_W()),
            Container(
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _switch
                            ? '${_timer_b} Stap ${_timer_a}'
                            : ' ${_timer_a} Stap ${_timer_b}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  GestureDetector(
                    onTap: () {
                      if (!game_start) {
                        setState(() {
                          game_ongoing = true;
                          game_start = !game_start;
                          if (!unlimited_time_a) {
                            _startTimer();
                          }
                          if (!unlimited_time_b) {
                            _startTimer_b();
                          }
                        });
                      } else {
                        setState(() {
                          game_ongoing = true;
                          game_start = !game_start;
                          if (!unlimited_time_a && !unlimited_time_b) {
                            _timer?.cancel();
                          }
                        });
                      }
                    },
                    child: Icon(
                      !game_start ? Icons.play_arrow : Icons.pause,
                      size: 48,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!game_ongoing) {
                        _showScrollModal(context);
                      } else {
                        setState(() {
                          _timer?.cancel();
                          _switch = false;
                          unlimited_time_a = false;
                          unlimited_time_b = false;
                          teamB = "Black";
                          teamA = "White";
                          btn_team_a = true;
                          _timer_a = 0;
                          _timer_b = 0;
                          string_remainingTime = '3';
                          string_remainingTime_b = '3';
                          game_ongoing = false;
                          game_start = false;
                          game_finis = false;
                          remainingTime = Duration(minutes: 3);
                          remainingTime_b = Duration(minutes: 3);
                        });
                      }
                    },
                    child: Icon(
                      game_ongoing ? Icons.stop : Icons.edit,
                      size: 48,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (game_start == false && game_ongoing == false) {
                        setState(() {
                          // btn_team_a = !btn_team_a;
                          _switch = !_switch;
                        });
                      }
                    },
                    child: Icon(
                      Icons.sync,
                      color: (game_start || game_ongoing)
                          ? Colors.grey
                          : Colors.black,
                      size: 48,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _switch ? buildBtn_W() : buildBtn_B()),
          ],
        ),
      ),
    );
  }
}
