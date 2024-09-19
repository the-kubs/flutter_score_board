import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ScoreBoard extends StatefulWidget {
  const ScoreBoard({super.key});

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  int _countA = 0;
  int _countb = 0;
  int _set = 1;
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
    if ((_set >= 4) || _isGameWon(scoreA, scoreB)) {
      _showFinalWinDialog();
      return;
    }

    if (_isDeuce(scoreA, scoreB)) {
      _showDeuceDialog();
      return;
    }

    if (_isSetWin(scoreA, scoreB, isTeamA)) {
      _countA = 0;
      _countb = 0;
      _set++;

      if (isTeamA) {
        _winA++;
      } else {
        _winB++;
      }

      _set >= 4 ? _showFinalWinDialog() : _showSetWinDialog();
    }
  }

  bool _isSetWin(int scoreA, int scoreB, bool isTeamA) {
    return (isTeamA && (scoreA == 21 && scoreB <= 19) ||
        (scoreA > 20 && scoreA - scoreB >= 2) ||
        !isTeamA && (scoreB == 21 && scoreA <= 19) ||
        (scoreB > 20 && scoreB - scoreA >= 2));
  }

  bool _isDeuce(int scoreA, int scoreB) {
    return scoreA == scoreB && scoreA >= 20;
  }

  bool _isGameWon(int scoreA, int scoreB) {
    return _set >= 4;
  }

  void _showFinalWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(_winA > _winB ? 'Win Team A' : 'Win Team B'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
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
      builder: (context) => AlertDialog(
        title: const Text("Win"),
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Board'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              // Handle menu item selection
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: $result')),
              );
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'Option 1',
                child: Text('Option 1'),
              ),
              const PopupMenuItem<String>(
                value: 'Option 2',
                child: Text('Option 2'),
              ),
              const PopupMenuItem<String>(
                value: 'Option 3',
                child: Text('Option 3'),
              ),
            ],
            icon: const Icon(Icons.more_vert), // Titik tiga menu icon
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi tombol back manual
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Stack(children: [
              GestureDetector(
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
                      const Text(
                        "Team A",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "$_winA",
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Set',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text(
                  "$_set",
                  style: const TextStyle(
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(children: [
              GestureDetector(
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
                      const Text(
                        "Team B",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "$_winB",
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
