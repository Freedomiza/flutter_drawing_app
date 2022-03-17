import 'package:drawer_app/generated/l10n.dart';
import 'package:drawer_app/routes/route_settings.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (ctx) => S.of(ctx).APP_NAME,
      routerDelegate: routeSettings.routerDelegate,
      routeInformationParser: routeSettings.routeInformationParser,
      localizationsDelegates: const [
        S.delegate,
      ],
    );
  }
}
