# Privacidade e proteção de dados — rascunho de validação

Este documento registra requisitos para decisão de produto; não é política de privacidade final nem parecer jurídico.

## Classificação e princípio de minimização

Respostas e preferências podem revelar dados sobre vida sexual, definidos como dados pessoais sensíveis pela LGPD. A [Lei nº 13.709/2018](https://www.gov.br/mj/pt-br/assuntos/sua-protecao/sedigi/Lei13709.pdf) trata vida sexual como dado sensível e prevê consentimento específico e destacado para finalidades específicas, salvo outra hipótese legal aplicável. A [orientação da ANPD](https://www.gov.br/anpd/pt-br/assuntos/noticias/guia_lgpd_final.pdf) reforça que o consentimento deve ser livre, informado, inequívoco e revogável.

O produto deve coletar apenas: identificador de conta, confirmação de maioridade sem data de nascimento completa, registro de consentimento, estado de vínculo, votos e preferências estritamente necessários. Não coletar fotos íntimas, chat, perfis públicos, telemetria de perguntas/votos/matches ou dados de terceiros não necessários.

## Requisitos antes da coleta real

- Designar controlador, canal de contato e responsáveis por segurança/suporte.
- Obter avaliação jurídica da base legal, transparência e transferências internacionais dos fornecedores.
- Redigir política de privacidade, termos, tabela de retenção e procedimento de direitos do titular.
- Produzir avaliação de impacto e threat model: parceiro abusivo, conta comprometida, convite vazado, IDOR, logs, administrador e reembolso.
- Definir operadores, DPA/contratos, MFA administrativo, rotação de segredos e acesso mínimo.

## Consentimento e controles

- Obter consentimento específico e destacado antes de gravar votos; recusa permite apenas informações legais e catálogo gratuito sem coleta de resposta.
- Registrar versão, finalidade, data e revogação; não usar consentimento genérico.
- Permitir revogação simples e gratuita; ao revogar, interromper o tratamento e remover dados derivados conforme a base legal aplicável.
- Opt-in para descobertas possíveis deve ser independente, desligado por padrão e revogável.
- Nunca expor voto, motivo, progresso ou e-mail do parceiro.

## Retenção, exclusão e exportação

- Definir prazos de retenção para conta, votos, vínculos, logs de segurança, eventos de compra e backups antes do release.
- Ao encerrar vínculo, apagar votos, preferências, matches e dados compartilhados na mesma transação; compras próprias seguem retenção legal separada.
- Exclusão de conta requer reautenticação e deve informar prazo, dados mantidos por obrigação e tratamento de backups.
- Exportar somente dados do titular e resultados legitimamente compartilhados; jamais votos do parceiro.
- Não prometer exclusão instantânea de backups; definir expurgo e retries auditáveis sem conteúdo íntimo.

## Segurança mínima de arquitetura

- RLS default deny; escrita de voto e vínculo somente por RPC transacional; `service_role` ausente do cliente.
- TLS, armazenamento seguro de sessão, limpeza de cache no logout e nenhum voto persistido no dispositivo no MVP.
- Logs, crash reports, suporte e analytics não podem receber votos, perguntas respondidas, matches específicos ou tokens de convite.
- Não alegar criptografia ponta a ponta: o servidor precisa avaliar compatibilidade dos votos.
