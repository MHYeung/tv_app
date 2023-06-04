import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launch_review/launch_review.dart';
import 'package:tvapp/const/ad_strings.dart';
import 'package:tvapp/const/playList.dart';
import 'package:tvapp/providers/channel_provider.dart';
import 'package:tvapp/providers/tv_provider.dart';
import 'package:tvapp/services/admob/ad_manager.dart';
import 'package:tvapp/themes/theme_provider.dart';
import 'package:tvapp/widgets/banner_ad_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider);
    final channelIndex = ref.watch(channelProvider);
    final controller = ref.watch(tvProvider);
    final textTheme = Theme.of(context).textTheme;
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: controller.tv,
          showVideoProgressIndicator: false,
          onReady: () => controller.isPlayerReady = true,
        ),
        builder: (context, player) {
          return Scaffold(
            appBar: AppBar(
                title: AutoSizeText(
                  Playlist.titles[channelIndex],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () =>
                          ref.read(themeModeProvider.notifier).switchTheme(),
                      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode))
                ]),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 3, child: player),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  //   child: Consumer(
                  //     builder: (BuildContext context, WidgetRef ref, Widget? widget) {
                  //       return AutoSizeText(
                  //         ref.watch(tvProvider).tv.metadata.title,
                  //         maxLines: 3,
                  //         style: textTheme.displayMedium,
                  //       );
                  //     }
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(channelProvider.notifier)
                                .previousChannel();
                          },
                          child: AutoSizeText(
                            '上一個頻道',
                            maxLines: 1,
                            style: textTheme.displaySmall,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ElevatedButton(
                          child: AutoSizeText(
                            '下一個頻道',
                            maxLines: 1,
                            style: textTheme.displaySmall,
                          ),
                          onPressed: () {
                            ref.read(channelProvider.notifier).nextChannel();
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: AutoSizeText(
                      '頻道列表',
                      style: textTheme.displayMedium,
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 2.0),
                        child: SingleChildScrollView(
                            physics: ClampingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: Playlist.titles
                                  .map((channel) => Container(
                                        width: double.infinity,
                                        child: GestureDetector(
                                          onTap: () {
                                            ref.read(intAdProvider).showIntAd(
                                                () => ref
                                                    .read(channelProvider
                                                        .notifier)
                                                    .switchChannel(Playlist
                                                        .titles
                                                        .indexOf(channel)));
                                          },
                                          child: Card(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  (channelIndex ==
                                                          Playlist.titles
                                                              .indexOf(channel))
                                                      ? Container(
                                                        padding: EdgeInsets.symmetric(horizontal:5.0, vertical: 2.0),
                                                        decoration: BoxDecoration(
                                                          color:  Colors.transparent,
                                                          borderRadius: BorderRadius.circular(4.0)
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Icon(Icons.live_tv_rounded, color: Colors.red,),
                                                              SizedBox(width: 5.0,),
                                                              AutoSizeText("現正觀看", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)
                                                            ],
                                                          ),
                                                      )
                                                      : CircleAvatar(
                                                          backgroundColor:
                                                              Colors.brown[400],
                                                          child: AutoSizeText(
                                                              "${Playlist.titles.indexOf(channel) + 1}")),
                                                  Expanded(
                                                    child: Center(
                                                      child: AutoSizeText(
                                                        channel,
                                                        overflow: TextOverflow.fade,
                                                        style: textTheme.displayMedium,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.share),
                                                    onPressed: () =>
                                                        LaunchReview.launch(),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            )),
                      )),
                  BannerAdWidget(
                    bannerID: AdString.bannerAdUnitID,
                  ),
                ]),
          );
        });
  }
}
