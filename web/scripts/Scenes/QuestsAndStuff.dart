import "dart:html";
import "../SBURBSim.dart";
import 'dart:math' as Math;

///in what way is this supposed to be an RPG if you can do quests and stuff?
class QuestsAndStuff extends Scene {
	bool canRepeat = true;
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
            if(session.isPlayerAvailable(p) && !p.dead && p.land != null && !p.land.noMoreQuests){
                QuestingParty party = createQuestingParty(p);
                if(party != null) landParties.add(party);
            }
        }
    }


    void allocateMoonQuests() {
        //you need to be alive. (available doesn't matter, you can dream after doing something. consider it a free action, otherwise they won't get into the medium).
        for(Player p in session.players) {
            if(!p.dead && p.moon != null && (session.rand.nextDouble()*100) < p.moonChance) {
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
        GameEntity helper = player.findHelper(session.getReadOnlyAvailablePlayers());
        //pages REQUIRE a helper, so if helper is null, return null.
        //if either player is grim dark >= 3, then no party. assume grim dark friend actively encourages peoplel they hang out with to not quest
        if(player.class_name == SBURBClassManager.PAGE && helper == null) return null;
        if(player.grimDark >=3 || (helper != null && (helper as Player).grimDark >=3)) return null;
        //it's okay if helper is null.
        //if(session.rand.nextBool()) helper = null; //don't ALWAYS have friends, yo

        if(helper == null && !player.sprite.dead && session.rand.nextDouble() > .75) {
            helper = player.sprite;
        }
        return new QuestingParty(session, player, helper);
    }

	void processMoon(Element div, QuestingParty questingParty) {
	    Player player = questingParty.player1;
		player.moon.initQuest([player]);
		String inEarly = "";
		if(player.sprite.name == "sprite") inEarly = "The ${player.htmlTitle()} has awoken early. ";
		String html = "${player.moon.getChapter()} ${inEarly}  ${player.moon.randomFlavorText(session.rand, player)} ";
		appendHtml(div, html);
		//doQuests will append itself.
		player.moon.doQuest(div, player, null);
	}

    void processLand(Element div, QuestingParty questingParty) {
        Player player = questingParty.player1;
        GameEntity helper = questingParty.helper;
        player.land.initQuest([player, helper]);
        String helperText = corruptionIsSpreading(questingParty);
        if(helper != null) {
            if(helper is Sprite) {
                helperText = "$helperText ${helper.htmlTitle()} ${(helper as Sprite).helpPhrase}<br><br>";
            }else {
                helperText = "$helperText The ${helper.htmlTitle()} is helping where they can. ";
            }
            helperText = "$helperText ${player.interactionEffect(helper)} "; //players always have an effect.
            if(helper is Player) helperText = "$helperText ${helper.interactionEffect(player)} <br><Br>"; //helpers do not.

        }
        String html = "${player.land.getChapter()}The ${player.htmlTitle()} is in the ${player.land.name}.  ${player.land.randomFlavorText(session.rand, player)} $helperText";
        appendHtml(div, html);
        bool savedLevel = player.land.firstCompleted;
        player.land.doQuest(div, player, helper);

        if(savedLevel != player.land.firstCompleted) {
            appendHtml(div, "<br><br>The ${player.htmlTitleBasicNoTip()}'s house has been built up enough to let them start visiting other lands. ");
        }

    }

    String corruptionIsSpreading(QuestingParty questingParty) {
	    Player player = questingParty.player1;
	    GameEntity helper = questingParty.helper;
	    bool playerCorrupted = false;
	    bool helperCorrupted = false;
	    if(player.land.corrupted || (helper != null && helper.corrupted)) {
            playerCorrupted = true;
            helperCorrupted = true;
        }
	    if(helper != null ) {
            if(helper is Player) {
                Player player2 = helper as Player;
                if(player2.grimDark > 0) playerCorrupted = true;
                if(player.grimDark > 0) helperCorrupted = true;

                if(helperCorrupted) player2.corruptionLevelOther += 5;
            }
        }

        if(playerCorrupted) player.corruptionLevelOther += 5;
	    if(playerCorrupted || helperCorrupted) {
	        session.logger.info("The corruption is spreading.");
            return "The corruption is spreading.";
        }
	    return "";
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
    GameEntity helper;
    Session session;
    ///will handle setting unavailable, don't need to worry about it modifying the array i'm looping on since it's read only.
    QuestingParty(Session this.session, Player this.player1, GameEntity this.helper) {
        session.removeAvailablePlayer(this.player1);
        session.removeAvailablePlayer(this.helper);
    }
}
