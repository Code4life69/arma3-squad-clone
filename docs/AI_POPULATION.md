# M003 AI Team Population

## Goal

The server is designed for one or a few humans with AI filling nearly every remaining combat slot.

Default match population is 6v6.

## Rules

- Human players always count toward their side's six slots.
- Managed bots fill the remaining slots.
- Empty editor playable slots do not spawn vanilla AI.
- Every managed bot is created and owned by the server.
- Each bot gets its own group so later arcade movement logic can route bots independently instead of forcing Arma formation behavior.
- A single reconciliation loop runs every three seconds.
- There are no permanent per-bot polling loops.
- A killed managed bot triggers a delayed reconciliation after the configured respawn delay.
- Bot corpses are cleaned up separately after a short delay.
- If a human joins a full side, one managed bot is retired on the next reconciliation.
- If a human leaves, a replacement bot is created on the next reconciliation.

## Spawn integration

New bots call the exact same SQC_fnc_placeUnitAtSpawn function used by players.

This keeps humans and AI on one spawn safety model.

## Difficulty

M003 only installs a mild baseline skill profile. Detailed arcade difficulty tuning belongs to the later combat-pace/AI-behavior milestones.
