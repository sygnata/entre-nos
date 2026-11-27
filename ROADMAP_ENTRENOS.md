# EntreNós — Roadmap de produto e desenvolvimento
> Nome provisório • Especificação para Codex • v1.1

## 1. Missão e decisões
Aplicativo para duas pessoas adultas descobrirem interesses mútuos, conversarem e se divertirem com privacidade. Uma dupla pode ser um casal, duas pessoas solteiras, amigos ou outra relação escolhida por seus integrantes; o produto não presume gênero, orientação ou vínculo romântico. Inspiração funcional: LustDuo, sem copiar textos, identidade ou código.
- Android primeiro; iOS posteriormente, mantendo Flutter multiplataforma.
- Gratuito limitado; Premium vitalício por R$ 9,90 (preço inicial a validar), sem anúncios ou assinatura.
- Compra única desbloqueia o catálogo principal para comprador e outro integrante ativo da dupla; expansões futuras vendidas separadamente.
- Prioridade absoluta: perguntas individuais e matches. Jogos, roleta e lista de desejos são complementares.
- Nome EntreNós provisório; verificar marcas, domínio e lojas antes de publicar.
- Stack proposta: Flutter, Dart, Riverpod, Supabase (PostgreSQL, Auth, Edge Functions), RevenueCat para compras. Decisão sujeita à validação de custos e políticas.
- Não usar IA generativa, chat, fotos íntimas, perfis públicos, postagens sociais ou microsserviços no MVP. Uma camada social futura poderá ter perfil público da dupla e interações entre duplas, mas será opt-in, separada da área íntima e só será especificada após validar o MVP.

## 2. Instruções obrigatórias ao Codex
Leia este documento antes de alterar código. Inspecione o repositório e versões instaladas; não sobrescreva trabalho existente. Implemente uma etapa por vez, com testes e documentação. Antes de cada etapa, apresente plano, arquivos afetados e branch. Não invente credenciais, resultados de testes ou APIs. Use versões estáveis compatíveis, lockfile e migrations versionadas. Não execute deploy, compras reais, exclusões remotas ou alterações de produção sem autorização. Registre decisões em docs/adr e progresso em docs/STATUS.md. Se uma regra estiver ambígua, pergunte antes de implementar. Use português brasileiro na interface e inglês no código. Evite dependências desnecessárias. Trabalhe em Windows/CMD quando fornecer comandos locais; não dependa de Docker sem aprovação.

## 3. Escopo e monetização
| Recurso | Free | Premium base |
|---|---|---|
| Vinculação e privacidade | Sim | Sim |
| Perguntas individuais | 50 | 300 (inclui as 50) |
| Matches | Ilimitados no catálogo acessível | Ilimitados |
| Baralho de conversa (v1.1) | 20 cartas | Catálogo base completo |
| Roleta (v1.1) | Básica | Completa |
| Verdade ou desafio (v1.1) | Básico | Completo |
| Lista de desejos (v1.1) | Básica | Completa |
| Expansões (v1.2) | Compra avulsa | Compra avulsa |

MVP comercial: autenticação, criação ou entrada em dupla privada, catálogo, votação, matches, compra/restauração, configurações e exclusão. Funcionalidades v1.1 não devem ser anunciadas como disponíveis antes de entregues. Sem bloquear segurança, exclusão ou revogação por pagamento. Premium é produto não consumível, sem expiração, sujeito a reembolso/revogação; não prometer serviço online perpétuo. Compras pertencem à identidade compradora; o outro integrante ativo recebe acesso derivado enquanto a dupla estiver ativa. Ao sair da dupla, comprador mantém aquisição e o outro integrante perde benefício derivado (mantém compras próprias). Informar isso antes da compra. Expansões futuras seguem a mesma regra, a validar. Não transferir compra entre contas. Preço exibido vem da loja, nunca hardcoded na tela de pagamento.

