part of SBURBSim;

class Player extends GameEntity{
	var baby = null;
	var interest1Category = null; //used by Replay page for custom interests.
	var interest2Category = null; //both should be null once they have been used to add the custom interest to the right place
	num pvpKillCount = 0; //for stats.
	num timesDied = 0;
	var denizen = null;
	var denizenMinion = null;
	num maxHornNumber = 73; //don't fuck with this
	num maxHairNumber = 74; //same
	var sprite = null; //gets set to a blank sprite when character is created.
	num grist = 0; //total party grist needs to be at a certain level for the ultimate alchemy. luck events can raise it, boss fights, etc.
		bool deriveChatHandle = true;
	var flipOutReason = null; //if it's null, i'm not flipping my shit.
	var flippingOutOverDeadPlayer = null; //don't let this go into url. but, don't flip out if the friend is currently alive, you goof.
	num denizen_index = 0; //denizen quests are in order.
	String causeOfDrain = ""; //just ghost things
	List<dynamic> ghostWisdom = []; //keeps you from spamming the same ghost over and over for wisdom.
	List<dynamic> ghostPacts = []; //some classes can form pacts with ghosts for use in boss battles (attack or revive) (ghosts don't leave bubbles, just lend power). or help others do so.  if i actually use a ghost i have a pact with, it's drained. (so anybody else with a pact with it can't use it.)
	var land1 = null; //words my land is made of.
	var land2 = null;
	bool trickster = false;
	bool sbahj = false;
	List<dynamic> sickRhymes = []; //oh hell yes. Hell. FUCKING. Yes!
	bool robot = false;
	var ectoBiologicalSource = null; //might not be created in their own session now.
	var class_name;  //TODO make class and aspect an object, not a string.  have that object ONLY place things happen based on classpect.  Player asks classpect "How do I increase power"? and aspect has static for colors and what associated stats that player should get.
	var guardian = null; //no longer the sessions job to keep track.
	num number_confessions = 0;
	num number_times_confessed_to = 0;
	bool baby_stuck = false;
	var influenceSymbol = null; //multiple aspects can influence/mind control.
	var influencePlayer = null; //who is controlling me? (so i can break free if i have more free will or they die)
	var stateBackup = null; //if you get influenced by something, here's where your true self is stored until you break free.
	var aspect;
	var land = null;
	var interest1 = null;
	var interest2 = null;
	var chatHandle = null;
	var object_to_prototype;
	List<dynamic> relationships = [];
	var moon;
	bool leveledTheHellUp = false; //triggers level up scene.
	var mylevels = null;
	num level_index = -1; //will be ++ before i query
	bool godTier = false;
	var victimBlood = null; //used for murdermode players.
	var hair = null;	//num hair = 16;
	var hairColor = null;
	bool dreamSelf = true;
	bool isTroll = false; //later
	String bloodColor = "#ff0000"; //human red.
	var leftHorn = null;
	var rightHorn = null;
	String lusus = "Adult Human";
	var quirk = null;

	var godDestiny;	//should only be false if killed permananetly as god tier
	bool canGodTierRevive = true;  //even if a god tier perma dies, a life or time player or whatever can brings them back.
	bool isDreamSelf = false;	//players can be triggered for various things. higher their triggerLevle, greater chance of going murdermode or GrimDark.
	bool murderMode = false;  //kill all players you don't like. odds of a just death skyrockets.
	bool leftMurderMode = false; //have scars, unless left via death.
	num corruptionLevelOther = 0; //every 100 points, sends you to next grimDarkLevel.
	num grimDark = 0;  //  0 = none, 1 ;= some, 2 = some more 3 ;= full grim dark with aura and font and everything.
	bool leader = false;
	num landLevel = 0; //at 10, you can challenge denizen.  only space player can go over 100 (breed better universe.)
	bool denizenFaced = false;
	bool denizenDefeated = false;
	bool denizenMinionDefeated = false;

	Player([String name, Session session, this.class_name, this.aspect, this.object_to_prototype, this.moon, this.godDestiny, num id]): super(name, id, session);


	bool fromThisSession(Session session){
		return (this.ectoBiologicalSource == null || this.ectoBiologicalSource == session.session_id);
	}

  @override
  void setStat(statName,value){
    if(statName == "RELATIONSHIPS") throw "Players modify the actual relationships, not the calculated value.";
    super.setStat(statName, value);
  }

  @override
  void addStat(statName,value){
    if(statName == "RELATIONSHIPS") throw "Players modify the actual relationships, not the calculated value.";
    super.addStat(statName, value);
  }


