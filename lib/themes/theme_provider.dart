import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeDataNotifier, bool>(
    (ref) => ThemeDataNotifier());

class ThemeDataNotifier extends StateNotifier<bool> {
  late SharedPreferences prefs;

  ThemeDataNotifier() : super(false) {
    _init();
  }

  Future _init() async {
    prefs = await SharedPreferences.getInstance();
    var isDark = prefs.getBool("darkMode");
    state = isDark ?? false;
  }

  void switchTheme() async{
    state = !state;
    prefs.setBool("darkMode", state);
  }

}