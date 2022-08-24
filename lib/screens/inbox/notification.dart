import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/notification/notification_bloc.dart';
import 'package:muserpol_pvt/components/headers.dart';
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
      final notificationBloc = BlocProvider.of<NotificationBloc>(context);
      debugPrint('argumentos ${ModalRoute.of(context)!.settings.arguments}');
      await DBProvider.db.updateNotificationModelByContent(
          json.encode(ModalRoute.of(context)!.settings.arguments));
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
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Column(children: [
              HedersComponent(title: args!['title'],titleExtra:args['PublicationDate'], stateBack: true),
              Expanded(
                  child: Stack(
                children: [
                  if (args['image'].length <= 0)
                  const Formtop(),
                  if (args['image'].length <= 0)
                  const FormButtom(),
                  Center(
                    child: SingleChildScrollView(
                        child: Column(
                          children: [
                          Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15.0),
                        child: Text(args['text'], textAlign: TextAlign.justify),
                      ),
                      if(args['text'].length > 0)
                      const Divider(
                        color: Colors.blueGrey,
                      ),
                      if (args['image'].length > 0)
                        InteractiveViewer(
                            minScale: 1,
                            maxScale: 4,
                            child: Image.network(args['image'])),
                    ])),
                  ),
                ],
              )),
            ])));
  }
}
