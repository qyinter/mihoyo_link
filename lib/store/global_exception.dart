import 'package:flutter/material.dart';

class GlobalExceptionNotifier extends ChangeNotifier {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
