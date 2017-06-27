var simulationMode = false;
var debugMode = false;
var spriteWidth = 400;
var spriteHeight = 300;
var canvasWidth = 1000;
var canvasHeight = 300;
var repeatTime = 5;
var version2 = true; //even though idon't want  to render content, 2.0 is different from 1.0 (think of dialog that triggers)
var curSessionGlobalVar;
var charCreatorHelperGlobalVar;
var numURLS = 0;
var junior = false;
//have EVERYTHING be a scene, don't put any story in v2.0's controller
//every scene can update the narration, or the canvas.
//should there be only one canvas?  Can have player sprites be written to a virtual canvas first, then copied to main one.
//main canvas is either Leader + PesterChumWindow + 1 or more Players (in chat or group chat with leader)
//or Leader + 1 or more Players  (leader doing bullshit side quests with someone)
window.onload = function() {
	$(this).scrollTop(0);
	loadNavbar();
	//these bitches are SHAREABLE.
	if(getParameterByName("seed")){
		Math.seed = getParameterByName("seed");
		initial_seed = getParameterByName("seed");
	}else{
		var tmp = getRandomSeed();
		Math.seed = tmp;
		initial_seed = tmp;
	}
	initSession();
	charCreatorHelperGlobalVar = new CharacterCreatorHelper(curSessionGlobalVar.players);
	//shareableURL();
}

function allGods(){
	//alert("all gods (go to heaven)");
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		var player = curSessionGlobalVar.players[i];
		player.isDreamSelf = false;
		player.godTier = true;
	}
}

function allMortals(){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		var player = curSessionGlobalVar.players[i];
		player.isDreamSelf = false;
		player.godTier = false;
	}
}

function allDream(){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		var player = curSessionGlobalVar.players[i];
		player.isDreamSelf = true;
		player.godTier = false;
	}
}

function allCosmetic(murderMode, formerMurderMode, grimDark){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		var player = curSessionGlobalVar.players[i];
		player.murderMode = murderMode;
		player.leftMurderMode = formerMurderMode;
		if(grimDark){
			player.grimDark = 4;
		}else{
			player.grimDark = 0;
		}
	}
}

function updateRender(){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		var player = curSessionGlobalVar.players[i];
		charCreatorHelperGlobalVar.redrawSinglePlayer(player);
	}
}

function renderPlayersForEditing(){
	charCreatorHelperGlobalVar.drawAllPlayers();
	updateRender();
	$("#button").prop('disabled', false)
}

function initSession(){
	curSessionGlobalVar = new Session(initial_seed)
	reinit();
	createScenesForSession(curSessionGlobalVar);
	curSessionGlobalVar.makePlayers();
	curSessionGlobalVar.randomizeEntryOrder();
	curSessionGlobalVar.makeGuardians(); //after entry order established
	checkEasterEgg(easterEggCallBack);

}

function easterEggCallBack(){
	initializePlayers(curSessionGlobalVar.players); //will take care of overriding players if need be.
	 loadFuckingEverything(true);
}

function grabAllPlayerInterests(){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		grabPlayerInterests(curSessionGlobalVar.players[i]);
	}
}

function grabPlayerInterests(player){
	var interestCategory1Dom =  $("#interestCategory1" +player.id);
	var interestCategory2Dom =  $("#interestCategory2" +player.id);
	var interest1TextDom =  $("#interest1" +player.id);
	var interest2TextDom =  $("#interest2" +player.id);
	player.interest1 = interest1TextDom.val().replace(/<(?:.|\n)*?>/gm, '');;
	player.interest1Category = interestCategory1Dom.val();
	player.interest2 = interest2TextDom.val().replace(/<(?:.|,\n)*?>/gm, '');;;
	player.interest2Category = interestCategory2Dom.val();
}

function grabCustomChatHandleForPlayer(player){
	player.chatHandle = $("#chatHandle" +player.id).val().replace(/<(,?:.|\n)*?>/gm, '');
}

//among other things, having chat handles in plain text right in the url lets people know what to expect.
function grabCustomChatHandles(){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		grabCustomChatHandleForPlayer(curSessionGlobalVar.players[i]);
	}
}

//IMPORTANT, DON'T RENDER THIS onload
//instead, when player clicks "STart Session", render this button so they click it. OR, rerender this button any time you reredner players.
function renderURLToSendPlayersIntoSBURB(){
	grabAllPlayerInterests();
	grabCustomChatHandles();
	numURLS ++;
	var html = "<Br><br><a href = 'index2.html?seed=" + curSessionGlobalVar.session_id +"&" + generateURLParamsForPlayers(curSessionGlobalVar.players,true) + "' target='_blank'>Be Responsible For Sending Players into SBURB? (Link " + numURLS +")</a>";
	$("#character_creator").append(html);
}