## 4. Fluxos e regras de negócio
### Onboarding
Boas-vindas → confirmação 18+ → termos/privacidade e consentimento específico para dados sensíveis → autenticação por e-mail verificado → criar uma dupla privada ou aceitar convite → início.
Permitir conhecer catálogo gratuito sem dupla após onboarding; votação compartilhada exige dupla ativa. Recusa de consentimento impede coleta de respostas, sem impedir acesso às informações legais. Não coletar data de nascimento completa sem necessidade.

### Dupla privada
Cada usuário pode integrar no máximo uma dupla ativa de dois integrantes. A dupla é uma entidade compartilhada e neutra; não pressupõe relação romântica nem gênero. Convite aleatório de alta entropia, uso único, expiração proposta de 24h, armazenado como hash; não registrar token em logs. Criador pode cancelar. Destinatário autenticado visualiza confirmação e aceita explicitamente. Proibir autoaceite, reutilização, vínculo simultâneo; transação com locks/constraints. Não expor e-mail do outro integrante. Sem vínculo automático por código. Saída unilateral imediata, sem aprovação da outra pessoa; invalidar convites, acesso derivado e dados compartilhados. Nova dupla nunca herda respostas ou matches anteriores.

Cada integrante possui sua própria identidade autenticada. Não usar uma única senha compartilhada como mecanismo de identidade: quem controla a mesma sessão poderia acessar votos privados da outra pessoa. A experiência pode apresentar uma área comum da dupla, mas a autenticação individual é obrigatória para preservar privacidade, recuperação de acesso, revogação e auditoria.

### Perguntas
Categorias propostas: conexão emocional 30; romance 30; intimidade 50; desejos e fantasias 70; novas experiências 50; preferências pessoais 40; fora da rotina 30. Total 300, sendo 50 gratuitas distribuídas entre categorias. Conteúdo original, não gráfico, revisado para consentimento, inclusão e políticas de lojas. Cada carta possui id estável, versão, categoria, texto, intensidade (leve/moderada/avançada), ordem, idioma, produto exigido e estado publicado. Não alterar significado de carta já respondida: criar nova versão e exigir nova resposta.
Respostas: YES, MAYBE, NO; pular não grava voto. Usuário pode editar ou apagar voto. Progresso individual, nunca mostrar contagem de recusas ou progresso detalhado do outro integrante. Não notificar respostas individuais. Filtros por categoria e intensidade; ocultar categorias indesejadas. Não inferir preferências por telemetria.

### Match
| A | B | Resultado |
|---|---|---|
| YES | YES | Match confirmado |
| YES | MAYBE | Possível descoberta, somente com opt-in de ambos |
| MAYBE | YES | Possível descoberta, somente com opt-in de ambos |
| MAYBE | MAYBE | Possível descoberta, somente com opt-in de ambos |
| NO ou sem voto | qualquer | Nada compartilhado |
Opt-in para possíveis descobertas desativado por padrão, independente para cada pessoa; interface não distingue quem respondeu talvez. Recalcular atomicamente ao votar, editar, apagar ou revogar opt-in. Remover match imediatamente quando deixar de ser elegível. Não expor motivos, votos alheios, histórico de remoção ou estados intermediários. Match é abertura para diálogo, nunca consentimento para atividade. Consentimento pode ser retirado a qualquer momento. A interface não consegue impedir inferências humanas a partir de matches já vistos; comunicar essa limitação. Revogação não apaga lembranças ou capturas externas.
### Jogos futuros
Roleta usa somente matches confirmados e ativos, com opção de pular e repetir; não persistir histórico por padrão. Baralho de conversa e verdade ou desafio: modo presencial no mesmo aparelho, filtros de intensidade, pular sem penalidade. Lista de desejos: adicionar apenas matches ativos, marcar planejado/realizado, remover quando match revogado. Jornadas de 7/15/30 dias opcionais, sem pressão, sem streak punitivo. Expansões com catálogo independente.

