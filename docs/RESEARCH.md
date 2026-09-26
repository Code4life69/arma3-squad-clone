> Historical Squad/VR foundation document. The current BO2-inspired arena is described in README.md and BLACKLINE_ARCHITECTURE.md.

# Research Notes

Research date: 2026-09-26

## Arma 3 multiplayer architecture

### Initialization order

Bohemia documents different initialization paths for server, player clients and JIP clients. `initServer.sqf` is server-only, while `initPlayerLocal.sqf` runs locally for joining clients. Headless clients also execute client-side mission initialization, so UI code must never assume every client has an interface.

Source: https://community.bistudio.com/wiki/Initialization_Order
Source: https://community.bistudio.com/wiki/Event_Scripts
Source: https://community.bistudio.com/wiki/Arma_3%3A_Headless_Client

**Design consequence:** bootstrap is split by execution role from the beginning.

### Locality and AI ownership

AI groups are simulated on the machine that owns the group. Locality can move when group leadership changes, players enter vehicles, or ownership is explicitly transferred. `setGroupOwner` is server-only and is the supported way to transfer an AI group to a client/headless client.

Source: https://community.bistudio.com/wiki/Multiplayer_Scripting
Source: https://community.bistudio.com/wiki/setGroupOwner
Source: https://community.bistudio.com/wiki/groupOwner

**Design consequence:** all future AI orders must route through the machine that owns the AI group. We will not scatter AI commands across arbitrary clients.

### AI scale and performance

Bohemia identifies AI quantity as a major CPU/network cost, recommends Dynamic Simulation for distant AI, and suggests headless clients to offload AI simulation when needed.

Source: https://community.bistudio.com/wiki/Mission_Optimisation
Source: https://community.bistudio.com/wiki/enableDynamicSimulation
Source: https://community.bistudio.com/wiki/Arma_3%3A_Headless_Client

**Design consequence:** AI is organized into managed groups, distant forces can be dynamically simulated, and headless-client support is part of the architecture rather than a late optimization.

### Remote execution security

Bohemia recommends remote-executing named functions rather than `call`/`spawn`, and `CfgRemoteExec` can whitelist functions by allowed target. Persistent JIP remote-execution ordering is not guaranteed.

Source: https://community.bistudio.com/wiki/remoteExec
Source: https://community.bistudio.com/wiki/CfgRemoteExec
Source: https://community.bistudio.com/wiki/Arma_3_Remote_Execution

**Design consequence:** network APIs will be small, named, validated, server-authoritative, and explicitly whitelisted when introduced. M001 intentionally has no custom remote-execution surface.

### UI system

Arma mission UI can be implemented through displays/dialogs and mission config controls. Displays are preferred for major interactive screens where we do not want the default dialog behavior to dictate the entire experience.

Source: https://community.bistudio.com/wiki/Arma%3A_GUI_Configuration
Source: https://community.bistudio.com/wiki/createDialog
Source: https://community.bistudio.com/wiki/ctrlCreate

**Design consequence:** the deployment/squad/map interface will be a dedicated UI subsystem with reusable controls and data adapters rather than ad-hoc hints/actions.

## Squad gameplay research

### Spawn network

Squad uses Main Base, team-wide HAB spawns and squad-specific Rally Points. Rally Points use wave spawning and can be removed by nearby enemies; HABs can become unavailable under enemy pressure.

Source: https://squad.wiki.gg/wiki/Spawning

**Design consequence:** respawn is a strategic network controlled by battlefield state. AI reinforcement spawning will use the same conceptual network so AI and player forces obey one set of rules.

### Logistics and FOBs

Construction and ammunition supplies are moved by logistics vehicles and sustain FOBs/deployables.

Source: https://squad.wiki.gg/wiki/Logistics

**Design consequence:** FOBs will be stateful logistics nodes, not decorative respawn markers.

### Tickets

Tickets are the primary win/loss resource. Infantry deaths, FOB losses and vehicle losses can consume tickets, while objective state can create gains or bleed depending on mode.

Source: https://squad.wiki.gg/wiki/Tickets

**Design consequence:** every major battlefield entity will report lifecycle events to one authoritative ticket/game-state service.

## AI behavior research

LAMBS Danger demonstrates a useful state-driven approach to infantry behavior and tactical building use, but its advanced task functions must execute where the AI is local.

Source: https://github.com/nk3nny/LambsDanger
Source: https://github-wiki-see.page/m/nk3nny/LambsDanger/wiki/waypoints

**Design consequence:** the core project remains vanilla-compatible first. LAMBS integration can be added later as an optional adapter after ownership, orders and state machines are stable.
