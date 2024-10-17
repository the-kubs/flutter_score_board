import 'package:flutter/material.dart';
import 'package:scorre_board_flutter/pages/appversion.dart';
import 'package:scorre_board_flutter/pages/history.dart';
import 'package:scorre_board_flutter/pages/home.dart';
import 'package:scorre_board_flutter/pages/score_board.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class MainScoreBords extends StatefulWidget {
  const MainScoreBords({super.key});

  @override
  State<MainScoreBords> createState() => _MainScoreBordsState();
}

class _MainScoreBordsState extends State<MainScoreBords> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  void initState() {
    super.initState();
  }

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
      navigatorObservers: <NavigatorObserver>[observer],
      routes: {
        '/': (context) => const AppVersionSplashScreenPage(),
        '/home': (context) =>
            analyticsScreenWrapper(const HomePage(), 'HomePage'),
        '/scoreboard': (context) =>
            analyticsScreenWrapper(const ScoreBoard(), 'ScoreBoard'),
        '/history': (context) =>
            analyticsScreenWrapper(const HistoryPagState(), 'HistoryPagState'),
        '/listBuyBg': (context) =>
            analyticsScreenWrapper(const HistoryPagState(), 'HistoryPagState')
      },
    );
  }

  Widget analyticsScreenWrapper(Widget screen, String screenName) {
    analytics.logScreenView(screenName: screenName, screenClass: screenName);
    return screen;
  }
}
