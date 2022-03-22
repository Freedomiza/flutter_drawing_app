import 'package:drawer_app/generated/assets.gen.dart';
import 'package:drawer_app/models/action_type.dart';
import 'package:drawer_app/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShapePickerDialog extends StatefulWidget {
  const ShapePickerDialog({Key? key, this.onShapeSelect, this.onCancel})
      : super(key: key);
  final void Function(ActionTypeModel? value)? onShapeSelect;
  final VoidCallback? onCancel;
  @override
  _ShapePickerDialogState createState() => _ShapePickerDialogState();
}

class _ShapePickerDialogState extends State<ShapePickerDialog> {
  final List<dynamic> shapes = [
    {
      'name': 'rounded_shape',
      'color': Colors.white,
      'asset': Assets.images.roundedShape.path,
      'mode': ActionTypeModel.ShapeRound
    },
    {
      'name': 'oval_shape',
      'color': Colors.white,
      'asset': Assets.images.ovalShape.path,
      'mode': ActionTypeModel.ShapeOval
    },
    {
      'name': 'triangle_shape',
      'color': Colors.white,
      'asset': Assets.images.triangleShape.path,
      'mode': ActionTypeModel.ShapeTriangle
    },
    {
      'name': 'rectangle_shape',
      'color': Colors.white,
      'asset': Assets.images.rectangleShape.path,
      'mode': ActionTypeModel.ShapeSquare
    },
    {
      'name': 'line_shape',
      'color': Colors.white,
      'asset': Assets.images.lineShape.path,
      'mode': ActionTypeModel.Line
    },
    /*   {
      'name': 'bezier_curve_shape',
      'color': Colors.white,
      'asset': LocalAssets.CUBICBEZIERCURVE_SHAPE
    } */
  ];
  @override
  Widget build(BuildContext context) {
    final shapeWidgets = shapes.map<Widget>((dynamic shape) {
      // print(shape);
      return TextButton(
        onPressed: () {
          if (widget.onShapeSelect != null) {
            widget.onShapeSelect!(shape['mode']);
          }
        },
        child: SizedBox(
          // padding: EdgeInsets.all(Styles.defaultPadding),
          width: 80,
          height: 80,
          /* decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.black)), */
          // color: Colors.amber,
          key: Key(shape['name']),
          child: SvgPicture.asset(shape['asset']),
        ),
      );
    });
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: GridView.count(
          crossAxisCount: 2,
          primary: false,
          padding: const EdgeInsets.all(Styles.defaultPadding),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: shapeWidgets.toList()),
    );
  }
}
