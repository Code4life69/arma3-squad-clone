# Mission Plan — AI-Heavy BO2-Style TDM

The project is designed around one human player with AI filling nearly all other combat slots.

## Work rule

Only one milestone is implemented at a time. Before moving forward it receives three independent checks:

1. architecture/locality review
2. automated structural and SQF syntax validation
3. independent code-path review against the milestone invariants

A real Arma hosted/dedicated smoke checklist is also kept for engine behavior.

## M001 — Dynamic Spawn Director

First production test area: Agia Marina, Stratis.

Deliverables:

- dynamically generated outdoor spawn candidates
- building/interior spawn candidates
- server-authoritative spawn selection
- enemy-distance safety gate
- friendly support preference
- behind-the-team / away-from-enemy-front preference
- recent-death danger heat
- recent-spawn reuse penalty
- expensive LOS checks only on finalists
- small randomized choice among similarly excellent candidates
- player respawn integration
- AI-compatible placement API
- no default spawn invulnerability
- detailed server logging
- automatic static and SQF validation

The milestone is intentionally isolated from scoring, HUD, classes and AI population.

## M002 — BO2-Style Visual Shell

Using the supplied BO2 screenshots as the visual target:

- dark translucent panels
- orange selected-state accents
- condensed bold typography
- BO2-like menu hierarchy
- multiplayer home screen
- class/loadout screen
- top-left minimap frame
- bottom-left team score block
- bottom-right ammo/equipment block
- right-side streak stack
- kill feed area
- respawn transition
- resolution-safe placement using Arma safeZone coordinates

All art will be recreated from scratch rather than importing proprietary BO2 assets.

## M003 — AI Team Population

- default 6v6 match
- AI fills every unoccupied slot
- humans can replace AI slots
- balanced teams
- AI respawn uses the M001 spawn director
- configurable difficulty
- server-safe lifecycle handling

## M004 — TDM Match Core

- 75-kill default score limit
- 10-minute default time limit
- server-authoritative score
- kill/death tracking
- teamkill and suicide rules
- match end
- scoreboard state

## M005 — Combat Pace

- respawn delay tuning
- stamina policy
- health/damage tuning
- health regeneration decision
- grenade/explosive balance
- friendly-fire policy
- AI accuracy/reaction profiles

## M006 — Classes and Loadouts

- assault
- SMG
- LMG
- sniper/marksman
- shotgun
- equipment
- perk-like modifiers where Arma supports them cleanly
- AI class distribution

## M007 — Arcade AI Behavior

- aggressive lane movement
- flanking
- building clearing
- pressure toward enemy space
- less static/prone behavior
- grenade use
- lightweight team awareness

## M008 — Scorestreak-Style Systems

- UAV/radar-style awareness
- counter-radar denial
- AI-controlled support effects
- server-validated streak progression
- configurable enable/disable

## M009 — Town/Map Layer System

Generalize the Agia Marina prototype so towns can become playable TDM arenas automatically.

- location discovery
- arena radius selection
- building/road density scoring
- generated spawn candidate cache
- playable-boundary generation
- per-town overrides
- later map voting/random town selection

## M010 — Polish and Soak Tests

- JIP/reconnect
- 30/60/120 minute bot matches
- spawn-death analytics
- spawn reuse analytics
- script error target: zero
- server FPS measurements
- UI polish
- release documentation
