# Engine acceptance checklist — NOT YET RUN

No Arma executable is available in the build environment. Every unchecked item below is pending, not an implied pass. Run first with vanilla Arma 3, `-showScriptErrors`, and a fresh RPT.

## Repair regression cases — pending engine verification

- [ ] Install the new PBO and remove/replace the old mission copy; launch a hosted multiplayer session, not SP preview.
- [ ] Die and respawn at least ten times; each RPT cycle has Registering life → Applied delivery → Confirmed delivery.
- [ ] Delay a delivery/ACK: the server resends the same ticket without moving/refilling an already applied life.
- [ ] Respawn during intermission and at a round transition; no stale ticket activates a new life.
- [ ] Cause a HUD initialization error in a development copy: deployment and eventual removal of protection still work.
- [ ] Join slowly, before the first state snapshot arrives; registration retries and warmup waits for an active human.
- [ ] Confirm the mission loads without the original suspected corruption error. If it fails, save the exact message and RPT.

## Start and display

- [ ] Open the Altis mission in Eden; no config/import error. Confirm all 12 slots and lobby parameters.
- [ ] Host alone on each side; lobby UI appears, default kit equips, bots fill the selected population, countdown enables combat.
- [ ] Check 1920×1080 and ultrawide at small/normal/large UI sizes. Text/buttons fit; minimap is visible; ammo/reserves match the actual weapon.
- [ ] F4 opens/closes class selection; hover perk tooltips, toggle above/below ten points, select each weapon. A saved class changes only on the next deployment.
- [ ] Tab scoreboard clears when released. Open/close menus while holding Tab; it must not remain stuck.

## Spawn quality

- [ ] Die 30 times on each side; no stranded staging life, duplicate teleport, underwater spawn, overlap, or lost kit.
- [ ] Review indoor floors and exits. Reject any inaccessible building candidates before release; adjust the height/clearance filters if needed.
- [ ] Move an enemy within 40 m of candidates; those positions are rejected. Observe direct lines of sight and simultaneous respawns.
- [ ] Saturate the arena with enemies; waiting displays “FINDING A SAFE SPAWN” and recovers when a candidate becomes safe.
- [ ] Destroy a spawn building; it must no longer be chosen. Record worst wait, minimum enemy distance, and deaths within five seconds of spawning.
- [ ] Verify 1.5-second incoming protection and suppression of outgoing bullets/grenades during that protection.
- [ ] Leaving the boundary shows the countdown and safely redeploys after eight seconds.

## Rules and bots

- [ ] TDM enemy kill adds one point, suicide adds none, friendly kill adds none. Instigator gets credit for a grenade and strike.
- [ ] Domination: solo capture takes ten ticks from neutral; contest freezes it; ownership neutralizes before switching; captures do not repeatedly award points.
- [ ] Hardpoint rotates every minute, only uncontested occupied points score, old hill stops scoring.
- [ ] Kill Confirmed: enemy tag scores once, friendly tag denies, tags expire, adjacent-floor tags cannot be picked up through the ceiling.
- [ ] Bots replace deaths after the respawn delay, navigate between objectives, engage opponents, and heal after damage-free time.
- [ ] Join/leave on each team; bot population adjusts and old groups do not accumulate.
- [ ] Survive to each streak threshold; activate rewards once, verify radar visibility/jamming, invalid strike rejection, three-second strike delay, and no cross-round strike leakage.
- [ ] Score/time limit produces correct win/loss/draw, freezes combat, and restarts with reset scores/classes preserved.

## Multiplayer

- [ ] Repeat with a dedicated server and two clients, including the host/client role differences.
- [ ] Join during warmup, active play, intermission, and while a UAV is active. Match state must match the server.
- [ ] Disconnect during deployment/death and reconnect; no duplicate scoring record or abandoned bot/player slot.
- [ ] Simulate latency/loss: no endless invulnerability, repeated kit refill, or duplicate score reward.
- [ ] Try malformed class/streak payloads and another player's object. Server rejects them without script errors.
- [ ] Run 30 minutes, three consecutive matches; collect RPTs, server FPS, entity/group counts, and screenshots.

Only after the hosted and dedicated checks pass should this be labeled playable/release-ready. Remaining feature parity (killcams, full catalogs/progression, all BO2 modes, town voting) is tracked in the README and is separate from bug-free operation of this prototype.
