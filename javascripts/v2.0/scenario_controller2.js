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
var canvasWidth = 800;
var canvasHeight = 300;
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
	intro();
	debug("Consider having ticks be a button press that clears the current story, rather than all at once. Only do this if too many canvases");
}

function newScene(){
	currentSceneNum ++;
	var div = "<div id='scene"+currentSceneNum+"'></div>";
	$("#story").append(div);
	return $("#scene"+currentSceneNum);
}

function intro(){
	introScene = new Intro();
	
	for(var i = 0; i<players.length; i++){
		var p = players[i];
		if(i==0){
			p.leader = true;
		}
		introScene.trigger(players, p)
		//$("#story").append(introScene.content());
		introScene.content(newScene(),i); //new scenes take care of displaying on their own.
	}
	
}

function randomizeEntryOrder(){
	players = shuffle(players);
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
		players[j].generateRelationships(players);
	}
}