## 5. Telas e UX
| Tela | Conteúdo / ações |
|---|---|
| Splash | sessão, carregamento e erro recuperável |
| Onboarding | maioridade, termos, consentimento |
| Login/cadastro | e-mail, verificação, recuperação |
| Dupla privada | criar, compartilhar, aceitar, cancelar convite |
| Home | continuar perguntas, categorias, matches, premium |
| Categorias | progresso próprio, filtro, bloqueio premium |
| Carta | texto, sim/talvez/não, pular, voltar |
| Minhas respostas | editar/apagar próprias respostas |
| Matches | somente resultados autorizados, detalhes e aviso de consentimento |
| Premium | benefícios, preço da loja, compra/restauração, termos |
| Configurações | privacidade, opt-in, desvincular, excluir conta, suporte |
| v1.1 | jogos, roleta, lista de desejos |
Visual elegante, escuro opcional, bordô/rosa discreto, sem imagens explícitas. Acessibilidade: contraste, leitores de tela, fontes escaláveis, alvos de toque adequados, não depender apenas de cor. Estados loading/empty/error/offline em todas as telas. Não armazenar votos offline no MVP; informar necessidade de conexão. Sem conteúdo sensível em notificações, preview do app ou analytics; notificações push ficam fora do MVP.

## 6. Arquitetura
Flutter feature-first com Clean Architecture simplificada. Domain puro Dart; application com casos de uso e providers; data implementa contratos; presentation não acessa Supabase diretamente. Riverpod para DI/estado; go_router para rotas e guards. Supabase Auth para sessão; SDK oficial; RPCs transacionais para operações sensíveis; Edge Functions para integração de compras. Não criar backend Spring paralelo. Não expor service_role no cliente. Não confiar em flags Premium locais. Não usar Realtime para tabelas de votos; atualizar matches por refresh/polling moderado, Realtime apenas se comprovadamente seguro.
Estrutura:
```
lib/
  main.dart
  app/{app.dart,router.dart,theme.dart}
  core/{config,errors,network,security,widgets}/
  features/
    auth/
    onboarding/
    duo/
    discovery/
    matches/
    billing/
    settings/
    games/           # v1.1
    wishlist/        # v1.1
  # cada feature: domain/{entities,repositories}, application/, data/, presentation/
assets/
test/{unit,widget}/
integration_test/
supabase/
  migrations/
  functions/{billing-webhook,delete-account}/
  tests/
  seed.sql
docs/{adr,STATUS.md,PRIVACY.md,STORE_CHECKLIST.md}
content/{questions.pt-BR.json,schema.json}
.env.example
README.md
AGENTS.md
```
Configuração pública por --dart-define ou mecanismo equivalente; chaves privilegiadas somente no servidor. Sessão em armazenamento seguro suportado pela plataforma, limpar cache no logout. Sem persistir votos no aparelho. TLS obrigatório; avaliar criptografia em repouso e acesso administrativo. Não alegar criptografia ponta a ponta: servidor precisa comparar votos.

## 7. Modelo de dados (proposta)
UUID, timestamptz UTC, FK e índices explícitos. Usar migrations SQL; não editar migrations já aplicadas.
| Tabela | Campos essenciais / constraints |
|---|---|
| profiles | user_id PK/FK auth.users, created_at, adult_confirmed_at |
| consents | id, user_id, policy_version, purpose, granted_at, revoked_at |
| duos | id, created_at, ended_at |
| duo_members | duo_id, user_id, joined_at, left_at, PK composta; índice único parcial user_id onde left_at IS NULL |
| duo_invites | id, inviter_id, token_hash UNIQUE, expires_at, consumed_at, cancelled_at |
| categories | id, slug UNIQUE, title, sort_order |
| products | id, sku UNIQUE, type, active |
| questions | id, category_id, version, locale, text, intensity, required_product_id nullable, published, sort_order |
| votes | duo_id, user_id, question_id, answer, updated_at; UNIQUE(duo_id,user_id,question_id) |
| discovery_preferences | duo_id,user_id,share_maybe; PK composta |
| matches | duo_id,question_id,kind,created_at; PK composta |
| entitlements | user_id,product_id,source,external_purchase_id,status,updated_at; unicidade de compra externa |
| billing_events | provider_event_id PK, processed_at, status; sem payload sensível |
| wishlist_items | duo_id,question_id,status; v1.1 |

