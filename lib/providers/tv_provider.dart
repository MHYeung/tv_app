import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../const/playList.dart';

final tvProvider = Provider((ref) => PlayerNotifier(ref));

class PlayerNotifier extends AutoDisposeAsyncNotifier<void>
    implements Listenable {
  final Ref _ref;

  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  late String channelTitle = '';
  late bool isPlayerReady = false;

  YoutubePlayerController get tv => _controller;

  PlayerNotifier(this._ref) : super() {
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
  }

  void listener() {
    if (isPlayerReady && !_controller.value.isFullScreen) {
      _playerState = _controller.value.playerState;
      _videoMetaData = _controller.metadata;
      channelTitle = _controller.metadata.title;
    }
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  FutureOr<void> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }
}
