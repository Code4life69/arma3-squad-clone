# M003 Engine Smoke Test

1. Host the mission alone as WEST.
2. Wait five seconds.
3. Confirm WEST totals six combatants: one human + five managed bots.
4. Confirm EAST totals six managed bots.
5. Confirm all bots begin inside the Agia Marina arena using the dynamic spawn director.
6. Kill one WEST bot and confirm a replacement exists after roughly the configured respawn delay.
7. Kill one EAST bot and confirm the same.
8. Join a second human on WEST and confirm the managed WEST bot count decreases so total combatants return to six.
9. Disconnect that second human and confirm a replacement bot appears.
10. Repeat for EAST.
11. Run for at least ten minutes and confirm:
   - no steadily increasing empty groups
   - no steadily increasing dead bot objects
   - no team grows above the configured target after reconciliation
   - no script errors

RPT should include [SQC][...][AI] spawn/retire messages only when population changes.
