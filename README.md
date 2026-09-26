# Arma 3 — AI Black Ops II-Style Team Deathmatch

Personal-use Arma 3 mission/server framework focused on recreating the fast feel of Black Ops II Team Deathmatch with an overwhelmingly AI-populated server.

## Priority order

1. Dynamic spawn system
2. BO2-style HUD and menus
3. AI population/combat pacing
4. TDM scoring, classes, kill feed, scorestreak-style systems and polish

Development follows one rule: finish one milestone, review it three ways, then move to the next.

## Current milestone

M001 — Dynamic Spawn Director

The first test map is Agia Marina on Stratis. The spawn director builds ground and building spawn candidates at runtime and chooses a spawn using team position, enemy pressure, recent deaths, recent spawn usage and real line-of-sight checks.

No long spawn invulnerability is used to conceal bad spawn selection.

See docs/MISSION_PLAN.md and docs/SPAWN_SYSTEM.md.
