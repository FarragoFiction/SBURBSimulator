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

//no. you gots to flip it TURN-WAYS, dunkass.
//rendering shouldu be different
//making new scenes to be different
function sbahjMode(){
	alert("where MAKING THIS HAPEN")
	$("#story").append("<img src = 'images/AUTHORSBAHJ.jpg' style='position:absolute; top:111px'>");
	$('body').css("background-color", "#0000ff");
	$('#story').css("background-color", "#ff00ff");
	curSessionGlobalVar.sbahj = true;
	for(var j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		p.sbahj = true;
		p.quirk.lettersToReplaceIgnoreCase = p.quirk.lettersToReplaceIgnoreCase.concat(sbahj_quirks);
	}
}

function tricksterMode(){
	alert("I FEEL JUST PEEEEEEEEEEEACHY!!!!!!!!!!!")
	$("#story").append("<img src = 'images/trickster_author.png' style='float:left;'>");
	$('body').css("background-color", "#ff93e4");
	for(var j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		p.hairColor = getRandomElementFromArray(tricksterColors);
		p.bloodColor = getRandomElementFromArray(tricksterColors);

		p.trickster  = true;
		if(p.aspect != "Heart"){//no personality changes.
			p.quirk.capitalization = 2;
			p.quirk.punctuation = 3;
			p.quirk.favoriteNumber = 11;
			for(var k = 0; k <p.relationships.length; k++){
				var r = p.relationships[k];
				r.value = 111111; //EVERYTHIGN IS BETTER!!!!!!!!!!!
			}
		}
		p.power = 111111;
		p.landLevel = 111111;
		p.level_index = 111111;


	}
}

function debugRoyalRumble(){
	alert("royal rumble!")
	for(var j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j]
		p.isTroll = true; //only .evel 2 players up
		p.bloodColor = "#99004d"
		p.triggerLevel = 10;
		p.decideLusus(p);
		p.kernel_sprite = p.lusus;
		p.relationships = [];
		p.quirk = null;
		p.generateRelationships(curSessionGlobalVar.players);  //heiresses hate each other
		p.quirk = randomTrollSim(p)
	}

}

function debugGrimDark(){
	for(var j = 0; j<2; j++){
		players[j].grimDark = true; //only .evel 2 players up
	}

}

function debugTriggerLevel(){
	for(var j = 0; j<2; j++){
		players[j].triggerLevel = 10;
	}

}
//does this even work? oh, yeah, it does, but won't trigger until land quests are done
function debugRelationshipDrama(){
	var p1 = players[0];
	var enemy = p1.getWorstEnemyFromList(players);
	p1.getRelationshipWith(enemy).value += 10;  //suddenly love them.
	p1.getRelationshipWith(enemy).drama = true
	var p2 = players[1];
	var friend = p2.getBestFriendFromList(players);
	p2.getRelationshipWith(friend).value += -10;  //suddenly hate them.
	p2.getRelationshipWith(friend).drama = true

}

function debugJackScheme(){
	queenStrength = 20;
	players[0].class_name = "Page" //make a chump for Jack to talk to.
	var s = new JackBeginScheming();
	if(s.trigger(players) && !version2){
		//alert("v1 " + version2);
		$("#story").append(s.content()+ "<br><br> ");
	}else if (s.trigger(players) && version2){
		s.renderContent(newScene());
	}
}

function debugCorpseLevelTheHellUp(){
	for(var j = 0; j<2; j++){
		players[j].dead = true;
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

function debugCorpseSmooch(){
	for(var j = 0; j<2; j++){
		players[j].dead = true;
	}
	var s = new CorpseSmooch();
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
