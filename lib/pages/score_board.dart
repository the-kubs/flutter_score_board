import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _saveScore(String jsonScore) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jsonScoreAll', jsonScore); // Save the JSON string
}

class ScoreBoard extends StatefulWidget {
  const ScoreBoard({super.key});

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  // late Map<String, dynamic> args;
  Map<String, dynamic>? args;
  int _maxSet = 3;
  String teamA = "";
  String teamB = "";
  String jsonScore = "[]";
  String jsonScoreAll = "[]";
  int _countA = 0;
  int _countb = 0;
  int _set = 1;
  int _setMaxScore = 11;
  int _winA = 0;
  int _winB = 0;

  void _minCounterA() {
    setState(() {
      if (_countA > 0) {
        _countA--;
      }
    });
  }

  void _minCounterB() {
    setState(() {
      if (_countb > 0) {
        _countb--;
      }
    });
  }

  void _incrementCounterA() {
    setState(() {
      _countA++;
      _checkSetWin(_countA, _countb, isTeamA: true);
    });
  }

  void _incrementCounterB() {
    setState(() {
      _countb++;
      _checkSetWin(_countA, _countb, isTeamA: false);
    });
  }

  void _checkSetWin(int scoreA, int scoreB, {required bool isTeamA}) {
    if ((_set >= _maxSet + 1) || _isGameWon(scoreA, scoreB)) {
      _showFinalWinDialog();
      return;
    }

    if (_isDeuce(scoreA, scoreB)) {
      _showDeuceDialog();
      return;
    }

    if (_isSetWin(scoreA, scoreB, isTeamA)) {
      // Parse the existing jsonScore string into a List
      List<dynamic> currentData = jsonDecode(jsonScore);

      // Add new score data to the list
      currentData.add({
        // 'team_A': teamA,
        // 'team_B': teamB,
        '_countA': _countA,
        '_countb': _countb,
        'set': _set
      });

      // Convert the updated list back to a JSON string
      jsonScore = jsonEncode(currentData);

      _set++;

      if (isTeamA) {
        _winA++;
      } else {
        _winB++;
      }

      _set >= _maxSet + 1 ? _showFinalWinDialog() : _showSetWinDialog();
    }
  }

  bool _isSetWin(int scoreA, int scoreB, bool isTeamA) {
    return (isTeamA && (scoreA == _setMaxScore && scoreB <= _setMaxScore - 2) ||
        (scoreA > _setMaxScore - 1 && scoreA - scoreB >= 2) ||
        !isTeamA && (scoreB == _setMaxScore && scoreA <= _setMaxScore - 2) ||
        (scoreB > _setMaxScore - 1 && scoreB - scoreA >= 2));
  }

  bool _isDeuce(int scoreA, int scoreB) {
    return scoreA == scoreB && scoreA >= _setMaxScore - 1;
  }

  bool _isGameWon(int scoreA, int scoreB) {
    return _set >= _maxSet + 1;
  }

  String _generateDateTime() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(now); // Format date and time
  }

  Future<void> _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jsonScoreAll = prefs.getString('jsonScoreAll') ??
          "[]"; // Load saved data or set default
    });
  }

  void _showFinalWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(_winA > _winB ? 'Win Team A' : 'Win Team B'),
        actions: [
          TextButton(
            onPressed: () async {
              // Parse the existing jsonScore string into a List
              List<dynamic> currentData = jsonDecode(jsonScoreAll);
              List<dynamic> jsonScore2 = jsonDecode(jsonScore);
              var datapertandingan = {
                'TeamA': teamA,
                'TeamB': teamB,
                'set': _maxSet,
                'finelScoreA': _winA,
                'finelScoreB': _winB,
                'score': jsonScore2
              };
              String currentDateTime = _generateDateTime();

              // Add new score data to the list
              currentData.add({currentDateTime: datapertandingan});

              // Convert the updated list back to a JSON string
              jsonScoreAll = jsonEncode(currentData);
              await _saveScore(jsonScoreAll);

              // ignore: use_build_context_synchronously

              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _showSetWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(_countA > _countb ? 'Win Team A' : 'Win Team B'),
        content: Container(
          width: 120,
          height: 50,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Justify antara widget di Row

            children: [
              Container(
                  margin: const EdgeInsets.only(right: 2),
                  color: Colors.amber,
                  width: 50,
                  height: 50,
                  child: Center(
                      child: Text(
                    '$_countA',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
              Container(
                  margin: const EdgeInsets.only(right: 2),
                  color: Colors.amber,
                  width: 50,
                  height: 50,
                  child: Center(
                      child: Text(
                    '$_countb',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _countA = 0;
              _countb = 0;
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _showDeuceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deuce"),
        content: const Text('Both teams have equal score at 20+ points.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // print(args['maxScore']);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _loadScore();
  }

  @override
  Widget build(BuildContext context) {
    // if (args == null) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _setMaxScore =
        int.tryParse(args?['maxScore']) as int; // Use null check here
    _maxSet = int.tryParse(args?['set']) as int; // Use null check here
    teamA = (args?['TeamA']); // Use null check here
    teamB = (args?['TeamB']);
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Board'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi tombol back manual
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _incrementCounterA,
                child: Container(
                  color: Colors.blue,
                  alignment: Alignment
                      .center, // Menyusun teks di tengah-tengah kontainer
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _minCounterA,
                        child: const Text(
                          '-',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Text(
                        '$_countA',
                        textAlign: TextAlign
                            .center, // Menyusun teks di tengah-tengah horizontal
                        style: const TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _incrementCounterA,
                        child: const Text(
                          '+',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Text(
                        teamA,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 105,
              child: Column(
                children: [
                  const Text(
                    'Set',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    "$_set",
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Justify antara widget di Row

                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 2),
                            color: Colors.amber,
                            width: 50,
                            height: 50,
                            child: Center(
                                child: Text(
                              '$_winA',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ))),
                        Container(
                            margin: const EdgeInsets.only(right: 2),
                            color: Colors.amber,
                            width: 50,
                            height: 50,
                            child: Center(
                                child: Text(
                              '$_winB',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: jsonDecode(jsonScore).length,
                        itemBuilder: (context, index) {
                          var matchData = jsonDecode(jsonScore)[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Justify antara widget di Row

                            children: [
                              Container(
                                  margin:
                                      const EdgeInsets.only(right: 2, top: 2),
                                  color: Colors.amber,
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    matchData['_countA'].toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))),
                              Container(
                                  margin:
                                      const EdgeInsets.only(right: 2, top: 2),
                                  color: Colors.amber,
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    matchData['_countb'].toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: _incrementCounterB,
                child: Container(
                  color: Colors.green,
                  alignment: Alignment
                      .center, // Menyusun teks di tengah-tengah kontainer
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _minCounterB,
                        child: const Text(
                          '-',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Text(
                        '$_countb',
                        textAlign: TextAlign
                            .center, // Menyusun teks di tengah-tengah horizontal
                        style: const TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _incrementCounterB,
                        child: const Text(
                          '+',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Text(
                        teamB,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
