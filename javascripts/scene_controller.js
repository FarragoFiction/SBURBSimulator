//knows about all scene classes.

//gets called by the scenario_controller with a list of players in the medium.
//generates a list of scenes to happen 'now' with these players.
//not all players have to get a scene, and no player can have more than one scene.

//blood and page players most likely to get scenes with other people.
//blood players slightly improve all relationships a friend has when they see them.
var availablePlayers = [];  //which players are available for scenes or whatever.
var scenes = [new StartDemocracy(), new JackBeginScheming(), new KingPowerful(), new QueenRejectRing(), new JackPromotion(), new JackRampage(), new GiveJackBullshitWeapon()];
//relationship drama has a high priority because it can distract a session from actually making progress. happened to universe a trolls.
scenes = scenes.concat([new RelationshipDrama(), new BeTriggered(), new EngageMurderMode(), new GoGrimDark(), new MurderPlayers(), new DisengageMurderMode()]);
scenes = scenes.concat([new VoidyStuff(), new FaceDenizen(), new DoEctobiology(), new DoLandQuest()]);

scenes = scenes.concat([new SolvePuzzles(), new ExploreMoon()]);


scenes = scenes.concat([new LevelTheHellUp()]);

//make sure kiss, then godtier, then godtierrevival, then any other form of revival.
var deathScenes = [ new SaveDoomedTimeLine(), new CorpseSmooch(), new GetTiger(), new GodTierRevival()];  //are always available.
var reckoningScenes = [new FightQueen(), new FightKing()];

//scenes can add other scenes to available scene list. (for example, spy missions being added if Jack began scheming)
var available_scenes = []; //remove scenes from this if they get used up.
//make non shallow copy.
for(var i = 0; i<scenes.length; i++){
	available_scenes.push(scenes[i]);
}

//makes copy of player list (no shallow copies!!!!)
function setAvailablePlayers(playerList){
	availablePlayers = [];
	for(var i = 0; i<playerList.length; i++){
		//dead players are always unavailable.
		if(!playerList[i].dead){
			availablePlayers.push(playerList[i]);
		}
	}
	return availablePlayers;
}

//playerlist is everybody in the medium
//might not be all players in the begining.
function processReckoning(playerList){
	var ret = "";
	for(var i = 0; i<reckoningScenes.length; i++){
		var s = reckoningScenes[i];
		if(s.trigger(playerList)){
			//console.log(s);
			//console.log("was triggered");
			ret += s.content() + " <br><br> ";
		}
	}

	for(var i = 0; i<deathScenes.length; i++){
		var s = deathScenes[i];
		if(s.trigger(playerList)){
			ret += s.content() + " <br><br> ";
		}
	}

	return ret;
}

function processScenes2(playerList){
	var ret = "";
	setAvailablePlayers(playerList);
	for(var i = 0; i<available_scenes.length; i++){
		var s = available_scenes[i];
		//var debugQueen = queenStrength;
		if(s.trigger(playerList)){
			s.renderContent(newScene());
			if(!s.canRepeat){
				removeFromArray(s,available_scenes);
			}
		}
	}

	for(var i = 0; i<deathScenes.length; i++){
		var s = deathScenes[i];
		if(s.trigger(playerList)){
			s.renderContent(newScene());
		}
	}



	return ret;
}

//playerlist is everybody in the medium
//might not be all players in the begining.
//can't just add an "if 2.0" check, btw.
//need to have a pause between each scene to give time for rendering.
//gotta test method in scenario_controller2.js move here, modify
function processScenes(playerList){
	var ret = "";
	setAvailablePlayers(playerList);
	for(var i = 0; i<available_scenes.length; i++){
		var s = available_scenes[i];
		//var debugQueen = queenStrength;
		if(s.trigger(playerList)){

			//console.log("was triggered");
			var content = s.content()
			if(content != ""){
			ret += content + " <br><br> ";
			}else{
				"Debug: " + s;
			}
			//if(queenStrength != debugQueen){
				//console.log(s);
			//}
			if(!s.canRepeat){
				removeFromArray(s,available_scenes);
			}
		}
	}

	for(var i = 0; i<deathScenes.length; i++){
		var s = deathScenes[i];
		if(s.trigger(playerList)){
			//console.log(s);
			//console.log("was triggered");
			ret += s.content() + " <br><br> ";
		}
	}



	return ret;
}
