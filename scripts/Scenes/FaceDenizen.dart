part of SBURBSim;


class FaceDenizen extends Scene{
	bool canRepeat = true;
	List<dynamic> playerList = [];  //what players are already in the medium when i trigger?
	List<dynamic> denizenFighters = [];	


	FaceDenizen(Session session): super(session);

	@override
	dynamic trigger(playerList){
		this.denizenFighters = [];
		this.playerList = playerList;
		for(num i = 0; i<this.session.availablePlayers.length; i++){
			var p = this.session.availablePlayers[i];
			if(p.denizen_index >= 3 && !p.denizenDefeated && p.land != null){
				var d = p.denizen;
				if(p.power > d.getStat("currentHP") || seededRandom() > .5){  //you're allowed to do other things between failed boss fights, you know.
					this.denizenFighters.push(p);
				}
			}else if(p.landLevel >= 6 && !p.denizenMinionDefeated && p.land != null){
				var d = p.denizenMinion;
				if(p.power > d.getStat("currentHP") || seededRandom() > .5){//you're allowed to do other things between failed boss fights, you know.
					this.denizenFighters.push(p);
				}
			}
		}
		return this.denizenFighters.length > 0;
	}
	dynamic addImportantEvent(player){  //TODO reimplment this for boss fights
		/*
		var current_mvp = findStrongestPlayer(this.session.players);
		//need to grab this cause if they are dream self corpse smooch won't trigger an important event
		if(player.godDestiny == false && player.isDreamSelf == true){//could god tier, but fate wn't let them
			var ret = this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.power,player) );
			if(ret){
				return ret;
			}
			this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
		}else if(this.session.reckoningStarted == true && player.isDreamSelf == true) { //if the reckoning started, they couldn't god tier.
			var ret = this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
			if(ret){
				return ret;
			}
			this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.power,player) );
		}else if(player.isDreamSelf == true){
				return this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
		}
		*/
	}
	@override
	void renderContent(div){
		div.append("<br><br>");
		for(num i = 0; i<this.denizenFighters.length; i++){
			var p = this.denizenFighters[i];
			removeFromArray(p, this.session.availablePlayers);
			if(!p.denizenMinionDefeated){
				this.faceDenizenMinion(p,div);
			}else if(!p.denizenDefeated){
				this.faceDenizen(p,div);
			}

		}
	}
	void faceDenizenMinion(p, div){
		var denizenMinion = p.denizenMinion;
		String ret = "<br>The " + p.htmlTitleHP() + " initiates a strife with the " + denizenMinion.name + ". ";
		if(p.sprite && p.sprite.getStat("currentHP") > 0 ) ret += " " + p.sprite.htmlTitleHP() + " joins them! ";
		div.append(ret);
		denizenMinion.strife(div, [p,p.sprite],0);
		if(denizenMinion.getStat("currentHP") <= 0 || denizenMinion.dead){
			p.denizenMinionDefeated = true;
		}
	}
	void faceDenizen(p, div){
		String ret = " ";
		var denizen = p.denizen;
		if(!p.denizenFaced && p.getFriends().length > p.getEnemies().length){ //one shot at The Choice
			//print("confront icon: " + this.session.session_id);
			ret += "<br><img src ;= 'images/sceneIcons/confront_icon.png'> The " + p.htmlTitle() + " cautiously approaches their " + denizen.name + " and are presented with The Choice. "
			if(p.power > 27){ //calibrate this l8r
				ret += " The " + p.htmlTitle() + " manages to choose correctly, despite the seeming impossibility of the matter. ";
				ret += " They gain the power they need to acomplish their objectives. ";
				p.denizenDefeated = true;
				p.power = p.power*2;  //current and future doubling of power.
				p.leveledTheHellUp = true;
				p.grist += denizen.grist;
				div.append("<br>"+ret);
				this.session.denizenBeat = true;
				p.fraymotifs = p.fraymotifs.concat(p.denizen.fraymotifs);
				//print("denizen beat through choice in session: " + this.session.session_id);
			}else{
				p.denizenDefeated = false;
				ret += " They are unable to bring themselves to make the clearly correct, yet impossible, Choice, and are forced to admit defeat. " + denizen.name + " warns them to prepare for a strife the next time they come back. ";
				div.append("<br>"+ret);
			}
		}else{
			ret += "<br>The " + p.htmlTitle() + " initiates a strife with their " + denizen.name + ". ";
			div.append(ret);
			denizen.strife(div, [p],0);
			if(denizen.getStat("currentHP") <= 0 || denizen.dead) {
				p.denizenDefeated = true;
				p.fraymotifs = p.fraymotifs.concat(p.denizen.fraymotifs);
				p.power = p.power*2;  //current and future doubling of power.
				this.session.denizenBeat = true;
			}else if(p.dead){
				//print("denizen kill " + this.session.session_id);
			}
		}
			p.denizenFaced = true; //may not have defeated them, but no longer have the option of The Choice
	}
	void renderContentOld(div){

		for(num i = 0; i<this.denizenFighters.length; i++){
			String ret = "<br>";
			var p = this.denizenFighters[i];
			removeFromArray(p, this.session.availablePlayers);
			//ret += "Debug Power: " + p.power;
			//fight denizen
			if(p.getFriends().length < p.getEnemies().length){
				ret += " The " + p.htmlTitle() + " sneak attacks their denizen, " + p.getDenizen() + ". ";
				if(p.power > 17){
					ret += " They win handly, and obtain untold levels of power and sweet sweet hoarde grist. They gain all the levels. All of them. ";
					p.denizenFaced = true;
					p.power = p.power*2;  //current and future doubling of power.
					p.level_index +=3;
					p.leveledTheHellUp = true;
					p.denizenDefeated = true;
					this.session.denizenBeat = true;
					//print("denizen beat through violence in session: " + this.session.session_id);
					div.append("<br>"+ret);
				}else{
					p.denizenFaced = true;
					p.denizenDefeated = false;
					ret += " Huh.  They were NOT ready for that.  They are easily crushed by their Denizen. DEAD.";
					p.makeDead("fighting their Denizen way too early");
					div.append("<br>"+ret);
					var divID = (div.attr("id"));
					String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
					div.append(canvasHTML);
					var canvas = querySelector("#canvas"+ divID);
					drawSinglePlayer(canvas, p);
					denizenKill(canvas, p);
					//print("denizen kill " + this.session.session_id);
					//foundRareSession(div, "A denizen made a corpse.");

				}
			}else{//do The Choice
				ret += " The " + p.htmlTitle() + " cautiously approaches their denizen, " + p.getDenizen() + " and are presented with The Choice. ";
				if(p.power > 27){
					ret += " The " + p.htmlTitle() + " manages to choose correctly, despite the seeming impossibility of the matter. ";
					ret += " They gain the power they need to acomplish their objectives. ";
					p.denizenFaced = true;
					p.denizenDefeated = true;
					p.power = p.power*2;  //current and future doubling of power.
					p.leveledTheHellUp = true;
					div.append("<br>"+ret);
					this.session.denizenBeat = true;
					//print("denizen beat through choice in session: " + this.session.session_id);
				}else{
					p.denizenFaced = true;
					p.denizenDefeated = false;
					ret += " They are unable to bring themselves to make the clearly correct, yet impossible, Choice, and are forced to admit defeat. " + p.getDenizen() + " warns them not to come back. ";
					div.append("<br>"+ret);
				}
			}

		}
	}
	dynamic content(){
		String ret = "";
		for(num i = 0; i<this.denizenFighters.length; i++){
			var p = this.denizenFighters[i];
			removeFromArray(p, this.session.availablePlayers);
			//ret += "Debug Power: " + p.power;
			//fight denizen
			if(p.getFriends().length < p.getEnemies().length){
				ret += " The " + p.htmlTitle() + " sneak attacks their denizen, " + p.getDenizen() + ". ";
				if(p.power > 7){
					ret += " They win handly, and obtain untold levels of power and sweet sweet hoarde grist. They gain all the levels. All of them. ";
					p.denizenFaced = true;
					p.power = p.power*2;  //current and future doubling of power.
					p.level_index +=3;
					p.leveledTheHellUp = true;
					p.denizenDefeated = true;
					this.session.denizenBeat = true;
				//	print("denizen beat through violence in session: " + this.session.session_id);
				}else{
					p.denizenFaced = true;
					p.denizenDefeated = false;
					ret += " Huh.  They were NOT ready for that.  They are easily crushed by their Denizen. DEAD.";
					p.dead = true;
					p.makeDead("fighting their Denizen way too early");
				}
			}else{//do The Choice
				ret += " The " + p.htmlTitle() + " cautiously approaches their denizen, " + p.getDenizen() + " and are presented with The Choice. ";
				if(p.power > 10){
					ret += " The " + p.htmlTitle() + " manages to choose correctly, despite the seeming impossibility of the matter. ";
					ret += " They gain the power they need to acomplish their objectives. ";
					p.denizenFaced = true;
					p.denizenDefeated = true;
					p.power = p.power*2;  //current and future doubling of power.
					p.leveledTheHellUp = true;
					//this.session.denizenBeat = true;
					//print("denizen beat through choice in session: " + this.session.session_id);
				}else{
					p.denizenFaced = true;
					p.denizenDefeated = false;
					ret += " They are unable to bring themselves to make the clearly correct, yet impossible, Choice, and are forced to admit defeat. " + p.getDenizen() + " warns them not to come back. ";
				}
			}

		}
		return ret;
	}

}
