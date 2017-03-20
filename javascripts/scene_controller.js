//knows about all scene classes.

//gets called by the scenario_controller with a list of players in the medium.
//generates a list of scenes to happen 'now' with these players.
//not all players have to get a scene, and no player can have more than one scene.

//blood and page players most likely to get scenes with other people.
//blood players slightly improve all relationships a friend has when they see them.




function createScenesForSession(session){
	session.scenes = [new StartDemocracy(session), new JackBeginScheming(session), new KingPowerful(session), new QueenRejectRing(session), new JackPromotion(session), new JackRampage(session), new GiveJackBullshitWeapon(session)];
	//relationship drama has a high priority because it can distract a session from actually making progress. happened to universe a trolls.
	session.scenes = session.scenes.concat([new RelationshipDrama(session), new BeTriggered(session), new EngageMurderMode(session), new GoGrimDark(session),  new DisengageMurderMode(session),new MurderPlayers(session)]);
	session.scenes = session.scenes.concat([new VoidyStuff(session), new FaceDenizen(session), new DoEctobiology(session), new DoLandQuest(session)]);
	session.scenes = session.scenes.concat([new SolvePuzzles(session), new ExploreMoon(session)]);
	session.scenes = session.scenes.concat([new LevelTheHellUp(session)]);

	//make sure kiss, then godtier, then godtierrevival, then any other form of revival.
	session.deathScenes = [ new SaveDoomedTimeLine(session), new CorpseSmooch(session), new GetTiger(session), new GodTierRevival(session)];  //are always available.
	session.reckoningScenes = [new FightQueen(session), new FightKing(session)];

	//scenes can add other scenes to available scene list. (for example, spy missions being added if Jack began scheming)
	session.available_scenes = []; //remove scenes from this if they get used up.
	//make non shallow copy.
	for(var i = 0; i<session.scenes.length; i++){
		session.available_scenes.push(session.scenes[i]);
	}
}

//makes copy of player list (no shallow copies!!!!)
function setAvailablePlayers(playerList,session){
	session.availablePlayers = [];
	for(var i = 0; i<playerList.length; i++){
		//dead players are always unavailable.
		if(!playerList[i].dead){
			session.availablePlayers.push(playerList[i]);
		}
	}
	return session.availablePlayers;
}

//playerlist is everybody in the medium
//might not be all players in the begining.
function processReckoning(playerList){
	var ret = "";
	for(var i = 0; i<reckoningScenes.length; i++){
		var s = reckoningScenes[i];
		if(s.trigger(playerList)){
			scenesTriggered.push(s);
			//console.log(s);
			//console.log("was triggered");
			ret += s.content() + " <br><br> ";
		}
	}

	for(var i = 0; i<deathScenes.length; i++){
		var s = deathScenes[i];
		if(s.trigger(playerList)){
			scenesTriggered.push(s);
			ret += s.content() + " <br><br> ";
		}
	}

	return ret;
}

function processScenes2(playerList,session){
	//console.log("processing scene");
	//$("#story").append("processing scene");
	var ret = "";
	setAvailablePlayers(playerList,session);
	for(var i = 0; i<session.available_scenes.length; i++){
		var s = session.available_scenes[i];
		//var debugQueen = queenStrength;
		if(s.trigger(playerList)){
			session.scenesTriggered.push(s);
			s.renderContent(session.newScene());
			if(!s.canRepeat){
				removeFromArray(s,session.available_scenes);
			}
		}
	}

	for(var i = 0; i<session.deathScenes.length; i++){
		var s = session.deathScenes[i];
		if(s.trigger(playerList)){
			session.scenesTriggered.push(s);
			s.renderContent(session.newScene());
		}
	}


	return ret;
}

//playerlist is everybody in the medium
//might not be all players in the begining.
function processReckoning2(playerList,session){
	var ret = "";
	for(var i = 0; i<session.reckoningScenes.length; i++){
		var s = session.reckoningScenes[i];
		if(s.trigger(playerList)){
			session.scenesTriggered.push(s);
			s.renderContent(session.newScene());
		}
	}

	for(var i = 0; i<session.deathScenes.length; i++){
		var s = session.deathScenes[i];
		if(s.trigger(playerList)){
			session.scenesTriggered.push(s);
			s.renderContent(session.newScene());
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
			scenesTriggered.push(s);
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
			scenesTriggered.push(s);
			ret += s.content() + " <br><br> ";
		}
	}



	return ret;
}
