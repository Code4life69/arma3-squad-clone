# M006 Functional Classes

The CREATE A CLASS shell now drives real Arma loadouts.

## Classes

### ASSAULT
- MX 6.5 mm
- holographic optic
- balanced magazine count
- sidearm
- grenade + smoke

### SMG
- Vermin .45 ACP
- close-range optic when available
- increased magazine count
- sidearm
- grenade + smoke

### LMG
- Mk200 6.5 mm
- holographic optic
- multiple belts
- sidearm
- smoke

### MARKSMAN
- Mk18 ABR 7.62 mm
- RCO-style optic
- precision magazine load
- sidearm
- smoke

### SHOTGUN
Preferred:
- Hunter shotgun if the installed Arma content exposes it
- pellet ammunition

Fallback:
- MXC close-quarters carbine

The fallback prevents the core mission from requiring optional DLC.

## Authority

The client only previews a class locally.

When DEPLOY is pressed:
1. client sends the selected class name to the server
2. server checks the allowed class list and unit ownership
3. server stores SQC_className on the unit
4. server tells only the unit owner to apply the validated loadout

The class is inherited from the old player object to the new object on respawn.

## AI

Managed bots receive a rotating class distribution across all five classes. They use the exact same loadout application function as humans.
