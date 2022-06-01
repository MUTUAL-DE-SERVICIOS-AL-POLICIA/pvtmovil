import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:muserpol_pvt/bloc/procedure/procedure_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/button.dart';
import 'package:muserpol_pvt/components/image_input.dart';
import 'package:muserpol_pvt/components/susessful.dart';
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
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class CardNewProcedure extends StatefulWidget {
  const CardNewProcedure({Key? key}) : super(key: key);

  @override
  State<CardNewProcedure> createState() => _CardNewProcedureState();
}

class _CardNewProcedureState extends State<CardNewProcedure>
    with TickerProviderStateMixin {
  TextEditingController phoneCtrl = TextEditingController();

  final GlobalKey<ExpansionTileCardState> card = GlobalKey();
  TabController? tabController;
  final TextRecognizer _textRecognizer = TextRecognizer();
  ProcedureModel? procedure;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool continueProcedure = false;
  double valueHeigth = 2.5;
  @override
  void initState() {
    super.initState();
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false).state;
    final appState = Provider.of<AppState>(context, listen: false);
    if (userBloc.phone != null) {
      setState(() => phoneCtrl.text = userBloc.phone!);
    }
    if (userBloc.controlLive) {
      if (userBloc.user!.verified!) {
        appState
            .updateStateLoadingProcedure(true); //OCULTAMOS EL BTN DE CONTINUAR
      } else {
        appState
            .updateStateLoadingProcedure(false); //OCULTAMOS EL BTN DE CONTINUAR
      }
    } else {
      appState
          .updateStateLoadingProcedure(false); //OCULTAMOS EL BTN DE CONTINUAR
    }

    tabController = TabController(
        initialIndex: userBloc.user!.verified!
            ? userBloc.controlLive
                ? appState.files.length
                : appState.indexTabProcedure
            : appState.indexTabProcedure,
        vsync: this,
        length: !userBloc.controlLive
            ? appState.files.length + 2
            : appState.files.length + 1);
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: true).state;
    final appState = Provider.of<AppState>(context, listen: true);
    final procedureBloc =
        Provider.of<ProcedureBloc>(context, listen: true).state;
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Form(
            key: formKey,
            child: ExpansionTileCard(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              expandedColor:
                  ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
              baseColor:
                  ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
              key: card,
              leading: CircleAvatar(
                  backgroundColor:
                      ThemeProvider.themeOf(context).data.primaryColor,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
              title: const Text('CREAR NUEVO TRÁMITE',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xff419388))),
              onExpansionChanged: (expands) {
                if (expands) {
                  observationAffiliate();
                  setState(() => valueHeigth = 2.5);
                  if (tabController!.index == tabController!.length - 1) {
                    setState(() => valueHeigth = 4);
                  }
                }
              },
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height <
                          MediaQuery.of(context).size.width / 1.65
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.height / valueHeigth,
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: [
                      if (!userBloc.controlLive)
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                    child: Text('CONTROL DE VIVENCIA')),
                                Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/certificado.png',
                                          fit: BoxFit.cover,
                                          gaplessPlayback: true,
                                          width: 200,
                                          height: 200,
                                        )),
                                    Positioned(
                                        bottom: 2,
                                        right: -14,
                                        child: IconBtnComponent(
                                            icon: Icons.camera_alt,
                                            onPressed: () => initCtrlLive()))
                                  ],
                                ),
                              ],
                            )),
                      for (var item in appState.files)
                        ImageInputComponent(
                          sizeImage: valueHeigth * 80,
                          text: item.validateState
                              ? item.title!
                              : item.textValidate!,
                          onPressed: (img, file) =>
                              detectorText(img, file, item),
                          itemFile: item,
                        ),
                      TabInfoEconomicComplement(
                        onTap: () {},
                        onEditingComplete: () => nextPage(),
                        phoneCtrl: phoneCtrl,
                      )
                    ],
                  ),
                ),
                if (procedureBloc.existInfoComplementInfo &&
                    appState.stateLoadingProcedure)
                  ButtonWhiteComponent(
                      text: tabController!.index == tabController!.length - 1
                          ? 'Enviar'
                          : 'Continuar',
                      onPressed: () => nextPage()
                      //=> prepareDocuments()
                      ),
              ],
            )));
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
                  appState.updateTabProcedure(
                      tabController!.index + appState.files.length + 1);
                  tabController!.animateTo(
                      tabController!.index + appState.files.length + 1);
                  appState.updateStateLoadingProcedure(true);
                } else {
                  setState((() {
                    appState.updateTabProcedure(tabController!.index + 1);
                    tabController!.animateTo(tabController!.index + 1);
                  }));
                }
                Navigator.pop(context);
              });
            }));
  }

  detectorText(InputImage inputImage, File fileImage, FileDocument item) async {
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
          appState.updateStateFiles(item.id!, false); // CAMBIAMOS DE ESTADO
          appState.updateStateLoadingProcedure(
              false); //OCULTAMOS EL BTN DE CONTINUAR
          return;
        }
      }
    } else {
      //NO CONTIENE PALABRAS CLAVES
      appState
          .updateStateLoadingProcedure(true); //MOSTRAMOS EL BTN DE CONTINUAR
    }
  }

  nextPage() async {
    final appState = Provider.of<AppState>(context, listen: false);
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      appState.updateStateLoadingProcedure(false);
      if (tabController!.index == tabController!.length - 1) {
        prepareDocuments();
      } else {
        appState.updateTabProcedure(tabController!.index + 1);
        tabController!.animateTo(tabController!.index + 1);
        if (tabController!.index == tabController!.length - 1) {
          appState.updateStateLoadingProcedure(true);
          setState(() {
            valueHeigth = 4;
          });
        }
      }
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
          tabController!.animateTo(0);
          appState.clearFiles();
        });
        card.currentState!.collapse();
        await getEconomicComplement();
        await getProcessingPermit();
        procedureBloc.add(UpdateStateComplementInfo(false));
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

  getProcessingPermit() async {
    //REVISANDO SI TIENE UN NUEVO TRÁMITE
    final appState = Provider.of<AppState>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    var response = await serviceMethod(context, 'get', null,
        serviceGetProcessingPermit(userBloc.state.user!.id!), true, true);
    if (response != null) {
      userBloc.add(UpdateCtrlLive(
          json.decode(response.body)['data']['liveness_success']));
      userBloc.add(UpdateProcedureId(
          json.decode(response.body)['data']['procedure_id']));
      userBloc.add(UpdatePhone(
          json.decode(response.body)['data']['cell_phone_number'][0]));
    } else {
      appState.updateStateProcessing(false);
    }
  }
}
