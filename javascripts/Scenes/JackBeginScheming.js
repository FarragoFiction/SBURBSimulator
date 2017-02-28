function JackBeginScheming(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.friend = null;
	
	//blood or page or thief or rogue. 
	this.findSympatheticPlayer = function(){
		this.friend =  findAspectPlayer(availablePlayers, "Blood");
		if(this.friend == null){
			this.friend =  findClassPlayer(availablePlayers, "Page");
		}else if(this.friend == null){
			this.friend =  findClassPlayer(availablePlayers, "Thief");
		}else if(this.friend == null){
			this.friend =  findClassPlayer(availablePlayers, "Rogue");
		}
	}
	
	//a player has to be not busy to be your friend right now.
	this.trigger = function(playerList){
		this.playerList = playerList;
		if(jackStrength <= 0 || queenStrength <= 0){  //the dead can't scheme or be schemed against
			return false;
		}
		this.findSympatheticPlayer();
		return (jackStrength >= queenStrength) && (this.friend != null);
	}
	
	
	this.smart = function(player){
		return ((player.aspect == "Light" || player.class_name == "Seer") ||(player.aspect == "Doom" || player.aspect == "Mind"))
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
		chatText += chatLine(player1Start, player1,"So, this Dersite named Jack showed up. Apparently he wants to help us exile the Black Queen?")
		chatText += chatLine(player1Start, player1,"Something about a grudge?")
		chatText += chatLine(player1Start, player1,"So I told him we'd see what we could do. ")
		if(player2.aspect == "Light" || player2.class_name == "Seer"){
			chatText += chatLine(player2Start, player2,"... are you SURE that's a good idea?");
			if(this.smart(player1)){
				chatText += chatLine(player1Start, player1,"I'm pretty sure it isn't. But a WORSE idea would have been telling that psycho 'no'.  ")
			}else{
				chatText += chatLine(player1Start, player1,"What? Come on, do you really want to fight the Black Queen? This is easy mode!")
			}
		}else if(player2.aspect == "Doom" || player2.aspect == "Mind"){
			chatText += chatLine(player2Start, player2,"Somehow, I'm getting a bad feeling from this.");
			if(this.smart(player1)){
				chatText += chatLine(player1Start, player1,"Yeah. But we need to get rid of the Black Queen one way or another. We'll just keep an eye on Jack.")
			}else{
				chatText += chatLine(player1Start, player1,"You worry too much. It'll be fine. What's the point of sidequests if you don't do them?")
			}
		}else{
			chatText += chatLine(player2Start, player2,"Cool, side quests for the win.");
			chatText += chatLine(player2Start, player2,"Anything's gotta be better than taking her head on. I hear she's a huge bitch.");
			if(this.smart(player1)){
				chatText += chatLine(player1Start, player1,"Well, I don't exactly trust Jack. But it can't hurt to weaken the Queen. ")
			}else{
				chatText += chatLine(player1Start, player1,"Yep, espionage and stuff has to be way easier than a huge boss fight.")
			}
		}
		chatText += chatLine(player1Start, player1,"On a side note, he's a litle stabby. ")
		chatText += chatLine(player2Start, player2,"!");
		if(this.smart(player1)){
				chatText += chatLine(player1Start, player1,"Yeah. Definitely going to keep an eye on him. ")
			}else{
				chatText += chatLine(player1Start, player1," But I'm pretty sure at least ONE of those stabs was on accident.")
				chatText += chatLine(player1Start, player1," It's... kind of how he says 'hello'?")
			}
		
		setTimeout(function(){
			drawChat(canvasDiv, player1, player2, chatText, repeatTime);
		}, repeatTime*1.2);  //images aren't always loaded by the time i try to draw them the first time.
	}
	
	this.renderContent = function(div){
		debug("TODO: have whoever jack approaches message living leader. "+div);
		if(!this.friend){
			return;
		}
		this.friend.increasePower();
		removeFromArray(this.friend, availablePlayers);
		available_scenes.unshift( new PrepareToExileQueen());  //make it top priority, so unshift, don't push
		available_scenes.unshift( new PlanToExileJack());  //make it top priority, so unshift, don't push
		available_scenes.unshift( new ExileQueen());  //make it top priority, so unshift, don't push
		var player1 = this.friend;
		var player2 = getLeader(findLivingPlayers(players));
		if(player2 && player2 != player1){
			//player tells leader what happened.
			debug("chat with leader: " + player2.title())
			this.chatWithFriend(div,player1, player2)
		}else if(player2 == player1){
			debug("chat with friend: " + player2.title())
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
	
	this.content = function(){
		if(this.friend){
			this.friend.increasePower();
			removeFromArray(this.friend, availablePlayers);
			available_scenes.unshift( new PrepareToExileQueen());  //make it top priority, so unshift, don't push
			available_scenes.unshift( new PlanToExileJack());  //make it top priority, so unshift, don't push
			available_scenes.unshift( new ExileQueen());  //make it top priority, so unshift, don't push
			var ret = " Archagent Jack Noir has not let the Queen's relative weakness go unnoticed. ";
			ret += " He meets with the " + this.friend.htmlTitle() + " at " + this.friend.shortLand() + " and begins scheming to exile her. ";
			ret += " You can tell he likes the " + this.friend.htmlTitle() + " because he only stabbed them, like, three times, tops. ";
			ret += " And at least ONE of those was on accident. ";
		return ret;
		}
	}
}