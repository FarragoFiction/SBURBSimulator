import "dart:html";
import "../SBURBSim.dart";

//TODO add "try very sincerely to kill x" meme
class EngageMurderMode extends Scene{

	Player player = null;


	EngageMurderMode(Session session): super(session);


	@override
	bool trigger(List<Player> playerList){
		this.playerList = playerList;
		//select a random player. if they've been triggered, random chance of going murderMode if enemies (based on how triggered.)
		List<Player> ap = session.getReadOnlyAvailablePlayers();
		if (!ap.isEmpty) {
			this.player = rand.pickFrom(ap);
		}
		num moon = 0;

		if(this.player != null){
			return !this.player.murderMode && this.player.getEnemies().length > 0 && this.flipsShit() && this.player.aspect != Aspects.RHYME; //dude, don't engage murder mode if you're already in it
			//todo note to self: change this so that the event triggers for rhyme players, but they don't feel it's effects.
			//todo because simply preventing them from going insane won't cut it.
		}
		return false;
	}
	bool flipsShit(){
		Player diamond = this.player.hasDiamond();
		num triggerMinimum = -275;

		if(diamond != null) triggerMinimum += -1*(this.player.getRelationshipWith(diamond).value);  //hope you don't hate your moirail
		if(this.player.moon == "Prospit") triggerMinimum += 100; //easier to flip shit when you see murders in the clouds.
		bool ret = (rand.nextDouble() * this.player.getStat(Stats.SANITY) < triggerMinimum);
		//if(ret && diamond != null) //session.logger.info("flipping shit even with moirail ${this.session.session_id}");
		//if(ret) //session.logger.info("flipping shit naturally ${this.session.session_id}");
		return ret;
	}
	String grimChat2(Element div, Player player1, Player player2){
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		String chatText = "";
		chatText += Scene.chatLine(player1Start, player1,"...");
		chatText += Scene.chatLine(player2Start, player2,Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1));
		chatText += Scene.chatLine(player1Start, player1,"You're going to die. And I'm going to see it. I'm going to DO it.");
		chatText += Scene.chatLine(player2Start, player2,"I don't care. Everything in this game wants to kill me, may as well add the Players to the list.");
		chatText += Scene.chatLine(player1Start, player1,"Fuck you. You are too far gone to even CARE that I'm going to kill you.");
		return chatText;
	}
	String normalConvo(Element div, Player player1, Player player2){
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		String chatText = "";
		chatText += Scene.chatLine(player1Start, player1,"...");
		chatText += Scene.chatLine(player2Start, player2,Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1));
		chatText += Scene.chatLine(player1Start, player1,"You're going to die. And I'm going to see it. I'm going to DO it.");
		if(player1.isTroll && player1.bloodColor == "#99004d" && player2.isTroll && player2.bloodColor == "#99004d"){
			chatText += this.heirressConvo(div, player1, player2);
		}else if(player2.aspect == Aspects.BLOOD || player2.aspect == SBURBClassManager.SYLPH){  //try to repair relationship
			chatText += this.repairConvo(div, player1, player2);
		}else if(player2.aspect == Aspects.MIND || player2.class_name == SBURBClassManager.BARD ){ //try to redirect madness at another target
			chatText += this.redirectConvo(div, player1, player2);
		}else if(player2.aspect == Aspects.RAGE || player2.class_name == SBURBClassManager.KNIGHT ){ //welcome the challenge
			chatText += this.blusterConvo(div, player1, player2);
		}else{
			chatText += this.panicConvo(div, player1, player2);
		}

		return chatText;

	}
	String heirressConvo(Element div, Player player1, Player player2){
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		String chatText = "";
		chatText += Scene.chatLine(player2Start, player2,"Oh my god! Can we NOT do this right now!?");
		chatText += Scene.chatLine(player2Start, player2,"If I can ignore my biological imperitive to murder you right in your stupid face, so can you!");
		chatText += Scene.chatLine(player2Start, player2,"Why the fuck did skaia stick multiple Heiresses in the medium together!? What was the purpose? Is it crazy!?");
		chatText += Scene.chatLine(player1Start, player1,"See you soon! :)");
		chatText += Scene.chatLine(player2Start, player2,"You asshole! I thought we were friends!");
		return chatText;
	}
	String panicConvo(Element div, Player player1, Player player2){
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		String chatText = "";
		if(r2.type() == r2.badBig){
			chatText += Scene.chatLine(player2Start, player2,"Oh, fuck.");
			chatText += Scene.chatLine(player2Start, player2,"Oh, fuck. I always knew you were an asshole, but THIS!?");
			chatText += Scene.chatLine(player2Start, player2,"What the hell? Why did you snap NOW? Why ME?");
			chatText += Scene.chatLine(player1Start, player1,"See you soon! :)");
			chatText += Scene.chatLine(player2Start, player2,"Oh, god.");
		}else{
			chatText += Scene.chatLine(player2Start, player2,"Oh, fuck.");
			chatText += Scene.chatLine(player2Start, player2,"Fuck.");
			chatText += Scene.chatLine(player2Start, player2,"Fuck.");
			chatText += Scene.chatLine(player2Start, player2,"What the hell? Why did you snap NOW? Why ME?");
			chatText += Scene.chatLine(player2Start, player2,"Fuck. Please no....");
			chatText += Scene.chatLine(player1Start, player1,"See you soon! :)");
			chatText += Scene.chatLine(player2Start, player2,"Oh, god.");
		}
		return chatText;
	}
	String blusterConvo(Element div, Player player1, Player player2){
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		String chatText = "";
		if(r2.type() == r2.badBig){
			chatText += Scene.chatLine(player2Start, player2,"You want to fight, bro? Let's do it. You and me.");
			chatText += Scene.chatLine(player1Start, player1,"It won't be a fight. It'll be a goddamned MASSACRE.");
			chatText += Scene.chatLine(player2Start, player2,"You're on.");
		}else{
			chatText += Scene.chatLine(player2Start, player2,"Oh fuck.");
			chatText += Scene.chatLine(player2Start, player2,"Fuck.");
			chatText += Scene.chatLine(player2Start, player2,"You know I'm not just going to LET you kill me right?");
			chatText += Scene.chatLine(player2Start, player2,"Please don't make me kill you in self defense.");
			chatText += Scene.chatLine(player1Start, player1,"See you soon! :)");
		}

		return chatText;
	}
	String redirectConvo(Element div, Player player1, Player player2){
		List<Player> livePlayers = findLivingPlayers(this.session.players);
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		String chatText = "";

		if(r2.type() == r2.badBig){
			chatText += Scene.chatLine(player2Start, player2,"Look, I get it. I've been a flaming asshole to you.");
			chatText += Scene.chatLine(player2Start, player2,"But am I REALLY the one you want to kill FIRST?");
			Player alternative = player2.getWorstEnemyFromList(livePlayers);
			if(alternative != null){
				chatText += Scene.chatLine(player2Start, player2,"What about " + alternative.chatHandle + " ?");
				chatText += Scene.chatLine(player2Start, player2,"Haven't they been worse to you?");
				Relationship r3 = player1.getRelationshipWith(alternative);
				if(r3 == null || r3.value > 0){
					chatText += Scene.chatLine(player1Start, player1,"ARRRRRGGGH! THIS IS WHY I HATE YOU!");
					chatText += Scene.chatLine(player1Start, player1,"YOU ARE A MILLION TIMES WORSE THAN " + alternative.chatHandle.toUpperCase());
					chatText += Scene.chatLine(player1Start, player1,"Prepare to die.");
					chatText += Scene.chatLine(player2Start, player2,"Fuck. Worth a shot.");
					r1.decrease();
				}else{
					chatText += Scene.chatLine(player1Start, player1,"... Maybe. Maybe you have a point.");
					r3.decrease();
				}
			}else{
				chatText += Scene.chatLine(player1Start, player1,"No, there really isn't. Prepare to die.");
				chatText += Scene.chatLine(player2Start, player2,"Fuck. Worth a shot.");
			}
		}else if(r2.type() == r2.goodBig){
			chatText += Scene.chatLine(player2Start, player2,"But...why? I LIKE you! I've been nice to you! Why ME?") ;//alt dialogue of them realizing that htey've actually been a dick?;
			Player alternative = player2.getWorstEnemyFromList(livePlayers);
			if(alternative != null){
				chatText += Scene.chatLine(player2Start, player2,alternative.chatHandle + "is a million times worse than me! ");
				Relationship r3 = player1.getRelationshipWith(alternative);
				if(r3.value > 0){
					chatText += Scene.chatLine(player1Start, player1,"No, they really aren't. Prepare to die.");
				}else{
					chatText += Scene.chatLine(player1Start, player1,"Maybe you have a point.");
					r3.decrease();
					r1.increase();
				}
			}else{
				chatText += Scene.chatLine(player1Start, player1,"You sure haven't shown it. Prepare to die.");
			}

		}else{
			chatText += Scene.chatLine(player2Start, player2,"Oh fuck.");
			chatText += Scene.chatLine(player2Start, player2,"Okay, but, am I the best person to rage out on?");
			Player alternative = player2.getWorstEnemyFromList(livePlayers); // I assume this is needed here -PL
			if(alternative != null){
				chatText += Scene.chatLine(player2Start, player2,"What about " + alternative.chatHandle + " ?");
				chatText += Scene.chatLine(player2Start, player2,"Haven't they been worse to you?");
				Relationship r3 = player1.getRelationshipWith(alternative);
				if(r3 != null && r3.value > 0){
					chatText += Scene.chatLine(player1Start, player1,"ARRRRRGGGH! THIS IS WHY I HATE YOU!");
					chatText += Scene.chatLine(player1Start, player1,"YOU ARE A MILLION TIMES WORSE THAN " + alternative.chatHandle);
					chatText += Scene.chatLine(player1Start, player1,"Prepare to die.");
					chatText += Scene.chatLine(player2Start, player2,"Fuck. Worth a shot.");
					r1.decrease();
				}else{ //if they get here because r3 is null, then they are i guess suicidal? because that means the player is themself.
					chatText += Scene.chatLine(player1Start, player1,"... Maybe. Maybe you have a point.");
					if(r3 != null) {
						r3.decrease();
					}else {
						chatText += Scene.chatLine(player1Start, player1," Maybe I'm my own worst enemy...");
					}
				}
			}else{
				chatText += Scene.chatLine(player1Start, player1,"Prepare to die.");
				chatText += Scene.chatLine(player2Start, player2,"Fuck. Worth a shot.");
			}

		}

		return chatText;
	}
	String repairConvo(Element div, Player player1, Player player2){
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		String chatText = "";

		chatText += Scene.chatLine(player2Start, player2,"Oh, fuck.");
		chatText += Scene.chatLine(player2Start, player2,"Fuck.");
		chatText += Scene.chatLine(player2Start, player2,"Look, I get that you have trouble controling your temper.");
		chatText += Scene.chatLine(player2Start, player2,"But you can be better than that.");
		if(rand.nextDouble() > .7){
			r1.increase();
			player1.addStat(Stats.SANITY, 1);
			chatText += Scene.chatLine(player2Start, player2,"Why don't we meet up in person. We can vent about whatever's bothering you. Nobody has to do anything that can't be undone.");
			chatText += Scene.chatLine(player1Start, player1,"Fuck. Maybe. I... I need to go think about this.");
		}else{
			player1.addStat(Stats.SANITY, -10);
			r1.decrease();
			chatText += Scene.chatLine(player2Start, player2,"I mean, probably. Everybody has at least some goodness in them, right? Even you?");
			chatText += Scene.chatLine(player1Start, player1,"You asshole. Always pretending to be above it all. To be better than me.");
			chatText += Scene.chatLine(player1Start, player1,"Well try being superior when you're dead.");
		}

		return chatText;
	}
	void rapBattle(Element div, Player player1, Player player2){
		 //session.logger.info("AB:  murder rap battles :${this.session.session_id}");
		this.session.stats.rapBattle = true;
		String narration = "The " + player1.htmlTitle() + " is contemplating murder. Can their rage be soothed by a good old-fashioned rap battle?<Br>";
		appendHtml(div, narration);
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		String canvasHTML = "<br><canvas id='canvas" + (div.id) +"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
		appendHtml(div, canvasHTML);
		CanvasElement canvasDiv = querySelector("#canvas"+  (div.id));
		String chatText = "";

		chatText += Scene.chatLine(player1Start, player1,"Bro. Rap Battle. Now. Bring the Fires.");
		chatText += Scene.chatLine(player2Start, player2,"Yes. Fuck yes! Hell FUCKING yes!");
		num p1score = 0;
		num p2score = 0;
		List<dynamic> raps1 = getRapForPlayer(player1,"",0);
		chatText += raps1[0];
		p1score = raps1[1];
		List<dynamic> raps2 = getRapForPlayer(player2,"",0);
		chatText += raps2[0];
		p2score = raps1[1];
		//window.alert("about to draw raps");
		Drawing.drawChat(canvasDiv, player1, player2, chatText,"discuss_raps.png");
		if(p1score + p2score > 6){ //it's not winning that calms them down, but sick fires in general.
			////session.logger.info("rap sick fires in session: " + this.session.session_id + " score: " + (p1score + p2score))
			div.appendHtml("<img class = 'sickFiresCentered' src = 'images/sick_fires.gif'><br> It seems that the " + player1.htmlTitle() + " has been calmed down, for now.",treeSanitizer: NodeTreeSanitizer.trusted);
			if(player1.murderMode) player1.unmakeMurderMode();
			if(player2.murderMode) player2.unmakeMurderMode(); //raps calm EVERYBODY down.
			//rap battles are truly the best way to power level.
			player1.increasePower();
			player2.increasePower();
			this.session.stats.sickFires = true;
		}else{
			String canvasHTML2 = "<br><canvas id='canvas2" + (div.id) +"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML2);
			CanvasElement canvasDiv2 = querySelector("#canvas2"+  (div.id));
			String chatText2 = "";
			chatText2 += Scene.chatLine(player1Start, player1,"Fuck. That was LAME! It makes me so FUCKING ANGRY!");
			chatText2 += Scene.chatLine(player2Start, player2,"Whoa.");
			chatText2 += Scene.chatLine(player1Start, player1,"All I FUCKING wanted was one tiny rap battle, and you can't even fucking do THAT!?");
			chatText2 += Scene.chatLine(player2Start, player2,"Now wait a second...");
			chatText2 += Scene.chatLine(player1Start, player1,"Fuck it. I'm done trying to hold back. See you soon.");
			Drawing.drawChat(canvasDiv2, player1, player2, chatText2,"discuss_murder.png");
		}
	}
	void chat(Element div){
		num repeatTime = 1000;
		List<Player> livePlayers = findLivingPlayers(this.session.players);
		Player player1 = this.player;
		Player player2 = player1.getWorstEnemyFromList(livePlayers);
		if(player2 != null && !player2.dead){
			Relationship r2 = player2.getRelationshipWith(player1);
			if((r2.value < -2 && r2.value > -12 ) || InterestManager.MUSIC.playerLikes(player1)){ //only if i generically dislike you. o rlike raps
				////session.logger.info("rap battle. session: " + this.session.session_id);
				this.rapBattle(div,player1, player2);
				return; //reap battle will handle it from here.
			}
		}

		if(player2 == null || player2.dead == true){
			return;//nobody i actually want to kill??? why am i in murder mode?
		}
		String canvasHTML = "<br><canvas id='canvas" + (div.id) +"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
		appendHtml(div, canvasHTML);

		CanvasElement canvasDiv = querySelector("#canvas"+  (div.id));

		String chatText = "";
		if(player2.grimDark > 1){
			chatText += this.grimChat2(div,player1, player2);
		}else{
			chatText += this.normalConvo(div,player1, player2);
		}
		Drawing.drawChat(canvasDiv, player1, player2, chatText,"discuss_murder.png");
	}
	dynamic addImportantEvent(){
		Player current_mvp = findStrongestPlayer(this.session.players);
		return this.session.addImportantEvent(new PlayerWentMurderMode(this.session, current_mvp.getStat(Stats.POWER),this.player, null) );
	}
	@override
	void renderContent(Element div){
		var alt = this.addImportantEvent();
		if(alt != null && alt.alternateScene(div)){
			return;
		}
		//reset capitilization quirk
		this.player.quirk.capitalization = rand.nextIntRange(0,5);
		div.appendHtml("<br>"+this.content(),treeSanitizer: NodeTreeSanitizer.trusted);
		this.chat(div);
	}
	String content(){
		////session.logger.info("murder mode");
		this.player.increasePower();
		session.removeAvailablePlayer(player);
		String ret = "The " + this.player.htmlTitle() + " has taken an acrobatic fucking pirouette off the handle and into a giant pile of crazy.  ";
		ret += " They engage Murder Mode while thinking of their enemies " + getPlayersTitles(this.player.getEnemies()) + ". ";
		ret += " This is completely terrifying. ";
		Player diamond = this.player.hasDiamond();
		if(diamond != null){
			ret += " I guess their Moirail, the " + diamond.htmlTitle() + " is not on the ball. ";
		}
		this.player.makeMurderMode();
		return ret;
	}

}