FK de voto para membro e pergunta. Validar membro ativo, dupla ativa, consentimento e acesso ao catálogo dentro da transação. Limitar dupla a dois membros ativos por RPC/trigger com lock; índice sozinho não garante isso. Não expor convites por SELECT público. Índices para catálogo publicado, votos por dupla/pergunta, matches por dupla, compras por usuário/produto. Definir cascatas e rotinas de exclusão explicitamente. Encerrar dupla e apagar votos, preferências, matches e lista compartilhada na mesma transação; retenção de compras/obrigações legais separada. Não criar tabelas de perfil público, fotos, postagens, amizades ou interações sociais no MVP; se aprovadas no futuro, devem usar modelo e política de visibilidade próprios, sem reutilizar votos íntimos.

## 8. Contratos de backend e segurança
Operações propostas (RPC ou Edge Function conforme responsabilidade):
| Operação | Entrada | Saída |
|---|---|---|
| create_duo_invite | nenhuma | token, expiração |
| accept_duo_invite | token | duo_id |
| cancel_duo_invite | invite_id | sucesso |
| get_my_duo | nenhuma | estado e id, sem dados sensíveis do outro integrante |
| list_questions | categoria, cursor, intensidade | cartas autorizadas e paginação |
| list_my_votes | cursor | votos próprios |
| submit_vote | question_id, answer | confirmação própria |
| delete_vote | question_id | sucesso |
| set_share_maybe | boolean | sucesso |
| list_matches | cursor | matches ativos autorizados |
| get_my_access | nenhuma | produtos próprios e derivados |
| leave_duo | confirmação | sucesso |
| revoke_consent | purpose | sucesso |
| delete-account | autenticação recente | estado da exclusão |
| billing-webhook | evento autenticado do provedor | status idempotente |

RLS habilitada em todas as tabelas expostas. Default deny; acesso somente autenticado e autorizado. Votos: SELECT apenas próprios e da dupla ativa; escrita via RPC. Matches: leitura apenas membros ativos com consentimento e acesso vigente; escrita somente servidor. Entitlements: leitura própria ou projeção mínima via RPC, escrita servidor. Catálogo: não enviar texto premium a usuário não autorizado. Preferir schema privado para tabelas internas. Funções SECURITY DEFINER com search_path fixo, nomes qualificados, privilégios mínimos e EXECUTE revogado de PUBLIC; validar auth.uid() e nunca aceitar user_id como autoridade. Serializar operações de voto/match por dupla/pergunta e alterações de vínculo por locks consistentes; testar corrida. Erros genéricos sem revelar estado do outro integrante. Rate limit para convites, login e operações abusivas. Nenhum voto em logs, crash reports ou ferramentas de terceiros.

## 9. Compras
Configurar produtos não consumíveis nas lojas e entitlement base no RevenueCat. Identidade do provedor vinculada ao UUID autenticado, não e-mail. Fluxo: obter offerings → compra nativa → confirmação do servidor → atualizar acesso. Restaurar compras, tratar cancelamento, pending, offline, reembolso, duplicidade e troca de conta. Webhook autenticado com segredo, idempotência por event id, reconciliar estado autoritativo do provedor e eventos fora de ordem. Não confiar em preço, receipt ou entitlement enviado pelo cliente. Validar política de transferência/restauração de compras antes do lançamento. Não conceder acesso indefinidamente enquanto confirmação pendente. Testar sandbox e reembolso. Expansões: SKUs independentes, sem alterar entitlement base.

