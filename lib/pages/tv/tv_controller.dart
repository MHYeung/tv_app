import 'package:get/get.dart';
import 'package:tvapp/services/admob/ad_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../const/playList.dart';

class TVController extends GetxController {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  var isPlayerReady = false.obs;
  var channelTitle = ''.obs;

  YoutubePlayerController get tv => _controller;

  @override
  void onInit() {
    _controller = YoutubePlayerController(
      initialVideoId: Playlist.id.first,
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
    super.onInit();
  }

  void listener() {
    if (isPlayerReady.value &&
        !_controller.value.isFullScreen &&
        this.initialized) {
      _playerState = _controller.value.playerState;
      _videoMetaData = _controller.metadata;
      channelTitle.value = _controller.metadata.title;
      update();
    }
  }

  previousChannel() {
    AdManager.showIntAd(() => tv.load(Playlist.id[
        (Playlist.id.indexOf(tv.metadata.videoId) - 1) % Playlist.id.length]));
  }

  nextChannel() {
    AdManager.showIntAd(() => tv.load(Playlist.id[
        (Playlist.id.indexOf(tv.metadata.videoId) + 1) % Playlist.id.length]));
  }

  void goToChannel(String e) {
    AdManager.showIntAd(
        () => _controller.load(Playlist.id[Playlist.titles.indexOf(e)]));
    update();
  }

  @override
  void onClose() {
    _controller.pause();
    super.onClose();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
