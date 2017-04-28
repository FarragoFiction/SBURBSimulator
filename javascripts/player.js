function Player(session,class_name, aspect, kernel_sprite, moon, godDestiny,id){

  //call if I overrode claspect or interest or anything
	this.reinit = function(){
		//console.log("player reinit");
		this.chatHandle = getRandomChatHandle(this.class_name,this.aspect,this.interest1, this.interest2);
		this.mylevels = getLevelArray(this);//make them ahead of time for echeladder graphic
		var tmp = getRandomLandFromPlayer(this);
		this.land1 = tmp[0]
		this.land2 = tmp[1];
		this.land = "Land of " + tmp[0] + " and " + tmp[1];
	}
	this.baby = null;
	this.session = session;
	this.hp = 0; //mostly used for boss battles;
	this.graphs = [];
	this.id = id;
	this.ghostPacts = []; //some classes can form pacts with ghosts for use in boss battles. or help others do so.  if i actually use a ghost i have a pact with, it's drained. (so anybody else with a pact with it can't use it.)
	this.land1 = null; //words my land is made of.
	this.land2 = null;
	this.minLuck = 0;
	this.maxLuck = 0;
	this.freeWill = 0;
	this.mobility = 0;
	this.trickster = false;
	this.sbahj = false;
	this.sickRhymes = []; //oh hell yes. Hell. FUCKING. Yes!
	this.robot = false;
	this.ectoBiologicalSource = null; //might not be created in their own session now.
	this.class_name = class_name;
	this.guardian = null; //no longer the sessions job to keep track.
	this.number_confessions = 0;
	this.number_times_confessed_to = 0;
	this.baby_stuck = false;
	this.influenceSymbol = null; //multiple aspects can influence/mind control.
	this.influencePlayer = null; //who is controlling me? (so i can break free if i have more free will or they die)
	this.stateBackup = null; //if you get influenced by something, here's where your true self is stored until you break free.
	this.aspect = aspect;
	this.land = null;
	this.interest1 =null;
	this.interest2 = null;
	this.chatHandle = null;
	this.kernel_sprite = kernel_sprite;
	this.relationships = [];
	this.moon = moon;
	this.power = 1;   //power is generic. generally scales with any aplicable stats. lets me compare two different aspect players.
	this.leveledTheHellUp = false; //triggers level up scene.
	this.mylevels = null
	this.level_index = -1; //will be ++ before i query
	this.godTier = false;
	this.victimBlood = null; //used for murdermode players.
	this.hair = null
	//this.hair = 16;
	this.hairColor = null
	this.dreamSelf = true;
	this.isTroll = false; //later
	this.bloodColor = "#ff0000" //human red.
	this.leftHorn = null;
	this.rightHorn = null;
	this.lusus = "Adult Human"
	this.quirk = null;
	this.dead = false;
	this.godDestiny = godDestiny;
	//should only be false if killed permananetly as god tier
	this.canGodTierRevive = true;  //even if a god tier perma dies, a life or time player or whatever can brings them back.
	this.isDreamSelf = false;
	//players can be triggered for various things. higher their triggerLevle, greater chance of going murdermode or GrimDark.
	this.triggerLevel = -2; //make up for moon bonus
	this.murderMode = false;  //kill all players you don't like. odds of a just death skyrockets.
	this.leftMurderMode = false; //have scars, unless left via death.
	this.corruptionLevelOther = 0; //every 100 points, sends you to next grimDarkLevel.
	this.grimDark = 0;  //  0 = none, 1 = some, 2 = some more 3 = full grim dark with aura and font and everything.
	this.leader = false;
	this.landLevel = 0; //at 10, you can challenge denizen.  only space player can go over 100 (breed better universe.)
	this.denizenFaced = false; //when faced, you double in power (including future power increases.)
	this.denizenDefeated = false;
	this.causeOfDeath = ""; //fill in every time you die. only matters if you're dead at end
	this.doomedTimeClones =  []; //help fight the final boss(es).


	this.fromThisSession = function(session){
		return (this.ectoBiologicalSource == null || this.ectoBiologicalSource == session.session_id)
	}

	this.getHearts = function(){
		var ret = [];
		for (var i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.heart){
				ret.push(r);
			}
		}
		return ret;
	}

	this.makeDead = function(causeOfDeath){
		this.dead = true;
		this.causeOfDeath = causeOfDeath;
		if(!this.godTier){ //god tiers only make ghosts in GodTierRevivial
			this.session.afterLife.addGhost(makeRenderingSnapshot(this));
		}
	}

	this.getSpades = function(){
		var ret = [];
		for (var i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.spades){
				ret.push(r);
			}
		}
		return ret;
	}

	this.getDiamonds = function(){
		var ret = [];
		for (var i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.diamond){
				ret.push(r);
			}
		}
		return ret;
	}


	this.chatHandleShort = function(){
		return this.chatHandle.match(/\b(\w)|[A-Z]/g).join('').toUpperCase();
	}

	this.chatHandleShortCheckDup = function(otherHandle){
		var tmp= this.chatHandle.match(/\b(\w)|[A-Z]/g).join('').toUpperCase();
		if(tmp == otherHandle){
			tmp = tmp + "2";
		}
		return tmp;
	}

		//people like them less and also they are more triggered.
	this.consequencesForTerriblePlayer  = function(){
		if((terrible_interests.indexOf(this.interest1) != -1)){
			this.damageAllRelationshipsWithMe();
			this.damageAllRelationshipsWithMe();
			this.damageAllRelationshipsWithMe();
			this.triggerLevel ++;
		}

		if((terrible_interests.indexOf(this.interest2) != -1)){
			this.damageAllRelationshipsWithMe();
			this.damageAllRelationshipsWithMe();
			this.damageAllRelationshipsWithMe();
			this.triggerLevel ++;
		}
	}

	//people like them more and also they are less triggered.
	this.consequencesForGoodPlayer = function(){
		if((social_interests.indexOf(this.interest1) != -1)){
			this.boostAllRelationshipsWithMe();
			this.boostAllRelationshipsWithMe();
			this.boostAllRelationshipsWithMe();
			this.triggerLevel +=-1;
		}

		if((social_interests.indexOf(this.interest2) != -1)){
			this.boostAllRelationshipsWithMe();
			this.boostAllRelationshipsWithMe();
			this.boostAllRelationshipsWithMe();
			this.triggerLevel +=-1;
		}
	}


	this.title = function(){
		var ret = "";

		if(this.murderMode){
			ret += "Murder Mode ";
		}

		if(this.grimDark>3){
			ret += "Severely Grim Dark ";
		}else if(this.grimDark > 1){
			ret += "Mildly Grim Dark ";
		}else if(this.grimDark >2){
			ret += "Grim Dark ";
		}

		if(this.godTier){
			ret+= "God Tier "
		}else if(this.isDreamSelf){
			ret+= "Dream ";
		}
		ret+= this.class_name + " of " + this.aspect;
		if(this.dead){
			ret += "'s Corpse"
		}else if(this.ghost){
			ret += "'s Ghost"
		}
		return ret;
	}

	this.htmlTitleBasic = function(){
			return getFontColorFromAspect(this.aspect) + this.titleBasic() + "</font>"
	}

	this.titleBasic = function(){
		var ret = "";

		ret+= this.class_name + " of " + this.aspect;
		return ret;
	}

	//old method from 1.0
	this.getRandomLevel = function(){
		if(Math.seededRandom() > .5){
			return getRandomLevelFromAspect(this.aspect);
		}else{
			return getRandomLevelFromClass(this.class_name);
		}
	}