	bool isQuadranted(){
		if(this.getHearts().length > 0) return true;
		if(this.getClubs().length > 0) return true;
		if(this.getDiamonds().length > 0) return true;
		if(this.getSpades().length > 0) return true;
		return false;
	}
	dynamic getClubs(){
		List<dynamic> ret = [];
		for (num i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.clubs){
				ret.add(r);
			}
		}
		return ret;
	}
	dynamic getHearts(){
		List<dynamic> ret = [];
		for (num i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.heart){
				ret.add(r);
			}
		}
		return ret;
	}
	void getDenzenNameArray(){

	}
	dynamic getOverallStrength(){
		num ret = 0;
		ret += this.getStat("power");
		ret += this.getStat("alchemy");
		ret += this.getStat("freeWill").abs();
		ret += this.getStat("mobility").abs();
		ret += this.getStat("hp").abs();
		ret += (this.getStat("maxLuck") + this.getStat("minLuck")).abs();
		ret += this.getStat("sanity").abs();
		return ret;
	}
	void generateDenizen(){
		var possibilities = this.getDenizenNameArray();
		var strength = this.getOverallStrength();
		num expectedMaxStrength = 150;  //if i change how stats work, i need to update this value 
		var strengthPerTier = (expectedMaxStrength)/possibilities.length;
		//print("Strength at start is, " + strength);//but what if you don't want STRANGTH!???
		var denizenIndex = (strength/strengthPerTier).round()-1;  //want lowest value to be off the denizen array.

		String denizenName = "";
		var denizenStrength = (denizenIndex/(possibilities.length))+1 ;//between 1 and 2;
		//print("Strength for denizen calculated from index of: " + denizenIndex + " out of " + possibilities.length);
		if(denizenIndex == 0){
			denizenName = this.weakDenizenNames();
			denizenStrength = 0.1;//fraymotifs about standing and looking at your pittifully
			print("strength demands a weak denizen " + this.session.session_id);
		}else if(denizenIndex >= possibilities.length){
			denizenName = this.strongDenizenNames(); //<-- doesn't have to be literally him. points for various mispellings of his name.
			denizenStrength = 5;
			print("Strength demands strong denizen. " + this.session.session_id);
		}else{
			denizenName = possibilities[denizenIndex];

		}

		this.makeDenizenWithStrength(denizenName, denizenStrength); //if you pick the middle enizen it will be at strength of "1", if you pick last denizen, it will be at 2 or more.

	}
	void makeDenizenWithStrength(name, strength){
		//print("Strength for denizen " + name + " is: " + strength);
		//based off existing denizen code.  care about which aspect i am.
		//also make minion here.
		var denizen = new Denizen("Denizen " +name, this.id, this.session);
		var denizenMinion = new DenizenMinion(name + " Minion", this.id, this.session);
		var tmpStatHolder = {};
		tmpStatHolder["minLuck"] = -10;
		tmpStatHolder["abscondable"] = true; //players can decide to flee like little bitches
        tmpStatHolder["canAbscond"] = false;
		tmpStatHolder["maxLuck"] = 10;
		tmpStatHolder["hp"] = 10 * strength;
		tmpStatHolder["mobility"] = 10;
		tmpStatHolder["sanity"] = 10;
		tmpStatHolder["freeWill"] = 10;
		tmpStatHolder["power"] = 5 * strength;
		tmpStatHolder["grist"] = 1000;
		tmpStatHolder["RELATIONSHIPS"] = 10;  //not REAL relationships, but real enough for our purposes.
		for(num i = 0; i<this.associatedStats.length; i++){
			//alert("I have associated stats: " + i);
			var stat = this.associatedStats[i];
			if(stat.name == "MANGRIT"){
				tmpStatHolder.power = tmpStatHolder.power * stat.multiplier * strength;
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
	dynamic getDenizenNameArray(){
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
		return ["ERROR 404: DENIZEN NOT FOUND"];
	}
	List<String> bloodDenizenNames(){
		return ['Blood','Hera','Hestia','Bastet','Bes','Vesta','Eleos','Sanguine','Medusa','Frigg','Debella','Juno','Moloch','Baal','Eusebeia','Horkos','Homonia','Harmonia','Philotes'];
	}
	List<String> mindDenizenNames(){
		return ['Mind','Athena','Forseti','Janus','Anubis','Maat','Seshat','Thoth','Jyglag','Peryite','Nomos','Lugus','Sithus','Dike','Epimetheus','Metis','Morpheus','Omoikane','Argus','Hermha','Morha','Sespille','Selcric','Tzeench'];
	}
	List<String> rageDenizenNames(){
		return ['Rage','Ares','Dyonisus','Bacchus','Abbadon','Mammon','Mania','Asmodeus','Belphegor','Set','Apophis','Nemesis','Menoetius','Shogorath','Loki','Alastor','Mol Bal','Deimos','Achos','Pallas','Deimos','Ania','Lupe','Lyssa','Ytilibatsni','Discord'];
	}
	List<String> voidDenizenNames(){
		return ['Void','Selene','Erebus','Nix','Artemis','Kuk','Kaos','Hypnos','Tartarus','Hœnir','Skoll',"Czernobog",'Vermina','Vidar','Asteria','Nocturne','Tsukuyomi','Leviathan','Hecate','Harpocrates','Diova'];
	}
	List<String> timeDenizenNames(){
		return ['Time','Ignis','Saturn','Cronos','Aion','Hephaestus','Vulcan','Perses','Prometheus','Geras','Acetosh','Styx','Kairos','Veter','Gegute','Etu','Postverta and Antevorta','Emitus','Moirai'];
	}
	List<String> heartDenizenNames(){
		return ['Heart','Aphrodite','Baldur','Eros','Hathor','Philotes','Anubis','Psyche','Mora','Isis','Jupiter', 'Narcissus','Hecate','Izanagi','Izanami','Ishtar','Anteros','Agape','Peitho','Mahara','Naidraug','Snoitome','Walthidian','Slanesh','Benu'];
	}
	List<String> breathDenizenNames(){
		return ['Breath','Ninlil','Ouranos','Typheus','Aether','Amun','Hermes','Shu','Sobek','Aura','Theia','Lelantos','Keenarth','Aeolus','Aurai','Zephyrus','Ventus','Sora','Htaerb','Worlourier','Quetzalcoatl'];
	}
	List<String> lightDenizenNames(){
		return ['Light','Helios','Ra','Cetus','Iris','Heimdall','Apollo','Coeus','Hyperion', "Belobog",'Phoebe','Metis','Eos','Dagr','Asura','Amaterasu','Sol','Tyche','Odin ','Erutuf'];
	}
	List<String> spaceDenizenNames(){
		return ['Space','Gaea','Nut','Echidna','Wadjet','Qetesh','Ptah','Geb','Fryja','Atlas','Hebe','Lork','Eve','Genesis','Morpheus','Veles ','Arche','Rekinom','Iago','Pilera','Tiamat','Gilgamesh','Implexel'];
	}
	List<String> hopeDenizenNames(){
		return ['Hope','Isis','Marduk','Fenrir','Apollo','Sekhmet','Votan','Wadjet','Baldur','Zanthar','Raphael','Metatron','Jerahmeel','Gabriel','Michael','Cassiel','Gavreel','Aariel','Uriel','Barachiel ','Jegudiel','Samael','Taylus','Tzeench'];
	}
	List<String> lifeDenizenNames(){
		return ['Life','Demeter','Pan','Nephthys','Ceres','Isis','Hemera','Andhrímnir','Agathodaemon','Eir','Baldur','Prometheus','Adonis','Geb','Panacea','Aborof','Nurgel','Adam'];
	}
	List<String> doomDenizenNames(){
		return ['Doom','Hades','Achlys','Cassandra','Osiris','Ananke','Thanatos','Moros','Iapetus','Themis','Aisa','Oizys','Styx','Keres','Maat','Castor and Pollux','Anubis','Azrael','Ankou','Kapre','Moros','Atropos','Oizys','Korne','Odin'];
	}
	dynamic strongDenizenNames(){
	    print("What if you don't want stranth? " + this.session.session_id);
		var ret = ['Yaldabaoth', '<span class ;= "void">Nobrop, the </span>Null', '<span class = "void">Paraxalan, The </span>Ever-Searching', "<span class ;= 'void'>Algebron, The </span>Dilletant", '<span class = "void">Doomod, The </span>Wanderer', 'Jörmungandr','Apollyon','Siseneg','Borunam','<span class ;= "void">Jadeacher the,</span>Researcher','Karmiution','<span class = "void">Authorot, the</span> Robot', '<span class ;= "void">Abbiejean, the </span>Scout', 'Aspiratcher, The Librarian','<span class = "void">Recurscker, The</span>Hollow One','Insurorracle','<span class ;= "void">Maniomnia, the Dreamwaker</span>','Kazerad','Shiva','Goliath'];
		return getRandomElementFromArray(ret);
	}
	dynamic weakDenizenNames(){
		var ret = ['Eriotur','Abraxas','Succra','Watojo','Bluhubit','Swefrat','Helaja','Fischapris'];
		return getRandomElementFromArray(ret);
	}
	void flipOut(reason){
		//print("flip out method called for: " + reason);
		this.flippingOutOverDeadPlayer = null;
		this.flipOutReason = reason;
	}
	bool interestedIn(interestWord, interestNum){
		if(!interestNum){
			if(interestWord == "Comedy") return playerLikesComedy(this);
			if(interestWord == "Music") return playerLikesMusic(this);
			if(interestWord == "Culture") return playerLikesCulture(this);
			if(interestWord == "Writing") return playerLikesWriting(this);
			if(interestWord == "Athletic") return playerLikesAthletic(this);
			if(interestWord == "Terrible") return playerLikesTerrible(this);
			if(interestWord == "Justice") return playerLikesJustice(this);
			if(interestWord == "Fantasy") return playerLikesFantasy(this);
			if(interestWord == "Domestic") return playerLikesDomestic(this);
			if(interestWord == "PopCulture") return playerLikesPopculture(this);
			if(interestWord == "Technology") return playerLikesTechnology(this);
			if(interestWord == "Social") return playerLikesSocial(this);
			if(interestWord == "Romance") return playerLikesRomantic(this);
			if(interestWord == "Academic") return playerLikesAcademic(this);
			return false;
		}else if(interestNum == 1){
			if(interestWord == "Comedy") return comedy_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Music") return music_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Culture") return culture_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Writing") return writing_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Athletic") return athletic_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Terrible") return terrible_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Justice") return justice_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Fantasy") return fantasy_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Domestic") return domestic_interests.indexOf(this.interest1) != -1;
			if(interestWord == "PopCulture") return pop_culture_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Technology") return technology_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Social") return social_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Romance") return romantic_interests.indexOf(this.interest1) != -1;
			if(interestWord == "Academic") return academic_interests.indexOf(this.interest1) != -1;
		}else if(interestNum == 2){
			if(interestWord == "Comedy") return comedy_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Music") return music_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Culture") return culture_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Writing") return writing_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Athletic") return athletic_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Terrible") return terrible_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Justice") return justice_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Fantasy") return fantasy_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Domestic") return domestic_interests.indexOf(this.interest2) != -1;
			if(interestWord == "PopCulture") return pop_culture_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Technology") return technology_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Social") return social_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Romance") return romantic_interests.indexOf(this.interest2) != -1;
			if(interestWord == "Academic") return academic_interests.indexOf(this.interest2) != -1;
		}
		return false;
	}
	void changeGrimDark(val){
		//this.grimDark += val;
		var tmp = this.grimDark + val;
		bool render = false;

		if(this.grimDark <= 3 && tmp > 3){ //newly GrimDark
			print("grim dark 3 or more in session: " + this.session.session_id);
			render = true;
		}else if(this.grimDark >3 && tmp <=3){ //newly recovered.
			render = true;
		}
		this.grimDark += val;
		if(render){
			this.renderSelf();
		}

	}
	void makeMurderMode(){
		this.murderMode = true;
		this.increasePower();
		this.renderSelf(); //new scars. //can't do scars just on top of sprite 'cause hair might cover.'
	}
	void unmakeMurderMode(){
		this.murderMode = false;
		this.leftMurderMode = true;
		this.renderSelf();
	}
	void makeDead(causeOfDeath){
		this.dead = true;
		this.timesDied ++;
		this.buffs = [];
		this.causeOfDeath = sanitizeString(causeOfDeath);
		if(this.getStat("currentHP") > 0) this.setStat("currentHP",-1); //just in case anything weird is going on. dead is dead.  (for example, you could have been debuffed of hp).
		//was in make alive, but realized that this makes doom ghosts way stronger if it's here. powered by DEATH, but being revived.
		if(this.aspect == "Doom"){ //powered by their own doom.
			//print("doom is powered by their own death: " + this.session.session_id) //omg, they are sayians.
			this.addStat("power", 50);
			this.addStat("hp",Math.max(100, this.getStat("hp")); //prophecy fulfilled. but hp and luck will probably drain again.
			this.setStat("minLuck",30); //prophecy fulfilled. you are no longer doomed.
		}
		if(!this.godTier){ //god tiers only make ghosts in GodTierRevivial
			var g = Player.makeRenderingSnapshot(this);
			g.fraymotifs = this.fraymotifs.sublist(0); //copy not reference
			this.session.afterLife.addGhost(g);
		}

		this.renderSelf();
		this.triggerOtherPlayersWithMyDeath();
	}
	void triggerOtherPlayersWithMyDeath(){
		//go through my relationships. if i am the only dead person, trigger everybody (death still has impact)
		//trigger (possibly ontop of base trigger) friends, and quadrant mates. really fuck up my moirel(s) if i have any
		//if triggered, also give a flip out reason.
		var dead = findDeadPlayers(this.session.players);
		for(num i = 0; i <this.relationships.length; i++){
			Relationship r = this.relationships[i];

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
				r.target.sanity += -100;
				r.target.flipOutReason = " their dead Matesprit, the " + this.htmlTitleBasic();
				r.target.flippingOutOverDeadPlayer = this;
			}
			else if(r.saved_type == r.diamond){
				r.target.sanity += -1000;
				r.target.damageAllRelationships();
				r.target.damageAllRelationships();
				r.target.damageAllRelationships();
				r.target.flipOutReason = " their dead Moirail, the " + this.htmlTitleBasic() + ", fuck, that can't be good...";
				r.target.flippingOutOverDeadPlayer = this;
			}

      //whether or not i care about them, there's also the novelty factor.
      if(dead.length == 1){  //if only I am dead, death still has it's impact and even my enemies care.
        r.target.sanity += -10;
        if(r.target.flipOutReason == null){
          r.target.flipOutReason = " the dead player, the " + this.htmlTitleBasic(); //don't override existing flip out reasons. not for something as generic as a dead player.
          r.target.flippingOutOverDeadPlayer = this;
        }
      }
			//print(r.target.title() + " has flipOutReason of: " + r.target.flipOutReason + " and knows about dead player: " + r.target.flippingOutOverDeadPlayer);
		}
	}
	dynamic getPactWithGhost(ghost){
		for(num i = 0; i<this.ghostPacts.length; i++){
			var g = this.ghostPacts[i][0];
			if(g == ghost) return g;
		}
		return null;
	}
	dynamic getSpades(){
		List<dynamic> ret = [];
		for (num i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.spades){
				ret.add(r);
			}
		}
		return ret;
	}
	dynamic getCrushes(){
		List<dynamic> ret = [];
		for (num i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.goodBig){
				ret.add(r);
			}
		}
		return ret;
	}
	dynamic getBlackCrushes(){
		List<dynamic> ret = [];
		for (num i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.badBig){
				ret.add(r);
			}
		}
		return ret;
	}
	dynamic getDiamonds(){
		List<dynamic> ret = [];
		for (num i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.saved_type == r.diamond){
				ret.add(r);
			}
		}
		return ret;
	}
	dynamic chatHandleShort(){
		return this.chatHandle.match(new RegExp(r"""\b(\w)|[A-Z]""", multiLine:true)).join('').toUpperCase();
	}
	dynamic chatHandleShortCheckDup(otherHandle){
		var tmp= this.chatHandle.match(new RegExp(r"""\b(\w)|[A-Z]""", multiLine:true)).join('').toUpperCase();
		if(tmp == otherHandle){
			tmp = tmp + "2";
		}
		return tmp;
	}
	void makeGodTier(){
		this.addStat("hp",500); //they are GODS.
    this.addStat("currentHP",500); //they are GODS.
    this.addStat("power",500); //they are GODS.
		this.increasePower();
		this.godTier = true;
		this.session.godTier = true;
		this.dreamSelf = false;
		this.canGodTierRevive = true;
		this.leftMurderMode = false; //no scars, unlike other revival methods
		this.isDreamSelf = false;
		this.makeAlive();
	}
	void makeAlive(){
			if(this.dead == false) return; //don't do all this.
			if(this.stateBackup) this.stateBackup.restoreState(this);
			this.influencePlayer = null;
			this.influenceSymbol = null;
			this.dead = false;
			this.murderMode = false;
			this.setStat("currentHP", Math.max(this.getStat("hp"),1)); //if for some reason your hp is negative, don't do that.
			//print("HP after being brought back from the dead: " + this.currentHP);
			this.grimDark = 0;
			this.addStat("sanity",-101);  //dying is pretty triggering.
			this.flipOutReason = "they just freaking died";
			//this.leftMurderMode = false; //no scars
			this.victimBlood = null; //clean face
			this.renderSelf();
		}
	dynamic title(){
		String ret = "";

		if(this.doomed){
			ret += "Doomed ";
		}



		if(this.trickster){
			ret += "Trickster ";
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
			ret+= "God Tier ";
		}else if(this.isDreamSelf){
			ret+= "Dream ";
		}
		if(this.robot){
			ret += "Robo";
		}
		ret+= this.class_name + " of " + this.aspect;
		if(this.dead){
			ret += "'s Corpse";
		}else if(this.ghost){
			ret += "'s Ghost";
		}
		ret += " (" + this.chatHandle + ")";
		return ret;
	}
	String htmlTitleBasic(){
			return getFontColorFromAspect(this.aspect) + this.titleBasic() + "</font>";
	}
	dynamic titleBasic(){
		String ret = "";

		ret+= this.class_name + " of " + this.aspect;
		return ret;
	}
	dynamic getRandomLevel(){
		if(seededRandom() > .5){
			return getRandomLevelFromAspect(this.aspect);
		}else{
			return getRandomLevelFromClass(this.class_name);
		}
	}
	dynamic getNextLevel(){
		this.level_index ++;
		var ret= this.mylevels[this.level_index];
		return ret;
	}
	dynamic getRandomQuest(){
		if(this.landLevel >= 9 && this.denizen_index < 3 && this.denizenDefeated == false){ //three quests before denizen
			//print("denizen quest");
			return getRandomDenizenQuestFromAspect(this); //denizen quests are aspect only, no class.
		}else if((this.landLevel < 9 || this.denizen_index >=3) && this.denizenDefeated == false){  //can do more land quests if denizen kicked your ass. need to grind.
			if(seededRandom() > .5 || this.aspect == "Space"){ //back to having space players be locked to frogs.
				return getRandomQuestFromAspect(this.aspect,false);
			}else{
				return getRandomQuestFromClass(this.class_name,false);
			}
		}else if(this.denizenDefeated){
			//print("post denizen quests " +this.session.session_id);
			//return "restoring their land from the ravages of " + this.session.getDenizenForPlayer(this).name;
			if(seededRandom() > .5 || this.aspect == "Space"){ //back to having space players be locked to frogs.
				return getRandomQuestFromAspect(this.aspect,true);
			}else{
				return getRandomQuestFromClass(this.class_name,true);
			}
		}
		return null;
	}
	bool canMindControl(){
		for(num i = 0; i<this.fraymotifs.length; i++){
			if(this.fraymotifs[i].name == "Mind Control") return this.fraymotifs[i].name;
		}
		return false;
	}
	bool canGhostCommune(){
		for(num i = 0; i<this.fraymotifs.length; i++){
			if(this.fraymotifs[i].name == "Ghost Communing")return  this.fraymotifs[i].name;
		}
		return false;
	}
	dynamic psionicList() {
		List<dynamic> psionics = [];
		//telekenisis, mind control, mind reading, ghost communing, animal communing, laser blasts, vision xfold.
			{
			var f = new Fraymotif([], "Telekinisis", 1);
			f.effects.add(new FraymotifEffect("power", 2, true));
			f.flavorText = " Large objects begin pelting the ENEMY. ";
			psionics.add(f);
		}

		{
			var f = new Fraymotif([], "Pyrokinisis", 1);
			f.effects.add(new FraymotifEffect("power", 2, true));
			f.flavorText = " Who knew shaving cream was so flammable? ";
			psionics.add(f);
		}

		{
			var f = new Fraymotif([], "Aquakinesis", 1);
			f.effects.add(new FraymotifEffect("power", 2, true));
			f.flavorText = " A deluge begins damaging the ENEMY. ";
			psionics.add(f);
		}

		{
			var f = new Fraymotif([], "Mind Control", 1);
			f.effects.add(new FraymotifEffect("freeWill", 3, true));
			f.effects.add(new FraymotifEffect("freeWill", 3, false));
			f.flavorText =
			" All enemies start damaging themselves. It's kind of embarassing how easy this is.  ";
			psionics.add(f);
		}

		{
			var f = new Fraymotif([], "Optic Blast", 1);
			f.effects.add(new FraymotifEffect("power", 2, true));
			f.flavorText =
			" Appropriately colored eye beams pierce the ENEMY. ";
			psionics.add(f);
		}

		{
			var f = new Fraymotif([], "Ghost Communing", 1);
			f.effects.add(new FraymotifEffect("sanity", 3, true));
			f.effects.add(new FraymotifEffect("sanity", 3, false));
			f.flavorText = " The souls of the dead start hassling all enemies. ";
			psionics.add(f);
		}

		{
			var f = new Fraymotif([], "Animal Communing", 1);
			f.effects.add(new FraymotifEffect("sanity", 3, true));
			f.effects.add(new FraymotifEffect("sanity", 3, false));
			f.flavorText = " Local animal equivalents start hassling all enemies. ";
			psionics.add(f);
		}

		return psionics;
	}

	void applyPossiblePsionics(){
	   // print("Checking to see how many fraymotifs I have: " + this.fraymotifs.length + " and if I am a troll: " + this.isTroll);
		if(this.fraymotifs.length > 0 || !this.isTroll) return; //if i already have fraymotifs, then they were probably predefined.
		//highest land dwellers can have chucklevoodoos. Other than that, lower on hemospectrum = greater odds of having psionics.;
		//make sure psionic list is kept in global var, so that char creator eventually can access? Wait, no, just wrtap it in a function here. don't polute global name space.
		//trolls can clearly have more than one set of psionics. so. odds of psionics is inverse with hemospectrum position. didn't i do this math before? where?
		//oh! low blood vocabulary!!! that'd be in quirks, i think.
		//print("My blood color is: " + this.bloodColor);
		var odds = 10 - bloodColors.indexOf(this.bloodColor);   //want gamzee and above to have NO powers (will give highbloods chucklevoodoos separate)
		var powers = this.psionicList();
		for(num i = 0; i<powers.length; i++){
			if(seededRandom()*40 < odds ){  //even burgundy bloods have only a 25% shot of each power.
				this.fraymotifs.add(powers[i]);
			}
		}
		//special psionics for high bloods and lime bloods.  highblood: #631db4  lime: #658200
		if(this.bloodColor == "#631db4"){
			var f = new Fraymotif([],  "Chucklevoodoos", 1);
			f.effects.add(new FraymotifEffect("sanity",3,false));
			f.effects.add(new FraymotifEffect("sanity",3,true));
			f.flavorText = " Oh god oh no no no no no no no no. The enemies are no longer doing okay, psychologically speaking. ";
			this.fraymotifs.add(f);
		}else if(this.bloodColor == "#658200"){
			var f = new Fraymotif([],  "Limeade Refreshment", 1);
			f.effects.add(new FraymotifEffect("sanity",1,false));
			f.effects.add(new FraymotifEffect("sanity",1,true));
			f.flavorText = " All allies just settle their shit for a little while. Cool it. ";
			this.fraymotifs.add(f);
		}else if(this.bloodColor == "#ffc3df"){
		    var f = new Fraymotif([],  "'<font color;='pink'>"+this.chatHandle + " and the Power of Looove~~~~~<3<3<3</font>'", 1);
            f.effects.add(new FraymotifEffect("RELATIONSHIPS",3,false));
            f.effects.add(new FraymotifEffect("RELATIONSHIPS",3,true));
            f.flavorText = " You are pretty sure this is not a real type of Troll Psionic.  It heals everybody in a bullshit parade of sparkles, and heart effects despite your disbelief. Everybody is also SUPER MEGA ULTRA IN LOVE with each other now, but ESPECIALLY in love with  " + this.htmlTitleHP() + ". ";
            this.fraymotifs.add(f);
		}
	}
	void decideLusus(player){
		if(this.bloodColor == "#610061" || this.bloodColor == "#99004d" || this.bloodColor == "#631db4" ){
			this.lusus = getRandomElementFromArray(sea_lusus_objects);
		}else{
			this.lusus = getRandomElementFromArray(lusus_objects);
		}
	}
	bool isVoidAvailable(){
		var light = findAspectPlayer(findLivingPlayers(this.session.players), "Light");
		if(light && light.godTier) return false;
		return true;
	}
	dynamic getPVPModifier(role){
		if(role == "Attacker") return this.getAttackerModifier();
		if(role == "Defender") return this.getDefenderModifier();
		if(role == "Murderer") return this.getMurderousModifier();
		return null;
	}
	bool renderable(){
		return true;
	}
	num getAttackerModifier(){
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
	num getDefenderModifier(){
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
	num getMurderousModifier(){
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
	dynamic getDenizen(){
		return this.denizen.name; //<--convineint that it wasn't hard to upgrade.
	}
	dynamic didDenizenKillYou(){
		if(this.causeOfDeath.indexOf(this.denizen.name) != -1){
			return true; //also return true for minions. this is intentional.;
		}
		return false;
	}
	dynamic justDeath(){
		bool ret = false;

		//impossible to have a just death from a denizen or denizen minion. unless you are corrupt.
		if(this.didDenizenKillYou() && !(this.grimDark <= 2)){
			return false;
		}else if(this.grimDark > 2){
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!just death for a corrupt player from their denizen or denizen minion in session: " + this.session.session_id);
			return true; //always just if the denizen puts down a corrupt player.
		}


		//if much less friends than enemies.
		if(this.getFriends().length < this.getEnemies().length){
			if(seededRandom() > .9){ //just deaths are rarer without things like triggers.
				ret = true;
			}
			//way more likely to be a just death if you're being an asshole.


			if((this.murderMode || this.grimDark > 2)){
				var rand = seededRandom();
				//print("rand is: " + rand);
				if(rand > .2){
					//print(" just death for: " + this.title() + "rand is: " + rand)
					ret = true;
				}
			}
		}else{  //you are a good person. just corrupt.
			//way more likely to be a just death if you're being an asshole.
			if((this.murderMode || this.grimDark > 2) && seededRandom()>.5){
				ret = true;
			}
		}
		//print(ret);
		//return true; //for testing
		return ret;
	}
	dynamic heroicDeath(){
		bool ret = false;

		//it's not heroic derping to death against a minion or whatever, or in a solo fight.
		if(this.didDenizenKillYou() || this.causeOfDeath == "from a Bad Break."){
			return false;
		}

		//if far more enemies than friends.
		if(this.getFriends().length > this.getEnemies().length ){
			if(seededRandom() > .6){
				ret = true;
			}
			//extra likely if you just killed the king/queen, you hero you.
			if((this.session.king.getStat("currentHP") <=0 || this.session.king.dead == true) && seededRandom()>.2){
				ret = true;
			}
		}else{ //unlikely hero
			if(seededRandom() > .8){
				ret = true;
			}
			//extra likely if you just killed the king/queen, you hero you.
			if(this.session.king.getStat("currentHP") <=0 || this.session.king.dead == true) {
				ret = true;
			}
		}

		if(ret){
			//print("heroic death");
		}
		return ret;
	}
	bool hasInteractionEffect(){
		return this.class_name == "Prince" || this.class_name == "Bard"|| this.class_name == "Witch"|| this.class_name == "Sylph"|| this.class_name == "Rogue"|| this.class_name == "Thief";
	}
	void associatedStatsInteractionEffect(player){
		if(this.hasInteractionEffect()){ //don't even bother if you don't have an interaction effect.
			for(num i = 0; i<this.associatedStats.length; i++){
				this.processStatInteractionEffect(player, this.associatedStats[i]);
			}
		}
	}
	void processStatInteractionEffect(player, stat){
		var powerBoost = this.getStat("power")"/20;
		if(this.class_name == "Witch"|| this.class_name == "Sylph"){
			powerBoost = powerBoost *  2 ;//sylph and witch get their primary boost here, so make it a good one.;
		}
		powerBoost = this.modPowerBoostByClass(powerBoost,stat);
		if(this.class_name == "Rogue"|| this.class_name == "Thief"){
		    powerBoost = 3 * powerBoost; //make up for how shitty your boost is for increasePower, THIS is how you are supposed to level.
			player.modifyAssociatedStat((-1 * powerBoost), stat);
			if(this.isActive()){ //modify me
				this.modifyAssociatedStat(powerBoost, stat);
			}else{  //modify others.
				for(num i = 0; i<this.session.players.length; i++){
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
	void interactionEffect(player){

		this.associatedStatsInteractionEffect(player);

		//no longer do this seperate. if close enough to modify with powers, close enough to be...closer.
		dynamic r1 = this.getRelationshipWith(player);
		if(r1){
			r1.moreOfSame();
		}

	}
	dynamic knowsAboutSburb(){
		//time might not innately get it, but they have future knowledge
		var rightClass = this.class_name == "Sage" || this.class_name == "Scribe" || this.class_name == "Seer" || this.class_name == "Mage" || this.aspect == "Light" || this.aspect == "Mind" || this.aspect == "Doom" || this.aspect == "Time";
		return rightClass && this.power > 20; //need to be far enough in my claspect
	}
	dynamic performEctobiology(session){
		session.ectoBiologyStarted = true;
		dynamic playersMade = findPlayersWithoutEctobiologicalSource(session.players);
		setEctobiologicalSource(playersMade, session.session_id);
		return playersMade;
	}
	dynamic isActive(){
		return active_classes.indexOf(this.class_name) != -1;
	}
	void makeGuardian(){
		//print("guardian for " + player.titleBasic());
		var player = this;
		var possibilities = available_classes_guardians;
		if(possibilities.length == 0) possibilities = classes;
		//print("class names available for guardians is: " + possibilities);
		var guardian = randomPlayerWithClaspect(this.session, getRandomElementFromArray(possibilities), this.aspect);
        available_classes_guardians.removeFromArray(guardian.class_name);
		guardian.isTroll = player.isTroll;
		guardian.quirk.favoriteNumber = player.quirk.favoriteNumber;
		if(guardian.isTroll){
			guardian.quirk = randomTrollSim(guardian) ;//not same quirk as guardian;
		}else{
			guardian.quirk = randomHumanSim(guardian);
		}

		guardian.bloodColor = player.bloodColor;
		guardian.lusus = player.lusus;
		if(guardian.isTroll == true){ //trolls always use lusus.
			guardian.object_to_prototype = player.object_to_prototype;
		}
		guardian.hairColor = player.hairColor;

		//print("Guardian className: " + guardian.class_name + " Player was: " + this.class_name);
		guardian.leftHorn = player.leftHorn;
		guardian.rightHorn = player.rightHorn;
		guardian.level_index = 5; //scratched kids start more leveled up
		guardian.power = 50;
		guardian.leader = player.leader;
		if(seededRandom() >0.5){ //have SOMETHING in common with your ectorelative.
			guardian.interest1 = player.interest1;
		}else{
			guardian.interest2 = player.interest2;
		}
		guardian.initializeDerivedStuff();//redo levels and land based on real aspect
		//this.guardians.add(guardian); //sessions don't keep track of this anymore
		player.guardian = guardian;
		guardian.guardian = this;//goes both ways.
	}
	void associatedStatsIncreasePower(powerBoost){
		//modifyAssociatedStat
		for(num i = 0; i< this.associatedStats.length; i++){
			this.processStatPowerIncrease(powerBoost, this.associatedStats[i]);
		}
	}
	dynamic modPowerBoostByClass(powerBoost, stat){
		switch (this.class_name) {
			case "Knight":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * 2;
				}else{
					powerBoost = powerBoost * 0.5;
				}
				break;
            case "Scout":
                if(stat.multiplier > 0){
                    powerBoost = powerBoost * 2;
                }else{
                    powerBoost = powerBoost * 0.5;
                }
                break;
            case "Guide":
                if(stat.multiplier > 0){
                    powerBoost = powerBoost * 2;
                }else{
                    powerBoost = powerBoost * 0.5;
                }
                break;
			case  "Seer":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * 2;
				}else{
					powerBoost = powerBoost * 2.5;
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
					powerBoost = powerBoost * 0.5;
				}
				break;
			case  "Thief":
				powerBoost = powerBoost * 0.5;
				break;
			case  "Sylph":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * 0.5;
				}else{
					powerBoost = powerBoost * -0.5;
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
					powerBoost = powerBoost *-0.5;
				}
				break;
			case  "Mage":
				if(stat.multiplier > 0){
					powerBoost = powerBoost * 2;
				}else{
					powerBoost = powerBoost * 2.5;
				}
				break;

			case  "Sage":
                if(stat.multiplier > 0){
                    powerBoost = powerBoost * 1;
                }else{
                    powerBoost = powerBoost * 0.25;
                }
                break;

            case  "Scribe":
                if(stat.multiplier > 0){
                    powerBoost = powerBoost * 1;
                }else{
                    powerBoost = powerBoost * 0.25;
                }
                break;

			case  "Waste":
				powerBoost = powerBoost * 0;  //wastes WASTE their abilities, until the cataclysm.
				break;
			default:
				print('What the hell kind of class is ' + this.class_name + '???');
		}

		return powerBoost;
	}
	void resetFraymotifs(){
		for(num i = 0; i<this.fraymotifs.length; i++){
			this.fraymotifs[i].usable = true;
		}
	}
	void processStatPowerIncrease(powerBoost, stat){
		var powerBoost = this.modPowerBoostByClass(powerBoost,stat);
		if(this.isActive()){ //modify me
			this.modifyAssociatedStat(powerBoost, stat);
		}else{  //modify others.
			powerBoost = 1* powerBoost; //to make up for passives being too nerfed. 1 for you
			this.modifyAssociatedStat(powerBoost* 0.5, stat); //half for me
			for(num i = 0; i<this.session.players.length; i++){
				this.session.players[i].modifyAssociatedStat(powerBoost/this.session.players.length, stat);
			}
		}
	}
	void increasePower(){
		if(seededRandom() >.9){
			this.leveledTheHellUp = true; //that multiple of ten thing is bullshit.
		}
		num powerBoost = 1;

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
		if(this.godTier || seededRandom() >.85){
			this.hp += 5;
			this.currentHP += 5;
		}
		if(this.power > 0) this.power = (this.power).round();

	}
	String shortLand(){
		return this.land.match(new RegExp(r"""\b(\w)""", multiLine:true)).join('').toUpperCase();
	}
	String htmlTitle(){
		return getFontColorFromAspect(this.aspect) + this.title() + "</font>";
	}
	/*String htmlTitleBasic(){
		return getFontColorFromAspect(this.aspect) + this.titleBasic() + "</font>";
	}*/
	String htmlTitleHP(){
		return getFontColorFromAspect(this.aspect) + this.title() + " (" + (this.getStat("currentHP")).round()+ "hp, " + (this.getStat("power")).round() + " power)</font>";
	}
	void generateBlandRelationships(friends){
		for(num i = 0; i<friends.length; i++){
			if(friends[i] != this){  //No, Karkat, you can't be your own Kismesis.
				//one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
				//that it needs to be a thing.
				var r = randomBlandRelationship(friends[i]);
				if(this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d"){
					r.value = -20; //biological imperitive to fight for throne.
					this.addStat("sanity", -100)
					friends[i].addStat("sanity",-100);
				}
				this.relationships.add(r);
			}
		}
	}
	void generateRelationships(friends){
	//	print(this.title() + " generating a relationship with: " + friends.length);
		for(num i = 0; i<friends.length; i++){
			if(friends[i] != this){  //No, Karkat, you can't be your own Kismesis.
				//one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
				//that it needs to be a thing.
				var r = randomRelationship(friends[i]);
				if(this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d"){
					r.value = -20; //biological imperitive to fight for throne.
					this.sanity += -10;
					friends[i].sanity += -10;
				}
				this.relationships.add(r);
			}else{
				//print(this.title() + "Not generating a relationship with: " + friends[i].title());
			}
		}


	}
	void checkBloodBoost(players){
		if(this.aspect == "Blood"){
			for(num i = 0; i<players.length; i++){
				players[i].boostAllRelationships();
			}
		}
	}
	void nullAllRelationships(){
		for(num i = 0; i<this.relationships.length; i++){
			this.relationships[i].value = 0;
			this.relationships[i].saved_type = this.relationships[i].neutral;
		}
	}
	void boostAllRelationships(){
		for(num i = 0; i<this.relationships.length; i++){
			this.relationships[i].increase();
		}
	}
	void boostAllRelationshipsBy(boost){
		for(num i = 0; i<this.relationships.length; i++){
			this.relationships[i].value += boost;
		}
	}
	void damageAllRelationships(){
		for(num i = 0; i<this.relationships.length; i++){
			this.relationships[i].decrease();
		}
	}
	void boostAllRelationshipsWithMeBy(boost){
		for(num i = 0; i<this.relationships.length; i++){
			var player = this.relationships[i].target;
			var r = this.getRelationshipWith(player);
			if(r){
				r.value += boost;
			}
		}
	}
	void boostAllRelationshipsWithMe(){
		for(num i = 0; i<this.relationships.length; i++){
			var player = this.relationships[i].target;
			var r = this.getRelationshipWith(player);
			if(r){
				r.increase();
			}
		}
	}
	dynamic rollForLuck(stat){
		if(!stat){
		    return getRandomInt(this.getStat("minLuck"), this.getStat("maxLuck"));
		}else{
		    //don't care if it's min or max, just compare it to zero.
		    return getRandomInt(0, this.getStat(stat));
		}

	}
	void damageAllRelationshipsWithMe(){
		for(num i = 0; i<curSessionGlobalVar.players.length; i++){
			var r = this.getRelationshipWith(curSessionGlobalVar.players[i]);
			if(r){
				r.decrease();
			}
		}
	}
	dynamic getAverageRelationshipValue(){
		if(this.relationships.length == 0) return 0;
		num ret = 0;
		for(num i = 0; i< this.relationships.length; i++){
			ret += this.relationships[i].value;
		}
		return ret/this.relationships.length;
	}
	dynamic hasDiamond(){
		for(num i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].saved_type == this.relationships[i].diamond && !this.relationships[i].target.dead ){
				return this.relationships[i].target;
			}
		}
		return null;
	}
	dynamic hasDeadDiamond(){
		for(num i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].saved_type == this.relationships[i].diamond && this.relationships[i].target.dead ){
				return this.relationships[i].target;
			}
		}
		return null;
	}
	dynamic hasDeadHeart(){
		for(num i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].saved_type == this.relationships[i].heart && this.relationships[i].target.dead ){
				return this.relationships[i].target;
			}
		}
		return null;
	}
	dynamic getRelationshipWith(player){
		for(num i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].target == player){
				return this.relationships[i];
			}
		}
		return null;
	}
	dynamic getWhoLikesMeBestFromList(potentialFriends){
		var bestRelationshipSoFar = this.relationships[0];
		var friend = bestRelationshipSoFar.target;
		for(num i = 0; i<potentialFriends.length; i++){
			var p = potentialFriends[i];
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
		return null;
	}
	dynamic getWhoLikesMeLeastFromList(potentialFriends){
		var worstRelationshipSoFar = this.relationships[0];
		var enemy = worstRelationshipSoFar.target;
		for(num i = 0; i<potentialFriends.length; i++){
			var p = potentialFriends[i];
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
		return null;
	}
	bool hasRelationshipDrama(){
		for(num i = 0; i<this.relationships.length; i++){
			this.relationships[i].type(); //check to see if there is a relationship change.
			if(this.relationships[i].drama){
				return true;
			}
		}
		return false;
	}
	dynamic getRelationshipDrama(){
		List<dynamic> ret = [];
		for(num i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.drama){
				ret.add(r);
			}
		}
		return ret;
	}
	dynamic getChatFontColor(){
		if(this.isTroll){
			return this.bloodColor;
		}else{
			return getColorFromAspect(this.aspect);
		}
	}
	dynamic getFriendsFromList(potentialFriends){
		List<dynamic> ret = [];
		for(num i = 0; i<potentialFriends.length; i++){
			var p = potentialFriends[i];
			if(p!=this){
				var r = this.getRelationshipWith(potentialFriends[i]);
				if(r.value > 0){
					ret.add(p);
				}
			}
		}
		return ret;
	}
	dynamic getEnemiesFromList(potentialEnemies){
		List<dynamic> ret = [];
		for(num i = 0; i<potentialEnemies.length; i++){
			var p = potentialEnemies[i];
			if(p!=this){
				var r = this.getRelationshipWith(potentialEnemies[i]);
				if(r.value < 0){
					ret.add(p);
				}
			}
		}
		return ret;
	}
	dynamic getLowestRelationshipValue(){
		var worstRelationshipSoFar = this.relationships[0];
		for(num i = 1; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.value < worstRelationshipSoFar.value){
				worstRelationshipSoFar = r;
			}
		}
		return worstRelationshipSoFar.value;
	}
	dynamic getTotalBuffForStat(statName){
	    num ret = 0;
	    for(num i = 0; i<this.buffs.length; i++){
	        var b = this.buffs[i];
	        if(b.name == statName) ret += b.value;
	    }
	    return ret;
	}
	String humanWordForBuffNamed(statName){
        if(statName == "MANGRIT") return "powerful";
        if(statName == "hp") return "sturdy";
        if(statName == "RELATIONSHIPS") return "friendly";
        if(statName == "mobility") return "fast";
        if(statName == "sanity") return "calm";
        if(statName == "freeWill") return "willful";
        if(statName == "maxLuck") return "lucky";
        if(statName == "minLuck") return "lucky";
        if(statName == "alchemy") return "creative";
        return "???";
	}
	String describeBuffs(){
	    List<dynamic> ret = [];
	    var allStats = this.allStats();
	    for(num i = 0; i<allStats.length; i++){
	        var b = this.getTotalBuffForStat(allStats[i]);
	        //only say nothing if equal to zero
	        if(b>0) ret.add("more "+this.humanWordForBuffNamed(allStats[i]));
	        if(b<0) ret.add("less " + this.humanWordForBuffNamed(allStats[i]));
	    }
	    if(ret.length == 0) return "";
	    //print("buffs printing out in: " + this.session.session_id);
	    return "<Br><Br>" +this.htmlTitleHP() + " is feeling " + turnArrayIntoHumanSentence(ret) + " than normal. ";
	}
	dynamic getStat(statName){
		num ret = 0;
		if(statName == "RELATIONSHIPS"){ //relationships, why you so cray cray???

			for(num i = 0; i<this.relationships.length; i++){
                ret += this.relationships[i].value;
            }
		} else if(statName == "power" ){
		    ret += this[statName];
		    ret += this.permaBuffs["MANGRIT"] ;//needed because if i mod power directly, it effects all future progress in an unbalanced way.;
		}else{
		    ret += this[statName];
		}

		for(num i = 0; i<this.buffs.length; i++){
			var b = this.buffs[i];
			if(b.name == statName) ret += b.value;
		}

		if(statName == "power") ret = Math.max(0, ret); //no negative power, dunkass.
		return (ret).round();
	}
	dynamic getHighestRelationshipValue(){
		var bestRelationshipSoFar = this.relationships[0];
		for(num i = 1; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.value > bestRelationshipSoFar.value){
				bestRelationshipSoFar = r;
			}
		}
		return bestRelationshipSoFar.value;
	}
	dynamic getBestFriend(){
		var bestRelationshipSoFar = this.relationships[0];
		for(num i = 1; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.value > bestRelationshipSoFar.value){
				bestRelationshipSoFar = r;
			}
		}
		return bestRelationshipSoFar.target;
	}
	dynamic getBestFriendFromList(potentialFriends, debugCallBack){
		var bestRelationshipSoFar = this.relationships[0];
		for(num i = 0; i<potentialFriends.length; i++){
			var p = potentialFriends[i];
			if(p!=this){
				var r = this.getRelationshipWith(p);
				if(!r){
					//print("Couldn't find relationships between " + this.chatHandle + " and " + p.chatHandle);
					//print(debugCallBack);
					//print(potentialFriends);
					//print(this);
				}
				if(r.value > bestRelationshipSoFar.value){
					bestRelationshipSoFar = r;
				}
			}
		}
		//can't be my best friend if they're an enemy
		//I SHOULD NOT HAVE A RELATIONSHIP WITH MYSELF. but if i do, don't return it.;
		if(bestRelationshipSoFar.value > 0 && bestRelationshipSoFar.target != this){
			return bestRelationshipSoFar.target;
		}
		return null;
	}
	dynamic getWorstEnemyFromList(potentialFriends){
		var worstRelationshipSoFar = this.relationships[0];
		for(num i = 0; i<potentialFriends.length; i++){
			var p = potentialFriends[i];
			if(p!=this){
				var r = this.getRelationshipWith(potentialFriends[i]);
				if(r.value < worstRelationshipSoFar.value){
					worstRelationshipSoFar = r;
				}
			}
		}
		//can't be my worst enemy if they're a friend.
		//I SHOULD NOT HAVE A RELATIONSHIP WITH MYSELF. but if i do, don't return it.;
		if(worstRelationshipSoFar.value < 0 && worstRelationshipSoFar.target != this){
			return worstRelationshipSoFar.target;
		}
		return null;
	}
	dynamic getFriends(){
		List<dynamic> ret = [];
		for(num i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].value > 0){
				ret.add(this.relationships[i].target);
			}
		}
		return ret;
	}
	dynamic getEnemies(){
		List<dynamic> ret = [];
		for(num i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].value < 0){
				ret.add( this.relationships[i].target);
			}
		}
		return ret;
	}
	bool highInit(){
		return (this.class_name == "Rogue" || this.class_name == "Sage" ||  this.class_name == "Waste" ||  this.class_name == "Guide" || this.class_name == "Knight" || this.class_name == "Maid"|| this.class_name == "Mage"|| this.class_name == "Sylph"|| this.class_name == "Prince");
	}
	void initializeLuck(){
		this.minLuck = getRandomInt(0,-10); //middle of the road.
		this.maxLuck = this.minLuck + getRandomInt(10,1);   //max needs to be more than min.
		if(this.trickster && this.aspect != "Doom"){
			this.minLuck = 11111111111;
			this.maxLuck = 11111111111;
		}

	}
	void initializeFreeWill(){
		this.freeWill = getRandomInt(-10,10);
		if(this.trickster && this.aspect != "Doom"){
			this.freeWill = 11111111111;
		}
	}
	void initializeHP(){
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
	void initSpriteCanvas(){
		//print("Initializing derived stuff.");
		this.spriteCanvasID = this.id+"spriteCanvas";
		String canvasHTML = "<br><canvas style;='display:none' id='" + this.spriteCanvasID+"' width;='" +400 + "' height="+300 + "'>  </canvas>";
		querySelector("#playerSprites").appendHtml(canvasHTML);
	}
	void renderSelf(){
		if(!this.spriteCanvasID) this.initSpriteCanvas();
		var canvasDiv = querySelector("#${this.spriteCanvasID}");

		var ctx = canvasDiv.getContext("2d");
		this.clearSelf();
		//var pSpriteBuffer = this.session.sceneRenderingEngine.getBufferCanvas(querySelector("#sprite_template"));
		var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
		drawSpriteFromScratch(pSpriteBuffer, this);
		copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,0,0);
		//this.session.sceneRenderingEngine.drawSpriteFromScratch(pSpriteBuffer, this);
		//this.session.sceneRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,0,0);
	}
	void clearSelf(){
		var canvasDiv = querySelector("#${this.spriteCanvasID}");
		var ctx = canvasDiv.getContext("2d");
		ctx.clearRect(0, 0, canvasDiv.width, canvasDiv.height);
	}
	void initializeMobility(){
		this.mobility = getRandomInt(0,10);
		if(this.trickster && this.aspect != "Doom"){
			this.mobility = 11111111111;
		}
	}
	void initializeSanity(){
		this.sanity = getRandomInt(-10,10);
	}
	void initializeRelationships(){
		if(this.trickster && this.aspect != "Doom" && this.aspect != "Heart"){
		for(num k = 0; k <this.relationships.length; k++){
				var r = this.relationships[k];
				r.value = 111111; //EVERYTHIGN IS BETTER!!!!!!!!!!!
				r.saved_type = r.goodBig;
			}
		}

		if(this.isTroll && this.bloodColor == "#99004d"){
			for(num i = 0; i<this.relationships.length; i++){
				//needs to be part of this in ADDITION to initialization because what about custom players now.
				var r = this.relationships[i];
				if(this.isTroll && this.bloodColor == "#99004d" && r.target.isTroll && r.target.bloodColor == "#99004d"){
					r.value = -20; //biological imperitive to fight for throne.
					this.sanity += -10;
					r.target.sanity += -10;
				}
			}
		}
        print("initializing relationships");
		if(this.robot || this.grimDark>1){ //you can technically start grimDark
			for(num k = 0; k <this.relationships.length; k++){
					var r = this.relationships[k];
					r.value = 0; //robots are tin cans with no feelings
					r.saved_type = r.neutral;
					r.old_type = r.neutral;
				}
		}
	}
	dynamic getNewFraymotif(helper){
		var f;
		if(this.godTier){
			f = this.session.fraymotifCreator.makeFraymotifForPlayerWithFriends(this, helper, 3);
		}else if (this.denizenDefeated){
			f = this.session.fraymotifCreator.makeFraymotifForPlayerWithFriends(this, helper, 2);
		}else{
			f = this.session.fraymotifCreator.makeFraymotifForPlayerWithFriends(this, helper, 1);
		}
		this.fraymotifs.add(f);
		return f;
	}
	void initializePower(){
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
	dynamic toDataStrings(includeChatHandle){
		String ch = "";
		if(includeChatHandle) ch = sanitizeString(this.chatHandle);
		String ret = ""+sanitizeString(this.causeOfDrain) + ","+sanitizeString(this.causeOfDeath) + "," + sanitizeString(this.interest1) + "," + sanitizeString(this.interest2) + "," + sanitizeString(ch);
		return ret;
	}
	String toOCDataString(){
	    //for now, only extentsion sequence is for classpect. so....
	    String x = "&x;=" +this.toDataBytesX(); //ALWAYS have it. worst case scenario is 1 bit.
		return "b=" + this.toDataBytes() + "&s;="+this.toDataStrings(true) + x;
	}
	dynamic toDataBytesX(){
        var builder = new ByteBuilder();
        var j = this.toJSON();
        if(j.class_name <= 15 && j.aspect <= 15){ //if NEITHER have need of extension, just return size zero;
            builder.appendExpGolomb(0); //for length
            return encodeURIComponent(builder.data).replace(new RegExp(r"""#""", multiLine:true), '%23').replace(new RegExp(r"""&""", multiLine:true), '%26');
        }
        builder.appendExpGolomb(2); //for length
        builder.appendByte(j.class_name);
        builder.appendByte(j.aspect);
        return encodeURIComponent(builder.data).replace(new RegExp(r"""#""", multiLine:true), '%23').replace(new RegExp(r"""&""", multiLine:true), '%26');
	}
	void readInExtensionsString(reader){
	    print("reading in extension string");
	    //just inverse of encoding process.
	    var numFeatures = reader.readExpGolomb(); //assume features are in set order. and that if a given feature is variable it is ALWAYS variable.
	    print("num features is: " + numFeatures);
	     if(numFeatures > 0){
	      var cid = reader.readByte();
	      print("Class Name ID : " + cid);
	      this.class_name = intToClassName(reader.readByte());
	      }
	    if(numFeatures > 1) this.aspect = intToAspect(reader.readByte());
	    //as i add more things, add more lines. ALWAYS in same order, but not all features all the time.
	}
	String toDataBytes(){
		var json = this.toJSON(); //<-- gets me data in pre-compressed format.
		//var buffer = new ByteBuffer(11);
		StringBuffer ret = new StringBuffer(); //gonna return as a string of chars.;
		var uint8View = new Uint8List(11);
		uint8View[0] = json.hairColor >> 16 ;//hair color is 12 bits. chop off 4 on right side, they will be in buffer[1];
		uint8View[1] = json.hairColor >> 8;
		uint8View[2] = json.hairColor >> 0;
		uint8View[3] = (json.class_name << 4) + json.aspect  ;//when I do fanon classes + aspect, use this same scheme, but have binary for "is fanon", so I know 1 isn't page, but waste (or whatever);
		uint8View[4] = (json.victimBlood << 4) + json.bloodColor;
		uint8View[5] = (json.interest1Category <<4) + json.interest2Category;
		uint8View[6] = (json.grimDark << 5) + (json.isTroll << 4) + (json.isDreamSelf << 3) + (json.godTier << 2) + (json.murderMode <<1) + (json.leftMurderMode) ;//shit load of single bit variables.;
		uint8View[7] = (json.robot << 7) + (json.moon << 6) + (json.dead << 5) + (json.godDestiny <<4) + (json.favoriteNumber);
		uint8View[8] = json.leftHorn;
		uint8View[9] = json.rightHorn;
		uint8View[10] = json.hair;
		//print(uint8View);
		for(num i = 0; i<uint8View.length; i++){
			ret.writeCharCode(uint8View[i]);// += String.fromCharCode(uint8View[i]);
		}
		return Uri.encodeComponent(ret.toString()).replaceAll("#", '%23').replaceAll("&", '%26');
	}
	dynamic toJSON(){
		num moon = 0;
		if(this.moon == "Prospit") moon =1;
		var json = {"aspect": aspectToInt(this.aspect), "class_name": classNameToInt(this.class_name), "favoriteNumber": this.quirk.favoriteNumber, "hair": this.hair,  "hairColor": hexColorToInt(this.hairColor), "isTroll": this.isTroll ? 1 : 0, "bloodColor": bloodColorToInt(this.bloodColor), "leftHorn": this.leftHorn, "rightHorn": this.rightHorn, "interest1Category": interestCategoryToInt(this.interest1Category), "interest2Category": interestCategoryToInt(this.interest2Category), "interest1": this.interest1, "interest2": this.interest2, "robot": this.robot ? 1 : 0, "moon": moon,"causeOfDrain": this.causeOfDrain,"victimBlood": bloodColorToInt(this.victimBlood), "godTier": this.godTier ? 1 : 0, "isDreamSelf":this.isDreamSelf ? 1 : 0, "murderMode":this.murderMode ? 1 : 0, "leftMurderMode":this.leftMurderMode ? 1 : 0,"grimDark":this.grimDark, "causeOfDeath": this.causeOfDeath, "dead": this.dead ? 1 : 0, "godDestiny": this.godDestiny ? 1 : 0 };
		return json;
	}
	dynamic toString(){
		return (this.class_name+this.aspect).replace(new RegExp(r"""'""", multiLine:true), '');; //no spaces.
	}
	void copyFromPlayer(replayPlayer){
		//print("copying from player who has a favorite number of: " + replayPlayer.quirk.favoriteNumber);
		//print("Overriding player from a replay Player. ");
		//print(replayPlayer);
		this.aspect = replayPlayer.aspect;
		this.class_name = replayPlayer.class_name;
		this.hair = replayPlayer.hair;
		this.hairColor = replayPlayer.hairColor;
		this.isTroll = replayPlayer.isTroll;
		this.bloodColor = replayPlayer.bloodColor;
		this.leftHorn = replayPlayer.leftHorn;
		this.rightHorn = replayPlayer.rightHorn;
		this.interest1 = replayPlayer.interest1.replace(new RegExp(r"""<(?:.|\n)*?>""", multiLine:true), '');;
		this.interest2 = replayPlayer.interest2.replace(new RegExp(r"""<(?:.|\n)*?>""", multiLine:true), '');;
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
		this.victimBlood = replayPlayer.victimBlood;
		this.robot = replayPlayer.robot;
		this.fraymotifs = [];  //whoever you were before, you don't have those psionics anymore
		this.applyPossiblePsionics(); //now you have new psionics
		//print("after applying psionics I have this many fraymotifs: " + this.fraymotifs.length);
		this.quirk.favoriteNumber = replayPlayer.quirk.favoriteNumber; //will get overridden, has to be after initialization, too, but if i don't do it here, char creartor will look wrong.
		this.makeGuardian();
		this.guardian.applyPossiblePsionics(); //now you have new psionics
	}
	void initialize(){
		this.initializeStats();
		this.initializeSprite();
		this.initializeDerivedStuff();  //TODO handle troll derived stuff. like quirk.
	}
	void initializeDerivedStuff(){
		var tmp = getRandomLandFromPlayer(this);
		this.land1 = tmp[0];
		this.land2 = tmp[1];
		this.land = "Land of " + tmp[0] + " and " + tmp[1];
		if(this.deriveChatHandle) this.chatHandle = getRandomChatHandle(this.class_name,this.aspect,this.interest1, this.interest2);
		this.mylevels = getLevelArray(this);//make them ahead of time for echeladder graphic

		if(this.isTroll){
			if(!this.quirk) this.quirk = randomTrollSim(this)  ;//if i already have a quirk it was defined already. don't override it.;
			this.sanity += -10;//trolls are slightly less stable

		}else{
			if(!this.quirk) this.quirk = randomHumanSim(this);
		}
	}
	void initializeSprite(){
		this.sprite = new GameEntity(session, "sprite",null); //unprototyped.
		//minLuck, maxLuck, hp, mobility, triggerLevel, freeWill, power, abscondable, canAbscond, framotifs, grist
		this.sprite.setStats(0,0,10,0,0,0,0,false, false, [],1000);//same as denizen minion, but empty power
		this.sprite.doomed = true;
		this.sprite.sprite = true;
	}
	dynamic allStats(){
		return ["power", "hp","RELATIONSHIPS","mobility","sanity","freeWill","maxLuck","minLuck","alchemy"];
	}
	dynamic intializeAssociatedClassStatReferences(){
		return null;//don't do this for now, too confusing.;
		/*var allStats = this.allStats().slice(0); //make copy
		allStats = allStats.concat("MANGRIT");
		allStats.removeFromArray("power"); //can't buff power directly
		switch (this.class_name) {
			case "Knight":
				this.associatedStats.add(new AssociatedStat("mobility", 0.5)); //will run to protect you.
				this.associatedStats.add(new AssociatedStat("hp", 0.5));
				this.associatedStats.add(new AssociatedStat("freeWill", -1));
				break;
			case  "Seer":
				this.associatedStats.add(new AssociatedStat("freeWill", 0.9));
				this.associatedStats.add(new AssociatedStat("MANGRIT", -0.9));
				break;
			case  "Bard":
				this.associatedStats.add(new AssociatedStat( getRandomElementFromArray(allStats), 1));
				this.associatedStats.add(new AssociatedStat( getRandomElementFromArray(allStats), -1));
				break;
			case  "Heir":
				this.associatedStats.add(new AssociatedStat("maxLuck", 0.5));
				this.associatedStats.add(new AssociatedStat("minLuck", 0.5));
				this.associatedStats.add(new AssociatedStat("freeWill", -1));
				break;
			case  "Maid":
				this.associatedStats.add(new AssociatedStat("sanity", 1));
				this.associatedStats.add(new AssociatedStat("minLuck", -1));
				break;
			case  "Rogue":
				this.associatedStats.add(new AssociatedStat("mobility", 0.5));
				this.associatedStats.add(new AssociatedStat("sanity", -0.5));
				break;
			case  "Page":
				this.associatedStats.add(new AssociatedStat("mobility", -0.5));
				this.associatedStats.add(new AssociatedStat("hp", 0.5));
				break;
			case  "Thief":
				this.associatedStats.add(new AssociatedStat("maxLuck", 0.5));
				this.associatedStats.add(new AssociatedStat("MANGRIT", -0.5));
				break;
			case  "Sylph":
				this.associatedStats.add(new AssociatedStat("hp", 0.5));
				this.associatedStats.add(new AssociatedStat("sanity", -0.5));
				break;
			case  "Prince":
				this.associatedStats.add(new AssociatedStat("MANGRIT", 1));
				this.associatedStats.add(new AssociatedStat("RELATIONSHIPS", -1));
				break;
			case  "Witch":
				this.associatedStats.add(new AssociatedStat("MANGRIT", 0.5));
				this.associatedStats.add(new AssociatedStat("freeWill", 0.5));
				this.associatedStats.add(new AssociatedStat("sanity", -1));
				break;
			case  "Mage":
				this.associatedStats.add(new AssociatedStat("freeWill", 1));
				this.associatedStats.add(new AssociatedStat("hp", -1));
				break;
			default:
				print('What the hell kind of class is ' + this.class_name + '???');
		}*/
	}
	dynamic getOnlyAspectAssociatedStats(){
		List<dynamic> ret = [];
		for(num i = 0; i<this.associatedStats.length; i++){
			if(this.associatedStats[i].isFromAspect) ret.add(this.associatedStats[i]);
		}
		return ret;
	}
	dynamic getOnlyPositiveAspectAssociatedStats(){
		List<dynamic> ret = [];
		for(num i = 0; i<this.associatedStats.length; i++){
			if(this.associatedStats[i].isFromAspect && this.associatedStats[i].multiplier > 0) ret.add(this.associatedStats[i]);
		}
		return ret;
	}
	dynamic getOnlyNegativeAspectAssociatedStats(){
		List<dynamic> ret = [];
		for(num i = 0; i<this.associatedStats.length; i++){
			if(this.associatedStats[i].isFromAspect && this.associatedStats[i].multiplier < 0) ret.add(this.associatedStats[i]);
		}
		return ret;
	}
	void intializeAssociatedAspectStatReferences(){
		var allStats = this.allStats().slice(0);
        allStats = allStats.concat("MANGRIT");
        allStats.removeFromArray("power"); //can't buff power directly

		switch (this.aspect) {
			case "Blood":
				this.associatedStats.add(new AssociatedStat("RELATIONSHIPS", 2,true));
				this.associatedStats.add(new AssociatedStat("sanity", 1,true));
				this.associatedStats.add(new AssociatedStat("maxLuck", -2,true));
				break;
			case  "Mind":
				this.associatedStats.add(new AssociatedStat("freeWill", 2,true));
				this.associatedStats.add(new AssociatedStat("minLuck", 1,true));
				this.associatedStats.add(new AssociatedStat("RELATIONSHIPS", -1,true));
				this.associatedStats.add(new AssociatedStat("maxLuck", -1,true)); //LUCK DO3SN'T M4TT3R!!!
				break;
			case  "Rage":
				this.associatedStats.add(new AssociatedStat("MANGRIT", 2,true));
				this.associatedStats.add(new AssociatedStat("mobility", 1,true));
				this.associatedStats.add(new AssociatedStat("sanity", -1,true));
				this.associatedStats.add(new AssociatedStat("RELATIONSHIPS", -1,true));
				break;
			case  "Void":
				this.associatedStats.add(new AssociatedStat( getRandomElementFromArray(allStats), 3,true)); //really good at one thing
				this.associatedStats.add(new AssociatedStat( getRandomElementFromArray(allStats), -1,true));  //hit to another thing.
				this.associatedStats.add(new AssociatedStat( "minLuck", -1,true));  //hit to another thing.
				break;
			case  "Time":
				this.associatedStats.add(new AssociatedStat("minLuck", 2,true));
				this.associatedStats.add(new AssociatedStat("mobility", 1,true));
				this.associatedStats.add(new AssociatedStat("freeWill", -2,true));
				break;
			case  "Heart":
				this.associatedStats.add(new AssociatedStat("RELATIONSHIPS", 1,true));
				this.associatedStats.addAll(this.getInterestAssociatedStats(this.interest1));
				this.associatedStats.addAll(this.getInterestAssociatedStats(this.interest2));
				break;
			case  "Breath":
				this.associatedStats.add(new AssociatedStat("mobility", 2,true));
				this.associatedStats.add(new AssociatedStat("sanity", 1,true));
				this.associatedStats.add(new AssociatedStat("hp", -1,true));
				this.associatedStats.add(new AssociatedStat( "RELATIONSHIPS", -1,true)); //somebody pointed out breath seems to destroy connections, sure, i'll roll with it.
				break;
			case  "Light":
				this.associatedStats.add(new AssociatedStat("maxLuck", 2,true));
				this.associatedStats.add(new AssociatedStat("freeWill", 1,true));
				this.associatedStats.add(new AssociatedStat("sanity", -1,true));
				this.associatedStats.add(new AssociatedStat("hp", -1,true));
				break;
			case  "Space":
				this.associatedStats.add(new AssociatedStat("alchemy", 2,true));
				this.associatedStats.add(new AssociatedStat("hp", 1,true));
				this.associatedStats.add(new AssociatedStat("mobility", -2,true));
				break;
			case  "Hope":
				this.associatedStats.add(new AssociatedStat("sanity", 2,true));
				this.associatedStats.add(new AssociatedStat("maxLuck", 1,true));
				this.associatedStats.add(new AssociatedStat( getRandomElementFromArray(allStats), -2,true));
				break;
			case  "Life":
				this.associatedStats.add(new AssociatedStat("hp", 2,true));
				this.associatedStats.add(new AssociatedStat("MANGRIT", 1,true));
				this.associatedStats.add(new AssociatedStat("alchemy", -2,true));
				break;
			case  "Doom":  //fool, doom will toot as it pleases
				this.associatedStats.add(new AssociatedStat("alchemy", 2,true));
				this.associatedStats.add(new AssociatedStat("freeWill", 1,true));
				this.associatedStats.add(new AssociatedStat("minLuck", -1,true));
				this.associatedStats.add(new AssociatedStat("hp", -1,true));
				break;
			default:
				print('What the hell kind of aspect is ' + this.aspect + '???');
		}
	}
	String voidDescription(){
		for(num i = 0; i<this.associatedStats.length; i++){
			var stat = this.associatedStats[i];
			if(stat.multiplier >= 3) return "SO " + this.getEmphaticDescriptionForStatNamed(stat.name);
		}
		return "SO BLAND";
	}
	String getEmphaticDescriptionForStatNamed(statName){
		if(this.highInit()){
			if(statName == "MANGRIT") return "STRONG";
			if(statName == "hp") return "STURDY";
			if(statName == "RELATIONSHIPS") return "FRIENDLY";
			if(statName == "mobility") return "FAST";
			if(statName == "sanity") return "CALM";
			if(statName == "freeWill") return "WILLFUL";
			if(statName == "maxLuck") return "LUCKY";
			if(statName == "minLuck") return "LUCKY";
			if(statName == "alchemy") return "CREATIVE";
		}else{
			if(statName == "MANGRIT") return "WEAK";
			if(statName == "hp") return "FRAGILE";
			if(statName == "RELATIONSHIPS") return "AGGRESSIVE";
			if(statName == "mobility") return "SLOW";
			if(statName == "sanity") return "CRAZY";
			if(statName == "freeWill") return "GULLIBLE";
			if(statName == "maxLuck") return "UNLUCKY";
			if(statName == "minLuck") return "UNLUCKY";
			if(statName == "alchemy") return "BORING";
		}
		return "CONFUSING";
	}
	List<AssociatedStat> getInterestAssociatedStats(interest){
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
		return [];
	}
	void initializeAssociatedStats(){
		for(num i = 0; i<this.associatedStats.length; i++){
			if(this.highInit()){
				this.modifyAssociatedStat(10, this.associatedStats[i]);
			}else{
				this.modifyAssociatedStat(-10, this.associatedStats[i]);
			}
		}
	}
	void modifyAssociatedStat(modValue, stat){
		if(!stat) return;
		//modValue * stat.multiplier.
		if(stat.name == "RELATIONSHIPS"){
			for(num i = 0; i<this.relationships.length; i++){
				this.relationships[i].value += (modValue/this.relationships.length) * stat.multiplier;  //stop having relationship values on the scale of 100000
			}
		}else if(stat.name == "MANGRIT"){
			this.permaBuffs["MANGRIT"] += modValue * stat.multiplier;
		}else {
         	this[stat.name] += modValue * stat.multiplier;
        }
	}
	void initializeInterestStats(){
		//getInterestAssociatedStats
		this.modifyAssociatedStat(35, this.getInterestAssociatedStats(this.interest1));
		this.modifyAssociatedStat(35, this.getInterestAssociatedStats(this.interest2));
	}
	void initializeStats(){
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
			//print("disastor");
		}else if(luck > 25){
			this.object_to_prototype = getRandomElementFromArray(fortune_objects);
			//print("fortune");
		}
		if(luck>5){
			this.godDestiny =true;
		}
		this.currentHP = this.hp; //could have been altered by associated stats

		if(this.class_name == "Waste"){
		    var f = new Fraymotif([],  "Rocks Fall, Everyone Dies", 1) ;//what better fraymotif for an Author to start with. Too bad it sucks.  If ONLY there were some way to hax0r SBURB???;
            f.effects.add(new FraymotifEffect("power",3,true));
            f.flavorText = "Disappointingly sized meteors rain down from above.  Man, for such a cool name, this fraymotif kind of sucks. ";
            this.fraymotifs.add(f);
		}else if(this.class_name == "Null"){
			{
				var f = new Fraymotif([], "What class???", 1);
				f.effects.add(new FraymotifEffect("power", 1, true));
				f.flavorText = " I am certain there is not a class here and it is laughable to imply otherwise. ";
				this.fraymotifs.add(f);
			}

			{
				var f = new Fraymotif([], "Nulzilla", 2);
				f.effects.add(new FraymotifEffect("power", 1, true));
				f.flavorText = " If you get this reference, you may reward yourself 15 Good Taste In Media Points (tm).  ";
				this.fraymotifs.add(f);
			}
		}
	}


  /******************************************************************
   *
   * No Premature Optimization. V1 will have a rendering
   * Snapshot just be a deep copy of the player.
   *
   * If testing shows that having it be this big heavy class is a problem
   * I can make a tiny version with only what I need.
   *
   * DO NOT FALL INTO THE TRAP OF USING THIS NEW TINY ONE FOR DOOMED TIME PLAYERS.
   *
   * THEY NEED MORE METHODS THAN YOU THINK THEY DO.
   *
   * Find out how you are SUPPOSED to make deep copies of objects in
   * langugages where objects aren't just shitty hashes.
   *
   *****************************************************************/

  //TODO how do you NORMALLY make deep copies of things when all objects aren't secretly hashes?
	//get rid of thigns doomed time players were using. they are just players. just like this is just a player
	//until ll8r when i bother to make it a mini class of just stats.
   static Player makeRenderingSnapshot(Player player) {
    Player ret = new Player();
    ret.robot = player.robot;
    ret.spriteCanvasID = player.spriteCanvasID;
    ret.doomed = player.doomed;
    ret.ghost = player.ghost;
    ret.causeOfDrain = player.causeOfDrain;
    ret.session = player.session;
    ret.id = player.id;
    ret.trickster = player.trickster;
    ret.baby_stuck = player.baby_stuck;
    ret.sbahj = player.sbahj;
    ret.influenceSymbol = player.influenceSymbol;
    ret.grimDark = player.grimDark;
    ret.victimBlood = player.victimBlood;
    ret.murderMode = player.murderMode;
    ret.leftMurderMode = player.leftMurderMode; //scars
    ret.dead = player.dead;
    ret.isTroll = player.isTroll;
    ret.godTier = player.godTier;
    ret.class_name = player.class_name;
    ret.aspect = player.aspect;
    ret.isDreamSelf = player.isDreamSelf;
    ret.hair = player.hair;
    ret.bloodColor = player.bloodColor;
    ret.hairColor = player.hairColor;
    ret.moon = player.moon;
    ret.chatHandle = player.chatHandle;
    ret.leftHorn = player.leftHorn;
    ret.rightHorn = player.rightHorn;
    ret.quirk = player.quirk;
    ret.baby = player.baby;
    ret.causeOfDeath = player.causeOfDeath;

    ret.interest1 = player.interest1;
    ret.interest2 = player.interest2;
    ret.setStatsHash(player.stats);
    return ret;
  }


  //TODO has specific 'doomed time clone' stuff in it, like randomizing state
  static Player makeDoomedSnapshot(Player doomedPlayer) {
    Player timeClone = Player.makeRenderingSnapshot(doomedPlayer);
    timeClone.dead = false;
    timeClone.setStat("currentHP", doomedPlayer.getStat("hp")); //heal
    timeClone.doomed = true;
    //from a different timeline, things went differently.
    var rand = seededRandom();
    timeClone.setStat("power",seededRandom() * 80+10);
    if(rand > 0.9){
      timeClone.robot = true;
      timeClone.hairColor = getRandomGreyColor();
    }else if(rand>.8){
      timeClone.godTier = !timeClone.godTier;
      if(timeClone.godTier){
        timeClone.setStat("power", 200); //act like a god, damn it.
      }
    }else if(rand>.6){
      timeClone.isDreamSelf = !timeClone.isDreamSelf;
    }else if(rand>.4){
      timeClone.grimDark = getRandomInt(0,4);
      timeClone.addStat("power",50 * timeClone.grimDark);
    }else if(rand>.2){
      timeClone.murderMode = !timeClone.murderMode;
    }

    if(timeClone.grimDark > 3){
      var f = new Fraymotif([],  Zalgo.generate("The Broodfester Tongues"), 3);
      f.effects.add(new FraymotifEffect("power",3,true));
      f.effects.add(new FraymotifEffect("power",0,false));
      f.flavorText = " They are stubborn throes. ";
      timeClone.fraymotifs.add(f);
    }

    if(timeClone.godTier){
     var f = curSessionGlobalVar.fraymotifCreator.makeFraymotif([doomedPlayer], 3);//first god tier fraymotif
      timeClone.fraymotifs.add(f);
    }

    if(timeClone.getStat("power") > 50){
      var f = curSessionGlobalVar.fraymotifCreator.makeFraymotif([doomedPlayer], 2);//probably beat denizen at least
      timeClone.fraymotifs.add(f);
    }

    var f = curSessionGlobalVar.fraymotifCreator.makeFraymotif([doomedPlayer], 1);//at least did first quest
    timeClone.fraymotifs.add(f);

    return timeClone;
  }

}



