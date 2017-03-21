//looking for rare sessions or doing moon prophecies. not rendering.
var simulationMode = true;
var debugMode = false;
var spriteWidth = 400;
var spriteHeight = 300;
var canvasWidth = 1000;
var canvasHeight = 300;
var repeatTime = 5;
var version2 = true; //even though idon't want  to render content, 2.0 is different from 1.0 (think of dialog that triggers)


var sessionObjects = []
var curSessionGlobalVar;
var sessionsSimulated = []
var timesEcto = 0;
var timesDenizen = 0;
var timesExileJack = 0;
var timesPlanExileJack = 0;
var timesExileQueen = 0;
var timesJackWeapon = 0;
var timesJackScheme = 0;
var timesJackRampage = 0;
var timesJackPromotion = 0;
var timesKingPowerful = 0;
var timesQueenRejectRing = 0;
var timesSavedDoomedTimeLine = 0;
var timesInterestingSaveDoomedTimeLine = 0;
var timesDemocracyStart = 0;
var timesScratchesAvailable =0;
var timesSickFrog = 0;
var timesNoFrog  = 0;
var timesFullFrog = 0;
var timesGrimDark = 0;
var timesMurderMode = 0;
var timesComboSession = 0;
var totalFrogLevel = 0;

var numSimulationsDone = 0;
var numSimulationsToDo = 2;

//have EVERYTHING be a scene, don't put any story in v2.0's controller
//every scene can update the narration, or the canvas.
//should there be only one canvas?  Can have player sprites be written to a virtual canvas first, then copied to main one.
//main canvas is either Leader + PesterChumWindow + 1 or more Players (in chat or group chat with leader)
//or Leader + 1 or more Players  (leader doing bullshit side quests with someone)
window.onload = function() {
	//these bitches are SHAREABLE.
	
	debug("Problem: generating wrong session to be child session for combo session. Session 2022 should make a child of 206577 (and is in index2.html) but is 163241. wrong wrong wrong.");
	debug("Ah, timeout was the problem. for some reason?")
	debug("log how often total party wipe happens")
	debug("test combo session: 212740")

	debug("heart/spade close scenes just like clubs/diamonds")
	debug("This is a list of sessions, where each session is a child of the previous session (even if it never got to make them)")
	if(getParameterByName("seed")){
		Math.seed = getParameterByName("seed");
		initial_seed = getParameterByName("seed");
	}else{
		var tmp = getRandomSeed();
		Math.seed = tmp;
		initial_seed = tmp;
	}
	startSession();
}

function startSession(){
	curSessionGlobalVar = new Session(initial_seed)
	createScenesForSession(curSessionGlobalVar);
	reinit();
	//initPlayersRandomness();
	curSessionGlobalVar.makePlayers();
	curSessionGlobalVar.randomizeEntryOrder();
	//authorMessage();
	curSessionGlobalVar.makeGuardians(); //after entry order established
	//checkSGRUB();
	if(simulationMode == true){
		intro();
	}else{
		load(curSessionGlobalVar.players, curSessionGlobalVar.guardians); //in loading.js
	}
}


