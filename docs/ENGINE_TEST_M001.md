# M001 Arma Engine Smoke Test

Run after copying mission/SQC_TDM.Stratis into the Arma 3 mpmissions folder.

## Hosted multiplayer

1. Host SQC_TDM on Stratis.
2. Join WEST.
3. Confirm the player is moved from the fallback marker into the Agia Marina arena.
4. Kill/respawn at least 15 times.
5. Confirm positions vary and do not repeatedly reuse one room or street corner.
6. Confirm some respawns can occur at valid building positions.
7. Place an EAST unit near a previously common spawn and confirm WEST stops using that immediate area.
8. Put an EAST unit with clear sight of a candidate area and confirm visible positions lose preference.
9. Cause multiple deaths in one small area and confirm that area becomes temporarily unattractive.
10. Check RPT for [SQC] spawn logs and zero script errors.

## Dedicated server

1. Repeat with a dedicated server and one remote client.
2. Confirm the server performs spawn selection.
3. Confirm the client only receives its final placement.
4. Confirm ownership validation rejects attempts to request a spawn for another client's unit.
5. Confirm respawn remains responsive.

## Pass criteria

- no SQF/script errors
- no player placed in water
- no player placed outside the 230 m arena
- no obvious spawn inside solid geometry
- no enemy within the configured 18 m hard reject distance at selection time
- spawn changes in response to enemy movement
- indoor candidates work
- repeated deaths/spawns temporarily influence selection
