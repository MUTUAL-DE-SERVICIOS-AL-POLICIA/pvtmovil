import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/bloc/notification/notification_bloc.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/database/db_provider.dart';
import 'package:theme_provider/theme_provider.dart';

class ScreenInbox extends StatefulWidget {
  const ScreenInbox({Key? key}) : super(key: key);

  @override
  State<ScreenInbox> createState() => _ScreenInboxState();
}

class _ScreenInboxState extends State<ScreenInbox> {
  @override
  Widget build(BuildContext context) {
    final notificationBloc =
        BlocProvider.of<NotificationBloc>(context, listen: true).state;
    return ComponentAnimate(
        child: AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Container(
        height: 400,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Text('Buzón de mensajes'),
            if (notificationBloc.existNotifications)
              for (final item in notificationBloc.listNotifications!.reversed)
                messageWidget(item)
          ],
        )),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ButtonWhiteComponent(
              text: 'Aceptar',
              onPressed: () => Navigator.of(context).pop(),
            )),
            if (notificationBloc.existNotifications &&
                notificationBloc.listNotifications!
                    .where((e) => e.selected == true)
                    .isNotEmpty)
              Expanded(
                  child: ButtonWhiteComponent(
                      text: 'Eliminar', onPressed: () => deleteMessage()))
          ],
        )
      ],
    ));
  }

  Widget messageWidget(NotificationModel item) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'message',
          arguments: json.decode(item.content)),
      child: ContainerComponent(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Titulo: ${item.title}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: item.read
                                  ? ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColorDark
                                  : ThemeProvider.themeOf(context)
                                      .data
                                      .scaffoldBackgroundColor,
                              fontWeight: item.read
                                  ? FontWeight.w300
                                  : FontWeight.bold),
                        ),
                        Text(
                          'Fecha: ${DateFormat('EEE dd, MMMM', "es_ES").format(item.date)}',
                          style: TextStyle(
                              color: item.read
                                  ? ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColorDark
                                  : ThemeProvider.themeOf(context)
                                      .data
                                      .scaffoldBackgroundColor,
                              fontWeight: item.read
                                  ? FontWeight.w300
                                  : FontWeight.bold),
                        ),
                        Text(
                          'Hora: ${DateFormat('kk:mm', "es_ES").format(item.date)}',
                          style: TextStyle(
                              color: item.read
                                  ? ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColorDark
                                  : ThemeProvider.themeOf(context)
                                      .data
                                      .scaffoldBackgroundColor,
                              fontWeight: item.read
                                  ? FontWeight.w300
                                  : FontWeight.bold),
                        ),
                      ],
                    )),
                Expanded(
                  flex: 1,
                  child: Checkbox(
                    value: item.selected,
                    onChanged: (value) {
                      print('value $value');
                      setState(() {
                        item.selected = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          color: item.read
              ? ThemeProvider.themeOf(context).data.scaffoldBackgroundColor
              : ThemeProvider.themeOf(context).data.primaryColor),
    );
  }

  deleteMessage() async {
    final notificationBloc =
        BlocProvider.of<NotificationBloc>(context, listen: false);
    for (var item in notificationBloc.state.listNotifications!
        .where((e) => e.selected == true)) {
      await DBProvider.db.deleteNotificationModelById(item.id!);
    }
    await DBProvider.db
        .getAllNotificationModel()
        .then((res) => notificationBloc.add(UpdateNotifications(res)));
  }
}
