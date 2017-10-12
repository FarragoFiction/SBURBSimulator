import "dart:html";
import '../Rendering/effects/sbahj.dart';
import '../Rendering/text/wordgif.dart';
import "../SBURBSim.dart";


//x times corpse smooch combo.
class CorpseSmooch extends Scene {

	List<dynamic> dreamersToRevive = [];
	num combo = 0;	


	CorpseSmooch(Session session): super(session);

	@override
	bool trigger(List<Player> playerList){
		////session.logger.info('checking corpse smooch');
		this.playerList = playerList;
		this.dreamersToRevive = [];
		//all dead players who aren't god tier and are destined to be god tier god tier now.
		var deadPlayers = findDeadPlayers(playerList);
		for(num i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			//only get one shot at this. if you're a jerk, no luck.
			//if(p.dreamSelf){ //no longer only dream self cause this generates important events for ANY death that is left unfixed.
			this.dreamersToRevive.add(p);
			//}
		}
		//corspses can't smooch themselves.
		var living = findLivingPlayers(this.session.players);
		////session.logger.info(this.dreamersToRevive.length + " vs "  + playerList.length);
		return this.dreamersToRevive.length > 0 && living.length>0;

	}
	@override
	void renderContent(Element div){
		this.dreamersToRevive;
		//////session.logger.info(this.dreamersToRevive);
		this.combo = 0;
		div.appendHtml("<br>"+this.contentForRender(div),treeSanitizer: NodeTreeSanitizer.trusted);

		if(this.combo>1){
			/*var divID = (div.id) + "_" + "combo";
			String canvasHTML = "<br><canvas id='canvasCombo" + divID+"' width='$canvasWidth' height='${canvasHeight/3}'>  </canvas>";
			appendHtml(div, canvasHTML);
			var canvasDiv = querySelector("#canvasCombo"+ divID);
			this.drawCombo(canvasDiv, this.combo);*/
			if (Drawing.checkSimMode() == true) {
				return;
			}
			if (curSessionGlobalVar.sbahj) {
				div.append(SBAHJ.sbahjText("${this.combo}x COPRSSMOOCH COMBOB${"!!" * this.combo}", 50, SBAHJGradients.horizon));
			} else {
				Colour col = new Colour(255, 0, 0);
				div.append(WordGif.dropText("${this.combo}x CORPSESMOOCH COMBO${"!" * this.combo}", 5, <Colour>[col, col * 0.9], <Colour>[col * 0.5, col * 0.4], 1, 1, 5));
			}
		}
	}

	void makeDead(Player d){
		////session.logger.info("make dead " + d.title())
		d.dreamSelf = false;
		d.dead = true;
	}

