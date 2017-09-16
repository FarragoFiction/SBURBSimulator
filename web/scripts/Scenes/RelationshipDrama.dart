import "dart:html";
import "../SBURBSim.dart";


//only one player at a time.
//compare old relationship with new relationship.
class RelationshipDrama extends Scene {

	List<dynamic> dramaPlayers = [];	


	RelationshipDrama(Session session): super(session);


	@override
	bool trigger(List<Player> playerList){
		this.playerList = playerList;
		this.dramaPlayers = [];
		for(Player p in session.getReadOnlyAvailablePlayers()){
			if(p.hasRelationshipDrama() && p.dead == false && validDrama(p)){ //stop corpse confessions!
				this.dramaPlayers.add(p);
			}
		}
		return this.dramaPlayers.length > 0;
	}
	void dontCheatOnQuadrantMate(Player player, Player potentialMate){
		//session.logger.info("TODO");
		//var r = player.getRelationshipWith(potentialMate);
	}
	void dontAllowCheatingOnQuadrantMate(Player player, Player potentialMate){
		//session.logger.info("TODO");
	}
	void celebratoryRapBattle(Element div, Player player1, Player player2){
		 //session.logger.info("AB:  celebratoryRapBattle :${this.session.session_id}");
		this.session.stats.rapBattle = true;
		String divId = (div.id) + player1.id.toString();
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		String canvasHTML = "<br><canvas id='canvas" + divId +"' width='" +canvasWidth.toString() + "' height='"+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		CanvasElement canvasDiv = querySelector("#canvas"+  divId);
		String chatText = "";

		chatText += Scene.chatLine(player1Start, player1,"Bro. Rap Battle. Now. Bring the Fires. Imma show you why you suck.");
		chatText += Scene.chatLine(player2Start, player2,"Yes. Fuck yes! Hell FUCKING yes!");
		num p1score = 0;
		num p2score = 0;
		List<dynamic> raps1 = getRapForPlayer(player1,"",0);
		chatText += raps1[0];
		p1score = raps1[1];
		List<dynamic> raps2 = getRapForPlayer(player2,"",0);
		chatText += raps2[0];
		p2score = raps1[1];
		Drawing.drawChat(canvasDiv, player1, player2, chatText,"discuss_raps.png");
		if(p1score + p2score > 6){ //it's not winning that calms them down, but sick fires in general.
			////session.logger.info("rap sick fires in session: " + this.session.session_id + " score: " + (p1score + p2score))
			appendHtml(div, "<img class = 'sickFiresCentered' src = 'images/sick_fires.gif'><br> It seems that the " + player1.htmlTitle() + " has been calmed down, for now.");
			if(player1.murderMode) player1.unmakeMurderMode(); //if they WERE in murder mode, well, now they ain't.
			if(player2.murderMode) player2.unmakeMurderMode();
			//rap battles are truly the best way to power level.
			player1.increasePower();
			player2.increasePower();
			this.session.stats.sickFires = true;
		}

	}
	void confessTooManyFeeling(Element div, Player player, Player crush){
		Relationship relationship = player.getRelationshipWith(crush);
		bool makeHate = false;
		//different format for canvas code

		String chatText = "";
		Player player1 = player;
		Player player2 = crush;

		String divID = (div.id) + "_" +"confess_crush_${crush.id}${player1.id}";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		CanvasElement canvasDiv = querySelector("#canvas"+ divID);
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.

		chatText += Scene.chatLine(player1Start, player1, "So... hey.");
		chatText += Scene.chatLine(player2Start, player2, "Hey?");

		chatText += Scene.chatLine(player1Start, player1, "I feel like an asshole.");
		chatText += Scene.chatLine(player1Start, player1, "I have had so many fucking crushes. ");
		chatText += Scene.chatLine(player1Start, player1, "I'd understand if you didn't take me seriously. But I like you. A lot.");

		player1.number_confessions ++;
		player2.number_times_confessed_to ++;


		Relationship r1 = relationship;
		Relationship r2 = player2.getRelationshipWith(player1);

		if(r2.saved_type == r2.goodBig){
			chatText += Scene.chatLine(player2Start, player2,"!");
			chatText += Scene.chatLine(player2Start, player2,"Wow... I ... I feel the same way!");
			chatText += Scene.chatLine(player1Start, player1,"Holy shit! Even though I've been hitting on everybody?");
			chatText += Scene.chatLine(player2Start, player2,"Honestly, I was kind of insulted you hit on everybody BUT ME.");
			chatText += Scene.chatLine(player1Start, player1,"Holy shit.");
			this.session.stats.hasHearts = true;
			Relationship.makeHeart(player1, player2);
		}else if(r2.saved_type ==r2.badBig){
			chatText += Scene.chatLine(player2Start, player2, "lol");
			chatText += Scene.chatLine(player2Start, player2, "You really think I'm dumb enough to fall for that?");
			chatText += Scene.chatLine(player2Start, player2, "You are " + this.generateNewOpinion(r2) + "!");
			chatText += Scene.chatLine(player2Start, player2, "so fuck off!");
			makeHate = true;
			//don't set hate here. Even though player is confessing flushed, shows them with a spade 'cause now they hate their crush.
			//this is not going to go well.
		}else{
			if(player2.grimDark > 3){
				chatText += Scene.chatLine(player2Start, player2,"Your feelings are irrelevant. Your promiscuity is irrelevant.");
				chatText += Scene.chatLine(player1Start, player1,"Fuck. You're grimdark, aren't you. Fuck. I've made a huge mistake.");
				player1.addStat(Stats.SANITY, -10);
			}else{
				chatText += Scene.chatLine(player2Start, player2,"Fuck. I'm sorry. I just don't feel that way about you. ");
				if(InterestManager.ROMANTIC.playerLikes(player1) || player1.aspect == Aspects.MIND){
					chatText += Scene.chatLine(player1Start, player1,"Fuck. I'm sorry I didn't keep it to myself. ");
					if(InterestManager.ROMANTIC.playerLikes(player2)|| player2.aspect == Aspects.MIND || player2.aspect == Aspects.RAGE){
						chatText += Scene.chatLine(player2Start, player2,"Better than keeping it bottled up. ");
					}
					player1.addStat(Stats.SANITY, -10);
				}else if(player2.class_name == SBURBClassManager.BARD || player2.aspect == Aspects.RAGE || InterestManager.TERRIBLE.playerLikes(player2)){
					chatText += Scene.chatLine(player1Start, player1,"Fuck. Why don't I ever learn that people suck?");
					if(player2.class_name == SBURBClassManager.SEER || player2.aspect == Aspects.BLOOD || InterestManager.ROMANTIC.playerLikes(player2)){
						chatText += Scene.chatLine(player2Start, player2,"Holy fucking shit. And you wonder why nobody likes you? ");
						makeHate = true;  //easier to hate after so many rejections. poor eridan.
					}
					player1.addStat(Stats.SANITY, -10);
				}else if(player2.class_name == SBURBClassManager.PAGE || player2.aspect == Aspects.BLOOD || InterestManager.ACADEMIC.playerLikes(player2)){
					chatText += Scene.chatLine(player1Start, player1,"But... I was even brave and told you and everything...");
					if(player2.class_name == SBURBClassManager.KNIGHT || player2.aspect == Aspects.RAGE || InterestManager.ACADEMIC.playerLikes(player2)){
						chatText += Scene.chatLine(player2Start, player2,"Fuck. But you've been 'brave' enough to hit on EVERYBODY! ");
						chatText += Scene.chatLine(player1Start, player1,"What else am I supposed to do? Ignoring how I feel is cowardice, right?");
						chatText += Scene.chatLine(player2Start, player2,"Man, it's like your emotions are calibrated wrong. I can't just tell you 'fall in love less easily'. Fuck.");
						player1.addStat(Stats.SANITY, -10);
					}else{
						chatText += Scene.chatLine(player2Start, player2,"I don't know what to tell you. ");
						chatText += Scene.chatLine(player1Start, player1,"Fuck");
					}

				}else{
					chatText += Scene.chatLine(player1Start, player1,"Oh. Yes. That's what I expected.");
					player1.addStat(Stats.SANITY, -10);
				}
			}

			if(player2.number_times_confessed_to > 3){
				chatText += Scene.chatLine(player2Start, player2,"What is it with everybody having a crush on me? ");
			}
		}
		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;
		Drawing.drawRelationshipChat(canvasDiv, player1, player2, chatText);

		if(makeHate == true){
			player1.addStat(Stats.SANITY, -10);
			r1.value = -20;
		}

	}
	void confessFeelings(Element div, Player player, Player crush){
		//debug("confession!!!");
		Relationship relationship = player.getRelationshipWith(crush);
		bool makeHate = false;

		//different format for canvas code

		String chatText = "";
		Player player1 = player;
		Player player2 = crush;
		//already set player unavailable
		session.removeAvailablePlayer(crush);

		if(crush.dead == true){
			String narration = "<br>The " + player.htmlTitle() + " used to think that the " + crush.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			narration += " It's especially tragic that they didn't realize this until the " + crush.htmlTitle() + " died.";
			appendHtml(div, narration);
			return;
		}
		if(player1.number_confessions > 3){
			//alert("why can't I hold all these feels?");
			this.confessTooManyFeeling(div, player, crush); //don't just keep spinning your wheels.
			return;
		}
		String divID = (div.id) + "_${player1.id}confess_crush_${crush.id}";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		CanvasElement canvasDiv = querySelector("#canvas"+ divID);
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.

		chatText += Scene.chatLine(player1Start, player1, "So... hey.");
		chatText += Scene.chatLine(player2Start, player2, "Hey?");
		chatText += Scene.chatLine(player1Start, player1, "I have no idea how to say this so I'm just going to do it.");
		chatText += Scene.chatLine(player2Start, player2, "?");
		chatText += Scene.chatLine(player1Start, player1, "I like you.  Romantically.");
		player1.number_confessions ++;
		player2.number_times_confessed_to ++;
		Relationship r1 = relationship;
		Relationship r2 = player2.getRelationshipWith(player1);

		if(r2.saved_type == r2.goodBig){
			chatText += Scene.chatLine(player2Start, player2,"!");
			chatText += Scene.chatLine(player2Start, player2,"Wow... I ... I feel the same way!");
			chatText += Scene.chatLine(player1Start, player1,"Holy shit!");
			Relationship.makeHeart(player1, player2);
			this.session.stats.hasHearts = true;
		}else if(r2.saved_type ==r2.badBig){
			chatText += Scene.chatLine(player2Start, player2, "lol");
			chatText += Scene.chatLine(player2Start, player2, "Well, I think YOU are " + this.generateNewOpinion(r2) + "!");
			chatText += Scene.chatLine(player2Start, player2, "so fuck off!");
			makeHate = true;
			//don't set hate here. Even though player is confessing flushed, shows them with a spade 'cause now they hate their crush.
			//this is not going to go well.
		}else{
			if(player2.grimDark  > 3){
				chatText += Scene.chatLine(player2Start, player2,"Your feelings are irrelevant. ");
				chatText += Scene.chatLine(player1Start, player1,"Fuck. You're grimdark, aren't you. Fuck.");
				player1.addStat(Stats.SANITY, -10);
			}else{
				chatText += Scene.chatLine(player2Start, player2,"Fuck. I'm sorry. I just don't feel that way about you. ");
				if(InterestManager.ROMANTIC.playerLikes(player1) || player1.aspect == Aspects.MIND){
					chatText += Scene.chatLine(player1Start, player1,"Fuck. Thanks for being honest. ");
					player1.addStat(Stats.SANITY, -0.5); //not triggered MUCH, but keeps them from continuing to confess to other people. I mean. Hypothetically.
				}else if(player2.class_name == SBURBClassManager.BARD || player2.aspect == Aspects.RAGE || InterestManager.TERRIBLE.playerLikes(player2)){
					chatText += Scene.chatLine(player1Start, player1,"But... but...WHY!? I tried so hard to be nice to you!");
					if(player2.class_name == SBURBClassManager.SEER || player2.aspect == Aspects.BLOOD || InterestManager.ROMANTIC.playerLikes(player2)){
						chatText += player2Start+"  Look, I'll level with you. I'm even dropping my dumb quirk, okay? It doesn't matter if you're nice. I'm sorry.  I can't just change the way I feel just because maybe you deserve it.\n";
					}else{
						chatText += Scene.chatLine(player2Start, player2,"Fuck. I just don't. I'm sorry. ");
					}
					chatText += Scene.chatLine(player1Start, player1,"Fuck.");
					player1.addStat(Stats.SANITY, -0.5);
				}else if(player1.class_name == SBURBClassManager.PAGE || player1.aspect == Aspects.BLOOD || InterestManager.ACADEMIC.playerLikes(player1)){
					chatText += Scene.chatLine(player1Start, player1,"But... I was even brave and told you and everything...");
					if(player2.class_name == SBURBClassManager.KNIGHT || player2.aspect == Aspects.RAGE || InterestManager.CULTURE.playerLikes(player2)){
						chatText += Scene.chatLine(player2Start, player2,"And that's really impressive! But... I can't MAKE myself like you back? You know? ");
						chatText += Scene.chatLine(player1Start, player1,"I know...");
					}else if(player2.class_name == SBURBClassManager.PAGE || player2.aspect == Aspects.BLOOD || InterestManager.ACADEMIC.playerLikes(player2)){
						chatText += Scene.chatLine(player2Start, player2,"And I get that! And I wish I liked you back. But I don't.");
						chatText += Scene.chatLine(player1Start, player1,"Fuck.");
					}else{
						chatText += Scene.chatLine(player2Start, player2,"I don't know what to tell you. ");
						chatText += Scene.chatLine(player1Start, player1,"Fuck");
					}

				}else{
					chatText += Scene.chatLine(player1Start, player1,"Oh.");
					player1.addStat(Stats.SANITY, -0.5);
				}
			}
			if(player2.number_times_confessed_to > 3){
				chatText += Scene.chatLine(player2Start, player2,"What is it with everybody having a crush on me? ");
			}
			player1.increasePower();
			player2.increasePower();

		}

		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;
		Drawing.drawRelationshipChat(canvasDiv, player1, player2, chatText);
		if(makeHate == true){
			player1.addStat(Stats.SANITY, -10);
			r1.value = -20;
		}
	}
	void corpseVent(Element div, Player player1, Player player2, Player crush){
		//alert("tell jadedResearcher you saw  corpse vent in session: " + this.session.session_id);
		Relationship relationship = player1.getRelationshipWith(crush);
		String chatText = "";

		String divID = (div.id) + "_${player1.id}advice_crush_${player1.id}";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		//different format for canvas code
		CanvasElement canvasDiv = querySelector("#canvas"+ divID);
		player1.addStat(Stats.SANITY, 1);;  //talking about it helps.
		String player1Start = player1.chatHandleShort()+ ": ";
		//String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = relationship;
		Relationship r2 = player2.getRelationshipWith(player1);
		chatText = "";
		String trait = Interest.getUnsharedCategoryWordForPlayers(player1, crush, false);
		chatText += Scene.chatLine(player1Start, player1,Relationship.getRelationshipFlavorGreeting(r1, r2, player1, player2));
		chatText += Scene.chatLine(player1Start, player1,"So... " + crush.chatHandle + ", they are " + this.generateNewOpinion(r1) + ", you know?");
		chatText += Scene.chatLine(player1Start, player1,"Shit...I just want to punch them in their " + trait + " face.");
		chatText += Scene.chatLine(player1Start, player1,"Fuck. I need to just avoid them. This stupid game is dangerous enough without me flying off the handle. ");
		chatText += Scene.chatLine(player1Start, player1,"You're always so good at advice.  Thanks!");
		Drawing.drawChat(canvasDiv, player1, player2, chatText,"discuss_hatemance.png");
	}
	void corpseAdvice(Element div, Player player1, Player player2, Player crush){
		//alert("tell jadedResearcher you saw corpse advice in session: " + this.session.session_id);
		Relationship relationship = player1.getRelationshipWith(crush);
		String chatText = "";

		String divID = (div.id) + "_${player1.id}advice_crush_${crush.id}";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		//different format for canvas code
		CanvasElement canvasDiv = querySelector("#canvas"+ divID);
		player1.addStat(Stats.SANITY, 1);  //talking about it helps.
		String player1Start = player1.chatHandleShort()+ ": ";
		//String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = relationship;
		Relationship r2 = player2.getRelationshipWith(player1);
		 chatText = "";
		////session.logger.info("player1: " + player1.title() + 'player2: ' + player2.title())
		String trait = Interest.getSharedCategoryWordForPlayers(player1, crush,true);
		chatText += Scene.chatLine(player1Start, player1,Relationship.getRelationshipFlavorGreeting(r1, r2, player1, player2));
		chatText += Scene.chatLine(player1Start, player1,"So... " + crush.chatHandle + ", they are " + this.generateNewOpinion(r1) + ", you know?");
	  chatText += Scene.chatLine(player1Start, player1,"Like, maybe I didn't see that at first, but now all I can do is think about how " + trait + " they are.");
		chatText += Scene.chatLine(player1Start, player1,"Shit... maybe I should just tell them? God, why is it so hard being in love. It's hard and nobody understands.");
		chatText += Scene.chatLine(player1Start, player1,"You're right. I'm going to tell them. Soon. When the time is right. ");
		chatText += Scene.chatLine(player1Start, player1,"You're always so good at advice.  Thanks!");
		Drawing.drawChat(canvasDiv, player1, player2, chatText,"discuss_romance.png");
	}
	void relationshipAdvice(Element div, Player player, Player crush){
		Relationship relationship = player.getRelationshipWith(crush);


		String chatText = "";
		Player player1 = player;
		Player player2 = this.getBestFriendBesidesCrush(player, crush); //this is currently returnin the crush in question. why?

		if(player2 == null || player2 == crush){
			String narration = "<br>The " + player.htmlTitle() + " used to think that the " + crush.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			if(crush.dead == true){
				narration += " It's especially tragic that they didn't realize this until the " + crush.htmlTitle() + " died.";
			}
			narration += " It's a shame the " + player.htmlTitle() + " has nobody to talk to about this. ";
			appendHtml(div, narration);
			return;
		}
		if(player2.dead == true){
			this.corpseAdvice(div,player1,player2,crush);
			return;
		}
		session.removeAvailablePlayer(player2);

		String divID = (div.id) + "_${player.id}advice_crush_${crush.id}";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		//different format for canvas code
		CanvasElement canvasDiv = querySelector("#canvas$divID");
		player.addStat(Stats.SANITY, 3);  //talking about it helps.
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = relationship;
		Relationship r2 = player2.getRelationshipWith(player1);
		Relationship r2crush = player2.getRelationshipWith(crush);  //sometimes crush is same as best friend...despite all my best efforts.
     ////session.logger.info("Crush: " + crush.title()) //these are occasionally the same despite my best efforts
		 ////session.logger.info("Player2: " + player2.title())

		//alert("I am: " + player2.title() + " and my relationship with : " + crush.title() + " is being checked")
		 chatText = "";

		chatText += Scene.chatLine(player1Start, player1,Relationship.getRelationshipFlavorGreeting(r1, r2, player1, player2));
		chatText += Scene.chatLine(player2Start, player2,Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1));
		chatText += Scene.chatLine(player1Start, player1,"So... " + crush.chatHandle + ", they are " + this.generateNewOpinion(r1) + ", you know?");
		if(crush.dead == true){
			player.addStat(Stats.SANITY, -20);  //still hurts that they are dead.
			chatText += Scene.chatLine(player2Start, player2,"Oh my god, you know they are dead, right?");
			chatText += Scene.chatLine(player1Start, player1,"Yeah. Fuck. Why didn't I notice them sooner?");
			chatText += Scene.chatLine(player2Start, player2,"Fuck. That sucks. I'm here for you.");
			chatText += Scene.chatLine(player1Start, player1,"Thanks. Fuck. This game sucks.");
			chatText += Scene.chatLine(player2Start, player2,"It really, really does.");
		}else{
			if(r2crush != null && r2crush.saved_type == r2crush.goodBig){ //best friend has a crush on them, too.
				//try to put aside feelings
				if(player2.class_name == SBURBClassManager.PAGE || player2.class_name == SBURBClassManager.MAID || player2.class_name == SBURBClassManager.SYLPH || player2.aspect == Aspects.BLOOD){
					chatText += Scene.chatLine(player2Start, player2,"Wow! You should definitely, definitely tell them that! Right away!");
					chatText += Scene.chatLine(player1Start, player1,"You think so?");
					chatText += Scene.chatLine(player2Start, player2,"Absolutely.");
				}else if(player2.class_name == SBURBClassManager.KNIGHT || player2.class_name == SBURBClassManager.SEER || player2.class_name == SBURBClassManager.HEIR || player2.aspect == Aspects.MIND){ //fight player1
					chatText += Scene.chatLine(player2Start, player2,"Fuck! I like them, too.");
					chatText += Scene.chatLine(player1Start, player1,"Well, fuck.");
					chatText += Scene.chatLine(player1Start, player1,"At least we have good taste?");
				}else{  //try to ignore feelings
					chatText += Scene.chatLine(player2Start, player2,"Oh?");
					chatText += Scene.chatLine(player2Start, player2,"I, hadn't noticed?");
					chatText += Scene.chatLine(player2Start, player2,"I guess I can see that. If that's your thing.");
					chatText += Scene.chatLine(player1Start, player1,"They are amazing...");
					r2.decrease();
				}
			}else if(r2crush != null && r2crush.saved_type == r2crush.badBig){ //friend thinks they are an asshole.
				if(player2.class_name == SBURBClassManager.PAGE || player2.class_name == SBURBClassManager.MAID || player2.class_name == SBURBClassManager.SYLPH || player2.aspect == Aspects.BLOOD){
					chatText += Scene.chatLine(player2Start, player2,"Wow! Huh. You should follow your heart.");
					chatText += Scene.chatLine(player1Start, player1,"You think so?");
					chatText += Scene.chatLine(player2Start, player2,"Absolutely.");
				}else if(player2.class_name == SBURBClassManager.KNIGHT || player2.class_name == SBURBClassManager.SEER || player2.class_name == SBURBClassManager.HEIR || player2.aspect == Aspects.MIND){ //fight player1
					chatText += Scene.chatLine(player2Start, player2,"Gonna be honest, I think they are " + this.generateNewOpinion(r2crush)  + ".");
					chatText += Scene.chatLine(player2Start, player2,"Sure you can't do better?");
					chatText += Scene.chatLine(player1Start, player1,"Screw you, you're just jealous.");
					r1.decrease();
				}else{  //try to ignore feelings
					chatText += Scene.chatLine(player2Start, player2,"Oh?");
					chatText += Scene.chatLine(player2Start, player2,"Congratulations?");
					chatText += Scene.chatLine(player2Start, player2,"I wish you the best of luck.");
					chatText += Scene.chatLine(player1Start, player1,"Thank you!");
				}
			}else{  //friend has no particular opinion about the crush.
				if(r2crush != null && r2.saved_type == r2crush.goodBig){  //but has a crush on the player (du-DUH!)
					//try to put aside feelings
					if(player2.class_name == SBURBClassManager.PAGE || player2.class_name == SBURBClassManager.MAID || player2.class_name == SBURBClassManager.SYLPH || player2.aspect == Aspects.BLOOD){
						chatText += Scene.chatLine(player2Start, player2,"Wow! You should definitely, definitely tell them that! Right away!");
						chatText += Scene.chatLine(player1Start, player1,"You think so?");
						chatText += Scene.chatLine(player2Start, player2,"Absolutely.");
					}else if(player2.class_name == SBURBClassManager.KNIGHT || player2.class_name == SBURBClassManager.SEER || player2.class_name == SBURBClassManager.HEIR || player2.aspect == Aspects.MIND){ //fight player1
						chatText += Scene.chatLine(player2Start, player2,"Fuck! Um... Okay, I hate to do this to you...but...I think you're " + this.generateNewOpinion(r2) + ".");
						chatText += Scene.chatLine(player1Start, player1,"Oh!");
						chatText += Scene.chatLine(player1Start, player1,"Um...");
						if(r1.saved_type == r1.goodBig){
							chatText += Scene.chatLine(player1Start, player1,"I... kind of like you, too?");
							chatText += Scene.chatLine(player1Start, player1,"I assumed you wouldn't like me back, God, this is so awkward.");
							chatText += Scene.chatLine(player2Start, player2,"Holy shit.");
							Relationship.makeHeart(player1, player2);
						}else{
							chatText += Scene.chatLine(player1Start, player1,"Fuck. I'm sorry. I just don't feel that way about you. ");
							chatText += Scene.chatLine(player2Start, player2,"Yeah. I kind of figured. But, I wanted to get that off my chest. ");
						}
					}else{  //try to ignore feelings
						chatText += Scene.chatLine(player2Start, player2,"Oh?");
						chatText += Scene.chatLine(player2Start, player2,"That's cool.");
						chatText += Scene.chatLine(player2Start, player2,"Yeah, that sure is a thing you just confided to me.");
						chatText += Scene.chatLine(player2Start, player2,"Glad you can trust me with this?");
						chatText += Scene.chatLine(player1Start, player1,"I couldn't keep it bottled up anymore...");
					}
				}else{  //generic advice
					chatText += Scene.chatLine(player2Start, player2,"Cool! What do you like about them?");
					var trait = Interest.getSharedCategoryWordForPlayers(player1, crush,true);
					chatText += Scene.chatLine(player1Start, player1,"They are just so...so...so " + trait);
					if(trait != "nice"){
						chatText += Scene.chatLine(player2Start, player2,"Heh, they sound perfect for you, then.");
						chatText += Scene.chatLine(player1Start, player1,"Thanks!");
					}else{
						chatText += Scene.chatLine(player2Start, player2,"Huh. Do you actually KNOW anything about them?");
						chatText += Scene.chatLine(player1Start, player1,"I'm getting there!");
					}

					//TODO maybe have another scene where they get a second chance at confessing, even if it's not fresh drama?
				}
			}
		}
		Drawing.drawChat(canvasDiv, player1, player2, chatText,"discuss_romance.png");
		player1.increasePower();
		player2.increasePower();
	}
	void ventAboutJerk(Element div, Player player, Player jerk){
		Relationship relationship = player.getRelationshipWith(jerk);

        relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;


		String chatText = "";
		Player player1 = player;
		Player player2 = this.getBestFriendBesidesCrush(player, jerk); //allowing them to be dead is funny

		if(player2 == null){
			String narration = "<br>The " + player.htmlTitle() + " used to think that the " + relationship.target.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			if(jerk.dead == true){
				narration += " It's hard for the " + player.htmlTitle() + " to care that they died.";
			}
			narration += " It's a shame the " + player.htmlTitle() + " has nobody to talk to about this. ";
			appendHtml(div, narration);
			return;
		}

		if(player2.dead == true){
			this.corpseVent(div,player1,player2, jerk);
			return;
		}
		session.removeAvailablePlayer(player2);
		String divID = (div.id) + "_${player1.id}vent_jerk_${jerk.id}";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		//different format for canvas code
		CanvasElement canvasDiv = querySelector("#canvas"+ divID);
		player.addStat(Stats.SANITY, 3);  //talking about it helps.
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = relationship;
		Relationship r2 = player2.getRelationshipWith(player1);
		Relationship r2jerk = player2.getRelationshipWith(jerk);
		if(r2jerk == null){
			//session.logger.info("I am : " + player2.title() + " and jerk is: " + jerk.title() + " and apparently I don't know them. ");
		}
		 chatText = "";
		var trait =Interest.getUnsharedCategoryWordForPlayers(player1, jerk, false);
		chatText += Scene.chatLine(player1Start, player1,Relationship.getRelationshipFlavorGreeting(r1, r2, player1, player2));
		chatText += Scene.chatLine(player2Start, player2,Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1));
		chatText += Scene.chatLine(player1Start, player1,"Oh my god, I can't STAND " + jerk.chatHandle + ", they are " + this.generateNewOpinion(r1) + ", you know?");
		if(jerk.dead == true){
			chatText += Scene.chatLine(player2Start, player2,"Do you really want to speak ill of the dead?");
			if( r2jerk != null && r2jerk.value < 0){
				chatText += Scene.chatLine(player2Start, player2,"But yeah, they were an asshole.");
				chatText += Scene.chatLine(player1Start, player1,"I know, right?");
			}else{
				chatText += Scene.chatLine(player1Start, player1,"Yeah, I kind of feel like an asshole, now");
			}
		}else{
			if(r2jerk != null && r2jerk.saved_type == r2jerk.badBig){
				chatText += Scene.chatLine(player2Start, player2,"Oh my god, I know, right?");
				chatText += Scene.chatLine(player2Start, player2,"I can't freaking stand them.");
				chatText += Scene.chatLine(player1Start, player1,"Represent.");
			}else if(r2jerk != null && r2jerk.saved_type == r2jerk.goodBig){
				chatText += Scene.chatLine(player2Start, player2,"!");
				chatText += Scene.chatLine(player2Start, player2,"Really?");
				chatText += Scene.chatLine(player2Start, player2,"I like them okay...");
				chatText += Scene.chatLine(player1Start, player1,"Great, now I have to question all your life decisions.");
			}else{
				chatText += Scene.chatLine(player2Start, player2,"Eh, they're okay.");
				if(player2.isTroll == false && player1.isTroll == true){
					chatText += Scene.chatLine(player2Start, player2,"Wait!  Is this a spades thing? That's a thing trolls do, right?");
					chatText += Scene.chatLine(player1Start, player1,"Oh. My. God. Just because I am a troll doesn't mean I have a black crush on every asshole that passes by.");
					chatText += Scene.chatLine(player2Start, player2,"Geez, sorry...");
				}else if(player2.isTroll == true && player1.isTroll == false){
					chatText += Scene.chatLine(player2Start, player2,"If that's what you're into, I mean. I can't see it.");
					chatText += Scene.chatLine(player1Start, player1,"Wait, what? Oh! No! Geez, I'm HUMAN, remember!? I do NOT have some weird troll crush on this " + trait + " asshole.");
					chatText += Scene.chatLine(player2Start, player2,"Geez, sorry...");
				}else{
					chatText += Scene.chatLine(player2Start, player2,"Why do you hate them so much?");

					chatText += Scene.chatLine(player1Start, player1,"They are just so... so... " + trait +"! That's all there is to say on the matter.");
					if(player2.isTroll == true && player1.isTroll == true){
						chatText += Scene.chatLine(player2Start, player2,"Whatever floats your boat.");
						chatText += Scene.chatLine(player1Start, player1,"Oh god... is this really coming off as a black crush?");
						chatText += Scene.chatLine(player1Start, player1,"Fuck. I hope it's not one.");
					}
				}
			}
		}
		Drawing.drawChat(canvasDiv, player1, player2, chatText,"discuss_hatemance.png");
		player1.increasePower();
		player2.increasePower();

	}
	void antagonizeJerk(Element div, Player player, Player jerk){
		//debug("antagonizing a jerk.") //is this ever even happening???

        Relationship relationship = player.getRelationshipWith(jerk);
		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;



		if(jerk.dead == true){
			String narration = "<br>The " + player.htmlTitle() + " used to think that the " + relationship.target.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			narration += "It's hard for the " + player.htmlTitle() + " to care that they died.";
			appendHtml(div, narration);
			return;
		}
		session.removeAvailablePlayer(jerk);
		String divID = (div.id) + "_${player.id}antagonize_jerk_${jerk.id}";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(div, canvasHTML);
		CanvasElement canvasDiv = querySelector("#canvas"+ divID);
		//different format for canvas code
		String chatText = "";
		Player player1 = player;
		Player player2 = jerk;
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = relationship;
		Relationship r2 = player2.getRelationshipWith(player1);
		chatText = "";

		chatText += Scene.chatLine(player1Start, player1,Relationship.getRelationshipFlavorGreeting(r1, r2, player1, player2));
		chatText += Scene.chatLine(player2Start, player2,Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1));
		chatText += Scene.chatLine(player1Start, player1,"You are " + this.generateNewOpinion(r1) + ", you know that?");
		r2.decrease();
		if(r2.saved_type == r2.badBig){
			chatText += Scene.chatLine(player2Start, player2,"The feeling is mutual, asshole. ");
			chatText += Scene.chatLine(player2Start, player2,"You are " + this.generateNewOpinion(r2) + ", times a million.");
			var trait = Interest.getUnsharedCategoryWordForPlayers(player1, player2, false);
			var trait2 = Interest.getUnsharedCategoryWordForPlayers(player2, player1, false);
			chatText += Scene.chatLine(player1Start, player1,"God, why are you so " + trait + "?");
			chatText += Scene.chatLine(player2Start, player2,"Fuck you, at least I'm not " + trait2 + "!");
			Relationship.makeSpades(player1, player2);
			this.session.stats.hasSpades = true;
			if(rand.nextDouble() > .5){
				this.celebratoryRapBattle(div, player1, player2);
			}

		}else if(r2.type == r2.goodBig){
			chatText += Scene.chatLine(player2Start, player2,"Wow. Yes. Way to be an asshole. ");
			var trait = Interest.getUnsharedCategoryWordForPlayers(player1, player2, false);
			chatText += Scene.chatLine(player1Start, player1,"God, why are you so " + trait + "?");
			chatText += Scene.chatLine(player2Start, player2,"And that's my cue to leave this chat. ");
			r2.decrease();
			r2.decrease();//broken heart
		}else{
			chatText += Scene.chatLine(player2Start, player2,"Holy shit. ");
			chatText += Scene.chatLine(player2Start, player2,"And here I thought you were " + this.generateNewOpinion(r2) + ".");
			if(player2.isTroll == true){
				chatText += Scene.chatLine(player2Start, player2,"I just don't hate you enough. ");
				if(player1.isTroll == true){
					chatText += Scene.chatLine(player1Start, player1,"Fuck.");
				}else{
					chatText += Scene.chatLine(player1Start, player1,"Wait. What!? Oh GOD, no! I am a HUMAN you dumb fuck! I DO NOT HAVE A CRUSH ON YOU!");
				}
			}else{
				if(player1.isTroll == true){
					chatText += Scene.chatLine(player1Start, player1,"Fuck.");

				}
			}
		}
		Drawing.drawRelationshipChat(canvasDiv, player1, player2, chatText);
		player1.increasePower();
		player2.increasePower();
	}
	Player getBestFriendBesidesCrush(Player player, Player crush){
		List<Player> living = findLivingPlayers(this.session.players);
		List<Player> dead = findDeadPlayers(this.session.players);
		List<Player> players = living;//new List.from(living);
		players.addAll(dead);
		////session.logger.info("living: " + living.length + "dead: " + dead.length + " both: " + players.length);
		//alert("removing crush: " + crush.title() + " from array: " + living.length)
		removeFromArray(crush, players);
		//alert("removed crush: " + crush.title() + " from array: " + living.length)
		if(players.length>0){
			return player.getBestFriendFromList(players,"getLivingBestFriendBesidesCrush $players");
		}
		return null;
	}
	Player getLivingBestFriendBesidesCrush(Player player, Player crush){
		List<Player> living = findLivingPlayers(this.session.players);
		//alert("removing crush: " + crush.title() + " from array: " + living.length)
		removeFromArray(crush, living);
		//alert("removed crush: " + crush.title() + " from array: " + living.length)
		if(living.length>0){
			return player.getBestFriendFromList(living,"getLivingBestFriendBesidesCrush $living");
		}
		return null;
	}


	//trying to debug this so made it but what is going on?
	bool validDrama(Player player) {
	    return true;
		List<Relationship> relationships = player.getRelationshipDrama();

		for(int j = 0; j<relationships.length; j++){
			Relationship r = relationships[j];
			if(r.type() == r.goodBig){
				return true;
			}else if(r.type() == r.badBig){
				return true;
			}else{
                r.drama = false; //i guess it was a break up?
            }

		}
		return false;
	}

	void renderForPlayer(Element div, Player player){
		//Player player1 = player;
		List<Relationship> relationships = player.getRelationshipDrama();

		for(int j = 0; j<relationships.length; j++){
			Relationship r = relationships[j];
			if(r.type() == r.goodBig){
				if(player.getStat(Stats.SANITY) > 1){
					this.confessFeelings(div, player, r.target);
				}else{
					this.relationshipAdvice(div, player, r.target);
				}
			}else if(r.type() == r.badBig){
				if(player.getStat(Stats.SANITY) > 1){
					this.ventAboutJerk(div, player, r.target);
				}else{
					this.antagonizeJerk(div, player, r.target); //not thinking clearly, gonna start shit.
				}
			}else{
				//narration. but is it really worth it for something so small?
				//debug("tiny drama")
			}

		}
	}

	@override
	void renderContent(Element div){
		//appendHtml(div, this.content());
		for(int i = 0; i<this.dramaPlayers.length; i++){

				Player p = this.dramaPlayers[i];
				//take up time for other player once i know who they are.
				session.removeAvailablePlayer(p);//how did i forget to make this take a turn? that's the whole point, romance distracts you from shit. won't make it distract your partner, tho.

				this.renderForPlayer(div, p);
			}
	}
	String matchTypeToOpinion(String type, Relationship relationship){
		if(type == relationship.badBig){
			return rand.pickFrom(bigBadDesc);
		}

		if(type == relationship.badMild){
			return rand.pickFrom(bigMildDesc);
		}

		if(type == relationship.goodBig){
			return rand.pickFrom(goodBigDesc);
		}

		if(type == relationship.goodMild){;
			return rand.pickFrom(goodMildDesc);
		}

		return "okay";
	}
	String generateOldOpinion(Relationship relationship){
		return this.matchTypeToOpinion(relationship.old_type, relationship);
	}
	String generateNewOpinion(Relationship relationship){
		return this.matchTypeToOpinion(relationship.saved_type, relationship);
	}
	String processDrama(Player player, Relationship relationship){
		String ret = "<img src = 'images/sceneIcons/heart_icon.png'> The " + player.htmlTitle() + " used to think that the " + relationship.target.htmlTitle() + " was ";
		ret += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";

		if(relationship.saved_type == relationship.goodBig && relationship.target.dead){
			player.addStat(Stats.SANITY, -10);
			ret += " They are especially devestated to realize this only after the " + relationship.target.htmlTitle() + " died. ";
		}
		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;
		return ret;

	}
	String content(){
		//describe what the drama is.  if the drama player is dead, skip.  if their target is dead, comment on that. (extra drama.  Only when he is a corpse do you realize...you love him.)
		String ret = " ";
		if(this.dramaPlayers.length > 2){
			ret += " So much drama has been going on. You don't even know. ";
		}
		for(num i = 0; i< this.dramaPlayers.length; i++){
			var p = this.dramaPlayers[i];
			List<Relationship> relationships = p.getRelationshipDrama();
			for(num j = 0; j<relationships.length; j++){
				ret += this.processDrama(p, relationships[j]);
			}

		}
		return ret;
	}

}
