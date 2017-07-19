
//TODO strip out all "strife" parts and leave this as the "parent" to Player, Ghost, DoomedPlayer, and NPC.
//TODO eventually subtype NPC out to consort, sprite and carapace.
class GameEntityOld {
	var session;
	var name;
	//num alchemy = 0;
	bool armless = false;
	num grist = 0;
	List<dynamic> fraymotifs = [];
	bool usedFraymotifThisTurn = false;
	List<dynamic> buffs = []; //only used in strifes, array of BuffStats (from fraymotifs and eventually weapons)
	bool carapacian = false;
	num sanity = 0; //eventually replace triggerLevel with this (it's polarity is opposite triggerLevel)
	num alchemy = 0; //mostly unused until we get to the Alchemy update.
	bool consort = false;
	bool sprite = false;		//if any stat is -1025, it's considered to be infinitie. denizens use. you can't outluck Cetus, she is simply the best there is.
	num minLuck = 0;
	num currentHP = 0;
	num hp = 0;  //what does infinite hp mean? you need to defeat them some other way. alternate win conditions? or can you only do The Choice?
	num mobility = 0;  //first guardian
	num maxLuck = 0; //rabbit
	num freeWill = 0; //jack has extremely high free will. why he is such a wild card
	List<dynamic> relationships = [];
	num RELATIONSHIPS = 0; //fake as fuck stat so gameEntieties buffing or debuffing relationships have something to do.
	num power = 0;
	bool dead = false;
	var crowned;
	bool abscondable = true; //nice abscond
	bool canAbscond = true; //can't abscond bro
	List<dynamic> playersAbsconded = [];
	bool iAbscond = false;
	bool exiled = false;
	bool lusus = false;
	bool player = false;  //did a player jump in a sprite?
	bool illegal = false; //used only for sprites. whether or not they are reptile/amphibian.
	bool corrupted = false; //if corrupted, name is zalgoed.
		//when tier2 sprites, helpful sprites override the other sprites helpfulnes and help phrase.
		//corrupt sprites maybe activate second corrupt phrase, like glitched out librarians and pomeranians
	num helpfulness = 0; //if 0, cagey riddles. if 1, basically another player. if -1, like calsprite. omg, just shut up.  NOT additive for when double prototyping. most recent prototyping overrides.
	String helpPhrase = "provides the requisite amount of gigglesnort hideytalk to be juuuust barely helpful. ";		

	// more undefined fields... -PL
	var flippingOutOverDeadPlayer = null;
	String flipOutReason = "";
	String causeOfDeath = "";


	GameEntity(this.session, this.name, this.crowned) {}


	bool renderable(){
			return false; //eventually some game entities can be rendered.
		}


	void changeGrimDark(){
			//stubb
		}
	void summonMidnightCrew(div, player, numTurns){

  }






}



//maybe it's a player. maybe it's game entity. whatever. copy it.
//take name explicitly 'cause plaeyrs don't have one
dynamic copyGameEntity(object, name){
	var ret = new GameEntity(object.session, name, null);
	ret.corrupted = object.corrupted;
	ret.helpPhrase = object.helpPhrase;
	ret.helpfulness = object.helpfulness; //completely overridden.
	ret.grist = object.grist;
	ret.minLuck = object.minLuck;
	ret.currentHP = object.currentHP;
	ret.hp = object.hp;
	ret.mobility = object.mobility;
	ret.maxLuck = object.maxLuck;
	ret.freeWill = object.freeWill;
	ret.power = object.power;
	ret.illegal = object.illegal;
	ret.minLuck = object.minLuck;
	ret.minLuck = object.minLuck;
	ret.minLuck = object.minLuck;
	ret.player = object.player;
	ret.lusus = object.lusus;
	//idea, custom 'help string'. stretch goal for later. would let me have players help in different ways than a pomeranian would, for example.
	return ret;
}

