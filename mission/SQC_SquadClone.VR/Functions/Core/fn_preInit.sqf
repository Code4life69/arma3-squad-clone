missionNamespace setVariable ["SQC_version", "0.1.0-foundation"];
missionNamespace setVariable ["SQC_bootstrapComplete", false];
missionNamespace setVariable ["SQC_serverReady", false];
missionNamespace setVariable ["SQC_clientReady", false];
missionNamespace setVariable ["SQC_headlessReady", false];

["BOOT", "CfgFunctions preInit complete", "DEBUG"] call SQC_fnc_log;
true
