# M001 Spawn Director

## Design target

Classic Call of Duty TDM uses authored spawn points plus dynamic logic: player locations influence which candidate is selected, with spawns generally occurring near/behind teammates and away from enemies. The Arma version keeps that behavior but can generate candidates from a town automatically.

## Agia Marina test arena

Center: [2915.2, 6164.52, 0]
Radius: 230 m
Terrain: Stratis

Candidate sources:

- outdoor grid seeds corrected through findEmptyPosition
- all usable building positions exposed by terrain buildings inside the arena

This means a valid house room, balcony or other engine-defined building position can become a spawn point.

## Selection pipeline

### Pass 1 — coarse scoring

Every candidate receives a cheap score.

Hard reject:
- enemy within 18 m

Positive:
- distance from nearest enemy, capped so extreme distance does not dominate
- friendly support around roughly 28 m
- candidate lies behind the friendly centroid relative to the enemy centroid
- small indoor bonus

Negative:
- candidate lies in front of the friendly line toward the enemy centroid
- recent deaths near the candidate
- the same team recently spawned near the candidate

### Pass 2 — visibility scoring

Only the top 24 coarse candidates receive geometry LOS checks.

For enemies within 120 m:
- visible candidate receives a strong penalty
- closer visible enemies penalize more
- a candidate hidden from all checked enemies receives a cover bonus
- hidden indoor positions receive a small additional bonus

### Final choice

The best refined score is identified. Up to the best three candidates within 12 score points of the leader form a tiny selection pool. One is chosen randomly so the system remains fluid and less predictable without sacrificing safety.

## Spawn direction

The spawned unit faces the current enemy centroid when possible. If no enemies exist, it faces the arena center.

## Death heat and reuse memory

Recent death positions remain hot for 14 seconds.
Recent same-team spawn usage remains relevant for 10 seconds.

These memories are server-only and pruned continuously.

## Server authority

Candidate generation and selection happen on the server.

Initial human join:
- the player client requests one initial placement
- the server checks isRemoteExecuted, remoteExecutedOwner and object owner
- the unit is marked SQC_initialSpawnDone so the request cannot be reused as a teleport

Normal respawns:
- the server's EntityRespawned mission event selects the spawn directly
- no client spawn request is trusted or required

AI initial placement:
- the server places non-player combatants directly
- future AI respawns use the same placeUnitAtSpawn path

The final setPosATL executes only where the unit is local.

## No default invulnerability

Spawn protection is intentionally zero by default. The system must solve spawn safety through placement rather than hiding poor choices behind invulnerability.

## Performance

Candidate generation happens once at server startup.
Cheap scoring runs across the full candidate set.
Geometry visibility checks run only for finalists.

No per-frame spawn scanning exists.
