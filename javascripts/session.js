//okay, fine, yes, global variables are getting untenable.
function Session(session_id){
	this.session_id = session_id; //initial seed
	this.players = [];
	this.hasClubs = false;
	this.sessionHealth = 5000; //grimDark players work to lower it. at 0, it crashes.  maybe have it do other things at other levels, or effect other things.
	this.hasDiamonds = false;
	this.hasHearts = false;
	this.hasSpades = false;
	this.denizenBeat = false;
	//session no longer keeps track of guardians.
	this.kingStrength = 100;
	this.rapBattle = false;
	this.crashedFromSessionBug = false; //gets corrupted if an unrecoverable error gets caught.
	this.crashedFromPlayerActions = false;
	this.sickFires = false;
	this.sbahj = false;
	this.queenStrength = 100;
	this.jackStrength = 50;
	this.hardStrength = 275;
	this.minFrogLevel = 18;
	this.goodFrogLevel = 28;
	this.democracyStrength = 0;
	this.reckoningStarted = false;
	this.aliensClonedOnArrival = []; //if i'm gonna do time shenanigans, i need to know what the aliens were like when they got here.
	this.murdersHappened = false;
	this.goodLuckEvent = false;
	this.badLuckEvent = false;
	this.hasFreeWillEvents = false;
	this.ectoBiologyStarted = false;
	this.doomedTimeline = false;
	this.makeCombinedSession = false; //happens if sick frog and few living players
	this.scratched = false;
	this.scratchAvailable = false;
	this.timeTillReckoning = 0;
	this.godTier = false;
	this.questBed = false;
	this.sacrificialSlab = false;
	this.sessionType = -999
	this.scenesTriggered = []; //this.scenesTriggered
	this.doomedTimelineReasons = [];
	this.currentSceneNum = 0;
	this.scenes = []; //scene controller initializes all this.
	this.reckoningScenes = [];
	this.deathScenes = [];
	this.available_scenes = [];
	this.hadCombinedSession = false;
	this.parentSession = null;
	this.availablePlayers = [];  //which players are available for scenes or whatever.
	this.importantEvents = [];
	this.yellowYardController = new YellowYardResultController();//don't expect doomed time clones to follow them to any new sessions

	//IMPORTANT do not add important events directly, or can't check for alternate timelines.
	//oh god, just typing that gives me chills. time shenanigans are so great.
	this.addImportantEvent = function(important_event){
		var alternate = this.yellowYardController.doesEventNeedToBeUndone(important_event);
	//	console.log("alternate i got from yellowYardController is: " + alternate)
		if(alternate){
		//	console.log("returning alternate")
			return alternate; //scene will use the alternate to go a different way. important event no longer happens.
		}else{
			//console.log(" pushing important event and returning null")
			this.importantEvents.push(important_event);
			return null;
		}
	}

	this.frogStatus = function(){
		var spacePlayer = findAspectPlayer(this.players, "Space");
		if(spacePlayer.landLevel < this.minFrogLevel){
			return "No Frog"
		}else if(spacePlayer.landLevel > this.goodFrogLevel){
			return "Full Frog"
		}else{
			return "Sick Frog"
		}

	}

	//make Math.seed  = to my session id, reinit all my variables (similar to a scratch.)
	//make sure the controller starts ticking again. very similar to scrach
	this.addEventToUndoAndReset = function(e){
		//console.log("undoing an event.")
		if(this.scratched){
			return this.addEventToUndoAndResetScratch(e); //works different
		}
		if(e){//will be null if undoing an undo
			this.yellowYardController.eventsToUndo.push(e);
		}
		//reinit the seed and restart the session
		var savedPlayers = curSessionGlobalVar.players;
		this.reinit();
		createScenesForSession(curSessionGlobalVar);
		//players need to be reinit as well.
		curSessionGlobalVar.makePlayers();
		curSessionGlobalVar.randomizeEntryOrder();
		curSessionGlobalVar.makeGuardians(); //after entry order established
		checkEasterEgg(); //in the controller.
		//now that i've done that, (for seed reasons) fucking ignore it and stick the actual players in
		//after alll, i could be from a combo session.
		//but don't just hardcore replace. need to...fuck. okay, cloning aliens now.
		curSessionGlobalVar.aliensClonedOnArrival = this.aliensClonedOnArrival;
		//console.log("adding this many clone aliens: " + curSessionGlobalVar.aliensClonedOnArrival.length)
		//console.log(getPlayersTitles(curSessionGlobalVar.aliensClonedOnArrival));
		var living = []  //if don't make copy of aliensClonedOnArrival, goes into an infinite loop as it loops on it and adds to it inside of addAliens
		for(var i = 0; i<this.aliensClonedOnArrival.length; i++){
			living.push(this.aliensClonedOnArrival[i])
		}
		this.aliensClonedOnArrival = [];//jettison old clones.
		addAliensToSession(curSessionGlobalVar, living);

		restartSession();//in controller
	}

	this.addEventToUndoAndResetScratch = function(e){
		console.log('yellow yard from scratched session')
		if(e){//will be null if undoing an undo
			this.yellowYardController.eventsToUndo.push(e);
		}
		var ectoSave = this.ectoBiologyStarted;
		reinit();
		//use seeds the same was as original session and also make DAMN sure the players/guardians are fresh.
		curSessionGlobalVar.makePlayers();
		curSessionGlobalVar.randomizeEntryOrder();
		curSessionGlobalVar.makeGuardians(); //after entry order established
		this.ectoBiologyStarted = ectoSave;
		this.scratched = true;
		this.switchPlayersForScratch();



		restartSession();//in controller
	}

	//child sessions are basically any session with an ID that matches the seed you stop on
	//TODO could possibly be constrained to need a space or time player to navigage. or godtier light/doom??? could further require the player be from derse
	//but this already 2-4% of all sessions, do i really want it to  be even rarer?
	this.initializeCombinedSession = function(){
		this.aliensClonedOnArrival = []; //PROBABLY want to do this.
		var living = findLivingPlayers(this.players);
		//nobody is the leader anymore.
		var newSession = new Session(Math.seed);  //this is a real session that could have gone on without these new players.
		newSession.currentSceneNum = this.currentSceneNum;
		newSession.reinit();
		newSession.makePlayers();
		newSession.randomizeEntryOrder();
		newSession.makeGuardians();
		if(living.length + newSession.players.length > 12){
			//console.log("New session " + newSession.session_id +" cannot support living players. Already has " + newSession.players.length + " and would need to add: " + living.length)
			return;  //their child session is not able to support them
		}
	//	console.log("about to add: " + living.length + " aliens to new session.")
		//console.log(getPlayersTitles(living));
		addAliensToSession(newSession, living);


		this.hadCombinedSession = true;
		newSession.parentSession = this;
		createScenesForSession(newSession);
		//console.log("Session: " + this.session_id + " has made child universe: " + newSession.session_id + " child has this long till reckoning: " + newSession.timeTillReckoning)
		return newSession;
	}

	this.getVersionOfPlayerFromThisSession = function(player){
		//can double up on classes or aspects if it's a combo session. god. why are their combo sessions?
		for(var i = 0; i< this.players.length; i++){
			var p = this.players[i];
			if(p.class_name == player.class_name && p.aspect == player.aspect){
				return p; //yeah, technically there COULD be two players with the same claspect in a combo session, but i have ceased caring.
			}
		}
		console.log("Error finding session's: " + player.title());
	}


	//if htis is used for scratch, manually save ectobiology cause it's getting reset here
	this.reinit = function(){
		groundHog = false;
		Math.seed = this.session_id; //if session is reset,
		//console.log("reinit with seed: "  + Math.seed)
		this.timeTillReckoning = getRandomInt(10,30);
		this.sessionType = Math.seededRandom();
		curSessionGlobalVar.available_scenes = curSessionGlobalVar.scenes.slice(0);
		curSessionGlobalVar.doomedTimeline = false;
		this.kingStrength = 100;
		this.queenStrength = 100;
		this.jackStrength = 50;
		this.democracyStrength = 0;
		this.reckoningStarted = false;
		this.importantEvents = [];
		this.scenesTriggered = []; //this.scenesTriggered
		this.doomedTimelineReasons = [];
		this.ectoBiologyStarted = false;

	}

	this.makePlayers = function(){
		//console.log("Making players with seed: " + Math.seed)
		this.players = [];
		available_classes = classes.slice(0); //re-initPlayers available classes.
		available_aspects = nonrequired_aspects.slice(0);
		var numPlayers = getRandomInt(2,12);
		this.players.push(randomSpacePlayer(this));
		this.players.push(randomTimePlayer(this));

		for(var i = 2; i<numPlayers; i++){
			this.players.push(randomPlayer(this));
		}

		for(var j = 0; j<this.players.length; j++){
			var p = this.players[j];

			p.generateRelationships(this.players);
			this.decideTroll(p);

			if(p.isTroll){
				p.quirk = randomTrollSim(p)
			}else{
				p.quirk = randomHumanSim(p);
			}
		}

		decideInitialQuadrants(this.players);

		for(var k = 0; k<this.players.length; k++){
			//can't escape consequences.
			this.players[k].consequencesForGoodPlayer();
			this.players[k].consequencesForTerriblePlayer();
		}
	}

	this.convertPlayerNumberToWords = function(){
		//alien players don't count
		var ps = findPlayersFromSessionWithId(this.players, this.session_id);
		if(ps.length == 0){
			ps = this.players;
		}
		var length = ps.length;
		if(length == 2){
			return "TWO";
		}else if(length == 3){
			return "THREE";
		}else if(length == 4){
			return "FOUR";
		}else if(length == 5){
			return "FIVE";
		}else if(length == 6){
			return "SIX";
		}else if(length == 7){
			return "SEVEN";
		}else if(length == 8){
			return "EIGHT";
		}else if(length == 9){
			return "NINE";
		}else if(length == 10){
			return "TEN";
		}else if(length == 11){
			return "ELEVEN";
		}else if(length == 12){
			return "TWELVE";
		}
	}

	this.makeGuardians = function(){
		//console.log("Making guardians")
		available_classes = classes.slice(0);
		available_aspects = nonrequired_aspects.slice(0); //required_aspects
		available_aspects = available_aspects.concat(required_aspects.slice(0));
		var guardians = [];
		for(var i = 0; i<this.players.length; i++){
			  var player = this.players[i];
				//console.log("guardian for " + player.titleBasic());
				var guardian = randomPlayer(this);
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
				//this.guardians.push(guardian); //sessions don't keep track of this anymore
				player.guardian = guardian;
				guardian.guardian = player;//goes both ways.
				guardians.push(guardian)
		}

		for(var j = 0; j<this.players.length; j++){
			var g = this.players[j].guardian;
			g.generateRelationships(guardians);
		}
		decideInitialQuadrants(guardians);

		for(var k = 0; k<this.players.length; k++){
			//can't escape consequences.
			this.players[k].guardian.consequencesForGoodPlayer();
			this.players[k].guardian.consequencesForTerriblePlayer();
		}
	}

	this.randomizeEntryOrder = function(){
		this.players = shuffle(this.players);
		this.players[0].leader = true;
	}

	/*
	no longer as simple as just switching players and guardians.
	need to only switch players who have an ectobiologicalSource of this session.
	*/
	this.switchPlayersForScratch = function(){
		//var tmp = curSessionGlobalVar.players;
		//curSessionGlobalVar.players = curSessionGlobalVar.guardians;
		//curSessionGlobalVar.guardians = tmp;
		var nativePlayers = findPlayersFromSessionWithId(this.players, this.session_id);
		//console.log(nativePlayers)
		var guardians = getGuardiansForPlayers(nativePlayers);
		this.players = guardians;
	}

	this.decideTroll = function decideTroll(player){
		if(this.getSessionType() == "Human"){
			return;
		}

		if(this.getSessionType() == "Troll" || (this.getSessionType() == "Mixed" &&Math.seededRandom() > 0.5) ){
			player.isTroll = true;
			player.hairColor = "#000000"
			player.triggerLevel ++;//trolls are less stable
			player.decideHemoCaste(player);
			player.decideLusus(player);
			player.kernel_sprite = player.lusus;
		}
	}


	this.getSessionType = function(){
		if(this.sessionType > .6){
			return "Human"
		}else if(this.sessionType > .3){
			return "Troll"
		}
		return "Mixed"
	}


	this.newScene = function(){
		this.currentSceneNum ++;
		var div;
		if(this.sbahj){
			div = "<div id='scene"+this.currentSceneNum+"' style='";
			div += "background-color: #00ff00;"
			div += "font-family: Comic Sans MS, cursive, sans-serif;"
			//$("#scene"+this.currentSceneNum).css("background-color", "#00ff00");
			var reallyRand = getRandomIntNoSeed(1,10);
			for(var i = 0; i<reallyRand; i++){
				var indexOfTerribleCSS = getRandomIntNoSeed(0,terribleCSSOptions.length-1)
				var tin = terribleCSSOptions[indexOfTerribleCSS]
				if(tin[1] == "????"){
					tin[1] = getRandomIntNoSeed(1,100) +"%";
				}
				div += tin[0] + tin[1]+";";
			}
			div += "' ></div>";
		}else{
			div = "<div id='scene"+this.currentSceneNum+"'></div>";
		}
		$("#story").append(div);
		return $("#scene"+this.currentSceneNum);
	}

	//holy shit, grand sessions are a thing? how far does this crazy train go?
	//i haven't dusted off RECURSION in forever.
	this.getLineage = function(){
			if(this.parentSession){
					return this.parentSession.getLineage().concat([this]);
			}
			return [this];
	}

	this.generateSummary = function(){
		var summary = new SessionSummary();
		summary.crashedFromSessionBug = this.crashedFromSessionBug;
		summary.crashedFromPlayerActions = this.crashedFromPlayerActions;
		summary.hasFreeWillEvents = this.hasFreeWillEvents;
		summary.averageMinLuck = getAverageMinLuck(this.players);
		summary.averageMaxLuck = getAverageMaxLuck(this.players);
		summary.averagePower = getAveragePower(this.players);
		summary.averageMobility = getAverageMobility(this.players);
		summary.averageFreeWill = getAverageFreeWill(this.players);
		summary.averageHP = getAverageHP(this.players);
		summary.averageRelationshipValue = getAverageRelationshipValue(this.players);
		summary.averageTriggerLevel = getAverageTriggerLevel(this.players);
		summary.session_id = this.session_id;
		summary.hasLuckyEvents = this.goodLuckEvent;
		summary.hasUnluckyEvents = this.badLuckEvent;
		summary.rapBattle = this.rapBattle;
		summary.sickFires = this.sickFires;
		summary.frogStatus = this.frogStatus();
		summary.godTier = this.godTier;
		summary.questBed = this.questBed;
		summary.sacrificialSlab = this.sacrificialSlab;
		summary.num_scenes = this.scenesTriggered.length;
		summary.players = this.players;
		summary.mvp = findStrongestPlayer(this.players);
		summary.parentSession = this.parentSession;
		summary.scratchAvailable = this.scratchAvailable;
		summary.yellowYard = findSceneNamed(this.scenesTriggered,"YellowYard") != "No"
		summary.numLiving =  findLivingPlayers(this.players).length;
		summary.numDead =  findDeadPlayers(this.players).length;
		summary.ectoBiologyStarted = this.ectoBiologyStarted;
		summary.denizenFought = findSceneNamed(this.scenesTriggered,"FaceDenizen") != "No";
		summary.denizenBeat = this.denizenBeat;
		summary.plannedToExileJack = findSceneNamed(this.scenesTriggered,"PlanToExileJack") != "No";
		summary.exiledJack = findSceneNamed(this.scenesTriggered,"ExileJack") != "No"
		summary.exiledQueen = findSceneNamed(this.scenesTriggered,"ExileQueen") != "No"
		summary.jackPromoted = findSceneNamed(this.scenesTriggered,"JackPromotion") != "No"
		summary.jackGotWeapon = findSceneNamed(this.scenesTriggered,"GiveJackBullshitWeapon") != "No"
		summary.jackRampage = findSceneNamed(this.scenesTriggered,"JackRampage") != "No"
		summary.jackScheme = findSceneNamed(this.scenesTriggered,"JackBeginScheming") != "No"
		summary.kingTooPowerful =findSceneNamed(this.scenesTriggered,"KingPowerful") != "No"
		summary.queenRejectRing =findSceneNamed(this.scenesTriggered,"QueenRejectRing") != "No"
		summary.democracyStarted =findSceneNamed(this.scenesTriggered,"StartDemocracy") != "No"
		summary.murderMode = findSceneNamed(this.scenesTriggered,"EngageMurderMode") != "No"
		summary.grimDark = findSceneNamed(this.scenesTriggered,"GrimDarkQuests") != "No"
		var spacePlayer = findAspectPlayer(this.players, "Space");
		summary.frogLevel =spacePlayer.landLevel
		summary.hasDiamonds =this.hasDiamonds;
		summary.hasSpades = this.hasSpades;
		summary.hasClubs = this.hasClubs;
		summary.hasHearts =  this.hasHearts;
		return summary;
	}
}


