function debugLevelTheHellUp(){
	for(var j = 0; j<2; j++){
		players[j].leveledTheHellUp = true; //only .evel 2 players up
	}
	var s = new LevelTheHellUp();
	if(s.trigger(players) && !version2){
		//alert("v1 " + version2);
		$("#story").append(s.content()+ "<br><br> ");
	}else if (s.trigger(players) && version2){
		s.renderContent(newScene());
	}
}

function debugGodTierLevelTheHellUp(){
	for(var j = 0; j<2; j++){
		players[j].godTier = true;
		players[j].leveledTheHellUp = true; //only .evel 2 players up
	}
	var s = new LevelTheHellUp();
	if(s.trigger(players) && !version2){
		//alert("v1 " + version2);
		$("#story").append(s.content()+ "<br><br> ");
	}else if (s.trigger(players) && version2){
		s.renderContent(newScene());
	}
}

function debugGodTier(){
	for(var j = 0; j<players.length; j++){
		players[j].godDestiny = true;
		players[j].dead = true; //only .evel 2 players up
	}
	var s = new GetTiger();
	if(s.trigger(players) && !version2){
		//alert("v1 " + version2);
		$("#story").append(s.content()+ "<br><br> ");
	}else if (s.trigger(players) && version2){
		s.renderContent(newScene());
	}
}

function debugGodTierRevive(){
	for(var j = 0; j<players.length; j++){
		players[j].godTier = true;
		players[j].dead = true; //only .evel 2 players up
	}
	var s = new GodTierRevival();
	if(s.trigger(players) && !version2){
		//alert("v1 " + version2);
		$("#story").append(s.content()+ "<br><br> ");
	}else if (s.trigger(players) && version2){
		s.renderContent(newScene());
	}
}

function debugPowerfulKing(){
	kingStrength = 10000;
	var s = new KingPowerful();
	if(s.trigger(players) && !version2){
		//alert("v1 " + version2);
		$("#story").append(s.content()+ "<br><br> ");
	}else if (s.trigger(players) && version2){
		s.renderContent(newScene());
	}
	
}

function generateDebugPlayers1(){
	//Player(class_name, aspect, land, kernel_sprite, moon)
	players.push(new Player("Knight", "Time", "Land of Headbanging and Stress", "Bugs", "Prospit", true));
	players.push(new Player("Page", "Space", "Land of BS and Tickles", "Code", "Prospit", true));
	players.push(new Player("Seer", "Void", "Land of Nothing and More Nothing", "Frog", "Prospit", true));
	players.push(new Player("Mage", "Mind", "Land of Slides and Whistles", "Lame", "Prospit", false));
	players.push(new Player("Heir", "Blood", "Land of Debugging and Tests", "Decoy", "Derse", false));
	players.push(new Player("Witch", "Light", "Land of Bugs and More Bugs", "First Guardian", "Derse",false));
	players.push(new Player("Thief", "Hope", "Land of Why and Serious", "Debug", "Derse",false));
	players.push(new Player("Rogue", "Heart", "Land of Flipping and Shit", "Spray", "Derse",false));

	for(var j = 0; j<players.length; j++){
		players[j].generateRelationships(players);
	}
}

function generateVoidLeader(){
	//Player(class_name, aspect, land, kernel_sprite, moon)
	players.push(new Player("Knight", "Void", "Land of Headbanging and Stress", "Bugs", "Prospit", true));
	players.push(new Player("Heir", "Space", "Land of BS and Tickles", "Code", "Prospit", true));
	players.push(new Player("Seer", "Time", "Land of Nothing and More Nothing", "Frog", "Prospit", true));
	players.push(new Player("Mage", "Mind", "Land of Slides and Whistles", "Lame", "Prospit", false));
	players.push(new Player("Thief", "Hope", "Land of Why and Serious", "Debug", "Derse",false));

	for(var j = 0; j<players.length; j++){
		players[j].generateRelationships(players);
	}
}

