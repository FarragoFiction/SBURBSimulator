var players = [];
//looking for rare sessions or doing moon prophecies. not rendering.
var simulationMode = true;
var guardians = [];
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
var repeatTime = 5;
var version2 = true; //even though idon't want  to render content, 2.0 is different from 1.0 (think of dialog that triggers)
var timeTillReckoning = getRandomInt(10,30); //these will be wrong if seed is set
var sessionType = Math.seededRandom(); //human, troll or mixed.

var sessionsSimulated = []
var timesEcto = 0;
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
var timesDemocracyStart = 0;
var timesScratchesAvailable =0;

var numSimulationsDone = 0;
var numSimulationsToDo = 1;

//have EVERYTHING be a scene, don't put any story in v2.0's controller
//every scene can update the narration, or the canvas.
//should there be only one canvas?  Can have player sprites be written to a virtual canvas first, then copied to main one.
//main canvas is either Leader + PesterChumWindow + 1 or more Players (in chat or group chat with leader)
//or Leader + 1 or more Players  (leader doing bullshit side quests with someone)
window.onload = function() {
		debug("Problem. Even though session ids are different, scenes always play out the same way.")
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
  init();
	randomizeEntryOrder();
	//authorMessage();
	makeGuardians(); //after entry order established
	//checkSGRUB();
	//load(players, guardians); //in loading.js no graphics

	intro();
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
	timesScratchesAvailable ++;
	summarizeSession(true);
}

function scratchConfirm(){
	var scratchConfirmed = confirm("This session is doomed. Scratching this session will erase it. A new session will be generated, but you will no longer be able to view this session. Is this okay?");
	if(scratchConfirmed){
		scratch();
	}
}

function reinit(){
	players = [];
	guardians = [];
	scenesTriggered = [];
	doomedTimelineReasons = []
	available_classes = classes.slice(0);
	available_aspects = nonrequired_aspects.slice(0); //required_aspects
	available_aspects = available_aspects.concat(required_aspects.slice(0));
	available_scenes = scenes.slice(0);  //was forgetting to reset this, so scratched players had less to do.
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
}

//TODO if i wanted to, I could have mixed sessions like in canon.
//not erasing the players, after all.
//or could have an afterlife where they meet guardian players???
function scratch(){
	reinit();
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
		summarizeSession();
	}

}
function findSceneNamed(scenesToCheck, name){
	for(var i = 0; i<scenesToCheck.length; i++){
		if(scenesToCheck[i].constructor.name == name){
			return scenesToCheck[i];
		}
	}
	return "No"
}

function summarizeScene(scenesTriggered, str){
	return "<br>&nbsp&nbsp&nbsp&nbsp" +str + " : " + findSceneNamed(scenesTriggered,str)
}

function summarizeSession(scratchAvailable){
	//don't summarize the same session multiple times. can happen if scratch happens in reckoning, both point here.
	if(sessionsSimulated.indexOf(initial_seed) != -1){
		return;
	}
	sessionsSimulated.push(initial_seed);
	$("#story").html("");
	var str = "<Br><hr>Session: " + initial_seed + " scenes: " + scenesTriggered.length + " Leader:  " + getLeader(players).title() ;
	if(scratchAvailable){
		str += "<b>&nbsp&nbsp&nbsp&nbspScratch Available</b>"
	}
	var tmp = "";
	tmp =  summarizeScene(scenesTriggered, "DoEctobiology")
	if(findSceneNamed(scenesTriggered,"DoEctobiology") != "No"){
		timesEcto ++;
	}
	str += tmp;

	tmp =  summarizeScene(scenesTriggered, "FaceDenizen")
	if(findSceneNamed(scenesTriggered,"FaceDenizen") != "No"){
		timesDenizen ++;
	}
	str += tmp;

	tmp =  summarizeScene(scenesTriggered, "ExileJack")
	if(findSceneNamed(scenesTriggered,"ExileJack") != "No"){
		timesExileJack ++;
	}
	str += tmp;


	tmp =  summarizeScene(scenesTriggered, "ExileQueen")
	if(findSceneNamed(scenesTriggered,"ExileQueen") != "No"){
		timesExileQueen ++;
	}
	str += tmp;


	tmp =  summarizeScene(scenesTriggered, "GiveJackBullshitWeapon")
	if(findSceneNamed(scenesTriggered,"GiveJackBullshitWeapon") != "No"){
		timesJackWeapon ++;
	}
	str += tmp;

	tmp =  summarizeScene(scenesTriggered, "JackBeginScheming")
	if(findSceneNamed(scenesTriggered,"JackBeginScheming") != "No"){
		timesJackScheme ++;
	}
	str += tmp;


	tmp =  summarizeScene(scenesTriggered, "JackPromotion")
	if(findSceneNamed(scenesTriggered,"JackPromotion") != "No"){
		timesJackPromotion ++;
	}
	str += tmp;

	tmp =  summarizeScene(scenesTriggered, "JackRampage")
	if(findSceneNamed(scenesTriggered,"JackRampage") != "No"){
		timesJackRampage ++;
	}
	str += tmp;


	tmp =  summarizeScene(scenesTriggered, "KingPowerful")
	if(findSceneNamed(scenesTriggered,"KingPowerful") != "No"){
		timesKingPowerful ++;
	}
	str += tmp;

	tmp =  summarizeScene(scenesTriggered, "QueenRejectRing")
	if(findSceneNamed(scenesTriggered,"QueenRejectRing") != "No"){
		timesQueenRejectRing ++;
	}
	str += tmp;


  //stats for this will happen in checkDoomedTimeLines
	str += summarizeScene(scenesTriggered, "SaveDoomedTimeLine") + doomedTimelineReasons;

	tmp =  summarizeScene(scenesTriggered, "StartDemocracy")
	if(findSceneNamed(scenesTriggered,"StartDemocracy") != "No"){
		timesDemocracyStart ++;
	}
	str += tmp;

	checkDoomedTimelines();
	debug(str);

	numSimulationsDone ++;
	if(numSimulationsDone > numSimulationsToDo){
		printStats();
		alert("should be done")
		return;
	}else{
		var tmp = getRandomSeed();
		Math.seed = tmp;
		doomedTimelineReasons = []
		//initial_seed = Math.seed; //does this break predictable randomness?
		initial_seed = tmp;
		initRandomness();
	  init();
		randomizeEntryOrder();
		//authorMessage();
		makeGuardians(); //after entry order established
		//checkSGRUB();
		//load(players, guardians); //in loading.js no graphics

		intro();

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
	str += "<Br>Times Scratches Available: " + timesScratchesAvailable + " (" + Math.round((timesScratchesAvailable/sessionsSimulated.length)*100) + "%)";
	str += "<Br>Times Ectobiology: " + timesEcto + " (" + Math.round((timesEcto/sessionsSimulated.length)*100) + "%)";
	str += "<Br>Times Fought Denizen (at least once): " + timesDenizen + " (" + Math.round((timesDenizen/sessionsSimulated.length)*100) + "%)";;
	str += "<Br>Times Exiled Jack: " + timesExileJack + " (" + Math.round((timesExileJack/sessionsSimulated.length)*100) + "%)";;
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
	for(var i= 0; i<doomedTimelineReasons.length; i ++){
		timesSavedDoomedTimeLine ++;
		if(doomedTimelineReasons[i] != "Random."){
			//alert("found an interesting doomed timeline" + doomedTimelineReasons[i])
			timesInterestingSaveDoomedTimeLine ++;
			return;
		}
	}
	if(doomedTimelineReasons.length > 1){
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
	guardians = [];
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
	players = [];
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
