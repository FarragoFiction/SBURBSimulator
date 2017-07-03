function EngageMurderMode(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;

	this.trigger = function(playerList){
		this.playerList = playerList;
		//select a random player. if they've been triggered, random chance of going murderMode if enemies (based on how triggered.)
		this.player = getRandomElementFromArray(this.session.availablePlayers);
		var moon = 0;

		if(this.player){
			return !this.player.murderMode && this.player.getEnemies().length > 0 && this.flipsShit(); //dude, don't engage murder mode if you're already in it

		}
		return false;
	}

	this.flipsShit = function(){
		var diamond = this.player.hasDiamond()
		var triggerMinimum = -275;

		if(diamond) triggerMinimum += -1*(this.player.getRelationshipWith(diamond).value);  //hope you don't hate your moirail
		if(this.player.moon == "Prospit") triggerMinimum += 100; //easier to flip shit when you see murders in the clouds.
		var ret = (Math.seededRandom() * this.player.sanity < triggerMinimum);
		if(ret && diamond) console.log("flipping shit even with moirail"  + this.session.session_id)
		if(ret) console.log("flipping shit naturally " + this.session.session_id)
		return ret;
	}

	this.grimChat2 = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);
		var chatText = "";
		chatText += chatLine(player1Start, player1,"...")
		chatText += chatLine(player2Start, player2,getRelationshipFlavorGreeting(r2, r1, player2, player1))
		chatText += chatLine(player1Start, player1,"You're going to die. And I'm going to see it. I'm going to DO it.")
		chatText += chatLine(player2Start, player2,"I don't care. Everything in this game wants to kill me, may as well add the Players to the list.")
		chatText += chatLine(player1Start, player1,"Fuck you. You are too far gone to even CARE that I'm going to kill you.")
		return chatText;
	}

	//a normal convo goes differently based on target players's aspect/class and relationship with murderer
	this.normalConvo = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);
		var chatText = "";
		chatText += chatLine(player1Start, player1,"...")
		chatText += chatLine(player2Start, player2,getRelationshipFlavorGreeting(r2, r1, player2, player1))
		chatText += chatLine(player1Start, player1,"You're going to die. And I'm going to see it. I'm going to DO it.")
		if(player1.isTroll && player1.bloodColor == "#99004d" && player2.isTroll && player2.bloodColor == "#99004d"){
			chatText += this.heirressConvo(div, player1, player2);
		}else if(player2.aspect == "Blood" || player2.aspect == "Sylph"){  //try to repair relationship
			chatText += this.repairConvo(div, player1, player2);
		}else if(player2.aspect == "Mind" || player2.class_name == "Bard" ){ //try to redirect madness at another target
			chatText += this.redirectConvo(div, player1, player2);
		}else if(player2.aspect == "Rage" || player2.class_name == "Knight" ){ //welcome the challenge
			chatText += this.blusterConvo(div, player1, player2);
		}else{
			chatText += this.panicConvo(div, player1, player2);
		}

		return chatText;

	}

	this.heirressConvo = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);
		var chatText = "";
		chatText += chatLine(player2Start, player2,"Oh my god! Can we NOT do this right now!?")
		chatText += chatLine(player2Start, player2,"If I can ignore my biological imperitive to murder you right in your stupid face, so can you!")
		chatText += chatLine(player2Start, player2,"Why the fuck did skaia stick multiple Heiresses in the medium together!? What was the purpose? Is it crazy!?")
		chatText += chatLine(player1Start, player1,"See you soon! :)")
		chatText += chatLine(player2Start, player2,"You asshole! I thought we were friends!")
		return chatText;
	}

	//panic
	this.panicConvo = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);
		var chatText = "";
		if(r2.type() == r2.badBig){
			chatText += chatLine(player2Start, player2,"Oh, fuck.")
			chatText += chatLine(player2Start, player2,"Oh, fuck. I always knew you were an asshole, but THIS!?")
			chatText += chatLine(player2Start, player2,"What the hell? Why did you snap NOW? Why ME?")
			chatText += chatLine(player1Start, player1,"See you soon! :)")
			chatText += chatLine(player2Start, player2,"Oh, god.")
		}else{
			chatText += chatLine(player2Start, player2,"Oh, fuck.")
			chatText += chatLine(player2Start, player2,"Fuck.")
			chatText += chatLine(player2Start, player2,"Fuck.")
			chatText += chatLine(player2Start, player2,"What the hell? Why did you snap NOW? Why ME?")
			chatText += chatLine(player2Start, player2,"Fuck. Please no....")
			chatText += chatLine(player1Start, player1,"See you soon! :)")
			chatText += chatLine(player2Start, player2,"Oh, god.")
		}
		return chatText;
	}

	//you want to fight, bro?
	this.blusterConvo = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);
		var chatText = "";
		if(r2.type() == r2.badBig){
			chatText += chatLine(player2Start, player2,"You want to fight, bro? Let's do it. You and me.")
			chatText += chatLine(player1Start, player1,"It won't be a fight. It'll be a goddamned MASSACRE.")
			chatText += chatLine(player2Start, player2,"You're on.")
		}else{
			chatText += chatLine(player2Start, player2,"Oh fuck.")
			chatText += chatLine(player2Start, player2,"Fuck.")
			chatText += chatLine(player2Start, player2,"You know I'm not just going to LET you kill me right?")
			chatText += chatLine(player2Start, player2,"Please don't make me kill you in self defense.")
			chatText += chatLine(player1Start, player1,"See you soon! :)")
		}

		return chatText;
	}

	//make them hate someone else more.
	this.redirectConvo = function(div, player1, player2){
		var livePlayers = findLivingPlayers(this.session.players);
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);
		var chatText = "";

		if(r2.type() == r2.badBig){
			chatText += chatLine(player2Start, player2,"Look, I get it. I've been a flaming asshole to you.")
			chatText += chatLine(player2Start, player2,"But am I REALLY the one you want to kill FIRST?")
			var alternative = player2.getWorstEnemyFromList(livePlayers);
			if(alternative){
				chatText += chatLine(player2Start, player2,"What about " + alternative.chatHandle + " ?")
				chatText += chatLine(player2Start, player2,"Haven't they been worse to you?")
				var r3 = player1.getRelationshipWith(alternative);
				if(!r3 || r3.value > 0){
					chatText += chatLine(player1Start, player1,"ARRRRRGGGH! THIS IS WHY I HATE YOU!")
					chatText += chatLine(player1Start, player1,"YOU ARE A MILLION TIMES WORSE THAN " + alternative.chatHandle.toUpperCase())
					chatText += chatLine(player1Start, player1,"Prepare to die.")
					chatText += chatLine(player2Start, player2,"Fuck. Worth a shot.")
					r1.decrease();
				}else{
					chatText += chatLine(player1Start, player1,"... Maybe. Maybe you have a point.")
					r3.decrease();
				}
			}else{
				chatText += chatLine(player1Start, player1,"No, there really isn't. Prepare to die.")
				chatText += chatLine(player2Start, player2,"Fuck. Worth a shot.")
			}
		}else if(r2.type() == r2.goodBig){
			chatText += chatLine(player2Start, player2,"But...why? I LIKE you! I've been nice to you! Why ME?") //alt dialogue of them realizing that htey've actually been a dick?
			var alternative = player2.getWorstEnemyFromList(livePlayers);
			if(alternative){
				chatText += chatLine(player2Start, player2,alternative.chatHandle + "is a million times worse than me! ")
				var r3 = player1.getRelationshipWith(alternative);
				if(r3.value > 0){
					chatText += chatLine(player1Start, player1,"No, they really aren't. Prepare to die.")
				}else{
					chatText += chatLine(player1Start, player1,"Maybe you have a point.")
					r3.decrease();
					r1.increase();
				}
			}else{
				chatText += chatLine(player1Start, player1,"You sure haven't shown it. Prepare to die.")
			}

		}else{
			chatText += chatLine(player2Start, player2,"Oh fuck.")
			chatText += chatLine(player2Start, player2,"Okay, but, am I the best person to rage out on?")
			if(alternative){
				chatText += chatLine(player2Start, player2,"What about " + alternative.chatHandle + " ?")
				chatText += chatLine(player2Start, player2,"Haven't they been worse to you?")
				var r3 = player1.getRelationshipWith(alternative);
				if(r3.value > 0){
					chatText += chatLine(player1Start, player1,"ARRRRRGGGH! THIS IS WHY I HATE YOU!")
					chatText += chatLine(player1Start, player1,"YOU ARE A MILLION TIMES WORSE THAN " + alternative.chatHandle)
					chatText += chatLine(player1Start, player1,"Prepare to die.")
					chatText += chatLine(player2Start, player2,"Fuck. Worth a shot.")
					r1.decrease();
				}else{
					chatText += chatLine(player1Start, player1,"... Maybe. Maybe you have a point.")
					r3.decrease();
				}
			}else{
				chatText += chatLine(player1Start, player1,"Prepare to die.")
				chatText += chatLine(player2Start, player2,"Fuck. Worth a shot.")
			}

		}

		return chatText;
	}


	//reduce trigger a bit?
	this.repairConvo = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);
		var chatText = "";

		chatText += chatLine(player2Start, player2,"Oh, fuck.")
		chatText += chatLine(player2Start, player2,"Fuck.")
		chatText += chatLine(player2Start, player2,"Look, I get that you have trouble controling your temper.")
		chatText += chatLine(player2Start, player2,"But you can be better than that.")
		if(Math.seededRandom() > .7){
			r1.increase();
			player1.sanity += 1;
			chatText += chatLine(player2Start, player2,"Why don't we meet up in person. We can vent about whatever's bothering you. Nobody has to do anything that can't be undone.")
			chatText += chatLine(player1Start, player1,"Fuck. Maybe. I... I need to go think about this.")
		}else{
			player1.sanity += -10;
			r1.decrease();
			chatText += chatLine(player2Start, player2,"I mean, probably. Everybody has at least some goodness in them, right? Even you?")
			chatText += chatLine(player1Start, player1,"You asshole. Always pretending to be above it all. To be better than me.")
			chatText += chatLine(player1Start, player1,"Well try being superior when you're dead.")
		}

		return chatText;
	}
	//each of us raps about one of our interests at random. don't care if it goes off screen.
	//extra chat box with results.
	//if player 1 wins, goes ahead with threatening. cites weak rhymes as reason.
	//if player2 wins, sick fires bro gif. player1 paraphrases gamzee when he calmed down with dave.
	this.rapBattle = function(div, player1, player2){
		this.session.rapBattle = true;
		var narration = "The " + player1.htmlTitle() + " is contemplating murder. Can their rage be soothed by a good old-fashioned rap battle?<Br>";
		div.append(narration)
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var canvasHTML = "<br><canvas id='canvas" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvasDiv = document.getElementById("canvas"+  (div.attr("id")));
		var chatText = ""

		chatText += chatLine(player1Start, player1,"Bro. Rap Battle. Now. Bring the Fires.")
		chatText += chatLine(player2Start, player2,"Yes. Fuck yes! Hell FUCKING yes!")
		var p1score = 0;
		var p2score = 0;
		var raps1 = getRapForPlayer(player1,"",0);
		chatText += raps1[0];
		p1score = raps1[1];
		var raps2 = getRapForPlayer(player2,"",0);
		chatText += raps2[0];
		p2score = raps1[1];
		drawChat(canvasDiv, player1, player2, chatText, repeatTime,"discuss_raps.png");
		if(p1score + p2score > 6){ //it's not winning that calms them down, but sick fires in general.
			//console.log("rap sick fires in session: " + this.session.session_id + " score: " + (p1score + p2score))
			div.append("<img class = 'sickFiresCentered' src = 'images/sick_fires.gif'><br> It seems that the " + player1.htmlTitle() + " has been calmed down, for now.");
			if(player1.murderMode) player1.unmakeMurderMode();
			if(player2.murderMode) player2.unmakeMurderMode(); //raps calm EVERYBODY down.
			//rap battles are truly the best way to power level.
			player1.increasePower();
			player2.increasePower();
			this.session.sickFires = true;
		}else{
			var canvasHTML2 = "<br><canvas id='canvas2" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML2);
			var canvasDiv2 = document.getElementById("canvas2"+  (div.attr("id")));
			var chatText2 = ""
			chatText2 += chatLine(player1Start, player1,"Fuck. That was LAME! It makes me so FUCKING ANGRY!")
			chatText2 += chatLine(player2Start, player2,"Whoa.")
			chatText2 += chatLine(player1Start, player1,"All I FUCKING wanted was one tiny rap battle, and you can't even fucking do THAT!?")
			chatText2 += chatLine(player2Start, player2,"Now wait a second...")
			chatText2 += chatLine(player1Start, player1,"Fuck it. I'm done trying to hold back. See you soon.")
			drawChat(canvasDiv2, player1, player2, chatText2, repeatTime,"discuss_murder.png");
		}
	}


	this.chat = function(div){
		var repeatTime = 1000;
		var livePlayers = findLivingPlayers(this.session.players);
		var player1 = this.player;
		var player2 = player1.getWorstEnemyFromList(livePlayers);
		if(player2 && !player2.dead){
			var r2 = player2.getRelationshipWith(player1);
			if((r2.value < -2 && r2.value > -12 ) || playerLikesMusic(player1)){ //only if i generically dislike you. o rlike raps
				//console.log("rap battle. session: " + this.session.session_id)
				return this.rapBattle(div,player1, player2);
			}
	}

		if(player2 == null || player2.dead == true){
			return;//nobody i actually want to kill??? why am i in murder mode?
		}
		var canvasHTML = "<br><canvas id='canvas" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);

		var canvasDiv = document.getElementById("canvas"+  (div.attr("id")));

		var chatText = "";
		if(player2.grimDark > 1){
			chatText += this.grimChat2(div,player1, player2);
		}else{
			chatText += this.normalConvo(div,player1, player2);
		}
		drawChat(canvasDiv, player1, player2, chatText, repeatTime,"discuss_murder.png");
	}

	this.addImportantEvent = function(){
		var current_mvp =  findStrongestPlayer(this.session.players)
		return this.session.addImportantEvent(new PlayerWentMurderMode(this.session, current_mvp.power,this.player) );
	}

	this.renderContent = function(div){
		var alt = this.addImportantEvent();
		if(alt && alt.alternateScene(div)){
			return;
		}
		//reset capitilization quirk
		this.player.quirk.capitalization = getRandomInt(0,5);
		div.append("<br>"+this.content());
		this.chat(div);
	}

	this.content = function(){
		//console.log("murder mode");
		this.player.increasePower();
		removeFromArray(this.player, this.session.availablePlayers);
		var ret = "The " + this.player.htmlTitle() + " has taken an acrobatic fucking pirouette off the handle and into a giant pile of crazy.  ";
		ret += " They engage Murder Mode while thinking of their enemies " + getPlayersTitles(this.player.getEnemies()) + ". ";
		ret += " This is completely terrifying. ";
		var diamond = this.player.hasDiamond()
		if(diamond){
			ret += " I guess their Moirail, the " + diamond.htmlTitle() + " is not on the ball. ";
		}
		this.player.makeMurderMode();
		return ret;
	}
}
