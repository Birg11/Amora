import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/duration_manager.dart';

class MinuteAdjustButtons extends StatelessWidget {
  const MinuteAdjustButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = Provider.of<DurationManager>(context);
    final minutes = (duration.seconds / 60).round();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.pinkAccent),
          onPressed: () {
            if (minutes > 1) {
              duration.setMinutes(minutes - 1);
            }
          },
        ),
        Text(
          "$minutes min",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.pinkAccent),
          onPressed: () {
            if (minutes < 60) {
              duration.setMinutes(minutes + 1);
            }
          },
        ),
      ],
    );
  }
}
