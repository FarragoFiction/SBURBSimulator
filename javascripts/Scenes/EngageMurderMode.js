function EngageMurderMode(){
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;

	this.trigger = function(playerList){
		this.playerList = playerList;
		//select a random player. if they've been triggered, random chance of going murderMode if enemies (based on how triggered.)
		this.player = getRandomElementFromArray(availablePlayers);
		var moon = 0;

		if(this.player){
			if(this.player.moon == "Prospit"){
				moon = 1;
			}
			if(this.player.triggerLevel > 0 &&  !this.player.murderMode && this.player.getEnemies().length > 0){
				if((Math.seededRandom() * 10) < this.player.triggerLevel+moon){  //easier to go crazy if you SEE all your friends dying already. (in prospit clouds)
					return true;
				}
			}
		}
		return false;
	}

	this.grimChat2 = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		var livePlayers = findLivingPlayers(players);
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
			chatText += chatLine(player2Start, player2,"But...why? I LIKE you! I've been nice to you! Why ME?")
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
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);
		var chatText = "";

		chatText += chatLine(player2Start, player2,"Oh, fuck.")
		chatText += chatLine(player2Start, player2,"Fuck.")
		chatText += chatLine(player2Start, player2,"Look, I get that you have trouble controling your temper.")
		chatText += chatLine(player2Start, player2,"But you can be better than that.")
		if(Math.seededRandom() > .7){
			r1.increase();
			player1.triggerLevel += -1;
			chatText += chatLine(player2Start, player2,"Why don't we meet up in person. We can vent about whatever's bothering you. Nobody has to do anything that can't be undone.")
			chatText += chatLine(player1Start, player1,"Fuck. Maybe. I... I need to go think about this.")
		}else{
			player1.triggerLevel += 1;
			r1.decrease();
			chatText += chatLine(player2Start, player2,"I mean, probably. Everybody has at least some goodness in them, right? Even you?")
			chatText += chatLine(player1Start, player1,"You asshole. Always pretending to be above it all. To be better than me.")
			chatText += chatLine(player1Start, player1,"Well try being superior when you're dead.")
		}

		return chatText;
	}

	this.chat = function(div){
		var repeatTime = 1000;
		var livePlayers = findLivingPlayers(players);
		var player1 = this.player;
		var player2 = player1.getWorstEnemyFromList(livePlayers);
		if(player2 == null || player2.dead == true){
			return;//nobody i actually want to kill??? why am i in murder mode?
		}
		var canvasHTML = "<br><canvas id='canvas" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);

		var canvasDiv = document.getElementById("canvas"+  (div.attr("id")));

		var chatText = "";
		if(player2.grimDark == true){
			chatText += this.grimChat2(div,player1, player2);
		}else{
			chatText += this.normalConvo(div,player1, player2);
		}
		drawChat(canvasDiv, player1, player2, chatText, repeatTime);
	}

	this.renderContent = function(div){
		//reset capitilization quirk, why isn't this working?
		this.player.quirk.capitalization = getRandomInt(0,5);
		div.append("<br>"+this.content());
		this.chat(div);
	}

	this.content = function(){
		//console.log("murder mode");
		this.player.increasePower();
		removeFromArray(this.player, availablePlayers);
		var ret = "The " + this.player.htmlTitle() + " has taken an acrobatic fucking pirouette off the handle and into a giant pile of crazy.  ";
		ret += " They engage Murder Mode while thinking of their enemies " + getPlayersTitles(this.player.getEnemies()) + ". ";
		ret += " This is completely terrifying. ";
		this.player.murderMode = true;
		return ret;
	}
}
