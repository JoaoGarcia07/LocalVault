# LocalVault

Aluno: João Vitor Prestes Garcia

## Descrição do App

O LocalVault é um aplicativo Flutter desenvolvido para praticar armazenamento local de dados.  
O app permite salvar configurações do usuário, cadastrar um perfil simples e armazenar um token fictício de forma segura.

## Tecnologias usadas

- Flutter
- Dart
- SharedPreferences
- Hive
- flutter_secure_storage

## SharedPreferences

O SharedPreferences foi usado para salvar configurações simples do aplicativo, como:

- Modo escuro ou claro
- Idioma escolhido
- Notificações ativadas ou desativadas

Ele foi escolhido porque é ideal para armazenar preferências pequenas e simples, que precisam continuar salvas mesmo depois de fechar o app.

## Hive

O Hive foi usado para salvar o perfil do usuário.
O perfil possui informações como:

- Nome
- E-mail
- Data de cadastro
- Pontuação

O Hive foi escolhido porque permite armazenar objetos de forma rápida e organizada no próprio dispositivo.

## flutter_secure_storage

O flutter_secure_storage foi usado para salvar um token de autenticação fictício.
Ele foi escolhido porque oferece mais segurança para guardar informações sensíveis, como tokens e chaves de acesso.

## LGPD

Se este app fosse publicado na Play Store, ele estaria armazenando dados como nome, e-mail, pontuação, preferências do aplicativo e um token fictício.
Para seguir a LGPD, o usuário deveria ser informado sobre quais dados são armazenados e por qual motivo.  
Também seria necessário permitir que ele excluísse seus dados. No app, o botão de limpar perfil representa o direito ao esquecimento.
## Como rodar o projeto

Clone o repositório:

```bash
git clone https://github.com/JoaoGarcia07/LocalVault.git
cd LocalVault
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
