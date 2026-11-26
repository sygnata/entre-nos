# ADR 0001 — Stack proposta para o MVP

- Status: Proposta; pendente de aprovação na Etapa 0.
- Data: 2026-11-25.

## Contexto

O roadmap sugere Flutter/Dart, Riverpod, Supabase e RevenueCat. O produto trata dados sensíveis e requer operações transacionais, RLS e compra não consumível.

## Proposta

Usar Flutter/Dart, Riverpod, `go_router`, Supabase (Auth, PostgreSQL, RLS, RPCs e Edge Functions) e RevenueCat somente na etapa de billing. Manter arquitetura feature-first com domain puro Dart e presentation sem acesso direto ao Supabase.

## Alternativas consideradas

- Backend Spring paralelo: rejeitado como proposta para o MVP por duplicar infraestrutura sem requisito identificado.
- Estado local confiável para Premium: rejeitado; entitlement precisa de fonte autoritativa no servidor.
- Realtime de votos: rejeitado inicialmente por ampliar superfície de exposição; usar refresh/polling moderado se necessário.

## Consequências e condições de aprovação

Exige avaliação de custo, localização/transferência de dados, suporte, RLS, backups e contratos dos fornecedores. Não criar projeto, credencial ou integração antes da aprovação da Etapa 1.
