# Mission Plan — AI-Heavy Black Ops II-Style TDM

## Verification rule

Every milestone must pass all three gates before the next begins:

1. **Architecture review** — multiplayer locality, authority and failure paths.
2. **Automated static/syntax validation** — structure checks plus SQF parsing.
3. **Engine smoke test** — hosted/dedicated checklist for behavior that only Arma can prove.

## M001 — TDM match core

Build the smallest complete game-mode kernel:

- VR test mission
- BLUFOR and OPFOR playable slots
- side respawn markers
- BASE respawn
- server-authoritative match state
- 75-kill default score limit
- 10-minute default timer
- enemy-kill scoring
- teamkill/suicide rejection
- replicated compact score/timer state
- clean match end
- RPT diagnostics
- automated validation

Nothing else is allowed into M001.

## M002 — AI team population

Target the real use case: about 95%+ AI.

- configurable team size, default 6v6
- AI fills empty human slots
- balanced BLUFOR/OPFOR rosters
- death replacement/respawn
- server ownership registry
- human joining does not duplicate a slot
- optional difficulty profiles
- no per-unit polling loops

## M003 — Arcade spawn director

This is one of the most important systems.

- multiple spawn anchors per team
- enemy-distance scoring
- line-of-sight danger penalty
- recent-death heat penalty
- teammate-density bonus
- avoid spawning directly behind/inside enemies
- anti-spawn-trap fallback
- short spawn protection
- configurable respawn delay
- AI and humans use the same spawn selector

## M004 — Classes and loadouts

BO2-style clarity without copying proprietary assets.

- assault
- SMG
- LMG
- marksman/sniper
- shotgun
- lightweight custom loadout system
- weapon/attachment/perk-like gameplay modifiers where Arma supports them cleanly
- AI role distribution

## M005 — Modern HUD, scoreboard and kill feed

Original UI with an early-2010s competitive shooter feel.

- team score at top center
- remaining time
- kill feed
- personal kills/deaths/KD
- full scoreboard
- respawn countdown
- class/loadout panel
- end-match scoreboard

## M006 — Combat pace conversion

Tune Arma away from slow milsim pacing where appropriate.

- stamina policy
- movement tuning where safely scriptable
- health/damage policy
- healing/regeneration decision
- grenade/explosive balance
- friendly-fire policy
- AI reaction and accuracy tuning

## M007 — AI combat behavior

- aggressive lane movement
- flanking
- pressure toward enemy-controlled space
- avoid excessive prone/static behavior
- close-range building clearing
- grenade use
- lightweight squad grouping without Squad-style logistics/command overhead

## M008 — Scorestreak-style rewards

Optional and configurable.

- server-validated streak points
- UAV/radar-style information
- counter-UAV-like denial
- AI-controlled support effects
- reset/retention rules
- strict performance limits

No proprietary BO2 assets or exact audiovisual copies.

## M009 — Map/layer system

- compact combat areas cut from Arma terrains
- per-map spawn anchor sets
- boundaries
- cover-density checks
- sightline checks
- 6v6 scale first
- optional larger 9v9/12v12 profiles

## M010 — Polish and soak testing

- dedicated-server testing
- JIP/reconnect
- 30/60/120 minute bot matches
- no script errors
- score consistency audit
- spawn-death rate analysis
- server FPS metrics
- UI polish
- admin config
- release documentation
