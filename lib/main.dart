import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:launch_review/launch_review.dart';
import 'package:tvapp/AdManager.dart';
import 'package:tvapp/bannerAd.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.dark(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late YoutubePlayerController _controller;

  late PlayerState _playerState;

  late YoutubeMetaData _videoMetaData;

  bool _isPlayerReady = false;

  final List<String> _ids = [
    'DHsJ10jOFAM',
    'TCnaIE_SAtM',
    'R2iMq5LKXco',
    'lu_BJKxqGnk',
    'ABn_ccXn_jc',
    'XxJKnDLYZz4',
    'EmuMuVyAjh4',
    'xL0ch83RAK8',
    'tJ-Y20luk04',
    'rGPXugD0ekU',
    'oV_i3Hsl_zg',
    'GlGXdDBGZ7k',
    'KDRwIRKP5tY',
    'vAMp4Ff2mrw',
    'wSKE3A40SIk',
    '_pZQ1Lk0xMA',
    'xbNWkUyxQGM',
    'LEOat38Iuao',
  ];

  final List<String> _titles = [
    '寰宇新聞台',
    '中視新聞台',
    'EBC 東森新聞',
    'CTI中天新聞',
    'EBC 東森財經新聞',
    '民視新聞',
    'TVBS 56頻道',
    '台視新聞台',
    '華視戲劇頻道-台灣靈異事件',
    '網路流行音樂電台',
    '大愛一臺',
    '淨空老法師直播台',
    'TVBS新聞 55 頻道',
    '誠心電視台',
    '新唐人LIVE',
    'momo購物一台',
    'momo購物二台',
    '美好購物2台',
  ];

  InterstitialAd? _interstitialAd;

  void _createInterstitialAd() {
    _interstitialAd = InterstitialAd(
        adUnitId: AdManager.interstitialAdUnitID,
        request: AdRequest(), listener: AdListener(),
    );
    _interstitialAd!.load();
  }

  void _showInterstitialAd() {
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: true,
        loop: false,
        isLive: true,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: false,
        onReady: () => _isPlayerReady = true,
      ),
      builder: (context, player) => Scaffold(
        // appBar: AppBar(
        //   title: const Text('電視直播大全'),
        // ),
        body: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            player,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.indigoAccent
                      ),
                      icon: Icon(Icons.share),
                      onPressed: () => LaunchReview.launch(),
                      label: Text('分享給朋友'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.indigoAccent
                      ),
                      onPressed: _isPlayerReady
                          ? () => _controller.load(_ids[
                      (_ids.indexOf(_controller.metadata.videoId) - 1) %
                          _ids.length])
                          : null,
                      child: Text('上一個頻道'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigoAccent
                      ),
                      child: Text('下一個頻道'),
                      onPressed:(){ _isPlayerReady
                          ?  _controller.load(_ids[
                      (_ids.indexOf(_controller.metadata.videoId) + 1) %
                          _ids.length])
                          : null;}
                    ),
                  ),
                ],
              ),
            ),
            _space,
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(child: Text(_controller.metadata.title)),
              ),
            ),
            Expanded(
              flex: 10,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: _titles
                          .map((e) => ActionChip(
                        backgroundColor: (_ids[_titles.indexOf(e)] ==
                            _controller.metadata.videoId)
                            ? Colors.orange
                            : Colors.brown,
                        avatar: CircleAvatar(
                            child: Text('${_titles.indexOf(e) + 1}')),
                        onPressed: () {
                          _showInterstitialAd();
                          setState(() {
                            _controller.load(_ids[_titles.indexOf(e)]);
                            _createInterstitialAd();
                          });
                        },
                        label: Text(e),
                      ))
                          .toList()
                          .cast<Widget>(),
                    ),
                  ),
                ),
              ),
            Expanded(
              flex: 1,
              child: HomePageAd(),
            ),
          ]),
        ),
      ),
    );
  }
}

Widget get _space => const SizedBox(height: 5);

