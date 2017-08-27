import "dart:html";
import '../Rendering/sbahj.dart';
import '../Rendering/wordgif.dart';
import "../SBURBSim.dart";


//x times corpse smooch combo.
class CorpseSmooch extends Scene {

	List<dynamic> dreamersToRevive = [];
	num combo = 0;	


	CorpseSmooch(Session session): super(session);

	@override
	bool trigger(List<Player> playerList){
		//print('checking corpse smooch');
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
		//print(this.dreamersToRevive.length + " vs "  + playerList.length);
		return this.dreamersToRevive.length > 0 && living.length>0;

	}
	@override
	void renderContent(Element div){
		this.dreamersToRevive;
		////print(this.dreamersToRevive);
		this.combo = 0;
		div.appendHtml("<br>"+this.contentForRender(div),treeSanitizer: NodeTreeSanitizer.trusted);

		if(this.combo>1){
			/*var divID = (div.id) + "_" + "combo";
			String canvasHTML = "<br><canvas id='canvasCombo" + divID+"' width='$canvasWidth' height='${canvasHeight/3}'>  </canvas>";
			appendHtml(div, canvasHTML);
			var canvasDiv = querySelector("#canvasCombo"+ divID);
			this.drawCombo(canvasDiv, this.combo);*/
			if (curSessionGlobalVar.sbahj) {
				div.append(SBAHJ.sbahjText("${this.combo}x COPRSSMOOCH COMBOB${"!!" * this.combo}", 50, SBAHJGradients.horizon));
			} else {
				Colour col = new Colour(255, 0, 0);
				div.append(WordGif.dropText("${this.combo}x CORPSESMOOCH COMBO${"!" * this.combo}", 5, <Colour>[col, col * 0.9], <Colour>[col * 0.5, col * 0.4], 1, 1, 5));
			}
		}
	}
	void makeAlive(Player d){
		//foundRareSession(div, "A player was corpse smooched alive.");
		d.dreamSelf = false; //only one self now.
		d.isDreamSelf = true;
		d.makeAlive();
	}
	void makeDead(Player d){
		//print("make dead " + d.title())
		d.dreamSelf = false;
		d.dead = true;
	}
	void drawCorpseSmooch(CanvasElement canvas, Player dead_player, Player royalty, repeatTime){
		var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
		Drawing.drawSprite(pSpriteBuffer,royalty);

		dead_player.dead = true;
		dead_player.isDreamSelf = false;  //temporarily show non dream version
		var dSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
		Drawing.drawSpriteFromScratch(dSpriteBuffer,dead_player);

		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0);
		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,200,0);

		var moonBuffer = Drawing.getBufferCanvas(querySelector("#canvas_template"));
		Drawing.drawMoon(moonBuffer, dead_player);
		this.makeAlive(dead_player);
		Drawing.drawSprite(moonBuffer,dead_player);
		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, moonBuffer,600,0);
		//dead_player.renderSelf();
		//this.makeAlive(dead_player); //make SURE the player is alive after smooches.

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
		Player royalty = d.getWhoLikesMeBestFromList(findLivingPlayers(this.session.availablePlayers));
		royalty = this.ignoreEnemies(d, royalty);
		if(royalty == null){
			//okay, princes are traditional...
			royalty = findClassPlayer(findLivingPlayers(this.session.availablePlayers), SBURBClassManager.PRINCE);
			if(royalty != null && royalty.grimDark  > 0){
				royalty = null; //grim dark won't corpse smooch unless they actual want to.
			}
		}
		royalty = this.ignoreEnemies(d, royalty);
		//from here on out, prefer to god tier than to be corpse smooched.
		if(royalty == null){
			//okay, anybody free?
			royalty = rand.pickFrom(findLivingPlayers(this.session.availablePlayers));
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
			//print("I couldn't find royalty and also could god tier. " + this.session.session_id);
		}
		return royalty;
	}
	void renderForPlayer(Element div, Player deadPlayer){
		Player royalty = this.getRoyalty(deadPlayer);
		if(royalty != null){
			deadPlayer.interactionEffect(royalty);
			royalty.interactionEffect(deadPlayer);
			String divID = (div.id) + "_" + deadPlayer.chatHandle;
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML);
			Element canvasDiv = querySelector("#canvas"+ divID);
			this.drawCorpseSmooch(canvasDiv, deadPlayer, royalty, 1000);
		}else{
			print("dream self dies from no corpse smooch: " + this.session.session_id.toString());
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
					royalty.addStat("sanity", -10);
					ret += " The " + royalty.htmlTitle() + ", as a member of the royalty of " + royalty.moon + ", administers the universal remedy for the unawakened ";
					ret += " to the " + d.htmlTitle() + ". Their dream self takes over on " + d.moon + ". ";
					if(d.aspect == Aspects.DOOM) ret += "The prophecy is fulfilled. ";
					this.renderForPlayer(div, this.dreamersToRevive[i]);
					//this.makeAlive(d);
					this.combo ++;
				}else{
					//print("Adding important event god tier for: " + d.title())
					var alt = this.addImportantEvent(d);
					//print("alt is: " +alt);
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
		//print("adding important event from corpse smooch");
		Player current_mvp = findStrongestPlayer(this.session.players);
		//only one alternate event can happen at a time. if one gets replaced, return

		if(player.godDestiny == false && player.godTier == false){//could god tier, but fate wn't let them
			return this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.getStat("power"),player) );
		}else if(this.session.reckoningStarted == true && player.godTier == false) { //if the reckoning started, they couldn't god tier.
			return this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.getStat("power"),player) );
		}
		return null;
	}
	dynamic content(){
		String ret = "";
		num combo = 0;
		for(num i = 0; i<this.dreamersToRevive.length; i++){
			var d = this.dreamersToRevive[i];
			//have best friend mac on you.
			var royalty = this.getRoyalty(d);

			if(royalty){
				royalty.sanity += -10;
				ret += " The " + royalty.htmlTitle() + ", as a member of the royalty of " + royalty.moon + ", administers the universal remedy for the unawakened ";
				ret += " to the " + d.htmlTitle() + ". Their dream self takes over on " + d.moon + ". ";
				this.makeAlive(d);
				combo ++;
			}else{
				ret += d.htmlTitle() + "'s waits patiently for the kiss of life. But nobody came. ";
				ret += " Their dream self dies as well. ";
				this.makeDead(d);
			}
		}
		if(combo > 1){
			ret += "${combo}X CORPSEMOOCH COMBO!!!";
		}
		//x times corpse smooch combo
		return ret;

	}


}
