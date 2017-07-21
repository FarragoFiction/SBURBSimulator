
/*

  WARNING: BEING ABANDONED FOR NOW CAUSE IT TURNS OUT MY JS WOULDN'T BE ABLE TO CALL THIS EASILY.


  
  A planet should be tailored for a specific player.
  It's land words should have one aspect related word, (only frog for space)
  and one "random" word.

  The quests inside the land should be specific to the player.  They should
  be based on class and aspect, most obviously, but also on their Interest Categories
  (which have 14 possible thingies).

  There should be quests for different internal land events.
  PreDenizen, Denizen and Post Denizen are
  categories currently in the sim.

  Lands should have a "questCompletion" rate that determines which set of quests to use.

  is prospit/derse a planet? a subtype of planet?

 */
class Planet{
  String word1;
  String word2;
  List<QuestChain> questChains;
}


/*
  Dead Planets do everything a planet does, but ALSO has a timelimit
  a penalty for not winning before timelimit
  and a reward for winning before timelimit.
 */
class DeadPlanet extends Planet{

}


/*
  A QuestChain is a collection of quests that must be completed in order.

  it is associated with a reward for completion. or something. still planning.

  IDEA: MAKE THEM BRANCHING BASED ON CLASS.  A PRINCE MIGHT DO DESTRUCTIVE THINGS TO WIN, WHILE A SYLPH MEDDLE-WINS

  ALSO branch based on help?  Maybe....instead of branching based on X, make it branching based on
  some internal marker, which different classes and aspects and helpers can effect?
  like a QuestChain has a "friendly" rating which you contribute to x2 and your helper contributes to x0.5
  and is just your RELATIONSHIPS stat.  If currentQuestChain.friendly > 10, do this, else do that.
  what kinds of branches could you expect?
  ways to solve quests:
  friendly -- agressive
  clever -- dumb
  lucky -- unlucky
 */
class QuestChain{
  List<Quest> quests;
  List<Reward> rewards; //most questChains only have one reward, but i won't limit things.


}


/*
  A Quest is just flavor text.
  maybe in the future it can be upgraded to be failable, maybe have a power requirement to pass?
 */
class Quest{
  String flavorText;
  List<Reward> rewards; //most quests only have one reward, but i won't limit things.
}

/*
  base level reward just calls increasePower on the player passed to it.
  but want to extend it so there is FraymotifReward, ItemReward, WeaponReward
  etc. Each will call teh super reward so that all rewards at minimum increase Power.
 */
class Reward{

  applyReward(player){
    player.increasePower();
  }

}