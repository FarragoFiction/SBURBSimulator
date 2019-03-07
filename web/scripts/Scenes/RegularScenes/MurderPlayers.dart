import "dart:html";
import "../../SBURBSim.dart";


class MurderPlayers extends Scene {
		List<Player> playerList = [];  //what players are already in the medium when i trigger?
	List<Player> murderers = [];


	MurderPlayers(Session session): super(session);


	@override
	bool trigger(playerList){
		this.playerList = playerList;
		this.murderers = [];
		for(Player p in session.getReadOnlyAvailablePlayers()){
			if(p.murderMode){
				this.murderers.add(p);
			}
		}

		return this.murderers.length > 0;
	}
	ImportantEvent addImportantEvent(Player player){
		////session.logger.info( "A player is dead. Dream Self: " + player.isDreamSelf + " God Destiny: " + player.godDestiny + " GodTier: " + player.godTier);

		if(player.isDreamSelf == true && player.godDestiny == false && player.godTier == false){
			var current_mvp = findStrongestPlayer(this.session.players);
			return this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.getStat(Stats.POWER),player,null) );
		}
		return null;
	}

	@override
	void renderContent(Element div){
    appendHtml(div,"<br> <img src = 'images/sceneIcons/murder_icon.png'>"+this.contentForRender(div));
	}
	dynamic friendsOfVictimHateYou(victim, murderer){
		var livePlayers = findLiving(this.session.players); //reroll it 'cause people might have died during this set of murders.'
		//just, fuck that guy.
		String ret = "";
		for(num i = 0; i<livePlayers.length; i++){
			var p = livePlayers[i];
			if(p != murderer && p != victim){
				Relationship rm = p.getRelationshipWith(murderer);
				Relationship rv = p.getRelationshipWith(victim);
				//more they liked the victim, the more they hate you.
				if(rv.saved_type == rv.diamond){
					rm.value = -100;
					p.addStat(Stats.SANITY,-100);
					ret += " The " + p.htmlTitle() + " is enraged that their Moirail was killed. ";
				}else if(rv.saved_type == rv.heart){
					rm.value = -100;
          p.addStat(Stats.SANITY,-100);
					ret += " The " + p.htmlTitle() + " is enraged that their Matesprit was killed. ";
				}else if(rv.saved_type == rv.spades){
					rm.value = -100;
          p.addStat(Stats.SANITY,-100);
					ret += " The " + p.htmlTitle() + " is enraged that their Kismesis was killed. ";
				}else if (rv.type() == rv.goodBig){
					rm.value = -20;
					ret += " The " + p.htmlTitle() + " is enraged that their crush was killed. ";
				}else if(rv.type() == rv.badBig && (p is Player && p.isTroll)){
					rm.value = -20;
					ret += " The " + p.htmlTitle() + " is enraged that their spades crush was killed. ";
				}else if(rv.type() == rv.badBig && (p is Player && !p.isTroll)){
					rm.increase();
					ret += " The " + p.htmlTitle() + " is pretty happy that their enemy was killed. ";
				}else if(rv.value > 0){  //iff i actually liked the guy.
					for(num j = 0; j< rv.value; j++){
						rm.decrease();
					}
					ret += " The " + p.htmlTitle() + " is pretty pissed that their friend was killed. ";
				}
			}
		}
		return ret;

	}

	bool shouldItBeAStrife(Player murderer, Player enemy) {
	    if(murderer == null || enemy == null) return false; //just. no.
		if(session.mutator.rageField) return true;
		Relationship r1 = murderer.getRelationshipWith(enemy);
		if(r1 != null && (r1.saved_type == r1.spades || r1.saved_type == r1.clubs)) return true; //at least TRY not to kill your kismesis or ashen mate. you're used to hatin them. If somehow you want to kill pale or flushed well...crime of passion.
		return false;
	}

	String doAStrife(Element div, Player murderer, Player enemy) {
	    session.logger.info("AB: A pvp strife is happening!");
	    String ret = "";
        Team pTeam = new Team.withName("${murderer.title()}", this.session, [murderer]);
        pTeam.canAbscond = false;
        Team dTeam = new Team.withName("${enemy.title()}", this.session, [enemy]);
        dTeam.canAbscond = false;
        Strife strife = new Strife(this.session, [pTeam, dTeam]);
        appendHtml(div, "<Br>The ${murderer.htmlTitle()} challenges the ${enemy.htmlTitle()} to an honorable duel. <Br>");
        strife.startTurn(div);
        if(!session.mutator.rageField && session.rand.nextDouble() >0.3 ) {  //MOST strifes arne't fatal.
            murderer.makeAlive();
            enemy.makeAlive();
            ret += "Luckily the combatants were only knocked out and recover shortly.";
        }else {
            Player killer = murderer;
            Player dead = murderer;
            if(enemy.dead) {
                dead = enemy;
            }else {
                killer = enemy;
            }
            String specialDeath = session.mutator.metaHandler.checkDeath(dead);
            if(session.mutator.rageField && specialDeath != null) {
                ret += "$specialDeath You did it. You finally killed one of the Manipulative Bastards. Keep going.";
                session.logger.info("AB: JR, that weird clone of ${dead.title()} was killed. ");
            }else {
                ret += " Oh. Oh god no. Please be grub sauce. Please be grub sauce! You didn't mean to! It was just a game... Why did ${dead.htmlTitle()} have to die? ";
            }
            killer.pvpKillCount ++;
            this.session.stats.murdersHappened = true;
            killer.victimBlood = dead.bloodColor;
            renderMurder(div, killer, dead);
        }
        session.removeAvailablePlayer(murderer);
        session.removeAvailablePlayer(enemy);
        return ret;
	}


	void renderMurder(Element div, Player murderer, Player victim){
		var divID = (div.id) + "_${victim.id}";
		CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
		div.append(canvas);

		var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
		Drawing.drawSprite(pSpriteBuffer,murderer);

		var dSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
		Drawing.drawSprite(dSpriteBuffer,victim);

		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0);
		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,200,0);

	}
	void renderDiamonds(Element div, Player murderer, Player diamond){

		var divID = (div.id) + "_${diamond.id}";
		CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
		div.append(canvas);

		var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
		Drawing.drawSprite(pSpriteBuffer,murderer);


		var dSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
		Drawing.drawSpriteTurnways(dSpriteBuffer,diamond);

		//used to check if troll was involved. what the fuck ever. everybody uses the quadrant system. it's just easier.
		var diSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
		Drawing.drawDiamond(diSpriteBuffer);
		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, diSpriteBuffer,175,0);
		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0);
		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,150,0);
	}
	void renderClubs(Element div, Player murderer, Player victim, Player club){
		//alert("clubs)")
		CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
		div.append(canvas);

		var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
		Drawing.drawSprite(pSpriteBuffer,murderer);

		var vSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
		Drawing.drawSprite(vSpriteBuffer,victim);

		var dSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
		Drawing.drawSpriteTurnways(dSpriteBuffer,club);  //facing non-middle leafs

		//used to check if troll was involved. what the fuck ever. everybody uses the quadrant system. it's just easier.
		var diSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
		Drawing.drawClub(diSpriteBuffer); //Auspisticism
		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, diSpriteBuffer,475,50);

		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0);
		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, vSpriteBuffer,200,0);
		Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,500,0);
	}
	dynamic contentForRender(Element div){
		var livePlayers = findLiving(session.getReadOnlyAvailablePlayers()); //just because they are alive doesn't mean they are in the medium
		String ret = "";
		for(num i = 0; i<this.murderers.length; i++){
			Player m = this.murderers[i];
			Player worstEnemy = m.getWorstEnemyFromList(livePlayers);
			if(worstEnemy != null) ret += m.interactionEffect(worstEnemy);

			//override regular shit to do a strife. really need to refactor this bullshit way to long method. later. gotta focus.
			if(shouldItBeAStrife(m, worstEnemy)){
                return doAStrife(div, m, worstEnemy);
            }
			//if(worstEnemy !=null && worstEnemy.sprite.name == "sprite") //session.logger.info("trying to kill somebody not in the medium yet: " + worstEnemy.title() + " in session: " + this.session.session_id.toString());
			var living = findLiving(this.session.players);
			removeFromArray(worstEnemy, living);
			var ausp = rand.pickFrom(living);
			if(ausp == worstEnemy || ausp == m){
				ausp = null;
			}
			//var notEnemy = m.getWorstEnemyFromList(this.session.availablePlayers);
			session.removeAvailablePlayer(m);

			if(worstEnemy !=null && worstEnemy.dead == false && this.canCatch(m,worstEnemy)){
				session.removeAvailablePlayer(worstEnemy);
				//if blood player is at all competant, can talk down murder mode player.
				if(worstEnemy.aspect.isThisMe(Aspects.BLOOD) && worstEnemy.getStat(Stats.POWER) > 25){
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += ", but instead the Bloody Thing happens and the " + m.htmlTitleBasic() + " is calmed down, and hug bumps are shared. ";
					if(m.dead) ret += " It is especially tragic that the burgeoning palemance is cut short with the " + m.htmlTitleBasic() + "'s untimely death. ";
					m.unmakeMurderMode();
					worstEnemy.checkBloodBoost(livePlayers);
					Relationship.makeDiamonds(m, worstEnemy);
					this.renderDiamonds(div, m, worstEnemy);

					return ret; //don't try to murder. (and also blood powers stop any other potential murders);
				}
				var r = worstEnemy.getRelationshipWith(m);
				if(r.type() == r.goodBig ){
					//moiralligance.
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += ", but instead gets talked down hardcore. Shit is downright tender.";
					if(m.dead == true){ //they could have been killed by another murder player in this same tick
						ret += " The task is made especially easy (yet tragic) by the " + m.htmlTitle() + " being in the middle of dying. ";
					}
					m.unmakeMurderMode();
					m.setStat(Stats.SANITY,1);
					Relationship.makeDiamonds(m, worstEnemy);
					this.renderDiamonds(div, m, worstEnemy);

				}else if(ausp != null && r.type() == r.badBig){  //they hate you back....
					///auspitism, but who is middle leaf?
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += "(who hates them back just as much), but instead is interrupted by the " + ausp.htmlTitle() + ", who convinces everyone to settle their shit down. ";
					if(m.dead == true){ //they could have been killed by another murder player in this same tick
						ret += " The task is made especially easy by the " + m.htmlTitle() + " dying partway through. ";
					}
					m.unmakeMurderMode();
					m.setStat(Stats.SANITY,1);
					this.renderClubs(div, m, worstEnemy,ausp);
					Relationship.makeClubs(ausp, m, worstEnemy);

				}else if(worstEnemy.getStat(Stats.POWER) * worstEnemy.getPVPModifier("Defender") < m.getStat(Stats.POWER)*m.getPVPModifier("Murderer")){
					var alt = this.addImportantEvent(worstEnemy);
					if(alt != null && alt.alternateScene(div)){
						//do nothing, alt scene will handle this.
					}else{
						m.increasePower();
						m.addStat(Stats.SANITY,100); //killing someone really takes the edge off.

						ret += " The " + m.htmlTitle() + " brutally murders that asshole, the " + worstEnemy.htmlTitle() +". " + getPVPQuip(worstEnemy,m, "Defender", "Murderer");
						if(m.dead == true){ //they could have been killed by another murder player in this same tick
							ret += " Every one is very impressed that they managed to do it while dying.";
						}
						ret += this.friendsOfVictimHateYou(worstEnemy, m);
						ret += worstEnemy.makeDead("fighting against the crazy " + m.title(), m);
						m.pvpKillCount ++;
						this.session.stats.murdersHappened = true;
						var r = worstEnemy.getRelationshipWith(m);
						r.value = -10; //you are not happy with murderer
						m.victimBlood = worstEnemy.bloodColor;
						this.renderMurder(div, m, worstEnemy);
					}
				}else{
					var alt = this.addImportantEvent(worstEnemy);
					if(alt != null && alt.alternateScene(div)){
						//do nothing, alt scene will handle this
					}else{
						worstEnemy.increasePower();

						ret += " The " + m.htmlTitle() + " attempts to brutally murder that asshole, the " + worstEnemy.htmlTitle();
						ret += ", but instead gets murdered first, in self-defense. " + getPVPQuip(m,worstEnemy, "Murderer", "Defender");
						if(m.dead == true){ //they could have been killed by another murder player in this same tick
							ret += " The task is made especially easy by the " + m.htmlTitle() + " being already in the proccess of dying. ";
						}
						ret += m.makeDead("being put down like a rabid dog by the " + worstEnemy.title(), worstEnemy);
						worstEnemy.pvpKillCount ++;
						this.session.stats.murdersHappened = true;
						var r = worstEnemy.getRelationshipWith(m);
						r.value = -10; //you are not happy with murderer
						worstEnemy.victimBlood = m.bloodColor;
						this.renderMurder(div,worstEnemy, m);
					}
				}
			}else{

				m.addStat(Stats.SANITY, 30);
				if(m.getStat(Stats.SANITY)>0){
					//alert("shit settled");
					ret += " The " + m.htmlTitle() + " has officially settled their shit. ";
					m.unmakeMurderMode();
				}else{
					if(!m.dead && worstEnemy != null && !this.canCatch(m,worstEnemy)){
						////session.logger.info("murder thwarted by mobility: " + this.session.session_id);
						if(worstEnemy.sprite.name == "sprite"){
							ret += " The " + m.htmlTitle() + " is too enraged to think things through.  The " + worstEnemy.htmlTitle() + " that they want to kill isn't even in the Medium, yet, dunkass!";
						}else if(worstEnemy.aspect.isThisMe(Aspects.VOID)){
							////session.logger.info("void avoiding murderer: " + this.session.session_id.toString());
							ret += " The " + m.htmlTitle() + " can't even find the " + worstEnemy.htmlTitle() + " in order to kill them! It's like they're fucking INVISIBLE or something. It's hard to stay enraged while wandering around, lost.";
						}else if (worstEnemy.aspect.isThisMe(Aspects.SPACE)){
							ret += " The " + m.htmlTitle() + " can't even find the " + worstEnemy.htmlTitle() + " in order to kill them! They probably aren't even running away, but somehow the " + m.htmlTitle() + " keeps getting turned around. It's hard to stay enraged while wandering around, lost.";
						}else{
							ret += " The " + m.htmlTitle() + " can't even find the " + worstEnemy.htmlTitle() + " in order to kill them! Do they just never stay in one spot for more than five seconds? Flighty bastard. It's hard to stay enraged while wandering around lost.";
						}
						m.addStat(Stats.SANITY,30);
					}else if(!m.dead){
						ret += " The " + m.htmlTitle() + " can't find anybody they hate enough to murder. They calm down a little. ";
					}
				}
			}
		}

		return ret;
	}
	bool canCatch(Player m, Player worstEnemy){
		if(session.mutator.rageField) return true; //can't run from the clown, yo.
		if(worstEnemy.sprite.name == "sprite") return false; //not in medium, dunkass.
		if(worstEnemy.getStat(Stats.POWER) > m.getStat(Stats.POWER)) return false;
		if(worstEnemy.aspect.isThisMe(Aspects.VOID) && worstEnemy.isVoidAvailable() && worstEnemy.getStat(Stats.POWER) >50) return false;
		if(worstEnemy.aspect.isThisMe(Aspects.SPACE) && worstEnemy.getStat(Stats.POWER) > 50){
			//session.logger.info("high level space player avoiding a murderer" + this.session.session_id.toString());
			return false;  //god tier calliope managed to hide from a Lord of Time. space players might not move around a lot, but that doesn't mean they are easy to catch.
		}
		return true;
	}


}
