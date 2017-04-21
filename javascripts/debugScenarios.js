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
	$("#story").append("<ixmg src = 'images/AUTHORSBAHJ.jpg' style='position:absolute; top:111px'>");
	$('body').css("background-color", "#0000ff");
	$('#story').css("background-color", "#ff00ff");
	curSessionGlobalVar.sbahj = true;
	for(var j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		p.sbahj = true;
		p.quirk.lettersToReplaceIgnoreCase =sbahj_quirks
	}
}

function checkEasterEgg(){
	//authorMessage();
	//i cannot resist
	if(initial_seed == 413){
		session413();
	}else if(initial_seed == 612){
		session612();
	}else if(initial_seed == 613){
		session613();
	}else if(initial_seed == 1025){
		session1025()
	}else if(initial_seed == 33){
		session33();
	}else if(initial_seed == 111111){
		session111111();
	}
}


function babyStuckMode(){
	alert("goo goo GA GAH!")
	for(var j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		p.baby_stuck = true;
		p.quirk.lettersToReplaceIgnoreCase = p.quirk.lettersToReplaceIgnoreCase.concat([["e", "goo"],["a","gah"],["i","ga"],["o","blooo"],["u","guuuu"]]);
	}
}

//AB told me this was funny! I SWEAR I am not Robo-Racist! It's IRONIC.
function roboMode(){
	alert("BEEP")
	$("#story").append("<img src = 'images/robot_author.png' style='float:left;'>");
	for(var j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		p.hairColor = getRandomGreyColor();
		p.bloodColor = getRandomGreyColor();
		p.robot  = true;
		p.power += 20; //Robots are superior.
		p.quirk.capitalization = 2; //OBVIOUSLY robots all speak in all caps.
		p.quirk.punctuation = 0; //robots speak in monotone, DUH.
		p.quirk.lettersToReplaceIgnoreCase.push(["\\bhuh\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.push(["\\ber\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.push(["\\bhrmm\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.push(["\\bum\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.push(["\\buh\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.push(["\\boh\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.push(["fuck","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.push(["ass","BEEP"]);
		for(var k = 0; k <p.relationships.length; k++){
				var r = p.relationships[k];
				r.value = 0.00001; // Clearly they are just tin cans without feelings. Robo, or otherwise.  if i set it to zero, they never even bother to talk to each other....
		}
	}
}

function tricksterMode(){
	alert("I FEEL JUST PEEEEEEEEEEEACHY!!!!!!!!!!!")
	$("#story").append("<img src = 'images/trickster_author.png' style='float:left;'><img src = 'images/trickster_artist.png' style='float:left;'>");
	$('body').css("background-color", "#ff93e4");
	for(var j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		if(p.aspect != "Doom"){ //kr says it would be funny if doom plalyers completely immune.
			p.hairColor = getRandomElementFromArray(tricksterColors);
			p.bloodColor = getRandomElementFromArray(tricksterColors);
			p.trickster  = true;
		}else{
		}


		if(p.aspect != "Heart" && p.aspect != "Doom"){//no personality changes.
			p.quirk.capitalization = 2;
			p.quirk.punctuation = 3;
			p.quirk.favoriteNumber = 11;
			for(var k = 0; k <p.relationships.length; k++){
				var r = p.relationships[k];
				r.value = 111111; //EVERYTHIGN IS BETTER!!!!!!!!!!!
			}
		}
		if(p.aspect != "Doom"){
			p.power = 111111;
			p.landLevel = 111111;
			p.level_index = 111111;
		}


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



function session413(){
	for(var i = 0; i<8;i++){
		var player;
		var guardian;
		if(i< curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian.quirk = randomHumanSim(guardian);
			player.quirk = randomHumanSim(player);
			player.guardian = guardian;
			guardian.guardian = player;
			curSessionGlobalVar.players.push(player);
		}
	}

	for(var i = 0; i<8;i++){
		player = curSessionGlobalVar.players[i];
		var guardian = player.guardian;
		player.isTroll = false;
		guardian.isTroll = false;
		player.relationships = [];
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players)
		guardian.generateBlandRelationships(guardians);
		player.generateBlandRelationships(curSessionGlobalVar.players);
		session413IndexToHuman(player, i);
		session413IndexToAncestor(guardian, i);//just call regular with a different index
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}

function session111111(){
	for(var i = 0; i<8;i++){
		var player;
		var guardian;
		if(i< curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian.quirk = randomHumanSim(guardian);
			player.quirk = randomHumanSim(player);
			player.guardian = guardian;
			guardian.guardian = player;
			curSessionGlobalVar.players.push(player);
		}
	}

	for(var i = 0; i<8;i++){
		player = curSessionGlobalVar.players[i];
		var guardian = player.guardian;
		player.isTroll = false;
		guardian.isTroll = false;
		player.relationships = [];
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players)
		guardian.generateBlandRelationships(guardians);
		player.generateBlandRelationships(curSessionGlobalVar.players);
		session413IndexToAncestor(player, i);
		session413IndexToHuman(guardian, i);//just call regular with a different index
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}

function session413IndexToHuman(player,index){
	if(index == 0){
		player.bloodColor = "#ff0000"
		player.class_name = "Heir"
		player.godDestiny = true;
		player.aspect = "Breath"
		player.hair  =3;
		player.hairColor = "#000000"
		player.chatHandle = "ectoBiologist"
		player.interest1 = "Pranks"
		player.interest2 = "Action Movies"
		player.kernel_sprite = "Clown"
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 1;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["lol","hehehe"]];
		player.land = "Land of Wind and Shade"
		player.moon = "Prospit"
	}else if(index == 1){
		player.moon = "Derse"
		player.bloodColor = "#ff0000"
		player.godDestiny = true;
		player.class_name = "Seer"
		player.land = "Land of Light and Rain"
		player.aspect = "Light"
		player.chatHandle = "tentacleTherapist"
		player.interest1 = "Writing"
		player.interest2 = "Horrorterrors"
		player.hair  =20;
		player.hairColor = "#fff3bd"
		player.kernel_sprite = "Cat"
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 1;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["hey","greetings"],["yes", "certainly"]];
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 2){
		player.moon = "Derse"
		player.bloodColor = "#ff0000"
		player.class_name = "Knight"
		player.land = "Land of Heat and Clockwork"
		player.aspect = "Time"
		player.hairColor = "#feffd7"
		player.hair  =1;
		player.chatHandle = "turntechGodhead"
		player.interest1 = "Rap"
		player.interest2 = "Irony"
		player.kernel_sprite = "Puppet"
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["hey","sup"]];
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 3){
		player.moon = "Prospit"
		player.bloodColor = "#ff0000"
		player.class_name = "Witch"
		player.land = "Land of Frost and Frogs"
		player.aspect = "Space"
		player.hair  =9;
		player.hairColor = "#3f1904"
		player.chatHandle = "gardenGnostic"
		player.interest1 = "Physics"
		player.interest2 = "Gardening"
		player.kernel_sprite = "First Guardian"
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 3;
		player.favoriteNumber = 5;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 4){
		player.moon = "Prospit"
		player.bloodColor = "#ff0000"
		player.class_name = "Maid"
		player.godDestiny = true;
		player.aspect = "Life"
		player.land = "Land of Crypts and Helium"
		player.hair  =38;
		player.hairColor = "#000000"
		player.chatHandle = "gutsyGumshoe"
		player.interest1 = "Pranks"
		player.interest2 = "Baking"
		player.kernel_sprite = "Mistake"
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["lol","hoo hoo"]];
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 5){
		player.moon = "Derse"
		player.bloodColor = "#ff0000"
		player.class_name = "Rogue"
		player.land = "Land of Pyramids and Neon"
		player.aspect = "Void"
		player.hair  =24;
		player.hairColor = "#fff3bd"
		player.chatHandle = "tipsyGnostalgic"
		player.interest1 = "Writing"
		player.interest2 = "Wizards"
		//HI!!! HOW ARE YOU!?
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["like","liek"], ["school","skool"]];
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
		player.kernel_sprite = "Troll"
	}else if(index == 6){
		player.moon = "Derse"
		player.bloodColor = "#ff0000"
		player.class_name = "Prince"
		player.land = "Land of Tombs and Krypton"
		player.aspect = "Heart"
		player.hair  =36;
		player.hairColor = "#feffd7"
		player.chatHandle = "timaeusTestified"
		player.interest1 = "Irony"
		player.interest2 = "Robots"
		player.kernel_sprite = "Robot Horse Weirdo"
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["hey","sup"]];
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""

	}else if(index == 7){
		player.moon = "Prospit"
		player.bloodColor = "#ff0000"
		player.class_name = "Page"
		player.land = "Land of Mounds and Xenon"
		player.aspect = "Hope"
		player.hair  =37;
		player.hairColor = "#3f1904"
		player.chatHandle = "golgothasTerror"
		player.interest1 = "Physics"
		player.interest2 = "Movies"
		player.kernel_sprite = "Buddy"
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 1;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["lol","good one"]];
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}

}

//just hange index and return whatever regular does. pretend janes goes in first
function session413IndexToAncestor(player,index){
	if(index == 0){
		session413IndexToHuman(player, 4)
	}else if(index == 1){
		session413IndexToHuman(player, 5)
	}else if(index == 2){
		session413IndexToHuman(player, 6)
	}else if(index == 3){
		session413IndexToHuman(player, 7)
	}else if(index == 4){
		session413IndexToHuman(player, 0)
	}else if(index == 5){
		session413IndexToHuman(player, 1)
	}else if(index == 6){
		session413IndexToHuman(player, 2)
	}else if(index == 7){
		session413IndexToHuman(player, 3)
	}
}

//12 dead nepetas
function session33(){
	//will it be 12 nepetas roleplaying as their friends?
	//or 12 canon trolls all roleplaying as nepeta?
	//it's shrodinger's nepeta!!!
	var actualRandomNumber = Math.random(); //no fucking seed.
	alert("Nepeta Quest")
	curSessionGlobalVar.players = [];//no, only nepetas.
	for(var i = 0; i<12;i++){
		var player;
		var guardian;
		if(i>2){
			guardian = randomPlayerWithClaspect(curSessionGlobalVar,"Rogue", "Heart");
			player = randomPlayerWithClaspect(curSessionGlobalVar,"Rogue", "Heart");
		}else if(i==0){
			guardian = randomPlayerWithClaspect(curSessionGlobalVar,"Rogue", "Time");
			player = randomPlayerWithClaspect(curSessionGlobalVar,"Rogue", "Time");
		}else if(i ==1){
			guardian = randomPlayerWithClaspect(curSessionGlobalVar,"Rogue", "Space");
			player = randomPlayerWithClaspect(curSessionGlobalVar,"Rogue", "Space");
		}
		if(i == 0){
			player.leader = true;
			guardian.leader = true;
		}
		player.quirk = randomTrollSim(player);
		guardian.quirk = randomTrollSim(player);
		curSessionGlobalVar.players.push(player);
		player.guardian = guardian;
		guardian.guardian = player;

		session612IndexToTroll(player, i);
		session612IndexToTrollAncestor(guardian, i);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}

	for(var i = 0; i<12;i++){
		player = curSessionGlobalVar.players[i];
		guardian = player.guardian;
		player.isTroll = true;
		guardian.isTroll = true;
		player.generateRelationships(curSessionGlobalVar.players);
		//TODO fix this i guess.  Edit: TheLertTheWorldNeeds convinced me to fix it.
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players)
		guardian.generateRelationships(guardians);
		if(player.aspect != "Time" && player.aspect != "Space"){
			player.aspect = "Heart"
			player.class_name = "Rogue"
		}
		if(guardian.aspect != "Time" && guardian.aspect != "Space"){
			guardian.aspect = "Heart"
			guardian.class_name = "Rogue"
		}
		player.hair = 7;
		player.leftHorn = 22;
		player.rightHorn = 22;
		if(actualRandomNumber > .5){
			player.bloodColor = "#416600"; //nope, allow for fishtroll nepetas.
			guardian.bloodColor = "#416600";
		}

		guardian.hair = 7;
		guardian.leftHorn = 22;
		guardian.rightHorn = 22;

	}

}

//can't control HOW the session will turn out, but can at least give it the right players.
function session613(){
	for(var i = 0; i<12;i++){
		var player;
		var guardian;
		if(i<curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian.quirk = randomTrollSim(guardian);
			player.quirk = randomTrollSim(player);
			//curSessionGlobalVar.guardians.push(guardian);
			curSessionGlobalVar.players.push(player);
			player.guardian = guardian;
			guardian.guardian = player;
		}
	}

	for(var i = 0; i<12;i++){
		player = curSessionGlobalVar.players[i];
		var guardian = player.guardian;
		player.isTroll = true;
		guardian.isTroll = true;
		player.relationships = [];
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players)
		guardian.generateRelationships(guardians);
		player.generateRelationships(curSessionGlobalVar.players);
		session612IndexToTrollAncestor(player, i);
		session612IndexToTroll(guardian, i);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}

//can't control HOW the session will turn out, but can at least give it the right players.
function session612(){
	for(var i = 0; i<12;i++){
		var player;
		var guardian;
		if(i<curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian.quirk = randomTrollSim(guardian);
			player.quirk = randomTrollSim(player);
			//curSessionGlobalVar.guardians.push(guardian);
			curSessionGlobalVar.players.push(player);
			player.guardian = guardian;
			guardian.guardian = player;
		}
	}

	for(var i = 0; i<12;i++){
		player = curSessionGlobalVar.players[i];
		var guardian = player.guardian;
		player.isTroll = true;
		guardian.isTroll = true;
		player.relationships = [];
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players)
		guardian.generateRelationships(guardians);
		player.generateRelationships(curSessionGlobalVar.players);
		session612IndexToTroll(player, i);
		session612IndexToTrollAncestor(guardian, i);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}
//["#A10000","#a25203","#a1a100","#658200","#416600","#078446","#008282","#004182","#0021cb","#631db4","#610061","#99004d"]
//karkat, terezi, gamzee, equius, aradia, nepeta, tavros, vriska, kanaya, eridan, feferi, sollux
function session612IndexToTroll(player, index){
	player.hairColor = "#000000"
	if(index == 0){
		player.aspect = "Blood"
		player.moon = "Prospit"
		player.bloodColor = "#ff0000"
		player.land = "Land of Pulse and Haze"
		player.class_name = "Knight"
		player.hair = 29;
		player.leftHorn = 21;
		player.rightHorn = 21;
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.kernel_sprite = "Crab"
		player.interest1 = "Romance"
		player.interest2 = "Leadership"
		player.chatHandle = "carcinoGeneticist"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 1){
		player.moon = "Prospit"
		player.aspect = "Mind"
		player.land = "Land of Thought and Flow"
		player.class_name = "Seer"
		player.hair = 10;
		player.leftHorn = 46;
		player.rightHorn = 46;
		player.bloodColor = "#008282";
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 4;
		player.quirk.lettersToReplace = [["E","3"],["I","1"],["A","4"]];
		player.kernel_sprite = "Dragon"
		player.interest1 = "Justice"
		player.interest2 = "Live Action Roleplaying"
		player.chatHandle = "gallowsCalibrator"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 2){
		player.moon = "Prospit"
		player.aspect = "Rage"
		player.land = "Land of Mirth and Tents"
		player.class_name = "Bard"
		player.hair = 41;
		player.leftHorn = 29;
		player.rightHorn = 29;
		player.bloodColor = "#631db4";
		player.quirk.capitalization = 4;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 10;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","motherfuck"]];
		player.kernel_sprite = "Seagoat"
		player.interest1 = "Clowns"
		player.interest2 = "Religion"
		player.chatHandle = "terminallyCapricious"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 3){
		player.moon = "Derse"
		player.land = "Land of Caves and Silence"
		player.aspect = "Void"
		player.class_name = "Heir"
		player.hair = 8;
		player.leftHorn = 43;
		player.rightHorn = 43;
		player.bloodColor = "#0021cb";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 6;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["x","%"],["fuck","fiddlesticks"]];
		player.quirk.prefix = "D -->"
		player.quirk.suffix = ""
		player.kernel_sprite = "Centaur"
		player.interest1 = "Racism"
		player.interest2 = "Weight Lifting"
		player.chatHandle = "centaursTesticle"

	}else if(index == 4){
		player.moon = "Derse"
		player.aspect = "Time"
		player.class_name = "Maid"
		player.land = "Land of Quartz and Melody"
		player.hair = 40;
		player.leftHorn = 36;
		player.rightHorn = 36;
		player.bloodColor = "#A10000";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["o","0"]];
		player.kernel_sprite = "Frog"
		player.interest1 = "Archaeology"
		player.interest2 = "Death"
		player.chatHandle = "apocalypseArisen"
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 5){
		player.moon = "Derse"
		player.aspect = "Heart"
		player.land = "Land of Little Cubes and Tea"
		player.class_name = "Rogue"
		player.hair = 7;
		player.leftHorn = 22;
		player.rightHorn = 22;
		player.bloodColor = "#416600";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 3;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ee","33"]];
		player.kernel_sprite = "Meowbeast"
		player.interest1 = "Role Playing"
		player.interest2 = "Romance"
		player.chatHandle = "arsenicCatnip"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 6){
		player.moon = "Prospit"
		player.aspect = "Breath"
		player.land = "Land of Sand and Zephyr"
		player.class_name = "Page"
		player.hair = 42;
		player.leftHorn = 28;
		player.rightHorn = 28;
		player.bloodColor = "#a25203";
		player.quirk.favoriteNumber = 1;
		player.quirk.capitalization = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","um"]];
		player.kernel_sprite = "Fairy Bull"
		player.interest1 = "Faeries"
		player.interest2 = "Animals"
		player.chatHandle = "adiosToreador"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 7){
		player.moon = "Prospit"
		player.land = "Land of Maps and Treasure"
		player.aspect = "Light"
		player.class_name = "Thief"
		player.hair = 14;
		player.leftHorn = 27;
		player.rightHorn = 27;
		player.bloodColor = "#004182";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 3;
		player.quirk.lettersToReplace = [];
		player.quirk.favoriteNumber = 8;
		player.quirk.lettersToReplaceIgnoreCase = [["b","8"]];
		player.interest1 = "Treasure"
		player.interest2 = "Live Action Roleplaying"
		player.kernel_sprite = "Spider"
		player.chatHandle = "arachnidsGrip"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
		player.godDestiny = true;
	}else if(index == 8){
		player.moon = "Prospit"
		player.land = "Land of Rays and Frogs"
		player.aspect = "Space"
		player.class_name = "Sylph"
		player.hair = 39;
		player.leftHorn = 26;
		player.rightHorn = 26;
		player.bloodColor = "#078446";
		player.quirk.capitalization = 3;
		player.quirk.favoriteNumber = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.kernel_sprite = "Mother Grub"
		player.interest1 = "Vampires"
		player.interest2 = "Fashion"
		player.chatHandle = "grimAuxiliatrix"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 9){
		player.moon = "Derse"
		player.land = "Land of Wrath and Angels"
		player.aspect = "Hope"
		player.class_name = "Prince"
		player.hair = 6;
		player.leftHorn = 19;
		player.rightHorn = 19;
		player.bloodColor = "#610061";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 7;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"], ["v","vv"], ["w","ww"]];
		player.kernel_sprite = "Skyhorse"
		player.interest1 = "Genocide"
		player.interest2 = "History"
		player.chatHandle = "caligulasAquarium"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 10){
		player.moon = "Derse"
		player.land = "Land of Dew and Glass"
		player.aspect = "Life"
		player.class_name = "Witch"
		player.hair = 19;
		player.leftHorn = 35;
		player.rightHorn = 35;
		player.bloodColor = "#99004d";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 9;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["h",")("],["e","-E"], ["fuck","glub"],  ["god","cod"]];
		player.kernel_sprite = "Horrorterror"
		player.interest1 = "Animals"
		player.interest2 = "Social Jusice"
		player.chatHandle = "cuttlefishCuller"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 11){
		player.moon = "Derse"//no way to have two dream selves righ tnow.
		player.land = "Land of Brains and Fire"
		player.aspect = "Doom"
		player.class_name = "Mage"
		player.hair = 2;
		player.leftHorn = 33;
		player.rightHorn = 33;
		player.bloodColor = "#a1a100";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["i","ii"],["s","2"]];
		player.kernel_sprite = "Bicyclops"
		player.interest1 = "Hacking"
		player.interest2 = "Programming"
		player.chatHandle = "twinArmageddons"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}
}

