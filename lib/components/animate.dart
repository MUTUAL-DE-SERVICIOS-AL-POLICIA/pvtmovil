import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ComponentAnimate extends StatelessWidget {
  final Widget child;
  const ComponentAnimate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      animate: true,
      child: child);
  }
}