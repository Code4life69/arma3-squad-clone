missionNamespace setVariable ["SQC_version", "0.2.0-visual-shell"];

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

["BOOT", "Spawn director and visual-shell defaults loaded", "DEBUG"] call SQC_fnc_log;
true
