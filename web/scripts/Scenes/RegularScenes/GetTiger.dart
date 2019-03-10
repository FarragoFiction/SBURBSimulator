import "dart:html";
import "../../SBURBSim.dart";


//known to lesser mortals as God Tier
class GetTiger extends Scene{

	List<Player> deadPlayersToGodTier = <Player>[];	//doesn't matter if dream self 'cause sacrificial slab.
	


	GetTiger(Session session): super(session);

	@override
	bool trigger(List<Player> playerList){
		this.playerList = playerList;
		this.deadPlayersToGodTier = <Player>[];
		if(this.session.reckoningStarted || this.session.didReckoning){
			return false; //can't god tier if you are definitely on skaia. (makes king fight too easy)
		}
		//all dead players who aren't god tier and are destined to be god tier god tier now.
		var deadPlayers = findDeadPlayers(playerList);
		for(num i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			if(!p.godTier && p.godDestiny){
				this.deadPlayersToGodTier.add(p);
			}
		}
		return this.deadPlayersToGodTier.length > 0;

	}
	@override
	void renderContent(Element div){
		var text = this.content();

		num repeatTime = 1000;
		var divID = (div.id) + "_tiger";
		var ch = canvasHeight;
		if(this.deadPlayersToGodTier.length > 6){
			ch = canvasHeight*2;
		}
		var players = this.deadPlayersToGodTier;
		if(!players[0].dead){
			appendHtml(div,"<br><img src = 'images/sceneIcons/rainbow_ascend_animated.gif'> " + text);

			CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
			div.append(canvasDiv);

			Drawing.drawGetTiger(canvasDiv, players); //only draw revivial if it actually happened.
		}


	}


	String content(){

		////session.logger.info("trying to get tiger for: " + getPlayersTitles(this.deadPlayersToGodTier))
		String ret = "" +getPlayersTitles(this.deadPlayersToGodTier) + " was always destined to take a Legendary Nap, and upon waking, become a God Tier. ";

		var withd = findPlayersWithDreamSelves(this.deadPlayersToGodTier);

		var withoutd = findPlayersWithoutDreamSelves(this.deadPlayersToGodTier);

		if(withd != null && partyRollForLuck(withd) > 25){  //MOST players in canon go god tier via sacrificial slab.
			for(num i = 0; i< withd.length; i++){
				var p = withd[i];
				p.setStat(Stats.CURRENT_HEALTH, p.getStat(Stats.HEALTH));
				//////session.logger.info("Quest bed: " + this.session.session_id);
				if(p.hasLand()) {
					ret += " Upon being laid to rest on their QUEST BED on the " + p.land.name + ", the " + p.htmlTitle() + "'s body glows, and rises Skaiaward. ";
					ret += "On ${p.moonName}, their dream self takes over and gets a sweet new outfit to boot.  ";
				}else if(p.hasMoon()) {
					ret += " You...aren't really sure how a real self made it to the SACRIFICIAL SLAB on ${p.moonName}, but there it is.  ";
					ret += "The " + p.htmlTitle() + " glows and ascends to the God Tiers with a sweet new outfit.  ";
				}else {
					p.godDestiny = false; //sorry, no land, no moon, you're fucked.
				}

				Fraymotif f = this.session.fraymotifCreator.makeFraymotif(rand, [p], 3);//first god tier fraymotif
				p.fraymotifs.add(f);
				ret += " They learn " + f.name + "." ;
				this.session.stats.questBed = true;
			}
		}else if(withd != null && withd.length > 0){
			session.logger.debug("We COULD have been on my quest bed, but random chance said no. " );
			return "";
		}

		if(withoutd != null){
			for(num i = 0; i< withoutd.length; i++){
				var p = withoutd[i];
				if(p.isDreamSelf && p.moon != null){
					p.setStat(Stats.CURRENT_HEALTH, p.getStat(Stats.HEALTH));
					removeFromArray(this.session.afterLife.findClosesToRealSelf(p), this.session.afterLife.ghosts);
					//////session.logger.info("sacrificial slab: " + this.session.session_id);
					ret += " Upon a wacky series of events leaving their corpse on their SACRIFICIAL SLAB on ${p.moonName}, the " + p.htmlTitle() + " glows and ascends to the God Tiers with a sweet new outfit.";
					this.session.stats.sacrificialSlab = true;
					Fraymotif f = this.session.fraymotifCreator.makeFraymotif(rand, [p], 3);//first god tier fraymotif
					p.fraymotifs.add(f);
					ret += " They learn " + f.name + "." ;
				}else if(p.moon == null) {
					p.godDestiny = false; //sorry, no moon means you're fucked.
				}

			}
			////session.logger.info("no dream self so slab");
		}
		this.session.stats.godTier = true;
		ret += " They are now extremely powerful. ";
		
		

		if(findClassPlayer(this.deadPlayersToGodTier, SBURBClassManager.PAGE) != null){
			ret += " Everyone fails to ignore the Page's outfit. ";
		}



		for(num i = 0; i<this.deadPlayersToGodTier.length; i++){
			Player p = this.deadPlayersToGodTier[i];
			if(p.godDestiny) p.makeGodTier(); //god destiny can be set to false if you didn't have anywhere to god tier
			if(p.aspect == Aspects.SAUCE) {
				ret += "<br><Br>...  Huh. What... what even happened there? Is that a SAUCE player? WTF? That's not canon... Fucking Shogun...";
			}
		}
		return ret;
	}

}