function reinit(){
	available_classes = classes.slice(0);
	available_aspects = nonrequired_aspects.slice(0); //required_aspects
	available_aspects = available_aspects.concat(required_aspects.slice(0));

	curSessionGlobalVar.reinit();
}



function startSession(){
	$("#button").prop('disabled', true)
	var time = findAspectPlayer(curSessionGlobalVar.players, "Time");
	var space = findAspectPlayer(curSessionGlobalVar.players, "Space");
	if(time && space){
		initializePlayers(curSessionGlobalVar.players);
		initGraphs();
		//load everything i'll need for this session that iw asn't loading before (wings, godtier, etc.)
		load(curSessionGlobalVar.players, curSessionGlobalVar.guardians,false);
	}else{
		alert("Nope. Banned. You need to at least have Space and Time players to continue. ")
	}

}



function shareableURL(){
	var str = '<a href = "character_creator.html?seed=' +initial_seed +'">Shareable URL </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp <a href = "character_creator.html">Random Session URL </a> '
	$("#seedText").html(str);
}

function checkSGRUB(){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		if(curSessionGlobalVar.players[i].isTroll == false){
			return;
		}
	}
	//can only get here if all are trolls.
	$(document).attr("title", "SGRUB Story Generator Creator by jadedResearcher");
	$("#heading").html("SGRUB Story Generator Creator by jadedResearcher (art assistance by karmicRetribution) ");
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
	renderGraphs();
	//alert("scratch [possible]");
	//can't scratch if it was a a total party wipe. just a regular doomed timeline.
	var living = findLivingPlayers(session.players);
	if(living.length > 0 && (session.makeCombinedSession == false && session.hadCombinedSession == false)){
		var timePlayer = findAspectPlayer(session.players, "Time");
		if(!session.scratched){
			//this is apparently spoilery.
			//alert(living.length  + " living players and the " + timePlayer.land + " makes a scratch available!");
			var html = '<img src="images/Scratch.png" onclick="scratchConfirm()"><br>Click To Scratch Session?';
			$("#story").append(html);
		}else{
			$("#story").append("<br>This session is already scratched. No further scratches available.");
		}
	}
}

function scratchConfirm(){
	var scratchConfirmed = confirm("This session is doomed. Scratching this session will erase it. A new session will be generated, but you will no longer be able to view this session. Is this okay?");
	if(scratchConfirmed){
		scratch();
	}
}

function restartSession(){
	$("#story").html("");
	window.scrollTo(0, 0);
	debug("TODO: make players match created players.  maybe save copy of them. clone like i do for foreign players, keep in this controller?")
	initializePlayers(curSessionGlobalVar.players);
	intro();
}



//only do at last minute 'cause claspect can change.
function initGraphs(){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		var player = curSessionGlobalVar.players[i];
		var powerGraph = new Graph("power", player.title(), [], getColorFromAspect(player.aspect));
		var luckGraph1 = new Graph("minLuck", player.title(),[], getColorFromAspect(player.aspect));
		var luckGraph2 = new Graph("maxLuck", player.title(),[], getColorFromAspect(player.aspect));
		var triggerGraph = new Graph("sanity", player.title(),[], getColorFromAspect(player.aspect));
		var landLevelGraph = new Graph("landLevel", player.title(),[], getColorFromAspect(player.aspect));
		var friendGraph = new Graph("bestFriendLevel", player.title(),[], getColorFromAspect(player.aspect));
		var enemyGraph = new Graph("worstEnemyLevel", player.title(),[], getColorFromAspect(player.aspect));
		var freeWill = new Graph("freeWill", player.title(),[], getColorFromAspect(player.aspect));
		var mobility = new Graph("mobility", player.title(),[], getColorFromAspect(player.aspect));
		var hp = new Graph("hp", player.title(),[], getColorFromAspect(player.aspect));
		player.graphs.push(powerGraph);
		player.graphs.push(luckGraph1);
		player.graphs.push(luckGraph2);
		player.graphs.push(triggerGraph);
		player.graphs.push(landLevelGraph);
		player.graphs.push(enemyGraph);
		player.graphs.push(friendGraph);
		player.graphs.push(mobility);
		player.graphs.push(freeWill);
		player.graphs.push(hp);
	}
}

