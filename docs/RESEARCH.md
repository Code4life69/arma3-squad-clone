# Research Notes

Research date: 2026-09-26

## Black Ops II Team Deathmatch baseline

Historical references consistently describe standard Black Ops II Team Deathmatch as:

- two teams
- 6–12 players total
- first team to 75 kills wins
- 10-minute time limit
- each enemy kill adds one point to the team score

References:
- https://gamefaqs.gamespot.com/xbox360/669289-call-of-duty-black-ops-ii/faqs/65319
- https://www.cod-france.com/black-ops-2/guides/modes.html

Black Ops II custom games exposed configurable score/time/spawn/health settings, so this project keeps the defaults configurable rather than hard-coding every later gameplay choice.

Reference:
- https://steamcommunity.com/app/202970/discussions/0/458606877329290921/

## Arma 3 implementation facts

### Respawn

Arma 3 supports BASE respawn through `description.ext`. BLUFOR and OPFOR use markers named with the `respawn_west` and `respawn_east` prefixes.

References:
- https://community.bistudio.com/wiki/EXT
- https://community.bistudio.com/wiki/Arma_3%3A_Respawn
- https://community.bistudio.com/wiki/Eden_Editor%3A_Scenario_Attributes

### Match scoring

Mission event handlers are installed on a specific machine. Installing `EntityKilled` only on the server gives the TDM rules one authoritative place to process deaths.

Reference:
- https://community.bistudio.com/wiki/Arma_3%3A_Mission_Event_Handlers

### State replication

A missionNamespace variable can be broadcast with the public form of `setVariable`. This state is suitable for compact match snapshots and is available to join-in-progress clients.

References:
- https://community.bistudio.com/wiki/setVariable
- https://community.bistudio.com/wiki/Multiplayer_Scripting

### Mission ending

`BIS_fnc_endMissionServer` ends a multiplayer mission for all connected players from the server.

Reference:
- https://community.bistudio.com/wiki/BIS_fnc_endMissionServer

## Design consequences

1. Server owns score, timer and match result.
2. Clients only display replicated state.
3. AI spawning will be a separate milestone.
4. Spawn selection will be a separate subsystem instead of random death-position respawn.
5. The project will reproduce the *feel and rules* of fast arcade TDM using original implementation and presentation.
