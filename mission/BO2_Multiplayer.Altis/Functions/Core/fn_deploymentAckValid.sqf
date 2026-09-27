// Pure rule: only the outstanding delivery in the current match may activate a life.
params ["_expectedId","_expectedRound","_receivedId","_receivedRound","_currentRound"];
(_expectedId > 0) && {_expectedId isEqualTo _receivedId} && {_expectedRound isEqualTo _receivedRound} && {_receivedRound isEqualTo _currentRound}
