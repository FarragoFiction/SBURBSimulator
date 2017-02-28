//only one player at a time.
//compare old relationship with new relationship.
function RelationshipDrama(){
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.dramaPlayers = [];
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.dramaPlayers = [];
		//CAN change how ou feel about somebody not yet in the medium
		for(var i = 0; i< players.length; i++){
			var p = players[i];
			if(p.hasRelationshipDrama()){
				this.dramaPlayers.push(p)
			}
		}
		return this.dramaPlayers.length > 0;
	}
	
	this.renderForPlayer = function (div, player){
		var player1 = player;
		var player2 = player.getBestFriendFromList(findLivingPlayers(players));
		var relationships = player.getRelationshipDrama();
		for(var j = 0; j<relationships.length; j++){
				this.processDrama(player, relationships[j]);  //or drama dnever leaves
			}
		
		if(!player2){
			return div.append(this.content() + " Too bad the " + player.htmlTitle() + " doesn't have anybody to talk to about this. ");
		}
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
		var relationship = relationships[0]
		chatText += chatLine(player1Start, player1, "TODO: Relationship stuff. I used to think " + player2.chatHandleShort() + " was " +this.generateOldOpinion(relationship ));
		if(relationship.target == player2){
			chatText += chatLine(player1Start, player1, "So...hey.");
			chatText += chatLine(player2Start, player2, "Hey?");
			chatText += chatLine(player1Start, player1, "I have no idea how to say this so I'm just going to do it.");
			chatText += chatLine(player1Start, player1, "I used to think you were "+ this.generateOldOpinion(relationship ));
			chatText += chatLine(player2Start, player2, "?");
			chatText += chatLine(player1Start, player1, "But now....");
			//maybe have different things happen here based on class?
			chatText += chatLine(player1Start, player1, "Fuck, this is too hard. Nevermind.");
		}
		setTimeout(function(){
			drawChat(canvasDiv, player1, player2, chatText, repeatTime);
		}, repeatTime*1.2);  //images aren't always loaded by the time i try to draw them the first time.
	}
	
	this.renderContent = function(div){
		//alert("drama!");
		//div.append(this.content());
		for(var i = 0; i<this.dramaPlayers.length; i++){
				var p = this.dramaPlayers[i];
				this.renderForPlayer(div, p);
			}
		
	}
	
	this.matchTypeToOpinion = function(type, relationship){
		if(type == relationship.badBig){
			return getRandomElementFromArray(bigBadDesc);
		}
		
		if(type == relationship.badMild){
			return getRandomElementFromArray(bigMildDesc);
		}
		
		if(type == relationship.goodBig){
			return getRandomElementFromArray(goodBigDesc);
		}
		
		if(type == relationship.goodMild){;
			return getRandomElementFromArray(goodMildDesc);
		}
	}
	
	this.generateOldOpinion = function(relationship){
		return this.matchTypeToOpinion(relationship.old_type, relationship);
	}
	
	this.generateNewOpinion = function(relationship){
		return this.matchTypeToOpinion(relationship.saved_type, relationship);
	}
	
	/*
		this.saved_type = "";
	this.drama = false; //drama is set to true if type of relationship changes.
	this.old_type = "";
	this.goodMild = "Friends";
	this.goodBig = "Totally In Love";
	this.badMild = "Rivals";
	this.badBig = "Enemies";
	*/
	this.processDrama = function(player, relationship){
		var ret = " The " + player.htmlTitle() + " used to think that the " + relationship.target.htmlTitle() + " was ";
		ret += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";	
		
		if(relationship.saved_type == relationship.goodBig && relationship.target.dead){
			player.triggerLevel ++;
			ret += " They are especially devestated to realize this only after the " + relationship.target.htmlTitle() + " died. ";
		}
		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;
		return ret;
		
	}
	
	this.content = function(){
		//describe what the drama is.  if the drama player is dead, skip.  if their target is dead, comment on that. (extra drama.  Only when he is a corpse do you realize...you love him.)
		var ret = " ";
		if(this.dramaPlayers.length > 2){
			ret += " So much drama has been going on. You don't even know. ";
		}
		for(var i = 0; i< this.dramaPlayers.length; i++){
			var p = this.dramaPlayers[i];
			var relationships = p.getRelationshipDrama();
			for(var j = 0; j<relationships.length; j++){
				ret += this.processDrama(p, relationships[j]);
			}
	
		}
		return ret;
	}
}