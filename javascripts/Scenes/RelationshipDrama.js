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
	
	this.renderContent = function(div){
		div.append(this.content());
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