	@deprecated
	void drawCombo(canvas, comboNum){
		Drawing.drawComboText(canvas, comboNum);
	}
	dynamic ignoreEnemies(player, royalty){
		if(royalty == null){
			return null;
		}
		var r = royalty.getRelationshipWith(player);
		if(r == null || (r !=null && r.value < 0)){
			return null;
		}
		return royalty;
	}
	dynamic getRoyalty(Player d){
		List<Player> availablePlayers = session.getReadOnlyAvailablePlayers();
		Player royalty = d.getWhoLikesMeBestFromList(findLivingPlayers(availablePlayers));
		royalty = this.ignoreEnemies(d, royalty);
		if(royalty == null){
			//okay, princes are traditional...
			royalty = findClassPlayer(findLivingPlayers(availablePlayers), SBURBClassManager.PRINCE);
			if(royalty != null && royalty.grimDark  > 0){
				royalty = null; //grim dark won't corpse smooch unless they actual want to.
			}
		}
		royalty = this.ignoreEnemies(d, royalty);
		//from here on out, prefer to god tier than to be corpse smooched.
		if(royalty == null){
			//okay, anybody free?
			royalty = rand.pickFrom(findLivingPlayers(availablePlayers));
			if(royalty != null && royalty.grimDark > 0){
				royalty = null; //grim dark won't corpse smooch unless they actual want to.
			}
		}
		royalty = this.ignoreEnemies(d, royalty);
		//shit, maybe your best friend can drop what they are doing to save your ass?
		if(royalty == null){
			royalty = d.getWhoLikesMeBestFromList(findLivingPlayers(this.playerList));
		}
		royalty = this.ignoreEnemies(d, royalty);
		//is ANYBODY even alive out there????
		if(royalty == null){
			royalty = rand.pickFrom(findLivingPlayers(this.playerList));
			if(royalty != null && royalty.grimDark > 0){
				royalty = null; //grim dark won't corpse smooch unless they actual want to.
			}
		}
		royalty = this.ignoreEnemies(d, royalty);
		if(royalty == null && d.godDestiny){
			////session.logger.info("I couldn't find royalty and also could god tier. " + this.session.session_id);
		}
		return royalty;
	}
	void renderForPlayer(Element div, Player deadPlayer, Player royalty){
		String ret = "";
		//Player royalty = this.getRoyalty(deadPlayer); //don't reget royalty not garanteed to be samebecause interaction effects
		if(royalty != null){

			String divID = (div.id) + "_${deadPlayer.id}";
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			ret += deadPlayer.interactionEffect(royalty);
			ret += royalty.interactionEffect(deadPlayer);
			appendHtml(div, ret + canvasHTML);
			Element canvasDiv = querySelector("#canvas"+ divID);
			Drawing.drawCorpseSmooch(canvasDiv, deadPlayer, royalty);
		}else{
			//session.logger.info("AB: dream self dies from no corpse smooch: " + this.session.session_id.toString());
			deadPlayer.isDreamSelf = true;
			deadPlayer.causeOfDeath = "sympathetic wounds after real self died unsmooched";
			this.makeDead(deadPlayer); //dream self dies, too
		}

	}
	dynamic contentForRender(Element div){
		String ret = "";
		this.combo = 0;
		for(num i = 0; i<this.dreamersToRevive.length; i++){
			Player d = this.dreamersToRevive[i];
			//have best friend mac on you.
			if(d.dreamSelf == true){
				Player royalty = this.getRoyalty(d);
				if(royalty != null){
					royalty.addStat(Stats.SANITY, -10);
					ret += " The " + royalty.htmlTitle() + ", as a member of the royalty of ${royalty.moon}, administers the universal remedy for the unawakened ";
					ret += " to the " + d.htmlTitle() + ". Their dream self takes over on ${d.moon}. ";
					if(d.aspect == Aspects.DOOM) ret += "The prophecy is fulfilled. ";
					this.renderForPlayer(div, this.dreamersToRevive[i], royalty);
					session.removeAvailablePlayer(royalty);
					//this.makeAlive(d);
					this.combo ++;
				}else{
					////session.logger.info("Adding important event god tier for: " + d.title())
					var alt = this.addImportantEvent(d);
					////session.logger.info("alt is: " +alt);
					if(alt != null&& alt.alternateScene(div)){
						//do nothing here.
					}else{
						ret += "<Br><Br><img src = 'images/sceneIcons/death_icon.png'>" + d.htmlTitle() + "'s waits patiently for the kiss of life. But nobody came. ";
						ret += " Their dream self dies as well. ";
						this.makeDead(d);
					}
				}
			}else if(d.isDreamSelf == true && d.godDestiny == false && d.godTier == false && d.dead == true){
				var alt = this.addImportantEvent(d);
					if(alt != null && alt.alternateScene(div)){
					}else{
						//don't even mention corpse smooching for dream selves. but them perma-dying is an event.
					}
			}
		}
		if(this.combo > 1){
			ret += "${this.combo}X CORPSEMOOCH COMBO!!!";
		}
		//x times corpse smooch combo
		return ret;
	}
	ImportantEvent addImportantEvent(Player player){
		////session.logger.info("adding important event from corpse smooch");
		Player current_mvp = findStrongestPlayer(this.session.players);
		//only one alternate event can happen at a time. if one gets replaced, return

		if(player.godDestiny == false && player.godTier == false){//could god tier, but fate wn't let them
			return this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.getStat(Stats.POWER),player) );
		}else if(this.session.reckoningStarted == true && player.godTier == false) { //if the reckoning started, they couldn't god tier.
			return this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.getStat(Stats.POWER),player) );
		}
		return null;
	}



}
