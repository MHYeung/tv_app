import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../const/ad_strings.dart';

final intAdProvider = Provider((ref) => AdManager());

class AdManager extends AutoDisposeAsyncNotifier<void>{
  static String intId = AdString.interstitialAdUnitID;
  static String banId = AdString.bannerAdUnitID;

  static int count = 0;
  static _clicked() => count++;
  static bool get showCount => count % 3 == 0 && count != 0;

  static InterstitialAd? _interstitialAd;

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

  void showIntAd(Function onTap) {
    _callIntAd(true, onTap);
  }

  void showCountIntAd(Function onTap) {
    _clicked();
    _callIntAd(showCount, onTap);
  }

  @override
  Future<FutureOr> build() async {
    await _loadIntAd();
  }
}
