import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPagState extends StatefulWidget {
  const HistoryPagState({super.key});

  @override
  State<HistoryPagState> createState() => _HistoryPagStateState();
}

class _HistoryPagStateState extends State<HistoryPagState> {
  String jsonScoreAll = "";
  Future<void> _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jsonScoreAll = prefs.getString('jsonScoreAll') ??
          "[]"; // Load saved data or set default
    });
  }

  Future<void> _loadAndDeleteScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jsonScoreAll');
    if (!mounted) return;
    setState(() {
      jsonScoreAll = prefs.getString('jsonScoreAll') ??
          "[]"; // Load saved data or set default
    });
    Navigator.of(context).pop();
    // Remove the score data from SharedPreferences
  }

  @override
  void initState() {
    super.initState();
    // print(args['maxScore']);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _loadScore(); // Load existing scores when the page starts
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> jsonScore;
    try {
      jsonScore = jsonDecode(jsonScoreAll);
    } catch (e) {
      // print('Error parsing JSON: $e');
      jsonScore = [];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Are You Sure"),
                  actions: [
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 180, 248, 186))),
                      onPressed: () {
                        _loadAndDeleteScores();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 249, 168, 180))),
                      onPressed: () {},
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'clear_Data',
                child: Text('Clear Data'),
              ),
            ],
            icon: const Icon(Icons.more_vert), // Titik tiga menu icon
          ),
        ],
      ),
      body: jsonScore.isEmpty
          ? const Center(
              child: Text('Data Tidak Tersedian'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: jsonScore.length,
                    itemBuilder: (context, index) {
                      var matchData = jsonScore.reversed.toList()[index];
                      String timestamp = matchData.keys
                          .first; // Ambil timestamp (misalnya: "2024-09-23 22:33:54") // Ambil nilai team_A dari index pertama
                      var matchList = matchData[
                          timestamp]; // List pertandingan dari timestamp tersebut

                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('dd MMM yyyy HH:mm:ss')
                                    .format(DateTime.parse(timestamp)),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      width: 200,
                                      height: 40,
                                      child: Text(
                                        matchList.isNotEmpty
                                            ? matchList['TeamA']
                                            : 'Unknown',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(right: 2),
                                      color: Colors.amber,
                                      width: 40,
                                      height: 40,
                                      child: Center(
                                          child: Text(
                                        matchList.isNotEmpty
                                            ? matchList['finelScoreA']
                                                .toString()
                                            : 'Unknown',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))),
                                  Row(
                                      children: List<Widget>.from(
                                    matchList['score'].map((item) {
                                      return Container(
                                          margin:
                                              const EdgeInsets.only(right: 2),
                                          color: Colors.amber,
                                          width: 40,
                                          height: 40,
                                          child: Center(
                                              child: Text(
                                            '${item['_countA']}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )));
                                    }).toList(),
                                  )),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    width: 200,
                                    height: 40,
                                    child: Text(
                                      matchList.isNotEmpty
                                          ? matchList['TeamB']
                                          : 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(right: 2),
                                      color: Colors.amber,
                                      width: 40,
                                      height: 40,
                                      child: Center(
                                          child: Text(
                                        matchList.isNotEmpty
                                            ? matchList['finelScoreB']
                                                .toString()
                                            : 'Unknown',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))),
                                  Row(
                                      children: List<Widget>.from(
                                    matchList['score'].map((item) {
                                      return Container(
                                          margin:
                                              const EdgeInsets.only(right: 2),
                                          color: Colors.amber,
                                          width: 40,
                                          height: 40,
                                          child: Center(
                                              child: Text(
                                            '${item['_countb']}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )));
                                    }).toList(),
                                  )),
                                ],
                              )
                            ],
                          ));
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
