# Status do projeto

## Etapa atual

- Etapa: 2 — autenticação e onboarding.
- Branch: `feature/auth-onboarding`.
- Situação: concluída; roadmap revisado para a próxima etapa de dupla privada.
- Última atualização: 2026-11-27.

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
| Autenticação e onboarding local | Implementados contrato, repositório Supabase, estado de sessão, cadastro/login por e-mail, bloqueio de e-mail não confirmado, confirmação 18+ e consentimento específico. O app verifica a persistência do consentimento antes de liberar a tela provisória de conta pronta. |
| Validação da Etapa 2 (parcial) | Em 2026-11-26, `dart format lib test`, `flutter analyze` e `flutter test` foram executados com sucesso; análise sem problemas e 1 teste de widget aprovado. |
| Deep link de confirmação | Implementado para Android com `br.com.entrenos.entrenos://auth-callback/`; análise, teste e build debug concluídos. Em 2026-11-27, o responsável confirmou o e-mail pelo link e retornou ao app com sucesso. Em projeto gratuito novo com SMTP padrão, o template pode ficar somente em visualização; ele não precisa ser alterado para este fluxo. |
| Correção de leitura do onboarding | Diagnóstico no dispositivo retornou HTTP 403 após o login. Migration `202611270001_grant_onboarding_read_access.sql` concedeu somente `SELECT` a `authenticated`; a RLS continua restringindo o acesso ao próprio usuário. A migration foi aplicada no Supabase dev e o reteste em 2026-11-27 chegou à tela “Conta pronta”. |
| Teste SQL/RLS da Etapa 2 | Roteiro transacional em `supabase/tests/20261127_profiles_consents_rls.sql` executado com sucesso no SQL Editor do EntreNos-dev em 2026-11-27: `PASS: profiles/consents RLS and privileges verified`. O teste validou leitura própria, isolamento de outro usuário, ausência de privilégios de escrita direta e bloqueio de leitura/RPCs para anônimo. A CLI `db query --remote` continuou indisponível neste computador por erro de transporte no endpoint de gerenciamento, inclusive para `SELECT 1`. |
| Formatação | `dart format .` executado com sucesso: 8 arquivos processados, 2 alterados. |
| Análise | `flutter analyze` executado com sucesso: sem problemas. |
| Testes | `flutter test` executado com sucesso: 1 teste de widget aprovado. |
| Build Android | `flutter build apk --debug` executado com sucesso na versão de autenticação/onboarding em 2026-11-26. APK gerado em `build/app/outputs/flutter-apk/app-debug.apk`. Neste computador, o Gradle exigiu `GRADLE_OPTS=-Djavax.net.ssl.trustStoreType=Windows-ROOT` para usar a cadeia confiável do Windows sem desativar TLS. |
| Emulador Android | AVDs existentes foram encontrados (`Medium_Phone_API_36`, `Pixel_7`, `Pixel_8_Pro`), mas o `Pixel_7` não inicia: o Android Emulator Hypervisor Driver/virtualização necessária não está instalada. Não foi possível confirmar abertura do app em Android. |
| Dispositivo Android físico | Teste executado pelo responsável em 2026-11-26: o APK foi compilado, instalado e aberto no dispositivo `2311DRK48I`; a tela esperada “Em preparação” foi exibida. |
| Pesquisa externa | Consultadas fontes oficiais em 2026-11-25; links e conclusões em `STORE_CHECKLIST.md` e `PRIVACY.md`. |

## Decisão de escopo registrada em 2026-11-27

- O produto passa a atender uma **dupla de duas pessoas adultas**, sem pressupor casal, gênero, orientação ou vínculo romântico.
- A área íntima permanece o único escopo do MVP. Perfil público da dupla, fotos, postagens, amizades e interação entre duplas ficam explicitamente fora do MVP.
- A dupla terá área compartilhada, mas cada integrante continuará usando sua própria identidade autenticada. Uma senha única compartilhada foi rejeitada por não preservar votos individuais privados.
- A decisão está detalhada no ADR `0004-dupla-privada-e-identidades-individuais.md`.

## Próximo passo

Aguardar autorização para iniciar a Etapa 3 (formação de dupla privada) na branch `feature/duo-link`. A etapa incluirá migrations e RPCs de convites, membros e saída segura.
