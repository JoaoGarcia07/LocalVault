import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/user_profile.dart';
import 'screens/home_screen.dart';
import 'services/migration_service.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter());
  await Hive.openBox<UserProfile>('user_profile_box');
  await MigrationService().runMigration();
  final darkMode = await SettingsService().getDarkMode();
  runApp(LocalVaultApp(darkMode: darkMode));
}

class LocalVaultApp extends StatefulWidget {
  final bool darkMode;

  const LocalVaultApp({
    super.key,
    required this.darkMode,
  });

  @override
  State<LocalVaultApp> createState() => _LocalVaultAppState();
}

class _LocalVaultAppState extends State<LocalVaultApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.darkMode;
  }

  void updateTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalVault',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomeScreen(
        onThemeChanged: updateTheme,
      ),
    );
  }
}