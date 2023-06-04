import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tvapp/pages/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: router,
    routes: router._routes,
    initialLocation: '/',
  );
});

class RouterNotifier extends AutoDisposeAsyncNotifier<void>
    implements Listenable {
  final Ref _ref;

  VoidCallback? routerListener;
  bool isAuth = false;

  RouterNotifier(this._ref);

  @override
  void addListener(VoidCallback listener) {
    routerListener = listener;
  }

  @override
  FutureOr<void> build() async {
    ref.listenSelf((_, __) {
      if (state.isLoading) return;
      routerListener?.call();
    });
  }

  void removeListener(VoidCallback listener) {
    routerListener = null;
  }

  List<RouteBase> get _routes => [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => HomeScreen(),
        )
      ];
}
