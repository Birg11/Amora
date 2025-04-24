import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TraitManager extends ChangeNotifier {
  final List<String> _traits = [];
  bool _isInitialized = false;

  List<String> get traits => _traits;

  Future<void> init() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    final savedTraits = prefs.getStringList('amora_traits') ?? [];
    _traits.clear();
    _traits.addAll(savedTraits);
    _isInitialized = true;
    notifyListeners();
  }

  void addTrait(String trait) {
    _traits.add(trait);
    _saveTraits();
    notifyListeners();
  }

  void removeTrait(int index) {
    _traits.removeAt(index);
    _saveTraits();
    notifyListeners();
  }

  Future<void> _saveTraits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('amora_traits', _traits);
  }
}
