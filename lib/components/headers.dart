import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muserpol_pvt/bloc/notification/notification_bloc.dart';
import 'package:muserpol_pvt/screens/inbox/screen_inbox.dart';
import 'package:badges/badges.dart' as badges;

// widget que se ajusta en la parte superior
class HedersComponent extends StatefulWidget {
  final String? titleHeader;
  final String? title;
  final bool center;
  final bool? stateBell;
  final GlobalKey? keyNotification;
  final bool? stateIconMuserpol;
  const HedersComponent(
      {super.key,
      this.titleHeader,
      this.title = '',
      this.center = false,
      this.stateBell = false,
      this.keyNotification,
      this.stateIconMuserpol = true});

  @override
  State<HedersComponent> createState() => _HedersComponentState();
}

class _HedersComponentState extends State<HedersComponent> {
  @override
  Widget build(BuildContext context) {
    final notificationBloc =
        BlocProvider.of<NotificationBloc>(context, listen: true).state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
            // correccion: Cambiado de 30 a 56 (el valor por defecto de Flutter es 56, cumple con el mínimo de 48dp)
            leadingWidth: 56,
            title: Text(widget.titleHeader ?? 'MUSERPOL',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              if (widget.stateBell!)
                badgeNotification(context, notificationBloc),
            ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(widget.title!,
              textAlign: widget.center ? TextAlign.center : TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
        )
      ],
    );
  }

  Widget badgeNotification(
      BuildContext context, NotificationState notificationBloc) {
    final countNotification = notificationBloc.listNotifications.where((e) =>
        e.read == false && e.idAffiliate == notificationBloc.affiliateId);

    // correccion: Agregado Semantics para que el lector de pantalla reconozca la campana como un botón
    return Semantics(
      label:
          'Notificaciones${countNotification.isNotEmpty ? ', ${countNotification.length} sin leer' : ''}',
      button: true,
      excludeSemantics:
          true, // Evita que lea "Container, Badge..." y solo lea la etiqueta limpia
      child: GestureDetector(
        onTap: () => dialogInbox(context),
        child: Container(
          color: Colors.transparent,
          // correccion: Ajustado el padding para garantizar exactamente 48dp de alto mínimo para el área tocable
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 11.5),
          child: badges.Badge(
            key: widget.keyNotification,
            badgeStyle: badges.BadgeStyle(
              badgeColor: notificationBloc.existNotifications
                  ? countNotification.isNotEmpty
                      ? Colors.red
                      : Colors.transparent
                  : Colors.transparent,
              elevation: 0,
            ),
            badgeContent: notificationBloc.existNotifications &&
                    countNotification.isNotEmpty
                ? Text(
                    '${countNotification.length}',
                    style: const TextStyle(color: Colors.white),
                  )
                : Container(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SvgPicture.asset('assets/icons/bell.svg',
                  height: 25.sp,
                  colorFilter: const ColorFilter.mode(
                      Color(0xff419388), BlendMode.srcIn)),
            ),
          ),
        ),
      ),
    );
  }

  dialogInbox(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const ScreenInbox());
  }
}
