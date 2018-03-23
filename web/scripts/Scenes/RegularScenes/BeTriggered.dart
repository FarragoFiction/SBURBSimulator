import "dart:html";
import "../../SBURBSim.dart";



class BeTriggered extends Scene{
	List<Player> playerList = [];  //what players are already in the medium when i trigger?
	List<Player> triggeredPlayers = [];
	List<dynamic> triggers = [];	


	BeTriggered(Session session): super(session);

	@override
	bool trigger(List<Player> playerList){
		this.playerList = playerList;
		this.triggeredPlayers = [];
		for(Player p in session.getReadOnlyAvailablePlayers()){
			//;
			if(this.IsPlayerTriggered(p) && rand.nextDouble() >.75){ //don't all flip out/find out at once. if i find something ELSE to flip out before i can flip out about this, well, oh well. SBURB is a bitch. 75 is what it should be when i'm done testing.
				//////session.logger.info("shit flipping: " + p.flipOutReason + " in session " + this.session.session_id);
				this.triggeredPlayers.add(p);
			}
		}
		return this.triggeredPlayers.length > 0;
	}
	@override
	void renderContent(Element div){
		appendHtml(div,"<br><img src = 'images/sceneIcons/flipout_icon_animated.gif'>"+this.content());
	}
	bool IsPlayerTriggered(Player player){
		if(player.flipOutReason != null && !player.flipOutReason.isEmpty){
			//////session.logger.info("I have a flip out reason: " + player.flipOutReason);
			if(player.flippingOutOverDeadPlayer != null && player.flippingOutOverDeadPlayer.dead){
				//////session.logger.info("I know about a dead player. so i'm gonna start flipping my shit. " + this.session.session_id);
				return true;
			}else if(player.flippingOutOverDeadPlayer != null){ //they got better.
			//	////session.logger.info(" i think i need to know about a dead player to flip my shit. " + player.flippingOutOverDeadPlayer.title())
				player.flipOutReason = null;
				player.flippingOutOverDeadPlayer = null;
				return false;
			}
			//if(player.flipOutReason == "being haunted by their own ghost") ////session.logger.info("flipping otu over own ghost" + this.session.session_id.toString());
			//"being haunted by the ghost of the Player they killed"
				//if(player.flipOutReason == "being haunted by the ghost of the Player they killed") ////session.logger.info("flipping otu over victim ghost" + this.session.session_id.toString());
			///okay. player.flippingOutOverDeadPlayer apparently can be null even if i totally and completely am flipping otu over a dead player. why.
			//////session.logger.info("preparing to flip my shit. and its about " + player.flipOutReason + " which BETTEr fucking not be about a dead player. " + player.flippingOutOverDeadPlayer);
			return true; //i am flipping out over not a dead player, thank you very much.

		}
		if(-1 * player.getStat(Stats.SANITY) > rand.nextDouble() * 100 && (player.flipOutReason == null || player.flipOutReason.isEmpty)){
			player.flipOutReason = "how they seem to be going shithive maggots for no goddamned reason";
			return true;
		}
		return false;
	}
	String content(){
		String ret = "";
		for(num i = 0; i<this.triggeredPlayers.length; i++){
			Player p = this.triggeredPlayers[i];
			Player hope = findAspectPlayer(findLiving(this.session.players), Aspects.HOPE);
			if(hope!=null && hope.getStat(Stats.POWER) > 100){

				//////session.logger.info("Hope Survives: " + this.session.session_id);
				ret += " The " +p.htmlTitle() + " should probably be flipping the fuck out about  " + p.flipOutReason;
				ret += " and being completely useless, but somehow the thought that the " + hope.htmlTitle() + " is still alive fills them with determination, instead.";  //hope survives.
				hope.increasePower();
				p.increasePower();
				p.flipOutReason = null;
				p.flippingOutOverDeadPlayer = null;

			}else{
				session.removeAvailablePlayer(p);
				if(p.flipOutReason == null) p.flipOutReason = " how glitchy SBURB is "; //<-- why is this necessary???
				ret += " The " +p.htmlTitle() + " is currently too busy flipping the fuck out about ";
				ret += p.flipOutReason + " to be anything but a useless piece of gargbage. ";
				p.addStat(Stats.SANITY, -10);
				p.flipOutReason = null;
				p.flippingOutOverDeadPlayer = null;
				if(p.getStat(Stats.SANITY) < -5){
					ret += " Their freakout level is getting dangerously high. ";
				}
			}
		}
		return ret;
	}

}
