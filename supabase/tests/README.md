# Testes SQL

Os testes de RLS desta etapa exigem um projeto Supabase de desenvolvimento isolado. Antes de executá-los, configurar a CLI oficial em Windows e aplicar esta migration somente nesse ambiente. Nunca apontar testes para produção.

Cobrir: anônimo sem acesso; usuário A lê apenas seu perfil/consentimentos; usuário B não lê A; execução anônima das RPCs é negada; consentimento é versionado e revogável.

As tabelas `profiles` e `consents` concedem somente `SELECT` ao papel
`authenticated`; a RLS ainda limita cada consulta ao `auth.uid()` do próprio
usuário. Nenhum papel de cliente recebe `INSERT`, `UPDATE` ou `DELETE` direto.

Execute o roteiro de validação no projeto de desenvolvimento vinculado:

```bat
npx supabase db query --remote --read-only --file supabase/tests/20261127_profiles_consents_rls.sql
```

O resultado esperado é `PASS: profiles/consents RLS and privileges verified`.
O roteiro é somente leitura: privilégios de escrita direta são verificados pelo
catálogo do PostgreSQL, sem executar `INSERT`, `UPDATE` ou `DELETE`.
