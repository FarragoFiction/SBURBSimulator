function QueenRejectRing(session){
	this.canRepeat = false;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		var nativePlayersInSession = findPlayersFromSessionWithId(playerList);
		var goodPrototyping = findGoodPrototyping(playerList);
		//console.log("holy fucking shit, don't reject the ring if an alien player comes in.")
		return goodPrototyping != null && this.session.queen.crowned;
	}

	this.renderContent = function(div){
		div.append("<br> <img src = 'images/sceneIcons/bq_icon.png'> "+this.content());
	}

	this.content = function(){
		this.session.queenRejectRing = true;
		this.session.queen.crowned = null; //queen no longer has ring, but session still does.
		var goodPrototyping = findGoodPrototyping(this.playerList);
		var ret = "The Queen, with her RING OF ORBS " + this.session.convertPlayerNumberToWords();
		ret += "FOLD would take on the attributes of each prototyping. ";
		ret += " She would become part " + this.playerList[0].object_to_prototype.htmlTitle();
		for(var i = 1; i<this.playerList.length-1; i++){
			ret += ", part " + this.playerList[i].object_to_prototype.htmlTitle() ;
		}

		ret += ". ";
		if(this.playerList.length != this.session.players.length && this.session.players[this.playerList.length].land){
			ret += " She would even stand eventually being prototyped with " ;
			ret += this.session.players[this.playerList.length].object_to_prototype.htmlTitle() ;
		}
		for(var i = this.playerList.length+1; i<this.session.players.length; i++){
			if(this.session.players[i].land) ret += ", and " + this.session.players[i].object_to_prototype.htmlTitle();
		}

		if(this.playerList.length != this.session.players.length){
			ret += ". ";
		}

		ret += " Though a queen is a vain creature, she is also sworn to her duty. ";
		ret += " She would be braced for the heavy load of augmentation ahead. ";
		ret += " However, there was one corruption to her figure she could not abide. Her vanity would not allow it. ";
		ret += " She could not stand bearing the visage of the most loathsome creature known to exist, the " + goodPrototyping + ". ";
		ret += " She removed the ring and concealed it in the ROYAL VAULT. ";
		ret += " She then retired to her private chamber from which she would dispatch orders, ";
		ret += " no one the wiser of her disadvantage. Or so she thought."
		return ret;
	}


}
