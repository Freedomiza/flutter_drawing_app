import 'package:drawer_app/screens/drawing/drawing_screen.dart';
import 'package:drawer_app/screens/home/home_screen.dart';
import 'package:go_router/go_router.dart';

final routeSettings = GoRouter(initialLocation: HomeScreen.routeUrl, routes: [
  GoRoute(
      name: HomeScreen.routeName,
      path: HomeScreen.routeUrl,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          name: DrawingScreen.routeName,
          path: DrawingScreen.routeName,
          builder: (context, state) => const DrawingScreen(),
        ),
      ]),
]);
