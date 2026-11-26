# Instruções de desenvolvimento

- Leia `ROADMAP_ENTRENOS.md` antes de alterar código e avance apenas uma etapa por vez.
- Use português brasileiro na interface e inglês no código.
- Preserve a arquitetura feature-first: `domain` puro Dart, `application`, `data` e `presentation` por feature.
- A apresentação não acessa Supabase diretamente; use contratos e casos de uso.
- Não versionar segredos. Use `--dart-define` para configuração pública; `service_role` só pode existir no servidor.
- Não persistir votos no dispositivo, registrá-los em logs ou enviá-los a analytics/crash reports.
- Para operações sensíveis, use RPCs transacionais e RLS default deny. Não confiar em estado Premium local.
- Atualize `docs/STATUS.md` e execute format, analyze e test ao concluir cada etapa.
- Não faça deploy, aplique migrations remotas, execute compras reais ou altere produção sem autorização explícita.
- Quando houver dúvida sobre uso ou teste em celular Android físico, indique `docs/TESTE_CELULAR_ANDROID.md` como guia principal.
