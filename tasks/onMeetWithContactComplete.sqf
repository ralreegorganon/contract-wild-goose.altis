["taskMeetWithContact", "succeeded"] call FHQ_TT_setTaskState;

execVM "hvt\hvtSetup.sqf";
execVM "communications\communicationsSetup.sqf";

contact sidechat "Here's the situation...";
sleep 3;
contact sidechat "The High Value Target is located in an industrial complex about 1km to the east of here.";
sleep 8;
contact sidechat "The complex looks pretty well protected. Last recon pass estimated two full squads of OPFOR.";
sleep 8;
contact sidechat "Check your intel for the latest photo we have of the HVT. Remember, the objective is to capture him alive.";
sleep 8;
[PlayerGroup,
	["taskCaptureHVT", 
	"The High Value Target is located in an industrial complex to the east of Negades. He must be captured alive.",
	"Capture HVT", 
	"CAPTURE", 
	getMarkerPos "marker_target_hvt", 
	"assigned"]
] call FHQ_TT_addTasks;
sleep 8;
contact sidechat "Extraction is by boat from the Kavala docks--we have people waiting offshore to take posession.";
sleep 8;
[PlayerGroup,
	["taskGetToDocks", 
	"Once you have the HVT in custody, bring him to the Kavala docks for extraction.",
	"Bring HVT to Kavala", 
	"DOCKS", 
	getMarkerPos "marker_target_docks",
	"created"]
] call FHQ_TT_addTasks;
contact sidechat "I've got a friend just north of Kore who can help with transportation to Kavala.";
sleep 8;
[PlayerGroup,
	["taskSecureTransportation", 
	"Meet the arms dealer in Kore to secure transportation to Kavala.",
	"(Optional) Secure transportation", 
	"TRANSPORTATION", 
	getMarkerPos "marker_target_transportation",
	"created"]
] call FHQ_TT_addTasks;
contact sidechat "One more thing...";
sleep 8;
contact sidechat "There's a communications facility south of here, overlooking the town.";
sleep 8;
contact sidechat "It looks like all of the communications from the industrial complex are being relayed through that facility.";
sleep 8;
contact sidechat "If you take it out, it'll ensure a communications blackout.";
[PlayerGroup,
	["taskDestroyCommunicationsTower", 
	"Communications from the complex are relayed through the comm towers to the south. Destroy them to create a distraction and ensure a blackout.",
	"(Optional) Disable communications", 
	"DESTROY", 
	getMarkerPos "marker_target_comm", 
	"created"]
] call FHQ_TT_addTasks;
sleep 8;
contact sidechat "They'd almost certainly send a team from the complex to investigate, so you should be able to take advantage of that.";
sleep 2;
contact sidechat "That's all I've got.";