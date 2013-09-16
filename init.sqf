0 = [0,5,150,15,1,4,50,0] execvm "tpw_civs\tpw_civs.sqf"; 
0 = [0,5,1000,15,2] execvm "tpw_civs\tpw_cars.sqf"; 
0 = [0,5,1000,15,2] execvm "tpw_civs\tpw_boats.sqf";
0 = [0,10,15,200,75] execvm "tpw_civs\tpw_animals.sqf"; 

"hvt_ups_patrols_1" setMarkerAlpha 0;
"comm_ups_patrols_1" setMarkerAlpha 0;
"comm_ups_patrols_2" setMarkerAlpha 0;
"extract_ups_patrols_1" setMarkerAlpha 0;
"extract_ups_patrols_2" setMarkerAlpha 0;
"extract_ups_patrols_3" setMarkerAlpha 0;
"extract_ups_patrols_4" setMarkerAlpha 0;
"extract" setMarkerAlpha 0;

call compile preprocessFileLineNumbers "=BTC=_revive\=BTC=_revive_init.sqf";

call compile preProcessFileLineNumbers "fhqtt\fhqtt.sqf";

[
  PlayerGroup, 
    ["Mission",
      "We've taken a contract to capture and extradite a high value target whom our client is particularly interested in. Our contact in Negades has just informed us that he has new intel on our targets location, so we're headed there now..."],
      
    ["Notes",
      "All three mercenaries have different loadouts. There is additional gear in your truck."],
      
    ["Credits",
      "Mission by    <br/>Jason Jones"]
    
] call FHQ_TT_addBriefing;


execVM "tasks\initialTasks.sqf";

null = [3] execvm "tpwcas\tpwcas_script_init.sqf"