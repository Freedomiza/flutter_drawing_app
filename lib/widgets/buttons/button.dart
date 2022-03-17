import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  const AppButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: Colors.blue,
        textColor: Colors.white,
        highlightColor: Colors.blue.shade700,
        splashColor: Colors.blueAccent,
        // elevation: 1,
        // style: ButtonStyle(
        //   backgroundColor: MaterialStateProperty.resolveWith(
        //     (states) {
        //       // If the button is pressed, return green, otherwise blue
        //       if (states.contains(MaterialState.pressed)) {
        //         return Colors.blue.withOpacity(.6);
        //       }
        //       return Colors.blue;
        //     },
        //   ),
        //   foregroundColor: MaterialStateProperty.resolveWith(
        //     (states) {
        //       // If the button is pressed, return green, otherwise blue
        //       if (states.contains(MaterialState.pressed)) {
        //         return Colors.blue;
        //       }
        //       return Colors.white;
        //     },
        //   ),
        //   textStyle:
        //       MaterialStateProperty.all(const TextStyle(color: Colors.white)),
        // ),
        onPressed: onPressed,
        child: child);
  }
}
