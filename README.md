# Robot Arena Duel

**Status:** primeiro MVP em Godot 4 — arena 3D criada em tempo de execução, dois robôs, movimentação, adversário controlado por regras simples, ataques de curta distância e placar de vida.

## Como executar

1. Instale o **Godot 4.2 ou superior** (edição padrão, GDScript).
2. Abra esta pasta no Godot (arquivo `project.godot`).
3. Pressione **F6/F5** para executar a cena/projeto, ou use `godot --path .`.

## Controles

- **WASD / setas:** movimentar robô azul.
- **Espaço:** atacar quando o adversário estiver perto.
- **B:** ativar defesa temporária; durante a defesa, o ataque fica bloqueado.
- **R:** reiniciar a partida.

O robô vermelho se aproxima e ataca automaticamente. A partida termina quando um dos dois fica sem vida.

## Estrutura

- `project.godot`: configuração do motor gráfico.
- `scenes/main.tscn`: cena inicial.
- `scripts/arena.gd`: montagem visual da arena e interface.
- `scripts/robot.gd`: movimentação, colisão e combate.
- `scripts/combat_rules.gd`: regras isoladas, fáceis de testar.
- `tests/test_combat.gd`: testes de regras.

## Testar

Com o Godot instalado:

```bash
godot --headless --path . --script tests/test_combat.gd
```

## Limites

É um **protótipo jogável**, não um jogo comercial: os modelos são formas geométricas geradas por código; não há multiplayer, sons, animações de personagem, menu de seleção nem arte final. As funcionalidades avançadas permanecem propostas para futuras entregas.

## Próximas etapas

- Modelos e animações de robôs personalizados.
- Feedback visual e sonoro dos ataques.
- Seleção de arena, menu inicial e dificuldade ajustável.
- Testes integrados e exportação para Windows/Linux.

MIT License.


## Mecânica de defesa (novo)

Pressione **B** para ativar uma defesa por **1,1 segundo**; durante esse intervalo o dano após a armadura é reduzido a aproximadamente 40%, nunca abaixo de 1 ponto quando um ataque válido acerta. A defesa entra em recarga por **3 segundos** contados a partir da ativação. O estado aparece no HUD como `PRONTO`, `ATIVO` ou `RECARGA`.

O módulo `scripts/combat_rules.gd` contém o cálculo de dano e a validação dos temporizadores. Os testes automatizados cobrem dano normal, defesa, valores inválidos e bloqueio de recarga. A mecânica é fictícia e não simula defesa física real.

## Impulso rápido (dash)

Pressione **Shift** enquanto movimenta o robô azul com WASD ou setas para executar um impulso curto na direção atual. O impulso dura **0,2 segundo**, usa velocidade maior e entra em recarga por **3,2 segundos** a partir da ativação.

Não é possível ativá-lo parado nem durante a defesa. O HUD mostra `PRONTO`, `IMPULSO` ou `RECARGA`. Os casos de uso e bloqueios são verificados em `tests/test_combat.gd`.

### Janela de esquiva e consistência do combate

Durante os **0,2 segundo** de impulso ativo, o robô não sofre dano de ataques. Fora desse intervalo, a armadura e a defesa continuam funcionando normalmente. **Não é possível atacar ou ativar a defesa durante o impulso**, nem iniciar um impulso enquanto a defesa está ativa; isso impede sobreposição de habilidades.

A janela de proteção é curta e começa quando o comando Shift é aceito. A recarga de **3,2 segundos** permanece. O módulo `combat_rules.gd` agora testa também a prioridade entre esquiva, defesa e dano.
