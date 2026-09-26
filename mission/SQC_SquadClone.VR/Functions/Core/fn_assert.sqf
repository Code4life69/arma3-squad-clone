params
[
    ["_condition", false, [true]],
    ["_message", "Assertion failed", [""]],
    ["_component", "CORE", [""]]
];

if (_condition) exitWith
{
    true
};

[_component, _message, "ERROR"] call SQC_fnc_log;
false
