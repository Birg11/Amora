import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late TextEditingController _controller;
  String _todayKey = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("journal_$_todayKey") ?? "";
    setState(() {
      _controller.text = saved;
    });
  }

  Future<void> _saveEntry() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("journal_$_todayKey", _controller.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Journal saved 💖")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Soulmate Journal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              DateFormat('EEEE, MMMM d').format(DateTime.now()),
              style: TextStyle(
                fontSize: 18,
                color: isDark ? Colors.pink.shade100 : Colors.pink.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Expanded(
  child: SingleChildScrollView(
    child: TextField(
      controller: _controller,
      maxLines: null,
      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        hintText: "Write what's on your heart today...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        fillColor: isDark ? Colors.pink.shade100.withOpacity(0.05) : Colors.pink.shade50,
        filled: true,
        contentPadding: const EdgeInsets.all(16), // This makes it start from the top
      ),
    ),
  ),
),

            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _saveEntry,
              icon: const Icon(Icons.save),
              label: const Text("Save Entry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
