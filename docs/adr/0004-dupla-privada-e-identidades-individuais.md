# ADR 0004 — Dupla privada e identidades individuais

- Status: Aceita.
- Data: 2026-11-27.

## Contexto

O produto deixa de pressupor que as duas pessoas formam um casal. A experiência privada deve atender qualquer dupla de adultos, inclusive casais, pessoas solteiras ou amigos, sem inferir gênero, orientação ou vínculo romântico. Há também uma intenção futura de oferecer perfil social da dupla e interação com outras duplas.

## Decisão

Adotar **dupla** como conceito de produto e `duo` como termo de código. Uma dupla tem exatamente dois integrantes ativos e é a fronteira dos resultados compartilhados, como matches.

Cada integrante mantém sua própria identidade autenticada e é ligado à dupla por convite explícito. A interface pode exibir uma área comum da dupla, mas não haverá uma única credencial compartilhada para responder em nome das duas pessoas. Votos continuam vinculados à identidade de quem os enviou e só resultados autorizados são compartilhados.

O MVP abrange exclusivamente a área íntima e privada: vínculo da dupla, perguntas, votos individuais, matches, acesso Premium e controles de privacidade. Não serão criados perfil público, fotos, postagens, amizades ou match entre duplas no MVP.

## Consequências

- A antiga nomenclatura `couple` passa a ser `duo` nas futuras features, migrations, RPCs e testes da Etapa 3 em diante.
- O fluxo de convite permanece necessário, agora para formar uma dupla privada de duas identidades autenticadas.
- Um futuro perfil social será uma feature opt-in, com dados e políticas próprios; nunca poderá expor ou reutilizar votos, respostas, categorias íntimas ou matches privados.
- A arquitetura preserva a possibilidade de representar publicamente uma dupla sem reduzir a segurança da área íntima.

## Alternativa rejeitada

Usar o mesmo e-mail/senha para as duas pessoas. Essa alternativa não permite garantir que uma pessoa não veja ou altere os votos privados da outra, nem permite recuperação, revogação ou auditoria individual adequadas.
