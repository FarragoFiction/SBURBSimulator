//okay, fine, yes, global variables are getting untenable.
function Session(session_id){
	this.session_id = session_id; //initial seed
	//this.sceneRenderingEngine = new SceneRenderingEngine(false); //default is homestuck  //comment this line out if need to run sim without it crashing
	this.players = [];
	this.fraymotifCreator = new FraymotifCreator();  //as long as FraymotifCreator has no state data, this is fine.
	this.hasClubs = false;
	this.sessionHealth = 500; //grimDark players work to lower it. at 0, it crashes.  maybe have it do other things at other levels, or effect other things.
	this.hasDiamonds = false;
	this.opossumVictory = false;
	this.hasBreakups = false;  //sessions aren't in charge of denizens anymore, they are for players and set when they get in the medium
	this.replayers = []; //used for fan oc easter eggs.
	this.afterLife = new AfterLife();
	this.queensRing = null; //eventually have white and black ones.
	this.kingsScepter = null;
	this.janusReward = false;
	this.badBreakDeath = false;
	this.jackGotWeapon = false;
	this.jackRampage = false;
	this.jackScheme = false;
	this.luckyGodTier = false;
	this.choseGodTier = false;
	this.plannedToExileJack = false;
	this.hasHearts = false;
	this.hasSpades = false;
	this.rocksFell = false;
	this.denizenBeat = false;
	//session no longer keeps track of guardians.
	this.king = null;
	this.queen = null;
	this.numScenes = 0;
	this.rapBattle = false;
	this.crashedFromSessionBug = false; //gets corrupted if an unrecoverable error gets caught.
	this.crashedFromPlayerActions = false;
	this.sickFires = false;
	this.dreamBubbleAfterlife = false;
	this.democraticArmy = null;
	this.sbahj = false;
	this.heroicDeath = null;
	this.won = false;
	this.justDeath = null;
	this.mayorEnding = false;
	this.waywardVagabondEnding = false;
	this.hardStrength = 500;
	this.minFrogLevel = 18;
	this.goodFrogLevel = 28;
	this.reckoningStarted = false;
	this.aliensClonedOnArrival = []; //if i'm gonna do time shenanigans, i need to know what the aliens were like when they got here.
	this.murdersHappened = false;
	this.queenRejectRing = false;
	this.goodLuckEvent = false;
	this.badLuckEvent = false;
	this.hasFreeWillEvents = false;
	this.ectoBiologyStarted = false;
	this.doomedTimeline = false;
	this.makeCombinedSession = false; //happens if sick frog and few living players
	this.scratched = false;
	this.scratchAvailable = false;
	this.timeTillReckoning = 0;
	this.reckoningEndsAt = -15;
	this.godTier = false;
	this.grimDarkPlayers = false;
	this.questBed = false;
	this.sacrificialSlab = false;
	this.sessionType = -999
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
	this.yellowYard = false;
	this.yellowYardController = new YellowYardResultController();//don't expect doomed time clones to follow them to any new sessions

	this.destroyBlackRing = function(){
		this.queensRing = null;
		this.jack.crowned = null;
		this.queen.crowned = null;
	}
	
	
	//space stuck needs love
	this.findBestSpace = function(){
		var spaces = findAllAspectPlayers(this.players, "Space");
		var ret = spaces[0];
		for(var i = 0; i<spaces.length; i++){
			if(spaces[i].landLevel > ret.landLevel) ret = spaces[i];
		}
		return ret;
	}
	
	this.findMostCorruptedSpace = function(){
		var spaces = findAllAspectPlayers(this.players, "Space");
		var ret = spaces[0];
		for(var i = 0; i<spaces.length; i++){
			if(spaces[i].landLevel< ret.landLevel) ret = spaces[i];
		}
		return ret;  //lowest space player.
	}

	//IMPORTANT do not add important events directly, or can't check for alternate timelines.
	//oh god, just typing that gives me chills. time shenanigans are so great.
	this.addImportantEvent = function(important_event){
		var alternate = this.yellowYardController.doesEventNeedToBeUndone(important_event);
	//	console.log("alternate i got from yellowYardController is: " + alternate)
		if(alternate){
		//	console.log("returning alternate")
		  if(doEventsMatch(important_event, this.afterLife.timeLineSplitsWhen,false))  this.afterLife.allowTransTimeLineInteraction();
			return alternate; //scene will use the alternate to go a different way. important event no longer happens.
		}else{
			//console.log(" pushing important event and returning null")
			this.importantEvents.push(important_event);
			return null;
		}
	}

	this.frogStatus = function(){
		var spacePlayer = this.findBestSpace();
		var corruptedSpacePlayer = this.findMostCorruptedSpace();
		var spacePlayer = findAspectPlayer(this.players, "Space");
		if(corruptedSpacePlayer.landLevel <= this.goodFrogLevel * -1) return "Purple Frog" //is this...a REFRANCE???
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
		//when I reset, need things to go the same. that includes having no ghosts interact with the session. figure out how to renable them once my event happens again.
		this.afterLife.complyWithLifeTimeShenanigans(e);
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
		checkEasterEgg(this.easterCallBack,this); //in the controller.

	}

	//will lose 'this' in the callback process, so take it in as that.
	this.easterCallBack = function(that){
		//now that i've done that, (for seed reasons) fucking ignore it and stick the actual players in
		//after alll, i could be from a combo session.
		//but don't just hardcore replace. need to...fuck. okay, cloning aliens now.
		curSessionGlobalVar.aliensClonedOnArrival = that.aliensClonedOnArrival;
		//console.log("adding this many clone aliens: " + curSessionGlobalVar.aliensClonedOnArrival.length)
		//console.log(getPlayersTitles(curSessionGlobalVar.aliensClonedOnArrival));
		var aliens = []  //if don't make copy of aliensClonedOnArrival, goes into an infinite loop as it loops on it and adds to it inside of addAliens
		for(var i = 0; i<that.aliensClonedOnArrival.length; i++){
			aliens.push(that.aliensClonedOnArrival[i])
		}
		that.aliensClonedOnArrival = [];//jettison old clones.
		addAliensToSession(curSessionGlobalVar, aliens);

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
		newSession.afterLife = this.afterLife; //afterlife carries over.
		newSession.dreamBubbleAfterlife = this.dreamBubbleAfterlife; //this, too
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
		addAliensToSession(newSession, this.players); //used to only bring players, but that broke shipping. shipping is clearly paramount to Skaia, because everything fucking crashes if shipping is compromised.


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
	//DEFINITELY don't erase the afterlife. that's the whole point.
	this.reinit = function(){
		groundHog = false;
		Math.seed = this.session_id; //if session is reset,
		//console.log("reinit with seed: "  + Math.seed)
		this.timeTillReckoning = getRandomInt(10,30);
		this.sessionType = Math.seededRandom();
		this.available_scenes = [];  //need a fresh slate because UpdateShippingGrid has MEMORY unlike all other scenes.
		createScenesForSession(this);
		//curSessionGlobalVar.available_scenes = curSessionGlobalVar.scenes.slice(0);
		//curSessionGlobalVar.doomedTimeline = false;
		this.doomedTimeline = false;
		this.setUpBosses();
		this.democracyStrength = 0;
		this.reckoningStarted = false;
		this.importantEvents = [];
		this.rocksFell = false;  //sessions where rocks fell screw over their scratched and yarded iterations, dunkass
		this.doomedTimelineReasons = [];
		this.ectoBiologyStarted = false;

	}

	this.makePlayers = function(){
		//console.log("Making players with seed: " + Math.seed)
		this.players = [];
		available_classes = classes.slice(0); //re-initPlayers available classes.
		available_classes_guardians = classes.slice(0);
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
		}

		decideInitialQuadrants(this.players);

		this.hardStrength = 300 + 50 * this.players.length;
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
		}else{
			return "???"
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
				player.makeGuardian();
				guardians.push(player.guardian)
		}

		for(var j = 0; j<this.players.length; j++){
			var g = this.players[j].guardian;
			g.generateRelationships(guardians);
		}
		decideInitialQuadrants(guardians);
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




	this.getSessionType = function(){
		if(this.sessionType > .6){
			return "Human"
		}else if(this.sessionType > .3){
			return "Troll"
		}
		return "Mixed"
	}


	this.setUpBosses = function(){
		this.queensRing = new GameEntity(this, "!!!RING!!! OMG YOU SHOULD NEVER SEE THIS!",false)
		this.queensRing.setStats(0,0,0,0,0,0,0,false, false, [],1000);
		var f = new Fraymotif([],  "Red Miles", 3)
		f.effects.push(new FraymotifEffect("power",2,true));
		f.flavorText = " You cannot escape them "
		this.queensRing.fraymotifs.push(f);

		this.kingsScepter = new GameEntity(this, "!!!SCEPTER!!! OMG YOU SHOULD NEVER SEE THIS!",false)
		this.kingsScepter.setStats(0,0,0,0,0,0,0,false, false, [],1000);
		var f = new Fraymotif([],  "Reckoning Meteors", 3)  //TODO eventually check for this fraymotif (just lik you do troll psionics) to decide if you can start recknoing.
		f.effects.push(new FraymotifEffect("power",2,true));
		f.flavorText = " The very meteors from the Reckoning rain down. "
		this.kingsScepter.fraymotifs.push(f);
		
		this.king = new GameEntity(this, "Black King", this.kingsScepter);
		//minLuck, maxLuck, hp, mobility, sanity, freeWill, power, abscondable, canAbscond, framotifs
		this.king.setStats(-10,10,1000,0,0,-100,100,false, false, [],1000); //royalty have no free will
		this.queen = new GameEntity(this, "Black Queen",this.queensRing);
		this.queen.setStats(-10,10,500,10,0,-100,50,false, false, [],1000); //red miles, put on ring
		this.queen.carapacian = true;
		this.king.carapacian = true;

		this.jack = new GameEntity(this, "Jack",null);
		this.jack.carapacian = true;
		this.jack.setStats(-500,-10,20,-50,-100,1000,40,true, true, [],100000); //jack is kind of a big deal. luck determines his odds of finding bullshit weapon
		//jack uses "Stab to Meet You", it's not very effective (nobody seems to think his stabs are important until he's crowned.)
		var f = new Fraymotif([],  "Stab To Meet You", 1)
		f.effects.push(new FraymotifEffect("power",3,true));
		f.flavorText = " It's pretty much how he says 'Hello'. "
		this.jack.fraymotifs.push(f);

		this.democraticArmy = new GameEntity(this, "Democratic Army",null); //doesn't actually exist till WV does his thing.
		this.democraticArmy.carapacian = true;
		this.democraticArmy.setStats(0,0,0,0,0,0,0,false, false, [],1000);
		var f = new Fraymotif([],  "Democracy Charge", 2)
		f.effects.push(new FraymotifEffect("power",3,true));
		f.flavorText = " The people have chosen to Rise Up against their oppressors. "
		this.democraticArmy.fraymotifs.push(f);


	}




	this.toString = function() {
		return this.session_id
	}

	this.newScene = function(){
		this.currentSceneNum ++;
		var div;
		if(this.sbahj){
			div = "<div class = 'scene' id='scene"+this.currentSceneNum+"' style='";
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
			div += "' >"
			if(ouija == true) div += "<img class = 'pen15' src = 'images/pen15_bg1.png'>" //can't forget the dicks
			div += "</div>";
		}else if(ouija == true){
			var trueRandom = getRandomIntNoSeed(1,4);
			div = "<div class = 'scene' id='scene"+this.currentSceneNum+"'>"
			div += "<img class = 'pen15' src = 'images/pen15_bg"+ trueRandom+".png'>"
			div += "</div>";
		}else{
			div = "<div class = 'scene' id='scene"+this.currentSceneNum+"'></div>";
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
		summary.setMiniPlayers(this.players);
		summary.blackKingDead = this.king.dead || this.king.getStat("currentHP") <=0
		summary.mayorEnding = this.mayorEnding;
		summary.waywardVagabondEnding = this.waywardVagabondEnding;
		summary.badBreakDeath = this.badBreakDeath;
		summary.luckyGodTier = this.luckyGodTier;
		summary.choseGodTier = this.choseGodTier;
		summary.scratched = this.scratched;
		summary.opossumVictory = this.opossumVictory;
		summary.rocksFell = this.rocksFell;
		summary.won = this.won;
		summary.hasBreakups = this.hasBreakups;
		summary.ghosts = this.afterLife.ghosts;
		summary.sizeOfAfterLife = this.afterLife.ghosts.length;
		summary.heroicDeath = this.heroicDeath;
		summary.justDeath = this.justDeath;
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
		summary.averageSanity = getAverageSanity(this.players);
		summary.session_id = this.session_id;
		summary.hasLuckyEvents = this.goodLuckEvent;
		summary.hasUnluckyEvents = this.badLuckEvent;
		summary.rapBattle = this.rapBattle;
		summary.sickFires = this.sickFires;
		summary.frogStatus = this.frogStatus();
		summary.godTier = this.godTier;
		summary.questBed = this.questBed;
		summary.sacrificialSlab = this.sacrificialSlab;
		summary.num_scenes = this.numScenes;
		summary.players = this.players;
		summary.mvp = findStrongestPlayer(this.players);
		summary.parentSession = this.parentSession;
		summary.scratchAvailable = this.scratchAvailable;
		summary.yellowYard = this.yellowYard
		summary.numLiving =  findLivingPlayers(this.players).length;
		summary.numDead =  findDeadPlayers(this.players).length;
		summary.ectoBiologyStarted = this.ectoBiologyStarted;
		summary.denizenBeat = this.denizenBeat;
		summary.plannedToExileJack = this.plannedToExileJack;
		summary.exiledJack = this.jack.exiled;
		summary.exiledQueen = this.queen.exiled;
		summary.jackGotWeapon = this.jackGotWeapon;
		summary.jackRampage = this.jackRampage;
		summary.jackScheme = this.jackScheme;
		summary.kingTooPowerful =  this.king.getStat("power")> this.hardStrength;
		summary.queenRejectRing = this.queenRejectRing;
		summary.democracyStarted =  this.democraticArmy.power > 0;
		summary.murderMode = this.murdersHappened;
		summary.grimDark = this.grimDarkPlayers;

		var spacePlayer = this.findBestSpace();
		var corruptedSpacePlayer = this.findMostCorruptedSpace();
		if(summary.frogStatus == "Purple Frog" ){
			summary.frogLevel =corruptedSpacePlayer.landLevel
		}else{
			summary.frogLevel =spacePlayer.landLevel
		}
		
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
	function addAliensToSession (newSession, aliens){
		//console.log("in method, adding aliens to session")
		for(var i = 0; i<aliens.length; i++){
			var survivor = aliens[i];
			survivor.land = null;
			survivor.dreamSelf = false;
			survivor.godDestiny = false;
			survivor.leader = false;
		}
		//save a copy of the alien players in case this session has time shenanigans happen

		for(var i = 0; i<aliens.length; i++){
			var survivor = aliens[i];
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
		for(var i = 0; i<aliens.length; i++){
			var survivor = aliens[i];
			//console.log(survivor.title() + " generating relationship with new players ")
			survivor.generateRelationships(newSession.players); //don't need to regenerate relationship with your old friends
		}


		for(var j= 0; j<newSession.players.length; j++){
			var player = newSession.players[j];
			player.generateRelationships(aliens);
		}

		for(var i = 0; i<aliens.length; i++){
			for(var j= 0; j<newSession.players.length; j++){
					var player = newSession.players[j];
					var survivor = aliens[i];
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

	newSession.players= newSession.players.concat(aliens);
}
