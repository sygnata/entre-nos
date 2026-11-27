# Status do projeto

## Etapa atual

- Etapa: 3.1 — fundação visual e experiência (concluída).
- Branch: `feature/design-foundation`.
- Situação: concluída, com validação visual aceita pelo responsável.
- Última atualização: 2026-11-27.

## Concluído na Etapa 0

- Leitura integral de `ROADMAP_ENTRENOS.md`.
- Inspeção do repositório: não havia aplicação, dependências, migrations ou automações existentes.
- Registro de evidências oficiais de lojas, LGPD e custos iniciais.
- Registro de decisões arquiteturais como propostas, não como decisões aprovadas.

## Pendências de produto

1. Aprovar ou reformular o posicionamento e o catálogo para compatibilidade com as lojas.
2. Definir responsável jurídico/controlador, base legal, retenção, operadores e transferências internacionais.
3. Aprovar orçamento mensal, preço final e modelo de acesso derivado após saída da dupla.
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

## Etapa 2.1 — alinhamento ao modelo de dupla

- Mensagem pós-onboarding, documentação de privacidade e validação de produto alinhadas ao conceito de dupla privada.
- Não houve migration, alteração de RLS nem operação remota: `profiles`, `consents` e a autenticação individual já atendem ao novo modelo.
- Em 2026-11-27, `dart format .`, `flutter analyze` e `flutter test` concluídos com sucesso nesta branch; análise sem problemas e 1 teste aprovado.

## Etapa 3 — formação de dupla privada (concluída)

- Branch: `feature/duo-link`.
- Escopo: convite de uso único, dupla com duas identidades autenticadas, cancelamento e saída unilateral segura.
- Correção local: a tela de dupla agora exibe a ação **Sair da conta**, para alternar entre as duas identidades durante os testes. A ação reutiliza o encerramento de sessão do repositório de autenticação e não altera dados da dupla.
- Correção local adicional: o estado de onboarding agora depende da sessão autenticada. Assim, ao trocar de conta, a segunda identidade não herda em memória o consentimento da primeira e deve concluir a confirmação de idade e o consentimento específico.
- Correção local adicional: na abertura, o app valida a sessão persistida com o Supabase. Caso a conta tenha sido removida no servidor, a sessão local é encerrada e a tela de login é exibida; a tela de consentimento também oferece ação para sair.
- Migration aplicada no Supabase dev em 2026-11-27: `202611270003_shorten_duo_invite_codes.sql` passa a gerar códigos alfanuméricos criptograficamente aleatórios de 16 caracteres. Convites pendentes emitidos no formato anterior de 64 caracteres foram cancelados e precisam ser gerados novamente.
- Compatibilidade transitória: o campo de convite aceita até 64 caracteres para permitir o uso de códigos legados somente enquanto houver uma versão anterior do app instalada; o backend agora gera somente 16 caracteres.
- Validação manual em dispositivo Android: duas contas confirmadas concluíram onboarding individual, criaram e aceitaram convite, e a segunda conta exibiu “Dupla formada com privacidade”. A expiração e o cancelamento de convite também foram validados.
- Teste SQL/RLS da Etapa 3: `supabase/tests/20261127_duos_rls.sql` executado com sucesso no SQL Editor do EntreNos-dev em 2026-11-27, após usar duas contas de teste sem dupla ativa. O roteiro confirmou RPCs exclusivos, bloqueio anônimo, aceite, proibição de autoaceite/reuso e saída segura em transação revertida.
- CI: pipeline aprovado, incluindo `dart format --output=none --set-exit-if-changed .` após o commit `4300a1a`.

## Etapa 3.1 — fundação visual e experiência

- Branch: `feature/design-foundation`.
- A direção aprovada foi aplicada como tema minimalista: superfícies grafite/azul-marinho no modo escuro, texto claro e acento malva suave. Não foram adicionadas imagens nem assets decorativos.
- `EntreNosTokens`, `ColorScheme`, tipografia e estilos de controles foram centralizados em `lib/app/theme.dart`. As telas não usam cores, raios ou sombras literais para definir a identidade.
- Foram adicionados os componentes reutilizáveis `AppPage` e `AppSectionCard` em `lib/core/widgets/` e aplicados às telas de login/cadastro, consentimento e dupla privada, incluindo estados de convite e dupla formada.
- O convite gerado passou a ter o código em um painel dedicado e a expiração é exibida no padrão brasileiro `DD/MM/AAAA HH:MM`. Títulos usam a família serifada genérica do sistema; textos de leitura permanecem na família padrão da plataforma.
- A assinatura visual `EntreNós` foi centralizada em `AppBrand` e aparece no canto superior esquerdo das telas da etapa; “Nós” usa a cor de destaque do tema, sem cor literal nos widgets.
- `AppPage` possui fallback de tokens para manter widgets testáveis isoladamente; isso evita acoplamento dos testes ao tema do app.
- Validação em 2026-11-27: `dart format lib test`, `flutter analyze` e `flutter test` concluídos com sucesso. Análise sem problemas e 5 testes aprovados.
- Validação visual em dispositivo Android físico aceita pelo responsável em 2026-11-27; etapa concluída.

## Próximo passo

Solicitar autorização para iniciar a Etapa 4 (catálogo de perguntas) em uma nova branch.
