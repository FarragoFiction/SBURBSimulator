import "dart:html";
import "../SBURBSim.dart";



//all available players do this. (so put this quest at the end, right before solving puzzles and dream bs.)
//get quest from either class or aspect array in random tables. if space, only aspect array (frog);

//can get help from another player, different bonuses based on claspect if so.
class DoLandQuest extends Scene{
		List<Player> playerList = [];  //what players are already in the medium when i trigger?
	List<List<Player>> playersPlusHelpers = []; //who is doing a land quest this turn?
	num landLevelNeeded = 12;


	DoLandQuest(Session session): super(session);

	@override
	bool trigger(List<Player> playerList){
		this.playersPlusHelpers = [];
		List<Player> playersAvailableAtStart = session.getReadOnlyAvailablePlayers();
		//don't remove available players from the array you'er looping on, asshole. but ALSO don't allow them to go anyways
		List<Player> alreadyChosenPlayers = new List<Player>();
		//even though using available players in multiple places do NOT use stored  var for second use, because needs to be up to date. removing shit.
    for(Player p in playersAvailableAtStart){
    	if(!alreadyChosenPlayers.contains(p)){
		    List<Player> ph = this.getPlayerPlusHelper(p, session.getReadOnlyAvailablePlayers());
		    if(ph != null){
		    	alreadyChosenPlayers.add(p);
		    	alreadyChosenPlayers.add(ph[1]); //i don't care if it's null, won't effect the contains
			    this.playersPlusHelpers.add(ph);
			    session.removeAvailablePlayer(ph[0]); //this method handles breath/time shit
			    session.removeAvailablePlayer(ph[1]);
		    }
	    }
    }

		return this.playersPlusHelpers.length > 0;
	}
	List<Player> getPlayerPlusHelper(Player p, List<Player> availablePlayers){
		if(p.land == null || p.getStat("power") < 2 || p.grimDark > 3) return null;  //can't do quests at all.
		Player helper = p.findHelper(availablePlayers);
		if(helper != null && helper.grimDark >= 3) helper = null;  //grim dark players aren't going to do quests.
		var playerPlusHelper = [p,helper];

		if((p.aspect == Aspects.BLOOD || p.class_name == SBURBClassManager.PAGE) ){// if page or blood player, can't do it on own.
			if(playerPlusHelper[1] != null){
				if((p.landLevel < this.landLevelNeeded || p.aspect == Aspects.SPACE) || rand.nextDouble() > .5){
					return (playerPlusHelper);
				}

			}
		}else{
			if((p.landLevel < this.landLevelNeeded || p.aspect == Aspects.SPACE) || rand.nextDouble() > .5){
				return (playerPlusHelper);
			}
		}
		return null;
	}
	String findFraymotif(Player player, Player helper){
		Fraymotif f;

		if(player.fraymotifs.length == 0){
			f = this.session.fraymotifCreator.makeFraymotif(player.rand, [player], 1);//shitty intial fraymotif.
			player.fraymotifs.add(f);
			return "The " + player.htmlTitle() + " feels...different. Like they are starting to understand what it MEANS to be a " + player.htmlTitleBasic() +". Huh. What do you think '" + f.name + "' means? ";
		}

		//i expect to do at least 10 land quests, so have a 3/10 chance of getting a fraymotif.
		double randomNumber = rand.nextDouble();
		if(randomNumber > 0.2) return "";

		f = player.getNewFraymotif(helper);
		return this.fraymotifFlavorTextForPlayer(player, f);

	}
	String fraymotifFlavorTextForPlayer(player, fraymotif){
		//fraymotif store names came from me looking up what places carry faygo near me and finding out
		//that i live in the laziest piece of fiction of all time.
		//"Super Low Grocery Outlet" and "Food Depot #27" sound fake as fuck, but also are the only places to carry faygo practically
		List<String> normalWays = ["The " + player.htmlTitle() + " purchases " + fraymotif.name + "from Super Low Fraymotif Outlet like a sensible person. "];
		normalWays.add("The " + player.htmlTitle() + " has finally saved up enough boondollars to buy " + fraymotif.name + "from Fraymotif Depot #27, the ONLY store with1n 413 miles. ");
		if(rand.nextDouble() > 0.5) return rand.pickFrom(normalWays);
		//otherwise do special shit.
		if(player.class_name == SBURBClassManager.THIEF) return "The " + player.htmlTitle() + " blatantly robs the fraymotif store, scoring " + fraymotif.name + ".  I sure hope it's worth the risk of being put in the slammer. ";
		if(player.class_name == SBURBClassManager.ROGUE) return "The " + player.htmlTitle() + " daringly heists fraymotif store, scoring " + fraymotif.name + ".  Nobody will notice it's missing for days. ";
		if(player.class_name == SBURBClassManager.KNIGHT) return "The " + player.htmlTitle() + " vallantly defends the fraymotif store from underlings, scoring " + fraymotif.name + " as a reward. ";
		if(player.class_name == SBURBClassManager.SEER) return "The " + player.htmlTitle() + " is made aware that " + fraymotif.name + " is hidden in a secret location, and claims it. ";
		if(player.class_name == SBURBClassManager.BARD) return "The " + player.htmlTitle() + " just suddenly knows " + fraymotif.name + ".  I sure hope you aren't expecting to find out HOW they learned it. ";
		if(player.class_name == SBURBClassManager.PAGE) return "The " + player.htmlTitle() + " has worked hard and put in the hours and now knows " + fraymotif.name + ".  Sometimes hard work pays off!. ";
		if(player.class_name == SBURBClassManager.SYLPH) return "The " + player.htmlTitle() + " has built up a rapport with the consort running the fraymotif shop. They receive " + fraymotif.name + " on the house. ";
		if(player.class_name == SBURBClassManager.HEIR) return "The " + player.htmlTitle() + " finds out that " + fraymotif.name + " was bequeathed to them by a wealthy consort. Their death will not be in vain!  ";
		if(player.class_name == SBURBClassManager.MAID) return "The " + player.htmlTitle() + " helps the consort that runs the fraymotif shop organize everything.  They are rewarded with " + fraymotif.name + ". ";
		if(player.class_name == SBURBClassManager.PRINCE) return "The " + player.htmlTitle() + " scores " + fraymotif.name + " for a stupidly discounted 'going out of business' price. ";
		if(player.class_name == SBURBClassManager.WITCH) return "The " + player.htmlTitle() + " joins a coven of Secret Wizards to learn " + fraymotif.name + ".   ";
		if(player.class_name == SBURBClassManager.MAGE) return "The " + player.htmlTitle() + " is pretty sure they have figured out the fraymotif system, at least enough to learn " + fraymotif.name + ". ";
		return rand.pickFrom(normalWays);
	}
	@override
	void renderContent(Element div){
		var content = this.content(div);
		//if(simulationMode) return;  will doing things like this speed AB up. might want to refactor gameEntity so only one div redered at fight end and not consantly.
		div.appendHtml("<br> <img src = 'images/sceneIcons/quest_icon.png'>"+content,treeSanitizer: NodeTreeSanitizer.trusted);

	}
	dynamic addImportantEvent(){
			Player current_mvp = findStrongestPlayer(this.session.players);
			return this.session.addImportantEvent(new FrogBreedingNeedsHelp(this.session, current_mvp.getStat("power"),null,null) );
	}

