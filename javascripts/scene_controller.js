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
		newsposts(""); //don't care what is happening.
		corruptRoboNewsposts("");
		renderAfterlifeURL();
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


function scratch(){
	console.log("scratch has been confirmed")
	var numPlayersPreScratch = curSessionGlobalVar.players.length;
	var ectoSave = curSessionGlobalVar.ectoBiologyStarted;

	reinit();
	curSessionGlobalVar.scratched = true;
	curSessionGlobalVar.scratchAvailable = false;
	curSessionGlobalVar.doomedTimeline = false;
	var raggedPlayers = findPlayersFromSessionWithId(curSessionGlobalVar.players, curSessionGlobalVar.session_id); //but only native
	//use seeds the same was as original session and also make DAMN sure the players/guardians are fresh.
	//hello to TheLertTheWorldNeeds, I loved your amazing bug report!  I will obviously respond to you in kind, but wanted
	//to leave a permanent little 'thank you' here as well. (and on the glitch page) I laughed, I cried, I realzied that fixing guardians
	//for easter egg sessions would be way easier than initially feared. Thanks a bajillion.
	//it's not as simple as remebering to do easter eggs here, but that's a good start. i also gotta
	//rework the easter egg guardian code. last time it worked guardians were an array a session had, but now they're owned by individual players.
	//plus, at the time i first re-enabled the easter egg, session 612 totally didn't have a scratch, so i could exactly test.
	curSessionGlobalVar.makePlayers();
	curSessionGlobalVar.randomizeEntryOrder();
	curSessionGlobalVar.makeGuardians(); //after entry order established
	checkEasterEgg();
	curSessionGlobalVar.ectoBiologyStarted = ectoSave; //if i didn't do ecto in first version, do in second
	if(curSessionGlobalVar.ectoBiologyStarted){ //players are reset except for haivng an ectobiological source
		setEctobiologicalSource(curSessionGlobalVar.players, curSessionGlobalVar.session_id);
	}
	curSessionGlobalVar.switchPlayersForScratch();
	var scratch = "The session has been scratched. The " + getPlayersTitlesBasic(getGuardiansForPlayers(curSessionGlobalVar.players)) + " will now be the beloved guardians.";
	scratch += " Their former guardians, the " + getPlayersTitlesBasic(curSessionGlobalVar.players) + " will now be the players.";
	scratch += " The new players will be given stat boosts to give them a better chance than the previous generation."

	var suddenDeath = findAspectPlayer(raggedPlayers, "Life");
	if( suddenDeath == null) suddenDeath = findAspectPlayer(raggedPlayers, "Doom");

	//NOT over time. literally sudden death. thanks meenah!
	if(suddenDeath && !suddenDeath.dead){
		console.log("sudden death in: " + curSessionGlobalVar.session_id)
		for(var i = 0; i<raggedPlayers.length; i++){
			raggedPlayers[i].makeDead("sudden death right as the scratch happened")
		}
		scratch += " It...appears that the " + suddenDeath.htmlTitleBasic() + " managed to figure out that killing everyone at the last minute would allow them to live on in the afterlife between sessions. They may be available as guides for the players. ";
	}
	if(curSessionGlobalVar.players.length != numPlayersPreScratch){
		scratch += " You are quite sure that players not native to this session have never been here at all. Quite frankly, you find the notion absurd. "
		console.log("forign players erased.")
	}
	scratch += " What will happen?"
	console.log("about to switch players")

	$("#story").html(scratch);
	if(!simulationMode) window.scrollTo(0, 0);

	var guardians  = raggedPlayers; //if i use guardians, they will be all fresh and squeaky. want the former players.
	var guardianDiv = curSessionGlobalVar.newScene();
	var guardianID = (guardianDiv.attr("id")) + "_guardians" ;
	var ch = canvasHeight;
	if(guardians.length > 6){
		ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
	}
	var canvasHTML = "<br><canvas id='canvas" + guardianID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";

	guardianDiv.append(canvasHTML);
	var canvasDiv = document.getElementById("canvas"+ guardianID);
	poseAsATeam(canvasDiv, guardians, 2000); //everybody, even corpses, pose as a team.


	var playerDiv = curSessionGlobalVar.newScene();
	var playerID = (playerDiv.attr("id")) + "_players" ;
	var ch = canvasHeight;
	if(curSessionGlobalVar.players.length > 6){
		ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
	}
	var canvasHTML = "<br><canvas id='canvas" + playerID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";

	playerDiv.append(canvasHTML);
	var canvasDiv = document.getElementById("canvas"+ playerID);
	poseAsATeam(canvasDiv, curSessionGlobalVar.players, 2000); //everybody, even corpses, pose as a team.

	intro();


}

function renderAfterlifeURL(){
	if(curSessionGlobalVar.afterLife.ghosts.length > 0){

		var html = "<Br><br><a href = 'rip.html?players=" + generateURLParamsForPlayers(curSessionGlobalVar.afterLife.ghosts) + "' target='_blank'>View Afterlife?</a>";
		//console.log("gonna append: " + html)
		$("#story").append(html);
	}else{
		console.log("no ghosts")
	}
}

//pair with seed for shareable url for character creator, or pair with nothing for afterlife viewer.
function generateURLParamsForPlayers(players){
	var ret = ""//up to caller to make players = ret
	var json = JSON.stringify(players, function(key,value){
		//console.log(key);
		if(key == "session" || key == "guardian" || key == "relationships" || key == "quirk"){  //TODO relationships are special case. figure it out. later.
			return null; //tutorial showed undefined here. how important is that?
		}else{
			return value;
		}
	});
	console.log(json)
	//otherwise won't escape single quotes, like in <font color = ''> stuff
	return encodeURI(ret+json, "UTF-8").replace(/'/g, "%27");
 }

 //TODO make this COMPLETELY WORK. probably enough to render the afterlife, but relationships are not brought over yet.
 function objToPlayer(obj){
	 var ret = new Player();
	 for (var prop in obj) ret[prop] = obj[prop];
	 return ret;
 }
