["taskMeetWithContact", "succeeded"] call FHQ_TT_setTaskState;

contact sidechat "Here's the situation...";
sleep 3;

contact sidechat "The High Value Target is located in an industrial complex about 1km to the east of here.";
sleep 8;
contact sidechat "The complex looks pretty well protected. Last recon pass estimated two full squads of OPFOR.";
sleep 8;
contact sidechat "Check your intel for the latest photo we have of the HVT. Remember, the objective is to capture him alive.";
execVM "mission\tasks\captureHVT\init.sqf";
sleep 8;

contact sidechat "Extraction is by boat from the Kavala docks--we have people waiting offshore to take posession.";
execVM "mission\tasks\getToDocks\init.sqf";
sleep 8;

contact sidechat "I've got a friend just north of Kore who can help with transportation to Kavala.";
execVM "mission\tasks\secureTransportation\init.sqf";
sleep 8;

contact sidechat "One more thing...";
sleep 8;
contact sidechat "There's a communications facility south of here, overlooking the town.";
sleep 8;
contact sidechat "It looks like all of the communications from the industrial complex are being relayed through that facility.";
sleep 8;
contact sidechat "If you take it out, it'll ensure a communications blackout.";
execVM "mission\tasks\destroyCommunications\init.sqf";
sleep 8;
contact sidechat "They'd almost certainly send a team from the complex to investigate, so you should be able to take advantage of that.";
sleep 2;

contact sidechat "That's all I've got.";