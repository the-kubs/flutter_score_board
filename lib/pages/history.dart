import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scorre_board_flutter/utils/ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HistoryPagState extends StatefulWidget {
  const HistoryPagState({super.key});

  @override
  State<HistoryPagState> createState() => _HistoryPagStateState();
}

class _HistoryPagStateState extends State<HistoryPagState> {
  String jsonScoreAll = "";

  bool _isNativeAdAdLoaded = false;
  bool _isBannerAdLoaded = false;
  BannerAd? _bannerAd;
  NativeAd? _nativeAd;

  final RewardedAdManager _adManager = RewardedAdManager();

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

    _adManager.loadInterstitialAd();
    if (_adManager.isInterstitialAdLoaded &&
        _adManager.getInterstitialAd() != null) {
      _adManager.getInterstitialAd()!.show();
      _adManager.getInterstitialAd()!.fullScreenContentCallback =
          FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          // Menavigasi ke halaman detail setelah iklan ditutup

          Navigator.of(context).pop();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Failed to show interstitial ad: $error');

          Navigator.of(context).pop();
        },
      );
    } else {
      print('Interstitial ad not ready yet.');

      Navigator.of(context).pop();
    }
    // Remove the score data from SharedPreferences
  }

  String adUnitIdBanner = dotenv.env['BANNER_AD_UNIT_ID'] ?? '';
  void loadBannerAd() {
    print("Banner ${adUnitIdBanner}");
    _bannerAd = BannerAd(
      adUnitId: adUnitIdBanner, // Ganti dengan Ad Unit ID Anda
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _isBannerAdLoaded = true;
          print('Banner Ad loaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _isBannerAdLoaded = false;
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  String adUnitId = dotenv.env['NATIVE_AD_UNIT_ID'] ?? '';
  void loadNativeAd123() {
    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      nativeTemplateStyle: NativeTemplateStyle(
        // Choose a template type
        templateType: TemplateType.medium,
        // Customize the ad's style
        mainBackgroundColor: Colors.purple,
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.cyan,
          backgroundColor: Colors.red,
          style: NativeTemplateFontStyle.monospace,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.red,
          backgroundColor: Colors.cyan,
          style: NativeTemplateFontStyle.italic,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.green,
          backgroundColor: Colors.black,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.brown,
          backgroundColor: Colors.amber,
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            print('Native Ad loaded');
            _isNativeAdAdLoaded = true;
            print('Native Ad loaded: $_isNativeAdAdLoaded');
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Native Ad failed to load: $error');
          ad.dispose(); // Dispose of the ad on failure
        },
        onAdOpened: (ad) {
          print('Native Ad opened');
        },
        onAdClosed: (ad) {
          print('Native Ad closed');
          setState(() {
            ad.dispose(); // Dispose of the ad when closed
            _isNativeAdAdLoaded = false; // Reset the loaded status
          });
        },
      ),
      request: AdRequest(),
    )..load(); // Load the ad
  }

  @override
  void initState() {
    super.initState();
    // print(args['maxScore']);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _loadScore(); // Load existing scores when the page starts
    _adManager.loadRewardedAd();
    _adManager.loadBannerAd();
    _adManager.loadInterstitialAd();
    loadNativeAd123();
    // _adManager.loadNativeAd();
    print('test');
    print("test ${_adManager.getNativeAd()}");
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
          ? const SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  NativeAdComponent(),
                  Center(
                    child: Text('Data Tidak Tersedian'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                const BannerAdComponent(),
                Expanded(
                  child: ListView.builder(
                    itemCount: jsonScore.length,
                    itemBuilder: (context, index) {
                      if (index > 0 && index % 6 == 0) {
                        // Menampilkan iklan setiap 5 data
                        return NativeAdComponent();
                      } else {
                        var matchData =
                            jsonScore.reversed.toList()[index - (index ~/ 6)];
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
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
