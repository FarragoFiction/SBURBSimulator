import "dart:html";
import "../../SBURBSim.dart";
import 'dart:math' as Math;

///in what way is this supposed to be an RPG if you can do quests and stuff?
class QuestsAndStuff extends Scene {
	bool canRepeat = true;
	List<QuestingParty> landParties = new List<QuestingParty>();
    List<QuestingParty> moonParties = new List<QuestingParty>();
    List<QuestingParty> skaiaParties = new List<QuestingParty>();
	QuestsAndStuff(Session session): super(session);


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
      allocateSkaiaQuests();
      return (landParties.isNotEmpty || moonParties.isNotEmpty || skaiaParties.isNotEmpty);
	}

    //you need to be available, you need to be alive, you need to have quests remaining on your land.
    void allocateLandQuests() {
        //random players get to go first
        List<Player> avail = shuffle(session.rand, session.getReadOnlyAvailablePlayers());
        for(Player p in avail) {
            if(session.isPlayerAvailable(p) && !p.dead && p.land != null && !p.land.noMoreQuests && !p.land.dead){
               // session.logger.info("making a questing party for ${p}");
                QuestingParty party = createQuestingParty(p);
                if(party != null) landParties.add(party);
            }else {
               // session.logger.info("can't make a questing party for ${p}, their land is ${p.land}, it has no more quests ${p.land.noMoreQuests} and the land is dead ${p.land.dead} they are available ${session.isPlayerAvailable(p)}");
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
                p.moonChance = Math.min(p.moonChance, 10.0);
            }else {
                p.moonChance += 5; //fiddle with this to make moon quests more or less spammy
            }
        }
	}

    void allocateSkaiaQuests() {
        List<Player> avail = shuffle(session.rand, session.getReadOnlyAvailablePlayers());
	   for(Player p in avail) {
            if((session.isPlayerAvailable(p) && !p.dead) && (p.land == null || p.canSkaia || p.land.dead)) {
                if(p.land != null && p.land.noMoreQuests) {
                    if(session.rand.nextDouble() > .6) { //small chance of doing skaia before land if you can.
                        skaiaParties.add(new QuestingParty(session, p, null));
                    }
                }else { //100% chance besides moon.
                    skaiaParties.add(new QuestingParty(session, p, null));
                }
            }
       }
    }


    QuestingParty createQuestingParty(Player player) {

        GameEntity helper;

        //sprites are for early game
        if(player.land.firstCompleted && !player.sprite.dead && session.rand.nextDouble() > .5) {
            helper = player.sprite;
        }


        if(helper == null && player.companionsCopy.isNotEmpty) {
            List<GameEntity> choices = findLiving(player.companionsCopy);
            helper = rand.pickFrom(choices);
        }


        if(helper == null || session.rand.nextDouble() > 0.5) {
            GameEntity playerHelper = player.findHelper(
                session.getReadOnlyAvailablePlayers());
            //pages REQUIRE a helper, so if helper is null, return null.
            //if either player is grim dark >= 3, then no party. assume grim dark friend actively encourages peoplel they hang out with to not quest

            //you aren't that interested in land quests any more, unless you have a friend dragging you along
            if (player.grimDark >= 3 ||
                (playerHelper != null && (playerHelper as Player).grimDark >= 3))
                return null;
            if(playerHelper != null) {
                helper = playerHelper;
            }
        }

        //if you're a page and you can't find ANY help, just quit while you're ahead
        if (player.class_name == SBURBClassManager.PAGE && helper == null)
            return null;


        return new QuestingParty(session, player, helper);
    }

	void processMoon(Element div, QuestingParty questingParty) {
	    Player player = questingParty.player1;
	    //&& (player.moon == session.prospit || player.moon == session.derse) && player.dreamSelf
	    if(player.moon != null && !player.moon.dead && (player.moon == session.prospit || player.moon == session.derse) && player.dreamSelf) {
            player.moon.initQuest([player]);
            String inEarly = "";
            if (player.sprite.name == "sprite") inEarly = "The ${player.htmlTitle()} has awoken early. ";
            String html = "${player.moon.getChapter()} ${inEarly} The ${player.htmlTitleWithTip()} is dreaming.  ${player.moon.randomFlavorText(session.rand, player)} ";
            appendHtml(div, html);
            //doQuests will append itself.
            player.moon.doQuest(div, player, null);
        }else {
            session.furthestRing.initQuest([player]);
            String inEarly = "";
            if (player.sprite.name == "sprite") inEarly = "The ${player.htmlTitle()} has awoken early. ";
            String html = "${session.furthestRing.getChapter()} ${inEarly} The ${player.htmlTitleWithTip()} is dreaming.  ${session.furthestRing.randomFlavorText(session.rand, player)} ";
            appendHtml(div, html);
            //doQuests will append itself.
            session.furthestRing.doQuest(div, player, null);
        }
	}

    void processSkaia(Element div, QuestingParty questingParty) {
        session.numberPlayersOnBattlefield ++;
        Player player = questingParty.player1;
        session.battlefield.initQuest([player]);
        String html = "${session.battlefield.getChapter()} The ${player.htmlTitleWithTip()} wanders the battlefield.   ${session.battlefield.randomFlavorText(session.rand, player)} ";
        appendHtml(div, html);
        //doQuests will append itself.
        session.battlefield.doQuest(div, player, null);
    }

    void processLand(Element div, QuestingParty questingParty) {
        Player player = questingParty.player1;

        GameEntity helper = questingParty.helper;
        player.land.initQuest([player, helper]);
        String helperText = corruptionIsSpreading(questingParty);
        if(helper != null) {
            String helperName = "${helper.htmlTitle()} ${helper == player?"(Past or Future???)":""}";

            if(helper is Sprite) {
                helperText = "$helperText ${helperName} ${(helper as Sprite).helpPhrase}<br><br>";
            }else if(helper is Consort){
                //session.logger.info("AB: consort helper.");
                helperText = "$helperText The ${helperName} is ${(helper as Consort).sound}ing. It's somehow helpful. ";
            }else if(helper is Leprechaun){
                //session.logger.info("AB: leprechaun helper.");
                helperText = "$helperText The ${helperName} is using Aspect powers in appropriate ways to clear the lands challenges for their Lord. ";
            }else if(helper is Player && (helper as Player).robot){
                //session.logger.info("AB: robo helper.");
                helperText = "$helperText The ${helperName} is helping way more than an organic would be able to. ";
            }else {
                helperText = "$helperText The $helperName is helping where they can. ";
            }
            helperText = "$helperText ${player.interactionEffect(helper)} "; //players always have an effect.
            if(helper == player && player.aspect != Aspects.TIME) session.logger.info("AB: non time player is their own helper: $helperText ");
            if(helper is Player) helperText = "$helperText ${helper.interactionEffect(player)} <br><Br>"; //helpers do not.

        }
        String html = player.land.getLandText(player, helperText);
        appendHtml(div, html);
        bool savedLevel = player.land.firstCompleted;
        player.land.doQuest(div, player, helper);
        if(player.land.noMoreQuests) player.canSkaia = true;

        if(savedLevel != player.land.firstCompleted) {
            appendHtml(div, "<br><br>The ${player.htmlTitleBasicNoTip()}'s house has been built up enough to let them start visiting other lands. ");
        }

        if(player.aspect == Aspects.SPACE && getParameterByName("spacePlayers") == "screwed") {
            //i've already killed sextellions, may as well do this,too, wait, let me go find out if shogun wants dibs
            //yup, he wants dibs. I can't keep doing villanous things if I'm supposed to be the 'good guy' after all.
            DivElement joke = new DivElement();
            joke.setInnerHtml("<br>Uh. What. God dammit Shogun, why did you blow that space player's planet up? Jesus fuck, no they did NOT 'steal your palette' they had it first! Ugh. Why would you even WANT an unfertilized Skaia??? Whatever. How are they supposed to win now, dunkass???");
            session.mutator.metaHandler.initalizePlayers(session, false);
            div.append(joke);
            div.append(player.land.planetsplode(session.mutator.metaHandler.feudalUltimatum));
        }

    }

    String corruptionIsSpreading(QuestingParty questingParty) {
	    Player player = questingParty.player1;
	    GameEntity helper = questingParty.helper;
	    bool playerCorrupted = false;
	    bool helperCorrupted = false;
	    if(player.land.corrupted || (helper != null && helper.corrupted)) {
	        //;
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
	        //session.logger.info("The corruption is spreading.");
            return "The corruption is spreading.";
        }
	    return "";
    }



	@override
	void renderContent(Element div){

		for(QuestingParty qp in moonParties) {
            processMoon(div, qp);
        }

        for(QuestingParty qp in skaiaParties) {
            processSkaia(div, qp);
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
