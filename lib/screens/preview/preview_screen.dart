import 'dart:typed_data';
import 'package:drawer_app/generated/l10n.dart';
import 'package:drawer_app/models/history.dart';
import 'package:drawer_app/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PreviewScreen extends StatefulWidget {
  static String routeName = "preview";
  static String routeUrl = "preview";

  const PreviewScreen({Key? key, this.bytes, this.pathHistory})
      : super(key: key);

  final Uint8List? bytes;
  final HistoryModel? pathHistory;
  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  S get l10n => S.current;

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      color: Styles.greyColor.withOpacity(0.66),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.VIEW_CANVAS),
        actions: [_buildSaveButton(context)],
      ),
      body: Container(
        decoration: boxDecoration,
        child: Center(child: Container(child: _buildPreviewPicture(context))),
      ),
    );
  }

  Widget _buildPreviewPicture(BuildContext context) {
    if (widget.bytes == null) return Container();
    return Hero(tag: "hero_image_", child: Image.memory(widget.bytes!));
  }

  Widget _buildSaveButton(BuildContext context) {
    return IconButton(
      icon: const Icon(MdiIcons.contentSave),
      onPressed: () {
        print("save");
      },
    );
  }
}
