import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdManager {
  late RewardedAd _rewardedAd;
  bool _isAdLoaded = false;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  NativeAd? _nativeAd;
  bool _isNativeAdAdLoaded = false;

  String adUnitIdBanner = dotenv.env['BANNER_AD_UNIT_ID'] ?? '';
  void loadBannerAd() {
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

  bool get isBannerAdLoaded => _isBannerAdLoaded;

  BannerAd? getBannerAd() {
    return _bannerAd;
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

  String adUnitId = dotenv.env['NATIVE_AD_UNIT_ID'] ?? '';
  void loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: adUnitId, // Ganti dengan Ad Unit ID Anda
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _isNativeAdAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Native Ad failed to load: $error');
        },
      ),
      request: AdRequest(),
    );
    _nativeAd!.load();
  }

  bool get isNativeAdAdLoaded => _isNativeAdAdLoaded;

  NativeAd? getNativeAd() {
    return _nativeAd;
  }
}
