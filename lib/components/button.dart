import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:theme_provider/theme_provider.dart';

class ButtonComponent extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool stateLoading;
  const ButtonComponent(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.stateLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 19),
        color: ThemeProvider.themeOf(context).data.primaryColor,
        disabledColor: Colors.grey,
        onPressed: onPressed,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          stateLoading
              ? Center(
                  child: Image.asset(
                  'assets/images/load.gif',
                  fit: BoxFit.cover,
                  height: 20,
                ))
              : Text(text,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
        ]));
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
        onPressed: onPressed,
        child: Text(
          text,
        ));
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
            side: const BorderSide(
              color: Colors.grey,
              width: 2.0,
            )),
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
  final String iconText;
  final Color? iconColor;
  final double? iconSize;
  const IconBtnComponent(
      {Key? key,
      required this.onPressed,
      required this.iconText,
      this.iconColor,
      this.iconSize = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {},
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      elevation: 2.0,
      fillColor: Colors.white,
      shape: const CircleBorder(),
      child: IconButton(
          iconSize: 40,
          icon: SvgPicture.asset(
            iconText,
            height: 100.0,
          ),
          onPressed: () => onPressed()),
    );
  }
}

class Buttontoltip extends StatelessWidget {
  final JustTheController tooltipController;
  final Function(bool) onPressed;
  const Buttontoltip(
      {Key? key, required this.tooltipController, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
        controller: tooltipController,
        showWhenUnlinked: true,
        barrierDismissible: true,
        isModal: true,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        backgroundColor:
            ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
        content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '¿Cuenta con un un carnet alfanumerico? Ej. 123456-7L',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWhiteComponent(
                        text: 'SI', onPressed: () => onPressed(true)),
                    ButtonWhiteComponent(
                        text: 'NO', onPressed: () => onPressed(false)),
                  ],
                )
              ],
            )),
        child: Material(
          color: ThemeProvider.themeOf(context).data.primaryColor,
          shape: const CircleBorder(),
          elevation: 0,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.question_mark_outlined,
              color: Colors.white,
            ),
          ),
        ));
  }
}
