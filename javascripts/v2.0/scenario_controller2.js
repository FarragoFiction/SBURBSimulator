var players = [];
var guardians = [];
//looking for rare sessions or doing moon prophecies. not rendering.
var simulationMode = false;
var frogStatus = 0;
var kingStrength = 100; //can use this to extrapolate enemy strength.
var queenStrength = 100;
var jackStrength = 50;
var hardStrength = 275;  //what consititutes a  'hard' game.
var democracyStrength = 0;
var queenUncrowned = false;  //if she loses her ring, she doesn't get stronger with further prototypes
var reckoningStarted = false; //can't god tier if you are definitely on skaia.
var ectoBiologyStarted = false;
var doomedTimeline = false;
var scratched = false;
var debugMode = false;
var introScene;
var currentSceneNum = 0;
var spriteWidth = 400;
var spriteHeight = 300;
var canvasWidth = 1000;
var canvasHeight = 300;
var repeatTime = 500;
var version2 = true;
var timeTillReckoning = 0; //these will be wrong if seed is set
var sessionType = -413; //human, troll or mixed.
//have EVERYTHING be a scene, don't put any story in v2.0's controller
//every scene can update the narration, or the canvas.
//should there be only one canvas?  Can have player sprites be written to a virtual canvas first, then copied to main one.
//main canvas is either Leader + PesterChumWindow + 1 or more Players (in chat or group chat with leader)
//or Leader + 1 or more Players  (leader doing bullshit side quests with someone)
window.onload = function() {
	//these bitches are SHAREABLE.
	if(getParameterByName("seed")){
		Math.seed = getParameterByName("seed");
		initial_seed = getParameterByName("seed");
	}else{
		var tmp = getRandomSeed();
		Math.seed = tmp;
		initial_seed = tmp;
	}

	initRandomness();
	shareableURL();

    init();

	if(!debugMode){
		randomizeEntryOrder();
	}


	//easter egg ^_^
	if(getParameterByName("royalRumble")  == "true"){
		debugRoyalRumble();
	}
	//authorMessage();
	makeGuardians(); //after entry order established
	//i cannot resist
	if(initial_seed == 413){
		session413();
	}else if(initial_seed == 612){
		session612();
	}else if(initial_seed == 1025){
		session1025()
	}else if(initial_seed == 33){
		session33();
	}
	checkSGRUB();
	load(players, guardians); //in loading.js

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

function initRandomness(){
	timeTillReckoning = getRandomInt(10,30);
    sessionType = Math.seededRandom(); //human, troll or mixed.
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

function checkSGRUB(){
	for(var i = 0; i<players.length; i++){
		if(players[i].isTroll == false){
			return;
		}
	}
	//can only get here if all are trolls.
	$(document).attr("title", "SGRUB Story Generator 2.0 by jadedResearcher");
	$("#heading").html("SGRUB Story Generator 2.0 by jadedResearcher (art assistance by karmicRetribution) ");

}
function getSessionType(){
	if(sessionType > .6){
		return "Human"
	}else if(sessionType > .3){
		return "Troll"
	}
	return "Mixed"
}

function renderScratchButton(){
	//alert("scratch [possible]");
	//can't scratch if it was a a total party wipe. just a regular doomed timeline.
	var living = findLivingPlayers(players);
	if(living.length > 0){
		var timePlayer = findAspectPlayer(players, "Time");
		if(!scratched){
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

//TODO if i wanted to, I could have mixed sessions like in canon.
//not erasing the players, after all.
//or could have an afterlife where they meet guardian players???
function scratch(){
	available_scenes = scenes;  //was forgetting to reset this, so scratched players had less to do.
	timeTillReckoning = getRandomInt(10,30);
	frogStatus = 0;
	kingStrength = 100; //can use this to extrapolate enemy strength.
	queenStrength = 100;
	jackStrength = 50;
	hardStrength = 250;  //what consititutes a  'hard' game.
	democracyStrength = 0;
	queenUncrowned = false;  //if she loses her ring, she doesn't get stronger with further prototypes
	reckoningStarted = false; //can't god tier if you are definitely on skaia.
	//ectobiology not reset. if performed in previous session, it's done.
	//if not, it's not. like how the alpha session trolls didn't perform ectobiology, so Karkat did.
	doomedTimeline = false;
	scratched = true;
	var scratch = "The session has been scratched. The " + getPlayersTitlesBasic(players) + " will now be the beloved guardians.";
	scratch += " Their former guardians, the " + getPlayersTitlesBasic(guardians) + " will now be the players.";
	scratch += " The new players will be given stat boosts to give them a better chance than the previous generation."
	scratch += " What will happen?"
	var tmp = players;
	players = guardians;
	guardians = tmp;
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
	poseAsATeam(canvasDiv, guardians, 2000); //everybody, even corpses, pose as a team.


	var playerDiv = newScene();
	var playerID = (playerDiv.attr("id")) + "_players" ;
	var ch = canvasHeight;
	if(players.length > 6){
		ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
	}
	var canvasHTML = "<br><canvas id='canvas" + playerID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";

	playerDiv.append(canvasHTML);
	var canvasDiv = document.getElementById("canvas"+ playerID);
	poseAsATeam(canvasDiv, players, 2000); //everybody, even corpses, pose as a team.

	intro();

}

function tick(){
	if(timeTillReckoning > 0 && !doomedTimeline){
		setTimeout(function(){
			timeTillReckoning += -1;
			processScenes2(players);
			tick();
		},repeatTime); //or availablePlayers.length * *1000?
	}else{

		reckoning();
	}
}

function reckoning(){
	var s = new Reckoning();
	s.trigger(players)
	s.renderContent(newScene());
	if(!doomedTimeline){
		reckoningTick();
	}
}

function reckoningTick(){
	if(timeTillReckoning > -10){
		setTimeout(function(){
			timeTillReckoning += -1;
			processReckoning2(players)
			reckoningTick();
		},repeatTime);
	}else{
		var s = new Aftermath();
		s.trigger(players)
		s.renderContent(newScene());
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
		s.trigger(playersInMedium, p)
		s.renderContent(newScene(),player_index); //new scenes take care of displaying on their own.
		processScenes2(playersInMedium);
		player_index += 1;
		callNextIntroWithDelay(player_index)
	},  repeatTime);  //want all players to be done with their setTimeOuts players.length*1000+2000
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

function session413(){
	for(var i = 0; i<8;i++){
		var player;
		var guardian;
		if(i<players.length){
			player = players[i];
		}else{
			player = randomPlayerWithClaspect("Page", "Void");
			guardian = randomPlayerWithClaspect("Page", "Void");
			guardian.quirk = randomHumanSim(guardian);
			player.quirk = randomHumanSim(player);
			guardians.push(guardian);
			players.push(player);
		}
	}

	for(var i = 0; i<8;i++){
		player = players[i];
		var guardian = guardians[i]
		player.isTroll = false;
		guardian.isTroll = false;
		guardian.generateBlandRelationships(guardians);
		player.generateBlandRelationships(players);
		session413IndexToHuman(player, i);
		session413IndexToAncestor(guardian, i);//just call regular with a different index
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}

function session413IndexToHuman(player,index){
	if(index == 0){
		player.bloodColor = "#ff0000"
		player.class_name = "Heir"
		player.godDestiny = true;
		player.aspect = "Breath"
		player.hair  =3;
		player.hairColor = "#000000"
		player.chatHandle = "ectoBiologist"
		player.interest1 = "Pranks"
		player.interest2 = "Action Movies"
		player.kernel_sprite = "Clown"
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 1;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["lol","hehehe"]];
		player.land = "Land of Wind and Shade"
		player.moon = "Prospit"
	}else if(index == 1){
		player.moon = "Derse"
		player.bloodColor = "#ff0000"
		player.godDestiny = true;
		player.class_name = "Seer"
		player.land = "Land of Light and Rain"
		player.aspect = "Light"
		player.chatHandle = "tentacleTherapist"
		player.interest1 = "Writing"
		player.interest2 = "Horrorterrors"
		player.hair  =20;
		player.hairColor = "#fff3bd"
		player.kernel_sprite = "Cat"
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 1;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["hey","greetings"],["yes", "certainly"]];
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 2){
		player.moon = "Derse"
		player.bloodColor = "#ff0000"
		player.class_name = "Knight"
		player.land = "Land of Heat and Clockwork"
		player.aspect = "Time"
		player.hairColor = "#feffd7"
		player.hair  =22;
		player.chatHandle = "turntechGodhead"
		player.interest1 = "Rap"
		player.interest2 = "Irony"
		player.kernel_sprite = "Puppet"
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["hey","sup"]];
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 3){
		player.moon = "Prospit"
		player.bloodColor = "#ff0000"
		player.class_name = "Witch"
		player.land = "Land of Frost and Frogs"
		player.aspect = "Space"
		player.hair  =9;
		player.hairColor = "#3f1904"
		player.chatHandle = "gardenGnostic"
		player.interest1 = "Physics"
		player.interest2 = "Gardening"
		player.kernel_sprite = "First Guardian"
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 3;
		player.favoriteNumber = 5;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 4){
		player.moon = "Prospit"
		player.bloodColor = "#ff0000"
		player.class_name = "Maid"
		player.godDestiny = true;
		player.aspect = "Life"
		player.land = "Land of Crypts and Helium"
		player.hair  =5;
		player.hairColor = "#000000"
		player.chatHandle = "gutsyGumshoe"
		player.interest1 = "Pranks"
		player.interest2 = "Baking"
		player.kernel_sprite = "Mistake"
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["lol","hoo hoo"]];
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 5){
		player.moon = "Derse"
		player.bloodColor = "#ff0000"
		player.class_name = "Rogue"
		player.land = "Land of Pyramids and Neon"
		player.aspect = "Void"
		player.hair  =24;
		player.hairColor = "#fff3bd"
		player.chatHandle = "tipsyGnostalgic"
		player.interest1 = "Writing"
		player.interest2 = "Wizards"
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["like","liek"], ["school","skool"]];
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
		player.kernel_sprite = "Troll"
	}else if(index == 6){
		player.moon = "Derse"
		player.bloodColor = "#ff0000"
		player.class_name = "Prince"
		player.land = "Land of Tombs and Krypton"
		player.aspect = "Heart"
		player.hair  =17;
		player.hairColor = "#feffd7"
		player.chatHandle = "timaeusTestified"
		player.interest1 = "Irony"
		player.interest2 = "Robots"
		player.kernel_sprite = "Robot Horse Weirdo"
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["hey","sup"]];
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""

	}else if(index == 7){
		player.moon = "Prospit"
		player.bloodColor = "#ff0000"
		player.class_name = "Page"
		player.land = "Land of Mounds and Xenon"
		player.aspect = "Hope"
		player.hair  =30;
		player.hairColor = "#3f1904"
		player.chatHandle = "golgothasTerror"
		player.interest1 = "Physics"
		player.interest2 = "Movies"
		player.kernel_sprite = "Buddy"
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 1;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["lol","good one"]];
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}

}