//new method having to pick 16 levels before entering the medium
	this.getNextLevel = function(){
		this.level_index ++;
		var ret= this.mylevels[this.level_index];
		return ret;
	}

	this.getRandomQuest = function(){
		if(Math.seededRandom() > .5 || this.aspect == "Space"){ //space players pretty much only get FrogBreeding duty.
			return getRandomQuestFromAspect(this.aspect);
		}else{
			return getRandomQuestFromClass(this.class_name);
		}

	}

	this.decideHemoCaste  =function (){
		if(this.aspect != "Blood"){  //sorry karkat
			this.bloodColor = getRandomElementFromArray(bloodColors);
		}
	}

	this.decideLusus = function(player){
		if(this.bloodColor == "#610061" || this.bloodColor == "#99004d" || this.bloodColor == "#631db4" ){
			this.lusus = getRandomElementFromArray(seaLususTypes);
		}else{
			this.lusus = getRandomElementFromArray(landlususTypes);
		}
	}


	this.getDenizen = function(){
		return getDenizenFromAspect(this.aspect);
	}

	//more likely if lots of people hate you
	this.justDeath = function(){
		var ret = false;
		//if much less friends than enemies.
		if(this.getFriends().length < this.getEnemies().length){
			if(Math.seededRandom() > .9){ //just deaths are rarer without things like triggers.
				ret = true;
			}
			//way more likely to be a just death if you're being an asshole.


			if((this.murderMode || this.grimDark > 2)){
				var rand = Math.seededRandom()
				//console.log("rand is: " + rand)
				if(rand > .2){
					//console.log(" just death for: " + this.title() + "rand is: " + rand)
					ret = true;
				}
			}
		}else{  //you are a good person. just corrupt.
			//way more likely to be a just death if you're being an asshole.
			if((this.murderMode || this.grimDark > 2) && Math.seededRandom()>.5){
				ret = true;
			}
		}
		//console.log(ret);
		//return true; //for testing
		return ret;
	}

	//more likely if lots of people like you
	this.heroicDeath = function(){
		var ret = false;
		//if far more enemies than friends.
		if(this.getFriends().length > this.getEnemies().length ){
			if(Math.seededRandom() > .6){
				ret = true;
			}
			//extra likely if you just killed the king/queen, you hero you.
			if(curSessionGlobalVar.kingStrength <=0 && Math.seededRandom()>.2){
				ret = true;
			}
		}else{ //unlikely hero
			if(Math.seededRandom() > .8){
				ret = true;
			}
			//extra likely if you just killed the king/queen, you hero you.
			if(curSessionGlobalVar.kingStrength <=0 && Math.seededRandom()>.4){
				ret = true;
			}
		}

		if(ret){
			//console.log("heroic death");
		}
		return ret;
	}

	//luck is about sprinting towards good events, not avoiding bad ones. only modifies max luck.
	this.lightInteractionEffect = function(player){
		var amount = this.power/3;
		if(this.class_name == "Thief"){ //takes for self
			this.maxLuck += amount
			player.maxLuck += -1 * amount;
		}else if(this.class_name == "Rogue"){ //takes an distributes to others.
			player.maxLuck += -1 * amount;
			for(var i = 0; i<this.session.players.length; i++){
				var p = this.session.players[i];
				p.maxLuck += amount/this.session.players.length;
			}
		}else if(this.class_name == "Sylph"){ //heals others
			player.maxLuck += amount;
		}else if(this.class_name == "Bard"){ //destroys in others
			player.maxLuck += -1 * amount;
		}

	}

	this.mindInteractionEffect = function(player){
		var amount = this.power/3;
		if(this.class_name == "Thief"){ //takes for self
			this.freeWill += amount
			player.freeWill += -1*amount
		}else if(this.class_name == "Rogue"){ //takes an distributes to others.
			player.freeWill += -1*amount
			for(var i = 0; i<this.session.players.length; i++){
				var p = this.session.players[i];
				p.freeWill += amount/this.session.players.length;
			}
		}else if(this.class_name == "Sylph"){ //heals others
			player.freeWill += amount
		}else if(this.class_name == "Bard"){ //destroys in others
			player.freeWill += -1*amount
		}
	}

	this.timeInteractionEffect = function(player){
		var amount = -1 * this.power/3;
		if(this.class_name == "Thief"){ //takes for self
			this.freeWill += amount
			player.freeWill += -1*amount
		}else if(this.class_name == "Rogue"){ //takes an distributes to others.
			player.freeWill += -1*amount
			for(var i = 0; i<this.session.players.length; i++){
				var p = this.session.players[i];
				p.freeWill += amount/this.session.players.length;
			}
		}else if(this.class_name == "Sylph"){ //heals others
			player.freeWill += amount
		}else if(this.class_name == "Bard"){ //destroys in others
			player.freeWill += -1*amount
		}
	}


	this.lifeInteractionEffect = function(player){
		var amount = this.power/3;
		if(this.class_name == "Thief"){ //takes for self
			this.hp += amount;
			player.hp += -1*amount
		}else if(this.class_name == "Rogue"){ //takes an distributes to others.
			player.hp += -1*amount
			for(var i = 0; i<this.session.players.length; i++){
				var p = this.session.players[i];
				p.hp += amount/this.session.players.length;
			}
		}else if(this.class_name == "Sylph"){ //heals others
			player.hp += amount
		}else if(this.class_name == "Bard"){ //destroys in others
			player.hp += -1*amount
		}
	}

	this.rageInterctionEffect = function(player){
		var amount = this.power/10;
		if(this.class_name == "Thief"){ //takes for self
			this.triggerLevel += amount;
			player.triggerLevel += -1 * amount
			this.boostAllRelationshipsWithMeBy(amount);
			this.boostAllRelationshipsBy(amount)
			player.boostAllRelationshipsWithMeBy(-1*amount);
			player.boostAllRelationshipsBy(-1* amount)
		}else if(this.class_name == "Rogue"){ //takes an distributes to others.
			player.triggerLevel += -1*amount
			player.boostAllRelationshipsWithMeBy(-1*amount);
			player.boostAllRelationshipsBy(-1* amount)
			for(var i = 0; i<this.session.players.length; i++){
				var p = this.session.players[i];
				p.triggerLevel += amount/this.session.players.length;
				p.boostAllRelationshipsWithMeBy(amount);
				p.boostAllRelationshipsBy(amount)
			}
		}else if(this.class_name == "Sylph"){ //heals others 'healing' rage would increase it.
			player.triggerLevel += amount
			player.boostAllRelationshipsWithMeBy(amount);
			player.boostAllRelationshipsBy(amount)
		}else if(this.class_name == "Bard"){ //destroys in others
			player.triggerLevel += -1*amount
			player.boostAllRelationshipsWithMeBy(-1*amount);
			player.boostAllRelationshipsBy(-1* amount)
		}
	}

	this.heartInteractionEffect = function(player){
		var amount = this.power/10;
		if(this.class_name == "Thief"){ //takes for self
			this.boostAllRelationshipsBy(amount);
			player.boostAllRelationshipsBy(-1* amount)
		}else if(this.class_name == "Rogue"){ //takes an distributes to others.
			player.boostAllRelationshipsBy(-1*amount)
			for(var i = 0; i<this.session.players.length; i++){
				var p = this.session.players[i];
				p.boostAllRelationshipsBy(amount/this.session.players.length);
			}
		}else if(this.class_name == "Sylph"){ //heals others 'healing' rage would increase it.
			player.boostAllRelationshipsBy(amount);
		}else if(this.class_name == "Bard"){ //destroys in others
			player.boostAllRelationshipsBy(-1*amount)
		}
	}

	this.breathInteractionEffect = function(player){
		var amount = this.power/3;
		if(this.class_name == "Thief"){ //takes for self
			this.mobility += amount
			player.mobility += -1*amount
		}else if(this.class_name == "Rogue"){ //takes an distributes to others.
			player.mobility += -1*amount
			for(var i = 0; i<this.session.players.length; i++){
				var p = this.session.players[i];
				p.mobility += amount/this.session.players.length;
			}
		}else if(this.class_name == "Sylph"){ //heals others
			player.mobility += amount
		}else if(this.class_name == "Bard"){ //destroys in others
			player.mobility += -1*amount
		}
	}

	//space is sticky. stuck on your planet breeding frogs, stuck in brooding caverns.
	/*'Calliope has also stated that Space is a typically passive aspect with great power,
	falling back and hosting the stage before
	suddenly in some way showing "who is truly the master" and then collapsing in on itself. '
	Yeah, First Guardian Jade had teleport powers, but there was nothing to show that that was a NORMAL space ability.
	She only glowed green doing that, not when altering sizes.
	Space is about groundingyou. It's gravity. It's so damn HARD to travel in space, cause it wants you to stay right the hell where you are.
	*/
	this.spaceInteractionEffect = function(player){
		var amount = -1* this.power/3;
		if(this.class_name == "Thief"){ //takes for self
			this.mobility += amount
			player.mobility += -1*amount
		}else if(this.class_name == "Rogue"){ //takes an distributes to others.
			player.mobility += -1*amount
			for(var i = 0; i<this.session.players.length; i++){
				var p = this.session.players[i];
				p.mobility += amount/this.session.players.length;
			}
		}else if(this.class_name == "Sylph"){ //heals others
			player.mobility += amount
		}else if(this.class_name == "Bard"){ //destroys in others
			player.mobility += -1*amount
		}
	}

	this.bloodInteractionEffect = function(player){
		var amount = -1* this.power/10;
		if(this.class_name == "Thief"){ //takes for self
			this.triggerLevel += amount;
			player.triggerLevel += -1 * amount
			this.boostAllRelationshipsWithMeBy(-1*amount);
			player.boostAllRelationshipsWithMeBy(amount);
		}else if(this.class_name == "Rogue"){ //takes an distributes to others.
			player.triggerLevel += -1*amount
			player.boostAllRelationshipsWithMeBy(amount);
			for(var i = 0; i<this.session.players.length; i++){
				var p = this.session.players[i];
				p.triggerLevel += amount/this.session.players.length;
				p.boostAllRelationshipsWithMeBy(-1*amount);
			}
		}else if(this.class_name == "Sylph"){ //heals others 'healing' rage would increase it.
			player.triggerLevel += amount
			player.boostAllRelationshipsWithMeBy(-1*amount);
		}else if(this.class_name == "Bard"){ //destroys in others
			player.triggerLevel += -1*amount
			player.boostAllRelationshipsWithMeBy(amount);
		}
	}

	//doom is about bad ends. only modifies min luck. alkso modifies power directly
	this.doomInteractionEffect = function(player){
		var amount = -1* this.power/3; //
		if(this.class_name == "Thief"){ //takes for self
			this.hp += amount;
			this.minLuck += amount
			player.hp += -1*amount
			player.minLuck += -1*amount
		}else if(this.class_name == "Rogue"){ //takes an distributes to others.
			player.power += -1*amount
			player.minLuck += -1*amount
			for(var i = 0; i<this.session.players.length; i++){
				var p = this.session.players[i];
				p.hp += amount/this.session.players.length;
				p.minLuck += amount/this.session.players.length;
			}
		}else if(this.class_name == "Sylph"){ //heals others
			player.hp += amount
			player.minLuck += amount
		}else if(this.class_name == "Bard"){ //destroys in others
			player.hp += -1*amount
			player.minLuck += -1*amount
		}
	}

	this.hopeInteractionEffect = function(player){
		var amount = this.power/3;
		if(this.class_name == "Thief"){ //takes for self
			this.power += amount;
			player.power += -1*amount
		}else if(this.class_name == "Rogue"){ //takes an distributes to others.
			player.power += -1*amount
			for(var i = 0; i<this.session.players.length; i++){
				var p = this.session.players[i];
				p.power += amount/this.session.players.length;
			}
		}else if(this.class_name == "Sylph"){ //heals others
			player.power += amount
		}else if(this.class_name == "Bard"){ //destroys in others
			player.power += -1*amount
		}
	}

	this.voidInteractionEffect = function(player){
		//void does nothing innately, modifies things at random.
		var statInteractions = [this.lightInteractionEffect.bind(this,player),this.mindInteractionEffect.bind(this,player),this.timeInteractionEffect.bind(this,player),this.lifeInteractionEffect.bind(this,player),this.rageInterctionEffect.bind(this,player),this.heartInteractionEffect.bind(this,player),this.breathInteractionEffect.bind(this,player),this.spaceInteractionEffect.bind(this,player),this.bloodInteractionEffect.bind(this,player),this.doomInteractionEffect.bind(this,player),this.hopeInteractionEffect.bind(this,player)];
		getRandomElementFromArray(statInteractions)();
	}


	this.interactionEffect = function(player){
		if(this.aspect == "Light"){
			this.lightInteractionEffect(player);
		}else if(this.aspect =="Doom"){
			this.doomInteractionEffect(player);
		}else if(this.aspect =="Blood"){
			this.bloodInteractionEffect(player);
		}else if(this.aspect =="Rage"){
			this.rageInterctionEffect(player);
		}else if(this.aspect =="Heart"){
			this.heartInteractionEffect(player);
		}else if(this.aspect =="Breath"){
			this.breathInteractionEffect(player);
		}else if(this.aspect =="Hope"){
			this.hopeInteractionEffect(player);
		}else if(this.aspect =="Mind"){
			this.mindInteractionEffect(player);
		}else if(this.aspect =="Life"){
			this.lifeInteractionEffect(player);
		}else if(this.aspect =="Void"){
			this.voidInteractionEffect(player);
		}else if(this.aspect =="Space"){
			this.spaceInteractionEffect(player);
		}else if(this.aspect =="Time"){
			this.timeInteractionEffect(player);
		}
		//no longer do this seperate. if close enough to modify with powers, close enough to be...closer.
		r1 = this.getRelationshipWith(player);
		if(r1){
			r1.moreOfSame();
		}
		
	}

	//SBURB is not a mystery to these classes/aspects.
	this.knowsAboutSburb = function(){
		var rightClass = this.class_name == "Seer" || this.aspect == "Light" || this.aspect == "Mind" || this.aspect == "Doom"
		return rightClass && this.power > 20; //need to be far enough in my claspect
	}

	this.performEctobiology = function(session){
		session.ectoBiologyStarted = true;
		playersMade = findPlayersWithoutEctobiologicalSource(session.players);
		setEctobiologicalSource(playersMade, session.session_id)
	}

	this.isActive = function(){
		return (this.class_name == "Thief" || this.class_name == "Knight" || this.class_name == "Heir"|| this.class_name == "Mage"|| this.class_name == "Witch"|| this.class_name == "Prince")
	}

	this.hopeIncreasePower = function(powerBoost){
		var power = powerBoost/10;
		if(this.class_name == "Prince" || this.class_name == "Bard"){
			power = -1 *power;
		}

		if(this.isActive()){ //modify me
			this.power += power;
		}else{  //modify others.
			for(var i = 0; i<this.session.players.length; i++){
				var player = this.session.players[i];
				player.power += power;
			}
		}
	}
	//only looks at best outcomes
	this.lightIncreasePower = function(powerBoost){
		var luckModifier = powerBoost*3;
		if(this.class_name == "Prince" || this.class_name == "Bard"){
			luckModifier = -1 *luckModifier;
		}

		if(this.isActive()){ //modify me
			this.maxLuck += luckModifier;
		}else{  //modify others.
			for(var i = 0; i<this.session.players.length; i++){
				var player = this.session.players[i];
				player.maxLuck += luckModifier;
			}
		}
	}

	this.mindIncreasePower = function(powerBoost){
		var modifier = powerBoost*3;
		if(this.class_name == "Prince" || this.class_name == "Bard"){
			modifier = -1 *modifier;
		}

		if(this.isActive()){ //modify me
			this.freeWill += modifier;
		}else{  //modify others.
			for(var i = 0; i<this.session.players.length; i++){
				var player = this.session.players[i];
				player.freeWill += modifier;
			}
		}
	}

	//time is about fate and inevitability, not decisions and free will.
	this.timeIncreasePower = function(powerBoost){
		var modifier = -1 * powerBoost*3;
		if(this.class_name == "Prince" || this.class_name == "Bard"){
			modifier = -1 *modifier;
		}

		if(this.isActive()){ //modify me
			this.freeWill += modifier;
		}else{  //modify others.
			for(var i = 0; i<this.session.players.length; i++){
				var player = this.session.players[i];
				player.freeWill += modifier;
			}
		}
	}

	this.doomIncreasePower = function(powerBoost){
		var power = -1 * powerBoost; //over 2 stats.
		if(this.class_name == "Prince" || this.class_name == "Bard"){
			power = -1 *power;
		}

		if(this.isActive()){ //modify me
			this.hp += power;
			this.minLuck += power;
		}else{  //modify others.
			for(var i = 0; i<this.session.players.length; i++){
				var player = this.session.players[i];
				player.hp += power;
				this.minLuck += power;
			}
		}
	}

	this.lifeIncreasePower = function(powerBoost){
		var landBoost = powerBoost/100;
		if(this.class_name == "Prince" || this.class_name == "Bard"){
			landBoost = -1 *landBoost;
		}

		if(this.isActive()){ //modify me
			this.hp += landBoost;
		}else{  //modify others.
			for(var i = 0; i<this.session.players.length; i++){
				var player = this.session.players[i];
				player.hp += landBoost;
			}
		}
	}


	//wanted this to modify relationships, but figured i'd give that to heart
	//blood keeps people from killing each other.
	this.bloodIncreasePower = function(powerBoost){
		var triggerModifier = -1*powerBoost/10;
		if(this.class_name == "Prince" || this.class_name == "Bard"){
			triggerModifier = -1 *triggerModifier;
		}

		if(this.isActive()){ //modify me
			this.triggerLevel += triggerModifier;
			this.boostAllRelationshipsWithMeBy(-1*triggerModifier);
		}else{  //modify others.
			for(var i = 0; i<this.session.players.length; i++){
				var player = this.session.players[i];
				player.triggerLevel += triggerModifier;
				player.boostAllRelationshipsWithMeBy(-1*triggerModifier);
			}
		}
	}

	this.rageIncreasePower = function(powerBoost){
		var triggerModifier = powerBoost/10;
		if(this.class_name == "Prince" || this.class_name == "Bard"){
			triggerModifier = -1 *triggerModifier;
		}

		if(this.isActive()){ //modify me
			this.triggerLevel += powerBoost;
			this.boostAllRelationshipsWithMeBy(-1*triggerModifier);
			this.boostAllRelationshipsBy(-1*triggerModifier);

		}else{  //modify others.
			for(var i = 0; i<this.session.players.length; i++){
				var player = this.session.players[i];
				player.triggerLevel += triggerModifier;
				player.boostAllRelationshipsWithMeBy(-1*triggerModifier);
				player.boostAllRelationshipsBy(-1*triggerModifier);
			}
		}
	}

	this.heartIncreasePower = function(powerBoost){
		var relationshipModifier = powerBoost/10;
		if(this.class_name == "Prince" || this.class_name == "Bard"){
			relationshipModifier = -1 *relationshipModifier;
		}

		if(this.isActive()){ //modify me
			this.boostAllRelationshipsBy(relationshipModifier);
		}else{  //modify others.
			for(var i = 0; i<this.session.players.length; i++){
				var player = this.session.players[i];
				player.boostAllRelationshipsBy(relationshipModifier);
			}
		}
	}


	this.breathIncreasePower = function(powerBoost){
		var mobilityModifier = powerBoost*3;
		if(this.class_name == "Prince" || this.class_name == "Bard"){
			mobilityModifier = -1 *mobilityModifier;
		}

		if(this.isActive()){ //modify me
			this.mobility += mobilityModifier;
		}else{  //modify others.
			for(var i = 0; i<this.session.players.length; i++){
				var player = this.session.players[i];
				player.mobility += mobilityModifier;
			}
		}
	}

	this.spaceIncreasePower = function(powerBoost){
		var mobilityModifier = -1 * powerBoost*3;
		if(this.class_name == "Prince" || this.class_name == "Bard"){
			mobilityModifier = -1 *mobilityModifier;
		}

		if(this.isActive()){ //modify me
			this.mobility += mobilityModifier;
		}else{  //modify others.
			for(var i = 0; i<this.session.players.length; i++){
				var player = this.session.players[i];
				player.mobility += mobilityModifier;
			}
		}
	}

	//need to bind funtions so they know what 'this' is.
	this.voidIncreasePower = function(powerBoost){
		//void does nothing innately. random stat modifications.
		var statIncreases = [this.bloodIncreasePower.bind(this,powerBoost),this.rageIncreasePower.bind(this,powerBoost),this.heartIncreasePower.bind(this,powerBoost),this.breathIncreasePower.bind(this,powerBoost),this.spaceIncreasePower.bind(this,powerBoost),this.lifeIncreasePower.bind(this,powerBoost),this.doomIncreasePower.bind(this,powerBoost),this.timeIncreasePower.bind(this,powerBoost),this.mindIncreasePower.bind(this,powerBoost),this.lightIncreasePower.bind(this,powerBoost),this.hopeIncreasePower.bind(this,powerBoost)];
		getRandomElementFromArray(statIncreases)();
	}

	//everything but space and time, they are exempt because EVER session has them.
	//you could argue they are baked into things.
	this.aspectIncreasePower = function(powerBoost){
		if(this.aspect == "Light"){
			this.lightIncreasePower(powerBoost);
		}else if(this.aspect =="Doom"){
			this.doomIncreasePower(powerBoost);
		}else if(this.aspect =="Blood"){
			this.bloodIncreasePower(powerBoost);
		}else if(this.aspect =="Rage"){
			this.rageIncreasePower(powerBoost);
		}else if(this.aspect =="Heart"){
			this.heartIncreasePower(powerBoost);
		}else if(this.aspect =="Breath"){
			this.breathIncreasePower(powerBoost);
		}else if(this.aspect =="Hope"){
			this.hopeIncreasePower(powerBoost);
		}else if(this.aspect =="Mind"){
			this.mindIncreasePower(powerBoost);
		}else if(this.aspect =="Life"){
			this.lifeIncreasePower(powerBoost);
		}else if(this.aspect =="Void"){
			this.voidIncreasePower(powerBoost);
		}else if(this.aspect =="Time"){
			this.timeIncreasePower(powerBoost);
		}else if(this.aspect =="Space"){
			this.spaceIncreasePower(powerBoost);
		}
	}

	this.increasePower = function(){
		var powerBoost = 1;

		if(this.class_name == "Page"){  //they don't have many quests, but once they get going they are hard to stop.
			powerBoost = powerBoost * 5;
		}

		if(this.aspect == "Hope"){
			powerBoost = powerBoost * 2;
		}

		if(this.godTier){
			powerBoost = powerBoost * 20;  //god tiers are ridiculously strong.
		}

		if(this.denizenDefeated){
			powerBoost = powerBoost * 2; //permanent doubling of stats forever.
		}

		this.power += powerBoost;
		this.aspectIncreasePower(powerBoost);

		if(this.power % 10 == 0){ //actually a really bad way to determine level ups at this point. need to refactor later.
			this.leveledTheHellUp = true;
		}
	}

	this.shortLand = function(){
		return this.land.match(/\b(\w)/g).join('').toUpperCase();
	}

	this.htmlTitle = function(){
		return getFontColorFromAspect(this.aspect) + this.title() + "</font>"
	}

	this.htmlTitleBasic = function(){
		return getFontColorFromAspect(this.aspect) + this.titleBasic() + "</font>"
	}

	this.generateBlandRelationships = function(friends){
		for(var i = 0; i<friends.length; i++){
			if(friends[i] != this){  //No, Karkat, you can't be your own Kismesis.
				//one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
				//that it needs to be a thing.
				var r = randomBlandRelationship(friends[i])
				if(this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d"){
					r.value = -20; //biological imperitive to fight for throne.
					this.triggerLevel ++;
					friends[i].triggerLevel ++;
				}
				this.relationships.push(r);
			}
		}
	}

	this.generateRelationships = function(friends){
		for(var i = 0; i<friends.length; i++){
			if(friends[i] != this){  //No, Karkat, you can't be your own Kismesis.
				//one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
				//that it needs to be a thing.
				var r = randomRelationship(friends[i])
				if(this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d"){
					r.value = -20; //biological imperitive to fight for throne.
					this.triggerLevel ++;
					friends[i].triggerLevel ++;
				}
				this.relationships.push(r);
			}else{
				//console.log(this.title() + "Not generating a relationship with: " + friends[i].title());
			}
		}


	}

	this.checkBloodBoost = function(players){
		if(this.aspect == "Blood"){
			for(var i = 0; i<players.length; i++){
				players[i].boostAllRelationships();
			}
		}
	}

	this.nullAllRelationships = function(){
		for(var i = 0; i<this.relationships.length; i++){
			this.relationships[i].value = 0;
			this.relationships[i].saved_type = this.relationships[i].neutral;
		}
	}
	//you like people more
	this.boostAllRelationships = function(){
		for(var i = 0; i<this.relationships.length; i++){
			this.relationships[i].increase();
		}
	}

	this.boostAllRelationshipsBy = function(boost){
		for(var i = 0; i<this.relationships.length; i++){
			this.relationships[i].value += boost;
		}
	}

	//you like people less
	this.damageAllRelationships = function(){
		for(var i = 0; i<this.relationships.length; i++){
			this.relationships[i].decrease();
		}
	}

	this.boostAllRelationshipsWithMeBy = function(boost){
		for(var i = 0; i<this.relationships.length; i++){
			var player = this.relationships[i].target
			var r = this.getRelationshipWith(player)
			if(r){
				r.value += boost;
			}
		}
	}
	//people like you more
	this.boostAllRelationshipsWithMe = function(){
		for(var i = 0; i<this.relationships.length; i++){
			var player = this.relationships[i].target
			var r = this.getRelationshipWith(player)
			if(r){
				r.increase();
			}
		}
	}

	//initial values are between 0 and 100, but the sim will mod those over time.
	//it's up to the thing that calls this to know what a 'good' roll is.
	//couldn't really have implemented this without having authorBot have my back.
	//she'll help me make sure i don't make everything boring implmeenting luck.
	//luck can absolutely be negative. thems the breaks.
	this.rollForLuck = function(){
		return getRandomInt(this.minLuck, this.maxLuck);
	}

	//people like you less
	this.damageAllRelationshipsWithMe = function(){
		for(var i = 0; i<curSessionGlobalVar.players.length; i++){
			var r = this.getRelationshipWith(curSessionGlobalVar.players[i])
			if(r){
				r.decrease();
			}
		}
	}

	this.getAverageRelationshipValue = function(){
		if(this.relationships.length == 0) return 0;
		var ret = 0;
		for(var i = 0; i< this.relationships.length; i++){
			ret += this.relationships[i].value;
		}
		return ret/this.relationships.length;
	}

	//and they need to be alive.
	this.hasDiamond = function(){
		for(var i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].saved_type == this.relationships[i].diamond && !this.relationships[i].target.dead ){
				return this.relationships[i].target;
			}
		}
		return null;
	}

	this.hasDeadDiamond = function(){
		for(var i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].saved_type == this.relationships[i].diamond && this.relationships[i].target.dead ){
				return this.relationships[i].target;
			}
		}
		return null;
	}

	this.hasDeadHeart = function(){
		for(var i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].saved_type == this.relationships[i].heart && this.relationships[i].target.dead ){
				return this.relationships[i].target;
			}
		}
		return null;
	}



	this.getRelationshipWith = function(player){
		for(var i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].target == player){
				return this.relationships[i];
			}
		}
		//this should only be happening if this == player. what is going on here!???
		//ah, was trying to make consequences for interets before making relationships
		//console.log("I am : " + this.title() + " and I couldn't find a relationship with: " + player.title() + " even though I have this many relationships " + this.relationships.length);
	}

	this.getWhoLikesMeBestFromList = function(potentialFriends){
		var bestRelationshipSoFar = this.relationships[0];
		var friend = bestRelationshipSoFar.target;
		for(var i = 0; i<potentialFriends.length; i++){
			var p =  potentialFriends[i];
			if(p!=this){
				var r = p.getRelationshipWith(this);
				if(r && r.value > bestRelationshipSoFar.value){
					bestRelationshipSoFar = r;
					friend = p;
				}
			}
		}
		//can't be my best friend if they're an enemy
		if(bestRelationshipSoFar.value > 0 && potentialFriends.indexOf(friend) != -1){
			return friend;
		}
	}

	this.getWhoLikesMeLeastFromList = function(potentialFriends){
		var worstRelationshipSoFar = this.relationships[0];
		var enemy = worstRelationshipSoFar.target;
		for(var i = 0; i<potentialFriends.length; i++){
			var p =  potentialFriends[i];
			if(p != this){
				var r = p.getRelationshipWith(this);
				if(r && r.value < worstRelationshipSoFar.value){
					worstRelationshipSoFar = r;
					enemy = p;
				}
			}
		}
		//can't be my worst enemy if they're a friend.
		if(worstRelationshipSoFar.value < 0 && potentialFriends.indexOf(enemy) != -1){
			return enemy;
		}
	}

	this.hasRelationshipDrama = function(){
		for(var i = 0; i<this.relationships.length; i++){
			this.relationships[i].type(); //check to see if there is a relationship change.
			if(this.relationships[i].drama){
				return true;
			}
		}
		return false;
	}

	this.getRelationshipDrama = function(){
		var ret = [];
		for(var i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.drama){
				ret.push(r);
			}
		}
		return ret;
	}

	this.getChatFontColor = function(){
		if(this.isTroll){
			return this.bloodColor;
		}else{
			return getColorFromAspect(this.aspect);
		}
	}

	this.getFriendsFromList = function(potentialFriends){
		var ret = [];
		for(var i = 0; i<potentialFriends.length; i++){
			var p =  potentialFriends[i];
			if(p!=this){
				var r = this.getRelationshipWith(potentialFriends[i]);
				if(r.value > 0){
					ret.push(p);
				}
			}
		}
		return ret;
	}

	this.getEnemiesFromList = function(potentialEnemies){
		var ret = [];
		for(var i = 0; i<potentialEnemies.length; i++){
			var p =  potentialEnemies[i];
			if(p!=this){
				var r = this.getRelationshipWith(potentialEnemies[i]);
				if(r.value < 0){
					ret.push(p);
				}
			}
		}
		return ret;
	}

	this.getLowestRelationshipValue = function(){
		var worstRelationshipSoFar = this.relationships[0];
		for(var i = 1; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.value < worstRelationshipSoFar.value){
				worstRelationshipSoFar = r;
			}
		}
		return worstRelationshipSoFar.value;
	}

	this.getHighestRelationshipValue = function(){
		var bestRelationshipSoFar = this.relationships[0];
		for(var i = 1; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.value > bestRelationshipSoFar.value){
				bestRelationshipSoFar = r;
			}
		}
		return bestRelationshipSoFar.value;
	}


	this.getBestFriend = function(){
		var bestRelationshipSoFar = this.relationships[0];
		for(var i = 1; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.value > bestRelationshipSoFar.value){
				bestRelationshipSoFar = r;
			}
		}
		return bestRelationshipSoFar.target;
	}

	this.getBestFriendFromList = function(potentialFriends, debugCallBack){
		var bestRelationshipSoFar = this.relationships[0];
		for(var i = 0; i<potentialFriends.length; i++){
			var p =  potentialFriends[i];
			if(p!=this){
				var r = this.getRelationshipWith(p);
				if(!r){
					//console.log("Couldn't find relationships between " + this.chatHandle + " and " + p.chatHandle);
					//console.log(debugCallBack)
					//console.log(potentialFriends);
					//console.log(this);
				}
				if(r.value > bestRelationshipSoFar.value){
					bestRelationshipSoFar = r;
				}
			}
		}
		//can't be my best friend if they're an enemy
		//I SHOULD NOT HAVE A RELATIONSHIP WITH MYSELF. but if i do, don't return it.
		if(bestRelationshipSoFar.value > 0 && bestRelationshipSoFar.target != this){
			return bestRelationshipSoFar.target;
		}
	}

	this.getWorstEnemyFromList = function(potentialFriends){
		var worstRelationshipSoFar = this.relationships[0];
		for(var i = 0; i<potentialFriends.length; i++){
			var p =  potentialFriends[i];
			if(p!=this){
				var r = this.getRelationshipWith(potentialFriends[i]);
				if(r.value < worstRelationshipSoFar.value){
					worstRelationshipSoFar = r;
				}
			}
		}
		//can't be my worst enemy if they're a friend.
		//I SHOULD NOT HAVE A RELATIONSHIP WITH MYSELF. but if i do, don't return it.
		if(worstRelationshipSoFar.value < 0 && worstRelationshipSoFar.target != this){
			return worstRelationshipSoFar.target;
		}
	}

	this.getFriends = function(){
		var ret = [];
		for(var i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].value > 0){
				ret.push(this.relationships[i].target);
			}
		}
		return ret;
	}

	this.getEnemies = function(){
		var ret = [];
		for(var i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].value < 0){
				ret.push( this.relationships[i].target);
			}
		}
		return ret;
	}

	this.highInit = function(){
		return (this.class_name == "Rogue" || this.class_name == "Knight" || this.class_name == "Maid"|| this.class_name == "Mage"|| this.class_name == "Sylph"|| this.class_name == "Prince")
	}

	this.initializeLuck = function(){
		this.minLuck = getRandomInt(20,40); //middle of the road.
		this.maxLuck = this.minLuck + getRandomInt(1,20);   //max needs to be more than min.
		if(this.aspect == "Light"){
			if(this.highInit()){
				this.maxLuck += 35;
			}else{
				this.maxLuck += -35;
			}
		}else if(this.aspect == "Doom"){
			if(this.highInit()){
				this.minLuck += -35;
			}else{
				this.minLuck += 35;
			}
		}

	}

	this.initializeFreeWill = function(){
		this.freeWill = getRandomInt(-25,25);
		if(this.aspect == "Mind"){
			if(this.highInit()){
				this.freeWill += 35;
			}else{
				this.freeWill += -35;
			}
		}else if(this.aspect == "Time"){
			if(this.highInit()){
				this.freeWill += -35;
			}else{
				this.freeWill += 35;
			}
		}
	}

	this.initializeHP= function(){
		this.hp = getRandomInt(50,100);
		if(this.aspect == "Life"){
			if(this.highInit()){
				this.hp += 50;
			}else{
				this.hp += -50;
			}
		}else if(this.aspect == "Doom"){
			if(this.highInit()){
				this.hp += -50;
			}else{
				this.hp += 50;
			}
		}
	}

	this.initializeMobility = function(){
		this.mobility = getRandomInt(0,75);
		if(this.aspect == "Breath"){
			if(this.highInit()){
				this.mobility += 35;
			}else{
				this.mobility += -35;
			}
		}else if(this.aspect == "Space"){
			if(this.highInit()){
				this.mobility += -35;
			}else{
				this.mobility += 35;
			}
		}
	}

	this.initializeTriggerLevel = function(){
		this.triggerLevel = getRandomInt(0,2);
		if(this.aspect == "Rage"){
			if(this.highInit()){
				this.triggerLevel += 2;
			}else{
				this.triggerLevel += -2;
			}
		}else if(this.aspect == "Blood"){
			if(this.highInit()){
				this.triggerLevel += -2;
			}else{
				this.triggerLevel += 2;
			}
		}
	}

	//don't recalculate values, but can boost postivily or negatively by an amount. sure.
	this.initializeRelationships = function(){
		var amount = 5;
		if(this.aspect == "Heart"){
			if(this.highInit()){
				this.boostAllRelationshipsBy(amount)
			}else{
				this.boostAllRelationshipsBy(-1 * amount)
			}
		}else if(this.aspect == "Rage"){
			if(this.highInit()){
				this.boostAllRelationshipsWithMeBy(-1* amount);
				this.boostAllRelationshipsBy(-1*amount)
			}else{
				this.boostAllRelationshipsWithMeBy(amount);
				this.boostAllRelationshipsBy(amount)
			}
		}else if(this.aspect == "Blood"){
			if(this.highInit()){
				this.boostAllRelationshipsWithMeBy(amount);
			}else{
				this.boostAllRelationshipsWithMeBy(-1 * amount);
			}
		}
	}

	this.initializePower = function(){
		this.power = 0;
		if(this.aspect == "Hope"){
			if(this.highInit()){
				this.power += 15
			}else{
				this.power += -15;
			}
		}
	}



	//void is associated with nothing, and thus can do/be anything.
	this.initializeVoid = function(){
		if(this.aspect == "Void"){

			var amount = 0;
			if(this.highInit()){
				amount += getRandomInt(1,35);
			}else{
				amount += -1 *getRandomInt(1,35);
			}
			var rand =getRandomInt(0,18); //one more than possibilities, can always start with NO boost.
			if(rand == 0){
				this.minLuck += amount;
			}else if(rand == 1){
				this.maxLuck += amount;
			}else if(rand == 2){
				this.freeWill += amount;
			}else if(rand == 3){
				this.hp += amount;
			}else if(rand == 4){
				this.mobility += amount;
			}else if(rand == 5){
				this.power += amount;
			}else if(rand == 6){
				this.boostAllRelationshipsWithMeBy(amount);
			}else if(rand == 7){
				this.boostAllRelationshipsBy(amount)
			}else if(rand == 8){
				this.triggerLevel += amount;
			}else if(rand == 9){
				this.minLuck += -1 * amount;
			}else if(rand == 10){
				this.maxLuck += -1 * amount;
			}else if(rand == 11){
				this.freeWill += -1 * amount;
			}else if(rand == 12){
				this.hp += -1 * amount;
			}else if(rand == 13){
				this.mobility += -1 * amount;
			}else if(rand == 14){
				this.power += -1 * amount;
			}else if(rand == 15){
				this.boostAllRelationshipsWithMeBy(-1 * amount);
			}else if(rand == 16){
				this.boostAllRelationshipsBy(-1 * amount)
			}else if(rand == 17){
				this.triggerLevel += -1 * amount;
			}
		}else{

		}
	}

	//players can start with any luck, (remember, Vriska started out super unlucky and only got AAAAAAAALL the luck when she hit godtier)
	//make sure session calls this before first tick, cause otherwise won't be initialized by right claspect after easter egg or character creation.
	this.initializeStats = function(){

		this.initializeLuck();
		this.initializeFreeWill();
		this.initializeHP();
		this.initializeMobility();
		this.initializeRelationships();
		this.initializePower();
		this.initializeVoid();
		this.initializeTriggerLevel();
		//reroll goddestiny and sprite as well. luck might have changed.
		var luck = this.rollForLuck();
		if(this.class_name == "Witch" || luck < 10){
			this.kernel_sprite = getRandomElementFromArray(disastor_prototypings);
			//console.log("disastor")
		}else if(luck > 65){
			this.kernel_sprite = getRandomElementFromArray(fortune_prototypings);
			//console.log("fortune")
		}
		if(luck>40){
			this.godDestiny =true;
		}
	}


}

