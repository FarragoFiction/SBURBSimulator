var simulationMode = false;
var debugMode = false;
var spriteWidth = 400;
var spriteHeight = 300;
var canvasWidth = 1000;
var canvasHeight = 300;
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

	if(getParameterByName("lollipop")  == "true"){
		tricksterMode();
	}
	if(getParameterByName("sbajifier")  == "true"){
		sbahjMode();
	}
	//authorMessage();
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

	load(curSessionGlobalVar.players, curSessionGlobalVar.guardians); //in loading.js
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
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		if(curSessionGlobalVar.players[i].isTroll == false){
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

function renderScratchButton(session){
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
	intro();
}

//TODO if i wanted to, I could have mixed sessions like in canon.
//not erasing the players, after all.
//or could have an afterlife where they meet guardian players???
function scratch(){
	console.log("scratch has been confirmed")
	var numPlayersPreScratch = curSessionGlobalVar.players.length;
	var ectoSave = curSessionGlobalVar.ectoBiologyStarted;

	reinit();
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
	if(initial_seed == 413){
		session413();
	}else if(initial_seed == 612){
		session612();
	}else if(initial_seed == 1025){
		session1025()
	}else if(initial_seed == 33){
		session33();
	}
	curSessionGlobalVar.ectoBiologyStarted = ectoSave; //if i didn't do ecto in first version, do in second
	if(curSessionGlobalVar.ectoBiologyStarted){ //players are reset except for haivng an ectobiological source
		setEctobiologicalSource(curSessionGlobalVar.players, curSessionGlobalVar.session_id);
	}
	curSessionGlobalVar.scratched = true;
	curSessionGlobalVar.switchPlayersForScratch();
	var scratch = "The session has been scratched. The " + getPlayersTitlesBasic(getGuardiansForPlayers(curSessionGlobalVar.players)) + " will now be the beloved guardians.";
	scratch += " Their former guardians, the " + getPlayersTitlesBasic(curSessionGlobalVar.players) + " will now be the players.";
	scratch += " The new players will be given stat boosts to give them a better chance than the previous generation."
	if(curSessionGlobalVar.players.length != numPlayersPreScratch){
		scratch += " You are quite sure that players not native to this session have never been here at all. Quite frankly, you find the notion absurd. "
		console.log("forign players erased.")
	}
	scratch += " What will happen?"
	console.log("about to switch players")

	$("#story").html(scratch);
	window.scrollTo(0, 0);

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


function session413(){
	for(var i = 0; i<8;i++){
		var player;
		var guardian;
		if(i< curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian.quirk = randomHumanSim(guardian);
			player.quirk = randomHumanSim(player);
			player.guardian = guardian;
			guardian.guardian = player;
			curSessionGlobalVar.players.push(player);
		}
	}

	for(var i = 0; i<8;i++){
		player = curSessionGlobalVar.players[i];
		var guardian = player.guardian;
		player.isTroll = false;
		guardian.isTroll = false;
		player.relationships = [];
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players)
		guardian.generateBlandRelationships(guardians);
		player.generateBlandRelationships(curSessionGlobalVar.players);
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
		player.hair  =1;
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
		player.hair  =38;
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
		//HI!!! HOW ARE YOU!?
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
		player.hair  =36;
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
		player.hair  =37;
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
		if(i<curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			guardian = randomPlayerWithClaspect(curSessionGlobalVar,"Rogue", "Heart");
			player = randomPlayerWithClaspect(curSessionGlobalVar,"Rogue", "Heart");
			player.quirk = randomTrollSim(player);
			guardian.quirk = randomTrollSim(player);
			players.push(player);
			player.guardian = guardian;
			guardian.guardian = player;
		}
		session612IndexToTroll(player, i);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}

	for(var i = 0; i<12;i++){
		player = curSessionGlobalVar.players[i];
		guardian = player.guardian;
		player.isTroll = true;
		guardian.isTroll = true;
		player.generateRelationships(curSessionGlobalVar.players);
		//TODO fix this i guess.  Edit: TheLertTheWorldNeeds convinced me to fix it.
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players)
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
		if(i<curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian = randomPlayerWithClaspect(curSessionGlobalVar,"Page", "Void");
			guardian.quirk = randomTrollSim(guardian);
			player.quirk = randomTrollSim(player);
			//curSessionGlobalVar.guardians.push(guardian);
			curSessionGlobalVar.players.push(player);
			player.guardian = guardian;
			guardian.guardian = player;
		}
	}

	for(var i = 0; i<12;i++){
		player = curSessionGlobalVar.players[i];
		var guardian = player.guardian;
		player.isTroll = true;
		guardian.isTroll = true;
		player.relationships = [];
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players)
		guardian.generateRelationships(guardians);
		player.generateRelationships(curSessionGlobalVar.players);
		session612IndexToTrollAncestor(player, i);
		session612IndexToTroll(guardian, i);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}
//["#A10000","#a25203","#a1a100","#658200","#416600","#078446","#008282","#004182","#0021cb","#631db4","#610061","#99004d"]
//karkat, terezi, gamzee, equius, aradia, nepeta, tavros, vriska, kanaya, eridan, feferi, sollux
function session612IndexToTroll(player, index){
	player.hairColor = "#000000"
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
		player.hair = 41;
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
		player.quirk.favoriteNumber = 6;
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
		player.hair = 40;
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
		player.hair = 39;
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
		player.hair = 19;
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
	player.hairColor = "#000000"
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
		player.hair = 41;
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
		player.quirk.favoriteNumber = 6;
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
		player.hair = 40;
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
		player.hair = 39;
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
		player.hair = 19;
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
		if(i<curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerWithClaspect("Page", "Void");
			guardian = randomPlayerWithClaspect("Page", "Void");
			guardian.quirk = randomTrollSim(guardian);
			player.quirk = randomTrollSim(player);
			//curSessionGlobalVar.guardians.push(guardian);
			player.guardian = guardian;
			guardian.guardian = player;
			curSessionGlobalVar.players.push(player);
		}
	}

	for(var i = 0; i<12;i++){
		player = curSessionGlobalVar.players[i];
		var guardian = player.guardian;
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
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players)
		guardian.generateRelationships(guardians);
		player.relationships = [];
		player.generateRelationships(curSessionGlobalVar.players);

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
