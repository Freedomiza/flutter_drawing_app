import 'package:flutter/material.dart';

class FooterButton extends StatelessWidget {
  const FooterButton({
    Key? key,
    required this.tooltips,
    required this.color,
    required this.icon,
    required this.onPress,
    this.onLongPress,
  }) : super(key: key);

  final String tooltips;
  final Color color;
  final Icon icon;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      key: Key(tooltips),
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(
            child: icon,
            width: 40,
            height: 40,
          ),
          onTap: onPress,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}
