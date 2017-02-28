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
	
	this.chatWithLeader = function(div,player1, player2){
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
		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2) +",leader.")
		chatText += chatLine(player2Start, player2,getRelationshipFlavorGreeting(r2, r1, player2, player1))
		chatText += chatLine(player1Start, player1,"leader.")
		
		setTimeout(function(){
			drawChat(canvasDiv, player1, player2, chatText, repeatTime);
		}, repeatTime*1.2);  //images aren't always loaded by the time i try to draw them the first time.
	}
	
	this.chatWithFriend = function(div,player1, player2){
		var repeatTime = 1000;
		div.append("Hwllo Jack");
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
		chatText += chatLine(player1Start, player1,"friend.")
		
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
			this.chatWithLeader(div,player1, player2)
		}else if(player2 == player1){
			debug("chat with friend: " + player2.title())
			//leader gossips with friends
			player2 = player1.getBestFriendFromList(findLivingPlayers(players));
			this.chatWithFriend(div,player1, player2)
			if(!player2){
				return div.append(this.content);
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