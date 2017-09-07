import "dart:html";
import "../SBURBSim.dart";


class FaceDenizen extends Scene{

	List<dynamic> denizenFighters = [];	


	FaceDenizen(Session session): super(session);

	@override
	bool trigger(playerList){
		this.denizenFighters = [];
		this.playerList = playerList;
		for(Player p in session.getReadOnlyAvailablePlayers()){
			if(p.denizen == null && p.aspect != Aspects.NULL) session.logger.warn("A player has no denizen, but is not a Null player. Player is $p");
			if (p.denizen_index >= 3 && !p.denizenDefeated && p.land != null && p.denizen != null) {
				var d = p.denizen;
				if (p.getStat(Stats.POWER) > d.getStat(Stats.CURRENT_HEALTH) || rand.nextDouble() > .5) { //you're allowed to do other things between failed boss fights, you know.
					this.denizenFighters.add(p);
				}
			} else if (p.landLevel >= 6 && !p.denizenMinionDefeated && p.land != null && p.denizen != null) {
				var d = p.denizenMinion;
				if (p.getStat(Stats.POWER) > d.getStat(Stats.CURRENT_HEALTH) || rand.nextDouble() > .5) { //you're allowed to do other things between failed boss fights, you know.
					this.denizenFighters.add(p);
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
			var ret = this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.getStat(Stats.POWER),player) );
			if(ret){
				return ret;
			}
			this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.getStat(Stats.POWER),player) );
		}else if(this.session.reckoningStarted == true && player.isDreamSelf == true) { //if the reckoning started, they couldn't god tier.
			var ret = this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.getStat(Stats.POWER),player) );
			if(ret){
				return ret;
			}
			this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.getStat(Stats.POWER),player) );
		}else if(player.isDreamSelf == true){
				return this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.getStat(Stats.POWER),player) );
		}
		*/
	}
	@override
	void renderContent(Element div){
		appendHtml(div,"<br><br>");
		for(num i = 0; i<this.denizenFighters.length; i++){
			var p = this.denizenFighters[i];
			session.removeAvailablePlayer(p);
			if(!p.denizenMinionDefeated){
				this.faceDenizenMinion(p,div);
			}else if(!p.denizenDefeated){
				this.faceDenizen(p,div);
			}

		}
	}
	void faceDenizenMinion(Player p, Element div){
		GameEntity denizenMinion = p.denizenMinion;
		String ret = "<br>The " + p.htmlTitleHP() + " initiates a strife with the " + denizenMinion.name + ". ";
		if(p.sprite != null && p.sprite.getStat(Stats.CURRENT_HEALTH) > 0 ) ret += " " + p.sprite.htmlTitleHP() + " joins them! ";
    appendHtml(div,ret);
		Team pTeam = new Team.withName("The ${p.htmlTitle()}",this.session, [p]);
		Team dTeam = new Team(this.session, [denizenMinion]);
    dTeam.canAbscond = false;
		Strife strife = new Strife(this.session, [pTeam, dTeam]);
		strife.startTurn(div);
		if(denizenMinion.getStat(Stats.CURRENT_HEALTH) <= 0 || denizenMinion.dead){
			p.denizenMinionDefeated = true;
		}
	}
	void faceDenizen(p, Element div){
		String ret = " ";
		var denizen = p.denizen;
		if(!p.denizenFaced && p.getFriends().length > p.getEnemies().length){ //one shot at The Choice
			////session.logger.info("confront icon: " + this.session.session_id);
			ret += "<br><img src = 'images/sceneIcons/confront_icon.png'> The " + p.htmlTitle() + " cautiously approaches their " + denizen.stat + " and are presented with The Choice. ";
			if(p.getStat(Stats.POWER) > 27){ //calibrate this l8r
				ret += " The " + p.htmlTitle() + " manages to choose correctly, despite the seeming impossibility of the matter. ";
				ret += " They gain the power they need to acomplish their objectives. ";
				p.denizenDefeated = true;
				p.addStat(Stats.POWER,p.getStat(Stats.POWER)*2);  //current and future doubling of power.
				p.leveledTheHellUp = true;
				p.grist += denizen.grist;
				appendHtml(div,"<br>"+ret);
				this.session.stats.denizenBeat = true;
				p.fraymotifs.addAll(p.denizen.fraymotifs);
				////session.logger.info("denizen beat through choice in session: " + this.session.session_id);
			}else{
				p.denizenDefeated = false;
				ret += " They are unable to bring themselves to make the clearly correct, yet impossible, Choice, and are forced to admit defeat. " + denizen.stat + " warns them to prepare for a strife the next time they come back. ";
        appendHtml(div,"<br>"+ret);
			}
		}else{
			ret += "<br>The " + p.htmlTitle() + " initiates a strife with their " + denizen.stat + ". ";
      appendHtml(div,ret);
      Team pTeam = new Team(this.session, [p]);
      pTeam.name = "The ${p.htmlTitle()}";
      Team dTeam = new Team(this.session, [denizen]);
      dTeam.canAbscond = false;
      Strife strife = new Strife(this.session, [pTeam, dTeam]);
      strife.startTurn(div);
			if(denizen.getStat(Stats.CURRENT_HEALTH) <= 0 || denizen.dead) {
				p.denizenDefeated = true;
				p.fraymotifs.addAll(p.denizen.fraymotifs);
				p.addStat(Stats.POWER,p.getStat(Stats.POWER)*2);  //current and future doubling of power.
				this.session.stats.denizenBeat = true;
			}else if(p.dead){
				////session.logger.info("denizen kill " + this.session.session_id);
			}
		}
			p.denizenFaced = true; //may not have defeated them, but no longer have the option of The Choice
	}


}