/*
oh my fucking god 234908u2alsk;d
javascript, you shitty shitty langugage
why the fuck does trying to decode a URI that is null, return the string "null";
why would ANYONE EVER WANT THAT!?????????
javascript is "WAT"ing me
because of COURSE "null" == null is fucking false, so my code is like "oh, i must have some players" and then try to fucking parse!!!!!!!!!!!!!!*/
dynamic getReplayers(){
//	var b = LZString.decompressFromEncodedURIComponent(getRawParameterByName("b"));
	var available_classes_guardians = classes.sublist(0); //if there are replayers, then i need to reset guardian classes
	var b = Uri.decodeComponent(LZString.decompressFromEncodedURIComponent(getRawParameterByName("b")));
	var s = LZString.decompressFromEncodedURIComponent(getRawParameterByName("s"));
	var x = LZString.decompressFromEncodedURIComponent(getRawParameterByName("x"));
	if(!b||!s) return [];
	if(b== "null" || s == "null") return []; //why was this necesassry????????????????
	//print("b is");
	//print(b);
	//print("s is ");
	//print(s);
	return dataBytesAndStringsToPlayers(b,s,x);
}



void syncReplayNumberToPlayerNumber(replayPlayers){
	if(curSessionGlobalVar.players.length == replayPlayers.length || replayPlayers.length == 0) return; //nothing to do.

	if(replayPlayers.length < curSessionGlobalVar.players.length ){ //gotta destroy some players (you monster);
		curSessionGlobalVar.players.splice(-1 * (curSessionGlobalVar.players.length - replayPlayers.length));
		return;
	}else if(replayPlayers.length > curSessionGlobalVar.players.length){
		var numNeeded = replayPlayers.length - curSessionGlobalVar.players.length;
		//print("Have: " + curSessionGlobalVar.players.length + " need: " + replayPlayers.length + " think the difference is: " + numNeeded);
		for(int i = 0; i<numNeeded; i++){
			// print("making new player: " + i);
			 curSessionGlobalVar.players.add( randomPlayerWithClaspect(curSessionGlobalVar, "Page", "Void"));
		}
		//print("Number of players is now: " + curSessionGlobalVar.players.length);
		return;
	}
}