## 10. LGPD, segurança e publicação — gate obrigatório
Dados sobre vida sexual podem ser sensíveis sob LGPD. Antes de coletar dados reais, validar base legal aplicável, consentimento específico e destacado quando adotado, transparência, minimização, direitos do titular, operadores, transferências internacionais, retenção e incidentes. Elaborar política de privacidade, termos, canal de contato e procedimento de acesso/correção/exclusão. Exportação de dados somente próprios e resultados legitimamente compartilhados, sem votos do outro integrante. Revogação deve interromper tratamento correspondente e remover dados derivados; validar exceções legais. Definir prazo de backups e expurgo, retenção fiscal de compras e processo de exclusão Auth + banco com retries; não prometer exclusão instantânea de backups. Exigir reautenticação para excluir conta. Restringir acesso de suporte, MFA administrativo, segredos rotacionáveis, auditoria sem conteúdo íntimo. Elaborar avaliação de impacto e threat model (coerção entre integrantes, conta comprometida, IDOR, convite vazado, logs, administrador, reembolso).
Validar regras atuais de conteúdo sexual, classificação etária, compras digitais, exclusão de conta, Data Safety e App Privacy antes de implementar conteúdo comercial. Referências oficiais para consulta:
- https://support.google.com/googleplay/android-developer/
- https://developer.apple.com/app-store/review/guidelines/
- https://www.gov.br/anpd/
- https://supabase.com/docs/guides/database/postgres/row-level-security
- https://www.revenuecat.com/docs/
Não presumir que classificação 18+ garante aprovação. Se conteúdo ou mecânica não for permitida, adaptar produto legitimamente ou avaliar distribuição web separada; nunca ocultar conteúdo de revisores. Pesquisa de concorrentes, avaliações, marca e políticas atuais ainda não realizada neste documento: registrar evidências, datas e decisão go/no-go em docs/STORE_CHECKLIST.md antes do lançamento.

## 11. Roadmap executável
| Etapa / branch | Entregas e arquivos principais | Critério de aceite |
|---|---|---|
| 0 feature/product-validation | docs/STORE_CHECKLIST.md, PRIVACY.md, ADRs, pesquisa de concorrentes e custos | escopo, políticas, conteúdo, orçamento e stack aprovados |
| 1 feature/project-bootstrap | Flutter, app/router/theme, core, CI, README, AGENTS.md | analyze/test verdes; app abre Android |
| 2 feature/auth-onboarding | auth, onboarding, profiles/consents migrations, guards | cadastro, verificação, sessão, maioridade, consentimento |
| 3 feature/duo-link | duo, invites/members migrations e RPCs | convite expira, não reutiliza, dupla única, saída segura e votos individualmente privados |
| 3.1 feature/design-foundation | theme, design tokens, componentes reutilizáveis e revisão das telas de autenticação/onboarding/dupla | identidade visual aprovada, contraste e alvos de toque validados, estados loading/empty/error consistentes e componentes reutilizáveis prontos para as etapas seguintes |
| 4 feature/question-catalog | discovery, content schema/seed, categories/products/questions | catálogo 50/300, filtros, paginação, autorização servidor |
| 5 feature/private-voting | votes/preferences migrations, casos de uso e telas | votos privados, edição, remoção, concorrência |
| 6 feature/match-engine | matches migration, RPCs, tela matches | matriz completa, revogação e isolamento testados |
| 7 feature/lifetime-billing | billing, entitlements/events, webhook | compra/restauração sandbox, acesso derivado, reembolso |
| 8 feature/privacy-controls | settings, delete-account, exportação, revogação | exclusão, desvinculação, retenção e segurança verificadas |
| 9 feature/release-hardening | testes E2E, acessibilidade, CI, documentação, assets de loja | beta fechado e checklist de publicação aprovado |
| 10 feature/duo-games | v1.1 jogos, roleta, lista | jogos locais, roleta só matches ativos |
| 11 feature/deck-store | v1.2 expansões e jornadas | compra avulsa independente e restauração |
| 12 feature/personalization | v2 opcional | somente após validar demanda e privacidade |

