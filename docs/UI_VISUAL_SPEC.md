# M002 Visual Specification — BO2-Inspired Shell

## Target

The supplied Black Ops II screenshots are the visual reference.

The mission UI should immediately read as an early-2010s competitive military shooter while remaining an original Arma implementation.

## HUD composition

### Upper-left — mini-map

- square tactical map
- charcoal/black translucent frame
- friendlies in cyan/green
- local player highlighted
- compass strip directly beneath the map
- intentionally compact; no giant Arma GPS panel

### Lower-left — match block

- time on top
- WINNING / LOSING / TIED state beside it
- team emblem placeholder
- large friendly score
- smaller enemy score
- score-limit label

This mirrors the information hierarchy visible in the supplied BO2 TDM screenshots.

### Mid-left — kill feed

- short stacked event lines
- no large opaque background
- names remain readable over bright scenery

### Right side — scorestreak stack

Three compact slots are reserved now so later scorestreak gameplay plugs into a stable layout.

### Lower-right — weapon block

- weapon name
- fire mode
- large loaded-ammo number
- smaller reserve-ammo number
- minimal equipment line

## Menu composition

The in-mission multiplayer menu uses:

- near-black translucent full-screen veil
- large MULTIPLAYER title
- orange selected-state bars
- left-side vertical class/navigation list
- central/right loadout information
- square/angular geometry
- condensed uppercase text
- no rounded mobile-style cards

## Palette

Approximate starting palette:

- background black: 0.02 / 0.025 / 0.03
- panel charcoal: 0.055 / 0.065 / 0.075
- primary white: 0.92 / 0.94 / 0.96
- muted gray: 0.50 / 0.53 / 0.56
- accent orange: 0.95 / 0.34 / 0.035
- friendly cyan: 0.25 / 0.80 / 0.95

## Typography

Use Arma's built-in Purista family to avoid external dependencies.

- headings: PuristaSemibold
- body: PuristaMedium
- numbers: large PuristaSemibold

## Resolution handling

All major placements use Arma safeZone coordinates. No absolute 4:3-only layout is allowed.

## Asset rule

No Black Ops II textures, logos, weapon art, sounds, fonts or other proprietary assets are imported. The similarity comes from layout, hierarchy, palette, motion and information density.
