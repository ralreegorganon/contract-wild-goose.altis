execVM "mission\references\init.sqf";
execVM "mission\briefing.sqf";
execVM "mission\ambient\init.sqf";
execVM "mission\tasks\init.sqf";

/* needs a new home */
"hvt_ups_patrols_1" setMarkerAlpha 0;
"comm_ups_patrols_1" setMarkerAlpha 0;
"comm_ups_patrols_2" setMarkerAlpha 0;
"extract_ups_patrols_1" setMarkerAlpha 0;
"extract_ups_patrols_2" setMarkerAlpha 0;
"extract_ups_patrols_3" setMarkerAlpha 0;
"extract_ups_patrols_4" setMarkerAlpha 0;
"extract" setMarkerAlpha 0;