import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                Navigator.pushNamed(context, '/history');
                // Aksi ketika tombol ditekan
              },
              child: Text('Hisory'),
            ),
            const Text("data"),
          ],
        ));
  }
}