//just hange index and return whatever regular does. pretend janes goes in first
function session413IndexToAncestor(player,index){
	if(index == 0){
		session413IndexToHuman(player, 4)
	}else if(index == 1){
		session413IndexToHuman(player, 5)
	}else if(index == 2){
		session413IndexToHuman(player, 6)
	}else if(index == 3){
		session413IndexToHuman(player, 7)
	}else if(index == 4){
		session413IndexToHuman(player, 0)
	}else if(index == 5){
		session413IndexToHuman(player, 1)
	}else if(index == 6){
		session413IndexToHuman(player, 2)
	}else if(index == 7){
		session413IndexToHuman(player, 3)
	}
}

//12 dead nepetas
function session33(){
	for(var i = 0; i<12;i++){
		var player;
		var guardian;
		if(i<players.length){
			player = players[i];
		}else{
			guardian = randomPlayerWithClaspect("Rogue", "Heart");
			player = randomPlayerWithClaspect("Rogue", "Heart");
			player.quirk = randomTrollSim(player);
			guardian.quirk = randomTrollSim(player);
			players.push(player);
			guardians.push(guardian);
		}
		session612IndexToTroll(player, i);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}

	for(var i = 0; i<12;i++){
		player = players[i];
		guardian = guardians[i]
		player.isTroll = true;
		guardian.isTroll = true;
		player.generateRelationships(players);
		guardian.generateRelationships(guardians);
		if(player.aspect != "Time" && player.aspect != "Space"){
			player.aspect = "Heart"
			player.class_name = "Rogue"
		}
		if(guardian.aspect != "Time" && guardian.aspect != "Space"){
			guardian.aspect = "Heart"
			guardian.class_name = "Rogue"
		}
		player.hair = 7;
		player.leftHorn = 22;
		player.rightHorn = 22;
		player.bloodColor = "#416600";

		guardian.hair = 7;
		guardian.leftHorn = 22;
		guardian.rightHorn = 22;
		guardian.bloodColor = "#416600";
	}

}

