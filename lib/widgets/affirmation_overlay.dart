import 'dart:async';
import 'package:flutter/material.dart';

class AffirmationOverlay extends StatefulWidget {
  const AffirmationOverlay({super.key});

  @override
  State<AffirmationOverlay> createState() => _AffirmationOverlayState();
}

class _AffirmationOverlayState extends State<AffirmationOverlay> {
  final List<String> affirmations = [
    "I am open to love 💗",
    "My soulmate is on their way 💫",
    "I radiate loving energy 🌸",
    "The universe brings me my match ✨",
  ];
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _index = (_index + 1) % affirmations.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ✅ Cancel the timer to prevent setState after dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: Text(
        affirmations[_index],
        key: ValueKey(_index),
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black54,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
