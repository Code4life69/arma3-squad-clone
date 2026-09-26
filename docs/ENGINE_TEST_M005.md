# M005 Engine Smoke Test

## Player

1. Sprint continuously for at least 30 seconds and confirm stamina does not force a slowdown.
2. Compare aiming sway and recoil to vanilla Arma; both should be noticeably reduced but still present.
3. Take non-lethal enemy fire:
   - damage should apply
   - health should not instantly recover
   - after roughly 5 damage-free seconds, health should return to full
4. Take another hit during the recovery delay and confirm the delay restarts.
5. Receive friendly fire and confirm health does not decrease.
6. Die and respawn; repeat tests 1-5 to prove the new player object is configured.

## AI

1. Damage a server-managed bot non-lethally.
2. Stop shooting and confirm it recovers after the same delay.
3. Confirm friendly-fire damage between same-side bots is blocked.
4. Confirm enemy fire still kills bots normally.

## Stability

Run a 10-minute 6v6 bot match and confirm:
- no HandleDamage script errors
- no growing number of regen loops
- no accidental invulnerability
- no player or bot heals while continuously receiving damage
