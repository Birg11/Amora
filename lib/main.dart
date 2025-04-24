import 'package:amora/screens/home_screen.dart';
import 'package:amora/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/trait_manager.dart';
import 'models/duration_manager.dart';
import 'models/affirmation_manager.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // REQUIRED

  final traitManager = TraitManager();
  await traitManager.init(); // ✅ Wait until prefs are ready

  runApp(
    MyThemeWrapper(traitManager: traitManager),
  );
}

class MyThemeWrapper extends StatefulWidget {
  final TraitManager traitManager;
  const MyThemeWrapper({super.key, required this.traitManager});

  @override
  State<MyThemeWrapper> createState() => _MyThemeWrapperState();
}

class _MyThemeWrapperState extends State<MyThemeWrapper> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyThemeSwitcher(
      themeMode: _themeMode,
      setTheme: _setThemeMode,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => widget.traitManager),
          ChangeNotifierProvider(create: (_) => DurationManager()),
          ChangeNotifierProvider(create: (_) => AffirmationManager()),
        ],
        child: MaterialApp(
          title: 'Amora',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeMode,
          debugShowCheckedModeBanner: false,
home: const SplashScreen(),
        ),
      ),
    );
  }
}