function session612IndexToTrollAncestor(player, index){
	player.hairColor = "#000000"
	if(index == 0){
		player.moon = "Prospit"
		player.aspect = "Blood"
		player.bloodColor = "#ff0000"
		player.land = "Land of Pulse and Haze"
		player.class_name = "Seer"
		player.hair = 44;
		player.leftHorn = 21;
		player.rightHorn = 21;
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["oo","69"], ["b","6"],["o","9"], ["fuck", "problematic"]];
		player.kernel_sprite = "Crab"
		player.interest1 = "Social Justice"
		player.interest2 = "Leadership"
		player.chatHandle = "carcinoGeneticist"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 1){
		player.moon = "Prospit"
		player.land = "Land of Thought and Flow"
		player.aspect = "Mind"
		player.class_name = "Knight"
		player.hair = 47;
		player.leftHorn = 46;
		player.rightHorn = 46;
		player.bloodColor = "#008282";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 4;
		player.quirk.lettersToReplace = [["e","3"],["i","1"],["a","4"],["for","4"],["four","4"],["fore","4"]["E","3"],["I","1"],["A","4"],["s\\b", "z"],["S\\b", "Z"]];
		player.kernel_sprite = "Dragon"
		player.interest1 = "Justice"
		player.interest2 = "Video Games"
		player.chatHandle = "gallowsCalibrator"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 2){
		player.moon = "Prospit"
		player.land = "Land of Mirth and Tents"
		player.aspect = "Rage"
		player.class_name = "Prince"
		player.hair = 45;
		player.leftHorn = 29;
		player.rightHorn = 29;
		player.bloodColor = "#631db4";
		player.quirk.capitalization = 4;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 10;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","motherfuck"]];
		player.kernel_sprite = "Seagoat"
		player.interest1 = "Death"
		player.interest2 = "Religion"
		player.chatHandle = "terminallyCapricious"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 3){
		player.moon = "Derse"
		player.aspect = "Void"
		player.land = "Land of Caves and Silence"
		player.class_name = "Page"
		player.hair = 53;
		player.leftHorn = 43;
		player.rightHorn = 43;
		player.bloodColor = "#0021cb";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 6;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["x","%"],["fuck","fiddlesticks"]];
		player.quirk.prefix = "8==D"
		player.quirk.suffix = ""
		player.kernel_sprite = "Centaur"
		player.interest1 = "Animals"
		player.interest2 = "Weight Lifting"
		player.chatHandle = "centaursTesticle"
	}else if(index == 4){
		player.moon = "Derse"
		player.aspect = "Time"
		player.class_name = "Witch"
		player.land = "Land of Quartz and Melody"
		player.hair = 50;
		player.leftHorn = 36;
		player.rightHorn = 36;
		player.bloodColor = "#A10000";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["o","0"]];
		player.kernel_sprite = "Frog"
		player.interest1 = "Intimidation"
		player.interest2 = "Death"
		player.chatHandle = "apocalypseArisen"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 5){
		player.aspect = "Heart"
		player.moon = "Derse"
		player.class_name = "Mage"
		player.land = "Land of Little Cubes and Tea"
		player.hair = 51;
		player.leftHorn = 22;
		player.rightHorn = 22;
		player.bloodColor = "#416600";
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 3;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ee","33"]];
		player.kernel_sprite = "Meowbeast"
		player.interest1 = "TV"
		player.interest2 = "Romance"
		player.chatHandle = "arsenicCatnip"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 6){
		player.aspect = "Breath"
		player.moon = "Prospit"
		player.land = "Land of Sand and Zephyr"
		player.class_name = "Rogue"
		player.hair = 1025;
		player.leftHorn = 28;
		player.rightHorn = 28;
		player.bloodColor = "#a25203";
		player.quirk.favoriteNumber = 1;
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["i","1"]];
		player.quirk.suffix = ""
		player.kernel_sprite = "Fairy Bull"
		player.interest1 = "Movies"
		player.interest2 = "Animals"
		player.chatHandle = "adiosToreador"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 7){
		player.aspect = "Light"
		player.moon = "Prospit"
		player.land = "Land of Maps and Treasure"
		player.class_name = "Sylph"
		player.hair = 52;
		player.leftHorn = 27;
		player.rightHorn = 27;
		player.bloodColor = "#004182";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.favoriteNumber = 8;
		player.quirk.lettersToReplaceIgnoreCase = [["b","8"]];
		player.interest1 = "Writing"
		player.interest2 = "Live Action Roleplaying"
		player.kernel_sprite = "Spider"
		player.chatHandle = "arachnidsGrip"
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 8){
		player.aspect = "Space"
		player.moon = "Prospit"
		player.land = "Land of Frost and Frogs"
		player.class_name = "Maid"
		player.hair = 55;
		player.leftHorn = 26;
		player.rightHorn = 26;
		player.bloodColor = "#078446";
		player.quirk.capitalization = 3;
		player.quirk.favoriteNumber = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["o","o+"]];
		player.kernel_sprite = "Mother Grub"
		player.interest1 = "Love"
		player.interest2 = "Fashion"
		player.chatHandle = "grimAuxiliatrix"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 9){
		player.aspect = "Hope"
		player.moon = "Derse"
		player.land = "Land of Wrath and Angels"
		player.class_name = "Bard"
		player.hair = 56;
		player.leftHorn = 19;
		player.rightHorn = 19;
		player.bloodColor = "#610061";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 1;
		player.quirk.favoriteNumber = 7;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"], ["v","vw"], ["w","wv"]];
		player.kernel_sprite = "Skyhorse"
		player.interest1 = "Romance"
		player.interest2 = "History"
		player.chatHandle = "caligulasAquarium"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 10){
		player.moon = "Derse"
		player.aspect = "Life"
		player.land = "Land of Dew and Glass"
		player.class_name = "Thief"
		player.hair = 57;
		player.leftHorn = 35;
		player.rightHorn = 35;
		player.bloodColor = "#99004d";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 9;
		player.quirk.lettersToReplace = [ ["H",")("],];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"],["e","-E"], ["fuck","glub"],  ["god","cod"]];
		player.kernel_sprite = "Horrorterror"
		player.interest1 = "Animals"
		player.interest2 = "Money"
		player.chatHandle = "cuttlefishCuller"
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 11){
		player.aspect = "Doom"
		player.moon = "Derse"
		player.land = "Land of Brains and Fire"
		player.class_name = "Heir"
		player.hair = 48;
		player.leftHorn = 33;
		player.rightHorn = 33;
		player.bloodColor = "#a1a100";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["i","ii"],["s","2"]];
		player.kernel_sprite = "Bicyclops"
		player.interest1 = "Video Games"
		player.interest2 = "Programming"
		player.chatHandle = "twinArmageddons"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}
}

