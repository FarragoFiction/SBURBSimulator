function PlanToExileJack(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.planner = null;
	//blood or page or thief or rogue. 
	this.findSympatheticPlayer = function(){
		this.planner =  findAspectPlayer(availablePlayers, "Mind");
		if(this.planner == null){
			this.planner =  findAspectPlayer(availablePlayers, "Doom");
		}else if(this.planner == null){
			this.planner =  findAspectPlayer(availablePlayers, "Light");
		}else if(this.planner == null){
			this.planner =  findClassPlayer(availablePlayers, "Seer");
		}
	}
	
	this.chatWithFriend = function(div,player1, player2){
		var repeatTime = 1000;
		var divID = (div.attr("id")) + "_" + player1.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		
		
		setTimeout(function(){
			drawChat(canvasDiv, player1, player2, chatText, repeatTime);
		}, repeatTime*1.2);  //images aren't always loaded by the time i try to draw them the first time.
	}
	
	this.smart = function(player){
		return ((player.aspect == "Light" || player.class_name == "Seer") ||(player.aspect == "Doom" || player.aspect == "Mind"))
	}
	
	this.renderContent = function(div){
		debug("planning to exile jack")
		if(!this.planner){
			return;
		}
		this.planner.increasePower();
		removeFromArray(this.planner, availablePlayers);
		available_scenes.unshift( new prepareToExileJack());
		available_scenes.unshift( new ExileJack());
		available_scenes.unshift( new ExileQueen());  //make it top priority, so unshift, don't push
		var player1 = this.planner;
		var player2 = getLeader(findLivingPlayers(players));
		if(player2 && player2 != player1){
			//player tells leader what happened.
			this.chatWithFriend(div,player1, player2)
		}else if(player2 == player1){
			//leader gossips with friends
			player2 = player1.getBestFriendFromList(findLivingPlayers(players));
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
	
	//a player has to be not busy to be your friend right now.
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.findSympatheticPlayer();
		return this.planner != null && jackStrength != 0 && queenStrength != 0; //don't plan to exile jack if he's already fllipping the fuck out.
	}
	
	this.content = function(){
		this.planner.increasePower();
		removeFromArray(this.planner, availablePlayers);
		available_scenes.unshift( new prepareToExileJack());
		available_scenes.unshift( new ExileJack());
		var ret = " The " + this.planner.htmlTitle() + " is getting a bad feeling about Jack Noir. "
		ret += " Even though he is their ally, he has stabbed players on multiple occasions, for example. ";
		ret += "There's only so many 'accidents' a single Desite can reasonably have. ";
		ret += "A plan is pulled together.  If a Queen can be exiled, why not a Jack as well? ";
		ret += " Of course, it wouldn't do to tip Jack off to the change of allegiance. You may as well continue to weaken the Queen while you're at it. ";
		return ret;
	}
}