import "dart:html";
import "../SBURBSim.dart";


class Gristmas extends Scene {
    int expectedInitialAverageAlchemyValue = 6;
    int expectedMiddleAverageAlchemyValue = 30;
    int expectedEndAverageAlchemyValue = 75;
    Player player;
  Gristmas(Session session) : super(session);
    /*TODO  ((rambling brainstorming for how i wanna do shit based on RS convos

        Okay, I'm nearly certain that ITEMS should know how combine with other items, not this scene.
         I want to be able to do alchemy even out of the scene proper. Probably ?

         What IS an alchemy scene? It's a scene where you combine items with other items and then stick those items into your specibus to upgrade it.

         Only one person can do it per round , person with greatest amount of items.  \
         (I'm going to assume alchemizing x and y consumes Y or syladex will get p full)

         Okay. What triggers an alchemy scene? Having items in your syladdex, for one. Having more room in your specibus to upgrade it for two.
         After that, whoever has highest alchemy gets first dibs?


         they check their syladex and see if they have anything good. if so, they go. if not, they don't.
         "good" is defined as any single item having a total tier more than their current specibus.

         Alright, I wanna test these scenes out before I implement item combining, see if the balance works
          (i.e. how much alchemy happens in an average session)

          What other things do I need to remember? If your alchemy is higher than average, be better at alchemy. What does this mean?

          Well, regardless of alchemy stat, some classes/aspects are better at it than others. This is the equivalent of a life scene or whatever for
          certain aspects, so they should get something special.

          If your aspect boosts alchemy, then the number of times you can do an alchemy scene is modified by that boost.
          Default is say, 3. Space has a +2 to alchemy, so they can upgrade their specibus 2 extra times.
          Oh my fuck why is there no aspects with NEGATIVE to alchemy, but fucking THREE with +2? this is bullshit. dream needs +3 at least.
          maybe mind can have a negative to alchemy? too many choices , we get overwhelmed?

          okay what else? am i missing anything? doop doop....

          So, what's the use case here.

          Alchemy scene checks if it's triggered.  It asks each player if they have any items in their specibus, and if their specibus
          can be improved.

          Doop doop.

          Need to think this through.  It's not enough to know how I want alchemy to work.
          I ALSO need to do it.  And the biggest hole in my plans is that I don't know how regular item
          level alchemy will work.

          Example:
            Player has 4 items in inventory. Wants to condense them into 2 items.
            How do they pick which items to rub on which items?

            Simplest algorithm would be to just go in order. Item 1 goes into item 0.
            But this is hardly optimal. If you get better items over time than you are shoving weak into weak
            and strong into strong and maybe repeating traits or whatever the fuck.

            ((Note to self, do I want items to be able to repeat traits? NO.))

            Second simplest is just bugfuck random. Shove random items into each other.

            Most 'human' and thus most complicated is to try to figure out which is "best".

            The problem is that knowing the results of alchemy is basically as hard as doing the alchemy itself.
            Or rather, from a technical viewpoint it's identical. Except I want alchemy to consume items.
            So I can't presimulate easily.

            Hrrrrrrm.

            I could have some sort of AlchemyResult object?

            Takes in two items, tells you what the result would be, and has a method to actually do it?



          Todo:
          *  let player  Player can modify max upgrades for items given to them.
          *     * Make syladex half private, so you can't add things to it without calling a method.
          * Add AND and OR (and maybe XOR) functions to items.
          *    * AND gives the item EVERYTHING the other item has. (possibly half of these, for balance)
          *    * OR gives the item the function of the original OR the appearance, and the opposite from the new one.
          *    XOR does an AND, then removes everything from the item that both items have in common.
          *Render Content shows player and alchemiter (eventually items, but nto pre rendering update) and has text about what was made and the procedural description.
     */

