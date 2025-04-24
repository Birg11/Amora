// ✅ Affirmation Management Screen with Add, Edit, Remove, and Theme Toggle

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/affirmation_manager.dart';

class AffirmationScreen extends StatelessWidget {
  const AffirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<AffirmationManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Affirmations 💬'),
        actions: [
          // IconButton(
          //   icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          //   onPressed: () {
          //     final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
          //     MyThemeSwitcher.of(context).setTheme(newMode);
          //   },
          // )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: manager.affirmations.length,
        itemBuilder: (context, index) {
          final affirmation = manager.affirmations[index];
          return ListTile(
            title: Text(affirmation),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.pinkAccent),
              onPressed: () => manager.removeAffirmation(index),
            ),
            onTap: () => _showEditDialog(context, index, affirmation),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Affirmation"),
        backgroundColor: Colors.pinkAccent,
        onPressed: () => _showAddDialog(context),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("New Affirmation"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "e.g. I attract love effortlessly"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Provider.of<AffirmationManager>(context, listen: false).addAffirmation(text);
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, String currentText) {
    final controller = TextEditingController(text: currentText);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Affirmation"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Update your affirmation"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newText = controller.text.trim();
              if (newText.isNotEmpty) {
                final manager = Provider.of<AffirmationManager>(context, listen: false);
                manager.removeAffirmation(index);
                manager.addAffirmation(newText);
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}

// Optional helper for toggling theme using InheritedWidget
class MyThemeSwitcher extends InheritedWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) setTheme;

  const MyThemeSwitcher({
    super.key,
    required this.themeMode,
    required this.setTheme,
    required super.child,
  });

  // static MyThemeSwitcher of(BuildContext context) {
  //   return context.dependOnInheritedWidgetOfExactType<MyThemeSwitcher>()!;
  // }

  @override
  bool updateShouldNotify(covariant MyThemeSwitcher oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}
