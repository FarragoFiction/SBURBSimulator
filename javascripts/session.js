//okay, fine, yes, global variables are getting untenable.
function Session(session_id){
	this.session_id = session_id; //initial seed
	this.players = [];
	this.guardians = [];
	this.kingStrength = 100;
	this.queenStrength = 100;
	this.jackStrength = 50;
	this.hardStrength = 275;
	this.minFrogLevel = 18;
	this.goodFrogLevel = 28;
	this.democracyStrength = 0;
	this.reckoningStarted = false;
	this.murdersHappened = false;
	this.ectoBiologyStarted = false;
	this.doomedTimeline = false;
	this.makeCombinedSession = false; //happens if sick frog and few living players
	this.scratched = false;
	this.scratchAvailable = false;
	this.timeTillReckoning = 0;
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


	//child sessions are basically any session with an ID that matches the seed you stop on
	//TODO could possibly be constrained to need a space or time player to navigage. or godtier light/doom??? could further require the player be from derse
	this.initializeCombinedSession = function(){
		var living = findLivingPlayers(this.players);
		//nobody is the leader anymore.
		var newSession = new Session(Math.seed);  //this is a real session that could have gone on without these new players.
		newSession.currentSceneNum = this.currentSceneNum;
		newSession.makePlayers();
		newSession.randomizeEntryOrder();
		newSession.makeGuardians();
		if(living.length + newSession.players.length > 12){
			//console.log("New session " + newSession.session_id +" cannot support living players. Already has " + newSession.players.length + " and would need to add: " + living.length)
			return;  //their child session is not able to support them
		}
		//console.log("TODO add a method for a session to simulate itself. if this session EVER can support the new players, insert them there");
		for(var i = 0; i<living.length; i++){
			var survivor = living[i];
			survivor.land = null;
			survivor.dreamSelf = false;
			survivor.godDestiny = false;
			survivor.leader = false;
			survivor.generateRelationships(newSession.players); //don't need to regenerate relationship with your old friends
			for(var j= 0; j<newSession.players.length; j++){
				var player = newSession.players[j];
				player.generateRelationships(living);
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
		this.hadCombinedSession = true;
		newSession.parentSession = this.session_id;
		createScenesForSession(newSession);
		console.log("Session: " + this.session_id + " has made child universe: " + newSession.session_id)
		return newSession;
	}

	this.reinit = function(){
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

		for(var k = 0; k<this.players.length; k++){
			//can't escape consequences.
			this.players[k].consequencesForGoodPlayer();
			this.players[k].consequencesForTerriblePlayer();
		}
	}

	this.makeGuardians = function(){
		this.guardians = [];
		//console.log("Making guardians")
		available_classes = classes.slice(0);
		available_aspects = nonrequired_aspects.slice(0); //required_aspects
		available_aspects = available_aspects.concat(required_aspects.slice(0));
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
				this.guardians.push(guardian);
		}

		for(var j = 0; j<this.guardians.length; j++){
			var g = this.guardians[j];
			g.generateRelationships(this.guardians);
		}

		for(var k = 0; k<this.guardians.length; k++){
			//can't escape consequences.
			this.guardians[k].consequencesForGoodPlayer();
			this.guardians[k].consequencesForTerriblePlayer();
		}
	}

	this.randomizeEntryOrder = function(){
		this.players = shuffle(this.players);
		this.players[0].leader = true;
	}

	this.decideTroll = function decideTroll(player){
		if(this.getSessionType() == "Human"){
			return;
		}

		if(this.getSessionType() == "Troll" || (this.getSessionType() == "Mixed" &&Math.seededRandom() > 0.5) ){
			player.isTroll = true;
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
		var div = "<div id='scene"+this.currentSceneNum+"'></div>";
		$("#story").append(div);
		return $("#scene"+this.currentSceneNum);
	}

	this.summarize = function(){
		var strongest = findStrongestPlayer(this.players)
		var str = "<a href = 'index2.html?seed="+ this.session_id +"'>Session: " + this.session_id + "</a> scenes: " + this.scenesTriggered.length + " Leader:  " + getLeader(this.players).title() + " MVP: " + strongest.htmlTitle()+ " with a power of: " + strongest.power;;
		if(this.scratchAvailable == true){
			str += "<br><b>&nbsp&nbsp&nbsp&nbspScratch Available</b>"
		}

		if(this.parentSession != null){
			str += "<br><b>&nbsp&nbsp&nbsp&nbspCombined Session From: " + this.parentSession + "</b>"
			//timesComboSession ++;
		}
		var living = findLivingPlayers(this.players);
		str += "<br><b>&nbsp&nbsp&nbsp&nbspLiving Players: " + living.length+ "</b>"
		if(living.length == 0){
			timesTotalPartyWipe ++;
		}
		var tmp = "";
		tmp =  summarizeScene(this.scenesTriggered, "DoEctobiology")
		if(findSceneNamed(this.scenesTriggered,"DoEctobiology") != "No"){
			timesEcto ++;
		}

		str += tmp;

		tmp =  summarizeScene(this.scenesTriggered, "FaceDenizen")
		if(findSceneNamed(this.scenesTriggered,"FaceDenizen") != "No"){
			timesDenizen ++;
		}
		str += tmp;


		tmp =  summarizeScene(this.scenesTriggered, "PlanToExileJack")
		if(findSceneNamed(this.scenesTriggered,"PlanToExileJack") != "No"){
			timesPlanExileJack ++;
		}
		str += tmp;

		tmp =  summarizeScene(this.scenesTriggered, "ExileJack")
		if(findSceneNamed(this.scenesTriggered,"ExileJack") != "No"){
			timesExileJack ++;
		}
		str += tmp;


		tmp =  summarizeScene(this.scenesTriggered, "ExileQueen")
		if(findSceneNamed(this.scenesTriggered,"ExileQueen") != "No"){
			timesExileQueen ++;
		}
		str += tmp;


		tmp =  summarizeScene(this.scenesTriggered, "GiveJackBullshitWeapon")
		if(findSceneNamed(this.scenesTriggered,"GiveJackBullshitWeapon") != "No"){
			timesJackWeapon ++;
		}
		str += tmp;

		tmp =  summarizeScene(this.scenesTriggered, "JackBeginScheming")
		if(findSceneNamed(this.scenesTriggered,"JackBeginScheming") != "No"){
			timesJackScheme ++;
		}
		str += tmp;


		tmp =  summarizeScene(this.scenesTriggered, "JackPromotion")
		if(findSceneNamed(this.scenesTriggered,"JackPromotion") != "No"){
			timesJackPromotion ++;
		}
		str += tmp;

		tmp =  summarizeScene(this.scenesTriggered, "JackRampage")
		if(findSceneNamed(this.scenesTriggered,"JackRampage") != "No"){
			timesJackRampage ++;
		}
		str += tmp;


		tmp =  summarizeScene(this.scenesTriggered, "KingPowerful")
		if(findSceneNamed(this.scenesTriggered,"KingPowerful") != "No"){
			timesKingPowerful ++;
		}
		str += tmp;

		tmp =  summarizeScene(this.scenesTriggered, "QueenRejectRing")
		if(findSceneNamed(this.scenesTriggered,"QueenRejectRing") != "No"){
			timesQueenRejectRing ++;
		}
		str += tmp;


	  //stats for this will happen in checkDoomedTimeLines
		str += summarizeScene(this.scenesTriggered, "SaveDoomedTimeLine") + this.doomedTimelineReasons;

		tmp =  summarizeScene(this.scenesTriggered, "StartDemocracy")
		if(findSceneNamed(this.scenesTriggered,"StartDemocracy") != "No"){
			timesDemocracyStart ++;
		}
		str += tmp;

		tmp =  summarizeScene(this.scenesTriggered, "EngageMurderMode")
		if(findSceneNamed(this.scenesTriggered,"EngageMurderMode") != "No"){
			timesMurderMode ++;
		}
		str += tmp;
		//murdersHappened

		tmp =  summarizeScene(this.scenesTriggered, "MurderPlayers")
		if(findSceneNamed(this.scenesTriggered,"MurderPlayers") != "No"){
			this.murdersHappened = true;
		}
		str += tmp;

		tmp =  summarizeScene(this.scenesTriggered, "GoGrimDark")
		if(findSceneNamed(this.scenesTriggered,"GoGrimDark") != "No"){
			timesGrimDark ++;
		}
		str += tmp;

		var spacePlayer = findAspectPlayer(this.players, "Space");
		var result = "No Frog"

		if(spacePlayer.landLevel >= this.minFrogLevel){
			if(spacePlayer.landLevel < this.goodFrogLevel){
				timesSickFrog ++;
				result = "Sick Frog"

			}else{
				timesFullFrog ++;
				result = "Full Frog"
			}
		}else{
			timesNoFrog ++;
		}
		totalFrogLevel += spacePlayer.landLevel;
		str += "<br>&nbsp&nbsp&nbsp&nbspFrog Breeding: " + result +  " (" + spacePlayer.landLevel +")"

		checkDoomedTimelines();
		return(str)

	}
}

function summarizeScene(scenesTriggered, str){
	var tmp = findSceneNamed(scenesTriggered,str)
	if(tmp != "No"){
		tmp = "Yes"
	}
	return "<br>&nbsp&nbsp&nbsp&nbsp" +str + " : " + tmp
}

function findSceneNamed(scenesToCheck, name){
	for(var i = 0; i<scenesToCheck.length; i++){
		if(scenesToCheck[i].constructor.name == name){
			return scenesToCheck[i];
		}
	}
	return "No"
}
