import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_provider/theme_provider.dart';

//  widget que se ajusta en la parte superior
class HedersComponent extends StatelessWidget {
  final String title;
  final bool stateBack;
  final bool menu;
  final Function()? onPressMenu;
  final bool center;
  const HedersComponent(
      {Key? key,
      required this.title,
      this.stateBack = false,
      this.menu = false,
      this.onPressMenu,
      this.center = false})
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
                      child: Icon(Icons.arrow_back_ios,
                          size: 17.sp,
                          color: ThemeProvider.themeOf(context).data.hintColor),
                    )),
              if (menu)
                GestureDetector(
                    onTap: () => onPressMenu!(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.menu,
                          size: 17.sp,
                          color: ThemeProvider.themeOf(context).data.hintColor),
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
        Center(
            child: Image.asset(
          'assets/icons/favicon.png',
          color: const Color(0xff419388),
          fit: BoxFit.cover,
          height: 40.sp,
        )),
      ],
    );
  }
}
