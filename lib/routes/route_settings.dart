import 'dart:typed_data';

import 'package:drawer_app/screens/drawing/drawing_screen.dart';
import 'package:drawer_app/screens/home/home_screen.dart';
import 'package:drawer_app/screens/preview/preview_screen.dart';
import 'package:go_router/go_router.dart';

final routeSettings = GoRouter(initialLocation: HomeScreen.routeUrl, routes: [
  GoRoute(
      name: HomeScreen.routeName,
      path: HomeScreen.routeUrl,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
            name: DrawingScreen.routeName,
            path: DrawingScreen.routeUrl,
            builder: (context, state) => const DrawingScreen(),
            routes: [
              GoRoute(
                  name: PreviewScreen.routeName,
                  path: PreviewScreen.routeUrl,
                  builder: (context, state) {
                    final params = state.extra as Map<String, dynamic>;

                    return PreviewScreen(
                      bytes: params['bytes']! as Uint8List,
                      pathHistory: params['pathHistory'],
                    );
                  }),
            ]),
      ]),
]);
