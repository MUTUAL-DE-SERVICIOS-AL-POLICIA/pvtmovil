import 'package:flutter/material.dart';
import 'package:muserpol_pvt/model/files_model.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:math' as math;

TargetFocus targetBottomNagigation1(GlobalKey<State<StatefulWidget>> keyTarget, StateAplication stateApp) {
  return TargetFocus(identify: "keyBottomNavigation1", keyTarget: keyTarget, alignSkip: Alignment.topRight, contents: [
    TargetContent(
      align: ContentAlign.top,
      builder: (context, controller) {
        return Column(
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  stateApp == StateAplication.complement ? "Aquí podrá ver su trámite solicitado" : "Aquí podrá ver sus aportes",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                )),
            Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(180),
                child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(15 / 180),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/images/arrow.png',
                        color: Colors.white,
                        height: 100,
                      ),
                    )))
          ],
        );
      },
    ),
  ]);
}

TargetFocus targetBottomNavigation2(GlobalKey<State<StatefulWidget>> keyTarget, StateAplication stateApp) {
  return TargetFocus(
    identify: "keyBottomNavigation2",
    keyTarget: keyTarget,
    alignSkip: Alignment.topRight,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) {
          return Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    stateApp == StateAplication.complement ? "Aquí podrá ver el historial de sus trámites" : "Aquí podrá ver sus préstamos",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              Transform.rotate(
                angle: math.pi / 7,
                child: Image.asset(
                  'assets/images/arrow.png',
                  color: Colors.white,
                  height: 100,
                ),
              ),
            ],
          );
        },
      ),
    ],
  );
}

TargetFocus targetCreateProcedure(GlobalKey<State<StatefulWidget>> keyTarget) {
  return TargetFocus(
    identify: "keyCreateProcedure",
    keyTarget: keyTarget,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return Column(
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Para crear su trámite debe presionar el botón CREAR TRÁMITE, cuando se encuentre en color verde",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(45),
                  child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(130 / 180),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/arrow.png',
                          color: Colors.white,
                          height: 80,
                        ),
                      )))
            ],
          );
        },
      ),
    ],
    shape: ShapeLightFocus.RRect,
    radius: 20,
  );
}

TargetFocus targetNotification(GlobalKey<State<StatefulWidget>> keyTarget) {
  return TargetFocus(
    identify: "keyNotification",
    keyTarget: keyTarget,
    alignSkip: Alignment.bottomRight,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return Column(
            children: <Widget>[
              Transform.rotate(
                angle: math.pi / 7,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(180),
                  child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(120 / 180),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/arrow.png',
                          color: Colors.white,
                          height: 80,
                        ),
                      )))),
              const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "BUZÓN DE NOTIFICACIONES\nAquí podrá observar todos los mensajes enviados por la MUSERPOL",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ],
          );
        },
      ),
    ],
  );
}

TargetFocus targetMenu(GlobalKey<State<StatefulWidget>> keyTarget) {
  return TargetFocus(identify: "keyMenu", keyTarget: keyTarget, contents: [
    TargetContent(
      align: ContentAlign.bottom,
      builder: (context, controller) {
        return Column(
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  "MENÚ\nAquí podrá ingresar al menú de datos y configuraciones",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                )),
            RotationTransition(
                turns: const AlwaysStoppedAnimation(100 / 180),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/arrow.png',
                    color: Colors.white,
                    height: 80,
                  ),
                ))
          ],
        );
      },
    ),
  ]);
}

TargetFocus targetRefresh(GlobalKey<State<StatefulWidget>> keyTarget) {
  return TargetFocus(identify: "keyRefresh", keyTarget: keyTarget, contents: [
    TargetContent(
      align: ContentAlign.top,
      builder: (context, controller) {
        return Column(
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  "ACTUALIZAR\nPresionando este botón usted podrá actualizar la pantalla",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                )),
            Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(10),
                child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(40 / 180),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/images/arrow.png',
                        color: Colors.white,
                        height: 80,
                      ),
                    )))
          ],
        );
      },
    ),
  ]);
}
