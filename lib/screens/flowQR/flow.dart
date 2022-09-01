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
      lowerBound: widget.qrModel.payload!.porcentage!/100,
      upperBound: widget.qrModel.payload!.porcentage!/100,
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animationController!.addListener(() => setState(() {}));
    _animationController!.repeat();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _animationController!.value * 100;
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
                Text(widget.qrModel.payload!.location!)
              ]))),
              Container(
                width: double.infinity,
                height: 75.0,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: LiquidLinearProgressIndicator(
                  value: _animationController!.value,
                  backgroundColor: const Color(0xfff2f2f2),
                  valueColor: const AlwaysStoppedAnimation(Color(0xff419388)),
                  borderRadius: 12.0,
                  borderWidth:2.1,
                  borderColor:Colors.black,
                  center: Text(
                    "${percentage.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ])));
  }
}
