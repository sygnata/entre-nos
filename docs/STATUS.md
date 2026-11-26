# Status do projeto

## Etapa atual

- Etapa: 2 — autenticação e onboarding.
- Branch: `feature/auth-onboarding`.
- Situação: em andamento.
- Última atualização: 2026-11-26.

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
| Android | SDK 36.0.0, NDK 27.0.12077973 e Command-line Tools instalados. `flutter doctor -v` confirma o toolchain Android e todas as licenças aceitas. |
| Supabase dev | Projeto `EntreNos-dev` (`jilftgawlpavattmimqk`) vinculado e migration `202611260001_profiles_and_consents.sql` aplicada em 2026-11-26. E-mail com confirmação foi configurado pelo responsável. |
| Formatação | `dart format .` executado com sucesso: 8 arquivos processados, 2 alterados. |
| Análise | `flutter analyze` executado com sucesso: sem problemas. |
| Testes | `flutter test` executado com sucesso: 1 teste de widget aprovado. |
| Build Android | `flutter build apk --debug` executado com sucesso após ajustar `compileSdk` para 36, `minSdk` para 23 e NDK para 27.0.12077973. APK gerado em `build/app/outputs/flutter-apk/app-debug.apk`. Neste computador, o Gradle exigiu `GRADLE_OPTS=-Djavax.net.ssl.trustStoreType=Windows-ROOT` para usar a cadeia confiável do Windows sem desativar TLS. |
| Emulador Android | AVDs existentes foram encontrados (`Medium_Phone_API_36`, `Pixel_7`, `Pixel_8_Pro`), mas o `Pixel_7` não inicia: o Android Emulator Hypervisor Driver/virtualização necessária não está instalada. Não foi possível confirmar abertura do app em Android. |
| Dispositivo Android físico | Teste executado pelo responsável em 2026-11-26: o APK foi compilado, instalado e aberto no dispositivo `2311DRK48I`; a tela esperada “Em preparação” foi exibida. |
| Pesquisa externa | Consultadas fontes oficiais em 2026-11-25; links e conclusões em `STORE_CHECKLIST.md` e `PRIVACY.md`. |

## Próximo passo

Implementar as telas e contratos locais de autenticação/onboarding. A integração e os testes SQL exigem um projeto Supabase de desenvolvimento isolado, ainda não configurado.
