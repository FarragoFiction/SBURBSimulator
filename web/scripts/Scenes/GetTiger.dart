import "dart:html";
import "../SBURBSim.dart";


//known to lesser mortals as God Tier
class GetTiger extends Scene{

	List<dynamic> deadPlayersToGodTier = [];	//doesn't matter if dream self 'cause sacrificial slab.
	


	GetTiger(Session session): super(session);

	@override
	bool trigger(List<Player> playerList){
		this.playerList = playerList;
		this.deadPlayersToGodTier = [];
		if(this.session.reckoningStarted){
			return false; //can't god tier if you are definitely on skaia. (makes king fight too easy)
		}
		//all dead players who aren't god tier and are destined to be god tier god tier now.
		var deadPlayers = findDeadPlayers(playerList);
		for(num i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			if(!p.godTier && p.godDestiny && (p.isDreamSelf || p.dreamSelf)){
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
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height='$ch'>  </canvas>";
			appendHtml(div,canvasHTML);
			//different format for canvas code
			Element canvasDiv = querySelector("#canvas"+ divID);

			drawGetTiger(canvasDiv, players); //only draw revivial if it actually happened.
		}


	}
	String content(){
		//print("trying to get tiger for: " + getPlayersTitles(this.deadPlayersToGodTier))
		String ret = "" +getPlayersTitles(this.deadPlayersToGodTier) + " was always destined to take a Legendary Nap, and upon waking, become a God Tier. ";

		var withd = findPlayersWithDreamSelves(this.deadPlayersToGodTier);
		var withoutd = findPlayersWithoutDreamSelves(this.deadPlayersToGodTier);

		if(withd != null && partyRollForLuck(withd) > 50){  //MOST players in canon go god tier via sacrificial slab.
			for(num i = 0; i< withd.length; i++){
				var p = withd[i];
				p.setStat("currentHP", p.getStat("hp"));
				////print("Quest bed: " + this.session.session_id);
				ret += " Upon being laid to rest on their QUEST BED on the " + p.land + ", the " + p.htmlTitle() + "'s body glows, and rises Skaiaward. ";
				ret +="On " + p.moon + ", their dream self takes over and gets a sweet new outfit to boot.  ";
				Fraymotif f = this.session.fraymotifCreator.makeFraymotif(rand, [p], 3);//first god tier fraymotif
				p.fraymotifs.add(f);
				ret += " They learn " + f.name + "." ;
				this.session.questBed = true;
			}
		}else if(withd != null && withd.length > 0){
			//print("We COULD have been on my quest bed, but random chance said no. " + getPlayersTitles(withd))
			return "";
		}

		if(withoutd != null){
			for(num i = 0; i< withoutd.length; i++){
				var p = withoutd[i];
				if(p.isDreamSelf){
					p.setStat("currentHP", p.getStat("hp"));
					removeFromArray(this.session.afterLife.findClosesToRealSelf(p), this.session.afterLife.ghosts);
					////print("sacrificial slab: " + this.session.session_id);
					ret += " Upon a wacky series of events leaving their corpse on their SACRIFICIAL SLAB on " + p.moon + ", the " + p.htmlTitle() + " glows and ascends to the God Tiers with a sweet new outfit.";
					this.session.sacrificialSlab = true;
					Fraymotif f = this.session.fraymotifCreator.makeFraymotif(rand, [p], 3);//first god tier fraymotif
					p.fraymotifs.add(f);
					ret += " They learn " + f.name + "." ;
				}

			}
			//print("no dream self so slab");
		}
		this.session.godTier = true;
		ret += " They are now extremely powerful. ";
		
		

		if(findClassPlayer(this.deadPlayersToGodTier, "Page") != null){
			ret += " Everyone fails to ignore the Page's outfit. ";
		}

		for(num i = 0; i<this.deadPlayersToGodTier.length; i++){
			var p = this.deadPlayersToGodTier[i];
			p.makeGodTier();
		}
		return ret;
	}

}
