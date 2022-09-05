import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:muserpol_pvt/swipe/acept_conditions.dart';
import 'package:muserpol_pvt/swipe/liquid_page.dart';

class PageSlider extends StatefulWidget {
  const PageSlider({Key? key}) : super(key: key);

  @override
  State<PageSlider> createState() => _PageSliderState();
}

class _PageSliderState extends State<PageSlider> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: LiquidSwipe(
            pages: liquidPages,
            enableLoop: true,
            fullTransitionValue: 500,
            waveType: WaveType.liquidReveal,
            positionSlideIcon: 0.25,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showModalInside(),
            label: const Text(
              'EMPEZAR',
              style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ));
  }

  _showModalInside() async {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => const ModalAceptTermin(),
    );
  }
}
