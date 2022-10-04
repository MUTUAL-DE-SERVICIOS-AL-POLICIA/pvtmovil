import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/animate.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/heders.dart';
import 'package:muserpol_pvt/components/image_input.dart';
import 'package:muserpol_pvt/components/susessful.dart';
import 'package:muserpol_pvt/dialogs/dialog_action.dart';
import 'package:muserpol_pvt/main.dart';
import 'package:muserpol_pvt/model/economic_complement_model.dart';
import 'package:muserpol_pvt/model/files_model.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/screens/modal_enrolled/modal.dart';
import 'package:muserpol_pvt/screens/pages/complement/new_procedure/tab_info.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class StepperProcedure extends StatefulWidget {
  final Function(dynamic) endProcedure;
  const StepperProcedure({Key? key, required this.endProcedure})
      : super(key: key);

  @override
  State<StepperProcedure> createState() => _StepperProcedureState();
}

class _StepperProcedureState extends State<StepperProcedure> {
  TextEditingController phoneCtrl = TextEditingController();
  StepperType stepperType = StepperType.vertical;
  final TextRecognizer _textRecognizer = TextRecognizer();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool buttonLoading = false;
  @override
  void initState() {
    super.initState();
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false).state;
    observationAffiliate();
    if (userBloc.phone != null) {
      setState(() => phoneCtrl.text = userBloc.phone!);
    }
  }

  Future<void> observationAffiliate() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false).state;
    final procedureBloc = Provider.of<ProcedureBloc>(context, listen: false);
    var response = await serviceMethod(mounted, context, 'get', null,
        serviceEcoComProcedure(userBloc.procedureId!), true, true);
    if (response != null) {
      procedureBloc.add(UpdateEconomicComplement(
          economicComplementModelFromJson(response.body)));
      if (userBloc.phone != null) {
        setState(() => phoneCtrl.text = userBloc.phone!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    final userBloc =
        BlocProvider.of<UserBloc>(context, listen: true).state.user;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const HedersComponent(title: 'Nuevo trámite'),
                  Expanded(
                    child: Stepper(
                      onStepTapped: (step) => tapped(step),
                      type: stepperType,
                      physics: const ScrollPhysics(),
                      currentStep: appState.indexTabProcedure,
                      onStepContinue: nextPage,
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        return appState.indexTabProcedure > 0
                            ? buttonStep(context, details)
                            : Container();
                      },
                      steps: <Step>[
                        Step(
                          title: Text('Control de vivencia',
                              style: TextStyle(
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColorDark)),
                          content: Stack(
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () => initCtrlLive(),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/face.png',
                                        fit: BoxFit.cover,
                                        gaplessPlayback: true,
                                        width: 200,
                                        height: 200,
                                      ))),
                              Positioned(
                                  bottom: 2,
                                  right: 0,
                                  child: IconBtnComponent(
                                      iconText: 'assets/icons/camera.svg',
                                      onPressed: () => initCtrlLive()))
                            ],
                          ),
                          isActive: appState.indexTabProcedure >= 0,
                          state: appState.indexTabProcedure >= 0
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        if (!userBloc!.verified!)
                          for (var item in appState.files)
                            Step(
                              title: Text('Documento:',
                                  style: TextStyle(
                                      color: ThemeProvider.themeOf(context)
                                          .data
                                          .primaryColorDark)),
                              subtitle: Text(item.title!,
                                  style: TextStyle(
                                      color: ThemeProvider.themeOf(context)
                                          .data
                                          .primaryColorDark)),
                              content: ImageInput(
                                sizeImage: 250,
                                onPressed: (img, file) =>
                                    detectorText(img, file, item),
                                itemFile: item,
                              ),
                              isActive: appState.indexTabProcedure >= 0,
                              state: userBloc.verified!
                                  ? StepState.complete
                                  : item.imageFile != null
                                      ? StepState.complete
                                      : StepState.disabled,
                            ),
                        Step(
                          title: Text('Mis datos',
                              style: TextStyle(
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColorDark)),
                          content: TabInfoEconomicComplement(
                            onEditingComplete: () => nextPage(),
                            phoneCtrl: phoneCtrl,
                          ),
                          isActive: appState.indexTabProcedure >= 0,
                          state: appState.indexTabProcedure > 2
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buttonStep(BuildContext context, ControlsDetails details) {
    final procedureBloc =
        Provider.of<ProcedureBloc>(context, listen: true).state;
    final userBloc =
        BlocProvider.of<UserBloc>(context, listen: true).state.user;
    final appState = Provider.of<AppState>(context, listen: true);
    return ButtonComponent(
      stateLoading: buttonLoading,
      text: (!userBloc!.verified! ? appState.files.length : 0) + 1 ==
              details.stepIndex
          ? 'ENVIAR'
          : 'CONTINUAR',
      onPressed: procedureBloc.existInfoComplementInfo &&
              appState.stateLoadingProcedure
          ? details.onStepContinue!
          : null,
    );
  }

  tapped(int step) async {
    if (step == 0) return;
    final appState = Provider.of<AppState>(context, listen: false);
    if (step <= appState.indexTabProcedure) {
      await appState.updateStateLoadingProcedure(true);
      await appState.updateTabProcedure(step);
    }
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ComponentAnimate(
            child: DialogTwoAction(
                message: '¿DESEAS SALIR DEL PROCESO?',
                actionCorrect: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                messageCorrect: 'Salir')));
  }

  initCtrlLive() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false).state;
    final appState = Provider.of<AppState>(context, listen: false);
    return showBarModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        expand: false,
        context: context,
        builder: (context) => ModalInsideModal(nextScreen: (message) {
              return showSuccessful(context, message, () async {
                if (userBloc.user!.verified!) {
                  await appState.updateStateLoadingProcedure(true);
                  await appState.updateTabProcedure(appState.indexTabProcedure +
                      (!userBloc.user!.verified! ? appState.files.length : 0) +
                      1);
                } else {
                  await appState
                      .updateTabProcedure(appState.indexTabProcedure + 1);
                }
                if (!mounted) return;
                Navigator.pop(context);
              });
            }));
  }

  nextPage() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userBloc =
        BlocProvider.of<UserBloc>(context, listen: false).state.user;
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate() ||
        appState.indexTabProcedure !=
            (userBloc!.verified! ? 0 : appState.files.length) + 1) {
      await appState.updateStateLoadingProcedure(false);

      if (appState.indexTabProcedure ==
          (userBloc!.verified! ? 0 : appState.files.length) + 1) {
        if (prefs!.getBool('isDoblePerception')!) {
          return confirmDoblePercetionAlert();
        }
        return prepareDocuments();
      } else {
        appState.updateTabProcedure(appState.indexTabProcedure + 1);
        if (appState.indexTabProcedure ==
            (!userBloc.verified! ? appState.files.length : 0)) {
          await appState.updateStateLoadingProcedure(true);
        } else {
          if (appState.files[appState.indexTabProcedure].imageFile != null) {
            await appState.updateStateLoadingProcedure(true);
          } else {
            await appState.updateStateLoadingProcedure(false);
          }
        }
      }
    }
  }

  confirmDoblePercetionAlert() async {
    final appState = Provider.of<AppState>(context, listen: false);
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ComponentAnimate(
            child: DialogTwoAction(
                message: 'Usted está creando trámites como doble percepción',
                actionCorrect: () {
                  Navigator.of(context).pop();
                  prepareDocuments();
                },
                actionCancel: () async {
                  await appState.updateStateLoadingProcedure(true);
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                messageCorrect: 'Crear')));
  }

  detectorText(InputImage inputImage, File fileImage, FileDocument item) async {
    setState(() => buttonLoading = true);
    //VERIFICAMOS QUE LA IMAGEN COINCIDA CON LAS PALABRAS CLAVES
    final appState = Provider.of<AppState>(context, listen: false);
    appState.updateFile(item.id!, fileImage); //ACTUALIZAMOS LA IMAGEN CAPTURADA
    final recognizedText = await _textRecognizer
        .processImage(inputImage); //OBTENEMOS EL TEXTO DE LA IMAGEN
    if (item.wordsKey!.isNotEmpty) {
      //CONTIENE PALABRAS CLAVES
      for (var element in item.wordsKey!) {
        // LOOP POR CADA PALABRA CLAVE
        if (recognizedText.text.contains(element)) {
          // VERIFICAMOS SI LA IMAGEN CONTIENE LAS PALABRAS CLAVES
          await appState.updateStateFiles(
              item.id!, true); // CAMBIAMOS DE ESTADO
          await appState.updateStateLoadingProcedure(true);
          setState(() => buttonLoading = false);
        } else {
          debugPrint('NO HAY LA PALABRA $element');
          await appState.updateStateFiles(
              item.id!, false); // CAMBIAMOS DE ESTADO
          await appState.updateStateLoadingProcedure(
              false); //OCULTAMOS EL BTN DE CONTINUAR
          setState(() => buttonLoading = false);
          return;
        }
      }
    } else {
      //NO CONTIENE PALABRAS CLAVES
      await appState
          .updateStateLoadingProcedure(true); //MOSTRAMOS EL BTN DE CONTINUAR
      setState(() => buttonLoading = false);
    }
  }

  prepareDocuments() async {
    //PREPARAMOS LOS DOCUMENTOS SOLICITADOS
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false).state;
    final files = Provider.of<AppState>(context, listen: false).files;
    List<Map<String, String>> data = [];
    var countFiles = 0;
    if (!userBloc.user!.verified!) {
      for (var element in files) {
        Uint8List imagebytes = await element.imageFile!.readAsBytes();
        String base64 = base64Encode(imagebytes);
        data.add({
          'filename': '${userBloc.procedureId}_${element.imageName}',
          'content': base64,
        });
        countFiles++;
        if (countFiles == files.length) {
          sendInfo(data);
        }
      }
    } else {
      sendInfo([]);
    }
  }

  sendInfo(List<Map<String, String>> info) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false).state;
    final Map<String, dynamic> data = {
      'eco_com_procedure_id': userBloc.procedureId,
      'cell_phone_number': phoneCtrl.text.trim(),
      'attachments': info,
    };
    var response = await serviceMethod(mounted, context, 'post', data,
        serviceSendImagesProcedure(), true, true);
    if (response != null) {
      appState.updateStateProcessing(false);
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.endProcedure(response);
    } else {
      appState.updateStateLoadingProcedure(true);
    }
  }
}
