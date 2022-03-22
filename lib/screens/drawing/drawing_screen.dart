import 'package:drawer_app/generated/l10n.dart';
import 'package:drawer_app/resources/draw_const.dart';

import 'package:drawer_app/screens/drawing/providers/frame_provider.dart';
import 'package:drawer_app/screens/drawing/widgets/footer_bar/drawing_footer_bar.dart';
import 'package:drawer_app/screens/drawing/widgets/header_bar/drawing_header_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './widgets/painter/drawing_tool.dart';

class DrawingScreen extends ConsumerStatefulWidget {
  static String routeName = 'drawing';
  static String routeUrl = '/drawing';
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends ConsumerState<DrawingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(frameProvider.notifier).setOrientation(DrawOrientation.vertical);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(frameProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).DRAWING_SCREEN),
      ),
      body: Stack(
        children: [
          Container(
            child: provider.isZero
                ? const SizedBox.shrink()
                : DrawingTool(
                    frame: provider,
                  ),
          ),
          const DrawingHeaderBar(),
          const DrawingFooterBar()
        ],
      ),
    );
  }
}
