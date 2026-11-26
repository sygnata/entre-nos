# Validação de produto — Etapa 0

## Objetivo

Validar se o EntreNós pode ser lançado como aplicativo móvel para adultos sem comprometer privacidade, segurança, regras das lojas ou viabilidade econômica. Este documento não aprova o produto nem substitui aconselhamento jurídico.

## Escopo proposto para o MVP

- Autenticação por e-mail verificado, confirmação de maioridade e consentimento específico.
- Vínculo privado entre duas pessoas adultas, por convite de uso único e expiração.
- Perguntas individuais não gráficas, votos privados e matches autorizados.
- Compra única não consumível, restauração e controles de privacidade/exclusão.

Fora do MVP: chat, fotos íntimas, perfis públicos, conteúdo gerado por usuários, IA generativa, anúncios, notificações com conteúdo sensível, jogos e expansões.

## Hipóteses a validar

| Hipótese | Evidência necessária | Estado |
|---|---|---|
| O catálogo pode permanecer em lojas móveis | Revisão jurídica/editorial por carta e confirmação de enquadramento não explícito. | Bloqueada |
| Há demanda pagante para compra única | Entrevistas com adultos voluntários, teste de mensagem e beta sem dados íntimos. | Pendente |
| R$ 9,90 sustenta a operação | Orçamento mensal, impostos, taxas, volume e cenários de reembolso. | Pendente |
| Flutter + Supabase + RevenueCat atende ao MVP | Avaliação de custos, contratos, residência/transferência de dados, segurança e suporte. | Pendente |
| O benefício ao parceiro vinculado é compreensível e permitido | Revisão de termos de loja, do provedor de compras e de redação pré-compra. | Pendente |

## Go/no-go da Etapa 0

**Status: NO-GO provisório.** Não iniciar desenvolvimento do produto até que todos os bloqueios abaixo tenham decisão registrada.

1. O conteúdo e os metadados de loja devem ser explicitamente não gráficos, não pornográficos e não orientados à gratificação sexual.
2. Jurídico/privacidade deve aprovar a base legal e o desenho de consentimento para dados de vida sexual.
3. Deve existir orçamento de operação e política de retenção/exclusão aprovada.
4. Nome e identidade devem passar por busca de disponibilidade de marca, domínio e lojas.
5. Deve haver decisão documentada sobre a stack e compra única antes do bootstrap.

## Riscos principais

| Risco | Mitigação proposta |
|---|---|
| Reprovação ou remoção em loja | Posicionamento de comunicação entre casais; revisão humana; nenhuma descrição explícita, imagens sugestivas, chat ou UGC; submissão transparente. |
| Exposição de dados sensíveis | Mínima coleta, consentimento destacado, RLS/RPC, sem logs/analytics de votos e exclusão verificável. |
| Inferência de voto do parceiro | Mostrar apenas matches elegíveis, nunca votos, motivos ou estados intermediários. |
| Preço inviável para custo vitalício | Planilha de ponto de equilíbrio e alertas de custo antes da venda. |
| Abuso por parceiro ou conta comprometida | Desvinculação unilateral, reautenticação em exclusão, ameaças modeladas e suporte restrito. |

## Evidências ainda necessárias

- Consulta jurídica LGPD e avaliação de impacto (DPIA/RIPD) apropriada ao tratamento.
- Revisão das 300 perguntas por editor(a) e especialista em consentimento/inclusão.
- Busca formal de marca, domínio e handles de loja para o nome definitivo.
- Política atual de comissão, produtos não consumíveis, restauração e compartilhamento familiar/entre contas nas lojas.
- Orçamentos reais para Supabase, RevenueCat, e-mail transacional, domínio, suporte, backups, impostos e contas de desenvolvedor.
- Pesquisa de concorrentes e entrevistas, sem coletar relatos íntimos ou dados sensíveis desnecessários.
