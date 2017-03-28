//looking for rare sessions  not rendering.
//I just realized that AuthorBot was technically born in a lab!!!
//Okay, like, not in a MEANINGFUL way, but they were replacing the carpet in the regular area so i had to work out of the lab instead.
//and before you worry, YES I work on this at my day job. But, like, I'm explicitly allowed to do "mad science" learning projects
//during downtime (as long as i don't make money off it), it helps keep my skillz (yes with a 'z') sharp.  90% of the tech i work with 
//proffesionally was first learned this way. go me.
//this whole bucket of spiders was intended to be a way for me to solidify my understanding of javascript arrays and debugging.
//and let me tell you for free: I am the goddamn master of javascript debugging at this point. at least compared to past me.
//have you seen some of the other things I've done? Nothing as complicated as this (or as Homestuck as this.)
//http://purplefrog.com/~jenny/
//that's a list of all the javascript projects i've done over the years. i've done plenty of non javascript shit, too, but, well, not as easily shareable.
//I think: http://purplefrog.com/~jenny/PheremoneMaze/Worlds/story_pheremone.html
//is particularly related to SBURB SIM.  AI simulation tied into a story engine.
//but the "I" in AI was stronger over there. It was a dead simple genetic algorithm of creatures living in a world filled with plants and predators.
//their 'DNA' was literally just the directions they would move over their life. but they would evolve, and it was neat to watch.
//the 'voice' of the narratator is shamelessly inspired by the game Bastion, so that tells you how old that sim is. 20-goddamned-11.  That's 6 years old now. damn.

//bob warned me about global variables. he told me, dog.
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
var sessionSummariesDisplayed = [];

var numSimulationsDone = 0;
var numSimulationsToDo = 52;
var quipMode = false;


window.onload = function() {
	if(quipMode == true){
			robotMode();
			return;
	}
	percentBullshit();

	if(getParameterByName("seed")){
		Math.seed = getParameterByName("seed");
		initial_seed = getParameterByName("seed");
	}else{
		var tmp = getRandomSeed();
		Math.seed = tmp;
		initial_seed = tmp;
	}
	formInit();
	//startSession();
}

//want the AuthorBot to actually be browsing sessions when bored, like she claims to be.
function robotMode(){
	numSimulationsToDo = 1;
	startSession();
}

function checkSessions(){
	numSimulationsDone = 0; //but don't reset stats
	$("#story").html("")
	//$("#debug").html("");
	//$("#stats").html("");
	numSimulationsToDo = parseInt($("#num_sessions").val())
	$("#button").prop('disabled', true)
	startSession();
}

function formInit(){
	$("#button").prop('disabled', false)
	$("#num_sessions_text").val($("#num_sessions").val());
	$("#num_sessions").change(function(){
			$("#num_sessions_text").val($("#num_sessions").val());
	});
}

function startSession(){
	$("#story").html("")
	curSessionGlobalVar = new Session(initial_seed)
	reinit();
	createScenesForSession(curSessionGlobalVar);
	//initPlayersRandomness();
	curSessionGlobalVar.makePlayers();
	curSessionGlobalVar.randomizeEntryOrder();
	curSessionGlobalVar.makeGuardians(); //after entry order established
	if(simulationMode == true){
		intro();
	}else{
		load(curSessionGlobalVar.players, curSessionGlobalVar.guardians); //in loading.js
	}
}

function restartSession(){
	$("#story").html("");
	window.scrollTo(0, 0);
	intro();
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
	if(session.ectoBiologyStarted == false){
		//summarizeSession(session);
	}
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
	curSessionGlobalVar.reinit();
}

//TODO if i wanted to, I could have mixed sessions like in canon.
//not erasing the players, after all.
//or could have an afterlife where they meet guardian players???
function scratch(){
	var savedEB = curSessionGlobalVar.ectoBiologyStarted;
	reinit();
	curSessionGlobalVar.ectoBiologyStarted = savedEB;  //if didn't do ecto in previous session, do here. else, don't
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
	}else{
		//console.log("doomed timeline prevents reckoning")
		summarizeSession(curSessionGlobalVar);
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
			//console.log("going to summarize: " + curSessionGlobalVar.session_id)
			summarizeSession(curSessionGlobalVar);
		}


	}

}

