part of SBURBSim;

//fully replacing old GameEntity that was also an unholy combo of strife engine
class GameEntity {
  Session session;
  String name;
  bool dead = false;
  List<dynamic> fraymotifs = [];
  bool usedFraymotifThisTurn = false;
  List<dynamic> buffs = []; //only used in strifes, array of BuffStats (from fraymotifs and eventually weapons)
  Stats stats = new Stats();
  var permaBuffs = {"MANGRIT":0}; //is an object so it looks like a player with stats.  for things like manGrit which are permanent buffs to power (because modding power directly gets OP as shit because power controls future power)
  num renderingType = 0; //0 means default for this sim.
  List<dynamic> associatedStats = [];  //most players will have a 2x, a 1x and a -1x stat.
  var spriteCanvasID = null;  //part of new rendering engine.
  num id;
  bool doomed = false; //stat that doomed time clones have.
  List<GameEntity> doomedTimeClones = []; //help fight the final boss(es).
  String causeOfDeath = ""; //fill in every time you die. only matters if you're dead at end
  GameEntity crowned = null; //TODO figure out how this should work. for now, crowns count as Game Entities, but should be an Item eventually
  GameEntity(this.name, this.id, this.session);

  //TODO grab out every method that current gameEntity, Player and PlayerSnapshot are required to have.
  //TODO make sure Player's @overide them.

  dynamic toString(){
    return this.htmlTitle().replace(new RegExp(r"""\s""", multiLine:true), '').replace(new RegExp(r"""'""", multiLine:true), ''); //no spces probably trying to use this for a div
  }
  void increasePower(){
    //stub for sprites, and maybe later consorts or carapcians
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
    return null;
  }
  dynamic describeBuffs(){
    List<dynamic> ret = [];
    var allStats = this.allStats();
    for(num i = 0; i<allStats.length; i++){
      var b = this.getTotalBuffForStat(allStats[i]);
      //only say nothing if equal to zero
      if(b>0) ret.add("more "+this.humanWordForBuffNamed(allStats[i]));
      if(b<0) ret.add("less " + this.humanWordForBuffNamed(allStats[i]));
    }
    if(ret.length == 0) return "";
    return this.htmlTitleHP() + " is feeling " + turnArrayIntoHumanSentence(ret) + " than normal. ";
  }

  void modifyAssociatedStat(modValue, stat){
    //modValue * stat.multiplier.
    if(stat.name == "RELATIONSHIPS"){
      for(num i = 0; i<this.relationships.length; i++){
        this.relationships[i].value += modValue * stat.multiplier;
      }
    }else{
      this[stat.name] += modValue * stat.multiplier;
    }
  }
  dynamic getStat(statName){
    num ret = 0;
    ret += this[statName] ;//for game entitties RELATIONSHIPS will ALSO be a fake as fuck int var thingy.;
    if(statName == "RELATIONSHIPS"){ //in addition to the for loop of doom.
      for(num i = 0; i<this.relationships.length; i++){
        ret += this.relationships[i].value;s
      }
    }
    for(num i = 0; i<this.buffs.length; i++){
      var b = this.buffs[i];
      if(b.name == statName) ret += b.value;
    }
    if(this.crowned) ret += this.crowned.getStat(statName); //so meta.
    return ret;
  }

