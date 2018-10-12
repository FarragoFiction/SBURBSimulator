import "dart:html";
import "../../SBURBSim.dart";

//TODO add "try very sincerely to kill x" meme
class EngageMurderMode extends Scene{

	Player player = null;
	List<String> deathThreats = <String>["You're going to die. And I'm going to see it. I'm going to DO it.",  "I'm gonna fucking KILL you.","You're dead fucking meat.", "I am going to kill you and dance on your fucking corpse.","I'm going to paint the wicked pictures with your blood.","Knife goes in. Blood comes out. Your blood.","You're going to respect me if I have to wear your severed head as a hat.","Fuck you fuck it fuck you they laugh and you don’t understand I need to make you understand fuck it. You will be blood.","You're a corpse."];


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
		num triggerMinimum = -2222;

		if(diamond != null) triggerMinimum += -10*(this.player.getRelationshipWith(diamond).value);  //hope you don't hate your moirail
		if(this.player.moon == "Prospit") triggerMinimum += 100; //easier to flip shit when you see murders in the clouds.
		double randomDouble = rand.nextDouble();
		num sanity = player.getStat(Stats.SANITY);
		bool ret = (randomDouble * sanity < triggerMinimum);
		/*
		if(ret) {
			print(" i should flip my shit and go murdermode when the random is $randomDouble and my sanity is $sanity and the minimum is $triggerMinimum");
		}*/
		//if(ret && diamond != null) //session.logger.info("flipping shit even with moirail ${this.session.session_id}");
		//if(ret) //session.logger.info("flipping shit naturally ${this.session.session_id}");
		return ret;
	}


	void rapBattle(Element div, Player player1, Player player2){
		 //session.logger.info("Engage Murder:   murder rap battles ");
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
		PlusMinusConversationalPair first;
		//explanation
		PlusMinusConversationalPair second;
		//threat
		PlusMinusConversationalPair third;
		//followup
		PlusMinusConversationalPair fourth;

		//generic
		first = (new PlusMinusConversationalPair(<String>["Hey, random text asshole.",  "You FUCKER.","Guess who, asshole."], <String>["Whoa. How did you contact me first?","This shouldn't be possible. I contact YOU not the other way around."],<String>["Whoa. How did you contact me first?","This shouldn't be possible. I contact YOU not the other way around."]));
		if(player1.aspect == Aspects.RAGE) {
			second = (new PlusMinusConversationalPair(<String>["The power of my rage is a fucking MIRACLE isn't it?",  "It's amazing what the depths of my hatred for you can do.","Lol, Rage is a beauty, isn't it?"], <String>["Uh. I should have considered the whole 'rage' angle. ","Just how pissed off ARE you?"],<String>["Uh. I should have considered the whole 'rage' angle. ","Just how pissed off ARE you?"]));
		}else if(player1.interestedInCategory(InterestManager.TECHNOLOGY)){
			second = (new PlusMinusConversationalPair(<String>["It REALLY wasn't hard to reverse engineer your IP address. It's not like you're behind 7 proxies or some shit.",  "Turns out SBURB is easy to hack. Who would have guessed.","Easy. I hacked it."], <String>["Well fuck. Just don't try to hack the game you're in. Not a good end there."],<String>["Well fuck. Just don't try to hack the game you're in. Not a good end there."]));

		}else if(player1.aspect == Aspects.VOID){
			second =(new PlusMinusConversationalPair(<String>["Void shit."], <String>["Oh. Well, okay then.","Sounds legit.","Makes sense.", "Your story checks out."],<String>["Oh. Well, okay then.","Sounds legit.","Makes sense.", "Your story checks out."]));

		}else{
			second =(new PlusMinusConversationalPair(<String>["That doesn't fucking matter.",  "Shut up shut up shut up! You never stop talking!","I don't care!"], <String>["..."," Whoa. Okay?"],<String>["..."," Whoa. Okay?"]));
		}
		third =(new PlusMinusConversationalPair(deathThreats, <String>["Uh. You sure about that, buddy?","Oooookay then. Good luck with that."],["Lol, good luck finding me. I'm behind 7 universes.","Lol, omfg you do realize I'm not even in your session, right? "]));

		if(player1.aspect == Aspects.SPACE) {
			fourth =(new PlusMinusConversationalPair(<String>["Oh don't you worry, I'll find a way to get to you, even if I have to unlock every single Space ability to do it.",  "Yes, because physical location is SUCH A hinderence to me.","Space. Player."], <String>["Fuck.","Shit.", "Uh. I. Don't THINK there's actually a way for you to do spacey shit to get to me. Hopefully."],["Fuck.","Shit.", "Uh. I. Don't THINK there's actually a way for you to do spacey shit to get to me. Hopefully."]));
		}else if(player1.interestedInCategory(InterestManager.TERRIBLE)){
			fourth =(new PlusMinusConversationalPair(<String>["I will dedicate my god damned life to this.",  "Oh I will fucking find a way. I will DEDICATE myself to this.","Your future corpse has just volunteered to be the driving force in my life. Congratulations. "], <String>["... God you're so creepy."],<String>["God, you're so creepy."]));
		}else if(player1.aspect == Aspects.DOOM){
			fourth =(new PlusMinusConversationalPair(<String>["Oh don't you worry, I'll figure out how to skirt the rules enough to do it. "], <String>["Oh. Well, okay then.","Sounds legit.","Makes sense.", "Your story checks out."],<String>["Oh. Well, okay then.","Sounds legit.","Makes sense.", "Your story checks out."]));

		}else if(player1.class_name == SBURBClassManager.WASTE || player1.class_name == SBURBClassManager.GRACE) {
			fourth =(new PlusMinusConversationalPair(<String>["Actually, I'm pretty sure that if I win, then get a Rage player to gnosis 4...that I can watch you die."], ["Fuck.","Shit.","Oh fuck.", "Oh."],<String>["Fuck.","Shit.","Oh fuck.", "Oh."]));
		}else{
			fourth =(new PlusMinusConversationalPair(<String>["JUST DIE!","Don't you fucking worry, I will FIND a way.","That doesn't fucking matter.",  "Shut up shut up shut up! You never stop talking!","I don't care!"], <String>["lol"," Good luck, I guess."],<String>["lol"," Good luck, man"]));
		}

		ret.addAll(<PlusMinusConversationalPair>[first, second, third, fourth]);
		//session.logger.info("Engage Murder: meta murder threat");
		return new Conversation(ret);
	}

	Conversation getMurdererNotValidThreatConvo(Player player1, Player player2) {
		List<PlusMinusConversationalPair> ret = new List<PlusMinusConversationalPair>();
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		//greeting
		PlusMinusConversationalPair first = new PlusMinusConversationalPair(<String>["..."], <String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)],<String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)]);
		PlusMinusConversationalPair second = new PlusMinusConversationalPair(deathThreats, <String>["Hey. Uh. I'm sure you mean that and all. But. Aren't you. Like. WAY weaker than me?","Hey, it's okay, let it all out.","I'm sorry you feel that way. "],<String>["Lol, you and what army?","Aww, how cute. It's like you think you can take me.","Doubtful."]);
		if(player2.interestedInCategory(InterestManager.TERRIBLE)){
			second = new PlusMinusConversationalPair(deathThreats, <String>["Man. On the one hand I actually like you. But on the other... no way am I going to let you kill me. Guess you're going to die!","Man, I always wanted to kill someone in self defense. Too bad it's you."],<String>["Man, I always wanted to kill someone in self defense. You're PERFECT.","Is it my birthday!? Already!?","A present! For me?", "Best. Day. Ever. I can't wait to cut you up in 'self defense'."]);
		}else if(player2.class_name.isDestructive) {
			second = new PlusMinusConversationalPair(deathThreats, <String>["I really don't recomend that if you want to live.","You're only going to get yourself killed. "],<String>["Your funeral."]);
		}else if(player2.class_name.isMagical) {
			second = new PlusMinusConversationalPair(deathThreats, <String>["But...why? I LIKE you! I've been nice to you! Why ME?","I. Where is this even coming from? I LIKE you. Why do this?"],<String>["Look, I get it. I've been a flaming asshole to you. But am I really the best target here? Think about it.","Lol, you really think I'm the worst person in this session? How dumb can you get."]);
		} else if(player2.class_name.isProtective) {
			second = new PlusMinusConversationalPair(deathThreats, <String>["Okay. Well. Better you target me than someone else.","I don't want to hurt you, but I'm not going to let you hurt anyone else."],<String>["Come at me, bro.","If I have to put you down like a mad dog to save everyone, I will."]);
		}
		PlusMinusConversationalPair third = new PlusMinusConversationalPair(<String>["ARRGGGGGGH I hate you so much!","You fucking patronizing ASSHOLE!","THIS is why I'm going to kill you! Shit like this!"], <String>["It's okay. I'm here for you.","It's good to get these feelings out.","Shooosh, it's okay."],<String>["lol","k","If you say so."]);
		PlusMinusConversationalPair fourth = new PlusMinusConversationalPair(<String>["Get ready, fucker.","Get ready, asshole.","I'm done here."], <String>["Hey! Wait a minute. You should keep venting!","I hope you feel better.","Sorry if I was making things worse."],<String>["Yeah, like that's going to scare me.","Meh.","Yeah, right."]);

		//		PlusMinusConversationalPair fourth = new PlusMinusConversationalPair(<String>[""], <String>[""],<String>[""]);


		//session.logger.info("Engage Murder: not valid murder threat");
		ret.addAll(<PlusMinusConversationalPair>[first, second, third,fourth]);
		return new Conversation(ret);
	}

	Conversation getMurdererValidThreatConvo(Player player1, Player player2) {
		List<PlusMinusConversationalPair> ret = new List<PlusMinusConversationalPair>();
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		//greeting
		ret.add(new PlusMinusConversationalPair(<String>["..."], <String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)],<String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)]));
		if(player2.interestedInCategory(InterestManager.JUSTICE)){
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["I thought you were better than this. Do you really want my death hanging over you?","You're better than this. Don't become a common criminal."],<String>["I didn't think even YOU would stoop this low.","Wow, way to prove my intuition was right. You're a criminal. Congratulations.","I wouldn't have thought you'd be clever enough to target a master detective such as myself first. But here we are."]));
			ret.add(new PlusMinusConversationalPair(<String>["See you soon!"], <String>["Fuck."],<String>["Fuck."]));
		}else if(player2.interestedInCategory(InterestManager.POPCULTURE)) {
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["No. You can't. You're. You're one of the GOOD GUYS. Why?","I. But. I trusted you. You were my hero. Why would you say that..."],<String>["I always knew you had the capacity to be a villain, but this is low even for you.","What the hell man, don't you know bad guys never win?"]));
			ret.add(new PlusMinusConversationalPair(<String>["See you soon!"], <String>["Fuck.","..."],<String>["Fuck.","..."]));
		}else if(player2.interestedInCategory(InterestManager.COMEDY)) {
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["Oh god. Tell me you're joking.","This isn't funny. ","You're normally funnier than this."],<String>["Is another one of your bad jokes?","You're joking right?","Haha, not."]));
			ret.add(new PlusMinusConversationalPair(<String>["...",":)"], <String>["... It's just a joke.","Haha you almost got me! Good joke, man!","It's just a joke. Right?"],<String>["Fuck. You're not joking.","Just drop it okay. It's not funny.","You never know when to drop a joke."]));
			ret.add(new PlusMinusConversationalPair(<String>["I think it's fucking hilarious. See you soon. You won't see me."], <String>["Fuck.","Oh fuck oh god you weren't joking."],<String>["Fuck.","I should have known you couldn't joke to save your life. Fuck."]));
		}else {
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["Oh god.","Oh fuck. oh fuck oh fuck.","...I. Really?","What the hell? Why did you snap NOW? Why ME?","Oh god. Tell me you're joking."],<String>["Oh, fuck. I always knew you were an asshole, but THIS!? ","Oh fuck, I didn't mean any of those things I said. I swear it!","....You. You're kidding. Right? Even you aren't this big of an asshole...","Oh god.","Oh fuck. oh fuck oh fuck.","Why ME?","What the hell? Why did you snap NOW? Why ME?","Oh god. Tell me you're joking."]));
			ret.add(new PlusMinusConversationalPair(<String>["...",":)"], <String>["Oh god.","Oh fuck. oh fuck oh fuck.","Why ME?","Why did you snap NOW?","It's a joke, right?"],<String>["Oh, fuck. ","You have to listen to me, I didn't mean any of those things I said!","...","Fuck."]));
			ret.add(new PlusMinusConversationalPair(<String>["See you soon!","...",":)"], <String>["Oh god.","Oh fuck. oh fuck oh fuck.","This isn't happening.","Oh god. Tell me you're joking."],<String>["Fuck.","... No. This isn't happening. It can't be.","Oh god.","Oh fuck. oh fuck oh fuck.","No. You don't mean this. Even you aren't this much of an asshole.","This isn't happening.","It's a shitty joke, that's all it is."]));
		}
		//		ret.add(new PlusMinusConversationalPair(<String>[""], <String>[""],<String>[""]));
		//session.logger.info("Engage Murder: not valid murder threat");
		return new Conversation(ret);
	}


	//both blood and rage have actual consequences to the murderer.
	Conversation getBloodConvo(Player player1, Player player2) {
		List<PlusMinusConversationalPair> ret = new List<PlusMinusConversationalPair>();
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		player2.increasePower(); //no matter what happens here, it's an rp bonus
		//greeting
		ret.add(new PlusMinusConversationalPair(<String>["..."], <String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)],<String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)]));
		//		ret.add(new PlusMinusConversationalPair(<String>[""], <String>[""],<String>[""]));
		if(player2.class_name.isDestructive) {
			//makes it worse
			player1.addStat(Stats.SANITY, -10);
			player1.addStat(Stats.RELATIONSHIPS, -10);
			player1.increasePower();
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["Oh. Fuck me. It's the Blood thing, isn't it.","I was waiting for this to happen. Fucking destroying Blood. How is that a good thing for me to do?","Aaaand SBURB finds a bright new shiny way to make being a destructive Blood player suck."],<String>["Well. If SOMEBODY had to be driven crazy by my destructive aspect, I'm glad it's you.","SBURB couldn't have picked a nicer player to drive insane enough to kill me. End sarcasm.","It's hilarious that you think you're doing this on purpose. It's the blood shit, man. You're just a puppet to me being a destructive ass."]));
			ret.add(new PlusMinusConversationalPair(<String>["This is YOUR fault.","You did this."], <String>["Probably", "Almost certainly.", "Can't argue there."],<String>["Lol, blaming me for your problems? How mature.", "Way to avoid all responsibility, asshole.", "You have to admit you helped the Bloody Thing along by being such a flagrant asshole."]));
			ret.add(new PlusMinusConversationalPair(<String>["Be. Seeing. You."], <String>["You can fight this. I know you can!","I always knew my shitty classpect would kill me."],<String>["Here's hoping you end up destroyed by this shit instead of destroying me.","Bluh. Why does this game suck so much?"]));
		}else if(player2.class_name.isMagical) {
			//manipulates blood, but can't create sanity from nothing from a distance
			player1.unmakeMurderMode();
			player1.addStat(Stats.RELATIONSHIPS, 10);
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["No. You can do better than this.","Wait, wait, I think I can sort of fix this.","Alright, this looks like a job for a changer of Blood."],<String>["Holy fuck, settle your horses, I can fix this.","Okay. Clearly something went wrong. I can fix this. Hold on.","Well, at least you were smart enough to contact the one player who could help you."]));
			ret.add(new PlusMinusConversationalPair(<String>["Fuck you I'm not broken.","I don't need your meddling. Always bugging and fussing and meddling."], <String>["What can I say, I'm a meddler. Okay. I changed things around so you don't hate anybody too much. Not really anything I could do to reroute your sanity, but at least you'll be quietly insane.", "Aaaand done. I wish I could just hand you sanity at a distance, but no dice. At least you don't hate people as much. It's a start. Come see me sometime and I'll try to give you the full whammy."],<String>["Lol, like you'd last ten seconds without my help. There you go, good as new, by which I mean at least you'll be quietly insane.","Hilarious, like you could do shit without me. There we go. Can't do anything about your sanity, but at least I moved around your relationships until you don't hate anybody TOO much."]));
			ret.add(new PlusMinusConversationalPair(<String>["... what.", " I don't like this.", "Shit."], <String>["Always a pleasure!","Happy to help!"],<String>["You're welcome, asshole."]));
		}else if(!player2.isActive()){
			//use their relationships
			player1.unmakeMurderMode();
			player1.addStat(Stats.SANITY, 10);
			player1.addStat(Stats.RELATIONSHIPS, 10);
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["Nope.","I'm not going to let you do that."],<String>["Hell No.", "You asshole. No."]));
			ret.add(new PlusMinusConversationalPair(<String>["What?", "Wait. What?","What did you say?"], <String>["Nope. You're not allowed to do that. Blood won't let you.", "The Blood says I can stop you. So I will."],<String>["Fuck off, let me do my Bloody thing.", "Fuck you, and fuck your messed up Blood. I can fix this."]));
			ret.add(new PlusMinusConversationalPair(<String>["...WHAT!?","What the fuck?","What am I feeling..."], <String>["Alright. There you go. Fixed.","Good as new. Sort of"],<String>["You're welcome, asshole."]));
		}else {
			//use your relationships, but not as good as if passive. either friendship, or rivalry.
			player1.addStat(Stats.RELATIONSHIPS, 10);
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["Whoa, friend. What's going on?","Let's talk about this. What made you so mad at me?"],<String>["Lol, are you really weak enough to give in to anger?","Wow, I never knew you were lame enough to just snap."]));
			ret.add(new PlusMinusConversationalPair(<String>["You don't know me.","You don't know what I'm going through."], <String>["Yeah, the more I play this game the more I realize how different everybody is. But I think we can still understand each other. We're friends.","Come on, it's ME. You remember how I helped you with that exam a year ago? We're friends!"],<String>["I don't care what you're going through. You're the fucking biggest asshole in all of Paradox Space, and you're still better than THIS.","Really, a little death game is all it takes for you to flip your fucking shit? You're better than this."]));
			ret.add(new PlusMinusConversationalPair(<String>["... Maybe you're right. Maybe you're wrong. But I still can't stop.","I don't KNOW! Everything is wrong!","ARGGG, stop, stop making sense!"], <String>["I believe in our friendship, friend."],<String>[""]));
		}
		return new Conversation(ret);
	}

	Conversation getRageConvo(Player player1, Player player2) {
		List<PlusMinusConversationalPair> ret = new List<PlusMinusConversationalPair>();
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		player2.increasePower(); //no matter what happens here, it's an rp bonus
		//greeting
		ret.add(new PlusMinusConversationalPair(<String>["..."], <String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)],<String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)]));
		if(player2.class_name.isDestructive) {
			//destroys rage
			player1.unmakeMurderMode();
			player1.addStat(Stats.SANITY, 10);
			player1.addStat(Stats.RELATIONSHIPS, 10);
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["No.","I'm not going to let you do that."],<String>["Hell No.", "You asshole. No."]));
			ret.add(new PlusMinusConversationalPair(<String>["What?", "Wait. What?","What did you say?"], <String>["Nope. Destroying your Rage. Stop that shit.", "Destroyer of Rage at your service."],<String>["Fuck off, let me do my destroyer of rage thing.", "Fuck you, and fuck your Rage."]));
			ret.add(new PlusMinusConversationalPair(<String>["...WHAT!?","What the fuck?","What am I feeling..."], <String>["Alright. There you go. Fixed."],<String>["You're welcome, asshole."]));
		}else if(player2.class_name.isMagical) {
			//manipulates rage
			player1.unmakeMurderMode(); //but doesn't change sanity.
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["I think you can use your Rage more productively.","There's other things you can do with all that energy."],<String>["I think you can use your Rage more productively.","Fuck you find something better to do with your Rage."]));
			ret.add(new PlusMinusConversationalPair(<String>["What?", "Wait. What?","What did you say?"], <String>["Just wait a second. I'm changing your Rage", "Changer of Rage at your service."],<String>["Fuck off, let me do my changer of rage thing.", "Fuck you, and fuck your misapplied Rage."]));
			ret.add(new PlusMinusConversationalPair(<String>["...WHAT!?","What the fuck?","What am I feeling..."], <String>["Alright. There you go. Fixed.", "Go fight enemies, asshole, not Players."],<String>["You're welcome, asshole.", "Hopefully you'll remember to fight the ENEMIES and not the PLAYERS now."]));
		}else if(!player2.isActive()){
			//gives rage
			player1.addStat(Stats.SANITY, -10);
			player1.addStat(Stats.RELATIONSHIPS, -10);
			player1.increasePower();
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["Holy fuck, bro, what is WRONG with you?","Yup. That's some rage you have."],<String>["Shit anything I could possibly say here would only make it worse.","Holy fuck, bro, what is WRONG with you?"]));
			ret.add(new PlusMinusConversationalPair(<String>["This is your fault you asshole."], <String>["Probably.", "Sorry about that. I didn't choose my Aspect!"],<String>["Nope, you'd be as terrible even without my Rage.", "Fuck you, and fuck you blaming my Rage for your problems."]));
			ret.add(new PlusMinusConversationalPair(<String>["Be. Seeing. You."], <String>["Yes.","I know."],<String>["Yes.","I know."]));
		}else {
			//has rage
			ret.add(new PlusMinusConversationalPair(deathThreats, <String>["Holy fuck, friend, what is WRONG with you?","Yup. That's some rage you have."],<String>["Shit anything I could possibly say here would only make it worse.","Holy fuck, friend, what is WRONG with you?"]));
			ret.add(new PlusMinusConversationalPair(<String>["You know what RAGE is, asshole.","What's wrong, don't recognize RAGE when you see it?"], <String>["Oh, yes. That is definitely some rage.", "Look, I'm sure we can figure something out. I get Rage, you can fight it."],<String>["Fuck you.", "Wow, how weak do you have to be to be overcome by such a little amount of Rage."]));
			ret.add(new PlusMinusConversationalPair(<String>["Be. Seeing. You."], <String>["Yes.","I know."],<String>["Yes.","I know."]));
		}

					//		ret.add(new PlusMinusConversationalPair(<String>[""], <String>[""],<String>[""]));
		//session.logger.info("Engage Murder: rage convo");
		return new Conversation(ret);
	}


	Conversation getMurdererConvo(Player player1, Player player2) {
		List<PlusMinusConversationalPair> ret = new List<PlusMinusConversationalPair>();
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		//greeting
		ret.add(new PlusMinusConversationalPair(<String>["..."], <String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)],<String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)]));
		ret.add(new PlusMinusConversationalPair(deathThreats, <String>["Well fuck. You get it. You understand.","You are singing my song there, bro."],<String>["I'll get you first, bro!","You get it, we'll paint the colors together. Until you are the colors."]));
		ret.add(new PlusMinusConversationalPair(<String>["See you soon!","...",":)"], <String>[":)"],<String>[":)"]));

		//		ret.add(new PlusMinusConversationalPair(<String>[""], <String>[""],<String>[""]));
		//session.logger.info("Engage Murder: killing buddies");
		return new Conversation(ret);
	}


	Conversation getHowKillGodConvo(Player player1, Player player2) {
		List<PlusMinusConversationalPair> ret = new List<PlusMinusConversationalPair>();
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		//greeting
		ret.add(new PlusMinusConversationalPair(<String>["..."], <String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)],<String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)]));
		ret.add(new PlusMinusConversationalPair(deathThreats, <String>["Do you really think killing me will be JUST? It's not going to stick.","As long as I don't fight back, it won't be HEROIC. It's not going to stick.","Uh. You do know I'm a GodTier, right? Kind of hard to kill."],<String>["Man, I hate you even more knowing you think killing me would be JUST.","I suppose I shall have to take it as a compliment that you think I'd be dumb enough to try to stop you and make it 'HEROIC'.","Wow, are you dumb enough to forget I'm a GodTier? How do you plan to kill me?"]));
		ret.add(new PlusMinusConversationalPair(<String>["Oh don't you worry, I'll find a way.","You raging asshole. If there is any justice in this world it will be JUST when I finish killing you.","Well you are safe from dying a HEROIC death, that's for sure."], <String>["You don't have to do this.","You can still stop."],<String>["It's hilarious that you think this is going to do anything.", "Well, have fun doing pointless shit."]));
		ret.add(new PlusMinusConversationalPair(<String>["See you soon!","...",":)"], <String>["Whatever."],<String>["Sure."]));


		//		ret.add(new PlusMinusConversationalPair(<String>[""], <String>[""],<String>[""]));
		//session.logger.info("Engage Murder: kill a god.");
		return new Conversation(ret);
	}


	Conversation getGrim1Conv(Player player1, Player player2) {
		List<PlusMinusConversationalPair> ret = new List<PlusMinusConversationalPair>();
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		//greeting
		ret.add(new PlusMinusConversationalPair(<String>["..."], <String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)],<String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)]));
		ret.add(new PlusMinusConversationalPair(<String>["I think things would go better if you were dead"], <String>["Oh god.","Oh fuck. oh fuck oh fuck.","...I. Really?","What the hell? Why did you snap NOW? Why ME?","Oh god. Tell me you're joking."],<String>["Oh, fuck. I always knew you were an asshole, but THIS!? ","Oh fuck, I didn't mean any of those things I said. I swear it!","....You. You're kidding. Right? Even you aren't this big of an asshole...","Oh god.","Oh fuck. oh fuck oh fuck.","Why ME?","What the hell? Why did you snap NOW? Why ME?","Oh god. Tell me you're joking."]));
		ret.add(new PlusMinusConversationalPair(<String>["Well. See you soon."], <String>["Oh god...Why are you like this?", "Oh god. No. Please.", "God it's so creepy how you are so flat but you're saying shit like that."],<String>["Oh god. You asshole.", "Fuck.","Shit.", "God it's so creepy how you are so flat but you're saying shit like that."]));
		//		ret.add(new PlusMinusConversationalPair(<String>[""], <String>[""],<String>[""]));
		//session.logger.info("kill while grim dark.");
		return new Conversation(ret);
	}


	Conversation getGrim2Conv(Player player1, Player player2) {
		List<PlusMinusConversationalPair> ret = new List<PlusMinusConversationalPair>();
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		//greeting
		ret.add(new PlusMinusConversationalPair(<String>["..."], <String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)],<String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)]));
		ret.add(new PlusMinusConversationalPair(deathThreats, <String>["I don't care. Everything in this game wants to kill me, may as well add the Players to the list.","Don't care.","Okay then.","Go right ahead and try."],<String>["I don't care. Everything in this game wants to kill me, may as well add the Players to the list.","Don't care.","Okay then.","Go right ahead and try."]));
		ret.add(new PlusMinusConversationalPair(<String>["Fuck you. You are too far gone to even CARE that I'm going to kill you.","... at least I know you deserve to die.","Fuck you."], <String>["If that's all you had to say,  I have shit to do. I think I'm close to achieving my goals."],<String>["If that's all you had to say,  I have shit to do.  I think I'm close to achieving my goals."]));
		//		ret.add(new PlusMinusConversationalPair(<String>[""], <String>[""],<String>[""]));
		//session.logger.info("Engage Murder: kill a grim dark.");
		return new Conversation(ret);
	}


	Conversation getBothGrimConv(Player player1, Player player2) {
		List<PlusMinusConversationalPair> ret = new List<PlusMinusConversationalPair>();
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		//greeting
		ret.add(new PlusMinusConversationalPair(<String>["..."], <String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)],<String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)]));
		ret.add(new PlusMinusConversationalPair(<String>["I think things would go better if you were dead"], <String>["I don't care. Everything in this game wants to kill me, may as well add the Players to the list.","Don't care.","Okay then.","Go right ahead and try."],<String>["I don't care. Everything in this game wants to kill me, may as well add the Players to the list.","Don't care.","Okay then.","Go right ahead and try."]));
		ret.add(new PlusMinusConversationalPair(<String>["Well. See you soon."], <String>["If that's all you had to say,  I have shit to do. I think I'm close to achieving my goals."],<String>["If that's all you had to say,  I have shit to do.  I think I'm close to achieving my goals."]));
		//		ret.add(new PlusMinusConversationalPair(<String>[""], <String>[""],<String>[""]));
		//session.logger.info("Engage Murder: kill a grim dark as a grimdark.");
		return new Conversation(ret);
	}

	Conversation getHeiressConversation(Player player1, Player player2) {
		List<PlusMinusConversationalPair> ret = new List<PlusMinusConversationalPair>();
		Relationship r1 = player1.getRelationshipWith(player2);
		Relationship r2 = player2.getRelationshipWith(player1);
		//greeting
		ret.add(new PlusMinusConversationalPair(<String>["..."], <String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)],<String>[Relationship.getRelationshipFlavorGreeting(r2, r1, player2, player1)]));
		ret.add(new PlusMinusConversationalPair(<String>["Get ready to be Challenged, fish stick!", "There's only room for one of us, bitch.", "I've had it up to my gills with your bullshit."], <String>["Oh my god! Can we NOT do this right now!?","If I can ignore my biological imperitive to murder you right in your stupid face, so can you!", "Cut it out! There's not many trolls left, so why kill each other!"],<String>["Fuck yes, about time we did an Heiress Challenge!","About time, I can't stand your stupid fishy face!", "There's only room for one big fish in this pond."]));
		ret.add(new PlusMinusConversationalPair(<String>["Skaia left two Heiresses alive for a reason, and I aim to prove I'm the one worth backing."], <String>["You're crazy!"],<String>["Why the fuck did skaia stick multiple Heiresses in the medium together!? What was the purpose? Is it crazy!?"]));
		ret.add(new PlusMinusConversationalPair(<String>["See you soon! :)"], <String>["You asshole, I thought we were friends!"],<String>["Bring it, bitch!"]));

		//		ret.add(new PlusMinusConversationalPair(<String>[""], <String>[""],<String>[""]));
		//session.logger.info("Engage Murder: kill a heiress.");
		return new Conversation(ret);
	}



	//assume positive responses are when the victim likes the murderer
	//and negative are when they don't
	Conversation getConversation(Player player1, Player player2) {


		if(session is DeadSession && session.mutator.metaHandler.metaPlayers.contains(player2)) {
			//Good luck finding me I’m behind 7 universes
			return getMetaConvo(player1, player2);
		}

		if(player1.isTroll && player1.bloodColor == "#99004d" && player2.isTroll && player2.bloodColor == "#99004d") {
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
		}else if(player2.aspect == Aspects.BLOOD && player2.hasPowers()) {
			return getBloodConvo(player1,player2);
		}else if(player2.aspect == Aspects.RAGE && player2.hasPowers()) {
			return getRageConvo(player1,player2);
		}else if(player2.getStat(Stats.POWER) * player2.getPVPModifier("Defender") < player1.getStat(Stats.POWER)*player1.getPVPModifier("Murderer")) {
			return getMurdererValidThreatConvo(player1,player2);
		}else {
			return getMurdererNotValidThreatConvo(player1,player2);

		}
	}

	void chat(Element div){
		List<Player> livePlayers = findLiving(this.session.players);
		Player player1 = this.player;
		Player player2 = player1.getWorstEnemyFromList(livePlayers);
		if(player2 != null && !player2.dead){
			Relationship r2 = player2.getRelationshipWith(player1);
			if((r2.value < -2 && r2.value > -12 ) || InterestManager.MUSIC.playerLikes(player1)){ //only if i generically dislike you. o rlike raps
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

    ImportantEvent addImportantEvent(){
		Player current_mvp = findStrongestPlayer(this.session.players);
		return this.session.addImportantEvent(new PlayerWentMurderMode(this.session, current_mvp.getStat(Stats.POWER),this.player, null) );
	}

	@override
	void renderContent(Element div){
		//print("engaging murder mode traditionally");
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
