# M006 Engine Smoke Test

1. Open CREATE A CLASS.
2. Select each class and press DEPLOY.
3. Confirm the primary weapon, ammo and HUD weapon name change.
4. Confirm each class has at least one usable primary magazine.
5. Confirm ASSAULT, SMG, LMG and MARKSMAN always work with base mission content.
6. Select SHOTGUN:
   - if Hunter shotgun exists, confirm it is equipped
   - otherwise confirm MXC fallback is equipped
7. Die and respawn; confirm the selected class persists.
8. Change classes after respawn and repeat.
9. Inspect bots and confirm the five-class rotation is represented.
10. Join from a second client and confirm one client cannot submit a class change for another player's unit.
11. Check RPT for zero loadout/config errors.
