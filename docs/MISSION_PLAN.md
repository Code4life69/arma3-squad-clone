# Mission Plan

The project is intentionally AI-first: assume roughly 95%+ of battlefield participants are AI and one or a few humans may occupy leadership or combat roles. PvP balance is not a current design target.

## Definition of done for every milestone

A milestone is complete only when:

1. Its scope is finished with no intentionally half-wired subsystem.
2. Arma locality/JIP behavior has been reviewed for every new multiplayer feature.
3. Static validation passes.
4. SQF syntax validation passes.
5. An engine test checklist exists and is completed for engine-dependent behavior.
6. Failure paths produce useful `[SQC]` diagnostics instead of silently failing.
7. The next milestone does not begin until all above checks pass.

---

## M001 — Runtime foundation

**Goal:** create a loadable development mission and a reliable startup/runtime skeleton before adding gameplay.

Deliverables:

- VR development mission
- CfgFunctions layout
- server/player/headless startup separation
- execution-role detection
- consistent RPT logging and assertions
- CI structure validation
- CI SQF syntax validation

Acceptance checks:

- hosted server initializes server and local player paths once
- dedicated server initializes only server path
- normal client initializes only player-client path
- headless client initializes headless path without executing UI logic
- no custom remote-execution surface exists yet

Status: **implemented on the M001 branch; engine smoke test remains the final real-Arma verification gate.**

---

## M002 — Authoritative state and AI ownership manager

**Goal:** establish the backbone required for an AI-heavy battlefield.

Deliverables:

- authoritative server state container
- registered AI group records with unique IDs
- group lifecycle events
- locality/ownership inspection
- optional headless-client registry
- safe group transfer with `setGroupOwner`
- fallback to server ownership when no HC exists
- ownership-change diagnostics
- Dynamic Simulation policy hooks

Tests:

- create/move/delete AI groups without orphaned records
- transfer AI groups to/from HC and confirm local execution follows ownership
- hosted and dedicated behavior match
- disconnecting HC safely returns/reassigns groups

---

## M003 — AI force generator and performance budget

**Goal:** spawn realistic platoon/squad forces without destroying server performance.

Deliverables:

- faction templates
- infantry squad/fireteam templates
- specialist roles
- vehicle crew templates
- force budgets and caps
- spawn queues
- despawn/recycle rules for irrelevant forces
- Dynamic Simulation distances by category
- staggered update scheduler
- server FPS/AI-count diagnostics

Tests include 50, 100, 150+ AI scaling profiles before selecting defaults.

---

## M004 — Squad structure, roles and player integration

**Goal:** make AI squads behave as first-class game entities rather than loose Arma groups.

Deliverables:

- squad IDs/names
- squad leader and fireteam leader roles
- rifleman, medic, automatic rifleman, grenadier, LAT/HAT, marksman, engineer and crewman role definitions
- player joins/creates/takes command of a squad
- automatic AI filling of empty squad slots
- AI replacement when a human takes a role
- role restrictions and specialist limits
- squad cohesion state

The player can lead AI, serve under an AI leader, or operate separately depending on mode settings.

---

## M005 — Modern deployment, squad and tactical-map UI shell

**Goal:** establish the user experience early enough that later systems plug into one coherent interface.

Deliverables:

- original modern dark tactical visual language
- map-dominant deployment display
- squad list and membership panel
- role selection cards
- spawn-point panel
- objective/ticket header placeholders fed by real view-state interfaces
- scalable safe-zone layout across common resolutions
- reusable controls/styles
- clear loading/disabled/error states

No gameplay rule is duplicated inside UI code.

---

## M006 — Objectives, AAS/RAAS-style layer and tickets

**Goal:** create the actual match loop.

Deliverables:

- objective definitions and capture areas
- ordered objective chain
- AAS first, RAAS-like hidden/revealed routes later
- attacker/defender eligibility
- capture progress and contest state
- server-authoritative tickets
- ticket events for infantry, vehicles, FOBs and objectives
- ticket bleed and end-of-round logic
- UI view state

AI director consumes the same active attack/defend objectives shown to the player.

---

## M007 — Incapacitation, revive and deployment spawning

**Goal:** replace Arma's basic death/respawn feel with the Squad-style reinforcement loop.

Deliverables:

- incapacitated state
- bleed-out/give-up timing
- revive rules
- medic advantages
- main-base spawn
- spawn timers
- deploy screen transition
- AI casualty/reinforcement integration
- ticket charge at the correct lifecycle point

AI should attempt sensible casualty recovery only when tactically reasonable.

---

## M008 — Rally Points

**Goal:** make each squad capable of maintaining its own forward reinforcement point.

