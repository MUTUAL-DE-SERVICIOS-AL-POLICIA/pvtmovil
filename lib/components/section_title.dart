import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_provider/theme_provider.dart';

class SectiontitleComponent extends StatelessWidget {
  final String title;
  final String? subTitle;
  final IconData icon;
  final Function() onTap;
  final bool? stateLoading;
  const SectiontitleComponent(
      {Key? key,
      required this.title,
      this.subTitle,
      required this.icon,
      required this.onTap,
      this.stateLoading = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 15.sp),
      ),
      subtitle: subTitle != null
          ? Text(
              subTitle!,
            )
          : null,
      trailing: stateLoading!
          ? Image.asset(
              'assets/images/load.gif',
              fit: BoxFit.cover,
              height: 15.sp,
            )
          : Icon(
              icon,
              size: 15.sp,
            ),
      onTap: onTap,
    );
  }
}

class SectiontitleSwitchComponent extends StatelessWidget {
  final String title;
  final bool valueSwitch;
  final Function(bool) onChangedSwitch;
  const SectiontitleSwitchComponent(
      {Key? key,
      required this.title,
      required this.valueSwitch,
      required this.onChangedSwitch})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 15.sp),
      ),
      trailing: CupertinoSwitch(
        activeColor: ThemeProvider.themeOf(context).data.primaryColor,
        value: valueSwitch,
        onChanged: onChangedSwitch,
      ),
    );
  }
}