function processCombinedSession(){
	initial_seed = Math.seed;
	var newcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();
	if(newcurSessionGlobalVar){
		timesComboSession ++;
		curSessionGlobalVar = newcurSessionGlobalVar;
		$("#story").append("<br><Br> But things aren't over, yet. The survivors manage to contact the players in the universe they created. Time has no meaning between universes, and they are given ample time to plan an escape from their own Game Over. They will travel to the new universe, and register as players there for session " + curSessionGlobalVar.session_id + ". ");
		intro();
	}else{
		summarizeSession(curSessionGlobalVar);
	}

}



function summarizeSession(session){
	//console.log("summarizing: " + curSessionGlobalVar.session_id)
	//don't summarize the same session multiple times. can happen if scratch happens in reckoning, both point here.
	if(sessionsSimulated.indexOf(session.session_id) != -1){
		//console.log("should be skipping a repeat session: " + curSessionGlobalVar.session_id)

		//return;
	}
	sessionsSimulated.push(curSessionGlobalVar.session_id);
	$("#story").html("");
	var str = curSessionGlobalVar.summarize();
	checkDoomedTimelines();
	debug("<br><hr><font color = 'red'> AB: " + getQuipAboutSession(curSessionGlobalVar) + "</font><Br>" );
	debug(str);

	numSimulationsDone ++;
	if(getParameterByName("robot")){
		printStatsRobot();
	}else{
		printStats();
}
	if(numSimulationsDone >= numSimulationsToDo){
		$("#button").prop('disabled', false)
		if(!getParameterByName("robot")){
			alert("Notice: should be ready to check more sessions.")
		}
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

//don't use a seed here
function percentBullshit(){
	var pr = 90+Math.random()*10; //this is not consuming randomness. what to do?
	$("#percentBullshit").html(pr+"%")
}

function getQuipAboutSession(session){
	var quip = "";
	var living = findLivingPlayers(session.players);
	var dead = findDeadPlayers(session.players)
	var strongest = findStrongestPlayer(session.players)
	var spacePlayer = findAspectPlayer(session.players, "Space");
	if(living.length == 0){
		quip += "Shit, you do not even want to KNOW how everybody died." ;
	}else  if(strongest.power > 3000){
		quip += "Holy Shit, do you SEE the " + strongest.titleBasic() + "!?  How even strong ARE they?" ;
	}else if(spacePlayer.landLevel < session.minFrogLevel ){
		quip += "Man, why is it always the frogs? " ;
		if(session.parentSession){
			quip += " You'd think what with it being a combo session, they would have gotten the frog figured out. "
		}
	}else  if(session.parentSession){
		quip += "Combo sessions are always so cool." ;
	}else  if(session.jackStrength > 200){
		quip += "Jack REALLY gave them trouble." ;
	}else if(dead.length == 0 && spacePlayer.landLevel > session.goodFrogLevel ){
		quip += "Everything went better than expected." ;
	}else  if(session.scenesTriggered.length > 200){
		quip += "God, this session just would not END." ;
		if(!session.parentSession){
			quip += " It didn't even have the excuse of being a combo session. "
		}
	}else  if(session.murdersHappened == true){
		quip += "It always sucks when the players start trying to kill each other." ;
	}else  if(session.scenesTriggered.length < 50){
		quip += "Holy shit, were they even in the session an entire hour?" ;
	}else  if(session.scratchAvailable == true){
		quip += "Maybe the scratch would fix things? I can't be bothered to check." ;
	}else{
		quip += "It was slightly less boring than calculating pi." ;
	}
	return quip;
}

//this doesn't actually work like i'd hoped.
//javascript only evaluated in browsr, not http get. should have realized
function printStatsRobot(){
	//$(document.body).empty();
	//console.log("Hello?  Oh. Good. I was afraid wiping the page would take me out, too.")
	//console.log("Now, which session should I entertain myself with today?")
	var json = "{session_id:" + curSessionGlobalVar.session_id + ", "
	json += "quip: " + getQuipAboutSession(curSessionGlobalVar);
	json +=  "}";
	return json;
	//$(document.body).append(json);
}

function foundRareSession(div, debugMessage){
	console.log(debugMessage)
	var canvasHTML = "<br><canvas id='canvasJRAB" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
	div.append(canvasHTML);

	var canvasDiv = document.getElementById("canvasJRAB"+  (div.attr("id")));
	var chat = "";
  chat += "AB: Just thought I'd let you know: " + debugMessage +"\n";
	chat += "JR: *gasp* You found it! Thanks! You are the best!!!\n";
	var quips1 = ["It's why you made me.", "It's not like I have a better use for my flawless mecha-brain.", "Just doing as programmed."];
	chat += "AB: " + getRandomElementFromArrayNoSeed(quips1)+"\n" ;
	chat += "JR: And THAT is why you are the best.\n "
	var quips2 = ["Seriously, isn't it a little narcissistic for you to like me so much?", "I don't get it, you know more than anyone how very little 'I' is in my A.I.", "Why did you go to all the effort to make debugging look like this?"];
	chat += "AB: " + getRandomElementFromArrayNoSeed(quips2)+"\n";
	chat += "JR: Dude, A.I.s are just awesome. Even simple ones. And yeah...being proud of you is a weird roundabout way of being proud of my own achievements.\n";
  var quips3 = ["Won't this be confusing to people who aren't you?", "What if you forget to disable these before deploying to the server?", "Doesn't this risk being visible to people who aren't you?"];
  chat += "AB: " + getRandomElementFromArrayNoSeed(quips3)+"\n";
	chat += "JR: Heh, I'll do my best to turn these debug messages off before deploying, but if I forget, I figure it counts as a highly indulgent author-self insert x2 combo. \n"
  chat += "JR: Oh! And I'm really careful to make sure these little chats don't actually influence the session in any way.\n"
	chat += "JR: Like maybe one day you or I can have a 'yellow yard' type interference scheme. But today is not that day."
	drawChatABJR(canvasDiv, chat);
}

function printStats(){

	var str = " <h2> Stats for all Checked Sessions</h2>"
	str += "<br>Number Sessions: " + sessionsSimulated.length;
	//timesScratchesAvailable
	str += "<br> Average Frog Level: " + Math.round(totalFrogLevel/sessionsSimulated.length);
	str+= "<Br>Times Frogs Full: " + timesFullFrog+ " (" + Math.round((timesFullFrog/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Frogs Sick: " + timesSickFrog+ " (" + Math.round((timesSickFrog/sessionsSimulated.length)*100) + "%)";;
	str += "<br>Times No Frog: " + timesNoFrog+ " (" + Math.round((timesNoFrog/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Scratches Available: " + timesScratchesAvailable + " (" + Math.round((timesScratchesAvailable/sessionsSimulated.length)*100) + "%)";
	str += "<Br>Times Combo Session Possible: " + timesComboSession + " (" + Math.round((timesComboSession/sessionsSimulated.length)*100) + "%)";
	//timesGroundHog
	str +=  "<Br>Times Yellow Yard Available: " + timesGroundHog + " (" + Math.round((timesGroundHog/sessionsSimulated.length)*100) + "%)";
	str +="<Br>Times Total Party Wipe: " + timesTotalPartyWipe + " (" + Math.round((timesTotalPartyWipe/sessionsSimulated.length)*100) + "%)";
	str += "<Br>Times Ectobiology: " + timesEcto + " (" + Math.round((timesEcto/sessionsSimulated.length)*100) + "%)";

	str += "<Br>Times GrimDark (at least one player): " + timesGrimDark + " (" + Math.round((timesGrimDark/sessionsSimulated.length)*100) + "%)";

	str += "<Br>Times MurderMode (at least one player): " + timesMurderMode + " (" + Math.round((timesMurderMode/sessionsSimulated.length)*100) + "%)";
	str += "<Br>Times Diamonds (at least one player): " + timesDiamonds + " (" + Math.round((timesDiamonds/sessionsSimulated.length)*100) + "%)";
	str += "<Br>Times Clubs (at least one player): " + timesClubs + " (" + Math.round((timesClubs/sessionsSimulated.length)*100) + "%)";

	str += "<Br>Times Fought Denizen (at least once): " + timesDenizen + " (" + Math.round((timesDenizen/sessionsSimulated.length)*100) + "%)";

	str += "<Br>Times Exiled Jack: " + timesExileJack + " (" + Math.round((timesExileJack/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Planned To Exile Jack: " + timesPlanExileJack + " (" + Math.round((timesPlanExileJack/sessionsSimulated.length)*100) + "%)";;

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
	$("#stats").html(str);
}



function checkDoomedTimelines(){
	//console.log("check")
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
