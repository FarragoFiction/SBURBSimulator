import "dart:html";
import "../SBURBSim.dart";



class Breakup extends Scene {
	Player player = null;
	Relationship relationshipToBreakUp = null;
	String reason = "";
	String formerQuadrant = ""; //who are you cheating with?
	//only can happen for one player at a time.
	//
	


	Breakup(Session session): super(session, false);

	@override
	bool trigger(List<Player> playerList){
		if(session.mutator.heartField) return false; //THE SHIPS CANNOT SINK!!!
		this.player = null;
		this.relationshipToBreakUp = null;
		for(num i = 0; i<this.session.getReadOnlyAvailablePlayers().length; i++){
			this.player = this.session.getReadOnlyAvailablePlayers()[i];
			var breakup= this.breakUpBecauseIAmCheating() || this.breakUpBecauseTheyCheating() || this.breakUpBecauseNotFeelingIt();
			if(!this.player.dead && breakup==true && this.relationshipToBreakUp != null){
				//////session.logger.info("breakup happening: is it triggering anything??? " + this.reason + " with player: " + this.player.title() + this.session.session_id)
				return true;
			}
		}
		this.player = null;
		return false;
	}
	bool breakUpBecauseIAmCheating(){
		//higher = more likely to break up if i'm given a reason.;
		var breakUpChance = this.getModifierForAspect() + this.getModifierForClass() + this.getModifierForInterestsAdmitCheating(); //returns min value of .3
		//more likely if prospit, because they don't think secrets stay secret very long.
		if(this.player.moon == "Prospit"){
			breakUpChance += 1;
		}

		var hearts = this.player.getHearts();
		if(hearts.length > 1){
			if(rand.nextDouble()*3 < breakUpChance){
				this.relationshipToBreakUp = rand.pickFrom(hearts);
				this.formerQuadrant = this.relationshipToBreakUp.saved_type;
				this.relationshipToBreakUp.target.addStat(Stats.SANITY,-10);
				this.relationshipToBreakUp.target.flipOut("getting cheated on by their Matesprit, the  " + this.player.htmlTitle() );
				var oppr = this.relationshipToBreakUp.target.getRelationshipWith(this.player);
				oppr.value = 5;
				this.reason = "me_cheat";

				//////session.logger.info("breaking up hearts because i am cheating in session: " +this.session.session_id);
				return true;
			}
		}

		var spades = this.player.getSpades();
		if(spades.length > 1){
			if(rand.nextDouble()*3 < breakUpChance){
				this.relationshipToBreakUp = rand.pickFrom(spades);
				this.formerQuadrant = this.relationshipToBreakUp.saved_type;
				this.relationshipToBreakUp.target.addStat(Stats.SANITY,-10);
				this.relationshipToBreakUp.target.flipOut("getting cheated on by their Kismesis, the  " + this.player.htmlTitle() );
				var oppr = this.relationshipToBreakUp.target.getRelationshipWith(this.player);
				oppr.value = 5;
				this.reason = "me_cheat";
				//////session.logger.info("breaking up spades because i am cheating in session: " +this.session.session_id);
				return true;
			}
		}
		var diamonds = this.player.getDiamonds();
		if(diamonds.length > 1){
			if(rand.nextDouble()*3 < breakUpChance){
				this.relationshipToBreakUp = rand.pickFrom(diamonds);
				this.formerQuadrant = this.relationshipToBreakUp.saved_type;
				//cheating with diamonds sounds like a terrible idea.
				this.relationshipToBreakUp.target.addStat(Stats.SANITY,-100);
				this.relationshipToBreakUp.target.flipOut("getting cheated on by their Moirail, the  " + this.player.htmlTitle() );
				var oppr = this.relationshipToBreakUp.target.getRelationshipWith(this.player);
				oppr.value = -1;
				this.reason = "me_cheat";
				//////session.logger.info("breaking up diamonds because i am cheating in session: " +this.session.session_id);
				return true;
			}
		}
		return false;
	}
	bool breakUpBecauseTheyCheating(){
		//higher = more likely to break up if i'm given a reason.;
		var breakUpChance = this.getModifierForAspect() + this.getModifierForClass() + this.getModifierForInterestsAccuseCheating(); //returns min value of .3
		//more likely if derse, horrorterrors tell you terrible things.
		if(this.player.moon == "Derse"){
			breakUpChance += 1;
		}

		for (num i = 0; i<this.player.relationships.length; i++){
			var r = this.player.relationships[i];
			if(r.saved_type ==r.heart){
				var hearts = r.target.getHearts();
				if(hearts.length > 1){
					if(rand.nextDouble()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
						//not happy with cheating bastards.
						this.player.addStat(Stats.SANITY,-100);
						this.player.flipOut("having to confront their Matesprit, the  " + this.relationshipToBreakUp.target.htmlTitle() + " about their cheating");
						r.value =-10;
						this.reason = "you_cheat";
						//////session.logger.info("breaking up hearts because they are cheating in session: " +this.session.session_id);
						return true;
					}
				}
			}

			if(r.saved_type ==r.spades){
				var spades = r.target.getSpades();
				if(spades.length > 1){
					if(rand.nextDouble()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
						//not happy with cheating bastards.
						this.player.addStat(Stats.SANITY,-100);
						this.player.flipOut("having to confront their Kismesis, the  " + this.relationshipToBreakUp.target.htmlTitle() + " about their cheating");
						r.value =-10;
						this.reason = "you_cheat";
						//////session.logger.info("breaking up spades because they are cheating in session: " +this.session.session_id);
						return true;
					}
				}
			}

			if(r.saved_type ==r.diamond){
				var diamonds = r.target.getDiamonds();
				if(diamonds.length > 1){
					if(rand.nextDouble()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
						//dude, cheating on diamonds sounds like a TERRIBLE idea.
						this.player.addStat(Stats.SANITY,-1000);
						this.relationshipToBreakUp.target.flipOut("having to confront their trusted FUCKING Moirail, the  " + this.relationshipToBreakUp.target.htmlTitle() + " about their cheating");
						r.value =-50;
						this.reason = "you_cheat";
						//////session.logger.info("breaking up diamonds because they are cheating in session: " +this.session.session_id);
						return true;
					}
				}
			}
		}
		return false;
	}
	bool breakUpBecauseNotFeelingIt(){
		var breakUpChance = this.getModifierForAspect() + this.getModifierForClass() + this.getModifierForInterestsBored(); //returns min value of .3
		for (num i = 0; i<this.player.relationships.length; i++){
			var r = this.player.relationships[i];
			var realType = r.changeType(); //doesn't save anything.
			if(r.saved_type ==r.heart && realType != r.goodBig ){
				if(rand.nextDouble()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
						this.reason = "bored";
						//////session.logger.info("breaking up heart because they are bored in session: " +this.session.session_id);
						return true;
				}
			}

			if(r.saved_type ==r.spades && realType != r.badBig ){
				if(rand.nextDouble()*3 < breakUpChance){
						this.relationshipToBreakUp =r;
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
						this.reason = "bored";
					//	////session.logger.info("breaking up spades because they are bored in session: " +this.session.session_id);
						return true;
				}
			}

			if(r.saved_type ==r.diamond && r.value < 0 ){
				if(rand.nextDouble()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						this.reason = "bored";
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
					//	////session.logger.info("breaking up diamond because they are bored in session: " +this.session.session_id);
						return true;
				}
			}
		}
		return false;
	}
	num getModifierForClass(){
		if(this.player.class_name == SBURBClassManager.THIEF || this.player.class_name == SBURBClassManager.KNIGHT || this.player.class_name == SBURBClassManager.HEIR|| this.player.class_name == SBURBClassManager.SEER|| this.player.class_name == SBURBClassManager.WITCH|| this.player.class_name == SBURBClassManager.PRINCE){
			return 1;
		}
		return 0;
	}
	num getModifierForAspect(){
		if(this.player.aspect == Aspects.DOOM ||  this.player.aspect == Aspects.RAGE ||this.player.aspect == Aspects.BREATH ||this.player.aspect == Aspects.LIGHT ||this.player.aspect == Aspects.HEART ||this.player.aspect == Aspects.MIND ){
			return 1;
		}
		return 0;
	}
	num getModifierForInterestsAdmitCheating(){
		if(InterestManager.TERRIBLE.playerLikes(this.player)){
			return -12;
		}else if(InterestManager.SOCIAL.playerLikes(this.player) || InterestManager.ROMANTIC.playerLikes(this.player) || InterestManager.JUSTICE.playerLikes(this.player)){
			return 1;
		}
		return 0.1;
	}
	num getModifierForInterestsAccuseCheating(){
		if(InterestManager.TERRIBLE.playerLikes(this.player)){
			return 2;
		}else if(InterestManager.POPCULTURE.playerLikes(this.player) || InterestManager.JUSTICE.playerLikes(this.player)){  //the TV always makes breakups dramatic, right?
			return 1;
		}else if(InterestManager.DOMESTIC.playerLikes(this.player)){  //care more about stability.
			return -1;
		}
		return 0.1;
	}
	num getModifierForInterestsBored(){
		if(InterestManager.TERRIBLE.playerLikes(this.player)){
			return 12;
		}else if(InterestManager.POPCULTURE.playerLikes(this.player) || InterestManager.TECHNOLOGY.playerLikes(this.player)){
			return 1;
		}
		return 0.1;
	}
	String getChat(player1, player2){
		if(this.reason == "me_cheat"){
			return this.meCheatChatText(player1, player2);
		}else if(this.reason == "you_cheat"){
			return this.youCheatChatText(player1, player2);
		}else{
			return this.meBoredChatText(player1, player2);
		}
	}
	void breakupChat(Element div){
		//drawChat(canvasDiv, player1, player2, chatText, 1000,"discuss_hatemance.png");
		String canvasHTML = "<br><canvas id='canvas" + (div.id) +"' width='$canvasWidth' height=$canvasHeight'>  </canvas>";
		appendHtml(div, canvasHTML);
		Player player1 = this.player;
		Player player2 = this.relationshipToBreakUp.target;
		String chatText = this.getChat(player1,player2);

		Drawing.drawChat(querySelector("#canvas"+ (div.id)), player1, player2, chatText,"discuss_breakup.png");
	}
	String youCheatChatText(Player player1, Player player2){
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		String chatText = "";
		chatText += Scene.chatLine(player1Start, player1,"You. Asshole!");
		chatText += Scene.chatLine(player2Start, player2,"Hey?");
		var mocking = player2.quirk.translate("Hey");
		chatText += Scene.chatLine(player1Start, player1,"Don't '" + mocking + "' me. I know what you did. ");
		chatText += Scene.chatLine(player2Start, player2,"I have no idea what you are talking about!");
		String other = "";
		if(this.formerQuadrant == this.relationshipToBreakUp.heart){
			 other = player2.getHearts()[0].target.chatHandle;
		}else if(this.formerQuadrant == this.relationshipToBreakUp.diamond){
			other = player2.getDiamonds()[0].target.chatHandle;
		}else if(this.formerQuadrant == this.relationshipToBreakUp.spades){
			other = player2.getSpades()[0].target.chatHandle;
		}
		chatText += Scene.chatLine(player1Start, player1,"I know what you've been doing with " + other + ". ");
		chatText += Scene.chatLine(player2Start, player2,"Fuck.");
		chatText += Scene.chatLine(player1Start, player1,"It's over.");
		return chatText;

	}
	String meCheatChatText(Player player1, Player player2){
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		String chatText = "";
		chatText += Scene.chatLine(player1Start, player1,"Um. Hey.");
		chatText += Scene.chatLine(player2Start, player2,"Hey?");
		chatText += Scene.chatLine(player1Start, player1,"Fuck. Why's this so hard?");
		chatText += Scene.chatLine(player1Start, player1,"How do I say this?");
		chatText += Scene.chatLine(player2Start, player2,"?");
		chatText += Scene.chatLine(player1Start, player1,"We need to break up.");
		chatText += Scene.chatLine(player2Start, player2,"What!?");
		String other = "";
		if(this.formerQuadrant == this.relationshipToBreakUp.heart){
			 other = player1.getHearts()[0].target.chatHandle;
		}else if(this.formerQuadrant == this.relationshipToBreakUp.diamond){
			other = player1.getDiamonds()[0].target.chatHandle;
		}else if(this.formerQuadrant == this.relationshipToBreakUp.spades){
			other = player1.getSpades()[0].target.chatHandle;
		}
		chatText += Scene.chatLine(player1Start, player1,"I didn't mean to hurt you. It just happened. But... I'm with " + other + " now. And I didn't want to keep stringing you along.");
		chatText += Scene.chatLine(player2Start, player2,"How could you!? I thought we were special!");
		chatText += Scene.chatLine(player1Start, player1,"I'm sorry.");

		return chatText;

	}
	String meBoredChatText(Player player1, Player player2){
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		String chatText = "";
		chatText += Scene.chatLine(player1Start, player1,"Um. Hey.");
		chatText += Scene.chatLine(player2Start, player2,"Hey?");
		chatText += Scene.chatLine(player1Start, player1,"Fuck. Why's this so hard?");
		chatText += Scene.chatLine(player2Start, player2,"?");
		chatText += Scene.chatLine(player1Start, player1,"We need to break up.");
		chatText += Scene.chatLine(player2Start, player2,"What!?");
		chatText += Scene.chatLine(player1Start, player1,"I just... don't feel the same way about you anymore. Maybe we changed too much.");
		chatText += Scene.chatLine(player1Start, player1,"I'm sorry. I can't keep pretending.");
		chatText += Scene.chatLine(player2Start, player2,"Wait! No! Let's talk about this!");
		chatText += Scene.chatLine(player1Start, player1,"I've made up my mind. I'm sorry. Goodbye.");

		return chatText;
	}
	@override
	void renderContent(Element div){
		div.appendHtml("<br>"+this.content(),treeSanitizer: NodeTreeSanitizer.trusted);
		//takes up time from both of them
		session.removeAvailablePlayer(this.player);
		session.removeAvailablePlayer(relationshipToBreakUp.target);

		if(this.relationshipToBreakUp.target.dead){
			//do nothing, just text
		}else{
			this.breakupChat(div);
		}

	}
	String content(){
		this.relationshipToBreakUp.saved_type = this.relationshipToBreakUp.changeType();
		this.relationshipToBreakUp.old_type = this.relationshipToBreakUp.saved_type;
		Relationship oppRelationship = this.relationshipToBreakUp.target.getRelationshipWith(this.player);
		if(oppRelationship != null) oppRelationship.saved_type = this.relationshipToBreakUp.changeType();
		if(oppRelationship != null)oppRelationship.old_type = this.relationshipToBreakUp.saved_type;
		this.session.stats.hasBreakups = true;  //lets AB report on the hot gos
		//String ret = "TODO: Render BREAKUP between " + this.player.title() + " and " + this.relationshipToBreakUp.target.title() + " because " + this.reason ;
		if(this.relationshipToBreakUp.target.dead){
			return "The " + this.player.htmlTitleBasic() + " has finally decided it is time to move on. The " + this.relationshipToBreakUp.target.htmlTitleBasic() + " is dead. They have mourned them long enough. ";
		}
		return "";
	}



}
