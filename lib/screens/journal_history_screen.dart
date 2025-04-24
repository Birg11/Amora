import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class JournalHistoryScreen extends StatefulWidget {
  const JournalHistoryScreen({super.key});

  @override
  State<JournalHistoryScreen> createState() => _JournalHistoryScreenState();
}

class _JournalHistoryScreenState extends State<JournalHistoryScreen> {
  List<String> journalKeys = [];

  @override
  void initState() {
    super.initState();
    _loadJournalKeys();
  }

  Future<void> _loadJournalKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith("journal_")).toList();
    keys.sort((a, b) => b.compareTo(a)); // recent first
    setState(() => journalKeys = keys);
  }

  String _formatDate(String key) {
    final date = DateTime.tryParse(key.replaceFirst("journal_", ""));
    if (date == null) return key;
    return DateFormat('EEEE, MMM d, yyyy').format(date);
  }

  void _openEntry(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(key) ?? "";
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JournalViewerScreen(dateKey: key, entry: text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Journal History")),
      body: journalKeys.isEmpty
          ? const Center(child: Text("No journal entries yet."))
          : ListView.builder(
              itemCount: journalKeys.length,
              itemBuilder: (_, index) {
                final key = journalKeys[index];
                return ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(_formatDate(key)),
                  onTap: () => _openEntry(key),
                );
              },
            ),
    );
  }
}

class JournalViewerScreen extends StatelessWidget {
  final String dateKey;
  final String entry;

  const JournalViewerScreen({super.key, required this.dateKey, required this.entry});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(dateKey.replaceFirst("journal_", ""));
    final formattedDate = date != null
        ? DateFormat('EEEE, MMM d, yyyy').format(date)
        : dateKey;

    return Scaffold(
      appBar: AppBar(title: Text(formattedDate)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          entry.isNotEmpty ? entry : "No entry found for this date.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
