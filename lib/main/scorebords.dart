import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scorre_board_flutter/pages/appversion.dart';
import 'package:scorre_board_flutter/pages/history.dart';
import 'package:scorre_board_flutter/pages/home.dart';
import 'package:scorre_board_flutter/pages/score_board.dart';
import 'package:scorre_board_flutter/utils/ads.dart';

class MainScoreBords extends StatefulWidget {
  const MainScoreBords({super.key});

  @override
  State<MainScoreBords> createState() => _MainScoreBordsState();
}

class _MainScoreBordsState extends State<MainScoreBords> {
  final RewardedAdManager _adManager = RewardedAdManager();
  @override
  void initState() {
    super.initState();
    _adManager.loadBannerAd();
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
      routes: {
        '/': (context) => const AppVersionSplashScreenPage(),
        '/home': (context) => const HomePage(),
        '/scoreboard': (context) => const ScoreBoard(),
        '/history': (context) => const HistoryPagState(),
      },
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: child!), // Menampilkan konten halaman
                  _adManager.getBannerAd() != null
                      ? Container(
                          width:
                              _adManager.getBannerAd()!.size.width.toDouble(),
                          height:
                              _adManager.getBannerAd()!.size.height.toDouble(),
                          child: AdWidget(ad: _adManager.getBannerAd()!),
                        )
                      : const Text('Loading Ad...'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
