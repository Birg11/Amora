import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/affirmation_overlay.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late Timer _timer;
  int secondsRemaining = 180;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining <= 0) {
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _timer.cancel();
    super.dispose();
  }

  String get timeString {
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F8),
      body: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _rippleController,
            builder: (_, __) {
              double scale = 1 + (_rippleController.value * 0.2);
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.pink.shade100.withOpacity(0.3),
                        Colors.pink.shade200.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Text(
            timeString,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const Positioned(
            bottom: 60,
            child: AffirmationOverlay(),
          )
        ],
      ),
    );
  }
}
