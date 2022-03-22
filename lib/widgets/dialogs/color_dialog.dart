import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorDialog extends StatefulWidget {
  const ColorDialog(
      {Key? key, this.onSelect, this.selectedColor, this.onCancel})
      : super(key: key);
  final Function(Color color)? onSelect;
  final Color? selectedColor;
  final VoidCallback? onCancel;
  @override
  _ColorDialogState createState() => _ColorDialogState();
}

class _ColorDialogState extends State<ColorDialog> {
  late Color selectingColor;
  @override
  void initState() {
    super.initState();
    selectingColor = widget.selectedColor ?? Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.antiAlias,
      actionsPadding: const EdgeInsets.all(5),
      content: SizedBox(
        height: 400,
        width: double.infinity,
        child: ColorPicker(
          pickerColor: selectingColor,
          pickerAreaBorderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2.0),
            topRight: Radius.circular(2.0),
          ),
          colorPickerWidth: 300.0,
          pickerAreaHeightPercent: 0.5,
          enableAlpha: true,
          displayThumbColor: true,
          labelTypes: const [],
          onColorChanged: (Color color) {
            // Handle color changes
            setState(() {
              selectingColor = color;
            });
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            if (widget.onCancel != null) widget.onCancel!();
            // Navigator.of(context).pop(selectingColor);
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            if (widget.onSelect != null) widget.onSelect!(selectingColor);

            // Navigator.of(context).pop(selectingColor);
          },
        ),
      ],
    );
  }
}
