# BLACKLINE architecture

This arena supersedes the Squad gameplay direction for the new `BO2_Multiplayer.Altis` mission. The original VR foundation and its validation remain intact. The previous combined-arms plan is historical, not this arena's implementation specification.

## Authority and locality

- `config` preInit initializes catalogs on every machine. `initServer` starts the single server loop; `initPlayerLocal` starts presentation only where `hasInterface` is true. A headless client has no work in this version.
- Server records: `[id, unit, team, name, kills, deaths, score, lifeScore, earnedThisLife, readyStreaks, class, lastRequest, humanLifeNetId]`. Human IDs are engine-reported UIDs; bots use monotonically increasing IDs.
- `request` is the only client-to-server endpoint. It requires a player object owned by `remoteExecutedOwner`, a valid faction, and a registered UID/current object. Class data is length/type/range/cost checked. Streak targets are numeric positions within the arena. Repeated join requests cannot redeploy an active life.
- Server snapshots publish match and scoreboard state once per second. `BL_state` is a public mission variable so joining clients receive the current value; transient notices and kills are not persistent JIP remote entries.
- `receive` and `event` accept only remote sender 2 (server). Their whitelist target is 0 because a hosted server is both server and player. Player position/loadout/healing execute on the owning client; bot equivalents execute on the server. Global simulation switches execute on the server.
- This is mission-level validation, not an anti-cheat system. Arma client-owned entities and public variables remain part of the engine's trust model.

## Match lifecycle

`WARMUP → ACTIVE → INTERMISSION → WARMUP`. Warmup waits for a human and freezes deployed units. Active starts their simulation; intermission freezes it again. At the next warmup, scores/streaks/objectives reset and living units enter the spawn queue. Dead humans follow the engine respawn path. Bot records retain match statistics when the body is replaced.

## Spawns

- Cached candidates: authored `buildingPos -1` positions with floor/head-clearance checks, and empty terrain positions on a 25 m grid. No zero-vector fallback; interior Z coordinates remain ATL.
- Cheap filtering: arena bounds at build time, non-water terrain, slope, destroyed buildings, 40 m enemy exclusion, 4 m occupancy, 9 m reservations for four seconds.
- Ranking: enemy separation, moderate friendly proximity, soft initial team anchor, recent-death heat, recent spawn reuse, indoor bonus, small random tie variation.
- Up to 24 candidates receive expensive visibility checks per request. All active enemies participate. Blocked requests advance a cursor, so lower-ranked candidates are eventually tested.
- A safe result is reserved before the next queued request. If no inspected candidate passes, the request stays queued for the next server tick. There is deliberately no unsafe timeout fallback.
- Deployment gives 1.5 seconds of protection; client outgoing fire is suppressed during it. These heuristics do not prove door accessibility or mesh clearance. Review those in the engine.

## Scheduling and load

One 1 Hz server loop handles spawn queues, objectives, boundaries, and snapshots. Bot population/tasks update every four seconds. Geometry scans occur once. The HUD updates at ~6.7 Hz; the small radar draws the limited active combatant set. The engine removes corpses after 10–30 seconds with a 16-body cap.

## Gameplay adaptations

- Domination capture rule is pure SQF, independently executable in SQF-VM. Contests freeze progress, three capturers cap the speed, and an enemy point neutralizes before capture.
- Hardpoint rotates every 60 seconds; sole occupancy earns one team point per server tick. Kill Confirmed pickups use full 3D distance to avoid collecting a tag on another building floor.
- Kill credit uses `EntityKilled` and its instigator, falling back to killer. Friendly kills do not raise team scores and subtract 100 personal points. Assists are not implemented.
- Classes contain catalog indices/booleans; optional perks incur additional wildcard cost. No arbitrary config classname is accepted from the client. Saved classes apply on the next life; there is no persistent account progression.
- UAV and counter-UAV last 30 seconds. The 750-point strike creates three delayed mortar-class impacts inside the arena and sets shot parents for attribution. Exact effects and credit need engine verification.

## Respawn repair protocol

`onPlayerRespawn.sqf` passes `_newUnit` to `prepare`; the global `player` is used only after it agrees with the new local unit. Initialization is keyed by `netId`, not a copied object boolean. Registration retries independently of UI setup and the first server snapshot. The server also records each human life ID, rather than relying on an object reference that could be rebound during respawn.

For humans, deployment is `queued → ticket sent → locally applied → acknowledged → active`. A ticket contains a monotonically increasing ID, position/direction, class, and match round. Delivery repeats every two seconds until acknowledged. The receiver rejects stale tickets and sends duplicate ACKs without teleporting/refilling twice. The server accepts only the owned current unit, outstanding ticket/current round, and replicated position within eight metres of the assigned spawn. It then reveals/unfreezes the unit and starts protection. Match resets and boundary redeploys clear outstanding tickets; a separate client life loop controls protection even if the HUD fails.

Static respawn markers are present before scripts start. Initial slot positions are near Kavala, protected and hidden until deployment. SP preview displays a multiplayer-launch instruction. RPT diagnostics distinguish registration, missing safe positions, applied tickets, and confirmed deployment. None of these offline checks establish live engine correctness.
