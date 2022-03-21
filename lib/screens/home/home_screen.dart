import 'package:drawer_app/screens/drawing/drawing_screen.dart';
import 'package:drawer_app/utils/size_config.dart';
import 'package:drawer_app/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:drawer_app/generated/l10n.dart';

class HomeScreen extends ConsumerWidget {
  static String routeName = 'home';
  static String routeUrl = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final counter = ref.watch(counterProvider);
    // final counterNotifier = ref.read(counterProvider.notifier);
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).APP_NAME),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
              child: AppButton(
            child: Text(S.of(context).NEW_DRAWING),
            onPressed: () {
              context.goNamed(DrawingScreen.routeName);
            },
          )),
          const Spacer(),
        ],
      ),
    );
  }
}
