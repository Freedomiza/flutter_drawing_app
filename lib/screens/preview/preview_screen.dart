import 'dart:typed_data';
import 'package:drawer_app/generated/l10n.dart';
import 'package:drawer_app/models/history.dart';
import 'package:drawer_app/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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
        _handleSave();
      },
    );
  }

  final _textFieldController = TextEditingController();

  Future<void> _handleSave() async {
    var status = await Permission.storage.request();

    final text = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Input picture name'),
        content: TextField(
          onChanged: (value) {},
          controller: _textFieldController,
          decoration: const InputDecoration(hintText: "my canvas etc ..."),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              _textFieldController.clear();
              Navigator.of(ctx).pop(null);
            },
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              Navigator.of(ctx).pop(_textFieldController.value.text);
            },
          ),
        ],
      ),
    );
    if (text == null || text! is String) {
      return;
    }
    if (widget.bytes != null && status.isGranted) {
      final saveData = widget.bytes;
      final result = await ImageGallerySaver.saveImage(saveData!,
          name: text, isReturnImagePathOfIOS: true);
      print(result);
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: const Text('Cannot request storage permission!'),
            );
          });
    }
  }
}
