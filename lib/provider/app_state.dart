
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {

  String messageObservation = '';
  updateObservation(String message) {
    messageObservation = message;
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
}