//can't control HOW the session will turn out, but can at least give it the right players.
function session612(){
	for(var i = 0; i<12;i++){
		var player;
		var guardian;
		if(i<players.length){
			player = players[i];
		}else{
			player = randomPlayerWithClaspect("Page", "Void");
			guardian = randomPlayerWithClaspect("Page", "Void");
			guardian.quirk = randomTrollSim(guardian);
			player.quirk = randomTrollSim(player);
			guardians.push(guardian);
			players.push(player);
		}
	}

	for(var i = 0; i<12;i++){
		player = players[i];
		var guardian = guardians[i]
		player.isTroll = true;
		guardian.isTroll = true;
		guardian.generateRelationships(guardians);
		player.generateRelationships(players);
		session612IndexToTrollAncestor(player, i);
		session612IndexToTroll(guardian, i);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}
//["#A10000","#a25203","#a1a100","#658200","#416600","#078446","#008282","#004182","#0021cb","#631db4","#610061","#99004d"]
//karkat, terezi, gamzee, equius, aradia, nepeta, tavros, vriska, kanaya, eridan, feferi, sollux
function session612IndexToTroll(player, index){
	if(index == 0){
		player.aspect = "Blood"
		player.moon = "Prospit"
		player.bloodColor = "#ff0000"
		player.land = "Land of Pulse and Haze"
		player.class_name = "Knight"
		player.hair = 18;
		player.leftHorn = 21;
		player.rightHorn = 21;
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.kernel_sprite = "Crab"
		player.interest1 = "Romance"
		player.interest2 = "Leadership"
		player.chatHandle = "carcinoGeneticist"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 1){
		player.moon = "Prospit"
		player.aspect = "Mind"
		player.land = "Land of Thought and Flow"
		player.class_name = "Seer"
		player.hair = 10;
		player.leftHorn = 46;
		player.rightHorn = 46;
		player.bloodColor = "#008282";
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 4;
		player.quirk.lettersToReplace = [["E","3"],["I","1"],["A","4"]];
		player.kernel_sprite = "Dragon"
		player.interest1 = "Justice"
		player.interest2 = "Live Action Roleplaying"
		player.chatHandle = "gallowsCalibrator"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 2){
		player.moon = "Prospit"
		player.aspect = "Rage"
		player.land = "Land of Mirth and Tents"
		player.class_name = "Bard"
		player.hair = 29;
		player.leftHorn = 29;
		player.rightHorn = 29;
		player.bloodColor = "#631db4";
		player.quirk.capitalization = 4;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 10;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","motherfuck"]];
		player.kernel_sprite = "Seagoat"
		player.interest1 = "Clowns"
		player.interest2 = "Religion"
		player.chatHandle = "terminallyCapricious"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 3){
		player.moon = "Derse"
		player.land = "Land of Caves and Silence"
		player.aspect = "Void"
		player.class_name = "Heir"
		player.hair = 8;
		player.leftHorn = 43;
		player.rightHorn = 43;
		player.bloodColor = "#0021cb";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 10;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["x","%"],["fuck","fiddlesticks"]];
		player.quirk.prefix = "D -->"
		player.quirk.suffix = ""
		player.kernel_sprite = "Centaur"
		player.interest1 = "Racism"
		player.interest2 = "Weight Lifting"
		player.chatHandle = "centaursTesticle"

	}else if(index == 4){
		player.moon = "Derse"
		player.aspect = "Time"
		player.class_name = "Maid"
		player.land = "Land of Quartz and Melody"
		player.hair = 23;
		player.leftHorn = 36;
		player.rightHorn = 36;
		player.bloodColor = "#A10000";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["o","0"]];
		player.kernel_sprite = "Frog"
		player.interest1 = "Archaeology"
		player.interest2 = "Death"
		player.chatHandle = "apocalypseArisen"
		player.godDestiny = true;
		player.doomedTimeClones = 5;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 5){
		player.moon = "Derse"
		player.aspect = "Heart"
		player.land = "Land of Little Cubes and Tea"
		player.class_name = "Rogue"
		player.hair = 7;
		player.leftHorn = 22;
		player.rightHorn = 22;
		player.bloodColor = "#416600";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 3;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ee","33"]];
		player.kernel_sprite = "Meowbeast"
		player.interest1 = "Role Playing"
		player.interest2 = "Romance"
		player.chatHandle = "arsenicCatnip"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 6){
		player.moon = "Prospit"
		player.aspect = "Breath"
		player.land = "Land of Sand and Zephyr"
		player.class_name = "Page"
		player.hair = 33;
		player.leftHorn = 28;
		player.rightHorn = 28;
		player.bloodColor = "#a25203";
		player.quirk.favoriteNumber = 1;
		player.quirk.capitalization = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","um"]];
		player.kernel_sprite = "Fairy Bull"
		player.interest1 = "Faeries"
		player.interest2 = "Animals"
		player.chatHandle = "adiosToreador"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 7){
		player.moon = "Prospit"
		player.land = "Land of Maps and Treasure"
		player.aspect = "Light"
		player.class_name = "Thief"
		player.hair = 14;
		player.leftHorn = 27;
		player.rightHorn = 27;
		player.bloodColor = "#004182";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 3;
		player.quirk.lettersToReplace = [];
		player.quirk.favoriteNumber = 8;
		player.quirk.lettersToReplaceIgnoreCase = [["b","8"]];
		player.interest1 = "Treasure"
		player.interest2 = "Live Action Roleplaying"
		player.kernel_sprite = "Spider"
		player.chatHandle = "arachnidsGrip"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
		player.godDestiny = true;
	}else if(index == 8){
		player.moon = "Prospit"
		player.land = "Land of Rays and Frogs"
		player.aspect = "Space"
		player.class_name = "Sylph"
		player.hair = 5;
		player.leftHorn = 26;
		player.rightHorn = 26;
		player.bloodColor = "#078446";
		player.quirk.capitalization = 3;
		player.quirk.favoriteNumber = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.kernel_sprite = "Mother Grub"
		player.interest1 = "Vampires"
		player.interest2 = "Fashion"
		player.chatHandle = "grimAuxiliatrix"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 9){
		player.moon = "Derse"
		player.land = "Land of Wrath and Angels"
		player.aspect = "Hope"
		player.class_name = "Prince"
		player.hair = 6;
		player.leftHorn = 19;
		player.rightHorn = 19;
		player.bloodColor = "#610061";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 7;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"], ["v","vv"], ["w","ww"]];
		player.kernel_sprite = "Skyhorse"
		player.interest1 = "Genocide"
		player.interest2 = "History"
		player.chatHandle = "caligulasAquarium"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 10){
		player.moon = "Derse"
		player.land = "Land of Dew and Glass"
		player.aspect = "Life"
		player.class_name = "Witch"
		player.hair = 1;
		player.leftHorn = 35;
		player.rightHorn = 35;
		player.bloodColor = "#99004d";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 9;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["h",")("],["e","-E"], ["fuck","glub"],  ["god","cod"]];
		player.kernel_sprite = "Horrorterror"
		player.interest1 = "Animals"
		player.interest2 = "Social Jusice"
		player.chatHandle = "cuttlefishCuller"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 11){
		player.moon = "Derse"//no way to have two dream selves righ tnow.
		player.land = "Land of Brains and Fire"
		player.aspect = "Doom"
		player.class_name = "Mage"
		player.hair = 2;
		player.leftHorn = 33;
		player.rightHorn = 33;
		player.bloodColor = "#a1a100";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["i","ii"],["s","2"]];
		player.kernel_sprite = "Bicyclops"
		player.interest1 = "Hacking"
		player.interest2 = "Programming"
		player.chatHandle = "twinArmageddons"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}
}

