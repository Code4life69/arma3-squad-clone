# M004 TDM Match Core

## Default rules

- two teams: WEST and EAST
- 75 enemy kills to win
- 10 minute time limit
- one enemy kill = one team point
- suicide = no team point
- teamkill = no team point
- scoring and timer are server-authoritative

## Replicated state

The server publishes:

- SQC_matchScores = [westScore, eastScore]
- SQC_matchTimeRemaining
- SQC_matchScoreLimit
- SQC_matchState
- SQC_matchRunning
- SQC_playerStats

The existing HUD only reads these values.

## Kill processing

The server's EntityKilled mission event calls SQC_fnc_matchHandleKill.

The function:

1. records a human victim death stat
2. resolves killer/instigator
3. rejects suicides/teamkills from team score
4. awards one point for a valid enemy kill
5. records a human killer kill stat
6. broadcasts a compact kill-feed line to clients
7. checks score limit

## Time limit

The server owns one timer loop.

At zero:
- higher score wins
- equal score is a draw

No client can extend or reduce the round timer.

## End of round

Scoring stops immediately, final state is replicated, then the mission ends through BIS_fnc_endMissionServer after a short final-score pause.
