# Checklist de lojas, conteúdo e custos

Atualizado em 2026-11-25. Evidência significa fonte consultada; não equivale a aprovação prévia de nenhuma loja.

## Decisão de conteúdo e lojas

| Item | Evidência oficial | Impacto para o EntreNós | Estado |
|---|---|---|---|
| Google Play — conteúdo sexual | [Inappropriate Content](https://support.google.com/googleplay/android-developer/answer/9878810?hl=en) proíbe conteúdo sexual, pornografia e conteúdo destinado à gratificação sexual; a exceção EDSA é limitada. | O conceito e cada pergunta exigem revisão severa. Não publicar conteúdo explícito, gráficos, fetiches, imagens sugestivas ou linguagem de gratificação sexual. | Bloqueador |
| App Store — conteúdo sexual | [App Review Guidelines 1.1.4](https://developer.apple.com/app-store/review/guidelines/) veda material sexual manifesto ou pornográfico e apps de hookup. | Posicionar como comunicação/consentimento para adultos não garante aprovação; revisar integralmente conteúdo e metadados. | Bloqueador |
| Conta e exclusão no Google Play | [Requisito de exclusão](https://support.google.com/googleplay/android-developer/answer/13327111?hl=en-en) exige caminho no app e recurso web para solicitar exclusão. | MVP precisa de exclusão no app e página web funcional antes do lançamento Android. | Obrigatório no release |
| Conta e exclusão na Apple | [Guia 5.1.1(v)](https://developer.apple.com/help/app-review/guideline-reference/5-1-1-account-deletion/) exige iniciar exclusão no app. | O fluxo deve excluir conta e dados associados, informar retenções legais e permitir reautenticação proporcional. | Obrigatório no release |
| Transparência de dados no Google Play | [User Data](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en-GB) exige formulário Data safety correto e consistente com a política. | Inventariar SDKs e fluxos antes de preencher o formulário; não adicionar analytics sem revisão. | Obrigatório no release |
| Privacidade na Apple | [Guideline 5.1.1](https://developer.apple.com/app-store/review/guidelines/) exige política acessível, coleta explicada e retenção/exclusão descritas. | Política de privacidade pública e dentro do app é pré-requisito de release. | Obrigatório no release |

## Checklist de go/no-go

- [ ] Conselho jurídico confirma enquadramento, base legal e texto de consentimento.
- [ ] Revisão editorial aprova todo conteúdo para uso nas lojas, sem promessa de gratificação sexual.
- [ ] Classificação etária e questionários de conteúdo foram preenchidos com fatos verificáveis.
- [ ] Política de privacidade, termos, suporte e página web de exclusão têm responsável e URLs definitivas.
- [ ] Data Safety (Google) e App Privacy (Apple) são derivados de inventário técnico real.
- [ ] Nome definitivo passou por análise de marca, domínio e disponibilidade de listagem.
- [ ] Processo de revisão de loja recebe acesso de teste e explicação transparente do fluxo.
- [ ] Critérios de beta com adultos voluntários foram aprovados.

## Custos — referências iniciais, a confirmar antes de contratar

| Serviço | Evidência consultada | Informação observada em 2026-11-25 | Decisão pendente |
|---|---|---|---|
| Supabase | [Pricing](https://supabase.com/pricing) | Plano Free: 2 projetos ativos, pausa após 1 semana de inatividade; Pro a partir de US$ 25/mês, com franquias e excedentes. | Definir dev/staging/prod, backups, região, limite de gasto e orçamento. |
| RevenueCat | [Pricing](https://www.revenuecat.com/pricing) | Gratuito até US$ 2.500 de receita mensal monitorada; depois 1% da receita monitorada, conforme página. | Confirmar suporte ao modelo de produto, webhook e custos na data de contratação. |
| Apple/Google/e-mail/domínio/backups/impostos | Sem fonte consolidada nesta etapa. | Não calculado. | Obter preços e obrigações vigentes antes da decisão de preço. |

Fórmula de referência: `ponto de equilíbrio = teto(custos fixos mensais / contribuição líquida por venda)`. O preço exibido deve sempre vir da loja; R$ 9,90 é apenas hipótese do roadmap.

## Pesquisa de concorrentes

Não realizada nesta etapa. Antes do beta, registrar concorrentes, data, fonte, proposta observada e diferenças legítimas, sem copiar identidade, textos ou código.
