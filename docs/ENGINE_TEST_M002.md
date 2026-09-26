# M002 Engine Smoke Test

## HUD

1. Start the mission at 16:9, 16:10 and one ultrawide resolution if available.
2. Confirm the mini-map remains fully on-screen in the upper-left.
3. Confirm match info remains fully on-screen in the lower-left.
4. Confirm weapon/ammo remains fully on-screen in the lower-right.
5. Confirm the scorestreak stack remains aligned along the right edge.
6. Move around Agia Marina and confirm the minimap follows the player smoothly.
7. Confirm the local-player triangle rotates with player direction.
8. Confirm friendly AI appears on the minimap.
9. Switch weapons and fire/reload; verify loaded and reserve ammo change correctly.
10. Confirm the standard Arma weapon-info panel is hidden while the aiming cursor remains usable.

## Menu

1. Join the mission and confirm the multiplayer menu opens once.
2. Confirm the world remains visible behind the dark translucent veil.
3. Click each class and confirm:
   - orange selected bar changes
   - class title changes
   - role subtitle changes
   - primary weapon preview text changes
4. Click DEPLOY and confirm the dialog closes immediately.
5. Confirm no UI control clips at Small / Normal / Large interface sizes.

## Error target

RPT must contain zero UI script errors and zero missing-control/config-class errors.