//this code is needed to make sure replay players have guardians.
void redoRelationships(players){
	List<dynamic> guardians = [];
	print("redoing relationships");
	for(num j = 0; j<players.length; j++){
		var p = players[j];
		guardians.add(p.guardian);
		p.relationships = [];
		p.generateRelationships(curSessionGlobalVar.players);
		p.initializeRelationships();
	}

	for(num j = 0; j<guardians.length; j++){
		var p = guardians[j];
		p.relationships = [];
		p.generateRelationships(guardians);
		p.initializeRelationships();
	}
}



void initializePlayers(players, session){
	var replayPlayers = getReplayers();
	if(replayPlayers.length == 0 && session) replayPlayers = session.replayers; //<-- probably blank too, but won't be for fan oc easter eggs.
	syncReplayNumberToPlayerNumber(replayPlayers);
	for(num i = 0; i<players.length; i++){
		if(replayPlayers[i]) players[i].copyFromPlayer(replayPlayers[i]); //DOES NOT use MORE PLAYERS THAN SESSION HAS ROOM FOR, BUT AT LEAST WON'T CRASH ON LESS.
		if(players[i].land){ //don't reinit aliens, their stats stay how they were cloned.
			players[i].initialize();
			players[i].guardian.initialize();
			if(replayPlayers[i]){
				players[i].quirk.favoriteNumber = int.parse(replayPlayers[i].quirk.favoriteNumber, onError:(String input) => 0) ;//has to be after initialization;
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



void initializePlayersNoDerived(players, session){
	var replayPlayers = getReplayers();
	for(num i = 0; i<players.length; i++){
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



dynamic getColorFromAspect(aspect){
	String color = "";
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
	    color = "#efefef";
	}
	return color;
}



dynamic getShirtColorFromAspect(aspect){
	String color = "";
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



dynamic getDarkShirtColorFromAspect(aspect){
	String color = "";
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



String getFontColorFromAspect(aspect){
	return "<font color='" + getColorFromAspect(aspect) + "'> ";
}



dynamic blankPlayerNoDerived(session){
	var k = prototyping_objects[0];
	bool gd = true;
	String m = "Prospit";
	var id = Math.seed;
	var p = new Player(session,"Page","Void",k,m,gd,id);
	p.interest1 = interests[0];
	p.interest2 = interests[0];
	p.baby = 1;
	p.hair = 1;
	p.leftHorn =  1;
	p.rightHorn = 1;
	p.quirk = new Quirk();
	p.quirk.capitalization = 1;
	p.quirk.punctuation = 1;
	p.quirk.favoriteNumber = 1;
	p.initializeSprite();
	return p;
}



dynamic randomPlayerNoDerived(session, c, a){
	var k = getRandomElementFromArray(prototyping_objects);


	bool gd = false;

	var m = getRandomElementFromArray(moons);
	var id = Math.seed;
	var p = new Player(session,c,a,k,m,gd,id);
	p.decideTroll();
	p.interest1 = getRandomElementFromArray(interests);
	p.interest2 = getRandomElementFromArray(interests);
	p.baby = getRandomInt(1,3);


	p.hair = getRandomInt(1,p.maxHairNumber);
	//hair color in decideTroll.
	p.leftHorn =  getRandomInt(1,p.maxHornNumber);
	p.rightHorn = p.leftHorn;
	if(seededRandom() > .7 ){ //preference for symmetry
			p.rightHorn = getRandomInt(1,p.maxHornNumber);
	}
	p.initializeStats();
	p.initializeSprite();


	return p;

}



dynamic randomPlayerWithClaspect(session, c, a){
	//print("random player");

	var k = getRandomElementFromArray(prototyping_objects);


	bool gd = false;

	var m = getRandomElementFromArray(moons);
	var id = Math.seed;
	var p = new Player(session,c,a,k,m,gd,id);
	p.decideTroll();
	p.interest1 = getRandomElementFromArray(interests);
	p.interest2 = getRandomElementFromArray(interests);
	p.initialize();

	//no longer any randomness directly in player class. don't want to eat seeds if i don't have to.
	p.baby = getRandomInt(1,3);


	p.hair = getRandomInt(1,p.maxHairNumber); //hair color in decide troll
	p.leftHorn =  getRandomInt(1,46);
	p.rightHorn = p.leftHorn;
	if(seededRandom() > .7 ){ //preference for symmetry
			p.rightHorn = getRandomInt(1,46);
	}


	return p;

}


dynamic randomPlayer(session){
	//remove class AND aspect from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = getRandomElementFromArray(available_aspects);
	removeFromArray(a, available_aspects);
	return randomPlayerWithClaspect(session,c,a);

}



dynamic randomPlayerWithoutRemoving(session){
	//remove class AND aspect from available
	var c = getRandomElementFromArray(available_classes);
	//removeFromArray(c, available_classes);
	var a = getRandomElementFromArray(available_aspects);
	//removeFromArray(a, available_aspects);
	return randomPlayerWithClaspect(session,c,a);

}



dynamic randomSpacePlayer(session){
	//remove class from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = required_aspects[0];
	return randomPlayerWithClaspect(session,c,a);
}



dynamic randomTimePlayer(session){
	//remove class from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = required_aspects[1];
	return randomPlayerWithClaspect(session,c,a);
}



dynamic findAspectPlayer(playerList, aspect){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.aspect == aspect){
			//print("Found " + aspect + " player");
			return p;
		}
	}
	return null;
}



dynamic findAllAspectPlayers(playerList, aspect){
	List<dynamic> ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.aspect == aspect){
			//print("Found " + aspect + " player");
			ret.add(p);
		}
	}
	return ret;
}




dynamic getLeader(playerList){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.leader){
			return p;
		}
	}
	return null;
}



//in combo sessions, mibht be more than one rage player, for example.
dynamic findClaspectPlayer(playerList, class_name, aspect){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.class_name == class_name && p.aspect == aspect){
			//print("Found " + class_name + " player");
			return p;
		}
	}
	return null;
}




