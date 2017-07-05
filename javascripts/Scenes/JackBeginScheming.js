function JackBeginScheming(session){
	this.canRepeat = false;
	this.session=session;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.friend = null;

	//blood or page or thief or rogue.  don't go for non native players
	this.findSympatheticPlayer = function(){
		//not available, living. jack inerupts whatever they are doingv
		var living = findLivingPlayers(this.session.players);
		this.friend =  findAspectPlayer(living, "Blood");
		if(this.friend == null || this.friend.land == null){
			this.friend =  findClassPlayer(living, "Page");
		}else if(this.friend == null || this.friend.land == null){
			this.friend =  findClassPlayer(living, "Thief");
		}else if(this.friend == null || this.friend.land == null){
			this.friend =  findClassPlayer(living, "Rogue");
		}else if(this.friend == null || this.friend.land == null){
			this.friend =  findAspectPlayer(living, "Hope");
		}else{
			this.friend = getRandomElementFromArray(curSessionGlobalVar.availablePlayers);
		}
		if(this.friend == null || this.friend.land == null){
			return null;
		}
	}

	//a player has to be not busy to be your friend right now.
	this.trigger = function(playerList){
		this.playerList = playerList;
		if(this.session.jack.getStat("currentHP") <= 0 && !this.session.jack.dead|| this.session.queen.getStat("currentHP") <= 0 && !this.session.queen.dead){  //the dead can't scheme or be schemed against
			return false;
		}
		this.findSympatheticPlayer();
		return (this.session.jack.getStat("power") >= this.session.queen.getStat("power")) && (this.friend != null);
	}


	this.smart = function(player){
		return ((player.aspect == "Light" || player.class_name == "Seer") ||(player.aspect == "Doom" || player.aspect == "Mind"))
	}

	//player2 is grimdark, reacting to jack player
	this.grimChat2 = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2))
		chatText += chatLine(player1Start, player1,"So, this Dersite named Jack showed up. Apparently he wants to help us exile the Black Queen?")
		chatText += chatLine(player1Start, player1,"Something about a grudge?")
		chatText += chatLine(player1Start, player1,"So I told him we'd see what we could do. ")
		if(this.smart(player2)){
			chatText += chatLine(player2Start, player2,"You are a fool. Jack is more dangerous than the Queen.");
			chatText += chatLine(player2Start, player2,"Empowering him will only make this game harder. ");
			if(this.smart(player1)){
				chatText +=  chatLine(player1Start, player1,"Yes, and pissing him off will make the game impossible.")
				chatText +=  chatLine(player1Start, player1,"We need to weaken the Queen anyways. ")
				chatText +=  chatLine(player1Start, player1,"We just have to be careful not to let him take her ring. ")
				chatText += chatLine(player2Start, player2,"I don't care.");
				chatText += chatLine(player1Start, player1,"Yes, I know. Goodbye. ")
			}else{
				chatText +=  chatLine(player1Start, player1,"Well, I'd like to see YOU say 'no' to Jack when he's stabbing you. ")
				chatText += chatLine(player2Start, player2,"You are a fool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"I don't care.");
			chatText += chatLine(player1Start, player1,"Yes. Well... If you ever do care, ping me and I'll bring you up to speed.")
		}
		return chatText;
	}

//player1 is grimdark, communicating jack stuff
	this.grimChat1 = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		chatText += chatLine(player1Start, player1,"In order to beat the Queen, we will be working with a Dersite named Jack to exile her. ")
		if(player2.aspect == "Light" || player2.class_name == "Seer"){
			chatText += chatLine(player2Start, player2,"... are you SURE that's a good idea?");
			if(this.smart(player1)){
				chatText += chatLine(player1Start, player1,"The Queen needs exiled. Jack gaining power is a risk I am willing to take.")
			}else{
				chatText += chatLine(player1Start, player1,"Beating this game is the only thing that matters. ")
			}
		}else if(player2.aspect == "Doom" || player2.aspect == "Mind"){
			chatText += chatLine(player2Start, player2,"Somehow, I'm getting a bad feeling from this.");
			if(this.smart(player1)){
				chatText += chatLine(player1Start, player1,"I commend your foresight. Jack is not to be trusted. But the Queen must be exiled.")
			}else{
				chatText += chatLine(player1Start, player1,"Your feelings are irrelevant. ")
			}
		}else{
			chatText += chatLine(player2Start, player2,"Cool, side quests for the win.");
			chatText += chatLine(player2Start, player2,"Anything's gotta be better than taking her head on. I hear she's a huge bitch.");
			if(this.smart(player1)){
				chatText += chatLine(player1Start, player1,"You are a fool. ")
			}else{
				chatText += chatLine(player1Start, player1,"We shall win.")
			}
		}
		return chatText;
	}

