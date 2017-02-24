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
//have EVERYTHING be a scene, don't put any story in v2.0's controller
//every scene can update the narration, or the canvas. 
//should there be only one canvas?  Can have player sprites be written to a virtual canvas first, then copied to main one.
//main canvas is either Leader + PesterChumWindow + 1 or more Players (in chat or group chat with leader)
//or Leader + 1 or more Players  (leader doing bullshit side quests with someone)
window.onload = function() {
   init();
	//exileQueenInit();
	//murderModeInit();
	//voidLeaderInit();
	if(!debugMode){
		randomizeEntryOrder();
	}
	//authorMessage();
	intro();
	//make a new intro scene that has characters talk about their lands with their best friends/worst enemies. 
	//refacor other scenario controller to use special scenes (not part of scene controller) rather than
	//have messy internal methods.
	//all other scenes are handled through the scene controller like normal, which will check if var version2 = true;
	//and if so will call "render" rather than "content"
	debug("refactor old scenes to render themselves rather than return a string. If content() 1.0, if renderContent(), 2.0")
	debug("oh, and update quirks so that players have a quirk for every main class. and they ignore case");
	debug("Consider having ticks be a button press that clears the current story, rather than all at once. Only do this if too many canvases");
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

function intro(){
	introScene = new Intro();
	
	for(var i = 0; i<players.length; i++){
		var p = players[i];
		introScene.trigger(players, p)
		//$("#story").append(introScene.content());
		introScene.renderContent(newScene(),i); //new scenes take care of displaying on their own.
	}
	
}

function randomizeEntryOrder(){
	players = shuffle(players);
	players[0].leader = true;
}

function makeAuthorAvatar(){
	players[0].aspect = "Mind"
	players[0].class_name = "Maid"
	players[0].hair = 13;
	players[0].hairColor = "#291200";
	players[0].quirk.punctuation = 3;
	players[0].quirk.capitalization = 1;
	players[0].quirk.favoriteNumber = 3;
	players[0].chatHandle = "jadedResearcher"
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
	
	players[0].hairColor = "#331200"
	for(var j = 0; j<players.length; j++){
		players[j].generateRelationships(players);
		players[j].quirk = randomHumanSim();
	}
}