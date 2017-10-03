import "dart:html";
import "../SBURBSim.dart";
import 'dart:math' as Math;

///in what way is this supposed to be an RPG if you can do quests and stuff?
class QuestsAndStuff extends Scene {
	bool canRepeat = false;
	List<QuestingParty> landParties = new List<QuestingParty>();
    List<QuestingParty> moonParties = new List<QuestingParty>();
    List<QuestingParty> skaiaParties = new List<QuestingParty>();
	QuestsAndStuff(Session session): super(session, false);


    /*
     *   There are several kinds of quests you can do here.
     *
     *   Land quests, require you to be in the medium.
     *      if you are a page, you also require help.
     *      A player can help once they have hit a particular grist level. Should mention this has happened when it does (scene for that?)
     *
*        Moon quests require you to be awake.
*           You don't need a dream self, moon quests will handle turning into bubble or horrorterror quests on command.
*           Players start at 0% dream chance (not awake), and then each turn they don't do a moon quest increases the odds of doing one.
*           Once you do a moon quest it resets to lower of current value or 33%  (unless you have  status effect that makes you obsessed with moon quests)
*           TODO: Post NPC update npc quest chains should add to the land/moon in question. If you are going to help overthrow queen, then quest chain gets added to Derse.
*
*       Skaia quests require you to be god tier or finished with all land quests. Need to refresh my memory on what these are.
*           when everybody has unlocked skaia quests, then reckoning happens. (or when time runs out).
     */
  @override
	bool trigger(List<Player> playerList){
      landParties.clear();
      moonParties.clear();
      skaiaParties.clear();
      allocateMoonQuests();
      allocateLandQuests(); //<-- is 100% going to happen unless finished, so go last or the thing after you won't count.
      //allocateSkaiaQuests(); //TODO
      return (landParties.isNotEmpty || moonParties.isNotEmpty || skaiaParties.isNotEmpty);
	}

    //you need to be available, you need to be alive, you need to have quests remaining on your land.
    void allocateLandQuests() {
        //random players get to go first
        List<Player> avail = shuffle(session.rand, session.getReadOnlyAvailablePlayers());
        for(Player p in avail) {
            if(session.isPlayerAvailable(p) && !p.dead && !p.landFuture.noMoreQuests){
                QuestingParty party = createQuestingParty(p);
                if(party != null) landParties.add(party);
            }
        }
    }


    void allocateMoonQuests() {
        //you need to be alive. (available doesn't matter, you can dream after doing something. consider it a free action, otherwise they won't get into the medium).
        for(Player p in session.players) {
            if(!p.dead && session.rand.nextDouble() < p.moonChance) {
                //TODO decide if i will allow co-op moon shit.
                moonParties.add(new QuestingParty(session, p, null));
                //back down to "normal"
                p.moonChance = Math.min(p.moonChance, 33.0);
            }else {
                p.moonChance += 5;
            }
        }
	}

    void allocateSkaiaQuests() {
	    //you need to be god tier or completely done with your land quests.
        throw("TODO");
    }


    QuestingParty createQuestingParty(Player player) {
        Player helper = player.findHelper(session.getReadOnlyAvailablePlayers());
        //pages REQUIRE a helper, so if helper is null, return null.
        //if either player is grim dark >= 3, then no party. assume grim dark friend actively encourages peoplel they hang out with to not quest
        if(player.class_name == SBURBClassManager.PAGE && helper == null) return null;
        if(player.grimDark >=3 || (helper != null && helper.grimDark >=3)) return null;
        //it's okay if helper is null.
        return new QuestingParty(session, player, helper);
    }

	void processMoon(Element div, QuestingParty questingParty) {
	    Player player = questingParty.player1;
		player.moonFuture.initQuest([player]);
		String html = "${player.moonFuture.getChapter()}  ";
		appendHtml(div, html);
		//doQuests will append itself.
		player.moonFuture.doQuest(div, player, null);
	}

    void processLand(Element div, QuestingParty questingParty) {
        Player player = questingParty.player1;
        Player helper = questingParty.player2;
        player.landFuture.initQuest([player]);
        String helperText = "The ${helper.htmlTitle()} is helping where they can. ";
        String html = "${player.landFuture.getChapter()}The ${player.htmlTitle()} is in the ${player.landFuture.name}.  ${player.landFuture.randomFlavorText(session.rand, player)} ";
        appendHtml(div, html);
        player.landFuture.doQuest(div, player, helper);
        player.interactionEffect(helper);
        helper.interactionEffect(player);

    }



	@override
	void renderContent(Element div){
		for(QuestingParty qp in moonParties) {
            processMoon(div, qp);
        }

        for(QuestingParty qp in landParties) {
		    processLand(div, qp);
        }
	}





}

//TODO once npc update hits can make this more generic. for now though, don't.
class QuestingParty
{
    Player player1;
    Player player2;
    Session session;
    ///will handle setting unavailable, don't need to worry about it modifying the array i'm looping on since it's read only.
    QuestingParty(Session this.session, Player this.player1, Player this.player2) {
        session.removeAvailablePlayer(this.player1);
        session.removeAvailablePlayer(this.player2);
    }
}
