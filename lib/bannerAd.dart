import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tvapp/AdManager.dart';

class HomePageAd extends StatefulWidget {
  @override
  _HomePageAdState createState() => _HomePageAdState();
}

class _HomePageAdState extends State<HomePageAd> {
  late BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void dispose() {
    // COMPLETE: Dispose a BannerAd object
    _ad.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ad = BannerAd(
        adUnitId: AdManager.bannerAdUnitID,
        size: AdSize.banner,
        request: AdRequest(),
        listener: AdListener(onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(
              'Ad load failed (code=${error.code} message = ${error.message}');
        }));

    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? Container(height: 20,
        child: AdWidget(
          ad: _ad,
        ),
        width: _ad.size.width.toDouble(),
        alignment: Alignment.center)
        : Container(height: 20,);
  }
}