  @override
  void renderContent(Element div) {
      String ret = "GRISTMAS: ";
      List<AlchemyResult> possibilities = doAlchemy();
      //TODO maybe only sort if you are good enough at alchemy???
      possibilities.sort(); //do most promising alchemy first so that you don't use up the items needed for it
      for(AlchemyResult result in possibilities) {
          String tmp  = result.apply(player);
          if(tmp != null) ret += "$tmp";
      }

      ret += "<br><br>After all that ridiculousness, they ALSO manage to upgrade their ${player.specibus}.";
      possibilities = upgradeSpecibus();
      //not a for loop, just do once.
      String tmp = possibilities.first.apply(player,true);
      if(tmp != null) {
          ret += tmp; //this scene should not happen if you don't have something to alchemize, so don't check to see if there's a result.
      }else {
          throw "No. How the fuck did this happen. Sylladex has ${player.sylladex.length} things in it, so how did I fail to upgrade my specibus?";
      }

      appendHtml(div, ret);
  }

  //takes all items in inventory and rubs them on each other.
  List<AlchemyResult> doAlchemy() {
      List<AlchemyResult> ret = new List<AlchemyResult>();
      //REMEMBER: item1 OR item2 is a DIFFERENT THING than the reverse. so you aren't wasting time by doing each item pair twice.
      for(Item item1 in player.sylladex) {
        for(Item item2 in player.sylladex) {
            if(item1 != item2) ret.addAll(AlchemyResult.planAlchemy(<Item>[item1, item2]));
        }
      }
      return ret;
  }

    //takes all items in inventory and rubs them on each other.
    List<AlchemyResult> upgradeSpecibus() {
        List<AlchemyResult> ret = new List<AlchemyResult>();
        //REMEMBER: item1 OR item2 is a DIFFERENT THING than the reverse. so you aren't wasting time by doing each item pair twice.
        for(Item item1 in player.sylladex) {
            ret.addAll(AlchemyResult.planAlchemy(<Item>[player.specibus, item1]));
        }
        return ret;
    }

  @override
  bool trigger(List<Player> playerList) { //god i hate that player list is still a thing, past jr fucked up.
      List<Player> availablePlayers = findLivingPlayers(session.getReadOnlyAvailablePlayers());
      //relative alchemy value matters too.
      List<Player> players = Stats.ALCHEMY.sortedList(availablePlayers);
      player = null;
      //print("trying to trigger gristmas for ${players.length} players.");
      for(Player p in players) {
          if(player == null) {
              //print("trying to trigger, player is not null");
              bool anyItems = false;
              bool goodItems = false;
              if (p.specibus.canUpgrade()) {
                  //print("trying to trigger, specibus can upgrade");
                  for (Item i in p.sylladex) {
                      if (i.canUpgrade()) anyItems = true;
                      if (meetsStandards(p,i)) goodItems = true;
                  }
                  if (anyItems && goodItems)  {
                      session.logger.info("AB: alchemy triggered.");
                      player = p;
                  }
              }
          }
      }
      return player != null;
  }

  //the better you are at alchemy, the higher your standards are.
  bool meetsStandards(Player p, Item i) {
      double ratio = 1.0;
      //depending on how far along you are in your quest, your standards should get higher.
      if(p.land != null && !p.land.firstCompleted) ratio = p.getStat(Stats.ALCHEMY)/expectedInitialAverageAlchemyValue;
      if(p.land != null && p.land.firstCompleted && !p.land.thirdCompleted) ratio = p.getStat(Stats.ALCHEMY)/expectedMiddleAverageAlchemyValue;
      if(p.land != null && !p.land.thirdCompleted) ratio = p.getStat(Stats.ALCHEMY)/expectedEndAverageAlchemyValue;

      //basically, if you'er higher than average, your standards will be higher
      //and if you'er lower than average, your standards will be lower.
      //specibus = 1.0, item = .9 works for somebody with lower skill
      //does not work for somebody with higher.
      //BUT don't be so snobby you don't alchemize things before the final battle.
      return ((i.rank) > p.specibus.rank*ratio) || session.timeTillReckoning < 10;
  }
}