//can also graph best and worth relationships.
function renderGraphs(){
	var powerRenderer = new GraphRenderer("power",getAllGraphsForPlayersNamed(curSessionGlobalVar.players, "power"),1000,300);
	var luckRenderer1 = new GraphRenderer("minLuck",getAllGraphsForPlayersNamed(curSessionGlobalVar.players, "minLuck"),1000,300);
	var luckRenderer2 = new GraphRenderer("maxLuck",getAllGraphsForPlayersNamed(curSessionGlobalVar.players, "maxLuck"),1000,300);
	var triggerRenderer = new GraphRenderer("sanity",getAllGraphsForPlayersNamed(curSessionGlobalVar.players, "sanity"),1000,300);
	var landRenderer = new GraphRenderer("landLevel",getAllGraphsForPlayersNamed(curSessionGlobalVar.players, "landLevel"),1000,300);
	var friendRenderer = new GraphRenderer("bestFriendLevel",getAllGraphsForPlayersNamed(curSessionGlobalVar.players, "bestFriendLevel"),1000,300);
	var enemyRenderer = new GraphRenderer("worstEnemyLevel",getAllGraphsForPlayersNamed(curSessionGlobalVar.players, "worstEnemyLevel"),1000,300);
	var freeWill = new GraphRenderer("freeWill",getAllGraphsForPlayersNamed(curSessionGlobalVar.players, "freeWill"),1000,300);
	var mobility = new GraphRenderer("mobility",getAllGraphsForPlayersNamed(curSessionGlobalVar.players, "mobility"),1000,300);
	var hp = new GraphRenderer("hp",getAllGraphsForPlayersNamed(curSessionGlobalVar.players, "hp"),1000,300);
	powerRenderer.render();
	luckRenderer1.render();
	luckRenderer2.render();
	triggerRenderer.render();
	landRenderer.render();
	friendRenderer.render();
	enemyRenderer.render();
	freeWill.render();
	mobility.render();
	hp.render();
}

function updateGraphs(){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		var player = curSessionGlobalVar.players[i];
		getGraphWithLabel(player.graphs, "power").points.push(player.power);
		getGraphWithLabel(player.graphs, "minLuck").points.push(player.minLuck);
		getGraphWithLabel(player.graphs, "maxLuck").points.push(player.maxLuck);
		getGraphWithLabel(player.graphs, "sanity").points.push(player.sanity);
		getGraphWithLabel(player.graphs, "landLevel").points.push(player.landLevel);
		getGraphWithLabel(player.graphs, "bestFriendLevel").points.push(player.getHighestRelationshipValue());
		getGraphWithLabel(player.graphs, "worstEnemyLevel").points.push(player.getLowestRelationshipValue());
		getGraphWithLabel(player.graphs, "freeWill").points.push(player.freeWill);
		getGraphWithLabel(player.graphs, "mobility").points.push(player.mobility);
		getGraphWithLabel(player.graphs, "hp").points.push(player.hp);
		//console.log(player.mobility)
	}
}

function tick(){
	//console.log("Tick: " + curSessionGlobalVar.timeTillReckoning)
	if(curSessionGlobalVar.timeTillReckoning > 0 && !curSessionGlobalVar.doomedTimeline){
		updateGraphs();
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
	}
}

function reckoningTick(){
	//console.log("Reckoning Tick: " + curSessionGlobalVar.timeTillReckoning)
	if(curSessionGlobalVar.timeTillReckoning > -10){
		updateGraphs();
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
			renderGraphs();
		}
	}

}

function processCombinedSession(){
	var tmpcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();
	if(tmpcurSessionGlobalVar){
		curSessionGlobalVar = tmpcurSessionGlobalVar
		initGraphs();
		$("#story").append("<br><Br> But things aren't over, yet. The survivors manage to contact the players in the universe they created. Their sick frog may have screwed them over, but the connection it provides to their child universe will equally prove to be their salvation. Time has no meaning between universes, and they are given ample time to plan an escape from their own Game Over. They will travel to the new universe, and register as players there for session <a href = 'index2.html?seed=" + curSessionGlobalVar.session_id + "'>"+curSessionGlobalVar.session_id +"</a>. ");
		checkSGRUB();
		load(curSessionGlobalVar.players); //in loading.js
	}else{
		renderGraphs()
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
		updateGraphs();
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

function newPlayer(){
	var p = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
	curSessionGlobalVar.players.push(p);
	if(curSessionGlobalVar.players.length == 13) alert("Like, go ahead and all, but this is your Official Warning that the sim is optimized for no more than 12 player sessions.")
	charCreatorHelperGlobalVar.drawSinglePlayer(p);

}

function intro(){
	//in a big pile. draw all the charactesr as they look as they are entereing
	function createInitialSprites(){
		for(var i = 0; i<curSessionGlobalVar.players.length; i++){
			var player = curSessionGlobalVar.players[i];
			player.renderSelf();
		}

	}
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
