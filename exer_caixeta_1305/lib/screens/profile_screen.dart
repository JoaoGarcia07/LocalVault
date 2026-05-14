import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Box<UserProfile> profileBox = Hive.box<UserProfile>('user_profile_box');

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pontuacaoController = TextEditingController();

  UserProfile? profile;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() {
    setState(() {
      profile = profileBox.get('profile');
    });
  }

  Future<void> saveProfile() async {
    final nome = nomeController.text;
    final email = emailController.text;
    final pontuacao = int.tryParse(pontuacaoController.text) ?? 0;

    if (nome.isEmpty || email.isEmpty) return;

    final newProfile = UserProfile(
      nome: nome,
      email: email,
      dataCadastro: DateTime.now(),
      pontuacao: pontuacao,
    );

    await profileBox.put('profile', newProfile);

    nomeController.clear();
    emailController.clear();
    pontuacaoController.clear();

    loadProfile();
  }

  Future<void> deleteProfile() async {
    await profileBox.delete('profile');

    setState(() {
      profile = null;
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    pontuacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = profile == null
        ? ''
        : '${profile!.dataCadastro.day}/${profile!.dataCadastro.month}/${profile!.dataCadastro.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Salvar Perfil com Hive',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'E-mail',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: pontuacaoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Pontuação',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: saveProfile,
            child: const Text('Salvar Perfil'),
          ),

          const SizedBox(height: 32),

          const Text(
            'Perfil Salvo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (profile == null)
            const Text('Nenhum perfil salvo.')
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nome: ${profile!.nome}'),
                    Text('E-mail: ${profile!.email}'),
                    Text('Data de cadastro: $formattedDate'),
                    Text('Pontuação: ${profile!.pontuacao}'),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: deleteProfile,
            child: const Text('Limpar Dados do Perfil'),
          ),

          const SizedBox(height: 8),

          const Text(
            'Este botão representa o direito ao esquecimento da LGPD.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}