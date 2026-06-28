# Delifit Mobile

Aplicativo mobile do ecossistema Delifit, construído em Flutter.

## Plataforma adotada

O projeto está organizado para:

- `android`: plataforma principal de desenvolvimento e execução
- `web`: suporte auxiliar para testes rápidos no navegador

As outras plataformas foram removidas do scaffold inicial para manter o repositório mais simples nesta fase.

## Estrutura inicial

O projeto começa com uma Clean Architecture enxuta:

- `lib/app`: configuração do app, tema, rotas e recursos compartilhados
- `lib/features`: módulos por funcionalidade, cada um com `domain`, `data` e `presentation`
- `lib/app/core`: cliente HTTP, storage, erros, constantes e injeção

## Como rodar

1. Instale o Flutter SDK.
2. Entre na pasta do projeto.
3. Rode `flutter pub get`.
4. Para Android, rode `flutter run -d android` em um emulador ou dispositivo conectado.
5. Para testar no navegador, rode `flutter run -d edge`.

## Observação sobre a API

O `apiBaseUrl` agora é decidido automaticamente em `lib/app/core/constants/app_constants.dart`:

- na `web`, o app usa `http://localhost:8000/api/v1`
- no `android`, o app usa `http://10.0.2.2:8000/api/v1`

Isso evita editar a URL manualmente toda vez que você alternar entre navegador e emulador Android.

## Observação sobre CORS

Quando você rodar na web, o backend pode precisar liberar a origem do navegador via CORS para o frontend conseguir consumir a API local.
