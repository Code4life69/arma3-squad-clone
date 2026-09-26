# M004 Engine Smoke Test

1. Start a 6v6 match.
2. Confirm HUD begins at 0-0 and 10:00.
3. Kill one enemy:
   - correct team score becomes 1
   - kill feed shows killer and victim
   - human killer stat increments
4. Die:
   - human death stat increments
5. Suicide:
   - death increments
   - neither team gains a point
6. Friendly-fire/teamkill if enabled for test:
   - death increments
   - neither team gains a point
7. Let AI kill AI and confirm team score increments correctly.
8. Set score limit temporarily to 2 and confirm the second valid enemy kill ends scoring immediately.
9. Set time limit temporarily to 15 seconds and verify:
   - higher score wins at zero
   - equal score produces draw
10. Confirm no kills after matchRunning becomes false can change final score.
11. Confirm RPT contains one match start and one match end line.
