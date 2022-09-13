import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:muserpol_pvt/bloc/notification/notification_bloc.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/containers.dart';
import 'package:muserpol_pvt/database/db_provider.dart';
import 'package:muserpol_pvt/dialogs/dialog_action.dart';
import 'package:muserpol_pvt/main.dart';
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
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
            if (notificationBloc.existNotifications)
              Text(
                  '${notificationBloc.listNotifications!.where((e) => e.idAffiliate == prefs!.getInt('idAffiliate')).isEmpty ? 'Sin' : notificationBloc.listNotifications!.where((e) => e.idAffiliate == prefs!.getInt('idAffiliate')).length} Notificación(es)',
                  style: const TextStyle(
                      fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      if (!notificationBloc.existNotifications ||
                          notificationBloc.listNotifications!.isEmpty)
                        Column(
                          children: [
                            Image.asset(
                              'assets/icons/clouds.png',
                              fit: BoxFit.cover,
                              height: 100.sp,
                            ),
                            const Text(
                              'No tienes mensajes para leer',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      if (notificationBloc.existNotifications)
                        for (final item in notificationBloc
                            .listNotifications!.reversed
                            .where((e) => e.idAffiliate == prefs!.getInt('idAffiliate')))
                          messageWidget(item)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        ButtonComponent(
          text: 'Cerrar',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ));
  }

  Widget messageWidget(NotificationModel item) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'message',
          arguments: json.decode(item.content)),
      child: ContainerComponent(
          color: item.read
              ? ThemeProvider.themeOf(context).data.scaffoldBackgroundColor
              : const Color.fromARGB(255, 235, 218, 192),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Row(
              children: [
                Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Titulo: ',
                              style: TextStyle(
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp),
                            ),
                            Flexible(
                                child: Text(
                              item.title,
                              style: TextStyle(
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColor,
                                  fontSize: 16.sp),
                            ))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Fecha: ',
                              style: TextStyle(
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp),
                            ),
                            Flexible(
                                child: Text(
                              DateFormat('EEE dd, MMMM', "es_ES")
                                  .format(item.date),
                              style: TextStyle(
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColor,
                                  fontSize: 16.sp),
                            )),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Hora: ',
                              style: TextStyle(
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp),
                            ),
                            Flexible(
                                child: Text(
                              DateFormat('kk:mm', "es_ES").format(item.date),
                              style: TextStyle(
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColor,
                                  fontSize: 16.sp),
                            )),
                          ],
                        ),
                      ],
                    )),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => deleteMessage(item),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        'assets/icons/delete.svg',
                        height: 25.sp,
                        color: Colors.red[900],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  deleteMessage(NotificationModel item) async {
    final notificationBloc =
        BlocProvider.of<NotificationBloc>(context, listen: false);
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ComponentAnimate(
            child: DialogTwoAction(
                message: 'Deseas eliminar la notificación ${item.title} ?',
                actionCorrect: () async {
                  await DBProvider.db.deleteNotificationModelById(item.id!);
                  await DBProvider.db.getAllNotificationModel().then(
                      (res) => notificationBloc.add(UpdateNotifications(res)));
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                messageCorrect: 'Eliminar')));
  }
}
