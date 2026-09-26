# M005 Arcade Combat Pace

## Goal

Move the infantry feel away from slow milsim pacing and toward a fast Black Ops II-style TDM loop without unsafe multiplayer animation/time hacks.

## Defaults

- stamina disabled
- player weapon sway coefficient: 0.55
- player recoil coefficient: 0.75
- incoming damage delta scale: 0.86
- friendly fire: disabled
- automatic health recovery after 5 seconds without taking damage
- no spawn invulnerability

All values are missionNamespace configuration values so they can be tuned without rewriting the subsystem.

## Locality

HandleDamage is local to the damaged unit.

Therefore:
- each player configures their own local player object
- server-owned bots are configured on the server
- respawned players are configured again because Arma creates a new unit object
- one regeneration loop exists per machine, not per unit

## Damage scaling

HandleDamage reports an absolute damage value, not merely a delta.

The subsystem calculates the proposed positive damage delta from the unit's current damage and scales only that delta. This avoids repeatedly multiplying already-existing damage.

Friendly fire returns the current damage value instead of zero, so blocking a friendly hit never heals damage the unit already had.

## Health recovery

Every configured local unit stores SQC_lastDamageTime.

The one local regeneration loop checks configured local units four times per second. When a living unit has non-zero damage and has gone at least the configured delay without taking damage, it heals to full.

This is intentionally simple and predictable for the arcade prototype.

## Non-goals

- changing global simulation speed
- custom animation-speed multipliers
- spawn invulnerability
- ACE medical compatibility
- per-unit regeneration loops
