import 'package:flutter/material.dart';
import 'package:scorre_board_flutter/pages/appversion.dart';
import 'package:scorre_board_flutter/pages/history.dart';
import 'package:scorre_board_flutter/pages/home.dart';
import 'package:scorre_board_flutter/pages/score_board.dart';

class MainScoreBords extends StatelessWidget {
  const MainScoreBords({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo 123',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFCD0C0D), // Warna latar belakang AppBar
            titleTextStyle: TextStyle(
              color: Colors.white, // Warna teks judul AppBar
              fontSize: 20, // Ukuran font judul
            ),
            iconTheme: IconThemeData(
              color: Colors.white, // Warna ikon AppBar
              size: 24, // Ukuran ikon
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AppVersionSplashScreenPage(),
          '/home': (context) => const HomePage(),
          '/scoreboard': (context) => const ScoreBoard(),
          '/history': (context) => const HistoryPagState(),
        });
  }
}
