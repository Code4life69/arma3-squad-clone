# Arma 3 Squad Clone

AI-first, Squad-inspired combined-arms mission framework for Arma 3.

## Project goal

Build a modern tactical game mode inside Arma 3 where one human player can fight in a battlefield populated primarily by AI. The project is not being designed around PvP at this stage. The human should be able to join or lead a squad while the rest of the force operates through AI squads, fireteams, vehicles, logistics, objectives, spawning and command systems.

The UI will be original, but functionally inspired by Squad: a modern deployment/map screen, squad and role management, spawn selection, objective/ticket information, command tools and clear status feedback.

## Development rule

One milestone at a time. A milestone is not considered complete until it passes all three gates:

1. Architecture/locality review against Arma 3 multiplayer behavior.
2. Static structure and invariant validation.
3. SQF syntax validation plus an in-game checklist when engine behavior is involved.

No later gameplay system should be layered on top of a failed foundation.

## Current milestone

**M001 — Runtime Foundation**

The repository currently contains a minimal VR development mission with:

- CfgFunctions-based function registration.
- Separate server, player-client and headless-client startup paths.
- Execution-role detection.
- Standardized diagnostic logging.
- Lightweight assertions.
- Automated repository structure checks.
- Automated SQF syntax checking in GitHub Actions.

No combat, spawning, objectives, tickets, FOBs, AI director or UI gameplay logic is intentionally included in M001.

## Development mission

Copy `mission/SQC_SquadClone.VR` into your Arma 3 `mpmissions` folder and open it in Eden or host it as a multiplayer mission.

Expected startup RPT messages begin with `[SQC]` and identify the machine role as one of:

- `DEDICATED_SERVER`
- `HOST_SERVER`
- `PLAYER_CLIENT`
- `HEADLESS_CLIENT`

See `docs/MISSION_PLAN.md` for the full staged plan and `docs/ARCHITECTURE.md` for the technical rules.
