# Robot Arena Duel

**Status:** primeiro MVP em Godot 4 — arena 3D criada em tempo de execução, dois robôs, movimentação, adversário controlado por regras simples, ataques de curta distância e placar de vida.

## Como executar

1. Instale o **Godot 4.2 ou superior** (edição padrão, GDScript).
2. Abra esta pasta no Godot (arquivo `project.godot`).
3. Pressione **F6/F5** para executar a cena/projeto, ou use `godot --path .`.

## Controles

- **WASD / setas:** movimentar robô azul.
- **Espaço:** atacar quando o adversário estiver perto.
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
