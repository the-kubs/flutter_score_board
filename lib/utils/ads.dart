import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdManager {
  late RewardedAd _rewardedAd;
  bool _isAdLoaded = false;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;
  NativeAd? _nativeAd;
  bool _isNativeAdAdLoaded = false;

  bool get isBannerAdLoaded => _isBannerAdLoaded;
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

          print("Banner 5 ${_isBannerAdLoaded}");
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _isBannerAdLoaded = false;
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();

    print("Banner ${_isBannerAdLoaded}");
  }

  BannerAd? getBannerAd() {
    return _bannerAd;
  }

  void loadInterstitialAd([Function()? onAdCompleted]) {
    String adUnitId = dotenv.env['INTERSIAL_AD_UNIT_ID'] ?? '';
    InterstitialAd.load(
      adUnitId: adUnitId, // Ganti dengan Unit ID Anda
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          // Tambahkan listener untuk event
          print('jalan123');

          _interstitialAd!.show();
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              ad.dispose();
              if (onAdCompleted != null) {
                onAdCompleted();
              }
              // loadInterstitialAd(); // Load ulang setelah iklan ditutup
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              ad.dispose();
              if (onAdCompleted != null) {
                onAdCompleted();
              }
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void loadInterstitialAd2() {
    String adUnitId = dotenv.env['INTERSIAL_AD_UNIT_ID'] ?? '';
    InterstitialAd.load(
      adUnitId: adUnitId, // Ganti dengan Unit ID Anda
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void showInterstitialAd(BuildContext context, Function() onAdCompleted) {
    if (_isInterstitialAdLoaded) {
      _interstitialAd!.show();
      // Tambahkan listener untuk event
      print('jalan123');

      _interstitialAd!.show();
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          ad.dispose();
          loadInterstitialAd2();
          // loadInterstitialAd(); // Load ulang setelah iklan ditutup
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          ad.dispose();
          loadInterstitialAd2();
        },
      );
    } else {
      print('Rewarded ad is not yet loaded');
    }
  }

  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded;

  InterstitialAd? getInterstitialAd() {
    return _interstitialAd;
  }

  void loadRewardedAd() {
    String adUnitId = dotenv.env['REWARDED_AD_UNIT_ID'] ?? '';
    RewardedAd.load(
      adUnitId: adUnitId, // Ganti dengan Ad Unit ID yang valid
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('Rewarded Ad loaded');
          _rewardedAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load Rewarded Ad: $error');
          _isAdLoaded = false;
        },
      ),
    );
  }

  void showRewardedAd(BuildContext context, Function() onAdCompleted) {
    if (_isAdLoaded) {
      _rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          // _showRewardDialog();
          print('User earned reward: ${reward.amount}');
          onAdCompleted();
        },
      );

      // Reset ad state setelah tampil
      _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (AdWithoutView ad) {
          ad.dispose();
          loadRewardedAd(); // Load iklan baru untuk penggunaan berikutnya
        },
        onAdFailedToShowFullScreenContent: (AdWithoutView ad, AdError error) {
          print('Failed to show Rewarded Ad: $error');
          ad.dispose();
          loadRewardedAd(); // Load iklan baru jika gagal tampil
        },
      );
    } else {
      print('Rewarded ad is not yet loaded');
    }
  }

  void loadNativeAd() {
    String adUnitId = dotenv.env['NATIVE_AD_UNIT_ID'] ?? '';
    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
          templateType: TemplateType.medium,
          // Optional: Customize the ad's style.
          mainBackgroundColor: Colors.purple,
          cornerRadius: 10.0,
          callToActionTextStyle: NativeTemplateTextStyle(
              textColor: Colors.cyan,
              backgroundColor: Colors.red,
              style: NativeTemplateFontStyle.monospace,
              size: 16.0),
          primaryTextStyle: NativeTemplateTextStyle(
              textColor: Colors.red,
              backgroundColor: Colors.cyan,
              style: NativeTemplateFontStyle.italic,
              size: 16.0),
          secondaryTextStyle: NativeTemplateTextStyle(
              textColor: Colors.green,
              backgroundColor: Colors.black,
              style: NativeTemplateFontStyle.bold,
              size: 16.0),
          tertiaryTextStyle: NativeTemplateTextStyle(
              textColor: Colors.brown,
              backgroundColor: Colors.amber,
              style: NativeTemplateFontStyle.normal,
              size: 16.0)), // Ganti dengan Ad Unit ID Anda
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print('native Ad loaded');
          _isNativeAdAdLoaded = true;
          print('native Ad loaded ${isNativeAdAdLoaded}');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Native Ad failed to load: $error');
        },
        onAdOpened: (ad) {
          print('Native Ad opened');
        },
        onAdClosed: (ad) {
          print('Native Ad closed');
          ad.dispose(); // Dispose of the ad when closed
          _isNativeAdAdLoaded = false; // Reset the loaded status
        },
      ),
      request: AdRequest(), // Styling
    )..load();
  }

  bool get isNativeAdAdLoaded => _isNativeAdAdLoaded;

  NativeAd? getNativeAd() {
    return _nativeAd;
  }
}