function initializeStatsForPlayers(players){
	for(var i = 0; i<players.length; i++){
		players[i].initializeStats();
	}
}

function getColorFromAspect(aspect){
	var color = "";
	if(aspect == "Space"){
		color = "#00ff00";
	}else if(aspect == "Time"){
		color = "#ff0000";
	}else if(aspect == "Breath"){
		color = "#3399ff";
	}else if(aspect == "Doom"){
		color = "#003300";
	}else if(aspect == "Blood"){
		color = "#993300";
	}else if(aspect == "Heart"){
		color = "#ff3399";
	}else if(aspect == "Mind"){
		color = "#3da35a";
	}else if(aspect == "Light"){
		color = "#ff9933";
	}else if(aspect == "Void"){
		color = "#000066";
	}else if(aspect == "Rage"){
		color = "#9900cc";
	}else if(aspect == "Hope"){
		color = "#ffcc66";
	}else if(aspect == "Life"){
		color = "#494132";
	}
	return color;
}

function getShirtColorFromAspect(aspect){
	var color = "";
	if(aspect == "Space"){
		color = "#030303";
	}else if(aspect == "Time"){
		color = "#b70d0e";
	}else if(aspect == "Breath"){
		color = "#0087eb";
	}else if(aspect == "Doom"){
		color = "#204020";
	}else if(aspect == "Blood"){
		color = "#3d190a";
	}else if(aspect == "Heart"){
		color = "#6b0829";
	}else if(aspect == "Mind"){
		color = "#3da35a";
	}else if(aspect == "Light"){
		color = "#ff7f00";
	}else if(aspect == "Void"){
		color = "#000066";
	}else if(aspect == "Rage"){
		color = "#9900cc";
	}else if(aspect == "Hope"){
		color = "#ffe094";
	}else if(aspect == "Life"){
		color = "#ccc4b5";
	}
	return color;
}

