import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trait_manager.dart';

class AddCharacteristicButton extends StatelessWidget {
  const AddCharacteristicButton({super.key});

  void _showInputDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add a Trait"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "e.g. Kind, Artistic"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Provider.of<TraitManager>(context, listen: false).addTrait(text);
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showInputDialog(context),
      label: const Text("Add Characteristic"),
      icon: const Icon(Icons.favorite),
      backgroundColor: Colors.pinkAccent,
    );
  }
}
