import 'package:drawer_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DrawingScreen extends StatelessWidget {
  static String routeName = 'drawing';

  static String routeUrl = '/drawing';

  const DrawingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).DRAWING_SCREEN),
      ),
      body: Container(),
    );
  }
}