function getDarkShirtColorFromAspect(aspect){
	var color = "";
	if(aspect == "Space"){
		color = "#242424";
	}else if(aspect == "Time"){
		color = "#970203";
	}else if(aspect == "Breath"){
		color = "#0070ED";
	}else if(aspect == "Doom"){
		color = "#11200F";
	}else if(aspect == "Blood"){
		color = "#2C1207";
	}else if(aspect == "Heart"){
		color = "#6B0829";
	}else if(aspect == "Mind"){
		color = "#3DA35A";
	}else if(aspect == "Light"){
		color = "#D66E04";
	}else if(aspect == "Void"){
		color = "#02285B";
	}else if(aspect == "Rage"){
		color = "#1E0C47";
	}else if(aspect == "Hope"){
		color = "#E8C15E";
	}else if(aspect == "Life"){
		color = "#CCC4B5";
	}
	return color;
}

function getFontColorFromAspect(aspect){
	return "<font color= '" + getColorFromAspect(aspect) + "'> ";
}



function randomPlayerWithClaspect(session, c,a){
	//console.log("random player");

	var k = getRandomElementFromArray(prototypings);


	var gd = false;

	var m = getRandomElementFromArray(moons);
	var id = Math.seed;
	var p =  new Player(session,c,a,k,m,gd,id);

	p.initializeStats();
	var tmp =getRandomLandFromPlayer(p);
	p.land1 = tmp[0]
	p.land2 = tmp[1];
	p.land = "Land of " + tmp[0] + " and " + tmp[1];
	//no longer any randomness directly in player class. don't want to eat seeds if i don't have to.
	p.baby = getRandomInt(1,3)
	p.interest1 = getRandomElementFromArray(interests);
	p.interest2 = getRandomElementFromArray(interests);
	p.chatHandle = getRandomChatHandle(p.class_name,p.aspect,p.interest1, p.interest2);
	p.mylevels = getLevelArray(p);//make them ahead of time for echeladder graphic
	p.hair = getRandomInt(1,60);
	p.hairColor = getRandomElementFromArray(human_hair_colors);
	p.leftHorn =  getRandomInt(1,46);
	p.rightHorn = p.leftHorn;
	if(Math.seededRandom() > .7 ){ //preference for symmetry
			p.rightHorn = getRandomInt(1,46);
	}
	return p;

}
function randomPlayer(session){
	//remove class AND aspect from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = getRandomElementFromArray(available_aspects);
	removeFromArray(a, available_aspects);
	return randomPlayerWithClaspect(session,c,a);

}