function getParameterByName(name, url) {
    if (!url) {
      url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function shareableURL(){
	var str = '<a href = "index2.html?seed=' +initial_seed +'">Shareable URL </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp <a href = "index2.html">Random Session URL </a> '
	$("#seedText").html(str);
}



function renderScratchButton(session){
	timesScratchesAvailable ++;
}

function scratchConfirm(){
	var scratchConfirmed = confirm("This session is doomed. Scratching this session will erase it. A new session will be generated, but you will no longer be able to view this session. Is this okay?");
	if(scratchConfirmed){
		scratch();
	}
}

function reinit(){
	available_classes = classes.slice(0);
	available_aspects = nonrequired_aspects.slice(0); //required_aspects
	available_aspects = available_aspects.concat(required_aspects.slice(0));
	curSessionGlobalVar.available_scenes = curSessionGlobalVar.scenes.slice(0);  //was forgetting to reset this, so scratched players had less to do.
}

//TODO if i wanted to, I could have mixed sessions like in canon.
//not erasing the players, after all.
//or could have an afterlife where they meet guardian players???
function scratch(){
	reinit();
	curSessionGlobalVar.scratched = true;
	var scratch = "The session has been scratched. The " + getPlayersTitlesBasic(curSessionGlobalVar.players) + " will now be the beloved guardians.";
	scratch += " Their former guardians, the " + getPlayersTitlesBasic(curSessionGlobalVar.guardians) + " will now be the players.";
	scratch += " The new players will be given stat boosts to give them a better chance than the previous generation."
	scratch += " What will happen?"
	var tmp = curSessionGlobalVar.players;
	curSessionGlobalVar.players = guardians;
	curSessionGlobalVar.guardians = tmp;
	$("#story").html(scratch);
	window.scrollTo(0, 0);


	var guardianDiv = newScene();
	var guardianID = (guardianDiv.attr("id")) + "_guardians" ;
	var ch = canvasHeight;
	if(guardians.length > 6){
		ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
	}
	var canvasHTML = "<br><canvas id='canvas" + guardianID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";

	guardianDiv.append(canvasHTML);
	var canvasDiv = document.getElementById("canvas"+ guardianID);
	poseAsATeam(canvasDiv, curSessionGlobalVar.guardians, 2000); //everybody, even corpses, pose as a team.


	var playerDiv = newScene();
	var playerID = (playerDiv.attr("id")) + "_players" ;
	var ch = canvasHeight;
	if(players.length > 6){
		ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
	}
	var canvasHTML = "<br><canvas id='canvas" + playerID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";

	playerDiv.append(canvasHTML);
	var canvasDiv = document.getElementById("canvas"+ playerID);
	poseAsATeam(canvasDiv, curSessionGlobalVar.players, 2000); //everybody, even corpses, pose as a team.

	intro();

}

function tick(){
	if(curSessionGlobalVar.timeTillReckoning > 0 && !curSessionGlobalVar.doomedTimeline){
		setTimeout(function(){
			curSessionGlobalVar.timeTillReckoning += -1;
			processScenes2(curSessionGlobalVar.players,curSessionGlobalVar);
			tick();
		},repeatTime); //or availablePlayers.length * *1000?
	}else{

		reckoning();
	}
}

function reckoning(){
	var s = new Reckoning(curSessionGlobalVar);
	s.trigger(curSessionGlobalVar.players)
	s.renderContent(curSessionGlobalVar.newScene());
	if(!curSessionGlobalVar.doomedTimeline){
		reckoningTick();
	}
}

function reckoningTick(){
	if(curSessionGlobalVar.timeTillReckoning > -10){
		setTimeout(function(){
			curSessionGlobalVar.timeTillReckoning += -1;
			processReckoning2(curSessionGlobalVar.players,curSessionGlobalVar)
			reckoningTick();
		},repeatTime);
	}else{
		var s = new Aftermath(curSessionGlobalVar);
		s.trigger(curSessionGlobalVar.players)
		s.renderContent(curSessionGlobalVar.newScene());
		
		
		//summarizeSession(curSessionGlobalVar);
		//for some reason whether or not a combo session is available isn't working? or combo isn't working right in this mode?
		if(curSessionGlobalVar.makeCombinedSession == true){
			processCombinedSession();  //make sure everything is done rendering first
		}else{
			summarizeSession(curSessionGlobalVar);
		}
		
		
	}

}

function processCombinedSession(){
	initial_seed = Math.seed;
	var newcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();
	if(newcurSessionGlobalVar){
		console.log("combosession")
		timesComboSession ++;
		curSessionGlobalVar = newcurSessionGlobalVar;
		console.log(curSessionGlobalVar.players)
		$("#story").append("<br><Br> But things aren't over, yet. The survivors manage to contact the players in the universe they created. Time has no meaning between universes, and they are given ample time to plan an escape from their own Game Over. They will travel to the new universe, and register as players there for session " + curSessionGlobalVar.session_id + ". ");
		intro();
	}else{
		summarizeSession(curSessionGlobalVar);
	}

}



function summarizeSession(session){
	//don't summarize the same session multiple times. can happen if scratch happens in reckoning, both point here.
	if(sessionsSimulated.indexOf(session.session_id) != -1){
		//console.log("skipping a repeat session: " + curSessionGlobalVar.session_id)
		return;
	}
	sessionsSimulated.push(curSessionGlobalVar.session_id);
	$("#story").html("");
	var str = curSessionGlobalVar.summarize();
	checkDoomedTimelines();
	debug(str);

	numSimulationsDone ++;
	if(numSimulationsDone >= numSimulationsToDo){
		printStats();
		alert("should be done")
		return;
	}else{
		setTimeout(function(){
			//var tmp = getRandomSeed();
			//Math.seed = tmp;
			//doomedTimelineReasons = []
			initial_seed = Math.seed; //child session
			startSession();
		},repeatTime*2); //since ticks are on time out, one might hit right as this is called, don't want that, cause causes players to be dead or godtier at start of next session
	}
}


/*var timesEcto = 0;
var timesDenizen = 0;
var timesExileJack = 0;
var timesExileQueen = 0;
var timesJackWeapon = 0;
var timesJackScheme = 0;
var timesJackRampage = 0;
var timesJackPromotion = 0;
var timesKingPowerful = 0;
var timesQueenRejectRing = 0;
var timesSavedDoomedTimeLine = 0;
var timesInterestingSaveDoomedTimeLine = 0;
var timesDemocracyStart = 0;*/
function printStats(){
	var str = "<br>Number Sessions: " + sessionsSimulated.length;
	//timesScratchesAvailable
	str += "<br> Average Frog Level: " + totalFrogLevel/sessionsSimulated.length;
	str+= "<Br>Times Frogs Full: " + timesFullFrog+ " (" + Math.round((timesFullFrog/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Frogs Sick: " + timesSickFrog+ " (" + Math.round((timesSickFrog/sessionsSimulated.length)*100) + "%)";;
	str += "<br>Times No Frog: " + timesNoFrog+ " (" + Math.round((timesNoFrog/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Scratches Available: " + timesScratchesAvailable + " (" + Math.round((timesScratchesAvailable/sessionsSimulated.length)*100) + "%)";
		str += "<Br>Times Combo Session Possible: " + timesComboSession + " (" + Math.round((timesComboSession/sessionsSimulated.length)*100) + "%)";
	str += "<Br>Times Ectobiology: " + timesEcto + " (" + Math.round((timesEcto/sessionsSimulated.length)*100) + "%)";

	str += "<Br>Times GrimDark (at least one player): " + timesGrimDark + " (" + Math.round((timesGrimDark/sessionsSimulated.length)*100) + "%)";

	str += "<Br>Times MurderMode (at least one player): " + timesMurderMode + " (" + Math.round((timesMurderMode/sessionsSimulated.length)*100) + "%)";

	str += "<Br>Times Fought Denizen (at least once): " + timesDenizen + " (" + Math.round((timesDenizen/sessionsSimulated.length)*100) + "%)";

	str += "<Br>Times Exiled Jack: " + timesExileJack + " (" + Math.round((timesExileJack/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Planned To Exiled Jack: " + timesPlanExileJack + " (" + Math.round((timesPlanExileJack/sessionsSimulated.length)*100) + "%)";;

	str += "<Br>Times Exiled Queen: " + timesExileQueen+ " (" + Math.round((timesExileQueen/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Jack Got a Bullshit Weapon: " + timesJackWeapon+ " (" + Math.round((timesJackWeapon/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Jack Schemed: " + timesJackScheme+ " (" + Math.round((timesJackScheme/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Jack Rampaged: " + timesJackRampage+ " (" + Math.round((timesJackRampage/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Jack Promoted: " + timesJackPromotion+ " (" + Math.round((timesJackPromotion/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times King Powerful: " + timesKingPowerful+ " (" + Math.round((timesKingPowerful/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Queen Rejected Ring: " + timesQueenRejectRing+ " (" + Math.round((timesQueenRejectRing/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Doomed Timelines: " + timesSavedDoomedTimeLine+ " (" + Math.round((timesSavedDoomedTimeLine/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Interesting Doomed Timelines: " + timesInterestingSaveDoomedTimeLine+ " (" + Math.round((timesInterestingSaveDoomedTimeLine/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Democracy Side Quest Activated: " + timesDemocracyStart+ " (" + Math.round((timesDemocracyStart/sessionsSimulated.length)*100) + "%)";;
	$("#stats").append(str);
}



function checkDoomedTimelines(){
	for(var i= 0; i<curSessionGlobalVar.doomedTimelineReasons.length; i ++){
		timesSavedDoomedTimeLine ++;
		if(curSessionGlobalVar.doomedTimelineReasons[i] != "Shenanigans"){
			//alert("found an interesting doomed timeline" + doomedTimelineReasons[i])
			timesInterestingSaveDoomedTimeLine ++;
			return;
		}
	}
	if(curSessionGlobalVar.doomedTimelineReasons.length > 1){
		timesSavedDoomedTimeLine ++;
	}
}



//scenes call this
function chatLine(start, player, line){
  if(player.grimDark == true){
    return start + line.trim()+"\n"; //no whimsy for grim dark players
  }else{
    return start + player.quirk.translate(line).trim()+"\n";
  }
}



function authorMessage(){
	makeAuthorAvatar();
	introScene = new AuthorMessage(curSessionGlobalVar);
	introScene.trigger(players, players[0])
	introScene.renderContent(newScene(),0); //new scenes take care of displaying on their own.
}

function callNextIntroWithDelay(player_index){
	if(player_index >= curSessionGlobalVar.players.length){
		tick();//NOW start ticking
		return;
	}
	setTimeout(function(){
		var s = new Intro(curSessionGlobalVar);
		var p = curSessionGlobalVar.players[player_index];
		var playersInMedium = curSessionGlobalVar.players.slice(0, player_index+1); //anybody past me isn't in the medium, yet.
		s.trigger(playersInMedium, p)
		s.renderContent(curSessionGlobalVar.newScene(),player_index); //new scenes take care of displaying on their own.
		processScenes2(playersInMedium,curSessionGlobalVar);
		player_index += 1;
		callNextIntroWithDelay(player_index)
	},  repeatTime);  //want all players to be done with their setTimeOuts players.length*1000+2000
}


function intro(){
	callNextIntroWithDelay(0);
}
