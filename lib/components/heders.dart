import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theme_provider/theme_provider.dart';

//  widget que se ajusta en la parte superior
class HedersComponent extends StatelessWidget {
  final String? titleHeader;
  final String title;
  final String? titleExtra;
  final bool stateBack;
  final bool menu;
  final Function()? onPressMenu;
  final bool center;
  final GlobalKey? keyMenu;
  final Widget? option;
  const HedersComponent(
      {Key? key,
      this.titleHeader = 'MUSERPOL',
      required this.title,
      this.titleExtra,
      this.stateBack = false,
      this.menu = false,
      this.onPressMenu,
      this.center = false,
      this.keyMenu,
      this.option})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (stateBack)
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        'assets/icons/back.svg',
                        height: 17.sp,
                        color: ThemeProvider.themeOf(context).data.hintColor,
                      ),
                    )),
              if (menu)
                GestureDetector(
                    key: keyMenu,
                    onTap: () => onPressMenu!(),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        'assets/icons/menu.svg',
                        height: 17.sp,
                        color: ThemeProvider.themeOf(context).data.hintColor,
                      ),
                    )),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$titleHeader'),
                    Text(title,
                        textAlign: center ? TextAlign.center : TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
                    if (titleExtra != null) Text(titleExtra!, style: const TextStyle(fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ],
          ),
        ),
        Image.asset(
          'assets/icons/favicon.png',
          color: const Color(0xff419388),
          fit: BoxFit.cover,
          height: 40.sp,
        ),
        if (option != null) option!
      ],
    );
  }
}
