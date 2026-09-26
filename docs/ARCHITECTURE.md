# Architecture

## Prime directive

The server owns match truth. The machine local to an AI group owns that group's low-level execution. The player client owns presentation and input. These responsibilities must not be mixed.

## Execution roles

### Dedicated server

Authoritative for:

- match phase and rules
- objectives and capture state
- tickets
- squad registry
- spawn-point registry
- FOB/logistics state
- AI force registry
- AI ownership assignment
- validation of player requests

### Hosted server

Runs the same authoritative server responsibilities while also presenting the local player's UI. Server and client code must still be treated as separate concerns even though they share one process.

### Player client

Responsible for:

- UI and input
- local camera/map presentation
- requesting valid server actions
- receiving replicated state needed for presentation

A player client must not authoritatively decide tickets, objective captures, FOB creation, AI force composition, or other match truth.

### Headless client

Responsible for:

- simulation of AI groups explicitly assigned to it
- execution of low-level AI orders for groups local to it
- reporting completion/status back through approved network APIs

A headless client does not own match rules.

## AI model

The AI system will use three levels.

### Strategic director

Server-authoritative. Decides where forces are needed based on active objectives, tickets, logistics routes, threat and force balance.

### Squad brain

Owns a squad task such as attack, defend, screen, transport, resupply, patrol, reinforce or recover. It converts strategic intent into waypoints/tactical goals.

### Tactical execution

Runs where the group is local. Handles formation, movement, contact behavior, suppression, cover, fireteam actions and vehicle behavior. Optional AI mods can later be integrated here through adapters.

## Data flow

Gameplay state follows this direction:

`player input / AI event -> validated request/event -> authoritative server service -> state change -> replicated view state -> UI`

AI order flow follows:

`server director -> group task -> current group owner -> local tactical execution`

## Networking rules

1. Use named functions for remote execution.
2. Add a `CfgRemoteExec` whitelist when the first network API is introduced.
3. Validate caller, side, role, range, cost and current match state on the server.
4. Never trust client-provided ticket values, object ownership or resource totals.
5. Do not depend on ordering between multiple persistent JIP remote-execution entries.
6. Prefer replicating compact state snapshots/events over broadcasting scripts.

## AI scalability rules

1. AI is managed by group, not by hundreds of independent polling loops.
2. Distant eligible AI groups use Dynamic Simulation.
3. No per-frame global battlefield scans.
4. Expensive director decisions run on controlled intervals and are staggered.
5. Group ownership is explicit and observable.
6. Headless clients are optional: the mission must still function on a dedicated or hosted server without one.
7. Spawn budgets and active-group caps are configurable per mission.

## UI architecture

The UI will use an original visual design inspired by modern tactical games rather than copied Squad art/assets.

Planned primary screen:

- full tactical map as the dominant surface
- squad list and squad status on the left
- role/loadout panel tied to selected squad
- spawn points and spawn status on the map
- objective chain and tickets at the top
- contextual action/status panel on the right/bottom
- commander/order layers only when relevant

UI reads view-state objects and does not directly mutate authoritative gameplay state.

## Validation gates

Every milestone must pass three checks before the next begins.

### Gate 1 — architecture/locality review

For every command/function added, verify where it executes, which objects must be local, whether effects are local/global, and how JIP behaves.

### Gate 2 — static project validation

Automated checks verify required files, function registration, bootstrap boundaries and milestone-specific invariants.

### Gate 3 — syntax and engine verification

SQF is syntax-checked automatically. Systems that depend on engine behavior also receive a reproducible hosted-server and dedicated-server checklist before being considered complete.
