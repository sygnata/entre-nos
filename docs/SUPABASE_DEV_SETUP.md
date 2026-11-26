# Ambiente Supabase de desenvolvimento

Crie um projeto **exclusivo de desenvolvimento** no painel do Supabase. Não use produção, nem compartilhe chaves privilegiadas.

## Criar o projeto

1. Acesse o painel do Supabase e crie uma organização/projeto de desenvolvimento.
2. Escolha uma senha forte para o banco e guarde-a em gerenciador de senhas; não a envie pelo chat nem a versione.
3. Em **Authentication > Providers**, mantenha e-mail habilitado e confirme que a verificação de e-mail está ativada antes de testes reais.
4. Em **Authentication > URL Configuration > Additional Redirect URLs**, adicione exatamente `br.com.entrenos.entrenos://auth-callback/`. Esta é a URL de retorno do app Android de desenvolvimento; não use `localhost:3000`.
5. Em projetos gratuitos novos que usam o SMTP padrão, os templates podem ficar somente em visualização. Não é necessário alterá-los para este teste: o template padrão usa a URL de confirmação e o app informa a URL de retorno permitida no cadastro. A edição do template exige SMTP próprio ou plano elegível.

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

## Testar confirmação de e-mail no Android

1. Instale uma nova versão do app após compilar com a alteração de deep link.
2. Cadastre um e-mail ainda não confirmado e abra **somente o link mais recente** recebido.
3. O Android deve oferecer/abrir o EntreNós; o app deve retornar à sessão autenticada.
4. Se surgir `otp_expired`, solicite um novo e-mail de confirmação e abra-o uma única vez. Links de confirmação são de uso único e expiram.

## Antes de aplicar migrations

- Confirme que o projeto é de desenvolvimento.
- Revise `supabase/migrations/202611260001_profiles_and_consents.sql`.
- Instale e autentique a CLI oficial do Supabase no Windows seguindo a documentação oficial.
- Aplique migrations somente por fluxo revisado e autorizado; não execute comandos contra produção.

Após criar o projeto, informe apenas que ele está pronto e forneça a URL pública e chave anônima por um canal seguro, se desejar que a integração local seja validada.
