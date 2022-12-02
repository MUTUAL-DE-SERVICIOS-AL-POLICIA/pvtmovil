import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muserpol_pvt/screens/inbox/screen_inbox.dart';

import '../bloc/notification/notification_bloc.dart';

//  widget que se ajusta en la parte superior
class HedersComponent extends StatefulWidget {
  final String? titleHeader;
  final String? title;
  final bool center;
  final bool? stateBell;
  final GlobalKey? keyNotification;
  final bool? stateIconMuserpol;
  const HedersComponent(
      {Key? key,
      this.titleHeader,
      this.title = '',
      this.center = false,
      this.stateBell = false,
      this.keyNotification,
      this.stateIconMuserpol = true})
      : super(key: key);

  @override
  State<HedersComponent> createState() => _HedersComponentState();
}

class _HedersComponentState extends State<HedersComponent> {
  @override
  Widget build(BuildContext context) {
    final notificationBloc = BlocProvider.of<NotificationBloc>(context, listen: true).state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(leadingWidth: 20, title: Text(widget.titleHeader ?? '', style: const TextStyle(fontWeight: FontWeight.w500)), actions: [
          if (widget.stateBell!)
            Badge(
              key: widget.keyNotification,
              animationDuration: const Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              badgeColor: notificationBloc.existNotifications
                  ? notificationBloc.listNotifications!.where((e) => e.read == false && e.idAffiliate == notificationBloc.affiliateId).isNotEmpty
                      ? Colors.red
                      : Colors.transparent
                  : Colors.transparent,
              elevation: 0,
              badgeContent: notificationBloc.existNotifications && notificationBloc.listNotifications!.where((e) => e.read == false).isNotEmpty
                  ? Text(
                      notificationBloc.listNotifications!
                          .where((e) => e.read == false && e.idAffiliate == notificationBloc.affiliateId)
                          .length
                          .toString(),
                      style: const TextStyle(color: Colors.white),
                    )
                  : Container(),
              child: GestureDetector(
                onTap: () => dialogInbox(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SvgPicture.asset(
                    'assets/icons/bell.svg',
                    height: 25.sp,
                    color: const Color(0xff419388),
                  ),
                ),
              ),
            ),
          if (widget.stateIconMuserpol!)
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 10),
                child: Image.asset(
                  'assets/icons/favicon.png',
                  color: const Color(0xff419388),
                  width: 30,
                )),
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(widget.title!,
              textAlign: widget.center ? TextAlign.center : TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
        ),
        const SizedBox(height: 30)
      ],
    );
  }

  dialogInbox(BuildContext context) {
    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => const ScreenInbox());
  }
}
