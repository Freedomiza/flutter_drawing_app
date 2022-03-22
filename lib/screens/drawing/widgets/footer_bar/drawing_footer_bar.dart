import 'package:drawer_app/models/action_type.dart';
import 'package:drawer_app/resources/styles.dart';
import 'package:drawer_app/screens/drawing/providers/painter_provider.dart';
import 'package:drawer_app/widgets/buttons/footer_button.dart';
import 'package:drawer_app/widgets/dialogs/color_dialog.dart';
import 'package:drawer_app/widgets/dialogs/shape_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'dart:io' show Platform;

class DrawingFooterBar extends ConsumerStatefulWidget {
  const DrawingFooterBar({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DrawingFooterBarState();
}

class _DrawingFooterBarState extends ConsumerState<DrawingFooterBar> {
  String _currentTools = '';

  // PopupMenu menu;
  @override
  void initState() {
    super.initState();
    _currentTools = 'Pencil';
  }

  Widget _buildFooterButton(
      {required Icon icon,
      String tooltips = '',
      VoidCallback? onPress,
      VoidCallback? onLongPress}) {
    // if(onLongPress is no)
    return FooterButton(
        tooltips: tooltips,
        icon: icon,
        color: tooltips == _currentTools
            ? Theme.of(context).primaryColorDark.withOpacity(0.75)
            : Colors.transparent,
        onPress: onPress,
        onLongPress: onLongPress);

    /* return FooterButton(
      tooltips: tooltips,
      icon: icon,
      color: tooltips == _currentTools
          ? Theme.of(context).primaryColorDark.withOpacity(0.75)
          : Colors.transparent,
      onPress: onPress,
    ); */
  }

  _pickStroke() {
    final controller = ref.read<PainterController>(painterProvider);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 200,
            child: Column(
              children: [
                Text("Stroke size: ${controller.thickness}px"),
                const Spacer(),
                Slider(
                    label: "Thickness ${controller.thickness}px",
                    value: controller.thickness,
                    onChanged: (value) {
                      // print(value);
                      setState(() {
                        controller.thickness = value.floorToDouble();
                      });
                    },
                    min: 1,
                    divisions: 60,
                    // divisions: 3,
                    max: 60),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(controller.thickness),
                    child: Container(
                      width: controller.thickness,
                      height: controller.thickness,
                      color: controller.drawColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: [
            //Resetting to default stroke value
            TextButton(
              child: const Icon(Icons.check),
              onPressed: () {
                // _strokeWidth = 3.0;
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Color?> _colorDialog() async {
    final controller = ref.watch(painterProvider);

    return showDialog<Color>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ColorDialog(
            selectedColor: controller.drawColor,
            onSelect: (Color color) {
              Navigator.of(context).pop(color);
            },
            onCancel: () {
              Navigator.of(context).pop(null);
            });
      },
    );
  }

  // Future<String> _showTextDialog() async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return TextDialog(
  //           onOK: (String text) {
  //             Navigator.of(context).pop(text);
  //           },
  //           onCancel: () {
  //             Navigator.of(context).pop(null);
  //           },
  //         );
  //       });
  // }

  Future<ActionTypeModel?> _shapePickerDialog() async {
    /* final controller =
        Provider.of<PainterController>(context).value; */

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return ShapePickerDialog(onShapeSelect: (ActionTypeModel? mode) {
            // print(mode);
            Navigator.of(context).pop(mode);
          }, onCancel: () {
            Navigator.of(context).pop(null);
          });
        });
  }

  List<Widget> _buildFooterButtons() {
    final controller = ref.read(painterProvider);

    return [
      _buildFooterButton(
        icon: Icon(Icons.edit,
            color: _currentTools == "Pencil"
                ? Styles.lightGreyColor
                : Styles.darkColor),
        tooltips: "Pencil",
        onPress: () async {
          setState(() {
            controller.resetMode();
            _currentTools = "Pencil";
          });
        },
        onLongPress: () async {
          await _pickStroke();
          setState(() {
            controller.resetMode();
            _currentTools = "Pencil";
          });
        },
      ),
      _buildFooterButton(
          icon: Icon(Icons.color_lens,
              color: _currentTools == "Color"
                  ? Styles.lightGreyColor
                  : Styles.darkColor),
          tooltips: "Color",
          onPress: () async {
            print('Chose color');
            var color = await _colorDialog();
            if (color != null) {
              setState(() {
                controller.drawColor = color;
              });
            }
          },
          onLongPress: () {}),
      _buildFooterButton(
          icon: Icon(MdiIcons.rectangle,
              color: _currentTools == "Background"
                  ? Styles.lightGreyColor
                  : Styles.darkColor),
          tooltips: "Background",
          onPress: () async {
            var color = await _colorDialog();
            if (color != null) {
              setState(() {
                controller.backgroundColor = color;
              });
            }
          },
          onLongPress: () {}),
      _buildFooterButton(
          icon: Icon(
            MdiIcons.eraser,
            color: _currentTools == "Eraser"
                ? Styles.lightGreyColor
                : Styles.darkColor,
          ),
          tooltips: "Eraser",
          onPress: () {
            setState(() {
              controller.eraser = !controller.eraser;
              _currentTools = "Eraser";
            });
            print('Chose eraser mode $controller.eraser');
          },
          onLongPress: () {}),
      _buildFooterButton(
          icon: Icon(controller.zoomMode ? MdiIcons.cancel : MdiIcons.magnify,
              color: _currentTools == "Zoom"
                  ? Styles.lightGreyColor
                  : Styles.darkColor),
          tooltips: "Zoom",
          onPress: () {
            // print('Toggle zoom');
            setState(() {
              _currentTools = "Zoom";

              controller.setZoomMode(!controller.zoomMode);
            });
          },
          onLongPress: () {}),

      _buildFooterButton(
          icon: Icon(MdiIcons.shape,
              color: _currentTools == "Shape"
                  ? Styles.lightGreyColor
                  : Styles.darkColor),
          tooltips: "Shape",
          onPress: () async {
            _currentTools = "Shape";
            ActionTypeModel? shape = await _shapePickerDialog();
            if (shape != null) {
              controller.setPathHistory(controller.pathHistory..mode = shape);
            }
          },
          onLongPress: () {}),
      // _buildFooterButton(
      //     icon: Icon(MdiIcons.formatColorFill,
      //         color: Theme.of(context).backgroundColor),
      //     tooltips: "Fill",
      //     onPress: () {
      //       print('Chose Pencils');
      //     }),
      _buildFooterButton(
          icon: Icon(Icons.text_fields,
              color: _currentTools == "Text"
                  ? Styles.lightGreyColor
                  : Styles.darkColor),
          tooltips: "Text",
          onPress: () async {
            print('Chose Text');
            // var text = await _showTextDialog();
            setState(() {
              _currentTools = "Text";
              controller.changeMode(ActionTypeModel.Text);
            });
          },
          onLongPress: () {}),
      _buildFooterButton(
          icon: Icon(MdiIcons.selectDrag,
              color: _currentTools == "Select"
                  ? Styles.lightGreyColor
                  : Styles.darkColor),
          tooltips: "Select",
          onPress: () {
            print('Chose Hand');
            setState(() {
              var selectMode = controller.selectMode;
              if (!selectMode) {
                controller.selectMode = !selectMode;
                _currentTools = "Select";
              } else {
                _currentTools = "Pencil";
                controller.resetMode();
              }
            });
          },
          onLongPress: () {}),
      _buildFooterButton(
          icon: Icon(Icons.layers,
              color: _currentTools == "Layers"
                  ? Styles.lightGreyColor
                  : Styles.darkColor),
          tooltips: "Layers",
          onPress: () {
            print('Chose Pencils');
          },
          onLongPress: () {}),
      // IconButton(
      //   icon: Icon(Icons.delete),
      //   tooltip: 'Clear',
      //   onPressed: () => widget.controller.clear(),
      // ),
      _buildFooterButton(
          icon: Icon(controller.gridMode ? Icons.grid_on : Icons.grid_off,
              color: _currentTools == "Grid"
                  ? Styles.lightGreyColor
                  : Styles.darkColor),
          tooltips: "Grid",
          onPress: () {
            print('Chose Grid ${!controller.gridMode}');
            setState(() {
              controller.gridMode = !controller.gridMode;
            });
          },
          onLongPress: () {}),
      _buildFooterButton(
          icon: Icon(MdiIcons.delete,
              color: _currentTools == "Clear"
                  ? Styles.lightGreyColor
                  : Styles.darkColor),
          tooltips: "Clear",
          onPress: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                  title: const Text("Confirm discard"),
                  content: const Text(
                      "Are you sure you want to discard your paint?"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        controller.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                  ]),
            );
          },
          onLongPress: () {}),
      // _buildFooterButton(
      //     icon: Icon(MdiIcons.contentSave,
      //         color: _currentTools == "Save"
      //             ? Styles.lightGreyColor
      //             : Styles.darkColor),
      //     tooltips: "Save",
      //     onPress: () async {
      //       Uint8List bytes = await controller.exportAsPNGBytes();
      //       Navigator.of(context)
      //           .push(MaterialPageRoute(builder: (BuildContext context) {
      //         return PreviewScreen(
      //           bytes: bytes,
      //         );
      //       }));
      //     },
      //     onLongPress: () {}),
    ];
  }

  onClickMenu(dynamic item) {}

  void onDismiss() {}

  @override
  Widget build(BuildContext context) {
    // PopupMenu.context = context;
    final List<Widget> stack = [
      _buildDraggableBottomSheet(),
    ];

    if (Platform.isIOS) {
      stack.add(_buildWhiteBlock());
    }
    return Stack(children: stack);
  }

  Positioned _buildWhiteBlock() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
          width: double.infinity, height: 40, color: Styles.lightGreyColor),
    );
  }

  DraggableScrollableSheet _buildDraggableBottomSheet() {
    return DraggableScrollableSheet(
      minChildSize: 0.1,
      maxChildSize: 0.22,
      initialChildSize: 0.12,
      builder: (context, scrollController) {
        final boxDecoration = BoxDecoration(
            color: Styles.lightGreyColor,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Styles.lightGreyColor.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(-2, -4), // changes position of shadow
              ),
            ],
            border: Border.all(
                width: 1, color: Styles.greyColor.withOpacity(0.57)));

        return Container(
          decoration: boxDecoration,
          child: ListView.builder(
              controller: scrollController,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  children: [
                    Container(
                        width: double.infinity,
                        // color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
                        // alignment: Alignment.le,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 10.0,
                          runSpacing: 20.0,
                          direction: Axis.horizontal,
                          children: _buildFooterButtons(),
                        )),
                    buildDragableIcon(context),
                  ],
                );
              }),
        );
      },
    );
  }

  Positioned buildDragableIcon(BuildContext context) {
    return Positioned(
      top: 0,
      left: MediaQuery.of(context).size.width / 2 - 12,
      child: const SizedBox(
        child: Icon(MdiIcons.dragHorizontal, color: Styles.greyColor),
      ),
    );
  }
}
