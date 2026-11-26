# Ambiente Supabase de desenvolvimento

Crie um projeto **exclusivo de desenvolvimento** no painel do Supabase. Não use produção, nem compartilhe chaves privilegiadas.

## Criar o projeto

1. Acesse o painel do Supabase e crie uma organização/projeto de desenvolvimento.
2. Escolha uma senha forte para o banco e guarde-a em gerenciador de senhas; não a envie pelo chat nem a versione.
3. Em **Authentication > Providers**, mantenha e-mail habilitado e confirme que a verificação de e-mail está ativada antes de testes reais.
4. Em **Authentication > URL Configuration**, adicione apenas URLs de desenvolvimento quando houver fluxo de deep link definido.

## Configuração pública do app

No painel, copie somente a **Project URL** e a chave **anon/publishable**. Elas são configuração pública do cliente, mas não devem ser commitadas.

Execute localmente no CMD:

```bat
flutter run --dart-define=SUPABASE_URL=SUA_PROJECT_URL --dart-define=SUPABASE_PUBLISHABLE_KEY=SUA_CHAVE_PUBLISHABLE
```

Nunca forneça ou use no Flutter:

- `service_role`
- senha do banco
- token pessoal de acesso
- segredo de webhook

## Antes de aplicar migrations

- Confirme que o projeto é de desenvolvimento.
- Revise `supabase/migrations/202611260001_profiles_and_consents.sql`.
- Instale e autentique a CLI oficial do Supabase no Windows seguindo a documentação oficial.
- Aplique migrations somente por fluxo revisado e autorizado; não execute comandos contra produção.

Após criar o projeto, informe apenas que ele está pronto e forneça a URL pública e chave anônima por um canal seguro, se desejar que a integração local seja validada.
