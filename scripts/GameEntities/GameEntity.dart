part of SBURBSim;

//fully replacing old GameEntity that was also an unholy combo of strife engine
//not abstract, COULD spawn just a generic game entity.
class GameEntity implements Comparable{
  Session session;
  String name;
  String fontColor = "#000000";
  bool ghost; //if you are ghost, you are rendered spoopy style
  num grist; //everything has it.
  bool dead = false;
  bool corrupted = false; //players are corrupted at level 4. will be easier than always checking grimDark level
  List<dynamic> fraymotifs = [];
  bool usedFraymotifThisTurn = false;
  List<Buff> buffs = []; //only used in strifes, array of BuffStats (from fraymotifs and eventually weapons)
  HashMap stats = {};
  List<Relationship> relationships; //not to be confused with the RELATIONSHIPS stat which is the value of all relationships.
  HashMap permaBuffs = {"MANGRIT":0}; //is an object so it looks like a player with stats.  for things like manGrit which are permanent buffs to power (because modding power directly gets OP as shit because power controls future power)
  num renderingType = 0; //0 means default for this sim.
  List<AssociatedStat> associatedStats = [];  //most players will have a 2x, a 1x and a -1x stat.
  var spriteCanvasID = null;  //part of new rendering engine.
  num id;
  bool doomed = false; //if you are doomed, no matter what you are, you are likely to die.
  List<GameEntity> doomedTimeClones = []; //help fight the final boss(es).
  String causeOfDeath = ""; //fill in every time you die. only matters if you're dead at end
  GameEntity crowned = null; //TODO figure out how this should work. for now, crowns count as Game Entities, but should be an Item eventually

  GameEntity(this.name, this.id, this.session) {
    stats['sanity'] = 0;
    stats['alchemy'] = 0;
    stats['currentHP'] = 0;
    stats['hp'] = 0;
    stats['RELATIONSHIPS'] = 0;
    stats['minLuck'] = 0;
    stats['maxLuck'] = 0;
    stats['freeWill'] = 0;
    stats['mobility'] = 0;
    stats['power'] = 0;  //power is generic sign of level.
  }

  //TODO grab out every method that current gameEntity, Player and PlayerSnapshot are required to have.
  //TODO make sure Player's @overide them.

  String toString(){
    return this.htmlTitle().replaceAll(new RegExp(r"\s", multiLine:true), '').replaceAll(new RegExp(r"'", multiLine:true), ''); //no spces probably trying to use this for a div
  }

  //as each type of entity gets renderable, override this.
  bool renderable() {
    return false;
  }

  //naturally sorted by mobility
  int compareTo(other) {
    return other.getStat("mobility") - getStat("mobility");  //TODO or is it the otherway around???
  }

  String checkDiedInAStrife(List<Team> enemyTeams) {
      if(getStat("currentHP") <= 0) {
        //TODO check for jack, king
        GameEntity jack = Team.findJackInTeams(enemyTeams);
        GameEntity king = Team.findKingInTeams(enemyTeams);
        String causeOfDeath = "fighting in a strife against ${Team.getTeamsNames(enemyTeams)}";
        if(jack != null) {
          causeOfDeath = "after being shown too many stabs from Jack";
        }else if(king != null){
          causeOfDeath = "fighting the Black King";
        }
        makeDead(causeOfDeath);
        return "${htmlTitleHP()} has died. ";
      }
      return "";
  }

  //any subclass can choose to do things differently. for now, this is default.
  //so yes, npcs can have ghost attacks.
  //this won't be called if I CAN'T take a turn because i participated in fraymotif
  void takeTurn(div, Team mySide, List<Team> enemyTeams) {

      //don't forget to let Team know if you used fraymotifs this turn.

      //if i am dead, and have a ghost pact, try to revive (no more non ghost pact strife reviving). pact only works on self.

      //if still dead, return, can't do anything.
      if(dead) {
        reviveViaGhostPact(div);
        //whether it works or not, return. you can't revive AND do other stuff.
        return;
      }

      //pick a team to target.  if cant find target, return
      Team targetTeam = pickATeamToTarget(enemyTeams);
      if(targetTeam == null) return; //nobody to fight.
      //pick a member of the team to extra target. ig player and light, even if corpse
      GameEntity target = pickATarget(targetTeam.members);
      //try to use fraymotif
      if(!useFraymotif(div, mySide, target, targetTeam)){
        aggrieve(div, target);
      }
      //last thing you do is die.
      mySide.checkForAPulse(div, enemyTeams);
      List<Team> allTeams = new List<Team>.from(enemyTeams);
      allTeams.add(mySide);
      for(Team team in enemyTeams) {
          team.checkForAPulse(div, team.getOtherTeams(allTeams));
      }
        throw "TODO: take turn";

  }