function summarizeScene(scenesTriggered, str){
	var tmp = findSceneNamed(scenesTriggered,str)
	if(tmp != "No"){
		tmp = "Yes"
	}
	return "<br>&nbsp&nbsp&nbsp&nbsp" +str + ": " + tmp
}

function findSceneNamed(scenesToCheck, name){
	for(var i = 0; i<scenesToCheck.length; i++){
		if(scenesToCheck[i].constructor.name == name){
			return scenesToCheck[i];
		}
	}
	return "No"
}


	//save a copy of the alien (in case of yellow yard)
	function addAliensToSession (newSession, living){
		//console.log("in method, adding aliens to session")
		for(var i = 0; i<living.length; i++){
			var survivor = living[i];
			survivor.land = null;
			survivor.dreamSelf = false;
			survivor.godDestiny = false;
			survivor.leader = false;
		}
		//save a copy of the alien players in case this session has time shenanigans happen

		for(var i = 0; i<living.length; i++){
			var survivor = living[i];
			newSession.aliensClonedOnArrival.push(clonePlayer(survivor, newSession));
		}
		//don't want relationships to still be about original players
		for(var i = 0; i<newSession.aliensClonedOnArrival.length; i++){
			var clone = newSession.aliensClonedOnArrival[i];
			transferFeelingsToClones(clone, newSession.aliensClonedOnArrival);
		}
			//console.log("generated relationships between clones");
		//generate relationships AFTER saving a backup of hte player.
		//want clones to only know about other clones. not players.
		for(var i = 0; i<living.length; i++){
			var survivor = living[i];
			//console.log(survivor.title() + " generating relationship with new players ")
			survivor.generateRelationships(newSession.players); //don't need to regenerate relationship with your old friends
		}


		for(var j= 0; j<newSession.players.length; j++){
			var player = newSession.players[j];
			player.generateRelationships(living);
		}

		for(var i = 0; i<living.length; i++){
			for(var j= 0; j<newSession.players.length; j++){
					var player = newSession.players[j];
					var survivor = living[i];
					//survivors have been talking to players for a very long time, because time has no meaning between univereses.
					var r1 = survivor.getRelationshipWith(player);
					var r2 = player.getRelationshipWith(survivor);
					r1.moreOfSame();
					r1.moreOfSame();
					//been longer from player perspective
					r2.moreOfSame();
					r2.moreOfSame();
					r2.moreOfSame();
					r2.moreOfSame();
			}
	}

	newSession.players= newSession.players.concat(living);
}