//inversion of 413
function session1025(){
	for(var i = 0; i<12;i++){
		var player;
		var guardian;
		if(i<curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerWithClaspect("Page", "Void");
			guardian = randomPlayerWithClaspect("Page", "Void");
			guardian.quirk = randomTrollSim(guardian);
			player.quirk = randomTrollSim(player);
			//curSessionGlobalVar.guardians.push(guardian);
			player.guardian = guardian;
			guardian.guardian = player;
			curSessionGlobalVar.players.push(player);
		}
	}

	for(var i = 0; i<12;i++){
		player = curSessionGlobalVar.players[i];
		var guardian = player.guardian;
		if(i<8){
			player.isTroll = false;
			guardian.isTroll = false;
			session413IndexToHuman(player,i);
			session413IndexToAncestor(guardian,i);
		}else{
			player.isTroll = true;
			guardian.isTroll = true;
			var index = 0;
			if(i == 8){
				index = 0;
			}else if(i == 9){
				index = 8;
			}else if(i == 10){
				index = 1;
			}else if(i == 11){
				index = 7;
			}
			session612IndexToTroll(player, index);
			session612IndexToTroll(guardian, index);
		}
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players)
		guardian.generateRelationships(guardians);
		player.relationships = [];
		player.generateRelationships(curSessionGlobalVar.players);

		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}

}