  void setStatsHash(hashStats){
    for (var key in hashStats){
      this[key] = hashStats[key];
    }
    this.currentHP = Math.max(this.hp, 10); //no negative hp asshole.
  }
  void setStats(minLuck, maxLuck, hp, mobility, sanity, freeWill, power, abscondable, canAbscond, framotifs, grist){
    this.minLuck = minLuck;
    this.hp = hp;
    this.currentHP = this.hp;
    this.mobility = mobility;
    this.maxLuck = maxLuck;
    this.sanity = sanity;
    this.freeWill = freeWill;
    this.power = power;
    this.abscondable = abscondable;
    this.canAbscond = canAbscond;
    this.grist = grist;
  }
  dynamic htmlTitle(){
    String ret = "";
    if(this.crowned != null) ret+="Crowned ";
    var pname = this.name;
    if(pname == "Yaldabaoth"){
      var misNames = ['Yaldobob', 'Yolobroth', 'Yodelbooger', "Yaldabruh", 'Yogertboner','Yodelboth'];
      print("Yaldobooger!!! " + this.session.session_d);
      pname = getRandomElementFromArray(misNames);
    }
    if(this.corrupted) pname = Zalgo.generate(this.name); //will i let denizens and royalty get corrupted???
    return ret + pname; //TODO denizens are aspect colored.
  }
  dynamic htmlTitleHP(){
    String ret = "";
    if(this.crowned != null) ret+="Crowned ";
    var pname = this.name;
    if(this.corrupted) pname = Zalgo.generate(this.name); //will i let denizens and royalty get corrupted???
    return ret + pname +" (" + (this.getStat("currentHP")).round() +" hp, " + (this.getStat("power")).round() + " power)</font>"; //TODO denizens are aspect colored.
  }
  void flipOut(reason){
    this.flippingOutOverDeadPlayer = null;
    this.flipOutReason = reason;
  }
  //TODO this will be different for different children. ???
  void addPrototyping(object){
    this.name = object.name + this.name; //sprite becomes puppetsprite.
    this.fraymotifs.addAll(object.fraymotifs);
    if(object.fraymotifs.length == 0){
      var f = new Fraymotif([], object.name + "Sprite Beam!", 1);
      f.effects.add(new FraymotifEffect("power",2,true)); //do damage
      f.effects.add(new FraymotifEffect("hp",1,true)); //heal
      f.flavorText = " An appropriately themed beam of light damages enemies and heals allies. ";
      this.fraymotifs.add(f);
    }
    this.corrupted = object.corrupted;
    this.helpfulness = object.helpfulness; //completely overridden.
    this.helpPhrase = object.helpPhrase;
    this.grist += object.grist;
    this.lusus = object.lusus;
    this.minLuck += object.minLuck;
    this.currentHP += object.currentHP;
    this.hp += object.hp;
    this.mobility += object.mobility;
    this.maxLuck += object.maxLuck;
    this.freeWill += object.freeWill;
    this.power += object.power;
    this.illegal = object.illegal;
    this.minLuck += object.minLuck;
    this.minLuck += object.minLuck;
    this.minLuck += object.minLuck;
    this.player = object.player;
  }

  dynamic htmlTitleBasic(){
    return this.name;
  }
  void getRelationshipWith(){
    //stub for boss fights where an asshole absconds.
  }
  void makeDead(causeOfDeath){
    this.dead = true;
    this.causeOfDeath = causeOfDeath;
  }

  void interactionEffect(player){
    //none
  }
  dynamic rollForLuck(stat){
    if(!stat){
      return getRandomInt(this.getStat("minLuck"), this.getStat("maxLuck"));
    }else{
      //don't care if it's min or max, just compare it to zero.
      return getRandomInt(0, this.getStat(stat));
    }

  }
  void boostAllRelationshipsWithMeBy(amount){

  }
  void boostAllRelationshipsBy(amount){

  }
  List<dynamic> getFriendsFromList(list){
    return [];
  }
  List<dynamic> getHearts(){
    return [];
  }
  List<dynamic> getDiamonds(){
    return [];
  }





  dynamic allStats(){
    return ["power","hp","RELATIONSHIPS","mobility","sanity","freeWill","maxLuck","minLuck","alchemy"];
  }

}

//knows how to get  a stat and modify it with buffers, whatever.
//TODO make this hash.
class Stats {
  num sanity = 0; //eventually replace triggerLevel with this (it's polarity is opposite triggerLevel)
  num alchemy = 0; //mostly unused until we get to the Alchemy update.
  num currentHP = 0;
  num hp = 0;  //what does infinite hp mean? you need to defeat them some other way. alternate win conditions? or can you only do The Choice?
  List<Relationship> relationships = [];
  num minLuck = 0;
  num maxLuck = 0;
  num freeWill = 0;
  num mobility = 0;
  num power = 1;   //power is generic. generally scales with any aplicable stats. lets me compare two different aspect players.
}