function session612IndexToTrollAncestor(player, index){
	if(index == 0){
		player.moon = "Prospit"
		player.aspect = "Blood"
		player.bloodColor = "#ff0000"
		player.land = "Land of Pulse and Haze"
		player.class_name = "Seer"
		player.hair = 18;
		player.leftHorn = 21;
		player.rightHorn = 21;
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["oo","69"], ["b","6"],["o","9"]];
		player.kernel_sprite = "Crab"
		player.interest1 = "Social Justice"
		player.interest2 = "Leadership"
		player.chatHandle = "carcinoGeneticist"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 1){
		player.moon = "Prospit"
		player.land = "Land of Thought and Flow"
		player.aspect = "Mind"
		player.class_name = "Knight"
		player.hair = 10;
		player.leftHorn = 46;
		player.rightHorn = 46;
		player.bloodColor = "#008282";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 4;
		player.quirk.lettersToReplace = [["E","3"],["I","1"],["A","4"]];
		player.kernel_sprite = "Dragon"
		player.interest1 = "Justice"
		player.interest2 = "Video Games"
		player.chatHandle = "gallowsCalibrator"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 2){
		player.moon = "Prospit"
		player.land = "Land of Mirth and Tents"
		player.aspect = "Rage"
		player.class_name = "Prince"
		player.hair = 29;
		player.leftHorn = 29;
		player.rightHorn = 29;
		player.bloodColor = "#631db4";
		player.quirk.capitalization = 4;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 10;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","motherfuck"]];
		player.kernel_sprite = "Seagoat"
		player.interest1 = "Death"
		player.interest2 = "Religion"
		player.chatHandle = "terminallyCapricious"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 3){
		player.moon = "Derse"
		player.aspect = "Void"
		player.land = "Land of Caves and Silence"
		player.class_name = "Page"
		player.hair = 8;
		player.leftHorn = 43;
		player.rightHorn = 43;
		player.bloodColor = "#0021cb";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 10;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["x","%"],["fuck","fiddlesticks"]];
		player.quirk.prefix = "8==D"
		player.quirk.suffix = ""
		player.kernel_sprite = "Centaur"
		player.interest1 = "Animals"
		player.interest2 = "Weight Lifting"
		player.chatHandle = "centaursTesticle"
	}else if(index == 4){
		player.moon = "Derse"
		player.aspect = "Time"
		player.class_name = "Witch"
		player.land = "Land of Quartz and Melody"
		player.hair = 23;
		player.leftHorn = 36;
		player.rightHorn = 36;
		player.bloodColor = "#A10000";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["o","0"]];
		player.kernel_sprite = "Frog"
		player.interest1 = "Intimidation"
		player.interest2 = "Death"
		player.chatHandle = "apocalypseArisen"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 5){
		player.aspect = "Heart"
		player.moon = "Derse"
		player.class_name = "Mage"
		player.land = "Land of Little Cubes and Tea"
		player.hair = 7;
		player.leftHorn = 22;
		player.rightHorn = 22;
		player.bloodColor = "#416600";
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 3;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ee","33"]];
		player.kernel_sprite = "Meowbeast"
		player.interest1 = "TV"
		player.interest2 = "Romance"
		player.chatHandle = "arsenicCatnip"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 6){
		player.aspect = "Breath"
		player.moon = "Prospit"
		player.land = "Land of Sand and Zephyr"
		player.class_name = "Rogue"
		player.hair = 33;
		player.leftHorn = 28;
		player.rightHorn = 28;
		player.bloodColor = "#a25203";
		player.quirk.favoriteNumber = 1;
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["i","1"]];
		player.quirk.suffix = ""
		player.kernel_sprite = "Fairy Bull"
		player.interest1 = "Movies"
		player.interest2 = "Animals"
		player.chatHandle = "adiosToreador"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 7){
		player.aspect = "Light"
		player.moon = "Prospit"
		player.land = "Land of Maps and Treasure"
		player.class_name = "Sylph"
		player.hair = 14;
		player.leftHorn = 27;
		player.rightHorn = 27;
		player.bloodColor = "#004182";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.favoriteNumber = 8;
		player.quirk.lettersToReplaceIgnoreCase = [["b","8"]];
		player.interest1 = "Writing"
		player.interest2 = "Live Action Roleplaying"
		player.kernel_sprite = "Spider"
		player.chatHandle = "arachnidsGrip"
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 8){
		player.aspect = "Space"
		player.moon = "Prospit"
		player.land = "Land of Frost and Frogs"
		player.class_name = "Maid"
		player.hair = 5;
		player.leftHorn = 26;
		player.rightHorn = 26;
		player.bloodColor = "#078446";
		player.quirk.capitalization = 3;
		player.quirk.favoriteNumber = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["o","o+"]];
		player.kernel_sprite = "Mother Grub"
		player.interest1 = "Love"
		player.interest2 = "Fashion"
		player.chatHandle = "grimAuxiliatrix"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 9){
		player.aspect = "Hope"
		player.moon = "Derse"
		player.land = "Land of Wrath and Angels"
		player.class_name = "Bard"
		player.hair = 6;
		player.leftHorn = 19;
		player.rightHorn = 19;
		player.bloodColor = "#610061";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 1;
		player.quirk.favoriteNumber = 7;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"], ["v","vw"], ["w","wv"]];
		player.kernel_sprite = "Skyhorse"
		player.interest1 = "Romance"
		player.interest2 = "History"
		player.chatHandle = "caligulasAquarium"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 10){
		player.moon = "Derse"
		player.aspect = "Life"
		player.land = "Land of Dew and Glass"
		player.class_name = "Thief"
		player.hair = 1;
		player.leftHorn = 35;
		player.rightHorn = 35;
		player.bloodColor = "#99004d";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 9;
		player.quirk.lettersToReplace = [ ["H",")("],];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"],["e","-E"], ["fuck","glub"],  ["god","cod"]];
		player.kernel_sprite = "Horrorterror"
		player.interest1 = "Animals"
		player.interest2 = "Money"
		player.chatHandle = "cuttlefishCuller"
		player.godDestiny = true;
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}else if(index == 11){
		player.aspect = "Doom"
		player.moon = "Derse"
		player.land = "Land of Brains and Fire"
		player.class_name = "Heir"
		player.hair = 2;
		player.leftHorn = 33;
		player.rightHorn = 33;
		player.bloodColor = "#a1a100";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["i","ii"],["s","2"]];
		player.kernel_sprite = "Bicyclops"
		player.interest1 = "Video Games"
		player.interest2 = "Programming"
		player.chatHandle = "twinArmageddons"
		player.quirk.suffix = ""
		player.quirk.prefix = ""
	}
}

