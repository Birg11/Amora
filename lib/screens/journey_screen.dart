import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  int _unlockedDay = 1;

  final List<String> _titles = [
    "Know Yourself",
    "Heal Old Wounds",
    "Envision Deep Love",
    "Release Fear",
    "Prepare Your Heart",
    "Radiate Love",
    "Receive the One",
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _unlockedDay = prefs.getInt("amora_day") ?? 1);
  }

  Future<void> _unlockNextDay() async {
    final prefs = await SharedPreferences.getInstance();
    if (_unlockedDay < 7) {
      setState(() => _unlockedDay++);
      await prefs.setInt("amora_day", _unlockedDay);
    }
  }

  void _showContent(int day) {
    final ritualText = _getRitualText(day);
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Day ${day + 1}: ${_titles[day]}", style: TextStyle(color: textColor)),
        content: Text(ritualText, style: TextStyle(color: textColor)),
        actions: [
          if (day + 1 == _unlockedDay && _unlockedDay < 7)
            TextButton(
              onPressed: () {
                _unlockNextDay();
                Navigator.pop(context);
              },
              child: const Text("Mark as Complete"),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  String _getRitualText(int day) {
    final rituals = [
      "Write 3 words that define the real you.",
      "Reflect on a past hurt. What did it teach you about love?",
      "Describe your dream partner in 5 emotions.",
      "What fear do you need to release before love arrives?",
      "Write 3 things you’ll make space for in your life.",
      "Send loving energy to someone, silently.",
      "Sit in silence and imagine your soulmate saying: 'I see you.'",
    ];
    return rituals[day];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: AppBar(title: const Text("7-Day Amora Journey")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7,
        itemBuilder: (_, index) {
          final locked = index >= _unlockedDay;
          return Card(
            color: locked
                ? (isDark ? Colors.grey.shade800 : Colors.grey.shade300)
                : (isDark ? Colors.pink.shade900.withOpacity(0.2) : Colors.pink.shade50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: Text(
                "Day ${index + 1}: ${_titles[index]}",
                style: TextStyle(
                  color: locked
                      ? Colors.grey
                      : (isDark ? Colors.pink.shade100 : Colors.pink.shade900),
                ),
              ),
              trailing: Icon(
                locked ? Icons.lock_outline : Icons.favorite,
                color: locked
                    ? Colors.grey
                    : (isDark ? Colors.pink.shade100 : Colors.pink),
              ),
              onTap: locked ? null : () => _showContent(index),
            ),
          );
        },
      ),
    );
  }
}
