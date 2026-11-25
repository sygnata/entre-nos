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
| Android | SDK 35.0.1 encontrado, porém faltam `cmdline-tools` e licenças aceitas; execução Android permanece pendente. |
| Formatação | `dart format .` executado com sucesso: 8 arquivos processados, 2 alterados. |
| Análise | `flutter analyze` executado com sucesso: sem problemas. |
| Testes | `flutter test` executado com sucesso: 1 teste de widget aprovado. |
| Build Android | `flutter build apk --debug` falhou porque o Gradle não conseguiu baixar `com.android.tools.build:gradle:8.6.1`: erro de certificado SSL (PKIX) em `dl.google.com` e Maven Central. Nenhum APK foi produzido. |
| Pesquisa externa | Consultadas fontes oficiais em 2026-11-25; links e conclusões em `STORE_CHECKLIST.md` e `PRIVACY.md`. |

## Próximo passo

Corrigir o ambiente Android (cadeia de certificados Gradle, `cmdline-tools` e licenças) e executar build/abertura Android. A Etapa 2 continua bloqueada até autorização explícita.
