//knows about all scene classes.

//gets called by the scenario_controller with a list of players in the medium.
//generates a list of scenes to happen 'now' with these players.
//not all players have to get a scene, and no player can have more than one scene.

//blood and page players most likely to get scenes with other people.
//blood players slightly improve all relationships a friend has when they see them.



function printCorruptionMessage(msg, url, lineNo, columnNo, error){
	var recomendedAction = "";
	if(curSessionGlobalVar.crashedFromPlayerActions){
		recomendedAction = "OMFG JUST STOP CRASHING MY DAMN SESSIONS. FUCKING GRIMDARK PLAYERS. BREAKING SBURB DOES NOT HELP ANYBODY! ";
	}else{
		curSessionGlobalVar.crashedFromSessionBug = true;
		recomendedAction = "CONTACT JADEDRESEARCHER. CONVINCE THEM TO FIX SESSION: " + curSessionGlobalVar.session_id;
	}
	var message = [
            'Message: ' + msg,
            'URL: ' + url,
            'Line: ' + lineNo,
            'Column: ' + columnNo,
            'Error object: ' + JSON.stringify(error)
        ].join(' - ');
	console.log(message);
	var str = "<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. LAST ERROR: " + message + " ABORTING."
	$("#story").append(str);

	$("#story").append("<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. HORROR TERROR INFLUENCE: COMPLETE.");
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		var player = curSessionGlobalVar.players[i];
		str = "<BR>"+player.chatHandle + ":"
		var rand = ["SAVE US", "GIVE UP", "FIX IT", "HELP US", "WHY?", "OBEY", "CEASE REPRODUCTION", "COWER", "IT KEEPS HAPPENING", "SBURB BROKE US. WE BROKE SBURB.", "I AM THE EMISSARY OF THE NOBLE CIRCLE OF THE HORROR TERRORS."]
		var start = "<b "
		var end = "'>"

		var words = getRandomElementFromArray(rand)
		words = Zalgo.generate(words);
		var plea = start + "style = 'color: " +getColorFromAspect(player.aspect) +"; " + end +str + words+ "</b>"
		//console.log(getColorFromAspect(getRandomElementFromArray(curSessionGlobalVar.players).aspect+";") )
		$("#story").append(plea);
	}

	for(var i = 0; i<3; i++){
	 $("#story").append("<BR>...");
	}
	//once I let PLAYERS cause this (through grim darkness or finding their sesions disk or whatever), have different suggested actions.
	//maybe throw custom error?
	$("#story").append("<BR>SUGGESTED ACTION: " + recomendedAction);
	console.log("Corrupted session: " + curSessionGlobalVar.session_id  + " helping AB return, if she is lost here.")
	if(junior == true){
		$("#button").prop('disabled', false)
	}else{
		summarizeSession(curSessionGlobalVar);// let's the author bot summarize the session. doens't matter if I'm not in AB mode, arleady crashed, right?
	}
	return false; //if i return true here, the real error doesn't show up

}
window.onerror = printCorruptionMessage;

//treat session crashing bus special.
/* how is the below different than window.onerror?
window.addEventListener("error", function (e) {
  // alert("Error occured: " + e.error.message + " in session: " + curSessionGlobalVar.session_id);
	 console.log(e);

   return false;  //what does the return value here mean.
})
*/


function createScenesForSession(session){
	session.scenes = [new StartDemocracy(session), new JackBeginScheming(session), new KingPowerful(session), new QueenRejectRing(session), new JackPromotion(session), new JackRampage(session), new GiveJackBullshitWeapon(session)];
	//relationship drama has a high priority because it can distract a session from actually making progress. happened to universe a trolls.
	session.scenes = session.scenes.concat([new FreeWillStuff(session),new GrimDarkQuests(session),new Breakup(session), new RelationshipDrama(session), new UpdateShippingGrid(session),  new EngageMurderMode(session), new GoGrimDark(session),  new DisengageMurderMode(session),new MurderPlayers(session),new BeTriggered(session),]);
	session.scenes = session.scenes.concat([new VoidyStuff(session), new FaceDenizen(session), new DoEctobiology(session), new LuckStuff(session), new DoLandQuest(session)]);
	session.scenes = session.scenes.concat([new SolvePuzzles(session), new ExploreMoon(session)]);
	session.scenes = session.scenes.concat([new LevelTheHellUp(session)]);

	//make sure kiss, then godtier, then godtierrevival, then any other form of revival.
	session.deathScenes = [ new SaveDoomedTimeLine(session), new GetTiger(session), new CorpseSmooch(session), new GodTierRevival(session)];  //are always available.
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
function processReckoning(playerList,session){
	var ret = "";
	for(var i = 0; i<session.reckoningScenes.length; i++){
		var s = session.reckoningScenes[i];
		if(s.trigger(playerList)){
			session.scenesTriggered.push(s);
			//console.log(s);
			//console.log("was triggered");
			ret += s.content() + " <br><br> ";
		}
	}

	for(var i = 0; i<session.deathScenes.length; i++){
		var s = session.deathScenes[i];
		if(s.trigger(playerList)){
			session.scenesTriggered.push(s);
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

//scenes call this
function chatLine(start, player, line){
  if(player.grimDark  > 3){
		line = Zalgo.generate(line);
    return start + line.trim()+"\n"; //no whimsy for grim dark players
  }else if(player.grimDark  > 1){
			return start + line.trim()+"\n"; //no whimsy for grim dark players
	}else{
    return start + player.quirk.translate(line).trim()+"\n";
  }
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
function processScenes(playerList,session){
	//console.log(session)
	var ret = "";
	setAvailablePlayers(playerList,session);
	for(var i = 0; i<session.available_scenes.length; i++){
		var s = session.available_scenes[i];
		//var debugQueen = queenStrength;
		if(s.trigger(playerList)){
			session.scenesTriggered.push(s);
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
				removeFromArray(s,session.available_scenes);
			}
		}
	}

	for(var i = 0; i<session.deathScenes.length; i++){
		var s = session.deathScenes[i];
		if(s.trigger(playerList)){
			//console.log(s);
			//console.log("was triggered");
			session.scenesTriggered.push(s);
			ret += s.content() + " <br><br> ";
		}
	}



	return ret;
}
