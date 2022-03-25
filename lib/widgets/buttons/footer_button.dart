import 'package:flutter/material.dart';

class FooterButton extends StatelessWidget {
  const FooterButton({
    Key? key,
    required this.tooltips,
    required this.color,
    required this.icon,
    required this.onPress,
    this.size = 32.0,
    this.onLongPress,
  }) : super(key: key);
  final double size;
  final String tooltips;
  final Color color;
  final Icon icon;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
          maximumSize: MaterialStateProperty.all(Size(size, size)),
          minimumSize: MaterialStateProperty.all(Size(size, size)),
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all<CircleBorder>(
              CircleBorder(side: BorderSide(color: color)))),
      child: icon,
    );
  }
}
