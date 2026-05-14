import 'package:shared_preferences/shared_preferences.dart';

class MigrationService {
  static const String keyDataVersion = 'data_version';

  Future<void> runMigration() async {
    final prefs = await SharedPreferences.getInstance();

    final currentVersion = prefs.getInt(keyDataVersion) ?? 1;

    if (currentVersion == 1) {
      // Aqui seria feita a migração de dados antigos para o novo formato.
      await prefs.setInt(keyDataVersion, 2);
    }
  }

  Future<int> getCurrentVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyDataVersion) ?? 1;
  }
}