class NativeAdComponent extends StatefulWidget {
  const NativeAdComponent({super.key});

  @override
  State<NativeAdComponent> createState() => _NativeAdComponentState();
}

class _NativeAdComponentState extends State<NativeAdComponent> {
  bool _isNativeAdAdLoaded = false;
  NativeAd? _nativeAd;

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
    loadNativeAd123();
  }

  @override
  Widget build(BuildContext context) {
    return _isNativeAdAdLoaded && _nativeAd != null
        ? ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 320, // minimum recommended width
              minHeight: 320, // minimum recommended height
              maxWidth: 400,
              maxHeight: 400,
            ),
            child: AdWidget(ad: _nativeAd!),
          )
        : SizedBox();
  }
}

class BannerAdComponent extends StatefulWidget {
  const BannerAdComponent({super.key});

  @override
  State<BannerAdComponent> createState() => _BannerAdComponentState();
}

class _BannerAdComponentState extends State<BannerAdComponent> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  String adUnitIdBanner = dotenv.env['BANNER_AD_UNIT_ID'] ?? '';
  void loadBannerAd() {
    print("Banner ${adUnitIdBanner}");
    _bannerAd = BannerAd(
      adUnitId: adUnitIdBanner, // Ganti dengan Ad Unit ID Anda
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdLoaded = true;
            print('Banner Ad loaded');

            print("Banner 5 ${_isBannerAdLoaded}");
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          setState(() {
            _isBannerAdLoaded = false;
            print('Banner ad failed to load: $error');
            ad.dispose();
          });
        },
      ),
    )..load();

    print("Banner ${_isBannerAdLoaded}");
  }

  @override
  void initState() {
    super.initState();
    loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return _isBannerAdLoaded && _bannerAd != null
        ? Container(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : SizedBox();
  }
}

class InterstitialAdComponent extends StatefulWidget {
  final VoidCallback? onShowAd;
  const InterstitialAdComponent({
    super.key,
    this.onShowAd,
  });

  @override
  State<InterstitialAdComponent> createState() =>
      _InterstitialAdComponentState();
}

class _InterstitialAdComponentState extends State<InterstitialAdComponent> {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  void loadInterstitialAd() {
    String adUnitId = dotenv.env['INTERSIAL_AD_UNIT_ID'] ?? '';
    InterstitialAd.load(
      adUnitId: adUnitId, // Ganti dengan Unit ID Anda
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
            _isInterstitialAdLoaded = true;
            // Tambahkan listener untuk event
          });
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                loadInterstitialAd(); // Load ulang setelah iklan ditutup
              });
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              setState(() {
                ad.dispose();
              });
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            print('InterstitialAd failed to load: $error');
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // _isInterstitialAdLoaded ? onShowAd! : null;
  }
}

class InterstitialAd2Component extends StatelessWidget {
  final VoidCallback? onShowAd;
  final bool isInterstitialAdLoaded;
  const InterstitialAd2Component(
      {super.key, this.onShowAd, required this.isInterstitialAdLoaded});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: isInterstitialAdLoaded ? onShowAd : null,
        child: Text('ads'));
  }
}
