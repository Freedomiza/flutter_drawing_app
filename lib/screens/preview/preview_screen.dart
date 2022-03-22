import 'dart:typed_data';

import 'package:drawer_app/models/history.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen(
      {Key? key, required Uint8List bytes, required HistoryModel pathHistory})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
