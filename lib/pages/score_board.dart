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
        _countA--;
      }
    });
  }

  void _incrementCounterA() {
    setState(() {
      _countA++;
    });
  }

  void _incrementCounterB() {
    setState(() {
      _countb++;
    });
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
                  child: const Text(
                    "0",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ]),
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
                child: const Text(
                  "0",
                  style: TextStyle(
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
