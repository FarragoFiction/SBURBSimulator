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