	dynamic calculateClasspectBoost(Player player, Player helper, Player targetPlayer){


		if(helper.aspect == Aspects.HEART && helper.class_name == SBURBClassManager.SYLPH){
			//session.logger.info("Will i heal corruption? grim dark is: ${player.grimDark}");
			//session.logger.info("sylph of heart corruption helping ${this.session.session_id}");
			if(player.grimDark > 1){
				return " The " + helper.htmlTitle() + " heals the " + player.htmlTitle() + "'s broken identity', restoring any holds the broodfester tongues of GrimDarkness had on them and increasing their resistance to future infestations. ";
			}
			return " The " + helper.htmlTitle() + " innoculates the " + player.htmlTitle() + "'s identity' against future attacks of GrimDarkness. ";

		}




		String ret = "";
		////session.logger.info("Debugging: Getting a helper in session ${session.session_id}");
		ret += player.interactionEffect(helper);
		ret += helper.interactionEffect(player);

		if(helper == player){
			player.increaseLandLevel();
			player.increasePower();
			return " Partnering up with your own time clones sure is efficient. ";
		}

		if(player.grimDark>0 && helper.aspect == Aspects.VOID){
			//session.logger.info("void corruption helping ${this.session.session_id}");
			return " The " + helper.htmlTitle() + " seems to commune with the ambiant corruption in the " + player.htmlTitle() + ", preventing it from piling up enough for them to reach the next tier of GrimDarkness.";
		}//todo: tell jr that I dont think this has ever happened, ever.

		//okay, now that i know it's not a time clone, look at my relationship with my helper.
		Relationship r1 = player.getRelationshipWith(helper);
		Relationship r2 = helper.getRelationshipWith(player);

		if(helper.aspect == Aspects.BREATH){
			this.session.addAvailablePlayer(player); //player isn't even involved, at this point. breath friend frees them up
			helper.increasePower();
			player.increaseLandLevel();
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " tells the " + player.htmlTitle() + " that they are going to run on ahead and do some quests on " + player.shortLand() + " on their own. The " + player.htmlTitle() + " is freed up to do other shit, now. " ;
				////session.logger.info("breath player doing quests for a friend: " + this.session.session_id);
			}else{
				ret += " The " + helper.htmlTitle() + " gets annoyed with how slow the " + player.htmlTitle() + " is being and runs ahead to get aaaaaaaall the levels and experience. At least the " + player.htmlTitle() + " has less stuff to do for the their main quests, now. " ;
			//	//session.logger.info("breath player ignoring enemy to get exp: " + this.session.session_id);
			}
		}

