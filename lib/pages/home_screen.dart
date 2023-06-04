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
                  Expanded(flex: 4, child: player),
                  AutoSizeText(ref.watch(tvProvider).tv.metadata.title, maxLines: 3,style: TextStyle(fontWeight: FontWeight.bold),),
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ElevatedButton(
                          child: AutoSizeText(
                            '下一個頻道',
                            maxLines: 1,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            ref.read(channelProvider.notifier).nextChannel();
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  AutoSizeText(
                    '頻道列表',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                                            AdManager.showIntAd(() => ref
                                                .read(channelProvider.notifier)
                                                .switchChannel(Playlist.titles
                                                    .indexOf(channel)));
                                          },
                                          child: Card(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CircleAvatar(
                                                      backgroundColor:
                                                          channelIndex ==
                                                                  Playlist
                                                                      .titles
                                                                      .indexOf(
                                                                          channel)
                                                              ? Colors.orange
                                                              : Colors
                                                                  .brown[400],
                                                      child: AutoSizeText(
                                                          "${Playlist.titles.indexOf(channel) + 1}")),
                                                  Text(channel, style: TextStyle(fontWeight: FontWeight.bold),),
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
