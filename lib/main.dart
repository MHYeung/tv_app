import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:launch_review/launch_review.dart';
import 'package:tvapp/const/ad_strings.dart';
import 'package:tvapp/const/playList.dart';
import 'package:tvapp/pages/tv/tv_binding.dart';
import 'package:tvapp/pages/tv/tv_screen.dart';
import 'package:tvapp/widgets/banner_ad_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: TVBinding(),
      home: TVScreen(),
      theme: ThemeData.dark(),
    );
  }
}