//both players are grimdark. 1 met jack
	this.grimChatBoth = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		chatText += chatLine(player1Start, player1,"In order to beat the Queen, we will be working with a Dersite named Jack to exile her. ")
		if(player2.aspect == "Light" || player2.class_name == "Seer"){
			chatText += chatLine(player2Start, player2,"I forsee problems.");
			if(this.smart(player1)){
				chatText += chatLine(player1Start, player1,"The Queen needs exiled. Jack gaining power is a risk I am willing to take.")
			}else{
				chatText += chatLine(player1Start, player1,"Beating this game is the only thing that matters. ")
			}
		}else if(player2.aspect == "Doom" || player2.aspect == "Mind"){
			chatText += chatLine(player2Start, player2,"This endeavor is doomed.");
			if(this.smart(player1)){
				chatText += chatLine(player1Start, player1,"I commend your foresight. Jack is not to be trusted. But the Queen must be exiled.")
			}else{
				chatText += chatLine(player1Start, player1,"Everything in this game is doomed. ")
			}
		}else{
			chatText += chatLine(player2Start, player2,"Yes.");
			if(this.smart(player1)){
				chatText += chatLine(player1Start, player1,"I will monitor Jack for signs of treachery.")
			}else{
				chatText += chatLine(player1Start, player1,"We shall win.")
			}
		}
		return chatText;
	}

	this.normalConvo = function(div, player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);
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
		chatText += chatLine(player1Start, player1,"On a side note, he's a little stabby. ")
		chatText += chatLine(player2Start, player2,"!");
		if(this.smart(player1)){
				chatText += chatLine(player1Start, player1,"Yeah. Definitely going to keep an eye on him. ")
			}else{
				chatText += chatLine(player1Start, player1,"But I'm pretty sure at least ONE of those stabs was on accident.")
				chatText += chatLine(player1Start, player1,"It's... kind of how he says 'hello'?")
				if(this.smart(player2)){
					chatText += chatLine(player2Start, player2,"Why do I even bother?")
				}
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
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var chatText = "";
		if(player1.grimDark  > 1 && player2.grimDark  > 1){
			chatText += this.grimChatBoth(div,player1, player2);
		}else if(player1.grimDark > 1){
			chatText += this.grimChat1(div,player1, player2);
		}else if(player2.grimDark  > 1){
			chatText += this.grimChat2(div,player1, player2);
		}else{
			chatText += this.normalConvo(div,player1, player2);
		}

		drawChat(canvasDiv, player1, player2, chatText, repeatTime,"discuss_jack.png");
	}

	this.renderContent = function(div){
		if(!this.friend){
			return;
		}
		this.session.jackScheme = true;
		this.friend.increasePower();
		removeFromArray(this.friend, this.session.availablePlayers);
		this.session.available_scenes.unshift( new PrepareToExileQueen(session));  //make it top priority, so unshift, don't push
		this.session.available_scenes.unshift( new PlanToExileJack(session));  //make it top priority, so unshift, don't push
		this.session.available_scenes.unshift( new ExileQueen(session));  //make it top priority, so unshift, don't push
		var player1 = this.friend;
		var player2 = getLeader(findLivingPlayers(this.session.players));
		if(player2 && player2 != player1){
			//player tells leader what happened.
			this.chatWithFriend(div,player1, player2)
		}else if(player2 == player1){
			//leader gossips with friends
			player2 = player1.getBestFriendFromList(findLivingPlayers(this.session.players));
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
			removeFromArray(this.friend, this.session.availablePlayers);
			this.session.available_scenes.unshift( new PrepareToExileQueen(this.session));  //make it top priority, so unshift, don't push
			this.session.available_scenes.unshift( new PlanToExileJack(this.session));  //make it top priority, so unshift, don't push
			this.session.available_scenes.unshift( new ExileQueen(this.session));  //make it top priority, so unshift, don't push
			var ret = " Archagent Jack Noir has not let the Queen's relative weakness go unnoticed. ";
			ret += " He meets with the " + this.friend.htmlTitle() + " at " + this.friend.shortLand() + " and begins scheming to exile her. ";
			ret += " You can tell he likes the " + this.friend.htmlTitle() + " because he only stabbed them, like, three times, tops. ";
			ret += " And at least ONE of those was on accident. ";
		return ret;
		}
	}
}
