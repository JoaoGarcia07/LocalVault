import 'package:flutter/material.dart';

import '../services/settings_service.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService settingsService = SettingsService();
  final StorageService storageService = StorageService();

  bool darkMode = false;
  bool notifications = true;
  String language = 'Português';

  final TextEditingController tokenController = TextEditingController();

  String tokenMessage = '';

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final savedDarkMode = await settingsService.getDarkMode();
    final savedNotifications = await settingsService.getNotifications();
    final savedLanguage = await settingsService.getLanguage();

    setState(() {
      darkMode = savedDarkMode;
      notifications = savedNotifications;
      language = savedLanguage;
    });
  }

  Future<void> saveToken() async {
    if (tokenController.text.trim().isEmpty) {
      setState(() {
        tokenMessage = 'Digite um token antes de salvar.';
      });
      return;
    }

    await storageService.saveToken(tokenController.text.trim());

    setState(() {
      tokenMessage = 'Token salvo com segurança!';
      tokenController.clear();
    });
  }

  Future<void> getToken() async {
    final token = await storageService.getToken();

    setState(() {
      tokenMessage = token == null || token.isEmpty
          ? 'Nenhum token encontrado.'
          : 'Token recuperado: $token';
    });
  }

  Future<void> deleteToken() async {
    await storageService.deleteToken();

    setState(() {
      tokenMessage = 'Token deletado com sucesso.';
    });
  }

  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }

  Widget buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildFullButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              buildSectionTitle(
                'Preferências do App',
                Icons.settings,
              ),

              const SizedBox(height: 16),

              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Modo escuro'),
                      subtitle: const Text('Alterna entre tema claro e escuro'),
                      value: darkMode,
                      onChanged: (value) async {
                        await settingsService.setDarkMode(value);

                        setState(() {
                          darkMode = value;
                        });

                        widget.onThemeChanged(value);
                      },
                    ),

                    const Divider(height: 1),

                    SwitchListTile(
                      title: const Text('Notificações'),
                      subtitle: const Text('Ativa ou desativa notificações'),
                      value: notifications,
                      onChanged: (value) async {
                        await settingsService.setNotifications(value);

                        setState(() {
                          notifications = value;
                        });
                      },
                    ),

                    const Divider(height: 1),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButtonFormField<String>(
                        value: language,
                        decoration: const InputDecoration(
                          labelText: 'Idioma',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Português',
                            child: Text('Português'),
                          ),
                          DropdownMenuItem(
                            value: 'Inglês',
                            child: Text('Inglês'),
                          ),
                        ],
                        onChanged: (value) async {
                          if (value == null) return;

                          await settingsService.setLanguage(value);

                          setState(() {
                            language = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              buildSectionTitle(
                'Armazenamento Seguro',
                Icons.security,
              ),

              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: tokenController,
                        decoration: const InputDecoration(
                          labelText: 'Token fictício',
                          hintText: 'Ex: abc123-token',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.key),
                        ),
                      ),

                      const SizedBox(height: 18),

                      buildFullButton(
                        text: 'Salvar Token',
                        icon: Icons.save,
                        onPressed: saveToken,
                      ),

                      const SizedBox(height: 12),

                      buildFullButton(
                        text: 'Recuperar Token',
                        icon: Icons.search,
                        onPressed: getToken,
                      ),

                      const SizedBox(height: 12),

                      buildFullButton(
                        text: 'Deletar Token',
                        icon: Icons.delete,
                        onPressed: deleteToken,
                      ),

                      if (tokenMessage.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                          child: Text(
                            tokenMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}