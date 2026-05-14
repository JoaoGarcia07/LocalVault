# LocalVault

Aluno: João Vitor Prestes Garcia

## Descrição do App

O LocalVault é um aplicativo Flutter criado para demonstrar o uso de armazenamento local com SharedPreferences, Hive e flutter_secure_storage.

O app possui tela de configurações, perfil do usuário e armazenamento seguro de token fictício.

## Por que foi escolhido SharedPreferences para configurações?

O SharedPreferences foi escolhido porque é ideal para armazenar dados simples, como preferências do usuário. No app, ele salva o modo escuro, idioma e notificações.

## Por que foi escolhido Hive para o perfil do usuário?

O Hive foi escolhido porque permite armazenar objetos locais de forma rápida e organizada. No app, ele salva o perfil do usuário com nome, e-mail, data de cadastro e pontuação.

## Por que foi escolhido flutter_secure_storage para o token?

O flutter_secure_storage foi escolhido porque é mais adequado para armazenar informações sensíveis, como tokens de autenticação. Ele oferece mais segurança do que salvar o token diretamente em SharedPreferences.

## Instruções para rodar o projeto

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run