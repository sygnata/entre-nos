# Testes SQL

Os testes de RLS desta etapa exigem um projeto Supabase de desenvolvimento isolado. Antes de executá-los, configurar a CLI oficial em Windows e aplicar esta migration somente nesse ambiente. Nunca apontar testes para produção.

Cobrir: anônimo sem acesso; usuário A lê apenas seu perfil/consentimentos; usuário B não lê A; execução anônima das RPCs é negada; consentimento é versionado e revogável.
