import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scorre_board_flutter/components/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String jsonScoreAll = "";
  Future<void> _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jsonScoreAll = prefs.getString('jsonScoreAll') ??
          "[]"; // Load saved data or set default
    });
  }

  // Future<void> _loadAndDeleteScores() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('jsonScoreAll');
  //   setState(() {
  //     jsonScoreAll = prefs.getString('jsonScoreAll') ??
  //         "[]"; // Load saved data or set default
  //   });
  //   // Remove the score data from SharedPreferences
  // }

  final TextEditingController _teamAController = TextEditingController();
  final TextEditingController _teamBController = TextEditingController();
  final TextEditingController _setAController = TextEditingController();
  final TextEditingController _maxScoreController = TextEditingController();

  // String team_A = _teamAController.text;
  // String team_B = _teamBController.text;
  @override
  void initState() {
    super.initState();
    _setAController.text = '3';
    _maxScoreController.text = '21';
    _loadScore(); // Load existing scores when the page starts
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.green, // Warna latar belakang status bar
      statusBarIconBrightness: Brightness.light, // Warna ikon status bar
    ));
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFCD0C0D),
          title: const Text(
            'Score Board',
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: !isPortrait
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TeamInput(
                              labelText: 'Team A ',
                              controller: _teamAController,
                              teamName: 'Team A',
                              containerColor: Colors.blue),
                          Container(
                            width: 80,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'VS',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TeamInput(
                              labelText: 'Team B ',
                              controller: _teamBController,
                              teamName: 'Team B',
                              containerColor: Colors.green),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TeamInput(
                              labelText: 'Team A ',
                              controller: _teamAController,
                              teamName: 'Team A',
                              containerColor: Colors.blue),
                          Container(
                            width: 80,
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'VS',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TeamInput(
                              labelText: 'Team B ',
                              controller: _teamBController,
                              teamName: 'Team B',
                              containerColor: Colors.green),
                        ],
                      ),
              ),
              Container(
                alignment: Alignment.center,
                child: !isPortrait
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TeamInput(
                              controller: _setAController,
                              keyboardType: TextInputType.number,
                              teamName: 'Set',
                              containerColor: Colors.white),
                          const SizedBox(
                            width: 80,
                          ),
                          TeamInput(
                              controller: _maxScoreController,
                              teamName: 'Max Score',
                              keyboardType: TextInputType.number,
                              containerColor: Colors.white),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TeamInput(
                              controller: _setAController,
                              keyboardType: TextInputType.number,
                              teamName: 'Set',
                              containerColor: Colors.white),
                          const SizedBox(
                            width: 80,
                          ),
                          TeamInput(
                              controller: _maxScoreController,
                              keyboardType: TextInputType.number,
                              teamName: 'Max Score',
                              containerColor: Colors.white),
                        ],
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width / (isPortrait ? 1 : 2),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/scoreboard',
                      arguments: {
                        'set': _setAController.text,
                        'maxScore': _maxScoreController.text,
                        'TeamA': _teamAController.text.isNotEmpty
                            ? _teamAController.text
                            : "Team A",
                        'TeamB': _teamBController.text.isNotEmpty
                            ? _teamBController.text
                            : "Team B",
                      },
                    );
                  },
                  child: const Text('Start'),
                ),
              ),

              // ElevatedButton(
              //   onPressed: () {
              //     _loadAndDeleteScores();
              //     // Navigator.pushNamed(context, '/history');
              //     // Aksi ketika tombol ditekan
              //   },
              //   child: const Text('Hisory'),
              // ),
            ],
          ),
        ));
  }
}