//inversion of 413
function session1025(){
	for(var i = 0; i<12;i++){
		var player;
		var guardian;
		if(i<players.length){
			player = players[i];
		}else{
			player = randomPlayerWithClaspect("Page", "Void");
			guardian = randomPlayerWithClaspect("Page", "Void");
			guardian.quirk = randomTrollSim(guardian);
			player.quirk = randomTrollSim(player);
			guardians.push(guardian);
			players.push(player);
		}
	}

	for(var i = 0; i<12;i++){
		player = players[i];
		var guardian = guardians[i]
		if(i<8){
			player.isTroll = false;
			guardian.isTroll = false;
			session413IndexToHuman(player,i);
			session413IndexToAncestor(guardian,i);
		}else{
			player.isTroll = true;
			guardian.isTroll = true;
			var index = 0;
			if(i == 8){
				index = 0;
			}else if(i == 9){
				index = 8;
			}else if(i == 10){
				index = 1;
			}else if(i == 11){
				index = 7;
			}
			session612IndexToTroll(player, index);
			session612IndexToTroll(guardian, index);
		}

		guardian.generateRelationships(guardians);
		player.generateRelationships(players);

		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}

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
	if(getSessionType() == "Human"){
		return;
	}

	if(getSessionType() == "Troll" || (getSessionType() == "Mixed" &&Math.seededRandom() > 0.5) ){
		player.isTroll = true;
		player.triggerLevel ++;//trolls are less stable
		decideHemoCaste(player);
		decideLusus(player);
		player.kernel_sprite = player.lusus;
	}
}
//species, hair and blood color is the same, horns and favorite number. aspect.  Thats it.
//when scratch, get rid of story dif. make blank. scratch has to be button press.
function makeGuardians(){
	//console.log("Making guardians")
	available_classes = classes.slice(0);
	available_aspects = nonrequired_aspects.slice(0); //required_aspects
	available_aspects = available_aspects.concat(required_aspects.slice(0));
	for(var i = 0; i<players.length; i++){
		  var player = players[i];
			//console.log("guardian for " + player.titleBasic());
			var guardian = randomPlayer();
			guardian.isTroll = player.isTroll;
			if(guardian.isTroll){
				guardian.quirk = randomTrollSim(guardian)
			}else{
				guardian.quirk = randomHumanSim(guardian);
			}
			guardian.quirk.favoriteNumber = player.quirk.favoriteNumber;
			guardian.bloodColor = player.bloodColor;
			guardian.lusus = player.lusus;
			if(guardian.isTroll == true){ //trolls always use lusus.
				guardian.kernel_sprite = player.kernel_sprite;
			}
			guardian.hairColor = player.hairColor;
			guardian.aspect = player.aspect;
			guardian.leftHorn = player.leftHorn;
			guardian.rightHorn = player.rightHorn;
			guardian.level_index = 5; //scratched kids start more leveled up
			guardian.power = 50;
			guardian.leader = player.leader;
			if(Math.seededRandom() >0.5){ //have SOMETHING in common with your ectorelative.
				guardian.interest1 = player.interest1;
			}else{
				guardian.interest2 = player.interest2;
			}
			guardian.reinit();//redo levels and land based on real aspect
			guardians.push(guardian);
	}

	for(var j = 0; j<guardians.length; j++){
		var g = guardians[j];
		g.generateRelationships(guardians);
	}
}

function init(){
	available_classes = classes.slice(0); //re-init available classes.
	available_aspects = nonrequired_aspects.slice(0);
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
			p.quirk = randomTrollSim(p)
		}else{
			p.quirk = randomHumanSim(p);
		}
	}

}
