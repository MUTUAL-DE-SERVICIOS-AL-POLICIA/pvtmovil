import 'package:flutter/material.dart';

class ContainerComponent extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color color;
  const ContainerComponent(
      {Key? key,
      required this.child,
      this.width,
      this.height,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: color,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 1.0,
                  offset: Offset(0, 0.5),
                )
              ],
            ),
            child: child));
  }
}
