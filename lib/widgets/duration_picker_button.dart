import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/duration_manager.dart';

class DurationPickerButton extends StatelessWidget {
  const DurationPickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.timer, color: Colors.pinkAccent),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          builder: (_) {
            return SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [1, 3, 5, 10].map((min) {
                  return ListTile(
                    title: Center(child: Text("$min minute${min > 1 ? 's' : ''}")),
                    onTap: () {
                      Provider.of<DurationManager>(context, listen: false)
                          .setMinutes(min);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}