function randomPlayerWithoutRemoving(session){
	//remove class AND aspect from available
	var c = getRandomElementFromArray(available_classes);
	//removeFromArray(c, available_classes);
	var a = getRandomElementFromArray(available_aspects);
	//removeFromArray(a, available_aspects);
	return randomPlayerWithClaspect(session,c,a);

}

function randomSpacePlayer(session){
	//remove class from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = required_aspects[0];
	return randomPlayerWithClaspect(session,c,a);
}

function randomTimePlayer(session){
	//remove class from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = required_aspects[1];
	return randomPlayerWithClaspect(session,c,a);
}

function findAspectPlayer(playerList, aspect){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.aspect == aspect){
			//console.log("Found " + aspect + " player");
			return p;
		}
	}
}

function findAllAspectPlayers(playerList, aspect){
	var ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.aspect == aspect){
			//console.log("Found " + aspect + " player");
			ret.push(p)
		}
	}
	return ret;
}


function getLeader(playerList){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.leader){
			return p;
		}
	}
}

//in combo sessions, mibht be more than one rage player, for example.
function findClaspectPlayer(playerList, class_name, aspect){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.class_name == class_name && p.aspect == aspect){
			//console.log("Found " + class_name + " player");
			return p;
		}
	}
}


function findClassPlayer(playerList, class_name){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.class_name == class_name){
			//console.log("Found " + class_name + " player");
			return p;
		}
	}
}

