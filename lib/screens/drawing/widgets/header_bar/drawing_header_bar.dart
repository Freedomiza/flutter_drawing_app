import 'dart:typed_data';
import 'package:drawer_app/resources/styles.dart';
import 'package:drawer_app/screens/preview/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:drawer_app/screens/drawing/providers/painter_provider.dart';

class DrawingHeaderBar extends ConsumerStatefulWidget {
  final VoidCallback? onReset;
  final List<Widget> actions;

  const DrawingHeaderBar({
    Key? key,
    this.onReset,
    this.actions = const [],
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DrawingHeaderBarState();
}

class _DrawingHeaderBarState extends ConsumerState<DrawingHeaderBar> {
  bool _expanded = true;
  bool _finished = false;
  List<Widget> _buildCollapsedActions(BuildContext context) {
    final controller = ref.read(painterProvider);
    return [
      IconButton(
          icon: const Icon(MdiIcons.eye),
          onPressed: () async {
            Uint8List bytes = await controller.exportAsPNGBytes();
            context.goNamed(PreviewScreen.routeName, extra: {
              "bytes": bytes,
              "pathHistory": controller.pathHistory,
            });
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (BuildContext context) {
            //   return PreviewScreen(
            //       bytes: bytes, pathHistory: controller.pathHistory);
            // }));
          }),
      // IconButton(
      //   icon: Icon(MdiIcons.dotsVertical),
      //   color: Styles.panelColor,
      //   onPressed: () {
      //     setState(() {
      //       _expanded = !_expanded;
      //     });
      //   },
      // )
    ];
  }

  List<Widget> _buildExpandedActions(BuildContext context) {
    final controller = ref.read(painterProvider);

    List<Widget> actions = [];
    if (_finished) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
            _finished = false;
            if (widget.onReset != null) widget.onReset!();
          }),
        ),
      );
    } else {
      actions.addAll([
        IconButton(
          icon: const Icon(Icons.undo),
          tooltip: 'Undo',
          onPressed: controller.canUndo
              ? () {
                  if (controller.canUndo) {
                    setState(() {
                      controller.undo();
                    });
                  }
                }
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.redo),
          tooltip: 'Redo',
          onPressed: controller.canRedo
              ? () {
                  if (controller.canRedo) {
                    controller.redo();
                  }
                }
              : null,
        ),
        IconButton(
            icon: const Icon(MdiIcons.eye),
            onPressed: () async {
              Uint8List bytes = await controller.exportAsPNGBytes();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return PreviewScreen(
                    bytes: bytes, pathHistory: controller.pathHistory);
              }));
            }),
        IconButton(
            icon: const Icon(MdiIcons.contentSave),
            onPressed: () async {
              Uint8List bytes = await controller.exportAsPNGBytes();
              // TODO: add save method
              // BlocProvider.of<DrawingCubit>(context).addFrame(
              //     bytes: bytes,
              //     context: context,
              //     history: controller.pathHistory);
              // Navigator.of(context).popUntil((route) {
              //   return route.settings.name == FrameDesignScreen.routeName;
              // });
            }),
      ]);
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      right: MediaQuery.of(context).size.width * 0.05,
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 200),
        width: _expanded ? MediaQuery.of(context).size.width * 0.9 : 150,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Styles.greyColor),
          color: Styles.lightGreyColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: [
            _buildActionsPanel(context),
            _buildBackButton(context),
            _buildToggleExpandButton(context)
          ],
        ),
      ),
    );
  }

  Positioned _buildToggleExpandButton(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: IconButton(
        icon: const Icon(MdiIcons.dotsVertical),
        color: Styles.darkColor,
        onPressed: () {
          setState(() {
            _expanded = !_expanded;
          });
        },
      ),
    );
  }

  Positioned _buildBackButton(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Styles.darkColor,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Container _buildActionsPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      // width: _expanded ? MediaQuery.of(context).size.width * 0.9 : 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: !_expanded
            ? _buildCollapsedActions(context)
            : _buildExpandedActions(context),
      ),
    );
  }
}
