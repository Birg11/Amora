// ✅ AffirmationManager: Stores affirmations with local persistence
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AffirmationManager extends ChangeNotifier {
  final List<String> _affirmations = [];

  List<String> get affirmations => _affirmations;

  AffirmationManager() {
    _loadAffirmations();
  }

  void addAffirmation(String text) {
    _affirmations.add(text);
    _saveAffirmations();
    notifyListeners();
  }

  void removeAffirmation(int index) {
    _affirmations.removeAt(index);
    _saveAffirmations();
    notifyListeners();
  }

  Future<void> _loadAffirmations() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('amora_affirmations') ?? [];
    _affirmations.clear();
    _affirmations.addAll(saved);
    notifyListeners();
  }

  Future<void> _saveAffirmations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('amora_affirmations', _affirmations);
  }
}