dynamic findClassPlayer(playerList, class_name){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.class_name == class_name){
			//print("Found " + class_name + " player");
			return p;
		}
	}
	return null;
}



dynamic findStrongestPlayer(playerList){
	var strongest = playerList[0];

	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.power > strongest.power){
			strongest = p;
		}
	}
	return strongest;
}



dynamic findDeadPlayers(playerList){
	var ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.dead){
			ret.add(p);
		}
	}
	return ret;
}



dynamic findDoomedPlayers(playerList){
	var ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.doomed){
			ret.add(p);
		}
	}
	return ret;
}



dynamic findLivingPlayers(playerList){
	var ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(!p.dead){
			ret.add(p);
		}
	}
	return ret;
}



dynamic getPartyPower(party){
	num ret = 0;
	for(num i = 0; i<party.length; i++){
		ret += party[i].power;
	}
	return ret;
}



dynamic getPlayersTitlesHP(playerList){
	//print(playerList);
	if(playerList.length == 0){
		return "";
	}
	var ret = playerList[0].htmlTitleHP();
	for(num i = 1; i<playerList.length; i++){
		ret += " and " + playerList[i].htmlTitleHP();
	}
	return ret;
}



dynamic getPlayersTitlesNoHTML(playerList){
	//print(playerList);
	if(playerList.length == 0){
		return "";
	}
	var ret = playerList[0].title();
	for(num i = 1; i<playerList.length; i++){
		ret += " and " + playerList[i].title();
	}
	return ret;
}



