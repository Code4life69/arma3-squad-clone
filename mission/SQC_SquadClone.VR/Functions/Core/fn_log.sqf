params
[
    ["_component", "CORE", [""]],
    ["_message", "", [""]],
    ["_level", "INFO", [""]]
];

private _role = call SQC_fnc_getExecutionRole;
private _version = missionNamespace getVariable ["SQC_version", "dev"];

diag_log format
[
    "[SQC][%1][%2][%3] %4",
    _version,
    toUpper _level,
    _role,
    format ["%1: %2", _component, _message]
];

true
