var players = [];
var frogStatus = 0;
var kingStrength = 100; //can use this to extrapolate enemy strength.
var queenStrength = 100;
var jackStrength = 50;
var hardStrength = 250;  //what consititutes a  'hard' game.
var democracyStrength = 0;
var queenUncrowned = false;  //if she loses her ring, she doesn't get stronger with further prototypes
var reckoningStarted = false; //can't god tier if you are definitely on skaia.
var ectoBiologyStarted = false;
var doomedTimeline = false;
var debugMode = false;
var introScene;
var currentSceneNum = 0;
var spriteWidth = 400;
var spriteHeight = 300;
var canvasWidth = 1000;
var canvasHeight = 300;
var version2 = true;
var timeTillReckoning = getRandomInt(10,30);
//have EVERYTHING be a scene, don't put any story in v2.0's controller
//every scene can update the narration, or the canvas.
//should there be only one canvas?  Can have player sprites be written to a virtual canvas first, then copied to main one.
//main canvas is either Leader + PesterChumWindow + 1 or more Players (in chat or group chat with leader)
//or Leader + 1 or more Players  (leader doing bullshit side quests with someone)
window.onload = function() {
	debug("okay, need a scene for the reckoning. and ways to call final battles,and then aftermath (mourning etc)");
   init();
	//exileQueenInit();
	//murderModeInit();
	//voidLeaderInit();
	if(!debugMode){
		randomizeEntryOrder();
	}
	//authorMessage();
	intro();
	//debugRelationshipDrama();
	//debugTriggerLevel();
	//debugGrimDark();
	//debugJackScheme();
	//debugLevelTheHellUp();
	//debugGodTierLevelTheHellUp();
	//debugCorpseLevelTheHellUp();
	//debugGodTierRevive();
	//debugCorpseSmooch();

	//make a new intro scene that has characters talk about their lands with their best friends/worst enemies.
	//refacor other scenario controller to use special scenes (not part of scene controller) rather than
	//have messy internal methods.
	//all other scenes are handled through the scene controller like normal, which will check if var version2 = true;
	//and if so will call "render" rather than "content"
	debug("consider keeping track of async tasks in array. if too many at a time, put new async tasks in second array, only activate and add to first array when it is empty enough");

	debug("relationship text. reckoning");
	//tick();  dont tick here, tick after intro
}

function tick(){
	if(timeTillReckoning > 0){
		setTimeout(function(){
			timeTillReckoning += -1;
			processScenes2(players);
			tick();
		},availablePlayers.length * 1000);
	}else{

		reckoning();
	}
}

function reckoning(){
	var s = new Reckoning();
	s.trigger(players)
	s.renderContent(newScene());
	
	reckoningTick();
}

function reckoningTick(){
	if(timeTillReckoning > -10){
		setTimeout(function(){
			timeTillReckoning += -1;
			processReckoning(players)
			reckoning();
		},1000);
	}else{

		debug("Handle Ending. Mourning, universe, etc.")
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

function newScene(){
	currentSceneNum ++;
	var div = "<div id='scene"+currentSceneNum+"'></div>";
	$("#story").append(div);
	return $("#scene"+currentSceneNum);
}

function authorMessage(){
	makeAuthorAvatar();
	introScene = new AuthorMessage();
	introScene.trigger(players, players[0])
	introScene.renderContent(newScene(),0); //new scenes take care of displaying on their own.
}

function callNextIntroWithDelay(player_index){
	if(player_index >= players.length){
    tick();//NOW start ticking
		return;
	}
	setTimeout(function(){
		var s = new Intro();
		var p = players[player_index];
		var playersInMedium = players.slice(0, player_index+1); //anybody past me isn't in the medium, yet.
		s.trigger(players, p)
		s.renderContent(newScene(),player_index); //new scenes take care of displaying on their own.
		processScenes2(playersInMedium);
		player_index += 1;
		callNextIntroWithDelay(player_index)
  		}, player_index * 1000);  //want all players to be done with their setTimeOuts players.length*1000+2000
}


function intro(){
  //delay is needed here because this is when images are first loaded.
	callNextIntroWithDelay(0);
  /* //
	introScene = new Intro();

	for(var i = 0; i<players.length; i++){
		var playersInMedium = players.slice(0, i+1); //anybody past me isn't in the medium, yet.
		var p = players[i];
		introScene.trigger(players, p)
		//$("#story").append(introScene.content());
		introScene.renderContent(newScene(),i); //new scenes take care of displaying on their own.
		processScenes2(playersInMedium);
	}*/

}

function randomizeEntryOrder(){
	players = shuffle(players);
	players[0].leader = true;
}

function makeAuthorAvatar(){
	players[0].grimDark = false;
	players[0].aspect = "Mind"
	players[0].class_name = "Maid"
	players[0].hair = 13;
	players[0].hairColor = "#291200";
	players[0].quirk.punctuation = 3;
	players[0].quirk.capitalization = 5;
	players[0].quirk.favoriteNumber = 3;
	players[0].chatHandle = "jadedResearcher"
	players[0].isTroll = false
	players[0].bloodColor = "#ff0000"
	players[0].mylevels = ["INSTEAD","a CORPSE JUST RENDERS HERE","STILL CAN LEVEL UP.","OH, AND CORPSES.","SAME LEVELS","BUT STILL HAVE","IMAGE","THEY GET A DIFFERENT","BEFORE MAXING OUT","IF THEY GODTIER","AND GO UP THE LADDER","LEVELS NOW","16 PREDETERMINED","HAVE","PLAYERS","I FINISHED ECHELADDERS."];
}

function decideHemoCaste(player){
	if(player.aspect != "Blood"){  //sorry karkat
		player.bloodColor = getRandomElementFromArray(bloodColors);
	}
}

function decideLusus(player){
	if(player.bloodColor == "#610061" || player.bloodColor == "#99004d" || players.bloodColor == "#631db4" ){
		player.lusus = getRandomElementFromArray(seaLususTypes);
	}else{
		player.lusus = getRandomElementFromArray(landlususTypes);
	}
}

function decideTroll(player){
	if(Math.random() > 0.75 ){
		player.isTroll = true;
		player.triggerLevel ++;//trolls are less stable
		decideHemoCaste(player);
		decideLusus(player);
		player.kernel_sprite = player.lusus;
	}
}

function init(){
	available_classes = classes; //re-init available classes.
	available_aspects = nonrequired_aspects;
	var numPlayers = getRandomInt(2,12);
	players.push(randomSpacePlayer());
	players.push(randomTimePlayer());

	for(var i = 2; i<numPlayers; i++){
		players.push(randomPlayer());
	}

	for(var j = 0; j<players.length; j++){
		var p = players[j];
		decideTroll(p);
		p.generateRelationships(players);
		if(p.isTroll){
			p.quirk = randomTrollSim()
		}else{
			p.quirk = randomHumanSim();
		}
	}
}
