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
import 'package:muserpol_pvt/model/economic_complement_model.dart';
import 'package:muserpol_pvt/model/files_model.dart';
import 'package:muserpol_pvt/model/procedure_model.dart';
import 'package:muserpol_pvt/provider/app_state.dart';
import 'package:muserpol_pvt/screens/modal_enrolled/modal.dart';
import 'package:muserpol_pvt/screens/pages/procedure/new_procedure/tab_info.dart';
import 'package:muserpol_pvt/services/service_method.dart';
import 'package:muserpol_pvt/services/services.dart';
import 'package:muserpol_pvt/utils/save_document.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';


class StepperProcedure extends StatefulWidget {
  const StepperProcedure({Key? key}) : super(key: key);

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
    var response = await serviceMethod(context, 'get', null,
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
    final procedureBloc =
        Provider.of<ProcedureBloc>(context, listen: true).state;
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false).state.user;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  HedersComponent(title: 'Nuevo tramite'),
                  Expanded(
                    child: Stepper(
                      type: stepperType,
                      physics: ScrollPhysics(),
                      currentStep: appState.indexTabProcedure,
                      onStepContinue: nextPage,
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        return appState.indexTabProcedure>0? ButtonComponent(
                          stateLoading: buttonLoading,
                          text: appState.files.length + 1 == details.stepIndex
                              ? 'ENVIAR'
                              : 'CONTINUAR',
                          onPressed: procedureBloc.existInfoComplementInfo &&
                                  appState.stateLoadingProcedure
                              ? details.onStepContinue!
                              : null,
                        ):Container();
                      },
                      steps: <Step>[
                        Step(
                          title: new Text('Control de viviencia',style:TextStyle(color: ThemeProvider.themeOf(context).data.primaryColorDark )),
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
                                  right: -14,
                                  child: IconBtnComponent(
                                      icon: Icons.camera_alt,
                                      onPressed: () => initCtrlLive()))
                            ],
                          ),
                          isActive: appState.indexTabProcedure >= 0,
                          state: appState.indexTabProcedure >= 0
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        for (var item in appState.files)
                          Step(
                            title: new Text('Documento:', style:TextStyle(color: ThemeProvider.themeOf(context).data.primaryColorDark )),
                            subtitle: new Text(item.title!,style:TextStyle(color: ThemeProvider.themeOf(context).data.primaryColorDark )),
                            content: ImageInputComponent(
                              sizeImage: 200,
                              onPressed: (img, file) =>
                                  detectorText(img, file, item),
                              itemFile: item,
                            ),
                            isActive: appState.indexTabProcedure >= 0,
                            state: userBloc!.verified!?StepState.complete : item.imageFile != null
                                ? StepState.complete
                                : StepState.disabled,
                          ),
                        Step(
                          title: new Text('Mis datos',style:TextStyle(color: ThemeProvider.themeOf(context).data.primaryColorDark )),
                          content: TabInfoEconomicComplement(
                            onTap: () {},
                            onEditingComplete: () => nextPage(),
                            phoneCtrl: phoneCtrl,
                          ),
                          isActive: appState.indexTabProcedure >= 0,
                          state: appState.indexTabProcedure >= 2
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

  Future<bool> _onBackPressed() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ComponentAnimate(
            child: DialogTwoAction(
                message: '¿DESEAS CANCELAR EL PROCESO?',
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
                  await appState.updateTabProcedure(
                      appState.indexTabProcedure + appState.files.length + 1);
                } else {
                  await appState.updateTabProcedure(appState.indexTabProcedure + 1);
                }
                Navigator.pop(context);
              });
            }));
  }

  nextPage() async {
    final appState = Provider.of<AppState>(context, listen: false);
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      await appState.updateStateLoadingProcedure(false);
      print('ind ${appState.indexTabProcedure}');
      if (appState.indexTabProcedure == appState.files.length + 1) {
        prepareDocuments();
      } else {
        appState.updateTabProcedure(appState.indexTabProcedure + 1);
        if (appState.indexTabProcedure == appState.files.length) {
          await appState.updateStateLoadingProcedure(true);
        } else {
          await appState.updateStateLoadingProcedure(false);
        }
      }
    }
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
        if (!recognizedText.text.contains(element)) {
          // VERIFICAMOS SI LA IMAGEN CONTIENE LA PALABRA CLAVE
          await appState.updateStateFiles(item.id!, false); // CAMBIAMOS DE ESTADO
          await appState.updateStateLoadingProcedure(
              false); //OCULTAMOS EL BTN DE CONTINUAR
          setState(() => buttonLoading = false);
          return;
        }
      }
      setState(() => buttonLoading = false);
    } else {
      //NO CONTIENE PALABRAS CLAVES
      await appState
          .updateStateLoadingProcedure(true); //MOSTRAMOS EL BTN DE CONTINUAR
          setState(() => buttonLoading = false);
    }
  }

  prepareDocuments() async {
    //PREPARAMOS LOS DOCUMENTOS SOLICITADOS
    print('REPARAMOS LOS DOCUMENTOS SOLICITADOS');
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
    final procedureBloc = Provider.of<ProcedureBloc>(context, listen: false);
    final Map<String, dynamic> data = {
      'eco_com_procedure_id': userBloc.procedureId,
      'cell_phone_number': phoneCtrl.text.trim(),
      'attachments': info,
    };
    var response = await serviceMethod(
        context, 'post', data, serviceSendImagesProcedure(), true, true);
    if (response != null) {
      
      return showSuccessful(context, 'Trámite registrado correctamente',
          () async {
        String pathFile = await saveFile(
          context,
          'Trámites',
          'sol_eco_com_${DateTime.now().millisecondsSinceEpoch}.pdf',
          response,
        );
        setState(() {
          appState.updateTabProcedure(0);
          // tabController!.animateTo(0);
          appState.clearFiles();
        });
        await Permission.storage.request();
        await Permission.manageExternalStorage.request();
        await Permission.accessMediaLocation.request();
        Directory documentDirectory =
            await Directory('/storage/emulated/0/Muserpol/pruebas')
                .create(recursive: true);
        String documentPath = documentDirectory.path;
        var imagen = File(
            '$documentPath/imagen${DateTime.now().millisecondsSinceEpoch}.txt');
        imagen.writeAsString('$data');

        // card.currentState!.collapse();
        await getEconomicComplement();
        await getProcessingPermit();
        await getObservations();
        procedureBloc.add(UpdateStateComplementInfo(false));
        appState.updateStateProcessing(false);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        await OpenFile.open(pathFile);
      });
    } else {
      appState.updateStateLoadingProcedure(true);
    }
  }

  getEconomicComplement() async {
    //REINICIO DEL LISTADO DE TRÁMITES VIGENTES
    final procedureBloc =
        BlocProvider.of<ProcedureBloc>(context, listen: false);
    var response = await serviceMethod(context, 'get', null,
        serviceGetEconomicComplements(0, true), true, true);
    if (response != null) {
      procedureBloc.add(UpdateCurrentProcedures(
          procedureModelFromJson(response.body).data!.data!));
    }
  }

  getObservations() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    var response = await serviceMethod(context, 'get', null,
        serviceGetObservation(userBloc.state.user!.id!), true, true);
    if (response != null) {
      appState.updateObservation(json.decode(response.body)['message']);
    }
  }

  getProcessingPermit() async {
    //REVISANDO SI TIENE UN NUEVO TRÁMITE
    final appState = Provider.of<AppState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    var response = await serviceMethod(context, 'get', null,
        serviceGetProcessingPermit(userBloc.state.user!.id!), true, true);
    if (response != null) {
      userBloc.add(UpdateCtrlLive(
          json.decode(response.body)['data']['liveness_success']));
      if (json.decode(response.body)['data']['liveness_success']) {
        print('HIZO SU CONTROL DE VIVIENCIA');
        if (userBloc.state.user!.verified!) {
          appState.updateTabProcedure(1 + appState.files.length);
          appState.updateStateLoadingProcedure(
              true); //MOSTRAMOS EL BTN DE CONTINUAR
        } else {
          appState.updateTabProcedure(1);

          appState.updateStateLoadingProcedure(
              false); //OCULTAMOS EL BTN DE CONTINUAR
        }
      } else {
        appState.updateTabProcedure(0);
        appState
            .updateStateLoadingProcedure(false); //OCULTAMOS EL BTN DE CONTINUAR
      }
      userBloc.add(UpdateProcedureId(
          json.decode(response.body)['data']['procedure_id']));
      userBloc.add(UpdatePhone(
          json.decode(response.body)['data']['cell_phone_number'][0]));
      appState.updateStateProcessing(true);
    }
  }

  continued() {
    print('siguiente');
    // _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }
}