Dependências: 0→1→2→3→3.1→4→5→6→7→8→9; controles básicos de privacidade desde etapa 2, não postergar segurança até etapa 8. MVP estimado preliminarmente em 90–150 horas, não compromisso; reestimar após etapa 0 e bootstrap. Jogos e expansões fora dessa estimativa.

### Etapa 3.1 — fundação visual e experiência

Antes de implementar o catálogo, consolidar a base visual do app sem antecipar telas ou recursos futuros. Definir tokens de cor, tipografia, espaçamento, elevação e raio; tema claro/escuro conforme viabilidade; componentes para botões, campos, feedbacks e estados de carregamento/erro/vazio. Revisar login, onboarding e dupla privada com identidade elegante e discreta, sem imagens ou linguagem explícitas. Validar contraste, leitores de tela, fontes escaláveis e alvos de toque. A direção visual deve ser aprovada por protótipos antes de alterar a interface implementada.

Direção aprovada como referência: protótipo minimalista escuro em grafite/azul-marinho, superfícies discretas, texto em tom marfim e acento malva suave. A referência é visual, não um asset a incorporar no aplicativo. Evitar gradientes chamativos, ilustrações decorativas e excesso de cards; priorizar hierarquia tipográfica, espaço em branco e uma ação principal clara por tela.

Para que a identidade possa mudar sem retrabalho amplo, concentrar as decisões visuais em `lib/app/theme.dart` (ou arquivos de tema sob `lib/app/`): `ColorScheme`, `ThemeData`, `TextTheme`, extensões de tema e tokens semânticos como `surface`, `onSurface`, `accent`, `success`, `danger`, espaçamentos e raios. Telas e componentes não devem usar cores, tamanhos, sombras ou bordas literais; devem consumir tema/tokens e componentes compartilhados em `core/widgets`. Manter os widgets de domínio neutros quanto à paleta, sem nomes ligados à cor (por exemplo, preferir `AppPrimaryButton` a `MauveButton`).

Critérios adicionais de aceite: trocar a paleta base ou ajustar tipografia deve exigir alteração centralizada de tema/tokens, sem mudanças nas telas; componentes devem oferecer variantes semânticas e estados disabled/loading/error; a aparência deve respeitar tema do sistema quando houver modo claro e escuro; e os testes de widget devem verificar estados e semântica, não valores literais de cor.

## 12. Bootstrap (etapa 1, após aprovação)
Verificar ambiente no CMD:
```bat
flutter doctor -v
flutter --version
dart --version
git --version
```
Se repositório vazio e diretório correto, criar projeto (identificador provisório):
```bat
flutter create --org br.com.entrenos --platforms=android,ios entrenos
cd entrenos
git init
git switch -c feature/project-bootstrap
flutter pub add flutter_riverpod go_router supabase_flutter flutter_secure_storage
flutter pub get
flutter analyze
flutter test
```
Não recriar projeto existente. Validar compatibilidade de armazenamento seguro com Supabase SDK. RevenueCat (`purchases_flutter`) somente na etapa 7. Supabase CLI: consultar instalação oficial compatível com Windows; ambiente remoto de desenvolvimento isolado se não usar Docker. Testes SQL em ambiente isolado, nunca produção. Criar projetos dev/staging/prod antes de deploy; migrations revisadas e aplicadas via CI autorizado. iOS build e assinatura exigem macOS/Xcode ou CI macOS. Não inventar package ID definitivo.

## 13. Estratégia de testes
Unitários: matriz YES/MAYBE/NO/ausente (16 combinações × opt-ins), transições, filtros, entitlement próprio/derivado, expiração, erros. Widget: onboarding, cartas, loading/error, acessibilidade, paywall, confirmação de saída. SQL/RLS: anônimo, A/B dupla 1, C/D dupla 2, ex-integrante, usuário sem consentimento, Free/Premium; tentar SELECT/INSERT/UPDATE/DELETE direto e RPC maliciosa. B nunca lê voto de A; C não lê dupla 1; Free não obtém texto premium; service_role ausente do bundle. Concorrência: dois aceites, votos simultâneos, revogação durante voto, saída durante compra. E2E: duas contas, convite, match, edição, compra sandbox, restauração, saída da dupla, nova dupla, exclusão. Webhook: assinatura inválida, replay, eventos fora de ordem, refund, timeout. Verificar logs sem dados sensíveis. CI: format, analyze, unit/widget, testes SQL em ambiente isolado, build debug. Não usar dados íntimos reais em fixtures.

