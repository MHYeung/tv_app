// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:launch_review/launch_review.dart';
// import 'package:tvapp/pages/tv/tv_controller.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import '../../const/ad_strings.dart';
// import '../../const/playList.dart';
// import '../../widgets/banner_ad_widget.dart';

// class TVScreen extends GetView<TVController> {
//   const TVScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//         player: YoutubePlayer(
//           controller: controller.tv,
//           showVideoProgressIndicator: false,
//           onReady: ()=> controller.isPlayerReady.value = true,
//         ),
//         builder: (context, player) => Scaffold(body: SafeArea(
//           child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//             player,
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                           primary: Colors.indigoAccent
//                       ),
//                       icon: Icon(Icons.share),
//                       onPressed: () => LaunchReview.launch(),
//                       label: Text('分享給朋友'),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           primary: Colors.indigoAccent
//                       ),
//                       onPressed: controller.previousChannel,
//                       child: Text('上一個頻道'),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             primary: Colors.indigoAccent
//                         ),
//                         child: Text('下一個頻道'),
//                         onPressed: controller.nextChannel,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             _space,
//             Expanded(
//               flex: 1,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: Container(child: Obx(() =>  Text(controller.channelTitle.value))),
//               ),
//             ),
//             Expanded(
//               flex: 10,
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Wrap(
//                     spacing: 5,
//                     runSpacing: 10,
//                     crossAxisAlignment: WrapCrossAlignment.center,
//                     runAlignment: WrapAlignment.center,
//                     children: Playlist.titles
//                         .map((e) => ActionChip(
//                       backgroundColor: (Playlist.id[Playlist.titles.indexOf(e)] ==
//                           controller.tv.metadata.videoId)
//                           ? Colors.orange
//                           : Colors.brown,
//                       avatar: CircleAvatar(
//                           child: Text('${Playlist.titles.indexOf(e) + 1}')),
//                       onPressed: () => controller.goToChannel(e),
//                       label: Text(e),
//                     ))
//                         .toList()
//                         .cast<Widget>(),
//                   ),
//                 ),
//               ),
//             ),
//             BannerAdWidget(bannerID: AdString.bannerAdUnitID,),
//           ]),
//         ),));
//   }
// }

// Widget get _space => const SizedBox(height: 5);