function findStrongestPlayer(playerList){
	var strongest = playerList[0];

	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.power > strongest.power){
			strongest = p;
		}
	}
	return strongest;
}

function findDeadPlayers(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.dead){
			ret.push(p);
		}
	}
	return ret;
}

function findLivingPlayers(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(!p.dead){
			ret.push(p);
		}
	}
	return ret;
}

function getPartyPower(party){
	var ret = 0;
	for(var i = 0; i<party.length; i++){
		ret += party[i].power;
	}
	return ret;
}

function getPlayersTitlesNoHTML(playerList){
	//console.log(playerList)
	if(playerList.length == 0){
		return "";
	}
		var ret = playerList[0].title();
		for(var i = 1; i<playerList.length; i++){
			ret += " and " + playerList[i].title();
		}
		return ret;
}

function getPlayersTitles(playerList){
	//console.log(playerList)
	if(playerList.length == 0){
		return "";
	}
		var ret = playerList[0].htmlTitle();
		for(var i = 1; i<playerList.length; i++){
			ret += " and " + playerList[i].htmlTitle();
		}
		return ret;
}

function partyRollForLuck(players){
	var ret = 0;
	for(var i = 0; i<players.length; i++){
		ret += players[i].rollForLuck();
	}
	return ret/players.length;
}

