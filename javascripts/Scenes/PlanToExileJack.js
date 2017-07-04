function PlanToExileJack(session){
	this.canRepeat = false;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.planner = null;



	//a player has to be not busy to be your friend right now.
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.findSympatheticPlayer();
		//console.log("Planner: " + this.planner + " jack hp: " + this.session.jack.getStat("currentHP") + " jack crowned: " + this.session.jack.crowned );
		return this.planner != null && 	this.session.jack.getStat("currentHP") > 0 && !this.session.jack.dead  && 	this.session.jack.crowned == null && !this.session.jack.exiled;
	}


	//blood or page or thief or rogue. dont' need to be avaible, will make time to do this.
	this.findSympatheticPlayer = function(){
		var living = findLivingPlayers(this.session.players)
		this.planner =  findAspectPlayer(living, "Mind");
		if(this.planner == null){
			this.planner =  findAspectPlayer(living, "Doom");
		}else if(this.planner == null){
			this.planner =  findAspectPlayer(living, "Light");
		}else if(this.planner == null){
			this.planner =  findClassPlayer(living, "Seer");
		}
	}

	this.grimChat2 = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2))
		chatText += chatLine(player1Start, player1,"So, new plan. Jack is WAY too stabby, we need to exile him.")
		if(this.smart(player2)){
				chatText += chatLine(player2Start, player2,"Agreed.")
		}else{
			chatText += chatLine(player2Start, player2,"I don't see how this helps us beat the game.")
			chatText += chatLine(player1Start, player1,"Look, if we're constantly being stabbed, then we're not exactly climbing our echeladders, right?")
			chatText += chatLine(player1Start, player1,"Just trust me, we can focus on the game once the stabs stop.")
		}
		chatText += chatLine(player1Start, player1,"We'll keep up the ruse of exiling the Black Queen.")
		chatText += chatLine(player1Start, player1,"But also 'accidentally' take out Jack's allies at the same time.")
		chatText += chatLine(player1Start, player1,"Then, we exile Jack.")
		chatText += chatLine(player2Start, player2,"Fine.")

		return chatText;
	}

	//player1 is grimdark, communicating jack stuff
		this.grimChat1 = function(div, player1, player2){
			var player1Start = player1.chatHandleShort()+ ": "
			var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
			var chatText = "";

			chatText += chatLine(player1Start, player1,"In order to beat the game quicker, we will now be exiling Jack.")

			if(this.smart(player2)){
				chatText += chatLine(player2Start, player2,"Makes sense. How will we pull it off without getting stabbed?")
				chatText += chatLine(player1Start, player1,"We will continue working with Jack to exile the Black Queen.");
				chatText += chatLine(player1Start, player1,"While also exiling Jack's allies and weakening him in other ways. With deniability.");
				chatText += chatLine(player2Start, player2,"Here's hoping it works.")
			}else{
				chatText += chatLine(player2Start, player2,"What!? No way! He's our ALLY!")
				chatText += chatLine(player1Start, player1,"You are a fool. His betrayal is inevitable.")
				chatText += chatLine(player2Start, player2,"Okay. MAYBE he's a little stabby.  But that's part of his charm!")
				chatText += chatLine(player2Start, player2,"Also, he is way too terrifying to backstab.")
				chatText += chatLine(player1Start, player1,"Ideally, he will never suspect our treachery.");
				chatText += chatLine(player1Start, player1,"We will continue working with Jack to exile the Black Queen.");
				chatText += chatLine(player1Start, player1,"While also exiling Jack's allies and weakening him in other ways. With deniability.");
				chatText += chatLine(player2Start, player2,"Fuck.")
			}

			return chatText;

		}

	this.grimChatBoth = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";

		chatText += chatLine(player1Start, player1,"In order to beat the game quicker, we will now be exiling Jack.")

		if(this.smart(player2)){
			chatText += chatLine(player2Start, player2,"Agreed.");
			chatText += chatLine(player1Start, player1,"We will continue working with Jack to exile the Black Queen.");
			chatText += chatLine(player1Start, player1,"While also exiling Jack's allies and weakening him in other ways. With deniability.");
			chatText += chatLine(player2Start, player2,"Fine.");
		}else{
			chatText += chatLine(player2Start, player2,"I don't see how this helps us beat the game.");
			chatText += chatLine(player1Start, player1,"You are a fool. His betrayal is inevitable.");
			chatText += chatLine(player2Start, player2,"It might not become relevant until we have left the Medium.");
			chatText += chatLine(player1Start, player1,"I want nothing to risk our Ascension.");
			chatText += chatLine(player2Start, player2,"Betraying Jack is a risk of its own.");
			chatText += chatLine(player1Start, player1,"Ideally, he will never suspect our treachery.");
			chatText += chatLine(player1Start, player1,"We will continue working with Jack to exile the Black Queen.");
			chatText += chatLine(player1Start, player1,"While also exiling Jack's allies and weakening him in other ways. With deniability.");
			chatText += chatLine(player2Start, player2,"I will hold you accountable should this fail.");
		}



		return chatText;
	}

	this.normalConvo = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);
		var chatText = "";

		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2))
		chatText += chatLine(player2Start, player2,getRelationshipFlavorGreeting(r2, r1, player2, player1))
		chatText += chatLine(player1Start, player1,"So, new plan. Jack is WAY too stabby, we need to exile him.")
		if(this.smart(player2)){
			chatText += chatLine(player2Start, player2,"Makes sense. How will we pull it off without getting stabbed?")
			chatText += chatLine(player1Start, player1,"We keep up the ruse of exiling the Black Queen.")
			chatText += chatLine(player1Start, player1,"But also 'accidentally' take out Jack's allies at the same time.")
			chatText += chatLine(player1Start, player1,"Then, we exile Jack.")
			chatText += chatLine(player2Start, player2,"Here's hoping it works.")
		}else{
			chatText += chatLine(player2Start, player2,"What!? No way! He's our ALLY!")
			chatText += chatLine(player1Start, player1,"What part of 'stabby' isn't getting through to you?")
			chatText += chatLine(player1Start, player1,"You can't spell 'backstab' without 'stab'. We have to backstab him first.")
			chatText += chatLine(player2Start, player2,"But you said it yourself: He's the BEST at stabs!")
			chatText += chatLine(player1Start, player1,"And that's why we're going to plan this. We'll take out his allies.")
			chatText += chatLine(player1Start, player1,"And exile him before he knows anything is going on.")
			chatText += chatLine(player2Start, player2,"I want it on the official record that this is a bad idea.")
			chatText += chatLine(player1Start, player1,"Yes.")
		}

		return chatText;
	}

	this.chatWithFriend = function(div,player1, player2){
		var repeatTime = 1000;
		var divID = (div.attr("id")) + "_" + player1.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);


		var chatText = "";
		if(player1.grimDark  > 1 && player2.grimDark  > 1){
			chatText += this.grimChatBoth(div,player1, player2);
		}else if(player1.grimDark  > 1){
			chatText += this.grimChat1(div,player1, player2);
		}else if(player2.grimDark  > 1){
			chatText += this.grimChat2(div,player1, player2);
		}else{
			chatText += this.normalConvo(div,player1, player2);
		}

		drawChat(canvasDiv,player1, player2, chatText, repeatTime,"discuss_jack.png");
	}

	this.smart = function(player){
		return ((player.aspect == "Light" || player.class_name == "Seer") ||(player.aspect == "Doom" || player.aspect == "Mind"))
	}

	this.renderContent = function(div){
		this.session.plannedToExileJack = true;
		if(!this.planner){
			return;
		}
		this.planner.increasePower();
		removeFromArray(this.planner, this.session.availablePlayers);
		this.session.available_scenes.unshift( new prepareToExileJack(this.session));
		this.session.available_scenes.unshift( new ExileJack(this.session));
		this.session.available_scenes.unshift( new ExileQueen(this.session));  //make it top priority, so unshift, don't push
		var player1 = this.planner;
		var player2 = getLeader(findLivingPlayers(	this.session.players));
		if(player2 && player2 != player1){
			//player tells leader what happened.
			this.chatWithFriend(div,player1, player2)
		}else if(player2 == player1){
			//leader gossips with friends
			player2 = player1.getBestFriendFromList(findLivingPlayers(	this.session.players));
			if(!player2){
				return div.append(this.content);
			}else{
				this.chatWithFriend(div,player1, player2)
			}
		}else{
			//we get a narration
			div.append(this.content);
		}
	}

	this.content = function(){
		if(!this.planner){
			return;//this should theoretically never happen
		}
		this.planner.increasePower();
		removeFromArray(this.planner, this.session.availablePlayers);
		this.session.available_scenes.unshift( new prepareToExileJack(this.session));
		this.session.available_scenes.unshift( new ExileJack(this.session));
		var ret = " The " + this.planner.htmlTitle() + " is getting a bad feeling about Jack Noir. "
		ret += " Even though he is their ally, he has stabbed players on multiple occasions, for example. ";
		ret += "There's only so many 'accidents' a single Desite can reasonably have. ";
		ret += "A plan is pulled together.  If a Queen can be exiled, why not a Jack as well? ";
		ret += " Of course, it wouldn't do to tip Jack off to the change of allegiance. You may as well continue to weaken the Queen while you're at it. ";
		return ret;
	}
}
