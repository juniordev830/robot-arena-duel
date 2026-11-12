# Robot Arena Duel

Protótipo **planejado** de combate 3D entre robôs personalizáveis em arenas futuristas.

> **Estado na branch principal:** somente conceito documentado; o núcleo de código de outro PR ainda não foi integrado. O objetivo abaixo é um MVP futuro, não uma versão jogável.

## Objetivo do primeiro protótipo

Construir uma arena pequena em que dois robôs possam mover-se, atacar, receber dano e concluir um duelo. Iniciar com assets geométricos simples e simulação local; multiplayer e loja de customizações ficam fora do escopo inicial.

## Regras de domínio propostas

- Cada robô possui vida de 0 a 100, velocidade e tempo de recarga do ataque.
- Um ataque válido reduz a vida do adversário sem permitir valores negativos.
- Não é possível atacar enquanto a recarga estiver ativa.
- A partida termina quando a vida de um robô chega a zero.
- Reiniciar devolve vida, posição e recargas aos valores iniciais.

## Critérios de aceitação

1. Dois robôs de teste aparecem em uma arena fechada.
2. O controle do jogador permite mover e atacar sem atravessar a parede.
3. Um duelo termina com vencedor identificável e opção de reinício.
4. O mesmo ataque não provoca dano duas vezes no mesmo evento.
5. A simulação permanece consistente com variação de FPS.

## Etapas recomendadas

- [ ] Selecionar engine e registrar versão no projeto.
- [ ] Criar entidades e testes para dano, recarga e vitória.
- [ ] Implementar cena de teste e controle por teclado/gamepad.
- [ ] Adicionar HUD de vida, reinício e captura de tela real.
- [ ] Documentar build para PC após validar uma execução.

**Sem previsão de lançamento nesta etapa.** Exemplos, modelos e efeitos sonoros devem ter licença compatível.