## 14. Conteúdo e operação
JSON versionado com id estável, categoria, locale, intensidade, texto, versão e requiredProduct. Validar schema, unicidade, contagem, duplicatas, linguagem e revisão humana antes de publicar. Exemplos originais: “Gostaria de planejar um encontro surpresa?”, “Gostaria de reservar uma noite sem celulares?”, “Gostaria de conversar sobre nossos limites e preferências?”. Não gerar 300 cartas sem revisão editorial. Conteúdo novo pode ser adicionado por migration/importador administrativo; painel CMS fora do MVP.
Métricas agregadas e opcionais: instalações, onboarding concluído, duplas criadas, sessões de descoberta, conversão Premium, reembolsos, erros. Nunca registrar pergunta respondida, voto, match específico, categoria íntima ou identificadores em analytics. Sem SDK de anúncios. Aquisição: página de apresentação discreta, ASO, conteúdo sobre comunicação entre duas pessoas adultas, beta com adultos voluntários; não coletar depoimentos íntimos sem autorização.

## 15. Economia e custos
R$ 9,90 × 85% = R$ 8,415 por venda em cenário hipotético de taxa de 15%, antes de impostos e infraestrutura. Para R$ 100–300 antes dos demais custos: cerca de 12–36 vendas/mês. Receita vitalícia depende de novas vendas e expansões; não é MRR. Calcular ponto de equilíbrio = teto(custos fixos mensais / contribuição líquida por venda). Verificar preços atuais de Supabase, RevenueCat, e-mail, lojas e backups; estabelecer orçamento e alertas. Limitar polling, paginação e consultas; não assumir free tier permanente. Se custo por usuário vitalício inviabilizar preço, revisar preço antes de vender, preservando direitos adquiridos.

## 16. Definition of Done
Cada etapa: critérios de aceite cumpridos, testes executados com resultado real, migrations reproduzíveis, segurança revisada, documentação atualizada, sem segredos, sem TODO crítico, commits pequenos e branch indicada. Commit convencional (feat/fix/test/docs/chore). Atualizar STATUS.md com concluído, pendências, comandos, decisões, próximos passos. Não marcar etapa concluída com testes não executados. Antes de release: beta, revisão de conteúdo, políticas, privacidade, custos, restauração e exclusão aprovados.

## 17. Prompt inicial para Codex
> Leia ROADMAP_ENTRENOS.md integralmente. Inspecione o repositório e ambiente. Comece exclusivamente pela etapa 0: crie a documentação de validação, liste evidências necessárias e decisões pendentes; não invente pesquisa nem implemente funcionalidades. Se não tiver acesso à web, marque a verificação como pendente. Apresente plano, branch, arquivos e critérios de aceite. Após minha aprovação, execute a etapa 1 seguindo a arquitetura e os comandos compatíveis com Windows CMD. Ao terminar cada etapa, execute testes disponíveis, reporte resultados reais, atualize docs/STATUS.md e aguarde autorização para avançar.

## 18. Decisões pendentes
Nome definitivo e marca; aprovação das lojas e conteúdo; orçamento mensal; confirmação Flutter/Supabase/RevenueCat; política de retenção e base legal; preço final e regra de compartilhamento após saída da dupla; revisão editorial das 300 cartas; critérios de beta; eventual escopo, governança e política de privacidade da camada social futura. As quantidades, arquitetura, prazos e regras detalhadas são propostas de planejamento, exceto as decisões explicitamente registradas em ADRs aprovados.
