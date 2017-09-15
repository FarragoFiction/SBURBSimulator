import "dart:html";
import "../SBURBSim.dart";


class Reckoning extends Scene {

	bool canRepeat = false;

	Reckoning(Session session): super(session, false);


	@override
	bool trigger(playerList){
		this.playerList = playerList;
		return true; //this should never be in the main array. call manually.
	}

	@override
	String renderContent(Element div){
		this.session.reckoningStarted = true;
		String intro = "";
		if(this.session.npcHandler.king.getStat(Stats.CURRENT_HEALTH) < 0){
			intro += "<br><br> The reckoning has begun, initiating a meteor storm to destroy Skaia. ";
		}else{
			intro += "<br><br> The reckoning has begun.  The Black King has defeated his Prospitian counterpart, initiating a meteor storm to destroy Skaia. ";
			this.session.npcHandler.king.heal();
			this.session.npcHandler.queen.heal();
		}

		var leader = getLeader(this.session.players);
		if(this.session.stats.ectoBiologyStarted){
			intro += " Remember those random baby versions of the players the " + leader.htmlTitleBasic() + " made? " ;
			if(this.session.stats.scratched){
				intro += "Wait... DID they make the babies? Or, was it their guardian, the " + getLeader(getGuardiansForPlayers(this.session.players)).htmlTitleBasic() +"? Scratched sessions are so confusing...";
			}
			intro += " Yeah, that didn't stop being a thing that was true. ";
			intro += " It turns out that those babies ended up on the meteors heading straight to Skaia. ";
			intro += " And to defend itself, Skaia totally teleported those babies back in time, and to Earth. ";
			intro += "We are all blown away by this stunning revelation.  Wow, those babies were the players? Really?  Like, a paradox?  Huh. ";
		}else if(!this.session.stats.ectoBiologyStarted && leader.aspect == Aspects.TIME &&!leader.dead){
			leader.performEctobiology(this.session);
			intro += " Okay. Don't panic. But it turns out that the " + leader.htmlTitle() + " completly forgot to close one of their time loops. ";
			intro += " They were totally supposed to take care of the ectobiology. It's cool though, they'll just go back in time and take care of it now. ";
			intro += " They warp back to the present in a cloud of clocks and gears before you even realize they were gone. See, nothing to worry about. ";
		}
		else if (!session.mutator.spaceField){
			intro += " So. I don't know if YOU know that this was supposed to be a thing, but the " + leader.htmlTitleBasic();
			intro += " was totally supposed to have taken care of the ectobiology. ";
			intro += " They didn't. They totally didn't.  And now, it turns out that none of the players could have possibly been born in the first place. ";
			intro += " Textbook case of a doomed timeline.  Apparently the Time Player ";
			if(findAspectPlayer(session.players, Aspects.TIME).doomedTimeClones.length >0){
				intro += ", despite all the doomed time clone shenanigans, ";
			}
			intro += "was not on the ball with timeline management. Nothing you can do about it. <Br><Br>GAME OVER.";
			this.session.stats.doomedTimeline = true;
			intro += "<br><br>";
			querySelector("#story").appendHtml(intro,treeSanitizer: NodeTreeSanitizer.trusted);
			//session.logger.info("reckoning scratch button");
			this.session.stats.scratchAvailable = true;
			SimController.instance.renderScratchButton(this.session);
			this.session.stats.scratchAvailable = true;
			return intro;
		}else {
			session.logger.info("AB: Space4 Gnosis is making ectobiology able to happen in child sessions. ");
			intro += "You find out that the ${session.mutator.spacePlayer.htmlTitle()} took care of things. ";
			intro += " Apparently now you're destined to have always have had been born in some other session? You get a little dizzy trying to think about it. ";
			intro += " At least you're able to follow that you SHOULD be doomed right now because ectobiology totally didn't happen. But you aren't. And you should thank the ${session.mutator.spacePlayer.htmlTitle()} ";
		}
		var living = findLivingPlayers(this.session.players);
		if(living.length > 0){
			if(this.session.npcHandler.king.getStat(Stats.CURRENT_HEALTH)<0){
				intro += "<br><br>Normally this is where the Black King would show up to do an epic boss fight. Jack fucked up THAT script, though.  Looks like there's nothing to stop the players from...just...deploying the frog into the Skaia hole???  I mean. If they have a Frog. They do, right?";
			}else{
					intro += " <br><br>Getting back to the King, all the players can do now is try to defeat him on Skaia before they lose their Ultimate Reward. ";
					intro += " The Ultimate Reward allows the players to create a new Universe frog, and live inside of it. ";
					intro += " Without it, they'll be trapped in the Medium forever. (Barring shenanigans). ";
					intro += living.length.toString() + " players will fight the Dersite Royalty and try to prove themselves worthy of the Ultimate Reward. ";
			}

		}else{
			intro += " <br><br>No one is alive. <BR><BR>Game Over.  ";
			intro += "<img src = 'images/abj_watermark.png' class='watermark'>";
			var strongest = findMVP(this.session.players);
			intro += "The MVP of the session was: " + strongest.htmlTitle() + " with a grist level of: ${strongest.grist}";
		}
		intro += "<br><br>";

		appendHtml(div, intro);
		return null;
	}
	void content(div, i){
		String ret = " TODO: Figure out what a non 2.0 version of the Intro scene would look like. ";
		div.append(ret);
	}

}
