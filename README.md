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

## Primeiro incremento de código (em revisão)

Arena local de dois robôs, movimento limitado, ataque por alcance, recarga e determinação do vencedor.

O arquivo `core.py` contém a implementação executável em Python 3.11+ e `tests/test_core.py` cobre regras, entradas inválidas e repetibilidade. Não há engine 3D, UI gráfica, asset ou build final nesta entrega; o protótipo é de **domínio/testes**.

Para executar a demonstração:

```bash
python core.py
```

Para verificar o comportamento:

```bash
python -m unittest discover -s tests -p 'test_*.py' -v
```

O GitHub Actions executa a suíte em cada PR. A lista de tarefas do roteiro acima descreve o objetivo completo do jogo e não deve ser interpretada como pronto para publicação.