function generateDebugBloodPlayers(){
	players.push(new Player("Knight", "Blood", "Land of Headbanging and Stress", "Bugs", "Prospit", true));
	players.push(new Player("Page", "Blood", "Land of BS and Tickles", "Code", "Prospit", true));
	players.push(new Player("Seer", "Blood", "Land of Nothing and More Nothing", "Frog", "Prospit", true));
	players.push(new Player("Mage", "Blood", "Land of Slides and Whistles", "Lame", "Prospit", false));
	players.push(new Player("Heir", "Blood", "Land of Debugging and Tests", "Decoy", "Derse", false));
	players.push(new Player("Witch", "Space", "Land of Bugs and More Bugs", "First Guardian", "Derse",false));
	players.push(new Player("Thief", "Time", "Land of Why and Serious", "Debug", "Derse",false));
	players.push(new Player("Rogue", "Blood", "Land of Flipping and Shit", "Spray", "Derse",false));

	for(var j = 0; j<players.length; j++){
		players[j].generateRelationships(players);
	}
}

function generateDebugRagePlayers(){
	players.push(new Player("Knight", "Rage", "Land of Headbanging and Stress", "Bugs", "Prospit", true));
	players.push(new Player("Page", "Rage", "Land of BS and Tickles", "Code", "Prospit", true));
	players.push(new Player("Seer", "Rage", "Land of Nothing and More Nothing", "Frog", "Prospit", true));
	players.push(new Player("Mage", "Rage", "Land of Slides and Whistles", "Lame", "Prospit", false));
	players.push(new Player("Heir", "Rage", "Land of Debugging and Tests", "Decoy", "Derse", false));
	players.push(new Player("Witch", "Space", "Land of Bugs and More Bugs", "First Guardian", "Derse",false));
	players.push(new Player("Thief", "Time", "Land of Why and Serious", "Debug", "Derse",false));
	players.push(new Player("Rogue", "Rage", "Land of Flipping and Shit", "Spray", "Derse",false));

	for(var j = 0; j<players.length; j++){
		players[j].generateRelationships(players);
	}
}

function generateDebugAllPlayers(){
	players.push(new Player("Knight", "Space", "Land of Headbanging and Stress", "Bugs", "Prospit", true));
	players.push(new Player("Page", "Time", "Land of BS and Tickles", "Code", "Prospit", true));
	players.push(new Player("Seer", "Void", "Land of Nothing and More Nothing", "Frog", "Prospit", true));
	players.push(new Player("Mage", "Mind", "Land of Slides and Whistles", "Lame", "Prospit", true));
	players.push(new Player("Heir", "Blood", "Land of Debugging and Tests", "Decoy", "Derse", true));
	players.push(new Player("Witch", "Light", "Land of Bugs and More Bugs", "First Guardian", "Derse",true));
	players.push(new Player("Thief", "Hope", "Land of Why and Serious", "Debug", "Derse",true));
	players.push(new Player("Maid", "Rage", "Land of Flipping and Shit", "Spray", "Derse",true));
	players.push(new Player("Rogue", "Doom", "Land of Fire and Ice", "Dictionary", "Derse",true));
	players.push(new Player("Sylph", "Life", "Land of Why and Not", "Wizard", "Prospit",true));
	players.push(new Player("Prince", "Breath", "Land of Here and There", "Beer", "Derse",true));
	players.push(new Player("Bard", "Heart", "Land of Fake and Magic", "Nonsense", "Prospit",true));


	for(var j = 0; j<players.length; j++){
		players[j].generateRelationships(players);
	}
}

function exileQueenInit(){
	available_classes = classes; //re-init available classes.
	available_aspects = nonrequired_aspects;
	generateDebugPlayers1();


}

function voidLeaderInit(){
	available_classes = classes; //re-init available classes.
	available_aspects = nonrequired_aspects;
	//generateDebugPlayers1();
	generateVoidLeader();


}

function murderModeInit(){
	available_classes = classes; //re-init available classes.
	available_aspects = nonrequired_aspects;
	generateDebugRagePlayers();	 //blood players can talk a murderer down.
	var mm = findAspectPlayer(players, "Rage");
	for(var i = 0; i<10; i++){
		mm.damageAllRelationships();
	}
	mm.triggerLevel = 3;
	mm.murderMode = true;
}
