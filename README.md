# EntreNós

Aplicativo Flutter, Android primeiro, para casais adultos explorarem interesses em comum com privacidade. O nome é provisório e o produto ainda não está aprovado para publicação.

## Estado atual

O projeto está no bootstrap da Etapa 1. Não há autenticação, backend configurado, coleta de dados, catálogo ou compra implementados.

## Pré-requisitos

- Flutter 3.29.2 e Dart 3.7.2 (versões atualmente instaladas neste repositório).
- Android SDK com `cmdline-tools` e licenças aceitas para executar no Android.

## Comandos locais (Windows CMD)

```bat
flutter pub get
dart format .
flutter analyze
flutter test
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

As definições do Supabase não são necessárias neste bootstrap e só devem ser fornecidas após a etapa de autenticação. Nunca use uma chave `service_role` no app.

### Observação do ambiente Windows atual

Neste computador, o Gradle só conseguiu validar os repositórios quando usou o repositório de certificados do Windows. Caso o erro `PKIX path building failed` reapareça, no CMD execute antes do build:

```bat
set GRADLE_OPTS=-Djavax.net.ssl.trustStoreType=Windows-ROOT
flutter build apk --debug
```

Isso não desativa TLS nem deve ser adicionado a arquivos versionados. O emulador local também requer aceleração de virtualização/hypervisor ou, alternativamente, um dispositivo Android físico conectado.

## Estrutura

- `lib/app`: composição do app, rota e tema.
- `lib/core`: infraestrutura compartilhada sem regra de produto.
- `lib/features`: funcionalidades isoladas por domínio.
- `docs`: decisões, status e validações.

Consulte `ROADMAP_ENTRENOS.md` e `AGENTS.md` antes de alterar o projeto.

Para instalar e testar o app em um celular Android físico, consulte `docs/TESTE_CELULAR_ANDROID.md`.
