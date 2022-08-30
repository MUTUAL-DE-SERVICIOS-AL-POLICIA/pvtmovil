import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/model/qr_model.dart';
class ScreenWorkFlow extends StatefulWidget {
  final QrModel qrModel;
  const ScreenWorkFlow({Key? key, required this.qrModel}) : super(key: key);
  @override
  State<ScreenWorkFlow> createState() => _ScreenWorkFlowState();
}
class _ScreenWorkFlowState extends State<ScreenWorkFlow> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
    @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    // _animationController.addListener(() => setState(() {}));
    // _animationController.repeat();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
            child: Column(children: [
              HedersComponent(title: 'Trámite ${widget.qrModel.payload!.code!}', stateBack: true),
              Text(
                widget.qrModel.payload!.moduleDisplayName!,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: 10.h,
                ),
                const Text('Tipo de Trámite: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${widget.qrModel.payload!.procedureTypeName!}:'),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  '${widget.qrModel.payload!.title!}:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    for (final person in widget.qrModel.payload!.person!)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Text('- ${person.fullName!}'),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                const Text('Ubicación del trámite:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.qrModel.payload!.location!),
                // const Text('Estado del trámite:'),
                // Text(widget.qrModel.payload!.stateName!)
              ]))),
              LiquidLinearProgressIndicator(
                value: _animationController!.value,
                valueColor: AlwaysStoppedAnimation(Colors.black), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.red,
                borderWidth: 5.0,
                borderRadius: 12.0,
                direction: Axis
                    .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                center: Text(
            "25%",
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
              ),
              // Container(
              //       decoration: const BoxDecoration(
              //         boxShadow: <BoxShadow>[
              //           BoxShadow(
              //             color: Color(0xffffdead),
              //             blurRadius: 4.0,
              //           ),
              //         ],
              //       ),
              //       child: Padding(
              //           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Text(widget.qrModel.payload!.stateName!),
              //               Icon(
              //                 Icons.brightness_1,
              //                 color: !widget.qrModel.payload!.validated! ? Colors.red : null,
              //               )
              //             ],
              //           ))),
            ])));
  }
}