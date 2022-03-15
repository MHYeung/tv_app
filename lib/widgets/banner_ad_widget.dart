import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key, required this.bannerID, this.adSize = AdSize.largeBanner}) : super(key: key);

  final String bannerID;
  final AdSize adSize;

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {

  late BannerAd myBanner;

  @override
  void initState() {
    myBanner = BannerAd(
      adUnitId: widget.bannerID,
      size: widget.adSize,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
    myBanner.load();
    super.initState();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, ///TODO: Change the container color to match theme
      alignment: Alignment.center,
      child: AdWidget(ad: myBanner,),
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
  }
}
