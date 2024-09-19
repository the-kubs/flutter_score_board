import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> _loadAndDeleteScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jsonScoreAll');
    setState(() {
      jsonScoreAll = prefs.getString('jsonScoreAll') ??
          "[]"; // Load saved data or set default
    });
    // Remove the score data from SharedPreferences
  }

  @override
  void initState() {
    super.initState();
    _loadScore(); // Load existing scores when the page starts
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blue, // Warna latar belakang status bar
      statusBarIconBrightness: Brightness.light, // Warna ikon status bar
    ));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFCD0C0D),
          title: Text(
            'Score Board',
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("match sets"),
                    content: const Text('err'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/scoreboard');
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Start'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aksi ketika tombol ditekan
                Navigator.pushNamed(context, '/scoreboard');
              },
              child: Text('Start'),
            ),
            ElevatedButton(
              onPressed: () {
                print(jsonScoreAll);
                // Navigator.pushNamed(context, '/history');
                // Aksi ketika tombol ditekan
              },
              child: Text('Hisory'),
            ),
            ElevatedButton(
              onPressed: () {
                _loadAndDeleteScores();
                // Navigator.pushNamed(context, '/history');
                // Aksi ketika tombol ditekan
              },
              child: Text('Hisory'),
            ),
            const Text("data"),
          ],
        ));
  }
}
