// ✅ Amora: Final Single-Screen App with Trait Adding, Timer, Reset, Theme + Affirmation + Info Button

import 'package:amora/models/duration_manager.dart';
import 'package:amora/models/trait_manager.dart';
import 'package:amora/screens/journal_history_screen.dart';
import 'package:amora/screens/journal_screen.dart';
import 'package:amora/screens/journey_screen.dart';
import 'package:amora/widgets/energy_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'affirmation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

return Scaffold(
  appBar: AppBar(
    title: const Text("Amora 💖"),
    actions: [
      // IconButton(
      //   icon: const Icon(Icons.chat_bubble_outline),
      //   onPressed: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => const AffirmationScreen()),
      //   ),
      // ),
      IconButton(
  icon: const Icon(Icons.menu_book_outlined),
  tooltip: "Journal History",
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const JournalHistoryScreen()),
  ),
),

      IconButton(
        icon: const Icon(Icons.info_outline),
        onPressed: () => _showMethodsPanel(context),
      ),
      IconButton(
        icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        onPressed: () {
          final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
          MyThemeSwitcher.of(context).setTheme(newMode);
        },
      ),
    ],
  ),
  body: SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.pinkAccent),
                onPressed: () {
                  final duration = Provider.of<DurationManager>(context, listen: false);
                  final minutes = (duration.seconds / 60).round();
                  if (minutes > 1) duration.setMinutes(minutes - 1);
                },
              ),
              Consumer<DurationManager>(
                builder: (_, manager, __) => Text(
                  "${(manager.seconds / 60).round()} min",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.pinkAccent),
                onPressed: () {
                  final duration = Provider.of<DurationManager>(context, listen: false);
                  final minutes = (duration.seconds / 60).round();
                  if (minutes < 60) duration.setMinutes(minutes + 1);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          const EnergyCircle(),
          const SizedBox(height: 20),
          Consumer<TraitManager>(
            builder: (_, manager, __) => Wrap(
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: List.generate(manager.traits.length, (index) {
                final trait = manager.traits[index];
                return Chip(
                  label: Text(
                    trait,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.pink.shade900,
                    ),
                  ),
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.pink.shade800.withOpacity(0.2)
                      : Colors.pink.shade50,
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => manager.removeTrait(index),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _showAddTraitDialog(context),
            icon: const Icon(Icons.add),
            label: const Text("Add Trait"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          const SizedBox(height: 100), // spacing to keep FAB floating nicely
        ],
      ),
    ),
  ),
  floatingActionButton: SpeedDial(
    icon: Icons.favorite,
    activeIcon: Icons.close,
    backgroundColor: Colors.pinkAccent,
    foregroundColor: Colors.white,
    overlayColor: Colors.black,
    overlayOpacity: 0.3,
    spacing: 10,
    spaceBetweenChildren: 12,
    children: [
      SpeedDialChild(
        child: const Icon(Icons.auto_awesome),
        label: "Amora Journey",
        backgroundColor: Colors.deepPurpleAccent,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JourneyScreen())),
      ),
      SpeedDialChild(
        child: const Icon(Icons.book_rounded),
        label: "Journal",
        backgroundColor: Colors.purpleAccent,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalScreen())),
      ),
      SpeedDialChild(
        child: const Icon(Icons.chat_bubble_outline),
        label: "Affirmation",
        backgroundColor: Colors.pink,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AffirmationScreen())),
      ),
    ],
  ),
);

  }

  void _showAddTraitDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add a Characteristic"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "e.g. Loyal, Funny, Deep thinker"),
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

void _showMethodsPanel(BuildContext context) {
  final textColor = Theme.of(context).textTheme.bodyLarge?.color;

  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text("🧘‍♀️ How to Use Amora", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 10),
            Text("• Tap once to play/pause the timer.", style: TextStyle(color: textColor)),
            Text("• Double tap to edit the time.", style: TextStyle(color: textColor)),
            Text("• Triple tap to reset.", style: TextStyle(color: textColor)),
            Text("• Add characteristics of your soulmate.", style: TextStyle(color: textColor)),
            Text("• Focus and visualize during countdown.", style: TextStyle(color: textColor)),
            const SizedBox(height: 20),
            Text("💖 Sample Affirmations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 10),
            Text("• I am ready to meet my soulmate.", style: TextStyle(color: textColor)),
            Text("• I radiate loving energy.", style: TextStyle(color: textColor)),
            Text("• My heart is open and aligned.", style: TextStyle(color: textColor)),
            Text("• Love flows easily to me.", style: TextStyle(color: textColor)),
          ],
        ),
      );
    },
  );
}

}

// Provide this higher in widget tree (main.dart)
class MyThemeSwitcher extends InheritedWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) setTheme;

  const MyThemeSwitcher({
    super.key,
    required this.themeMode,
    required this.setTheme,
    required super.child,
  });

  static MyThemeSwitcher of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyThemeSwitcher>()!;
  }

  @override
  bool updateShouldNotify(covariant MyThemeSwitcher oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}
