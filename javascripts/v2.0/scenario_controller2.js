var simulationMode = false;
var debugMode = false;
var spriteWidth = 400;
var spriteHeight = 300;
var canvasWidth = 1000;
var canvasHeight = 300;
var junior = false;

var repeatTime = 5;
var version2 = true; //even though idon't want  to render content, 2.0 is different from 1.0 (think of dialog that triggers)
var curSessionGlobalVar;

//have EVERYTHING be a scene, don't put any story in v2.0's controller
//every scene can update the narration, or the canvas.
//should there be only one canvas?  Can have player sprites be written to a virtual canvas first, then copied to main one.
//main canvas is either Leader + PesterChumWindow + 1 or more Players (in chat or group chat with leader)
//or Leader + 1 or more Players  (leader doing bullshit side quests with someone)
window.onload = function() {
	//these bitches are SHAREABLE.
	setTimeout(function() {window.scrollTo(0, 0);},1)
	loadNavbar();
	if(getParameterByName("seed")){
		Math.seed = getParameterByName("seed");
		initial_seed = getParameterByName("seed");
	}else{
		var tmp = getRandomSeed();
		Math.seed = tmp;
		initial_seed = tmp;
	}

	shareableURL();

	startSession();

	//intro();  //~~~~~~LOADING SCRIPT WILL CALL THIS~~~~~~~~~


	//debugRelationshipDrama();
	//debugTriggerLevel();
	//debugGrimDark();
	//debugJackScheme();
	//debugLevelTheHellUp();
	//debugGodTierLevelTheHellUp();
	//debugCorpseLevelTheHellUp();
	//debugGodTierRevive();
	//debugCorpseSmooch();
}

function reinit(){
	available_classes = classes.slice(0);
	available_aspects = nonrequired_aspects.slice(0); //required_aspects
	available_aspects = available_aspects.concat(required_aspects.slice(0));

	curSessionGlobalVar.reinit();
}


function startSession(){
	curSessionGlobalVar = new Session(initial_seed)
	reinit();
	createScenesForSession(curSessionGlobalVar);
	//initPlayersRandomness();
	curSessionGlobalVar.makePlayers();
	curSessionGlobalVar.randomizeEntryOrder();
	//authorMessage();
	curSessionGlobalVar.makeGuardians(); //after entry order established
	//easter egg ^_^
	if(getParameterByName("royalRumble")  == "true"){
		debugRoyalRumble();
	}

	if(getParameterByName("COOLK1D")  == "true"){
		cool_kid = true;
		coolK1DMode();
	}

	if(getParameterByName("lollipop")  == "true"){
		tricksterMode();
	}
	//void is in navbar code

	if(getParameterByName("robot")  == "true"){
		roboMode();
	}

	if(getParameterByName("sbajifier")  == "true"){
		sbahjMode();
	}

	if(getParameterByName("babyStuck")  == "true"){
		babyStuckMode();
	}
	checkEasterEgg();

	initializePlayers(curSessionGlobalVar.players); //will take care of overriding players if need be.
	checkSGRUB();

	load(curSessionGlobalVar.players, curSessionGlobalVar.guardians); //in loading.js
}






function shareableURL(){
	var str = '<div class = "links"><a href = "index2.html?seed=' +initial_seed +'">Shareable URL </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp <a href = "character_creator.html?seed=' +initial_seed +' " target="_blank">Replay Session (Mildly Fucking Alpha) </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp<a href = "index2.html">Random Session URL </a> </div>'
	$("#seedText").html(str);
}

function checkSGRUB(){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		if(curSessionGlobalVar.players[i].isTroll == false){
			return;
		}
	}
	//can only get here if all are trolls.
	$(document).attr("title", "SGRUB Story Generator by jadedResearcher");
	$("#heading").html("SGRUB Story Generator by jadedResearcher (art assistance by karmicRetribution) ");
}


function getSessionType(){
	if(sessionType > .6){
		return "Human"
	}else if(sessionType > .3){
		return "Troll"
	}
	return "Mixed"
}

