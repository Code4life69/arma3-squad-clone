if (!isServer) exitWith {};
private _rows = BL_records apply {[_x select 0,_x select 2,_x select 3,_x select 4,_x select 5,_x select 6,_x select 7,+(_x select 9)]};
BL_state = [BL_phase,BL_mode,+BL_scores,BL_limit,BL_phaseEnd,+BL_objectives,BL_hill,BL_hillEnd,_rows,+BL_uavUntil,+BL_counterUntil,+BL_tags,BL_round];
publicVariable "BL_state";
