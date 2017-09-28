import "dart:html";
import "../SBURBSim.dart";


class GrimDarkQuests extends Scene{
		List<Player> players = [];	//grim dark players don't do their jobs. they try to crash the session.
	


	GrimDarkQuests(Session session): super(session);

	@override
	bool trigger(playerList){
		this.players = [];
		var living = findLivingPlayers(playerList);
		for (num i = 0; i<living.length; i++){
			var player = living[i];
			if (player is Player) {
				if (player.grimDark > 2) {
					this.players.add(player);
				} else if (player.grimDark > 1 && rand.nextDouble() > .5) {
					this.players.add(player);
				}
			}
		}
		if(this.players.length > 0 && this.players[0].trickster && rand.nextDouble() >.01) return false; //tricksters are too op and distractable, don't often actually try to break sim

		return this.players.length>0;
	}
	String checkSnapOutOfIt(player){
		Player  bestFriend = player.getBestFriend();
		if(bestFriend != null){
			var r = player.getRelationshipWith(bestFriend);
			if(r.value > 10){
				String ret = "The " + player.htmlTitle() + " suddenly snaps out of it.  Their friendship with the " + bestFriend.htmlTitle() + " has managed to free them of the Horrorterror's influence. ";
				if(bestFriend.grimDark > 1) ret += " The irony of this does not escape anyone. ";
				player.changeGrimDark(-3); //if you are max grimDark doesn't fully save you...but if you weren't....maybe you get an extra buffer?
				return ret;
			}
		}
		return null;

	}
	String workToCrashSession(player){
			var tasks = ["try to explode a gate using dark magicks. ", "try to destroy a temple meant to help them with their Quests.","search for the game disk for SBURB itself.","seek the counsel of the noble circle of the Horrorterrors. ","begin asking the local consorts VERY uncomfortable questsions.","meet with the Dersites to discuss game destroying options.","attempt to use their powers to access the Game's source code.","exploit glitches to access areas of the game meant never to be seen by players. ","seek forbidden knowledge hidden deep within the glitchiest parts of the Furthest Ring. "];
			if(player.aspect == Aspects.SPACE){
				tasks.add("try to destroy frog breeding equipment");
				tasks.add("just straight up murdering frogs out of frustration");
				tasks.add("try to tamper with the Forge");
				player.landLevel += -10; //they FOCUS on killing frogs and ruining the game.
				//session.logger.info("A grim dark space player is actively trying to breed a corrupt frog in session: " + this.session.session_id.toString());
			}
			String quip = "";
			num amount =0;
			if(player.grimDark < 2){
				amount = -1* player.getStat(Stats.POWER)/4; //not trying as hard
			}else if(player.grimDark <=3){
				amount = -1* player.getStat(Stats.POWER)/2;
			}else if(player.grimDark >3){
				 amount = -1* player.getStat(Stats.POWER); //more powerful the player, the more damage they do. get rid of grimDark bonus
			}
			this.session.sessionHealth += amount;
			player.landLevel += -1; //if they manage to snap out of this, they are gonna still have a bad time. why did they think this was a good idea?
			if(player.getStat(Stats.POWER) < 250 * Stats.POWER.coefficient){
				quip = " Luckily, they kind of suck at this game. ";
			}else if(player.getStat(Stats.POWER) > 500* Stats.POWER.coefficient){
				quip = " Oh shit. This looks bad. ";
			}else if(player.getStat(Stats.POWER) > 300* Stats.POWER.coefficient){
				quip = " They seem strong enough to do some serious damage. ";
			}
			return "The "+ player.htmlTitle() + " is trying to break SBURB itself. They ${rand.pickFrom(tasks)} $quip. Session health is at ${session.sessionHealth}.";

	}
	void crashSession(){
		this.session.stats.crashedFromPlayerActions = true;
		throw new PlayersCrashedSession(getPlayersTitlesNoHTML(this.players) + " has foolishly crashed session: ${this.session.session_id}");
	}
	@override
	void renderContent(Element div){
		////session.logger.info("A grim dark player is actively working to crash session " + this.session.session_id + " and this much health remains: " + this.session.sessionHealth );
		////session.logger.info("trying to crash session like an idiot: " + this.session.session_id);
    appendHtml(div,"<br><img src = 'images/sceneIcons/grimdark_black_icon.png'> "+this.content());
		if(this.session.sessionHealth <= 0){
      appendHtml(div,"<br><br>YOU MANIACS! YOU BLEW IT UP! AH, DAMN YOU! GOD DAMN YOU ALL TO HELL! <br><br>Just joking. Well, I mean. Not about them blowing it up. Sessions fucked. But. I mean, come on. What did you THINK would happen? Stupid, lousy goddamned GrimDark players crashing my fucking sessions.");

          this.crashSession();
		}
	}
	dynamic content(){
			String ret = "";
			for(num i = 0; i<this.players.length; i++){
				if(this.session.sessionHealth <= 0) return ret;
				Player player = this.players[i];
				String snop = this.checkSnapOutOfIt(player);
				if(snop != null){
					////session.logger.info("Grim dark player snapped out of it through the power of friendship in session " + this.session.session_id);
					ret += snop;
				}else{
					ret += this.workToCrashSession(player);
				}
			}
			return ret;
	}

}


//https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error#Custom_Error_Types
class PlayersCrashedSession implements Exception {
  String name = 'PlayersCrashedSession';
  String message =  'PlayersCrashedSession';
  PlayersCrashedSession(this.message);
}
