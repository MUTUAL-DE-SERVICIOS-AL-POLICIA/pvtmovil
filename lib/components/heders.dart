import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theme_provider/theme_provider.dart';

//  widget que se ajusta en la parte superior
class HedersComponent extends StatelessWidget {
  final String title;
  final bool stateBack;
  final bool menu;
  final Function()? onPressMenu;
  final bool center;
  final GlobalKey? keyMenu;
  const HedersComponent(
      {Key? key,
      required this.title,
      this.stateBack = false,
      this.menu = false,
      this.onPressMenu,
      this.center = false,
      this.keyMenu})
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
                    child: Padding(
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
                    child: Padding(
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
                    const Text('MUSERPOL'),
                    Text(title,
                        textAlign: center ? TextAlign.center : TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.sp)),
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
      ],
    );
  }
}
