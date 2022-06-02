import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_provider/theme_provider.dart';

class ButtonComponent extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const ButtonComponent({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 19),
        splashColor: Colors.transparent,
        color: ThemeProvider.themeOf(context).data.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(text,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
        ]),
        onPressed: onPressed);
  }
}

class ButtonWhiteComponent extends StatelessWidget {
  final String text;
  final Color? colorText;
  final Function() onPressed;
  const ButtonWhiteComponent(
      {Key? key, required this.text, required this.onPressed, this.colorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 0),
        splashColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(text,
              style: TextStyle(
                fontSize: 15.sp,
                color: ThemeProvider.themeOf(context).data.primaryColor,
              )),
        ]),
        onPressed: onPressed);
  }
}

class ButtonWhiteComponentOutlined extends StatelessWidget {
  final String text;
  final Color? colorText;
  final FontWeight? fontWeight;
  final bool iconState;
  final Function() onPressed;
  const ButtonWhiteComponentOutlined(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.iconState = false,
      this.colorText,
      this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 15),
        splashColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: const Color(0xfff2f2f2),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(text,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: ThemeProvider.themeOf(context).data.primaryColor,
              ))
        ]),
        onPressed: onPressed);
  }
}

class ButtonOptionsComponent extends StatelessWidget {
  final String text;
  final Color? colorText;
  final Function() onPressed;
  const ButtonOptionsComponent(
      {Key? key, required this.text, required this.onPressed, this.colorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: GestureDetector(
            onTap: onPressed,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600])),
                    Row(
                      children: [
                        const Text('Seleccionar',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey)),
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          size: 35,
                          color:
                              ThemeProvider.themeOf(context).data.primaryColor,
                        )
                      ],
                    )
                  ],
                ))));
  }
}

class ButtonDate extends StatelessWidget {
  final String text;
  final Color? colorText;
  final FontWeight? fontWeight;
  final bool iconState;
  final Function() onPressed;
  const ButtonDate(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.iconState = false,
      this.colorText,
      this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        elevation: 0,
        focusElevation: 0,
        autofocus: true,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Colors.grey,
              width: 2.0,
            )),
        // color: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(text,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: ThemeProvider.themeOf(context).data.primaryColor,
              )),
        ]));
  }
}

class IconBtnComponent extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  const IconBtnComponent(
      {Key? key,
      required this.onPressed,
      required this.icon,
      this.iconColor,
      this.iconSize = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {},
      elevation: 2.0,
      fillColor: Colors.white,
      child: IconButton(
          iconSize: iconSize,
          icon: Icon(
            icon,
            color: const Color(0xff419388),
          ),
          onPressed: () => onPressed()),
      padding: const EdgeInsets.all(0),
      shape: const CircleBorder(),
    );
  }
}