function getPlayersTitlesBasic(playerList){
	if(playerList.length == 0){
		return "";
	}
		var ret = playerList[0].htmlTitleBasic();
		for(var i = 1; i<playerList.length; i++){
			ret += " and " + playerList[i].htmlTitleBasic();
		}
		return ret;
	}

function findPlayersWithDreamSelves(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.dreamSelf){
			ret.push(p);
		}
	}
	return ret;
}

function findPlayersWithoutDreamSelves(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(!p.dreamSelf){
			ret.push(p);
		}
	}
	return ret;
}


//don't override existing source
function setEctobiologicalSource(playerList,source){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		var g  = p.guardian; //not doing this caused a bug in session 149309 and probably many, many others.
		if(p.ectoBiologicalSource == null){
			p.ectoBiologicalSource = source;
			g.ectoBiologicalSource = source;
		}
	}
}


function findPlayersWithoutEctobiologicalSource(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.ectoBiologicalSource == null){
			ret.push(p);
		}
	}
	return ret;
}

//deeper than a snapshot, for yellowyard aliens
//have to treat properties that are objects differently. luckily i think those are only player and relationships.
function clonePlayer(player, session, isGuardian){
	var clone = new Player();
	for(var propertyName in player) {
		if(propertyName == "guardian"){
			if(!isGuardian){ //no infinite recursion, plz
				clone.guardian = clonePlayer(player.guardian, session, true);
				clone.guardian.guardian = clone;
		}
	}else if(propertyName == "relationships"){
		clone.relationships = cloneRelationshipsStopgap(player.relationships); //won't actually work, but will let me actually clone the relationships later without modifying originals
	}else{
				clone[propertyName] = player[propertyName]
	}
	}
	return clone;
}

