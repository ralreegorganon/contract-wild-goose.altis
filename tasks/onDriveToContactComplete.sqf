["taskDriveToContact", "succeeded"] call FHQ_TT_setTaskState;
[PlayerGroup,["taskMeetWithContact", "Meet with your contact in the nearby building",  "Meet with contact", "Contact", getpos contact, "assigned"]] call FHQ_TT_addTasks;
