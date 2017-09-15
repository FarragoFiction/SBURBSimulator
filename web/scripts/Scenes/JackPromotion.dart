import "dart:html";
import "../SBURBSim.dart";


class JackPromotion extends Scene{
	List<Player> playerList = [];  //what players are already in the medium when i trigger?
  bool canRepeat = false;
	JackPromotion(Session session): super(session, false);

	@override
	bool trigger(List<Player> playerList){
		this.playerList = playerList;
		if(this.session.npcHandler.jack.getStat(Stats.CURRENT_HEALTH) <= 0 || this.session.npcHandler.jack.exiled) return false;  //jack can't be dead or exiled.
		if(this.session.npcHandler.queensRing == null) return false; //all is moot if no ring
		if(this.session.npcHandler.jack.crowned != null) return false; //don't steal the ring from yourself, dunkass
		////session.logger.info("jack is alive, there is a queens ring and jack doesn't have it: " + this.session.session_id);
		//jack is alive, and stronger than queen. (even if queen is dead, this means her lackeys are undisciplined)
		if(this.session.npcHandler.jack.getStat(Stats.POWER) > this.session.npcHandler.queen.getStat(Stats.POWER) || this.session.npcHandler.queen.getStat(Stats.CURRENT_HEALTH) <= 0 || this.session.npcHandler.queen.dead){
			return true;
		}

		return false;
	}
	ImportantEvent addImportantEvent(){
		Player current_mvp = findStrongestPlayer(this.session.players);
		return this.session.addImportantEvent(new JackPromoted(this.session, current_mvp.getStat(Stats.POWER),null,null) );
	}
	String content(){
		String ret = " In a shocking turn of events, Jack Noir claims the Black Queen's RING OF ORBS " + this.session.convertPlayerNumberToWords();
		ret += "FOLD. ";
		if(this.session.npcHandler.queen.crowned != null && !this.session.npcHandler.queen.exiled){
			if(this.session.npcHandler.queen.getStat(Stats.CURRENT_HEALTH) > 0){
				if(rand.nextDouble() > .5){
					//session.logger.info("Jack making out like a bandit in session: " + this.session.session_id.toString()); //get it? 'cause cause he is making otu with BQ but also stealing from her???'
					//and now the players still have to fight her.  ringless sure, but....
					this.session.npcHandler.queen.setStat(Stats.POWER,50); //she gets a morale boost, any weakening she had is reduced.
					ret += " At this point you would EXPECT him to kill the weakened Queen, but somehow they end up making out??? Dersites, am I right?  He still ends up with the RING, though.";
				}else{
					//session.logger.info("jack murdering queen instead of kissing her in sessin: " + this.session.session_id.toString());
					ret += "He easily murders the weakened queen and uses her ring to obtain her power. ";
					this.session.npcHandler.queen.setStat(Stats.CURRENT_HEALTH,-9999); //actually kill her you dunkass. not KISS her.
					this.session.npcHandler.queen.dead = true;
				}

			}else{
				ret += " He pries the ring off her still twitching finger. ";
			}
		}else{
			ret += "It's not hard at all to get his Crew to pull off a heist to get the RING OF ORBS "+ this.session.convertPlayerNumberToWords();
			ret += "FOLD. ";
			if(this.session.npcHandler.queen.getStat(Stats.CURRENT_HEALTH) > 0 && !this.session.npcHandler.queen.exiled){
				if(rand.nextDouble() > .5){
					//session.logger.info("Jack making out like a bandit in session: " + this.session.session_id.toString()); //get it? 'cause cause he is making otu with BQ but also stealing from her???'
					//and now the players still have to fight her.  ringless sure, but....
					this.session.npcHandler.queen.setStat(Stats.POWER,50); //she gets a morale boost, any weakening she had is reduced.
					ret += " At this point you would EXPECT him to kill the weakened Queen, but somehow they end up making out??? Dersites, am I right?  He still ends up with the RING, though.";
				}else{
					//session.logger.info("jack murdering queen instead of kissing her in sessin: " + this.session.session_id.toString());
					ret += "He easily defeats the weakened queen while he's at it. ";
					this.session.npcHandler.queen.setStat(Stats.CURRENT_HEALTH,-9999); //actually kill her you dunkass. not KISS her.
				}
			}
		}
		ret += " You'd think this would be no worse than having the Black Queen around, but Jack is kind of a big deal. ";
		ret += " He immediately decides to show everybody his stabs. ";
		var badPrototyping = findBadPrototyping(this.playerList);
		this.session.npcHandler.jack.crowned = this.session.npcHandler.queensRing;
		this.session.npcHandler.queen.crowned = null;

		if( badPrototyping == "First Guardian"){
			ret += " He is now in charge of random teleporation murders. ";
		}
		return ret;
	}
	@override
	void renderContent(Element div){
		ImportantEvent alt = this.addImportantEvent();
		////session.logger.info("Alt for jack promotion is: " + alt);
		if(alt != null && alt.alternateScene(div)){
			return;
		}
		appendHtml(div,"<br> <img src = 'images/sceneIcons/jack_icon.png'>"+this.content());
	}



}
