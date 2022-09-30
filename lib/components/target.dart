import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

TargetFocus target(String identify, GlobalKey<State<StatefulWidget>> keyTarget, ContentAlign align, AlignmentGeometry? alignSkip, String title,
    Widget? child, ShapeLightFocus? shape, double? radius,VerticalDirection? verticalDirection) {
  return TargetFocus(
    identify: identify,
    keyTarget: keyTarget,
    alignSkip: alignSkip,
    contents: [
      TargetContent(
        align: align,
        builder: (context, controller) {
          return Column(
            verticalDirection : verticalDirection ?? VerticalDirection.down,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  )),
              child ?? Container()
            ],
          );
        },
      ),
    ],
    shape: shape,
    radius: radius,
  );
}