  bool useFraymotif(div, Team mySide, GameEntity target, Team targetTeam){
    List<GameEntity> living_enemies = findLivingPlayers(targetTeam.members);
    List<GameEntity> living_allies = findLivingPlayers(mySide.members);
    if(seededRandom() > 0.5) return false; //don't use them all at once, dunkass.
    List<Fraymotif> usableFraymotifs = this.session.fraymotifCreator.getUsableFraymotifs(this, living_allies, living_enemies);
    if(crowned != null){  //ring/scepter has fraymotifs, too.  (maybe shouldn't let humans get thefraymotifs but what the fuck ever. roxyc could do voidy shit.)
      usableFraymotifs.addAll(this.session.fraymotifCreator.getUsableFraymotifs(crowned, living_allies, living_enemies));
    }
    if(usableFraymotifs.length == 0) return false;
    var mine = owner.getStat("sanity");
    var theirs = getAverageSanity(living_enemies);
    if(mine+200 < theirs && seededRandom() < 0.5){
      print("Too insane to use fraymotifs: " + owner.htmlTitleHP() +" against " + living_enemies[0].htmlTitleHP() + "Mine: " + mine + "Theirs: " + theirs + " in session: " + this.session.session_id)
      div.append(" The " + owner.htmlTitleHP() + " wants to use a Fraymotif, but they are too crazy to focus. ")
      return false;
    }
    mine = owner.getStat("freeWill") ;
    theirs = getAverageFreeWill(living_enemies);
    if(mine +200 < theirs && seededRandom() < 0.5){
      print("Too controlled to use fraymotifs: " + owner.htmlTitleHP() +" against " + living_enemies[0].htmlTitleHP() + "Mine: " + mine + "Theirs: " + theirs + " in session: " + this.session.session_id)
      div.append(" The " + owner.htmlTitleHP() + " wants to use a Fraymotif, but Fate dictates otherwise. ")
      return false;
    }

    var chosen = usableFraymotifs[0];
    for(num i = 0; i<usableFraymotifs.length; i++){
      var f = usableFraymotifs[i];
      if(f.tier > chosen.tier){
        chosen = f; //more stronger is more better (refance)
      }else if(f.tier == chosen.tier && f.aspects.length > chosen.aspects.length){
        chosen = f; //all else equal, prefer the one with more members.
      }
    }



    div.append("<Br><br>"+chosen.useFraymotif(owner, living_allies, living_enemies) + "<br><Br>");
    chosen.usable = false;
    return true;
    throw("TODO");
  }

  void aggrieve(div, GameEntity target){


  }

  //currently only thing ghost pacts are good for post refactor.
  void reviveViaGhostPact(div){
      throw("TODO");
  }

  Team pickATeamToTarget(List<Team> team){
    //when assigning assholePoints to a team, give them extra if they have light players on them. light players are distracting.
    //negative points for void players.
    throw("TODO");
  }

  GameEntity pickATarget(List<GameEntity> targets){
    //when assigning assholePoints to a target, give them extra if they have light players on them. light players are distracting.
    //negative points for void players.
    throw("TODO");
  }

