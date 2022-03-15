import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../const/ad_strings.dart';

class AdManager extends GetxService {
  static String intId = AdString.interstitialAdUnitID;
  static String banId = AdString.bannerAdUnitID;

  static int count = 0;
  static _clicked() => count++;
  static bool get showCount => count % 3 == 0 && count != 0;

  static InterstitialAd? _interstitialAd;

  static init() async {
    await _loadIntAd();
  }

  static Future _loadIntAd() async {
    await InterstitialAd.load(
        adUnitId: intId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  static Future _callIntAd(bool show, Function? onTap) async {
    if (show && _interstitialAd != null) {
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            debugPrint('%ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          debugPrint('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          onTap?.call();
          _loadIntAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          onTap?.call();
          _loadIntAd();
        },
        onAdImpression: (InterstitialAd ad) =>
            debugPrint('$ad impression occurred.'),
      );
      _interstitialAd?.show();
    } else {
      onTap!.call();
    }
  }

  static showIntAd(Function onTap){
    _callIntAd(true, onTap);
  }

  static showCountIntAd(Function onTap){
    _clicked();
    _callIntAd(showCount, onTap);
  }
}
