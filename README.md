# BLACKLINE — Black Ops II-inspired multiplayer for Arma 3

A vanilla Arma 3 infantry arena in **Kavala, Altis**, developed from the `m001-runtime-foundation` branch. The original `SQC_SquadClone.VR` runtime remains available as a regression fixture.

**Status: implemented prototype; engine playtest pending.** Source structure, SQF parsing, and pure rule regression tests run automatically. Arma graphics, terrain clearance, AI navigation, and multiplayer synchronization need the hosted/dedicated playtest in [docs/PLAYTEST.md](docs/PLAYTEST.md). This is not a completed one-to-one Black Ops II reproduction.

## Spawn queue repair

Spawn selection now relaxes enemy visibility after eight seconds while retaining land, occupancy, recent reservation, and a 15 m enemy exclusion. Relaxed spawns receive three seconds of protection. Final outdoor positions are checked for water after the empty-position search, and engine respawn markers are moved to checked ground candidates at startup. Deployment sets the server's destination before client acknowledgement to avoid waiting on a disabled unit's position replication. These changes address code-level failure paths; hosted Arma validation remains required.

## Respawn repair build

This revision passes Arma's new respawn unit into initialization, tracks each life by network ID, retries server-issued deployment tickets without repeated refills, and waits for acknowledgement before activating the player. Damage protection no longer depends on the HUD rendering. The mission now includes permanent respawn markers and startup positions near Kavala instead of offshore map-corner coordinates.

The reported corruption could not be confirmed without the failing file or Arma error/RPT. The rebuilt text configs now receive strict syntax/entity checks, and the downloadable PBO/ZIP include integrity checksums. Live Arma testing is still pending.

## Included

- 32 multiplayer slots, sixteen on each side; automatic arena-area population (12v12 here, capped at 16v16) and manual 1v1 through 16v16 targets with server-owned bot fill.
- Team Deathmatch, Domination, Hardpoint, and Kill Confirmed; warmup, time/score limits, match report, automatic next match.
- Three-second engine respawn followed by a server safety queue. Spawn candidates cover streets and building interiors, retain floor height, reject nearby enemies/occupied spots/recent reservations, and check enemy sightlines.
- BO2-inspired charcoal/orange class screen, minimap, score/timer, kill feed, ammo display, objective markers, scoreboard, and scorestreak panel.
- Five vanilla weapon families, a ten-point class budget, optional optic/pistol/grenades, four adapted perks, health regeneration, no fatigue, and first-person presentation.
- UAV, counter-UAV, and a delayed three-impact lightning strike adaptation. Earned rewards survive death; life score resets.
- Server-owned scores, captures, bot population, deployment, and streak authorization; restricted named remote calls and caller ownership checks.

## Play

1. Download `releases/BLACKLINE-Multiplayer.zip` and extract it.
2. Replace the old installed copy with **`BO2_Multiplayer.Altis.pbo`** in your game installation's `MPMissions` folder, commonly `Steam\steamapps\common\Arma 3\MPMissions`. The same PBO works for a dedicated server's `MPMissions` folder.
3. In Arma choose **Multiplayer → Server Browser → Host Server → LAN**, select **Altis → BLACKLINE | Kavala Arena**, and join a BLACK OPS or MERCENARIES slot. You can host alone with bots.
4. Set the mode, population, time, and difficulty under lobby Parameters.

**Do not test respawn using single-player preview.** For Eden editing, copy the unpacked `BO2_Multiplayer.Altis` folder into your profile's `missions` folder and use **Play → Play in Multiplayer**. Install either the packed mission or the editable folder for a given test, avoiding duplicate old versions.

`releases/SHA256SUMS.txt` covers both downloads. The ZIP also contains a per-file checksum manifest. If startup or respawn still fails, send the exact error and the latest `Arma3*.rpt` from `%LOCALAPPDATA%\Arma 3`, especially lines containing `[BLACKLINE]` or `Error in expression`.

Arma 3 **2.14+**, vanilla assets; no Workshop dependencies. The initial test arena is a 225 m radius around `[3660,13110]`. Objective coordinates are authored starting points, still awaiting terrain inspection.

| Control | Action |
| --- | --- |
| F4 | Class menu; saved changes apply at the next spawn |
| Hold Tab | Scoreboard |
| 5 | Activate earned UAV |
| 6 | Activate earned counter-UAV |
| 7 | Activate earned lightning strike at your crosshair's terrain point |

Default Arma movement, aim, reload, and grenade controls remain. A 1.5-second spawn shield suppresses your outgoing projectiles too. Leaving the combat area gives eight seconds to return, then queues redeployment.

## Scope and differences

This build uses original UI code and Arma weapons, animations, buildings, and sounds. Spawn weighting is an original safety heuristic, **not Treyarch's proprietary spawn algorithm**. The ten-point class builder and perks are simplified adaptations. Domination uses one continuous round; Hardpoint uses three authored positions; the strike uses explosive impacts instead of an aircraft.

Not yet implemented: killcam/final-kill replay, hitmarkers, exact BO2 weapon balance, the full weapon/perk/streak catalog, prestige/unlocks, Search & Destroy, map voting, or automatic support for every town. Building reachability, UI scaling, network races, and pacing must be verified in-game before calling this release ready.

## Development checks

Linux x64 / Python 3.11+:

```sh
python tools/fetch_sqfvm.py
python tests/validate_arena.py
python tests/lint_sqf.py
python -m unittest discover -s tests -p 'test_*.py' -v
python tools/package_mission.py
python tests/verify_package.py
```

SQF-VM is pinned and checksum-verified. The rule tests execute the actual class-budget and Domination functions, not Python copies. It is not the Arma engine. See [architecture](docs/BLACKLINE_ARCHITECTURE.md), [research](docs/BLACKLINE_RESEARCH.md), and [playtest checklist](docs/PLAYTEST.md).
