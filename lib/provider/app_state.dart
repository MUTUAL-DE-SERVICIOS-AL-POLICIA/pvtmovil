import 'dart:io';

import 'package:flutter/material.dart';
import 'package:muserpol_pvt/model/files_model.dart';

class AppState with ChangeNotifier {
  String? messageObservation = null;
  updateObservation(String message) {
    messageObservation = message;
    notifyListeners();
  }

  bool stateAuxToken = false;
  updateStateAuxToken(bool state) {
    stateAuxToken = state;
    notifyListeners();
  }

  int indexTabProcedure = 0;
  updateTabProcedure(int index) async {
    await Future.delayed(const Duration(milliseconds: 50), () {});
    indexTabProcedure = index;
    notifyListeners();
  }

  bool stateProcessing = false;
  updateStateProcessing(bool state) {
    stateProcessing = state;
    notifyListeners();
  }

  bool stateLoadingProcedure = false;
  updateStateLoadingProcedure(bool state) async {
    await Future.delayed(const Duration(milliseconds: 50), () {});
    stateLoadingProcedure = state;
    notifyListeners();
  }

  List<FileDocument> files = [
    // FileDocument(
    //     id: 'renta',
    //     title: 'Renta',
    //     imageName: 'boleta_de_renta.jpg',
    //     textValidate: 'El documento es invalido, revise la fecha de vigencia',
    //     imageFile: null,
    //     imagePathDefault: 'assets/images/certificado.png',
    //     wordsKey: [],
    //     validateState: true),
    FileDocument(
        id: 'cianverso',
        title: 'CI Anverso',
        imageName: 'ci_anverso.jpg',
        textValidate:
            'Verifique que su carnet sea el Anverso y que este vigente',
        imageFile: null,
        imagePathDefault: 'assets/images/anverso.png',
        wordsKey: [
          //'numCarnet',
          //'CÉDULA DE IDENTIDAD',
          //'ESTADO PLURINACIONAL DE BOLIVIA'
        ],
        validateState: true),
    FileDocument(
        id: 'cireverso',
        title: 'CI Reverso',
        imageName: 'ci_reverso.jpg',
        textValidate: 'Verifique que su carnet sea el Reverso',
        imageFile: null,
        imagePathDefault: 'assets/images/reverso.png',
        wordsKey: [
          //'numCarnet',
          // 'nombre'
        ],
        validateState: true),
  ];

  Future<void> addKey(String keyId, String keyText) async {
    await Future.delayed(const Duration(milliseconds: 50), () {});
    files.firstWhere((e) => e.id == keyId).wordsKey!.add(keyText);
    notifyListeners();
  }

  updateStateFiles(String keyId, bool state) {
    files.firstWhere((e) => e.id == keyId).validateState = state;
    notifyListeners();
  }

  updateFile(String keyId, File? file) {
    if (file == null) {
      files.firstWhere((e) => e.id == keyId).imageFile = null;
    } else {
      files.firstWhere((e) => e.id == keyId).imageFile = file;
    }
    notifyListeners();
  }

  clearFiles() {
    for (var i = 0; i < files.length; i++) {
      files[i].imageFile = null;
      files[i].validateState = true;
    }
    notifyListeners();
  }
}
