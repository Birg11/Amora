// ✅ EnergyCircle Widget with Gesture Timer Control (Tap, Double, Triple)

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../models/trait_manager.dart';
import '../models/duration_manager.dart';

class EnergyCircle extends StatefulWidget {
  const EnergyCircle({super.key});

  @override
  State<EnergyCircle> createState() => _EnergyCircleState();
}

class _EnergyCircleState extends State<EnergyCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _timer;
  int secondsRemaining = 180;
  int totalSeconds = 180;
  bool isRunning = true;
  int tapCount = 0;
  Timer? tapTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newTotal = Provider.of<DurationManager>(context).seconds;
    if (newTotal != totalSeconds) {
      totalSeconds = newTotal;
      secondsRemaining = totalSeconds;
      _startCountdown();
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    if (!isRunning) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (secondsRemaining <= 0) {
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  void _handleTap() {
    tapCount++;
    tapTimer?.cancel();
    tapTimer = Timer(const Duration(milliseconds: 400), () {
      if (tapCount == 1) {
        // Single tap: toggle play/pause
        setState(() {
          isRunning = !isRunning;
        });
        if (isRunning) {
          _startCountdown();
        } else {
          _timer?.cancel();
        }
      } else if (tapCount == 3) {
        // Triple tap: reset
        setState(() {
          secondsRemaining = totalSeconds;
        });
        _startCountdown();
      }
      tapCount = 0;
    });
  }

  void _handleDoubleTap() async {
    final minutes = await showDialog<int>(
      context: context,
      builder: (_) {
        int selected = totalSeconds ~/ 60;
        return AlertDialog(
          title: const Text("Set Duration (Minutes)"),
          content: DropdownButton<int>(
            value: selected,
            onChanged: (value) => Navigator.pop(context, value),
            items: [1, 2, 3, 5, 10, 15, 20].map((m) {
              return DropdownMenuItem(
                value: m,
                child: Text("$m minutes"),
              );
            }).toList(),
          ),
        );
      },
    );
    if (minutes != null) {
      final duration = Provider.of<DurationManager>(context, listen: false);
      duration.setMinutes(minutes);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    tapTimer?.cancel();
    super.dispose();
  }

  String get timeString {
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final traits = Provider.of<TraitManager>(context).traits;
    final percent = secondsRemaining / totalSeconds;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        double scale = 1 + (_pulseController.value * 0.1);
        return Transform.scale(
          scale: scale,
          child: Stack(
            
            alignment: Alignment.center,
            children: [
              CustomPaint(
                
                painter: _LinePainter(traits: traits),
                size: const Size(280, 280),
              ),
              CircularPercentIndicator(
                radius: 100,
                lineWidth: 10,
                percent: percent.clamp(0.0, 1.0),
                backgroundColor: Colors.transparent,
                progressColor: Colors.pinkAccent,
                circularStrokeCap: CircularStrokeCap.round,
                center: GestureDetector(
                  onTap: _handleTap,
                  onDoubleTap: _handleDoubleTap,
                  child: Text(
                    timeString,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<String> traits;

  _LinePainter({required this.traits});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..color = Colors.pinkAccent.withOpacity(0.2)
      ..strokeWidth = 2;

    final totalLines = max(traits.length, 8);
    const lineLength = 140.0;

    for (int i = 0; i < totalLines; i++) {
      final angle = (2 * pi / totalLines) * i;
      final x = center.dx + lineLength * cos(angle);
      final y = center.dy + lineLength * sin(angle);
      canvas.drawLine(center, Offset(x, y), paint);

      if (i < traits.length) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: traits[i],
            style: const TextStyle(
              color: Colors.pink,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - 20, y - 8));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
