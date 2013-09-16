[
    PlayerGroup,                                                          
      ["taskDriveToContact", "Meet with your contact in Negades for information as to the HVT's location",  "Drive to Negades", "Negades", getMarkerPos "markerNegades", "created"]
] call FHQ_TT_addTasks;

sleep 1;

["taskDriveToContact", "assigned"] call FHQ_TT_setTaskState;