function renderScratchButton(session){
	console.log("scratch possible, button");
	//alert("scratch [possible]");
	//can't scratch if it was a a total party wipe. just a regular doomed timeline.
	var living = findLivingPlayers(session.players);
	if(living.length > 0 && (session.makeCombinedSession == false && session.hadCombinedSession == false)){
		console.log("gonna render scratch")
		var timePlayer = findAspectPlayer(session.players, "Time");
		if(!session.scratched){
			//this is apparently spoilery.
			//alert(living.length  + " living players and the " + timePlayer.land + " makes a scratch available!");
			if(session.scratchAvailable){
				var html = '<img src="images/Scratch.png" onclick="scratchConfirm()"><br>Click To Scratch Session?';
				$("#story").append(html);
				renderAfterlifeURL();
			}
		}else{
			console.log("no more scratches")
			$("#story").append("<br>This session is already scratched. No further scratches available.");
			renderAfterlifeURL();
		}
	}else{
		console.log("what went wrong? is makecomo?" +session.makeCombinedSession + "is all dead: " + living.length + " is had combo? " +session.hadCombinedSession )
	}

}

function scratchConfirm(){
	var scratchConfirmed = confirm("This session is doomed. Scratching this session will erase it. A new session will be generated, but you will no longer be able to view this session. Is this okay?");
	if(scratchConfirmed){
		scratch();
	}
}

function restartSession(){
	$("#story").html('<canvas id="loading" width="1000" height="354"> ');
	window.scrollTo(0, 0);
	initializePlayers(curSessionGlobalVar.players); //initializePlayers
	intro();
}




function tick(){
	//console.log("Tick: " + curSessionGlobalVar.timeTillReckoning)
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
	//console.log('reckoning')
	var s = new Reckoning(curSessionGlobalVar);
	s.trigger(curSessionGlobalVar.players)
	s.renderContent(curSessionGlobalVar.newScene());
	if(!curSessionGlobalVar.doomedTimeline){
		reckoningTick();
	}else{
		renderAfterlifeURL();
	}
}

function reckoningTick(){
	//console.log("Reckoning Tick: " + curSessionGlobalVar.timeTillReckoning)
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
		if(curSessionGlobalVar.makeCombinedSession == true){
			processCombinedSession();  //make sure everything is done rendering first
		}else{
			renderAfterlifeURL();
		}
	}

}

function processCombinedSession(){
	var tmpcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();
	if(tmpcurSessionGlobalVar){
		curSessionGlobalVar = tmpcurSessionGlobalVar
		$("#story").append("<br><Br> But things aren't over, yet. The survivors manage to contact the players in the universe they created. Their sick frog may have screwed them over, but the connection it provides to their child universe will equally prove to be their salvation. Time has no meaning between universes, and they are given ample time to plan an escape from their own Game Over. They will travel to the new universe, and register as players there for session <a href = 'index2.html?seed=" + curSessionGlobalVar.session_id + "'>"+curSessionGlobalVar.session_id +"</a>. ");
		checkSGRUB();
		load(curSessionGlobalVar.players); //in loading.js
	}else{
		//scratch fuckers.
		curSessionGlobalVar.makeCombinedSession = false;  //can't make a combo session, and skiaia is a frog so no scratch.
		//renderScratchButton(curSessionGlobalVar);
	}

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


//in a big pile. draw all the charactesr as they look as they are entereing
function createInitialSprites(){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		var player = curSessionGlobalVar.players[i];
		player.renderSelf();
	}

}

function intro(){
	createInitialSprites();
	callNextIntroWithDelay(0);
}



function makeAuthorAvatar(){
	players[0].grimDark = false;
	players[0].aspect = "Mind"
	players[0].class_name = "Maid"
	players[0].hair = 13;
	players[0].hairColor = "#291200";
	players[0].quirk.punctuation = 3;
	players[0].quirk.capitalization = 1;
	players[0].quirk.favoriteNumber = 3;
	players[0].chatHandle = "jadedResearcher"
	players[0].isTroll = false
	players[0].bloodColor = "#ff0000"
	players[0].mylevels = ["INSTEAD","a CORPSE JUST RENDERS HERE","STILL CAN LEVEL UP.","OH, AND CORPSES.","SAME LEVELS","BUT STILL HAVE","IMAGE","THEY GET A DIFFERENT","BEFORE MAXING OUT","IF THEY GODTIER","AND GO UP THE LADDER","LEVELS NOW","16 PREDETERMINED","HAVE","PLAYERS","I FINISHED ECHELADDERS."];
}