function findPlayersFromSessionWithId(playerList, source){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		//if it' snull, you could be from here, but not yet ectoborn
		if(p.ectoBiologicalSource == source || p.ectoBiologicalSource == null){
			ret.push(p);
		}
	}
	return ret;
}

function findBadPrototyping(playerList){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i].kernel_sprite;
		if(disastor_prototypings.indexOf(p) != -1){
			return p;
		}
	}
}

function findHighestMobilityPlayer(playerList){
	var ret = playerList[0];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i]
		if(p.mobility < ret.mobility){
			ret = p;
		}
	}
	return ret;
}

function findGoodPrototyping(playerList){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i].kernel_sprite;
		if(fortune_prototypings.indexOf(p) != -1){
			return p;
		}
	}
}

function getGuardiansForPlayers(playerList){
	var tmp = [];
	for(var i= 0; i<playerList.length; i++){
		var g = playerList[i].guardian;
		tmp.push(g);
	}
	return tmp;
}

function sortPlayersByFreeWill(players){
	return players.sort(compareFreeWill)
}

function compareFreeWill(a,b) {
  return b.freeWill - a.freeWill;
}

function getAverageMinLuck(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].minLuck;
	}
	return  Math.round(ret/players.length);
}

function getAverageMaxLuck(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].maxLuck;
	}
	return  Math.round(ret/players.length);
}

function getAverageTriggerLevel(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].triggerLevel;
	}
	return  Math.round(ret/players.length);
}

function getAverageHP(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].hp;
	}
	return  Math.round(ret/players.length);
}

function getAverageMobility(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].mobility;
	}
	return  Math.round(ret/players.length);
}

function getAverageRelationshipValue(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].getAverageRelationshipValue();
	}
	return Math.round(ret/players.length);
}

function getAveragePower(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].power;
	}
	return  Math.round(ret/players.length);
}

function getAverageFreeWill(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].freeWill;
	}
	return  Math.round(ret/players.length);
}
