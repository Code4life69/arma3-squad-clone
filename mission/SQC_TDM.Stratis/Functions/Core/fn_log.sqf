params
[
    ["_component", "CORE", [""]],
    ["_message", "", [""]],
    ["_level", "INFO", [""]]
];

private _version = missionNamespace getVariable ["SQC_version", "dev"];
private _role = call SQC_fnc_getExecutionRole;

diag_log format
[
    "[SQC][%1][%2][%3][%4] %5",
    _version,
    toUpper _level,
    _role,
    _component,
    _message
];

true
