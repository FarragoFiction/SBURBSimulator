function Player(session,class_name, aspect, object_to_prototype, moon, godDestiny,id){
	this.baby = null;
	this.buffs = []; //only used in strifes, array of BuffStats (from fraymotifs and eventually weapons)
	this.permaBuffs = {"MANGRIT":0}; //is an object so it looks like a player with stats.  for things like manGrit which are permanent buffs to power (because modding power directly gets OP as shit because power controls future power)
	this.renderingType = 0; //0 means default for this sim.
	this.associatedStats = [];  //most players will have a 2x, a 1x and a -1x stat.
	this.sanity = 0; //eventually replace triggerLevel with this (it's polarity is opposite triggerLevel)
	this.alchemy = 0; //mostly unused until we get to the Alchemy update.
	this.interest1Category = null; //used by Replay page for custom interests.
	this.interest2Category = null; //both should be null once they have been used to add the custom interest to the right place
	this.spriteCanvasID = null;  //part of new rendering engine.
	this.session = session;
	this.pvpKillCount = 0; //for stats.
	this.timesDied = 0;
	this.usedFraymotifThisTurn = false;
	this.fraymotifs = [];
	this.currentHP = 0;
	this.denizen = null;
	this.denizenMinion = null;
	this.maxHornNumber = 73; //don't fuck with this
	this.maxHairNumber = 75; //same
	this.sprite = null; //gets set to a blank sprite when character is created.
	this.grist = 0; //total party grist needs to be at a certain level for the ultimate alchemy. luck events can raise it, boss fights, etc.
	this.hp = 0; //mostly used for boss battles;
	this.graphs = [];
	this.deriveChatHandle = true;
	this.id = id;
	this.flipOutReason = null; //if it's null, i'm not flipping my shit.
	this.flippingOutOverDeadPlayer = null; //don't let this go into url. but, don't flip out if the friend is currently alive, you goof.
	this.denizen_index = 0; //denizen quests are in order.
	this.causeOfDrain = ""; //just ghost things
	this.ghostWisdom = []; //keeps you from spamming the same ghost over and over for wisdom.
	this.ghostPacts = []; //some classes can form pacts with ghosts for use in boss battles (attack or revive) (ghosts don't leave bubbles, just lend power). or help others do so.  if i actually use a ghost i have a pact with, it's drained. (so anybody else with a pact with it can't use it.)
	this.land1 = null; //words my land is made of.
	this.land2 = null;
	this.minLuck = 0;
	this.maxLuck = 0;
	this.freeWill = 0;
	this.mobility = 0;
	this.crowned = null; //players can't be crowned.
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
	this.object_to_prototype = object_to_prototype;
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
	this.sanity = 2; //make up for moon bonus
	this.murderMode = false;  //kill all players you don't like. odds of a just death skyrockets.
	this.leftMurderMode = false; //have scars, unless left via death.
	this.corruptionLevelOther = 0; //every 100 points, sends you to next grimDarkLevel.
	this.grimDark = 0;  //  0 = none, 1 = some, 2 = some more 3 = full grim dark with aura and font and everything.
	this.leader = false;
	this.landLevel = 0; //at 10, you can challenge denizen.  only space player can go over 100 (breed better universe.)
	this.denizenFaced = false;
	this.denizenDefeated = false;
	this.denizenMinionDefeated = false;
	this.causeOfDeath = ""; //fill in every time you die. only matters if you're dead at end
	this.doomedTimeClones =  []; //help fight the final boss(es).
	this.doomed = false; //stat that doomed time clones have.


	this.fromThisSession = function(session){
		return (this.ectoBiologicalSource == null || this.ectoBiologicalSource == session.session_id)
	}

	this.isQuadranted = function(){
		if(this.getHearts().length > 0) return true;
		if(this.getClubs().length > 0) return true;
		if(this.getDiamonds().length > 0) return true;
		if(this.getSpades().length > 0) return true;

	}

	this.getClubs = function(){
		var ret = [];
		for (var i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.clubs){
				ret.push(r);
			}
		}
		return ret;
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

	this.getDenzenNameArray = function(){

	}

	//returns a number based on the absolute value of everything except relationships (can't help you with a denizen fight and that's what this is for)
	this.getOverallStrength  = function(){
		var ret = 0;
		ret += this.power;
		ret += Math.abs(this.freeWill)
		ret += Math.abs(this.mobility)
		ret += Math.abs(this.hp)
		ret += Math.abs
		(this.maxLuck + this.minLuck)
		ret += Math.abs(this.sanity)
		return ret;
	}

	this.generateDenizen = function(){
		var possibilities = this.getDenizenNameArray();
		var strength = this.getOverallStrength();
		var expectedMaxStrength = 150;  //if i change how stats work, i need to update this value 
		var strengthPerTier = (expectedMaxStrength)/possibilities.length;
		//console.log("Strength at start is, " + strength);//but what if you don't want STRANGTH!???
		var denizenIndex = Math.round(strength/strengthPerTier)-1;  //want lowest value to be off the denizen array.

		var denizenName = "";
		var denizenStrength = (denizenIndex/(possibilities.length))+1 //between 1 and 2
		//console.log("Strength for denizen calculated from index of: " + denizenIndex + " out of " + possibilities.length)
		if(denizenIndex == 0){
			denizenName = this.weakDenizenNames();
			denizenStrength = 0.1;//fraymotifs about standing and looking at your pittifully
			console.log("strength demands a weak denizen " + this.session.session_id)
		}else if(denizenIndex >= possibilities.length){
			denizenName = this.strongDenizenNames(); //<-- doesn't have to be literally him. points for various mispellings of his name.
			denizenStrength = 5;
			console.log("Strength demands strong denizen. " + this.session.session_id)
		}else{
			denizenName = possibilities[denizenIndex];

		}

		this.makeDenizenWithStrength(denizenName, denizenStrength); //if you pick the middle enizen it will be at strength of "1", if you pick last denizen, it will be at 2 or more.

	}

	//generate denizen gets me name and strength, this just takes care of making it.
	this.makeDenizenWithStrength = function(name, strength){
		//console.log("Strength for denizen " + name + " is: " + strength)
		//based off existing denizen code.  care about which aspect i am.
		//also make minion here.
		var denizen =  new GameEntity(this.session, "Denizen " +name, null);
		var denizenMinion = new GameEntity(this.session,name + " Minion", null);
		var tmpStatHolder = {};
		tmpStatHolder.minLuck = -10;
		tmpStatHolder.abscondable = true; //players can decide to flee like little bitches
        tmpStatHolder.canAbscond = false;
		tmpStatHolder.maxLuck = 10;
		tmpStatHolder.hp = 10 * strength;
		tmpStatHolder.mobility = 10;
		tmpStatHolder.sanity = 10;
		tmpStatHolder.freeWill = 10;
		tmpStatHolder.power = 5 * strength;
		tmpStatHolder.grist = 1000;
		tmpStatHolder.RELATIONSHIPS = 10;  //not REAL relationships, but real enough for our purposes.
		for(var i = 0; i<this.associatedStats.length; i++){
			//alert("I have associated stats: " + i)
			var stat = this.associatedStats[i];
			if(stat.name == "MANGRIT"){
				tmpStatHolder.power = tmpStatHolder.power * stat.multiplier * strength
			}else{
				tmpStatHolder[stat.name] += tmpStatHolder[stat.name] * stat.multiplier * strength;
			} 
		}

		//denizenMinion.setStats(tmpStatHolder.minLuck,tmpStatHolder.maxLuck,tmpStatHolder.hp,tmpStatHolder.mobility,tmpStatHolder.sanity,tmpStatHolder.freeWill,tmpStatHolder.power,true, false, [],1000);
		
		denizenMinion.setStatsHash(tmpStatHolder);
		tmpStatHolder.power = 10*strength;
		for(var key in tmpStatHolder){
			tmpStatHolder[key] = tmpStatHolder[key] * 2; // same direction as minion stats, but bigger. 
		}
		//denizen.setStats(tmpStatHolder.minLuck,tmpStatHolder.maxLuck,tmpStatHolder.hp,tmpStatHolder.mobility,tmpStatHolder.sanity,tmpStatHolder.freeWill,tmpStatHolder.power,true, false, [],1000000);
		denizen.setStatsHash(tmpStatHolder);
		this.denizen = denizen;
		this.denizenMinion = denizenMinion;
		this.session.fraymotifCreator.createFraymotifForPlayerDenizen(this,name);
	}

	this.getDenizenNameArray = function(){
		if(this.aspect == "Blood") return this.bloodDenizenNames();
		if(this.aspect == "Mind") return this.mindDenizenNames();
		if(this.aspect == "Rage") return this.rageDenizenNames();
		if(this.aspect == "Void") return this.voidDenizenNames();
		if(this.aspect == "Time") return this.timeDenizenNames();
		if(this.aspect == "Heart") return this.heartDenizenNames();
		if(this.aspect == "Breath") return this.breathDenizenNames();
		if(this.aspect == "Light") return this.lightDenizenNames();
		if(this.aspect == "Space") return this.spaceDenizenNames();
		if(this.aspect == "Hope") return this.hopeDenizenNames();
		if(this.aspect == "Life") return this.lifeDenizenNames();
		if(this.aspect == "Doom") return this.doomDenizenNames();
		return ["ERROR 404: DENIZEN NOT FOUND"]
	}
	//discord generated most of these names.
	this.bloodDenizenNames = function(){
		return ['Blood','Hera','Hestia','Bastet','Bes','Vesta','Eleos','Sanguine','Medusa','Frigg','Debella','Juno','Moloch','Baal','Eusebeia','Horkos','Homonia','Harmonia','Philotes'];
	}

	this.mindDenizenNames = function(){
		return ['Mind','Athena','Forseti','Janus','Anubis','Maat','Seshat','Thoth','Jyglag','Peryite','Nomos','Lugus','Sithus','Dike','Epimetheus','Metis','Morpheus','Omoikane','Argus','Hermha','Morha','Sespille','Selcric','Tzeench']
	}

	this.rageDenizenNames = function(){
		return ['Rage','Ares','Dyonisus','Bacchus','Abbadon','Mammon','Mania','Asmodeus','Belphegor','Set','Apophis','Nemesis','Menoetius','Shogorath','Loki','Alastor','Mol Bal','Deimos','Achos','Pallas','Deimos','Ania','Lupe','Lyssa','Ytilibatsni','Discord'];
	}

	this.voidDenizenNames = function(){
		return ['Void','Selene','Erebus','Nix','Artemis','Kuk','Kaos','Hypnos','Tartarus','Hœnir','Skoll',"Czernobog",'Vermina','Vidar','Asteria','Nocturne','Tsukuyomi','Leviathan','Hecate','Harpocrates','Diova'];
	}

	this.timeDenizenNames = function(){
		return ['Time','Ignis','Saturn','Cronos','Aion','Hephaestus','Vulcan','Perses','Prometheus','Geras','Acetosh','Styx','Kairos','Veter','Gegute','Etu','Postverta and Antevorta','Emitus','Moirai'];
	}

	this.heartDenizenNames = function(){
		return ['Heart','Aphrodite','Baldur','Eros','Hathor','Philotes','Anubis','Psyche','Mora','Isis','Jupiter', 'Narcissus','Hecate','Izanagi','Izanami','Ishtar','Anteros','Agape','Peitho','Mahara','Naidraug','Snoitome','Walthidian','Slanesh','Benu'];
	}

	this.breathDenizenNames = function(){
		return ['Breath','Ninlil','Ouranos','Typheus','Aether','Amun','Hermes','Shu','Sobek','Aura','Theia','Lelantos','Keenarth','Aeolus','Aurai','Zephyrus','Ventus','Sora','Htaerb','Worlourier','Quetzalcoatl'];
	}

	this.lightDenizenNames = function(){
		return ['Light','Helios','Ra','Cetus','Iris','Heimdall','Apollo','Coeus','Hyperion', "Belobog",'Phoebe','Metis','Eos','Dagr','Asura','Amaterasu','Sol','Tyche','Odin ','Erutuf'];
	}

	this.spaceDenizenNames = function(){
		return ['Space','Gaea','Nut','Echidna','Wadjet','Qetesh','Ptah','Geb','Fryja','Atlas','Hebe','Lork','Eve','Genesis','Morpheus','Veles ','Arche','Rekinom','Iago','Pilera','Tiamat','Gilgamesh','Implexel'];
	}


	this.hopeDenizenNames = function(){
		return ['Hope','Isis','Marduk','Fenrir','Apollo','Sekhmet','Votan','Wadjet','Baldur','Zanthar','Raphael','Metatron','Jerahmeel','Gabriel','Michael','Cassiel','Gavreel','Aariel','Uriel','Barachiel ','Jegudiel','Samael','Taylus','Tzeench'];
	}

	this.lifeDenizenNames = function(){
		return ['Life','Demeter','Pan','Nephthys','Ceres','Isis','Hemera','Andhrímnir','Agathodaemon','Eir','Baldur','Prometheus','Adonis','Geb','Panacea','Aborof','Nurgel','Adam'];
	}

	this.doomDenizenNames = function(){
		return ['Doom','Hades','Achlys','Cassandra','Osiris','Ananke','Thanatos','Moros','Iapetus','Themis','Aisa','Oizys','Styx','Keres','Maat','Castor and Pollux','Anubis','Azrael','Ankou','Kapre','Moros','Atropos','Oizys','Korne','Odin'];
	}

	this.strongDenizenNames = function(){
	    console.log("What if you don't want stranth? " + this.session.session_id)
		var ret = ['Yaldabaoth', '<span class = "void">Nobrop, the </span>Null', '<span class = "void">Paraxalan, The </span>Ever-Searching', "<span class = 'void'>Algebron, The </span>Dilletant", '<span class = "void">Doomod, The </span>Wanderer', 'Jörmungandr','Apollyon','Siseneg','Borunam','<span class = "void">Jadeacher the,</span>Researcher','Karmiution','<span class = "void">Authorot, the</span> Robot', '<span class = "void">Abbiejean, the </span>Scout', 'Aspiratcher, The Librarian','<span class = "void">Recurscker, The</span>Hollow One','Insurorracle','<span class = "void">Maniomnia, the Dreamwaker</span>','Kazerad','Shiva','Goliath'];
		return getRandomElementFromArray(ret);
	}

	this.weakDenizenNames = function(){
		var ret = ['Eriotur','Abraxas','Succra','Watojo','Bluhubit','Swefrat','Helaja','Fischapris'];
		return getRandomElementFromArray(ret);
	}



	//flipping out over the dead won't call this but everything else will.
	this.flipOut = function(reason){
		//console.log("flip out method called for: " + reason)
		this.flippingOutOverDeadPlayer = null;
		this.flipOutReason = reason;
	}

	this.interestedIn = function(interestWord,interestNum){
		if(!interestNum){
			if(interestWord == "Comedy") return playerLikesComedy(this)
			if(interestWord == "Music") return playerLikesMusic(this)
			if(interestWord == "Culture") return playerLikesCulture(this)
			if(interestWord == "Writing") return playerLikesWriting(this)
			if(interestWord == "Athletic") return playerLikesAthletic(this)
			if(interestWord == "Terrible") return playerLikesTerrible(this)
			if(interestWord == "Justice") return playerLikesJustice(this)
			if(interestWord == "Fantasy") return playerLikesFantasy(this)
			if(interestWord == "Domestic") return playerLikesDomestic(this)
			if(interestWord == "PopCulture") return playerLikesPopculture(this)
			if(interestWord == "Technology") return playerLikesTechnology(this)
			if(interestWord == "Social") return playerLikesSocial(this)
			if(interestWord == "Romance") return playerLikesRomantic(this)
			if(interestWord == "Academic") return playerLikesAcademic(this)
			return false;
		}else if(interestNum == 1){
			if(interestWord == "Comedy") return comedy_interests.indexOf(this.interest1) != -1
			if(interestWord == "Music") return music_interests.indexOf(this.interest1) != -1
			if(interestWord == "Culture") return culture_interests.indexOf(this.interest1) != -1
			if(interestWord == "Writing") return writing_interests.indexOf(this.interest1) != -1
			if(interestWord == "Athletic") return athletic_interests.indexOf(this.interest1) != -1
			if(interestWord == "Terrible") return terrible_interests.indexOf(this.interest1) != -1
			if(interestWord == "Justice") return justice_interests.indexOf(this.interest1) != -1
			if(interestWord == "Fantasy") return fantasy_interests.indexOf(this.interest1) != -1
			if(interestWord == "Domestic") return domestic_interests.indexOf(this.interest1) != -1
			if(interestWord == "PopCulture") return pop_culture_interests.indexOf(this.interest1) != -1
			if(interestWord == "Technology") return technology_interests.indexOf(this.interest1) != -1
			if(interestWord == "Social") return social_interests.indexOf(this.interest1) != -1
			if(interestWord == "Romance") return romantic_interests.indexOf(this.interest1) != -1
			if(interestWord == "Academic") return academic_interests.indexOf(this.interest1) != -1
		}else if(interestNum == 2){
			if(interestWord == "Comedy") return comedy_interests.indexOf(this.interest2) != -1
			if(interestWord == "Music") return music_interests.indexOf(this.interest2) != -1
			if(interestWord == "Culture") return culture_interests.indexOf(this.interest2) != -1
			if(interestWord == "Writing") return writing_interests.indexOf(this.interest2) != -1
			if(interestWord == "Athletic") return athletic_interests.indexOf(this.interest2) != -1
			if(interestWord == "Terrible") return terrible_interests.indexOf(this.interest2) != -1
			if(interestWord == "Justice") return justice_interests.indexOf(this.interest2) != -1
			if(interestWord == "Fantasy") return fantasy_interests.indexOf(this.interest2) != -1
			if(interestWord == "Domestic") return domestic_interests.indexOf(this.interest2) != -1
			if(interestWord == "PopCulture") return pop_culture_interests.indexOf(this.interest2) != -1
			if(interestWord == "Technology") return technology_interests.indexOf(this.interest2) != -1
			if(interestWord == "Social") return social_interests.indexOf(this.interest2) != -1
			if(interestWord == "Romance") return romantic_interests.indexOf(this.interest2) != -1
			if(interestWord == "Academic") return academic_interests.indexOf(this.interest2) != -1
		}
	}

	//if change would push me over 3, render 'cause i'm newly grimdark
	//if it would pull be from over 3, render 'cause i have somewhat recovered.
	this.changeGrimDark = function(val){
		//this.grimDark += val;
		var tmp = this.grimDark + val;
		var render = false;

		if(this.grimDark <= 3 && tmp > 3){ //newly GrimDark
			console.log("grim dark 3 or more in session: " + this.session.session_id)
			render = true;
		}else if(this.grimDark >3 && tmp <=3){ //newly recovered.
			render = true;
		}
		this.grimDark += val;
		if(render){
			this.renderSelf();
		}

	}

	this.makeMurderMode = function(){
		this.murderMode = true;
		this.increasePower();
		this.renderSelf(); //new scars. //can't do scars just on top of sprite 'cause hair might cover.'
	}

	this.unmakeMurderMode = function(){
		this.murderMode = false;
		this.leftMurderMode = true;
		this.renderSelf();
	}


	this.makeDead = function(causeOfDeath){
		this.dead = true;
		this.timesDied ++;
		this.buffs = [];
		this.causeOfDeath = sanitizeString(causeOfDeath);
		if(this.currentHP > 0) this.currentHP = -1; //just in case anything weird is going on. dead is dead.  (for example, you could have been debuffed of hp).
		//was in make alive, but realized that this makes doom ghosts way stronger if it's here. powered by DEATH, but being revived.
		if(this.aspect == "Doom"){ //powered by their own doom.
			//console.log("doom is powered by their own death: " + this.session.session_id) //omg, they are sayians.
			this.power += 50;
			this.hp = Math.max(100, this.hp); //prophecy fulfilled. but hp and luck will probably drain again.
			this.minLuck = 30; //prophecy fulfilled. you are no longer doomed.
		}
		if(!this.godTier){ //god tiers only make ghosts in GodTierRevivial
			var g = makeRenderingSnapshot(this);
			g.fraymotifs = this.fraymotifs.slice(0); //copy not reference
			this.session.afterLife.addGhost(g);
		}

		this.renderSelf();
		this.triggerOtherPlayersWithMyDeath();
	}

	//this used to happen in beTriggered. fuck that noise, it was shit.
	this.triggerOtherPlayersWithMyDeath = function(){
		//go through my relationships. if i am the only dead person, trigger everybody (death still has impact)
		//trigger (possibly ontop of base trigger) friends, and quadrant mates. really fuck up my moirel(s) if i have any
		//if triggered, also give a flip out reason.
		var dead = findDeadPlayers(this.session.players);
		for(var i = 0; i <this.relationships.length; i++){
			var r = this.relationships[i];

			if(r.saved_type == r.goodBig){
				r.target.sanity += -10;
				if(r.target.flipOutReason == null){
					r.target.flipOutReason = " their dead crush, the " + this.htmlTitleBasic(); //don't override existing flip out reasons. not for something as generic as a dead crush.
					r.target.flippingOutOverDeadPlayer = this;
				}
			}else if(r.value > 0){
				r.target.sanity += -10;
				if(r.target.flipOutReason == null){
					 r.target.flippingOutOverDeadPlayer = this;
					 r.target.flipOutReason = " their dead friend, the " + this.htmlTitleBasic(); //don't override existing flip out reasons. not for something as generic as a dead friend.
				}
			}else if(r.saved_type == r.spades){
				r.target.sanity += -100;
				r.target.flipOutReason = " their dead Kismesis, the " + this.htmlTitleBasic();
				r.target.flippingOutOverDeadPlayer = this;
			}else if(r.saved_type == r.heart){
				r.target.sanity += -100
				r.target.flipOutReason = " their dead Matesprit, the " + this.htmlTitleBasic();
				r.target.flippingOutOverDeadPlayer = this;
			}
			else if(r.saved_type == r.diamond){
				r.target.sanity += -1000
				r.target.damageAllRelationships();
				r.target.damageAllRelationships();
				r.target.damageAllRelationships();
				r.target.flipOutReason = " their dead Moirail, the " + this.htmlTitleBasic() + ", fuck, that can't be good...";
				r.target.flippingOutOverDeadPlayer = this;
			}
			//console.log(r.target.title() + " has flipOutReason of: " + r.target.flipOutReason + " and knows about dead player: " + r.target.flippingOutOverDeadPlayer);
		}

		//whether or not i care about them, there's also the novelty factor.
		if(dead.length == 1){  //if only I am dead, death still has it's impact and even my enemies care.
			r.target.sanity += -10;
			if(r.target.flipOutReason == null){
				r.target.flipOutReason = " the dead player, the " + this.htmlTitleBasic(); //don't override existing flip out reasons. not for something as generic as a dead player.
			 r.target.flippingOutOverDeadPlayer = this;
			}
		}
	}

	//needed'cause ghost pacts are a an array of pairs now so i know how i'm reviving.
	this.getPactWithGhost = function(ghost){
		for(var i = 0; i<this.ghostPacts.length; i++){
			var g = this.ghostPacts[i][0]
			if(g == ghost) return g
		}
		return null;
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

	this.getCrushes = function(){
		var ret = [];
		for (var i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.goodBig){
				ret.push(r);
			}
		}
		return ret;
	}

	this.getBlackCrushes = function(){
		var ret = [];
		for (var i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.badBig){
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

	//what happened when you reached god tier was too inconsistent, and also
	//this lets sprite be updated.
	this.makeGodTier = function(){
		this.hp += 500; //they are GODS.
		this.power += 500;
		this.increasePower();
		this.godTier = true;
		this.session.godTier = true;
		this.dreamSelf = false;
		this.canGodTierRevive = true;
		this.leftMurderMode = false; //no scars, unlike other revival methods
		this.isDreamSelf = false;
		this.makeAlive();
	}



	this.makeAlive = function(){
			if(this.dead == false) return; //don't do all this.
			if(this.stateBackup) this.stateBackup.restoreState(this);
			this.influencePlayer = null;
			this.influenceSymbol = null;
			this.dead = false;
			this.murderMode = false;
			this.currentHP = Math.max(this.hp,1); //if for some reason your hp is negative, don't do that.
			//console.log("HP after being brought back from the dead: " + this.currentHP)
			this.grimDark = 0;
			this.sanity += -101;  //dying is pretty triggering.
			this.flipOutReason = "they just freaking died"
			//this.leftMurderMode = false; //no scars
			this.victimBlood = null; //clean face
			this.renderSelf();
		}




	this.title = function(){
		var ret = "";

		if(this.doomed){
			ret += "Doomed "
		}



		if(this.trickster){
			ret += "Trickster "
		}

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
		if(this.robot){
			ret += "Robo"
		}
		ret+= this.class_name + " of " + this.aspect;
		if(this.dead){
			ret += "'s Corpse"
		}else if(this.ghost){
			ret += "'s Ghost"
		}
		ret += " (" + this.chatHandle + ")"
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
		if(this.landLevel >= 9 && this.denizen_index < 3 && this.denizenDefeated == false){ //three quests before denizen
			//console.log("denizen quest")
			return getRandomDenizenQuestFromAspect(this); //denizen quests are aspect only, no class.
		}else if((this.landLevel < 9 || this.denizen_index >=3) && this.denizenDefeated == false){  //can do more land quests if denizen kicked your ass. need to grind.
			if(Math.seededRandom() > .5 || this.aspect == "Space"){ //back to having space players be locked to frogs.
				return getRandomQuestFromAspect(this.aspect);
			}else{
				return getRandomQuestFromClass(this.class_name);
			}
		}else if(this.denizenDefeated){
			//console.log("post denizen quests " +this.session.session_id);
			//return "restoring their land from the ravages of " + this.session.getDenizenForPlayer(this).name;
			if(Math.seededRandom() > .5 || this.aspect == "Space"){ //back to having space players be locked to frogs.
				return getRandomQuestFromAspect(this.aspect,true);
			}else{
				return getRandomQuestFromClass(this.class_name,true);
			}
		}

	}

	this.decideHemoCaste  =function (){
		if(this.aspect != "Blood"){  //sorry karkat
			this.bloodColor = getRandomElementFromArray(bloodColors);
		}
		this.applyPossiblePsionics();
	}

	//expect it to be first in list, so this is only bad if you DON'T have mind control AND have a shit ton of fraymotifs.
	this.canMindControl = function(){
		for(var i = 0; i<this.fraymotifs.length; i++){
			if(this.fraymotifs[i].name == "Mind Control") return this.fraymotifs[i].name;
		}
		return false;
	}

	this.canGhostCommune = function(){
		for(var i = 0; i<this.fraymotifs.length; i++){
			if(this.fraymotifs[i].name == "Ghost Communing")return  this.fraymotifs[i].name;
		}
		return false;
	}

	//psionics are less than game powers, so tier 1 only.
	this.psionicList = function(){
		var psionics = [];
		//telekenisis, mind control, mind reading, ghost communing, animal communing, laser blasts, vision xfold.
		var f = new Fraymotif([],  "Telekinisis", 1)
		f.effects.push(new FraymotifEffect("power",2,true));
		f.flavorText = " Large objects begin pelting the ENEMY. "
		psionics.push(f);

		var f = new Fraymotif([],  "Pyrokinisis", 1)
		f.effects.push(new FraymotifEffect("power",2,true));
		f.flavorText = " Who knew shaving cream was so flammable? "
		psionics.push(f);

		var f = new Fraymotif([],  "Aquakinesis", 1)
		f.effects.push(new FraymotifEffect("power",2,true));
		f.flavorText = " A deluge begins damaging the ENEMY. "
		psionics.push(f);

		var f = new Fraymotif([],  "Mind Control", 1)
		f.effects.push(new FraymotifEffect("freeWill",3,true));
		f.effects.push(new FraymotifEffect("freeWill",3,false));
		f.flavorText = " All enemies start damaging themselves. It's kind of embarassing how easy this is.  "
		psionics.push(f);


		var f = new Fraymotif([],  "Optic Blast", 1)
		f.effects.push(new FraymotifEffect("power",2,true));
		f.flavorText = " Appropriately colored eye beams pierce the ENEMY. "
		psionics.push(f);

		var f = new Fraymotif([],  "Ghost Communing", 1)
		f.effects.push(new FraymotifEffect("sanity",3,true));
		f.effects.push(new FraymotifEffect("sanity",3,false));
		f.flavorText = " The souls of the dead start hassling all enemies. "
		psionics.push(f);

		var f = new Fraymotif([],  "Animal Communing", 1)
		f.effects.push(new FraymotifEffect("sanity",3,true));
		f.effects.push(new FraymotifEffect("sanity",3,false));
		f.flavorText = " Local animal equivalents start hassling all enemies. "
		psionics.push(f);

		return psionics;
	}

	this.applyPossiblePsionics = function(){
	   // console.log("Checking to see how many fraymotifs I have: " + this.fraymotifs.length + " and if I am a troll: " + this.isTroll);
		if(this.fraymotifs.length > 0 || !this.isTroll) return; //if i already have fraymotifs, then they were probably predefined.
		//highest land dwellers can have chucklevoodoos. Other than that, lower on hemospectrum = greater odds of having psionics.
		//make sure psionic list is kept in global var, so that char creator eventually can access? Wait, no, just wrtap it in a function here. don't polute global name space.
		//trolls can clearly have more than one set of psionics. so. odds of psionics is inverse with hemospectrum position. didn't i do this math before? where?
		//oh! low blood vocabulary!!! that'd be in quirks, i think.
		//console.log("My blood color is: " + this.bloodColor);
		var odds = 10 - bloodColors.indexOf(this.bloodColor);   //want gamzee and above to have NO powers (will give highbloods chucklevoodoos separate)
		var powers = this.psionicList();
		for(var i = 0; i<powers.length; i++){
			if(Math.seededRandom()*40 < odds ){  //even burgundy bloods have only a 25% shot of each power.
				this.fraymotifs.push(powers[i]);
			}
		}
		//special psionics for high bloods and lime bloods.  highblood: #631db4  lime: #658200
		if(this.bloodColor == "#631db4"){
			var f = new Fraymotif([],  "Chucklevoodoos", 1)
			f.effects.push(new FraymotifEffect("sanity",3,false));
			f.effects.push(new FraymotifEffect("sanity",3,true));
			f.flavorText = " Oh god oh no no no no no no no no. The enemies are no longer doing okay, psychologically speaking. "
			this.fraymotifs.push(f);
		}else if(this.bloodColor == "#658200"){
			var f = new Fraymotif([],  "Limeade Refreshment", 1)
			f.effects.push(new FraymotifEffect("sanity",1,false));
			f.effects.push(new FraymotifEffect("sanity",1,true));
			f.flavorText = " All allies just settle their shit for a little while. Cool it. "
			this.fraymotifs.push(f);
		}else if(this.bloodColor == "#ffc3df"){
		    var f = new Fraymotif([],  "'<font color='pink'>"+this.chatHandle + " and the Power of Looove~~~~~<3<3<3</font>'", 1)
            f.effects.push(new FraymotifEffect("RELATIONSHIPS",3,false));
            f.effects.push(new FraymotifEffect("RELATIONSHIPS",3,true));
            f.flavorText = " You are pretty sure this is not a real type of Troll Psionic.  It heals everybody in a bullshit parade of sparkles, and heart effects despite your disbelief. Everybody is also SUPER MEGA ULTRA IN LOVE with each other now, but ESPECIALLY in love with  " + this.htmlTitleHP() + ". "
            this.fraymotifs.push(f);
		}
	}

	this.decideLusus = function(player){
		if(this.bloodColor == "#610061" || this.bloodColor == "#99004d" || this.bloodColor == "#631db4" ){
			this.lusus = getRandomElementFromArray(sea_lusus_objects);
		}else{
			this.lusus = getRandomElementFromArray(lusus_objects);
		}
	}

	this.isVoidAvailable = function(){
		var light = findAspectPlayer(findLivingPlayers(this.session.players), "Light");
		if(light && light.godTier) return false;
		return true;
	}

	//classes only, at least for now
	this.getPVPModifier = function(role){
		if(role == "Attacker") return this.getAttackerModifier();
		if(role == "Defender") return this.getDefenderModifier();
		if(role == "Murderer") return this.getMurderousModifier();

	}

	this.renderable = function(){
		return true;
	}

	//basically free will shit. choosing to kill a player despite not being crazy
	this.getAttackerModifier = function(){
		if(this.class_name == "Knight") return 1.0;
		if(this.class_name == "Seer") return 0.67;
		if(this.class_name == "Bard") return 2.0;
		if(this.class_name == "Maid") return 0.33;
		if(this.class_name == "Heir") return 0.5;
		if(this.class_name == "Rogue") return 1.25;
		if(this.class_name == "Page"){
			if(this.godTier){
				return 5.0;
			}else{
				return 1.0;
			}
		}
		if(this.class_name == "Thief") return 1.5;
		if(this.class_name == "Sylph") return 2.5;
		if(this.class_name == "Prince") return 5.0;
		if(this.class_name == "Witch") return 2.0;
		if(this.class_name == "Mage") return 0.67;
		return 1.0;
	}



	//defending yourself from an attack
	this.getDefenderModifier = function(){
		if(this.class_name == "Knight") return 2.5;
		if(this.class_name == "Seer") return 0.67;
		if(this.class_name == "Bard") return 0.5;
		if(this.class_name == "Maid") return 3.0;
		if(this.class_name == "Heir") return 2.0;
		if(this.class_name == "Rogue") return 1.25;
		if(this.class_name == "Page"){
			if(this.godTier){
				return 5.0;
			}else{
				return 1.0;
			}
		}
		if(this.class_name == "Thief") return 0.8;
		if(this.class_name == "Sylph") return 1.0;
		if(this.class_name == "Prince") return 0.33;
		if(this.class_name == "Witch") return 1.0;
		if(this.class_name == "Mage") return 0.67;
		return 1.0;
	}

	//being shit flippingly crazy AND initiating a fight
	this.getMurderousModifier = function(){
		if(this.class_name == "Knight") return 0.75;
		if(this.class_name == "Seer") return 1.0;
		if(this.class_name == "Bard") return 3.0;
		if(this.class_name == "Maid") return 1.5;
		if(this.class_name == "Heir") return 1.5;
		if(this.class_name == "Rogue") return 1.0;
		if(this.class_name == "Page"){
			if(this.godTier){
				return 5.0;
			}else{
				return 1.0;
			}
		}
		if(this.class_name == "Thief") return 1.0;
		if(this.class_name == "Sylph") return 1.5;
		if(this.class_name == "Prince") return 1.5;
		if(this.class_name == "Witch") return 1.5;
		if(this.class_name == "Mage") return 1.5;
		return 1.0;
	}


	this.getDenizen = function(){
		return this.denizen.name; //<--convineint that it wasn't hard to upgrade.
	}

	this.didDenizenKillYou = function(){
		if(this.causeOfDeath.indexOf(this.denizen.name) != -1){
			return true; //also return true for minions. this is intentional.
		}
		return false;
	}

	//more likely if lots of people hate you
	this.justDeath = function(){
		var ret = false;

		//impossible to have a just death from a denizen or denizen minion. unless you are corrupt.
		if(this.didDenizenKillYou() && !this.grimDark <= 2){
			return false;
		}else if(this.grimDark > 2){
			console.log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!just death for a corrupt player from their denizen or denizen minion in session: " + this.session.session_id)
			return true; //always just if the denizen puts down a corrupt player.
		}


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

		//it's not heroic derping to death against a minion or whatever, or in a solo fight.
		if(this.didDenizenKillYou() || this.causeOfDeath == "from a Bad Break."){
			return false;
		}

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



	this.hasInteractionEffect = function(){
		return this.class_name == "Prince" || this.class_name == "Bard"|| this.class_name == "Witch"|| this.class_name == "Sylph"|| this.class_name == "Rogue"|| this.class_name == "Thief"
	}

	this.associatedStatsInteractionEffect = function(player){
		if(this.hasInteractionEffect()){ //don't even bother if you don't have an interaction effect.
			for(var i = 0; i<this.associatedStats.length; i++){
				this.processStatInteractionEffect(player, this.associatedStats[i]);
			}
		}
	}


	this.processStatInteractionEffect = function(player, stat){
		var powerBoost = this.power/20;
		if(this.class_name == "Witch"|| this.class_name == "Sylph"){
			powerBoost = powerBoost *  2 //sylph and witch get their primary boost here, so make it a good one.
		}
		var powerBoost = this.modPowerBoostByClass(powerBoost,stat);
		if(this.class_name == "Rogue"|| this.class_name == "Thief"){
		    powerBoost = 3 * powerBoost; //make up for how shitty your boost is for increasePower, THIS is how you are supposed to level.
			player.modifyAssociatedStat((-1 * powerBoost), stat);
			if(this.isActive()){ //modify me
				this.modifyAssociatedStat(powerBoost, stat);
			}else{  //modify others.
				for(var i = 0; i<this.session.players.length; i++){
					this.session.players[i].modifyAssociatedStat(powerBoost/this.session.players.length, stat);
				}
			}
		}else{
			if(this.isActive()){ //modify me
				this.modifyAssociatedStat(powerBoost, stat);
			}else{  //modify others.
				player.modifyAssociatedStat(powerBoost, stat);
			}
		}
	}

	this.interactionEffect = function(player){

		this.associatedStatsInteractionEffect(player);

		//no longer do this seperate. if close enough to modify with powers, close enough to be...closer.
		r1 = this.getRelationshipWith(player);
		if(r1){
			r1.moreOfSame();
		}

	}

	//SBURB is not a mystery to these classes/aspects.  TODO MAKE THIS AN ACTUAL ASSOCIATED STAT
	this.knowsAboutSburb = function(){
		//time might not innately get it, but they have future knowledge
		var rightClass = this.class_name == "Sage" || this.class_name == "Scribe" || this.class_name == "Seer" || this.class_name == "Mage" || this.aspect == "Light" || this.aspect == "Mind" || this.aspect == "Doom" || this.aspect == "Time"
		return rightClass && this.power > 20; //need to be far enough in my claspect
	}

	this.performEctobiology = function(session){
		session.ectoBiologyStarted = true;
		playersMade = findPlayersWithoutEctobiologicalSource(session.players);
		setEctobiologicalSource(playersMade, session.session_id)
		return playersMade;
	}

	this.isActive = function(){
		return active_classes.indexOf(this.class_name) != -1;
	}



	//each player knows how to generate their own guardian.
	this.makeGuardian =function(){
		//console.log("guardian for " + player.titleBasic());
		var player = this;
		var possibilities = available_classes_guardians;
		if(possibilities.length == 0) possibilities = classes;
		//console.log("class names available for guardians is: " + possibilities)
		var guardian = randomPlayerWithClaspect(this.session, getRandomElementFromArray(possibilities), this.aspect);
        available_classes_guardians.removeFromArray(guardian.class_name)
		guardian.isTroll = player.isTroll;
		guardian.quirk.favoriteNumber = player.quirk.favoriteNumber;
		if(guardian.isTroll){
			guardian.quirk = randomTrollSim(guardian) //not same quirk as guardian
		}else{
			guardian.quirk = randomHumanSim(guardian);
		}

		guardian.bloodColor = player.bloodColor;
		guardian.lusus = player.lusus;
		if(guardian.isTroll == true){ //trolls always use lusus.
			guardian.object_to_prototype = player.object_to_prototype;
		}
		guardian.hairColor = player.hairColor;

		//console.log("Guardian className: " + guardian.class_name + " Player was: " + this.class_name);
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
		guardian.initializeDerivedStuff();//redo levels and land based on real aspect
		//this.guardians.push(guardian); //sessions don't keep track of this anymore
		player.guardian = guardian;
		guardian.guardian = this;//goes both ways.
	}



	this.associatedStatsIncreasePower = function(powerBoost){
		//modifyAssociatedStat
		for(var i = 0; i< this.associatedStats.length; i++){
			this.processStatPowerIncrease(powerBoost, this.associatedStats[i]);
		}
	}

	this.modPowerBoostByClass = function(powerBoost,stat){
		switch (this.class_name) {
			case "Knight":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * 2;
				}else{
					powerBoost = powerBoost * 0.5
				}
				break;
            case "Scout":
                if(stat.multiplier > 0){
                    powerBoost = powerBoost * 2;
                }else{
                    powerBoost = powerBoost * 0.5
                }
                break;
            case "Guide":
                if(stat.multiplier > 0){
                    powerBoost = powerBoost * 2;
                }else{
                    powerBoost = powerBoost * 0.5
                }
                break;
			case  "Seer":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * 2;
				}else{
					powerBoost = powerBoost * 2.5
				}
				break;
			case  "Bard":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * -0.5; //good things invert to bad.
				}else{
					powerBoost = powerBoost * -2.0; //bad thigns invert to good, with a boost to make up for the + to bad things
				}
				break;
			case  "Heir":
				powerBoost = powerBoost * 1.5;
				break;
			case  "Maid":
				powerBoost = powerBoost * 1.5;
				break;
			case  "Rogue":
				powerBoost = powerBoost * 0.5;
				break;
			case  "Page":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * 2;
				}else{
					powerBoost = powerBoost * 0.5
				}
				break;
			case  "Thief":
				powerBoost = powerBoost * 0.5;
				break;
			case  "Sylph":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * 0.5;
				}else{
					powerBoost = powerBoost * -0.5
				}
				break;
			case  "Prince":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * -0.5; //good things invert to bad.
				}else{
					powerBoost = powerBoost * -2.0; //bad thigns invert to good, with a boost to make up for the + to bad things
				}
				break;
			case  "Witch":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * 0.5;
				}else{
					powerBoost = powerBoost *-0.5
				}
				break;
			case  "Mage":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * 2;
				}else{
					powerBoost = powerBoost * 2.5
				}
				break;

			case  "Sage":
                if(stat.multiplier > 0){
                    powerBoost = powerBoost * 1;
                }else{
                    powerBoost = powerBoost * 0.25
                }
                break;

            case  "Scribe":
                if(stat.multiplier > 0){
                    powerBoost = powerBoost * 1;
                }else{
                    powerBoost = powerBoost * 0.25
                }
                break;

			case  "Waste":
				powerBoost = powerBoost * 0;  //wastes WASTE their abilities, until the cataclysm.
				break;
			default:
				console.log('What the hell kind of class is ' + this.class_name + '???');
		}

		return powerBoost;
	}

	this.resetFraymotifs = function(){
		for(var i = 0; i<this.fraymotifs.length; i++){
			this.fraymotifs[i].usable = true;
		}
	}

	this.processStatPowerIncrease = function(powerBoost, stat){
		var powerBoost = this.modPowerBoostByClass(powerBoost,stat);
		if(this.isActive()){ //modify me
			this.modifyAssociatedStat(powerBoost, stat);
		}else{  //modify others.
			powerBoost = 1* powerBoost; //to make up for passives being too nerfed. 1 for you
			this.modifyAssociatedStat(powerBoost* 0.5, stat); //half for me
			for(var i = 0; i<this.session.players.length; i++){
				this.session.players[i].modifyAssociatedStat(powerBoost/this.session.players.length, stat);
			}
		}
	}


	this.increasePower = function(){
		if(Math.seededRandom() >.9){
			this.leveledTheHellUp = true; //that multiple of ten thing is bullshit.
		}
		var powerBoost = 1;

		if(this.class_name == "Page"){  //they don't have many quests, but once they get going they are hard to stop.
			powerBoost = powerBoost * 5;
		}


		if(this.godTier){
			powerBoost = powerBoost * 20;  //god tiers are ridiculously strong.
		}

		if(this.denizenDefeated){
			powerBoost = powerBoost * 2; //permanent doubling of stats forever.
		}

		this.power += powerBoost;

		this.associatedStatsIncreasePower(powerBoost);
		//gain a bit of hp, otherwise denizen will never let players fight them if their hp isn't high enough.
		if(this.godTier || Math.seededRandom() >.85){
			this.hp += 5;
			this.currentHP += 5;
		}
		if(this.power > 0) this.power = Math.round(this.power);

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

	this.htmlTitleHP = function(){
		return getFontColorFromAspect(this.aspect) + this.title() + " (" + Math.round(this.getStat("currentHP"))+ "hp, " + Math.round(this.getStat("power")) + " power)</font>"
	}

	this.generateBlandRelationships = function(friends){
		for(var i = 0; i<friends.length; i++){
			if(friends[i] != this){  //No, Karkat, you can't be your own Kismesis.
				//one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
				//that it needs to be a thing.
				var r = randomBlandRelationship(friends[i])
				if(this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d"){
					r.value = -20; //biological imperitive to fight for throne.
					this.sanity += -100;
					friends[i].sanity += -100;
				}
				this.relationships.push(r);
			}
		}
	}

	this.generateRelationships = function(friends){
	//	console.log(this.title() + " generating a relationship with: " + friends.length);
		for(var i = 0; i<friends.length; i++){
			if(friends[i] != this){  //No, Karkat, you can't be your own Kismesis.
				//one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
				//that it needs to be a thing.
				var r = randomRelationship(friends[i])
				if(this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d"){
					r.value = -20; //biological imperitive to fight for throne.
					this.sanity += -10;
					friends[i].sanity += -10;
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
	//if i pass a stat, then i want you to only look at one luck stat not the other.
	this.rollForLuck = function(stat){
		if(!stat){
		    return getRandomInt(this.getStat("minLuck"), this.getStat("maxLuck"));
		}else{
		    //don't care if it's min or max, just compare it to zero.
		    return getRandomInt(0, this.getStat(stat));
		}

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


	//checks array of buffs, and adds up all buffs that effect a given stat.
	//useful so combat can now how to describe status.
	this.getTotalBuffForStat = function(statName){
	    var ret = 0;
	    for(var i = 0; i<this.buffs.length; i++){
	        var b = this.buffs[i];
	        if(b.name == statName) ret += b.value;
	    }
	    return ret;
	}

	this.humanWordForBuffNamed = function(statName){
        if(statName == "MANGRIT") return "powerful"
        if(statName == "hp") return "sturdy"
        if(statName == "RELATIONSHIPS") return "friendly"
        if(statName == "mobility") return "fast"
        if(statName == "sanity") return "calm"
        if(statName == "freeWill") return "willful"
        if(statName == "maxLuck") return "lucky"
        if(statName == "minLuck") return "lucky"
        if(statName == "alchemy") return "creative"
	}

	//used for strifes.
	this.describeBuffs = function(){
	    var ret = [];
	    var allStats = this.allStats();
	    for(var i = 0; i<allStats.length; i++){
	        var b = this.getTotalBuffForStat(allStats[i]);
	        //only say nothing if equal to zero
	        if(b>0) ret.push("more "+this.humanWordForBuffNamed(allStats[i]));
	        if(b<0) ret.push("less " + this.humanWordForBuffNamed(allStats[i]));
	    }
	    if(ret.length == 0) return "";
	    //console.log("buffs printing out in: " + this.session.session_id);
	    return "<Br><Br>" +this.htmlTitleHP() + " is feeling " + turnArrayIntoHumanSentence(ret) + " than normal. ";
	}

	//remember that hp and currentHP are different things.
	this.getStat = function(statName){
		var ret =  0;
		if(statName == "RELATIONSHIPS"){ //relationships, why you so cray cray???

			for(var i = 0; i<this.relationships.length; i++){
                ret += this.relationships[i].value;
            }
		} else if(statName == "power" ){
		    ret += this[statName];
		    ret += this.permaBuffs["MANGRIT"] //needed because if i mod power directly, it effects all future progress in an unbalanced way.
		}else{
		    ret += this[statName]
		}

		for(var i = 0; i<this.buffs.length; i++){
			var b = this.buffs[i];
			if(b.name == statName) ret += b.value;
		}

		if(statName == "power") ret = Math.max(0, ret); //no negative power, dunkass.
		return Math.round(ret);
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
		return (this.class_name == "Rogue" || this.class_name == "Sage" ||  this.class_name == "Waste" ||  this.class_name == "Guide" || this.class_name == "Knight" || this.class_name == "Maid"|| this.class_name == "Mage"|| this.class_name == "Sylph"|| this.class_name == "Prince")
	}

	this.initializeLuck = function(){
		this.minLuck = getRandomInt(0,-10); //middle of the road.
		this.maxLuck = this.minLuck + getRandomInt(10,1);   //max needs to be more than min.
		if(this.trickster && this.aspect != "Doom"){
			this.minLuck = 11111111111;
			this.maxLuck = 11111111111;
		}

	}

	this.decideTroll = function decideTroll(player){
		if(this.session.getSessionType() == "Human"){
			this.hairColor = getRandomElementFromArray(human_hair_colors);
			return;
		}

		if(this.session.getSessionType() == "Troll" || (this.session.getSessionType() == "Mixed" &&Math.seededRandom() > 0.5) ){
			this.isTroll = true;
			this.hairColor = "#000000"
			this.decideHemoCaste();
			this.decideLusus();
			this.object_to_prototype = this.lusus;
		}else{
			this.hairColor = getRandomElementFromArray(human_hair_colors);
		}
	}

	this.initializeFreeWill = function(){
		this.freeWill = getRandomInt(-10,10);
		if(this.trickster && this.aspect != "Doom"){
			this.freeWill = 11111111111;
		}
	}

	this.initializeHP= function(){
		this.hp = getRandomInt(40,60);
		this.currentHP = this.hp;
		if(this.trickster && this.aspect != "Doom"){
			this.currentHP = 11111111111;
			this.hp = 11111111111;
		}

		if(this.isTroll && this.bloodColor != "#ff0000"){
			this.currentHP += bloodColorToBoost(this.bloodColor);
			this.hp += bloodColorToBoost(this.bloodColor);
		}
	}

	this.initSpriteCanvas = function(){
		//console.log("Initializing derived stuff.")
		this.spriteCanvasID = this.id+"spriteCanvas";
		var canvasHTML = "<br><canvas style='display:none' id='" + this.spriteCanvasID+"' width='" +400 + "' height="+300 + "'>  </canvas>";
		$("#playerSprites").append(canvasHTML)
	}

	this.renderSelf = function(){
		if(!this.spriteCanvasID) this.initSpriteCanvas();
		var canvasDiv = document.getElementById(this.spriteCanvasID);

		var ctx = canvasDiv.getContext("2d");
		this.clearSelf();
		//var pSpriteBuffer = this.session.sceneRenderingEngine.getBufferCanvas(document.getElementById("sprite_template"));
		var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSpriteFromScratch(pSpriteBuffer, this);
		copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,0,0)
		//this.session.sceneRenderingEngine.drawSpriteFromScratch(pSpriteBuffer, this);
		//this.session.sceneRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,0,0)
	}

	this.clearSelf = function(){
		var canvasDiv = document.getElementById(this.spriteCanvasID);
		var ctx = canvasDiv.getContext("2d");
		ctx.clearRect(0, 0, canvasDiv.width, canvasDiv.height)
	}

	this.initializeMobility = function(){
		this.mobility = getRandomInt(0,10);
		if(this.trickster && this.aspect != "Doom"){
			this.mobility = 11111111111;
		}
	}

	this.initializeSanity = function(){
		this.sanity = getRandomInt(-10,10);
	}

	//don't recalculate values, but can boost postivily or negatively by an amount. sure.
	this.initializeRelationships = function(){
		if(this.trickster && this.aspect != "Doom" && this.aspect != "Heart"){
		for(var k = 0; k <this.relationships.length; k++){
				var r = this.relationships[k];
				r.value = 111111; //EVERYTHIGN IS BETTER!!!!!!!!!!!
				r.saved_type = r.goodBig;
			}
		}

		if(this.isTroll && this.bloodColor == "#99004d"){
			for(var i = 0; i<this.relationships.length; i++){
				//needs to be part of this in ADDITION to initialization because what about custom players now.
				var r = this.relationships[i];
				if(this.isTroll && this.bloodColor == "#99004d" && r.target.isTroll && r.target.bloodColor == "#99004d"){
					r.value = -20; //biological imperitive to fight for throne.
					this.sanity += -10;
					r.target.sanity += -10;
				}
			}
		}
        console.log("initializing relationships")
		if(this.robot || this.grimDark>1){ //you can technically start grimDark
			for(var k = 0; k <this.relationships.length; k++){
					var r = this.relationships[k];
					r.value = 0; //robots are tin cans with no feelings
					r.saved_type = r.neutral;
					r.old_type = r.neutral;
				}
		}
	}

	this.getNewFraymotif = function(helper){
		var f;
		if(this.godTier){
			f = this.session.fraymotifCreator.makeFraymotifForPlayerWithFriends(this, helper, 3);
		}else if (this.denizenDefeated){
			f = this.session.fraymotifCreator.makeFraymotifForPlayerWithFriends(this, helper, 2);
		}else{
			f = this.session.fraymotifCreator.makeFraymotifForPlayerWithFriends(this, helper, 1);
		}
		this.fraymotifs.push(f);
		return f;
	}

	this.initializePower = function(){
		this.power = 0;
		if(this.trickster && this.aspect != "Doom"){
			this.power = 11111111111;
		}

		if(this.robot){
			this.power += 100; //robots are superior
		}

		if(this.isTroll && this.bloodColor != "#ff0000"){
			this.power += bloodColorToBoost(this.bloodColor);
		}
	}


	this.toDataStrings = function(includeChatHandle){
		var ch = "";
		if(includeChatHandle) ch = sanitizeString(this.chatHandle);
		var ret = ""+sanitizeString(this.causeOfDrain) + ","+sanitizeString(this.causeOfDeath) + "," + sanitizeString(this.interest1) + "," + sanitizeString(this.interest2) + "," + sanitizeString(ch)
		return ret;
	}

	//not compressed
	this.toOCDataString = function(){
	    //for now, only extentsion sequence is for classpect. so....
	   // var x = "&x=" +this.toDataBytesX(); //ALWAYS have it. worst case scenario is 1 bit.
	    var x = ""; //come back later to fix this. this.toDataBytes needs to not be a string.
		return "b=" + this.toDataBytes() + "&s="+this.toDataStrings(true) + x;
	}

	//for now, only type is 1, which is class + aspect.
	/*
	    TODO COMEBACK L8R AND FIX THIS.  needs to return bytes, not string
	    so byte builder can handle makign the joing x string for mulitple players
	*/
	this.toDataBytesX = function(){
        var builder = new ByteBuilder();
        var j = this.toJSON();
        if(j.class_name <= 15 && j.aspect <= 15){ //if NEITHER have need of extension, just return size zero
            builder.appendExpGolomb(0) //for length
            return encodeURIComponent(byteArrayToString(builder.toBuffer())).replace(/#/g, '%23').replace(/&/g, '%26');
        }
        builder.appendExpGolomb(2) //for length
        builder.appendByte(j.class_name);
        builder.appendByte(j.aspect);
        return encodeURIComponent(byteArrayToString(builder.toBuffer())).replace(/#/g, '%23').replace(/&/g, '%26');
	}

    //values for extension string should overwrite existing values.
    //takes in a reader because it acts as a stream, not a byte array
    //read will read "next thing", all player has to do is know how to handle self.
	this.readInExtensionsString = function(reader){
	    console.log("reading in extension string")
	    //just inverse of encoding process.
	    var numFeatures = reader.readExpGolomb(); //assume features are in set order. and that if a given feature is variable it is ALWAYS variable.
	    console.log("num features is: " + numFeatures);
	    console.log(["read bytes is: ",reader]);

	     if(numFeatures > 0){
	      var cid = reader.readByte();
	      console.log("Class Name ID : " + cid)
	      this.class_name = intToClassName(cid);
	      }
	    if(numFeatures > 1){
			var aid = reader.readByte();
			console.log("Aspect ID : " + aid)
			this.aspect = intToAspect(aid);
		} 
	    //as i add more things, add more lines. ALWAYS in same order, but not all features all the time.
	}


	/*
		3 bytes: (24 bits) hairColor
		1 byte: class/asspect
		1 byte victimBlood, bloodColor
		1 byte interest1Category, interest2Category
		1 byte griDark,isTroll, isDreamSelf, isGodTier, murderMode, leftMurderMode
		1 byte extra binaries, like robotMode,moon, dead, godTierDestiny, (4 bits) favoriteNumber
		1 byte  leftHorn
		1byte  rightHorn
		1byte hair

		I am the l337est asshole in the world
	*/
	this.toDataBytes = function(){
		var json = this.toJSON(); //<-- gets me data in pre-compressed format.
		var buffer = new ArrayBuffer(11);
		var ret = ""; //gonna return as a string of chars.
		var uint8View = new Uint8Array(buffer);
		uint8View[0] = json.hairColor >> 16 //hair color is 12 bits. chop off 4 on right side, they will be in buffer[1]
		uint8View[1] = json.hairColor >> 8
		uint8View[2] = json.hairColor >> 0
		uint8View[3] = (json.class_name << 4) + json.aspect  //when I do fanon classes + aspect, use this same scheme, but have binary for "is fanon", so I know 1 isn't page, but waste (or whatever)
		uint8View[4] = (json.victimBlood << 4) + json.bloodColor
		uint8View[5] = (json.interest1Category <<4) + json.interest2Category
		uint8View[6] = (json.grimDark << 5) + (json.isTroll << 4) + (json.isDreamSelf << 3) + (json.godTier << 2) + (json.murderMode <<1) + (json.leftMurderMode) //shit load of single bit variables.
		uint8View[7] = (json.robot << 7) + (json.moon << 6) + (json.dead << 5) + (json.godDestiny <<4) + (json.favoriteNumber)
		uint8View[8] = json.leftHorn
		uint8View[9] = json.rightHorn
		uint8View[10] = json.hair
		//console.log(uint8View);
		for(var i = 0; i<uint8View.length; i++){
			ret += String.fromCharCode(uint8View[i]);
		}
		return encodeURIComponent(ret).replace(/#/g, '%23').replace(/&/g, '%26');
	}


	//initial step before binary compression
	this.toJSON = function(){
		var moon = 0;
		if(this.moon == "Prospit") moon =1;
		var json = {aspect: aspectToInt(this.aspect), class_name: classNameToInt(this.class_name), favoriteNumber: this.quirk.favoriteNumber, hair: this.hair,  hairColor: hexColorToInt(this.hairColor), isTroll: this.isTroll ? 1 : 0, bloodColor: bloodColorToInt(this.bloodColor), leftHorn: this.leftHorn, rightHorn: this.rightHorn, interest1Category: interestCategoryToInt(this.interest1Category), interest2Category: interestCategoryToInt(this.interest2Category), interest1: this.interest1, interest2: this.interest2, robot: this.robot ? 1 : 0, moon: moon,causeOfDrain: this.causeOfDrain,victimBlood: bloodColorToInt(this.victimBlood), godTier: this.godTier ? 1 : 0, isDreamSelf:this.isDreamSelf ? 1 : 0, murderMode:this.murderMode ? 1 : 0, leftMurderMode:this.leftMurderMode ? 1 : 0,grimDark:this.grimDark, causeOfDeath: this.causeOfDeath, dead: this.dead ? 1 : 0, godDestiny: this.godDestiny ? 1 : 0 };
		return json;
	}

	this.toString = function(){
		return (this.class_name+this.aspect).replace(/'/g, '');; //no spaces.
	}





	//if it's part of player json, need to copy it over.
	this.copyFromPlayer = function(replayPlayer){
		//console.log("copying from player who has a favorite number of: " + replayPlayer.quirk.favoriteNumber)
		//console.log("Overriding player from a replay Player. ")
		//console.log(replayPlayer)
		this.aspect = replayPlayer.aspect;
		this.class_name = replayPlayer.class_name;
		this.hair = replayPlayer.hair;
		this.hairColor = replayPlayer.hairColor;
		this.isTroll = replayPlayer.isTroll;
		this.bloodColor = replayPlayer.bloodColor;
		this.leftHorn = replayPlayer.leftHorn;
		this.rightHorn = replayPlayer.rightHorn;
		this.interest1 = replayPlayer.interest1.replace(/<(?:.|\n)*?>/gm, '');;
		this.interest2 = replayPlayer.interest2.replace(/<(?:.|\n)*?>/gm, '');;
		this.interest1Category = replayPlayer.interest1Category;
		this.interest2Category = replayPlayer.interest2Category;
		this.causeOfDrain = replayPlayer.causeOfDrain;
		this.causeOfDeath = replayPlayer.causeOfDeath;
		if(replayPlayer.chatHandle != ""){
			this.chatHandle = replayPlayer.chatHandle;
			this.deriveChatHandle = false;
		}
		this.isDreamSelf = replayPlayer.isDreamSelf;
		this.godTier = replayPlayer.godTier;
		this.godDestiny = replayPlayer.godDestiny;
		this.murderMode = replayPlayer.murderMode;
		this.leftMurderMode = replayPlayer.leftMurderMode;
		this.grimDark = replayPlayer.grimDark;
		this.moon = replayPlayer.moon;
		this.dead = replayPlayer.dead;
		this.victimBlood = replayPlayer.victimBlood
		this.robot = replayPlayer.robot;
		this.fraymotifs = [];  //whoever you were before, you don't have those psionics anymore
		this.applyPossiblePsionics(); //now you have new psionics
		//console.log("after applying psionics I have this many fraymotifs: " + this.fraymotifs.length);
		this.quirk.favoriteNumber = replayPlayer.quirk.favoriteNumber; //will get overridden, has to be after initialization, too, but if i don't do it here, char creartor will look wrong.
		this.makeGuardian();
		this.guardian.applyPossiblePsionics(); //now you have new psionics
	}


	this.initialize = function(){
		this.initializeStats();
		this.initializeSprite();
		this.initializeDerivedStuff();  //TODO handle troll derived stuff. like quirk.
	}


	this.initializeDerivedStuff = function(){
		var tmp =getRandomLandFromPlayer(this);
		this.land1 = tmp[0]
		this.land2 = tmp[1];
		this.land = "Land of " + tmp[0] + " and " + tmp[1];
		if(this.deriveChatHandle) this.chatHandle = getRandomChatHandle(this.class_name,this.aspect,this.interest1, this.interest2);
		this.mylevels = getLevelArray(this);//make them ahead of time for echeladder graphic

		if(this.isTroll){
			if(!this.quirk) this.quirk = randomTrollSim(this)  //if i already have a quirk it was defined already. don't override it.
			this.sanity += -10;//trolls are slightly less stable

		}else{
			if(!this.quirk) this.quirk = randomHumanSim(this);
		}
	}

	this.initializeSprite = function(){
		this.sprite = new GameEntity(session, "sprite",null); //unprototyped.
		//minLuck, maxLuck, hp, mobility, triggerLevel, freeWill, power, abscondable, canAbscond, framotifs, grist
		this.sprite.setStats(0,0,10,0,0,0,0,false, false, [],1000);//same as denizen minion, but empty power
		this.sprite.doomed = true
		this.sprite.sprite = true;
	}

	this.allStats = function(){
		return ["power", "hp","RELATIONSHIPS","mobility","sanity","freeWill","maxLuck","minLuck","alchemy"];
	}


	//sum to 0
	this.intializeAssociatedClassStatReferences = function(){
		return //don't do this for now, too confusing.
		var allStats = this.allStats().slice(0); //make copy
		allStats = allStats.concat("MANGRIT")
		allStats.removeFromArray("power"); //can't buff power directly
		switch (this.class_name) {
			case "Knight":
				this.associatedStats.push(new AssociatedStat("mobility", 0.5)); //will run to protect you.
				this.associatedStats.push(new AssociatedStat("hp", 0.5));
				this.associatedStats.push(new AssociatedStat("freeWill", -1));
				break;
			case  "Seer":
				this.associatedStats.push(new AssociatedStat("freeWill", 0.9));
				this.associatedStats.push(new AssociatedStat("MANGRIT", -0.9));
				break;
			case  "Bard":
				this.associatedStats.push(new AssociatedStat( getRandomElementFromArray(allStats), 1));
				this.associatedStats.push(new AssociatedStat( getRandomElementFromArray(allStats), -1));
				break;
			case  "Heir":
				this.associatedStats.push(new AssociatedStat("maxLuck", 0.5));
				this.associatedStats.push(new AssociatedStat("minLuck", 0.5));
				this.associatedStats.push(new AssociatedStat("freeWill", -1));
				break;
			case  "Maid":
				this.associatedStats.push(new AssociatedStat("sanity", 1));
				this.associatedStats.push(new AssociatedStat("minLuck", -1));
				break;
			case  "Rogue":
				this.associatedStats.push(new AssociatedStat("mobility", 0.5));
				this.associatedStats.push(new AssociatedStat("sanity", -0.5));
				break;
			case  "Page":
				this.associatedStats.push(new AssociatedStat("mobility", -0.5));
				this.associatedStats.push(new AssociatedStat("hp", 0.5));
				break;
			case  "Thief":
				this.associatedStats.push(new AssociatedStat("maxLuck", 0.5));
				this.associatedStats.push(new AssociatedStat("MANGRIT", -0.5));
				break;
			case  "Sylph":
				this.associatedStats.push(new AssociatedStat("hp", 0.5));
				this.associatedStats.push(new AssociatedStat("sanity", -0.5));
				break;
			case  "Prince":
				this.associatedStats.push(new AssociatedStat("MANGRIT", 1));
				this.associatedStats.push(new AssociatedStat("RELATIONSHIPS", -1));
				break;
			case  "Witch":
				this.associatedStats.push(new AssociatedStat("MANGRIT", 0.5));
				this.associatedStats.push(new AssociatedStat("freeWill", 0.5));
				this.associatedStats.push(new AssociatedStat("sanity", -1));
				break;
			case  "Mage":
				this.associatedStats.push(new AssociatedStat("freeWill", 1));
				this.associatedStats.push(new AssociatedStat("hp", -1));
				break;
			default:
				console.log('What the hell kind of class is ' + this.class_name + '???');
		}
	}

	this.getOnlyAspectAssociatedStats = function(){
		var ret = [];
		for(var i = 0; i<this.associatedStats.length; i++){
			if(this.associatedStats[i].isFromAspect) ret.push(this.associatedStats[i])
		}
		return ret;
	}

	this.getOnlyPositiveAspectAssociatedStats = function(){
		var ret = [];
		for(var i = 0; i<this.associatedStats.length; i++){
			if(this.associatedStats[i].isFromAspect && this.associatedStats[i].multiplier > 0) ret.push(this.associatedStats[i])
		}
		return ret;
	}

	this.getOnlyNegativeAspectAssociatedStats = function(){
		var ret = [];
		for(var i = 0; i<this.associatedStats.length; i++){
			if(this.associatedStats[i].isFromAspect && this.associatedStats[i].multiplier < 0) ret.push(this.associatedStats[i])
		}
		return ret;
	}

	//sum to 1
	this.intializeAssociatedAspectStatReferences = function(){
		var allStats = this.allStats().slice(0);
        allStats = allStats.concat("MANGRIT")
        allStats.removeFromArray("power"); //can't buff power directly

		switch (this.aspect) {
			case "Blood":
				this.associatedStats.push(new AssociatedStat("RELATIONSHIPS", 2,true));
				this.associatedStats.push(new AssociatedStat("sanity", 1,true));
				this.associatedStats.push(new AssociatedStat("maxLuck", -2,true));
				break;
			case  "Mind":
				this.associatedStats.push(new AssociatedStat("freeWill", 2,true));
				this.associatedStats.push(new AssociatedStat("minLuck", 1,true));
				this.associatedStats.push(new AssociatedStat("RELATIONSHIPS", -1,true));
				this.associatedStats.push(new AssociatedStat("maxLuck", -1,true)); //LUCK DO3SN'T M4TT3R!!!
				break;
			case  "Rage":
				this.associatedStats.push(new AssociatedStat("MANGRIT", 2,true));
				this.associatedStats.push(new AssociatedStat("mobility", 1,true));
				this.associatedStats.push(new AssociatedStat("sanity", -1,true));
				this.associatedStats.push(new AssociatedStat("RELATIONSHIPS", -1,true));
				break;
			case  "Void":
				this.associatedStats.push(new AssociatedStat( getRandomElementFromArray(allStats), 3,true)); //really good at one thing
				this.associatedStats.push(new AssociatedStat( getRandomElementFromArray(allStats), -1,true));  //hit to another thing.
				this.associatedStats.push(new AssociatedStat( "minLuck", -1,true));  //hit to another thing.
				break;
			case  "Time":
				this.associatedStats.push(new AssociatedStat("minLuck", 2,true));
				this.associatedStats.push(new AssociatedStat("mobility", 1,true));
				this.associatedStats.push(new AssociatedStat("freeWill", -2,true));
				break;
			case  "Heart":
				this.associatedStats.push(new AssociatedStat("RELATIONSHIPS", 1,true));
				this.associatedStats = this.associatedStats.concat(this.getInterestAssociatedStats(this.interest1));
				this.associatedStats = this.associatedStats.concat(this.getInterestAssociatedStats(this.interest2));
				break;
			case  "Breath":
				this.associatedStats.push(new AssociatedStat("mobility", 2,true));
				this.associatedStats.push(new AssociatedStat("sanity", 1,true));
				this.associatedStats.push(new AssociatedStat("hp", -1,true));
				this.associatedStats.push(new AssociatedStat( "RELATIONSHIPS", -1,true)); //somebody pointed out breath seems to destroy connections, sure, i'll roll with it.
				break;
			case  "Light":
				this.associatedStats.push(new AssociatedStat("maxLuck", 2,true));
				this.associatedStats.push(new AssociatedStat("freeWill", 1,true));
				this.associatedStats.push(new AssociatedStat("sanity", -1,true));
				this.associatedStats.push(new AssociatedStat("hp", -1,true));
				break;
			case  "Space":
				this.associatedStats.push(new AssociatedStat("alchemy", 2,true));
				this.associatedStats.push(new AssociatedStat("hp", 1,true));
				this.associatedStats.push(new AssociatedStat("mobility", -2,true));
				break;
			case  "Hope":
				this.associatedStats.push(new AssociatedStat("sanity", 2,true));
				this.associatedStats.push(new AssociatedStat("maxLuck", 1,true));
				this.associatedStats.push(new AssociatedStat( getRandomElementFromArray(allStats), -2,true));
				break;
			case  "Life":
				this.associatedStats.push(new AssociatedStat("hp", 2,true));
				this.associatedStats.push(new AssociatedStat("MANGRIT", 1,true));
				this.associatedStats.push(new AssociatedStat("alchemy", -2,true));
				break;
			case  "Doom":  //fool, doom will toot as it pleases
				this.associatedStats.push(new AssociatedStat("alchemy", 2,true));
				this.associatedStats.push(new AssociatedStat("freeWill", 1,true));
				this.associatedStats.push(new AssociatedStat("minLuck", -1,true));
				this.associatedStats.push(new AssociatedStat("hp", -1,true));
				break;
			default:
				console.log('What the hell kind of aspect is ' + this.aspect + '???');
		}
	}

	this.voidDescription = function(){
		for(var i = 0; i<this.associatedStats.length; i++){
			var stat = this.associatedStats[i];
			if(stat.multiplier >= 3) return "SO " + this.getEmphaticDescriptionForStatNamed(stat.name);
		}
		return "SO BLAND";
	}
	//["power","hp","RELATIONSHIPS","mobility","sanity","freeWill","maxLuck","minLuck","alchemy"]

	this.getEmphaticDescriptionForStatNamed = function(statName){
		if(this.highInit()){
			if(statName == "MANGRIT") return "STRONG"
			if(statName == "hp") return "STURDY"
			if(statName == "RELATIONSHIPS") return "FRIENDLY"
			if(statName == "mobility") return "FAST"
			if(statName == "sanity") return "CALM"
			if(statName == "freeWill") return "WILLFUL"
			if(statName == "maxLuck") return "LUCKY"
			if(statName == "minLuck") return "LUCKY"
			if(statName == "alchemy") return "CREATIVE"
		}else{
			if(statName == "MANGRIT") return "WEAK"
			if(statName == "hp") return "FRAGILE"
			if(statName == "RELATIONSHIPS") return "AGGRESSIVE"
			if(statName == "mobility") return "SLOW"
			if(statName == "sanity") return "CRAZY"
			if(statName == "freeWill") return "GULLIBLE"
			if(statName == "maxLuck") return "UNLUCKY"
			if(statName == "minLuck") return "UNLUCKY"
			if(statName == "alchemy") return "BORING"
		}
		return "CONFUSING";
	}

	//["power","hp","RELATIONSHIPS","mobility","sanity","freeWill","maxLuck","minLuck","alchemy"];
	this.getInterestAssociatedStats = function(interest){
		if(pop_culture_interests.indexOf(interest) != -1) return [new AssociatedStat("mobility",2, true)];
		if(music_interests.indexOf(interest) != -1) return [new AssociatedStat("sanity",1, true),new AssociatedStat("maxLuck",1, true)];
		if(culture_interests.indexOf(interest) != -1) return [new AssociatedStat("sanity",-1, true),new AssociatedStat("hp",-1, true)]; //SBURB is NOT high art.
		if(writing_interests.indexOf(interest) != -1) return [new AssociatedStat("freeWill",2, true)];  //they know how stories go.
		if(technology_interests.indexOf(interest) != -1) return [new AssociatedStat("alchemy",2, true)];
		if(social_interests.indexOf(interest) != -1) return [new AssociatedStat("sanity",2, true)];
		if(romantic_interests.indexOf(interest) != -1)return [new AssociatedStat("RELATIONSHIPS",2, true)];
		if(academic_interests.indexOf(interest) != -1) return [new AssociatedStat("freeWill",-2, true)]; //dont' get so caught up in how the old rules worked
		if(comedy_interests.indexOf(interest) != -1) return [new AssociatedStat("minLuck",-1, true),new AssociatedStat("maxLuck",1, true)]; //hilarious (to SBURB) pratfalls abound.
		if(domestic_interests.indexOf(interest) != -1) return [new AssociatedStat("sanity",1, true),new AssociatedStat("RELATIONSHIPS",1, true)];
		if(athletic_interests.indexOf(interest) != -1) return [new AssociatedStat("MANGRIT",2, true)]; //so STRONG
		if(terrible_interests.indexOf(interest) != -1) return [new AssociatedStat("RELATIONSHIPS",-1, true), new AssociatedStat("sanity",-1, true)];
		if(fantasy_interests.indexOf(interest) != -1) return [new AssociatedStat("maxLuck",1, true),new AssociatedStat("alchemy",1, true)];
		if(justice_interests.indexOf(interest) != -1) return [new AssociatedStat("MANGRIT",1, true),new AssociatedStat("hp",1, true)];
	}


	//care about highInit(), and also interestCategories.
	this.initializeAssociatedStats = function(){
		for(var i = 0; i<this.associatedStats.length; i++){
			if(this.highInit()){
				this.modifyAssociatedStat(10, this.associatedStats[i]);
			}else{
				this.modifyAssociatedStat(-10, this.associatedStats[i]);
			}
		}
	}


	//if RELATIONSHIPS, loop on all relationships.
	//up to who calls me to pick a sane value. (modified by class as appropriate)
	//you don't have to own the associated stat for it to modify you. A sylph will call this for each player in the party, for example
	//and pass their own stat, but it will mod the player's stat. don't worry about it.
	this.modifyAssociatedStat = function(modValue, stat){
		if(!stat) return;
		//modValue * stat.multiplier.
		if(stat.name == "RELATIONSHIPS"){
			for(var i = 0; i<this.relationships.length; i++){
				this.relationships[i].value += (modValue/this.relationships.length) * stat.multiplier;  //stop having relationship values on the scale of 100000
			}
		}else if(stat.name == "MANGRIT"){
			this.permaBuffs["MANGRIT"] += modValue * stat.multiplier;
		}else {
         	this[stat.name] += modValue * stat.multiplier;
        }
	}

	this.initializeInterestStats = function(){
		//getInterestAssociatedStats
		this.modifyAssociatedStat(35, this.getInterestAssociatedStats(this.interest1));
		this.modifyAssociatedStat(35, this.getInterestAssociatedStats(this.interest2));
	}

	//players can start with any luck, (remember, Vriska started out super unlucky and only got AAAAAAAALL the luck when she hit godtier)
	//make sure session calls this before first tick, cause otherwise won't be initialized by right claspect after easter egg or character creation.
	this.initializeStats = function(){
		if(this.trickster && this.aspect == "Doom") this.trickster == false; //doom players break rules
		this.associatedStats = []; //this might be called multiple times, wipe yourself out.
		this.intializeAssociatedAspectStatReferences();
		this.intializeAssociatedClassStatReferences();
		this.initializeLuck();
		this.initializeFreeWill();
		this.initializeHP();
		this.initializeMobility();
		this.initializeRelationships();
		this.initializePower();
		this.initializeSanity();

		this.initializeAssociatedStats();
		this.initializeInterestStats();  //takes the place of old random intial stats.
		//reroll goddestiny and sprite as well. luck might have changed.
		var luck = this.rollForLuck();
		if(this.class_name == "Witch" || luck < -9){
			this.object_to_prototype = getRandomElementFromArray(disastor_objects);
			//console.log("disastor")
		}else if(luck > 25){
			this.object_to_prototype = getRandomElementFromArray(fortune_objects);
			//console.log("fortune")
		}
		if(luck>5){
			this.godDestiny =true;
		}
		this.currentHP = this.hp; //could have been altered by associated stats

		if(this.class_name == "Waste"){
		    var f = new Fraymotif([],  "Rocks Fall, Everyone Dies", 1) //what better fraymotif for an Author to start with. Too bad it sucks.  If ONLY there were some way to hax0r SBURB???
            f.effects.push(new FraymotifEffect("power",3,true));
            f.flavorText = "Disappointingly sized meteors rain down from above.  Man, for such a cool name, this fraymotif kind of sucks. "
            this.fraymotifs.push(f);
		}else if(this.class_name == "Null"){
            var f = new Fraymotif([],  "What class???", 1)
            f.effects.push(new FraymotifEffect("power",1,true));
            f.flavorText = " I am certain there is not a class here and it is laughable to imply otherwise. "
            this.fraymotifs.push(f);

            var f = new Fraymotif([],  "Nulzilla", 2)
            f.effects.push(new FraymotifEffect("power",1,true));
            f.flavorText = " If you get this reference, you may reward yourself 15 Good Taste In Media Points (tm).  "
            this.fraymotifs.push(f);
		}
	}


}

/*
oh my fucking god 234908u2alsk;d
javascript, you shitty shitty langugage
why the fuck does trying to decode a URI that is null, return the string "null"
why would ANYONE EVER WANT THAT!?????????
javascript is "WAT"ing me
because of COURSE "null" == null is fucking false, so my code is like "oh, i must have some players" and then try to fucking parse!!!!!!!!!!!!!!*/
function getReplayers(){
//	var b = LZString.decompressFromEncodedURIComponent(getRawParameterByName("b"));
	available_classes_guardians = classes.slice(0); //if there are replayers, then i need to reset guardian classes
	var b = decodeURIComponent(LZString.decompressFromEncodedURIComponent(getRawParameterByName("b")));
	var s = LZString.decompressFromEncodedURIComponent(getRawParameterByName("s"));
	var x = decodeURIComponent(LZString.decompressFromEncodedURIComponent(getRawParameterByName("x")));
	if(!b||!s) return [];
	if(b== "null" || s == "null") return []; //why was this necesassry????????????????
	//console.log("b is");
	//console.log(b)
	//console.log("s is ")
	//console.log(s)
	return dataBytesAndStringsToPlayers(b,s,x);
}

function syncReplayNumberToPlayerNumber(replayPlayers){
	if(curSessionGlobalVar.players.length == replayPlayers.length || replayPlayers.length == 0) return; //nothing to do.

	if(replayPlayers.length < curSessionGlobalVar.players.length ){ //gotta destroy some players (you monster);
		curSessionGlobalVar.players.splice(-1 * (curSessionGlobalVar.players.length - replayPlayers.length))
		return;
	}else if(replayPlayers.length > curSessionGlobalVar.players.length){
		var numNeeded = replayPlayers.length - curSessionGlobalVar.players.length;
		//console.log("Have: " + curSessionGlobalVar.players.length + " need: " + replayPlayers.length + " think the difference is: " + numNeeded)
		for(var i = 0; i< numNeeded; i++){
			// console.log("making new player: " + i)
			 curSessionGlobalVar.players.push( randomPlayerWithClaspect(curSessionGlobalVar, "Page", "Void"));
		}
		//console.log("Number of players is now: " + curSessionGlobalVar.players.length)
		return;
	}
}

//this code is needed to make sure replay players have guardians.
function redoRelationships(players){
	var guardians = [];
	console.log("redoing relationships")
	for(var j = 0; j<players.length; j++){
		var p = players[j];
		guardians.push(p.guardian)
		p.relationships = [];
		p.generateRelationships(curSessionGlobalVar.players);
		p.initializeRelationships();
	}

	for(var j = 0; j<guardians.length; j++){
		var p = guardians[j]
		p.relationships = [];
		p.generateRelationships(guardians);
		p.initializeRelationships();
	}
}

function initializePlayers(players,session){
	var replayPlayers = getReplayers();
	if(replayPlayers.length == 0 && session) replayPlayers = session.replayers; //<-- probably blank too, but won't be for fan oc easter eggs.
	syncReplayNumberToPlayerNumber(replayPlayers);
	for(var i = 0; i<players.length; i++){
		if(replayPlayers[i]) players[i].copyFromPlayer(replayPlayers[i]); //DOES NOT use MORE PLAYERS THAN SESSION HAS ROOM FOR, BUT AT LEAST WON'T CRASH ON LESS.
		if(players[i].land){ //don't reinit aliens, their stats stay how they were cloned.
			players[i].initialize();
			players[i].guardian.initialize();
			if(replayPlayers[i]){
				players[i].quirk.favoriteNumber = parseInt(replayPlayers[i].quirk.favoriteNumber) //has to be after initialization
				if(players[i].isTroll){
					players[i].quirk.makeTrollQuirk(players[i]); //redo quirk
				}else{
					players[i].quirk.makeHumanQuirk(players[i]);
				}
			}
		}
	}
	if(replayPlayers.length > 0){
		redoRelationships(players);  //why was i doing this, this overrides robot and gim dark and initial relationships
	    //oh because it makes replayed sessions with scratches crash.
	}

}

function initializePlayersNoDerived(players,session){
	var replayPlayers = getReplayers();
	for(var i = 0; i<players.length; i++){
		if(replayPlayers[i]) players[i].copyFromPlayer(replayPlayers[i]); //DOES NOT use MORE PLAYERS THAN SESSION HAS ROOM FOR, BUT AT LEAST WON'T CRASH ON LESS.
		players[i].initializeStats();
		players[i].initializeSprite();
	}

	//might not be needed.   futureJadedResearcher (FJR) has begun pestering pastJadedResearcher(PJR).  FJR: Yeah, no shit sherlock
	if(replayPlayers.length > 0){
		redoRelationships(players);  //why was i doing this, this overrides robot and gim dark and initial relationships
		//oh because it makes replayed sessions with scratches crash.
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
	}else{
	    color = "#efefef"
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
	}else{
	    color = "#ffffff"
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
	}else{
	    color = "#eeeeee"
	}
	return color;
}

function getFontColorFromAspect(aspect){
	return "<font color='" + getColorFromAspect(aspect) + "'> ";
}

function blankPlayerNoDerived(session){
	var k = prototyping_objects[0];
	var gd = true;
	var m = "Prospit";
	var id = Math.seed;
	var p =  new Player(session,"Page","Void",k,m,gd,id);
	p.interest1 = interests[0];
	p.interest2 = interests[0]
	p.baby = 1
	p.hair = 1
	p.leftHorn =  1
	p.rightHorn = 1
	p.quirk = new Quirk();
	p.quirk.capitalization = 1;
	p.quirk.punctuation = 1;
	p.quirk.favoriteNumber = 1;
	p.initializeSprite();
	return p;
}

function randomPlayerNoDerived(session, c, a){
	var k = getRandomElementFromArray(prototyping_objects);


	var gd = false;

	var m = getRandomElementFromArray(moons);
	var id = Math.seed;
	var p =  new Player(session,c,a,k,m,gd,id);
	p.decideTroll();
	p.interest1 = getRandomElementFromArray(interests);
	p.interest2 = getRandomElementFromArray(interests);
	p.baby = getRandomInt(1,3)


	p.hair = getRandomInt(1,p.maxHairNumber);
	//hair color in decideTroll.
	p.leftHorn =  getRandomInt(1,p.maxHornNumber);
	p.rightHorn = p.leftHorn;
	if(Math.seededRandom() > .7 ){ //preference for symmetry
			p.rightHorn = getRandomInt(1,p.maxHornNumber);
	}
	p.initializeStats();
	p.initializeSprite();


	return p;

}

function randomPlayerWithClaspect(session, c,a){
	//console.log("random player");

	var k = getRandomElementFromArray(prototyping_objects);


	var gd = false;

	var m = getRandomElementFromArray(moons);
	var id = Math.seed;
	var p =  new Player(session,c,a,k,m,gd,id);
	p.decideTroll();
	p.interest1 = getRandomElementFromArray(interests);
	p.interest2 = getRandomElementFromArray(interests);
	p.initialize();

	//no longer any randomness directly in player class. don't want to eat seeds if i don't have to.
	p.baby = getRandomInt(1,3)


	p.hair = getRandomInt(1,p.maxHairNumber); //hair color in decide troll
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

function findDoomedPlayers(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.doomed){
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

function getPlayersTitlesHP(playerList){
	//console.log(playerList)
	if(playerList.length == 0){
		return "";
	}
		var ret = playerList[0].htmlTitleHP();
		for(var i = 1; i<playerList.length; i++){
			ret += " and " + playerList[i].htmlTitleHP();
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
		if(p.dreamSelf && !p.isDreamSelf){
			ret.push(p);
		}
	}
	return ret;
}

function findPlayersWithoutDreamSelves(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(!p.dreamSelf || p.isDreamSelf){ //if you ARE your dream self, then when you go to sleep....
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
		if(playerList[i].object_to_prototype.power >= 200){
			return (playerList[i].object_to_prototype.htmlTitle());
		}
	}
}

function findHighestMobilityPlayer(playerList){
	var ret = playerList[0];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i]
		if(p.mobility > ret.mobility){
			ret = p;
		}
	}
	return ret;
}

function findLowestMobilityPlayer(playerList){
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
		if(playerList[i].object_to_prototype.illegal ==true){
			//console.log("found good")
			return (playerList[i].object_to_prototype.htmlTitle());
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
  return b.getStat("freeWill") - a.getStat("freeWill");
}

function getAverageMinLuck(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].getStat("minLuck");
	}
	return  Math.round(ret/players.length);
}

function getAverageMaxLuck(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].getStat("maxLuck");
	}
	return  Math.round(ret/players.length);
}

function getAverageSanity(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].getStat("sanity");
	}
	return  Math.round(ret/players.length);
}

function getAverageHP(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].getStat("hp");
	}
	return  Math.round(ret/players.length);
}

function getAverageMobility(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].getStat("mobility");
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
		ret += players[i].getStat("power");
	}
	return  Math.round(ret/players.length);
}