dynamic getPlayersTitles(playerList){
	//print(playerList);
	if(playerList.length == 0){
		return "";
	}
	var ret = playerList[0].htmlTitle();
	for(num i = 1; i<playerList.length; i++){
		ret += " and " + playerList[i].htmlTitle();
	}
	return ret;
}



dynamic partyRollForLuck(players){
	num ret = 0;
	for(num i = 0; i<players.length; i++){
		ret += players[i].rollForLuck();
	}
	return ret/players.length;
}



dynamic getPlayersTitlesBasic(playerList){
	if(playerList.length == 0){
		return "";
	}
		var ret = playerList[0].htmlTitleBasic();
		for(num i = 1; i<playerList.length; i++){
			ret += " and " + playerList[i].htmlTitleBasic();
		}
		return ret;
	}



dynamic findPlayersWithDreamSelves(playerList){
	var ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.dreamSelf && !p.isDreamSelf){
			ret.add(p);
		}
	}
	return ret;
}



dynamic findPlayersWithoutDreamSelves(playerList){
	var ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(!p.dreamSelf || p.isDreamSelf){ //if you ARE your dream self, then when you go to sleep....
			ret.add(p);
		}
	}
	return ret;
}




//don't override existing source
void setEctobiologicalSource(playerList, source){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		var g = p.guardian; //not doing this caused a bug in session 149309 and probably many, many others.
		if(p.ectoBiologicalSource == null){
			p.ectoBiologicalSource = source;
			g.ectoBiologicalSource = source;
		}
	}
}




