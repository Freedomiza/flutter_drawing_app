import 'package:flutter/material.dart';

enum SpacingDirection { vertical, horizontal }

class Spacing extends StatelessWidget {
  const Spacing(
    this.space, {
    Key? key,
    this.direction = SpacingDirection.vertical,
  }) : super(key: key);

  final double space;
  final SpacingDirection direction;

  @override
  Widget build(BuildContext context) {
    final double spacing = 15 * space;
    return SizedBox(
      height: direction == SpacingDirection.vertical ? spacing : null,
      width: direction == SpacingDirection.horizontal ? spacing : null,
    );
  }

  static Spacing horizontal(double space) {
    return Spacing(space, direction: SpacingDirection.horizontal);
  }
}