function getPVPQuip(deadPlayer, victor, deadRole, victorRole){
	if(victor.getPVPModifier(victorRole) > deadPlayer.getPVPModifier(deadRole)){
		return "Which is pretty much how you expected things to go down between a " + deadPlayer.class_name + " and a " + victor.class_name + " in that exact situation. ";
	}else{
		return "Which is weird because you would expect the " + deadPlayer.class_name + " to have a clear advantage. Guess echeladder rank really does matter?";
	}
}

function getAverageFreeWill(players){
	if(players.length == 0) return 0;
	var ret = 0;
	for(var i = 0; i< players.length; i++){
		ret += players[i].getStat("freeWill");
	}
	return  Math.round(ret/players.length);
}

//need to know if you're from aspect, 'cause only aspect associatedStats will be used for fraymotifs.
//except for heart, which can use ALL associated stats. (cause none will be from aspect.)
function AssociatedStat(statName, multiplier, isFromAspect){
	this.name = statName
	this.multiplier = multiplier;
	this.isFromAspect = isFromAspect;
	this.toString= function(){
		var tmp = ""
		if(this.isFromAspect) tmp = " (from Aspect) "
		return "["+statName + " x " +this.multiplier + tmp+"]";
	}
}

//can eventually have a duration, but for now, assumed to be the whole fight. i don't want fights to last long.
function Buff(statName, buff){
	this.name = statName;
	this.value = buff;
}
