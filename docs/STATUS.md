# Status do projeto

## Etapa atual

- Etapa: 1 — bootstrap do projeto.
- Branch: `feature/project-bootstrap`.
- Situação: em andamento.
- Última atualização: 2026-11-25.

## Concluído na Etapa 0

- Leitura integral de `ROADMAP_ENTRENOS.md`.
- Inspeção do repositório: não havia aplicação, dependências, migrations ou automações existentes.
- Registro de evidências oficiais de lojas, LGPD e custos iniciais.
- Registro de decisões arquiteturais como propostas, não como decisões aprovadas.

## Pendências de produto

1. Aprovar ou reformular o posicionamento e o catálogo para compatibilidade com as lojas.
2. Definir responsável jurídico/controlador, base legal, retenção, operadores e transferências internacionais.
3. Aprovar orçamento mensal, preço final e modelo de acesso derivado após desvinculação.
4. Confirmar Flutter + Supabase + RevenueCat após avaliação de custos e políticas.
5. Validar nome, marca, domínio e identificadores de pacote.
6. Definir critérios e público do beta; revisar editorialmente qualquer conteúdo antes de publicação.

## Verificações executadas

| Verificação | Resultado real |
|---|---|
| Estado Git | `feature/project-bootstrap` criada a partir da documentação da Etapa 0. |
| Estrutura do repositório | Projeto Flutter criado sem sobrescrever `ROADMAP_ENTRENOS.md` ou `docs/`. |
| Ambiente Flutter | Flutter 3.29.2, Dart 3.7.2 e Git 2.33.0 instalados. Flutter reportou falha de certificado ao buscar tags; nenhuma atualização foi executada. |
| Android | SDK 36.0.0 e NDK 27.0.12077973 instalados durante o build. O `flutter doctor` ainda sinaliza ausência de `cmdline-tools` e status de licenças desconhecido, embora as licenças necessárias ao build tenham sido aceitas pelo Gradle. |
| Formatação | `dart format .` executado com sucesso: 8 arquivos processados, 2 alterados. |
| Análise | `flutter analyze` executado com sucesso: sem problemas. |
| Testes | `flutter test` executado com sucesso: 1 teste de widget aprovado. |
| Build Android | `flutter build apk --debug` executado com sucesso após ajustar `compileSdk` para 36, `minSdk` para 23 e NDK para 27.0.12077973. APK gerado em `build/app/outputs/flutter-apk/app-debug.apk`. Neste computador, o Gradle exigiu `GRADLE_OPTS=-Djavax.net.ssl.trustStoreType=Windows-ROOT` para usar a cadeia confiável do Windows sem desativar TLS. |
| Emulador Android | AVDs existentes foram encontrados (`Medium_Phone_API_36`, `Pixel_7`, `Pixel_8_Pro`), mas o `Pixel_7` não inicia: o Android Emulator Hypervisor Driver/virtualização necessária não está instalada. Não foi possível confirmar abertura do app em Android. |
| Pesquisa externa | Consultadas fontes oficiais em 2026-11-25; links e conclusões em `STORE_CHECKLIST.md` e `PRIVACY.md`. |

## Próximo passo

Para concluir integralmente o aceite da Etapa 1, habilitar a aceleração de virtualização ou conectar um dispositivo Android físico, iniciar o app e registrar o resultado. Também instalar `cmdline-tools` e executar a verificação de licenças para deixar o `flutter doctor` limpo. A Etapa 2 continua bloqueada até autorização explícita.
