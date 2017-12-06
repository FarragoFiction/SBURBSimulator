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
			return !this.player.murderMode && this.player.getEnemies().length > 0 && this.flipsShit(); //dude, don't engage murder mode if you're already in it

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


	void rapBattle(Element div, Player player1, Player player2){
		 //session.logger.info("AB:  murder rap battles :${this.session.session_id}");
		this.session.stats.rapBattle = true;
		String narration = "The " + player1.htmlTitle() + " is contemplating murder. Can their rage be soothed by a good old-fashioned rap battle?<Br>";
		appendHtml(div, narration);
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.

		CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
		div.append(canvasDiv);
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
			CanvasElement canvasDiv2 = new CanvasElement(width: canvasWidth, height: canvasHeight);
			div.append(canvasDiv2);
			String chatText2 = "";
			chatText2 += Scene.chatLine(player1Start, player1,"Fuck. That was LAME! It makes me so FUCKING ANGRY!");
			chatText2 += Scene.chatLine(player2Start, player2,"Whoa.");
			chatText2 += Scene.chatLine(player1Start, player1,"All I FUCKING wanted was one tiny rap battle, and you can't even fucking do THAT!?");
			chatText2 += Scene.chatLine(player2Start, player2,"Now wait a second...");
			chatText2 += Scene.chatLine(player1Start, player1,"Fuck it. I'm done trying to hold back. See you soon.");
			Drawing.drawChat(canvasDiv2, player1, player2, chatText2,"discuss_murder.png");
		}
	}

	Conversation getMetaConvo(Player player1, Player player2) {
		List<PlusMinusConversationalPair> ret = new List<PlusMinusConversationalPair>();


		//greeting
		List<PlusMinusConversationalPair> first = new List<PlusMinusConversationalPair>();
		//explanation
		List<PlusMinusConversationalPair> second = new List<PlusMinusConversationalPair>();
		//threat
		List<PlusMinusConversationalPair> third = new List<PlusMinusConversationalPair>();
		//followup
		List<PlusMinusConversationalPair> fourth = new List<PlusMinusConversationalPair>();

		//generic
		first.add(new PlusMinusConversationalPair(["Hey, random text asshole.",  "You FUCKER.","Guess who, asshole."], ["Whoa. How did you contact me first?","This shouldn't be possible. I contact YOU not the other way around."],["Whoa. How did you contact me first?","This shouldn't be possible. I contact YOU not the other way around."]));
		if(player1.aspect == Aspects.RAGE) {
			second.add(new PlusMinusConversationalPair(["The power of my rage is a fucking MIRACLE isn't it?",  "It's amazing what the depths of my hatred for you can do.","Lol, Rage is a beauty, isn't it?"], ["Uh. I should have considered the whole 'rage' angle. ","Just how pissed off ARE you?"],["Uh. I should have considered the whole 'rage' angle. ","Just how pissed off ARE you?"]));
		}else if(player1.interestedInCategory(InterestManager.TECHNOLOGY)){
			second.add(new PlusMinusConversationalPair(["It REALLY wasn't hard to reverse engineer your IP address. It's not like you're behind 7 proxies or some shit.",  "Turns out SBURB is easy to hack. Who would have guessed.","Easy. I hacked it."], ["Well fuck. Just don't try to hack the game you're in. Not a good end there."],["Well fuck. Just don't try to hack the game you're in. Not a good end there."]));

		}else if(player1.aspect == Aspects.VOID){
			second.add(new PlusMinusConversationalPair(["Void shit."], ["Oh. Well, okay then.","Sounds legit.","Makes sense.", "Your story checks out."],["Oh. Well, okay then.","Sounds legit.","Makes sense.", "Your story checks out."]));

		}else{
			second.add(new PlusMinusConversationalPair(["That doesn't fucking matter.",  "Shut up shut up shut up! You never stop talking!","I don't care!"], ["..."," Whoa. Okay?"],["..."," Whoa. Okay?"]));
		}
		third.add(new PlusMinusConversationalPair(["You're going to die. And I'm going to see it. I'm going to DO it.",  "I'm gonna fucking KILL you.","You're dead fucking meat.", "I am going to kill you and dance on your fucking corpse."], ["Uh. You sure about that, buddy?","Oooookay then. Good luck with that."],["Lol, good luck finding me. I'm behind 7 universes.","Lol, omfg you do realize I'm not even in your session, right? "]));

		if(player1.aspect == Aspects.SPACE) {
			fourth.add(new PlusMinusConversationalPair(["Oh don't you worry, I'll find a way to get to you, even if I have to unlock every single Space ability to do it.",  "Yes, because physical location is SUCH A hinderence to me.","Space. Player."], ["Fuck.","Shit.", "Uh. I. Don't THINK there's actually a way for you to do spacey shit to get to me. Hopefully."],["Fuck.","Shit.", "Uh. I. Don't THINK there's actually a way for you to do spacey shit to get to me. Hopefully."]));
		}else if(player1.interestedInCategory(InterestManager.TERRIBLE)){
			fourth.add(new PlusMinusConversationalPair(["I will dedicate my god damned life to this.",  "Oh I will fucking find a way. I will DEDICATE myself to this.","Your future corpse has just volunteered to be the driving force in my life. Congratulations. "], ["... God you're so creepy."],["God, you're so creepy."]));
		}else if(player1.aspect == Aspects.DOOM){
			fourth.add(new PlusMinusConversationalPair(["Oh don't you worry, I'll figure out how to skirt the rules enough to do it. "], ["Oh. Well, okay then.","Sounds legit.","Makes sense.", "Your story checks out."],["Oh. Well, okay then.","Sounds legit.","Makes sense.", "Your story checks out."]));

		}else if(player1.class_name == SBURBClassManager.WASTE || player1.class_name == SBURBClassManager.GRACE) {
			fourth.add(new PlusMinusConversationalPair(["Actually, I'm pretty sure that if I win, then get a Rage player to gnosis 4...that I can watch you die."], ["Fuck.","Shit.","Oh fuck.", "Oh."],["Fuck.","Shit.","Oh fuck.", "Oh."]));
		}else{
			fourth.add(new PlusMinusConversationalPair(["JUST DIE!","Don't you fucking worry, I will FIND a way.","That doesn't fucking matter.",  "Shut up shut up shut up! You never stop talking!","I don't care!"], ["lol"," Good luck, I guess."],["lol"," Good luck, man"]));
		}

		ret.add(session.rand.pickFrom(first));
		ret.add(session.rand.pickFrom(second));
		ret.add(session.rand.pickFrom(third));
		ret.add(session.rand.pickFrom(fourth));

		session.logger.info("meta murder threat");
		return new Conversation(ret);
	}

	Conversation getMurdererNotValidThreatConvo(Player player1, Player player2) {
		throw "TODO";
	}

	Conversation getMurdererValidThreatConvo(Player player1, Player player2) {
		throw "TODO";
	}


	Conversation getCalmingConvo(Player player1, Player player2) {
		throw "TODO";
	}


	Conversation getMurdererConvo(Player player1, Player player2) {
		throw "TODO";
	}


	Conversation getHowKillGodConvo(Player player1, Player player2) {
		throw "TODO";
	}


	Conversation getGrim1Conv(Player player1, Player player2) {
		throw "TODO";
	}


	Conversation getGrim2Conv(Player player1, Player player2) {
		throw "TODO";
	}


	Conversation getBothGrimConv(Player player1, Player player2) {
		throw "TODO";
	}

	Conversation getHeiressConversation(Player player1, Player player2) {
		throw "TODO";
	}



	//assume positive responses are when the victim likes the murderer
	//and negative are when they don't
	Conversation getConversation(Player player1, Player player2) {
		if(session is DeadSession && session.mutator.metaHandler.metaPlayers.contains(player2)) {
			//Good luck finding me I’m behind 7 universes
			return getMetaConvo(player1, player2);
		}if(player1.isTroll && player1.bloodColor == "#99004d" && player2.isTroll && player2.bloodColor == "#99004d") {
			return getHeiressConversation(player1, player2);
		}else if(player2.grimDark > 1 && player1.grimDark >1) {
			return getBothGrimConv(player1,player2);
		}else if(player2.grimDark > 1) {
			return getGrim2Conv(player1,player2);
		}else if(player1.grimDark > 1) {
			return getGrim1Conv(player1,player2);
		}else if(player2.godTier) {
			return getHowKillGodConvo(player1,player2);
		}else if(player2.murderMode) {
			return getMurdererConvo(player1,player2);
		}else if(player2.aspect == Aspects.BLOOD) {
			return getCalmingConvo(player1,player2);
		}else if(player2.getStat(Stats.POWER) * player2.getPVPModifier("Defender") < player1.getStat(Stats.POWER)*player1.getPVPModifier("Murderer")) {
			return getMurdererValidThreatConvo(player1,player2);
		}else {
			return getMurdererNotValidThreatConvo(player1,player2);

		}
	}

	void chat(Element div){
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
		CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
		div.append(canvasDiv);

		String chatText = "";
		String player1Start = player1.chatHandleShort()+ ": ";
		String player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.

		Conversation convo = getConversation(player1, player2);
		chatText += convo.returnStringConversation(player1, player2, player1Start, player2Start, player2.getRelationshipWith(player1).value > 0);


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
