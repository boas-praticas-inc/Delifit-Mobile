# Delifit Mobile

Aplicativo mobile do ecossistema Delifit, construido em Flutter.

## Estrutura inicial

O projeto comeca com uma Clean Architecture enxuta:

- `lib/app`: configuracao do app, tema, rotas e recursos compartilhados
- `lib/features`: modulos por funcionalidade, cada um com `domain`, `data` e `presentation`
- `lib/app/core`: clientes HTTP, storage, erros, constantes e injecao

## Como rodar

1. Instale o Flutter SDK.
2. Entre na pasta do projeto.
3. Rode `flutter pub get`.
4. Rode `flutter run`.

