import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/notification/notification_bloc.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/database/db_provider.dart';

class ScreenNotification extends StatefulWidget {
  const ScreenNotification({Key? key}) : super(key: key);

  @override
  State<ScreenNotification> createState() => _ScreenNotificationState();
}

class _ScreenNotificationState extends State<ScreenNotification> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      print('argumentos ${ModalRoute.of(context)!.settings.arguments}');
      await DBProvider.db.updateNotificationModelByContent(
          json.encode(ModalRoute.of(context)!.settings.arguments));
      final notificationBloc = BlocProvider.of<NotificationBloc>(context);
      DBProvider.db
          .getAllNotificationModel()
          .then((res) => notificationBloc.add(UpdateNotifications(res)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        json.decode(json.encode(ModalRoute.of(context)!.settings.arguments));
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child: Column(children: [
              HedersComponent(title: args!['title'], stateBack: true),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(children: [
                InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Image.network(args['image']))
              ]))),
            ])));
  }
}
