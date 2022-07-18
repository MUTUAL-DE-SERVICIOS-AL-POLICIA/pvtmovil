import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:muserpol_pvt/components/button.dart';

class TabInfo extends StatelessWidget {
  final String text;
  final Function() nextScreen;
  const TabInfo({Key? key, required this.text, required this.nextScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: text != ''
          ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Flexible(
                    child: Text(
                  text,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 20.sp),
                )),
                const SizedBox(
                  height: 20,
                ),
                ButtonComponent(
                  text: 'INICIAR',
                  onPressed: () => nextScreen(),
                )
              ]),
            )
          : Center(
              child: Image.asset(
              'assets/images/load.gif',
              fit: BoxFit.cover,
              height: 20,
            )),
    );
  }
}
