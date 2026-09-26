missionNamespace setVariable ["SQC_version", "0.5.0-arcade-combat"];

missionNamespace setVariable ["SQC_spawnArenaCenter", [2915.2, 6164.52, 0]];
missionNamespace setVariable ["SQC_spawnArenaRadius", 230];
missionNamespace setVariable ["SQC_spawnGroundStep", 25];
missionNamespace setVariable ["SQC_spawnEnemyHardMin", 18];
missionNamespace setVariable ["SQC_spawnLOSRange", 120];
missionNamespace setVariable ["SQC_spawnRefineCount", 24];
missionNamespace setVariable ["SQC_spawnDeathMemorySeconds", 14];
missionNamespace setVariable ["SQC_spawnReuseMemorySeconds", 10];
missionNamespace setVariable ["SQC_spawnCandidates", []];
missionNamespace setVariable ["SQC_spawnRecent", []];
missionNamespace setVariable ["SQC_spawnDeathHeat", []];
missionNamespace setVariable ["SQC_spawnReady", false];

missionNamespace setVariable ["SQC_selectedClass", "ASSAULT"];
missionNamespace setVariable ["SQC_matchScores", [0, 0]];
missionNamespace setVariable ["SQC_matchTimeRemaining", 600];
missionNamespace setVariable ["SQC_matchScoreLimit", 75];
missionNamespace setVariable ["SQC_matchTimeLimit", 600];
missionNamespace setVariable ["SQC_matchRunning", false];
missionNamespace setVariable ["SQC_matchInitialized", false];
missionNamespace setVariable ["SQC_matchState", "WAITING"];
missionNamespace setVariable ["SQC_playerStats", []];

missionNamespace setVariable ["SQC_aiTeamSize", 6];
missionNamespace setVariable ["SQC_aiRespawnDelay", 2];
missionNamespace setVariable ["SQC_aiCorpseCleanupDelay", 10];
missionNamespace setVariable ["SQC_aiClassWest", "B_Soldier_F"];
missionNamespace setVariable ["SQC_aiClassEast", "O_Soldier_F"];
missionNamespace setVariable ["SQC_nextBotId", 1];
missionNamespace setVariable ["SQC_aiInitialized", false];
missionNamespace setVariable ["SQC_aiPendingRespawns", []];

missionNamespace setVariable ["SQC_friendlyFire", false];
missionNamespace setVariable ["SQC_damageScale", 0.86];
missionNamespace setVariable ["SQC_healthRegenDelay", 5];
missionNamespace setVariable ["SQC_playerAimCoef", 0.55];
missionNamespace setVariable ["SQC_playerRecoilCoef", 0.75];
missionNamespace setVariable ["SQC_combatLocalInitialized", false];

["BOOT", "Spawn, UI, AI, TDM and arcade-combat defaults loaded", "DEBUG"] call SQC_fnc_log;
true
