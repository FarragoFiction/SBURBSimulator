import "dart:html";
import "../SBURBSim.dart";


class Gristmas extends Scene {
    int expectedInitialAverageAlchemyValue = 6;
    int expectedMiddleAverageAlchemyValue = 30;
    int expectedEndAverageAlchemyValue = 75;
    Player player;
  Gristmas(Session session) : super(session);

  String gristmasContent() {
      String ret = "<br><br>GRISTMAS: ";
      List<AlchemyResult> possibilities = doAlchemy();
      //TODO maybe only sort if you are good enough at alchemy???
      possibilities.sort(); //do most promising alchemy first so that you don't use up the items needed for it
      for(AlchemyResult result in possibilities) {
          String tmp  = result.apply(player);
          if(tmp != null) ret += "$tmp";
      }

      ret += "<br><br>After all that ridiculousness, they ALSO manage to upgrade their specibus.";
      possibilities = upgradeSpecibus();
      //not a for loop, just do once.
      String tmp = possibilities.first.apply(player,true);
      if(tmp != null) {
          ret += tmp; //this scene should not happen if you don't have something to alchemize, so don't check to see if there's a result.
      }else {
          throw "No. How the fuck did this happen. Sylladex has ${player.sylladex.length} things in it, so how did I fail to upgrade my specibus?";
      }

    return ret;

  }

  @override
  void renderContent(Element div) {
      String ret = gristmasContent();
      CanvasElement canvas = new CanvasElement(width: 400, height: 400);
      CanvasElement canvas2 = new CanvasElement(width: 400, height: 300);
      Drawing.drawWhatever(canvas, "Rewards/holyAlchemy.png");
      Drawing.drawSinglePlayer(canvas2, player);
      canvas.context2D.drawImage(canvas2,0,0);
      div.append(canvas);
      appendHtml(div, ret);
  }

  //takes all items in inventory and rubs them on each other.
  List<AlchemyResult> doAlchemy() {
      List<AlchemyResult> ret = new List<AlchemyResult>();
      //REMEMBER: item1 OR item2 is a DIFFERENT THING than the reverse. so you aren't wasting time by doing each item pair twice.
      for(Item item1 in player.sylladex) {
        for(Item item2 in player.sylladex) {
            if(item1 != item2 && (item1.canUpgrade() || session.mutator.dreamField)) ret.addAll(AlchemyResult.planAlchemy(<Item>[item1, item2]));
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
              if (p.specibus.canUpgrade() || session.mutator.dreamField) {
                  //print("trying to trigger, specibus can upgrade");
                  p.sylladex.sort();
                  for (Item i in p.sylladex) {
                      if (i.canUpgrade() || session.mutator.dreamField) anyItems = true;
                      if (meetsStandards(p,i)) goodItems = true;
                  }
                  if (anyItems && goodItems)  {
                      //session.logger.info("AB: alchemy triggered.");
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