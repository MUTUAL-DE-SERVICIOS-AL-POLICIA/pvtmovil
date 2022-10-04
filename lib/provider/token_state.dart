
import 'package:flutter/material.dart';

class TokenState with ChangeNotifier {

  bool stateAuxToken = false;
  updateStateAuxToken(bool state) {
    stateAuxToken = state;
    notifyListeners();
  }
}