Deliverables:

- one active rally per squad
- placement eligibility around squad leadership
- enemy proximity rejection/burn logic
- cooldown
- wave spawn timing
- map/deployment representation
- AI understanding of rally viability

The exact numbers remain configurable rather than hard-coded to one Squad version.

---

## M009 — FOB/HAB network and construction

**Goal:** create team-level forward infrastructure.

Deliverables:

- FOB radio state
- build radius and exclusion rules
- construction resources
- HAB creation and activation
- enemy pressure/proxy behavior
- ammo crate
- repair point
- fortification/emplacement registry
- FOB destruction/ticket consequence
- map/deployment UI

---

## M010 — Logistics system

**Goal:** make battlefield sustainment matter to both human and AI forces.

Deliverables:

- ammunition and construction supply pools
- logistics vehicle cargo
- load/unload interactions
- main-base resupply
- FOB resupply
- infantry/ammo resupply
- vehicle repair/rearm hooks
- AI logistics squads and routes
- route-risk awareness

AI logistics must actually support active FOBs rather than teleporting resources.

---

## M011 — Strategic AI director

**Goal:** make the mostly-AI server feel like two organized teams playing the objective.

Deliverables:

- team commander state
- force allocation to attack/defend/logistics/reserve
- objective priority
- reinforcement decisions
- squad task assignment
- reaction to FOB loss, objective loss, vehicle loss and threat changes
- reserve/recovery behavior
- anti-zerg distribution rules

The director issues intent; it does not micromanage individual soldiers.

---

## M012 — Tactical squad AI

**Goal:** improve how AI squads execute intent.

Deliverables:

- movement/assault/defend/patrol/hold/reinforce tasks
- contact state machine
- suppression and maneuver hooks
- bounding behavior where practical
- fireteam splitting/rejoining
- cover/building behavior
- specialist weapon awareness
- fallback/retreat/regroup
- optional LAMBS adapter

Every tactical command executes on the machine local to the group.

---

## M013 — Vehicles and mechanized AI

**Goal:** integrate vehicles as strategic assets instead of disposable transports.

Deliverables:

- vehicle registry and ticket costs
- crew assignment
- driver/gunner/commander AI roles
- mounted infantry transport tasks
- dismount conditions
- logistics trucks
- APC/IFV/tank behavior
- repair/rearm loops
- abandonment/recovery
- spawn/respawn timers

---

## M014 — Command tools and map orders

**Goal:** let the human interact with the AI army efficiently without Zeus micromanagement.

Deliverables:

- squad/fireteam map orders
- move/attack/defend/hold/observe/resupply/transport commands
- command markers
- order acknowledgement/status
- commander-to-squad tasking
- contextual radial/quick commands
- AI reports for contact, casualties, low ammo and task state

---

## M015 — Battlefield information and communication

**Goal:** recreate the information discipline that makes Squad readable.

Deliverables:

- squad markers
- vehicle occupancy/status
- objective labels
- FOB/HAB/rally icons
- contact markers with decay
- squad and command channels represented through UI/status even when voice mods are not installed
- concise AI radio/status events

---

## M016 — Layer/config system and real maps

**Goal:** make the framework portable between terrains and scenarios.

Deliverables:

- map-independent layer config
- objective definitions
- main bases
- vehicle pools
- faction pairing
- initial force composition
- ticket settings
- AI population/performance settings
- optional mod presets

Start with one real production layer after the VR testbed is stable.

---

## M017 — Persistence, JIP and recovery hardening

**Goal:** survive long sessions and joins/disconnects cleanly.

Deliverables:

- complete JIP state rebuild
- player reconnect handling
- HC reconnect/rebalance
- stale entity cleanup
- state consistency audits
- server recovery hooks where possible

---

## M018 — Optimization and large-battle soak testing

**Goal:** reach a practical AI count with stable simulation.

Deliverables:

- profiling counters
- scheduler budgets
- AI ownership balancing
- dynamic simulation tuning
- spawn/despawn tuning
- network traffic reduction
- 30/60/120 minute soak tests
- dedicated-server RPT error budget of zero script errors

---

## M019 — Polish and release candidate

**Goal:** turn the framework into a coherent game experience.

Deliverables:

- UI animation/audio polish
- tutorials/tooltips
- server configuration documentation
- mission-maker documentation
- admin/debug tools
- failure-safe defaults
- release checklist and reproducible test matrix

## Non-goals for the early project

- PvP-specific balance
- exact 1:1 copying of Squad art/assets
- dependence on ACE, CBA or LAMBS for the core mission to function
- hundreds of independent AI scripts running per frame
- client-authoritative gameplay rules
