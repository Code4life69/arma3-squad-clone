# Implementation references

Reviewed 2026-09-26. References describe APIs and game concepts; they do not prove this mission works in Arma.

## Black Ops II concepts

- Activision: https://support.activision.com/call-of-duty--black-ops-ii/articles/what-modes-are-available-in-black-ops-ii-multiplayer — official mode descriptions for TDM, Domination, rotating Hardpoint, and tag collection/denial in Kill Confirmed.
- Activision: https://support.activision.com/call-of-duty--black-ops-ii/articles/what-are-scorestreaks — score-based streak concept. Current thresholds and effects are this mission's adaptation, not a claim of complete catalog parity.

No primary source exposing Treyarch's exact BO2 spawn algorithm was established. Distance, visibility, team proximity, reservations, and death heat are our own implementation choices. They should be tuned from recorded spawn deaths and wait times after playtesting.

## Bohemia documentation

- https://community.bohemia.net/wiki/Arma_3:_Mission_Event_Handlers — server kill observation and instigator attribution.
- https://community.bohemia.net/wiki/Arma_3:_CfgRemoteExec — named remote-execution whitelist.
- https://community.bohemia.net/wiki/remoteExecutedOwner — caller ownership and server-origin checks.
- https://community.bohemia.net/wiki/buildingPos — authored building positions; preserve position elevation.
- https://community.bohemia.net/wiki/findEmptyPosition — terrain candidate search; ignores moving objects, so live occupancy is a separate check.
- https://community.bohemia.net/wiki/checkVisibility — ASL eye-to-candidate visibility test.
- https://community.bohemia.net/wiki/setShotParents — server-owned projectile attribution.
- https://community.bohemia.net/wiki/import_(Config) — import engine UI classes into mission configuration (introduced in 2.02).
- https://community.bohemia.net/wiki/ctrlCreate — runtime controls can use engine or mission classes.
- https://community.bohemia.net/wiki/ctrlMapAnimAdd — radar centering/scale.
- https://community.bohemia.net/wiki/Event_Scripts — local player respawn lifecycle.

## Offline verification

- https://github.com/SQFvm/runtime/releases/tag/v2026.04.03-ed9f5f5 — pinned SQF parser/runtime for syntax and pure rules, not terrain, UI, physics, or multiplayer emulation.
- SQF-VM's config parser is not used as an Arma mission-config validator; the root mission format/imported engine UI classes require the real engine. Static delimiter/registration checks cover these files offline.

## Respawn repair references (2026-09-27 UTC)

- https://community.bohemia.net/wiki/Event_Scripts — onPlayerRespawn receives new unit, old unit, respawn type, and delay. Initialization now consumes the new unit explicitly.
- https://community.bohemia.net/wiki/Mission.sqm — text entity/group/marker structure; new structural parser checks counts, identities, slots, markers, and syntax.
- https://community.bohemia.net/wiki/PBO — PBO entry table, properties, uncompressed data, and trailing checksum. The repair package includes a packed mission plus SHA-256 manifests.
- SQF-VM's Linux virtual path mapping cannot resolve nested backslash PBO names correctly. Package verification therefore reads all entries directly and additionally checks the two root config files through SQF-VM's independent reader. This does not claim Arma config/asset validation.