  void changeGrimDark(){
    //stubb
  }
  void increasePower(){
    //stub for sprites, and maybe later consorts or carapcians
  }
  num getTotalBuffForStat(statName){
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
    if(statName == "currentHP") return "sturdy";
    if(statName == "RELATIONSHIPS") return "friendly";
    if(statName == "mobility") return "fast";
    if(statName == "sanity") return "calm";
    if(statName == "freeWill") return "willful";
    if(statName == "power") return "powerful";  //should never buff this directly, just use MANGRIT
    if(statName == "maxLuck") return "lucky";
    if(statName == "minLuck") return "lucky";
    if(statName == "alchemy") return "creative";
    print("what the hell kind of stat name is: ${statName}");
    return "glitchy";
  }
  String describeBuffs(){
    List<dynamic> ret = [];
    Iterable allStats = this.allStats();
    for(String stat in allStats){
      var b = this.getTotalBuffForStat(stat);
      //only say nothing if equal to zero
      if(b>0) ret.add("more "+this.humanWordForBuffNamed(stat));
      if(b<0) ret.add("less " + this.humanWordForBuffNamed(stat));
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
      this.stats[stat.name] += modValue * stat.multiplier;
    }
  }
  //TODO players (and any complicated NPCS) need to override this to hook up RELATIONSHIPS to actual other players.
  num getStat(statName){
    num ret = this.stats[statName];
    for(var i = 0; i<this.buffs.length; i++){
      var b = this.buffs[i];
      if(b.name == statName) ret += b.value;
    }
    if(statName == "power") {
      ret += this.permaBuffs["MANGRIT"]; //needed because if i mod power directly, it effects all future progress in an unbalanced way.;
      ret = Math.max(0, ret); //no negative power, dunkass.
    }
    return (ret).round();
  }

  //sets current hp to max hp. mostly called after strifes assuming you'll use healing items
  void heal() {
      setStat("currentHP", getStat("hp"));
  }

  void setStat(statName,value){
    if(this.stats[statName] == null) throw("I have never heard of a stat called: " +statName);
    this.stats[statName] = value;
  }

  void addStat(statName,value){
    if(this.stats[statName] == null) throw("I have never heard of a stat called: " +statName);
    this.stats[statName] += value;
  }


  void setStatsHash(hashStats){
    for (var key in hashStats.keys){
      this.stats[key] =  hashStats[key];
    }
    this.stats["currentHP"] =  Math.max(this.stats["hp"], 10); //no negative hp asshole.
  }

  dynamic htmlTitle(){
    String ret = "";
    if(this.crowned != null) ret+="Crowned ";
    var pname = this.name;
    if(pname == "Yaldabaoth"){
      var misNames = ['Yaldobob', 'Yolobroth', 'Yodelbooger', "Yaldabruh", 'Yogertboner','Yodelboth'];
      print("Yaldobooger!!! " + this.session.session_id.toString());
      pname = getRandomElementFromArray(misNames);
    }
    if(this.corrupted) pname = Zalgo.generate(this.name); //will i let denizens and royalty get corrupted???
    return ret + pname; //TODO denizens are aspect colored.
  }
  String htmlTitleHP(){
    String ret = "<font color ='${fontColor}'>" ;
    if(this.crowned != null) ret+="Crowned ";
    var pname = this.name;
    if(this.corrupted) pname = Zalgo.generate(this.name); //will i let denizens and royalty get corrupted???
    return ret + pname +" (" + (this.getStat("currentHP")).round().toString() +" hp, " + (this.getStat("power")).round().toString() + " power)</font>"; //TODO denizens are aspect colored.
  }
  void flipOut(reason){

  }

  String htmlTitleBasic(){
    return this.name;
  }

  void makeAlive() {
    this.dead = false;
  }


  void getRelationshipWith(GameEntity target){
    //stub for boss fights where an asshole absconds.
  }

  void makeDead(String causeOfDeath){
    this.dead = true;
    this.causeOfDeath = causeOfDeath;
  }

  void interactionEffect(GameEntity ge){
    //none
  }
  //takes in a stat name we want to use. for example, use only min luck to avoid bad events.
  num rollForLuck(String stat){
    if(stat==""){
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

  Iterable allStats(){
    return this.stats.keys;
  }

  static String getEntitiesNames(List<GameEntity> ges) {
   return ges.join(',');  //TODO put an and at the end.
  }


}




//need to know if you're from aspect, 'cause only aspect associatedStats will be used for fraymotifs.
//except for heart, which can use ALL associated stats. (cause none will be from aspect.)
class AssociatedStat {
  var name;
  var multiplier;
  var isFromAspect;


  AssociatedStat(this.name, this.multiplier, this.isFromAspect) {}


  String toString(){
    String tmp = "";
    if(this.isFromAspect) tmp = " (from Aspect) ";
    return "["+this.name + " x " +this.multiplier + tmp+"]";
  }
}



//can eventually have a duration, but for now, assumed to be the whole fight. i don't want fights to last long.
class Buff {
  Buff(String this.name, num this.value) {}

  String name;
  num value;
}

