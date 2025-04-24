// models/duration_manager.dart
import 'package:flutter/material.dart';

class DurationManager extends ChangeNotifier {
  int seconds = 180; // default = 3 minutes

  void setMinutes(int minutes) {
    seconds = minutes * 60;
    notifyListeners();
  }
}