		if(helper.aspect == Aspects.BLOOD){
			player.boostAllRelationships();
			player.boostAllRelationshipsWithMe();
			player.addStat("sanity", 1);
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " spends a great deal of time helping the " + player.htmlTitle() + " out with their relationship drama. " ;
			}else{
				ret += " The " + helper.htmlTitle() + " spends a great deal of time lecturing the " + player.htmlTitle() + " about the various ways a player can be triggered into going shithive maggots. " ;
			}
		}

		if (player.aspect == Aspects.MIST && targetPlayer != null){ //Mist players do their quests on every land.
			targetPlayer.increaseLandLevel();
			if(player != targetPlayer) { //no, sorry, you can't be better on your own land then you are everywhere else.
				player.increaseLandLevel();
			}

		}

		if(helper.aspect == Aspects.TIME || helper.aspect == Aspects.LIGHT || helper.aspect == Aspects.HOPE || helper.aspect == Aspects.MIND || helper.class_name == SBURBClassManager.PAGE || helper.class_name == SBURBClassManager.SEER){
			player.increaseLandLevel();
			helper.increasePower();
			if(r2 == null || r2.value > 0){
				ret += " The " + helper.htmlTitle() + " is doing a kickass job of helping the " + player.htmlTitle() + ". " ;
			}else{
				ret += " The " + helper.htmlTitle() + " delights in rubbing how much better they are at the game in the face of the " + player.htmlTitle() + ". " ;
			}
		}

		if(helper.aspect == Aspects.RAGE){
			player.damageAllRelationships();
			player.damageAllRelationshipsWithMe();
			player.addStat("sanity", -10);
			helper.addStat("sanity", -10);
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " spends a great deal of time shit talking about the other players. ";
			}else{
				ret += " The " + helper.htmlTitle() + " spends a great deal of time making the " + player.htmlTitle() + " aware of every bad thing the other players have said behind their back. " ;
			}
		}

		if(helper.aspect == Aspects.DOOM){
			player.increaseLandLevel();
			helper.increaseLandLevel(-1.0);
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " figures the " + player.htmlTitle() + " could make better use of some quest items, so generously donates them to the cause. ";
			}else{
				ret += " The " + helper.htmlTitle() + " condescendingly says that since the " + player.htmlTitle() + "  is so bad at the game, they'll donate some of their quest items to them. ";
			}
		}

		if(helper.class_name == SBURBClassManager.THIEF){
			player.increaseLandLevel(-1.0);
			helper.increaseLandLevel();
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " covertly spends at least half of their time diverting resources to complete their own quests. ";
			}else{
				ret += " The " + helper.htmlTitle() + " blatantly steals resources from the" + player.htmlTitle() + ", saying that THEIR quests are just so much more important. " ;
			}
		}


		return ret;

	}
	String spreadCoruption(Player player1, Player player2){
		bool ret = false;
		if(player2 != null && player2.grimDark>0){
			player1.corruptionLevelOther += 5;
			ret = true;
		}

		if(player2 != null && player1.grimDark>0){
			player2.corruptionLevelOther += 5;
			ret = true;
		}

		if(corruptedOtherLandTitles.indexOf(player1.land1) != -1 || corruptedOtherLandTitles.indexOf(player1.land2) != -1 ){
			player1.corruptionLevelOther += 5;
			ret = true;
			if(player2 != null) player2.corruptionLevelOther += 5;
		}

		if(player1.object_to_prototype.corrupted && !player1.sprite.dead){
		//	//session.logger.info("corrupt sprite: " + this.session.session_id);
			player1.corruptionLevelOther += 5;
			ret = true;
			if(player2 != null) player2.corruptionLevelOther += 5;
		}

		if(ret){
			////session.logger.info("Spreading corruptin in: " + this.session.session_id);
			return "The corruption is spreading.";
		}
		return "";

	}
	String spriteContent(Player player){
		if(player.sprite.dead) return "";//nothing to see here.
		String ret = player.sprite.htmlTitle();
		if(player.sprite.corrupted){
			player.increaseLandLevel(-0.75);
		}else if(player.sprite.helpfulness > 0){
			////session.logger.info("good sprite: " + this.session.session_id);
			player.increaseLandLevel();
		}else if(player.sprite.helpfulness < 0){
			////session.logger.info("bad sprite: " + this.session.session_id);
			player.increaseLandLevel(-0.5);
			player.addStat("sanity", -0.1);
		}else{
			////session.logger.info("normal sprite: " + this.session.session_id);
			player.increaseLandLevel(0.5);
		}
		ret +=  " " + player.sprite.helpPhrase + " "; //best idea.
		return ret;
	}
	String contentForPlayer(Player player, Player helper){
		var targetPlayer = rand.pickFrom(session.getReadOnlyAvailablePlayers());
		String ret = "<Br><Br> ";
		ret += "The " + player.htmlTitle()  ;

		player.increasePower();
		player.increaseLandLevel();
		if(helper != null){
			ret += " and the " + helper.htmlTitle() + " do " ;
			helper.increasePower();
			player.increaseLandLevel();
		}else{
			ret += " does";
		}
		if(player.aspect == Aspects.MIST && targetPlayer != null) {
			if (rand.nextDouble() > 0.8) {
				ret += " quests at " + targetPlayer.shortLand();
			} else {
				ret += " quests in the " + targetPlayer.land;
			}
			ret += ", " + targetPlayer.getRandomQuest() + ". The " + player.htmlTitleBasic() + " makes good use of their ability to imitate the" + targetPlayer.htmlTitleBasic() + ". ";
			if (helper != null) {
				ret += this.calculateClasspectBoost(player, helper, targetPlayer);
			}
			print("Mist player Quests elsewhere");
		}else {
			if (rand.nextDouble() > 0.8) {
				ret += " quests at " + player.shortLand();
			} else {
				ret += " quests in the " + player.land;
			}

		}

		if(helper != null && player  != helper ){
			Relationship r1 = player.getRelationshipWith(helper);
			Relationship r2 = helper.getRelationshipWith(player);
			ret += Relationship.getRelationshipFlavorText(r1,r2, player, helper);
		}
		ret += this.findFraymotif(player, helper);
		ret += this.spriteContent(player);
		ret += this.spreadCoruption(player, helper);
		return ret;
	}
	dynamic content(div){
		String ret = "";
		for(num i = 0; i<this.playersPlusHelpers.length; i++){
			var player = this.playersPlusHelpers[i][0];

			var living = findLivingPlayers(this.session.players);
			var dead = findDeadPlayers(this.session.players);
			if(living.length == 1 && dead.length > 2){
				//session.logger.info("AB: SWEET BIKE STUNTS, BRO: ${this.session.session_id}");
				String realSelf = "";
				if(!player.isDreamSelf && !player.godTier){
					//session.logger.info("AB:Real self stunting in: ${this.session.session_id}");
					realSelf =  "You are duly impressed that they are not a poser who does dreamself stunting.  Realself stunting 5ever, bro.";
				}
				return "The " + player.htmlTitle()  + " is " + rand.pickFrom(bike_quests) + ". " + realSelf;
			}

			////session.logger.info("doing land quests at: " + player.land);
			var helper = this.playersPlusHelpers[i][1]; //might be null
			if(player.aspect == Aspects.SPACE && helper == null){

				var alt = this.addImportantEvent();
				if(alt != null && alt.alternateScene(div)){
					//do nothing, alternate scene handles it
				}else{
					ret += this.contentForPlayer(player, helper);
				}
			}else{
				ret += this.contentForPlayer(player, helper);
			}
			if(player.denizen_index == 3 && !player.denizenDefeated ){
				ret += " They finally finished off all the main quests on " + player.land + ". They should be ready to face their Denizen. ";
			}
		}
		return ret;
	}


}
