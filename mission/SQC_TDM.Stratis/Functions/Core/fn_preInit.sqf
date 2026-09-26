missionNamespace setVariable ["SQC_version", "0.1.0-spawn-director"];

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

["BOOT", "Spawn director configuration loaded", "DEBUG"] call SQC_fnc_log;
true
