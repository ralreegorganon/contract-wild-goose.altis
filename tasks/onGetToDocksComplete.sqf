["taskGetToDocks", "succeeded"] call FHQ_TT_setTaskState;
[PlayerGroup,
	["taskExtractHVT", 
	"Bring the HVT offsore for extraction.",
	"Extract", 
	"EXTRACT", 
	getMarkerPos "marker_target_extract", 
	"assigned"]
] call FHQ_TT_addTasks;
"extract" setMarkerAlpha 1;
