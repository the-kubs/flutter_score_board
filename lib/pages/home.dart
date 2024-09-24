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

  final TextEditingController _teamAController = TextEditingController();
  final TextEditingController _teamBController = TextEditingController();
  final TextEditingController _setAController = TextEditingController();
  final TextEditingController _maxScoreController = TextEditingController();

  // String team_A = _teamAController.text;
  // String team_B = _teamBController.text;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.green, // Warna latar belakang status bar
      statusBarIconBrightness: Brightness.light, // Warna ikon status bar
    ));
    _setAController.text = '3';
    _maxScoreController.text = '21';
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFCD0C0D),
          title: const Text(
            'Score Board',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String result) {
                Navigator.pushNamed(
                  context,
                  '/history',
                );
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'Option 1',
                  child: Text('History'),
                ),
              ],
              icon: const Icon(Icons.more_vert), // Titik tiga menu icon
            ),
          ],
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
                    if (int.parse(_setAController.text) > 3) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                              "Set Pertandingan tidak boleh lebih dari 3"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _setAController.text = '3';
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    } else {
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
                    }
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