dynamic findPlayersWithoutEctobiologicalSource(playerList){
	var ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.ectoBiologicalSource == null){
			ret.add(p);
		}
	}
	return ret;
}



//deeper than a snapshot, for yellowyard aliens
//have to treat properties that are objects differently. luckily i think those are only player and relationships.
dynamic clonePlayer(player, session, isGuardian){
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
				clone[propertyName] = player[propertyName];
	}
	}
	return clone;
}



dynamic findPlayersFromSessionWithId(playerList, source){
	var ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		//if it' snull, you could be from here, but not yet ectoborn
		if(p.ectoBiologicalSource == source || p.ectoBiologicalSource == null){
			ret.add(p);
		}
	}
	return ret;
}



dynamic findBadPrototyping(playerList){
	for(var i= 0; i<playerList.length; i++){
		if(playerList[i].object_to_prototype.power >= 200){
			return (playerList[i].object_to_prototype.htmlTitle());
		}
	}
	return null;
}



dynamic findHighestMobilityPlayer(playerList){
	var ret = playerList[0];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.mobility > ret.mobility){
			ret = p;
		}
	}
	return ret;
}



dynamic findLowestMobilityPlayer(playerList){
	var ret = playerList[0];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.mobility < ret.mobility){
			ret = p;
		}
	}
	return ret;
}



