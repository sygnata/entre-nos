# Teste em celular Android físico

Use este guia para instalar e abrir a versão de desenvolvimento do EntreNós em um aparelho Android conectado por USB.

## Pré-requisitos

- Android SDK configurado e licenças aceitas. Confirme com `flutter doctor -v`.
- Cabo USB com transferência de dados.
- Celular Android desbloqueado.
- Projeto aberto na pasta raiz `EntreNos`.

## Preparar o celular

1. Abra **Configurações > Sobre o telefone**.
2. Toque sete vezes em **Número da versão** ou **Número da compilação**.
3. Volte para Configurações e abra **Opções do desenvolvedor**.
4. Ative **Depuração USB**.
5. Conecte o celular ao computador com o cabo USB.
6. No celular, aceite a solicitação **Permitir depuração USB?** e mantenha a tela desbloqueada.

## Confirmar a conexão

No CMD, na raiz do projeto, execute:

```bat
flutter devices
```

O celular deve aparecer como dispositivo Android. Se aparecer como `unauthorized`, desbloqueie-o e aceite a chave RSA. Se não aparecer, confira se o USB está no modo **Transferência de arquivos** e instale o driver USB do fabricante, se necessário.

## Instalar e abrir o app

Neste computador, configure temporariamente o Gradle para usar a cadeia de certificados confiáveis do Windows:

```bat
set GRADLE_OPTS=-Djavax.net.ssl.trustStoreType=Windows-ROOT
flutter run --dart-define=SUPABASE_URL=SUA_PROJECT_URL --dart-define=SUPABASE_PUBLISHABLE_KEY=SUA_CHAVE_PUBLISHABLE
```

Se houver mais de um dispositivo conectado, informe o identificador exibido por `flutter devices`:

```bat
flutter run -d ID_DO_CELULAR --dart-define=SUPABASE_URL=SUA_PROJECT_URL --dart-define=SUPABASE_PUBLISHABLE_KEY=SUA_CHAVE_PUBLISHABLE
```

O comando compila, instala uma versão de depuração e abre o app no celular. Ele não publica o app na Play Store.

## Confirmação de e-mail

O teste de cadastro requer a configuração de deep link descrita em `docs/SUPABASE_DEV_SETUP.md`. Depois de instalar a versão atualizada, cadastre uma conta e abra apenas o link de confirmação mais recente. O retorno esperado é abrir o EntreNós, não `localhost`.

## Durante o desenvolvimento

Com `flutter run` em execução no CMD:

- Pressione `r` para hot reload.
- Pressione `R` para hot restart.
- Pressione `q` para encerrar a sessão.

## Solução de problemas

| Sintoma | Ação |
|---|---|
| O celular não aparece | Teste outro cabo/porta USB, habilite transferência de arquivos e confira o driver do fabricante. |
| Aparece `unauthorized` | Desbloqueie o aparelho e aceite a solicitação de depuração USB. Se necessário, revogue autorizações de depuração USB e reconecte. |
| Erro `PKIX path building failed` | Antes de executar o Flutter, rode `set GRADLE_OPTS=-Djavax.net.ssl.trustStoreType=Windows-ROOT`. Não desative TLS. |
| Mais de um dispositivo | Execute `flutter run -d ID_DO_CELULAR`. |

Após o primeiro teste bem-sucedido, informe o resultado para que ele seja registrado em `docs/STATUS.md` e o critério Android da Etapa 1 seja confirmado.
