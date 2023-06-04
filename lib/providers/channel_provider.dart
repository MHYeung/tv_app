import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvapp/const/playList.dart';
import 'package:tvapp/providers/tv_provider.dart';

final channelProvider =
    StateNotifierProvider<ChannelNotifier, int>((ref) => ChannelNotifier(ref));

class ChannelNotifier extends StateNotifier<int> {
  final Ref _ref;
  ChannelNotifier(this._ref) : super(0) {
    _init();
  }

  late SharedPreferences prefs;

  Future _init() async {
    prefs = await SharedPreferences.getInstance();
    int channelIndex = prefs.getInt("channel") ?? 0;
    state = channelIndex;
  }

  void previousChannel(){
    if(state>0){
      state = state -1;
      _ref.read(tvProvider).tv.load(Playlist.id[state]);
    }

  }

  void nextChannel(){
    if(state < Playlist.id.length -1){
      state = state +1;
      _ref.read(tvProvider).tv.load(Playlist.id[state]);
    }
    
  }

  void switchChannel(int newChannelIndex) {
    state = newChannelIndex;
    _ref.read(tvProvider).tv.load(Playlist.id[state]);
    prefs.setInt("channel", state);
  }
}