dynamic findGoodPrototyping(playerList){
	for(var i= 0; i<playerList.length; i++){
		if(playerList[i].object_to_prototype.illegal ==true){
			//print("found good");
			return (playerList[i].object_to_prototype.htmlTitle());
		}
	}
	return null;
}



dynamic getGuardiansForPlayers(playerList){
	List<dynamic> tmp = [];
	for(var i= 0; i<playerList.length; i++){
		var g = playerList[i].guardian;
		tmp.add(g);
	}
	return tmp;
}



void sortPlayersByFreeWill(players){
	return players.sort(compareFreeWill);
}



dynamic compareFreeWill(a,b) {
	return b.getStat("freeWill") - a.getStat("freeWill");
}

dynamic getAverageMinLuck(players){
	if(players.length == 0) return 0;
	num ret = 0;
	for(num i = 0; i< players.length; i++){
		ret += players[i].getStat("minLuck");
	}
	return  (ret/players.length).round();
}



dynamic getAverageMaxLuck(players){
	if(players.length == 0) return 0;
	num ret = 0;
	for(num i = 0; i< players.length; i++){
		ret += players[i].getStat("maxLuck");
	}
	return  (ret/players.length).round();
}



dynamic getAverageSanity(players){
	if(players.length == 0) return 0;
	num ret = 0;
	for(num i = 0; i< players.length; i++){
		ret += players[i].getStat("sanity");
	}
	return  (ret/players.length).round();
}



dynamic getAverageHP(players){
	if(players.length == 0) return 0;
	num ret = 0;
	for(num i = 0; i< players.length; i++){
		ret += players[i].getStat("hp");
	}
	return (ret/players.length).round();
}



dynamic getAverageMobility(players){
	if(players.length == 0) return 0;
	num ret = 0;
	for(num i = 0; i< players.length; i++){
		ret += players[i].getStat("mobility");
	}
	return  (ret/players.length).round();
}



dynamic getAverageRelationshipValue(players){
	if(players.length == 0) return 0;
	num ret = 0;
	for(num i = 0; i< players.length; i++){
		ret += players[i].getAverageRelationshipValue();
	}
	return (ret/players.length).round();
}



dynamic getAveragePower(players){
	if(players.length == 0) return 0;
	num ret = 0;
	for(num i = 0; i< players.length; i++){
		ret += players[i].getStat("power");
	}
	return  (ret/players.length).round();
}



String getPVPQuip(deadPlayer, victor, deadRole, victorRole){
	if(victor.getPVPModifier(victorRole) > deadPlayer.getPVPModifier(deadRole)){
		return "Which is pretty much how you expected things to go down between a " + deadPlayer.class_name + " and a " + victor.class_name + " in that exact situation. ";
	}else{
		return "Which is weird because you would expect the " + deadPlayer.class_name + " to have a clear advantage. Guess echeladder rank really does matter?";
	}
}



dynamic getAverageFreeWill(players){
	if(players.length == 0) return 0;
	num ret = 0;
	for(num i = 0; i< players.length; i++){
		ret += players[i].getStat("freeWill");
	}
	return  (ret/players.length).round();
}

