function QueenRejectRing(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		var goodPrototyping = findGoodPrototyping(this.playerList);
		return goodPrototyping != null && queenStrength > 0;
	}
	
	this.renderContent = function(div){
		div.append(this.content());
	}
	
	this.content = function(){
		queenStrength = 50;
		queenUncrowned = true;
		var goodPrototyping = findGoodPrototyping(this.playerList);
		var ret = "The Queen, with her RING OF ORBS " + this.convertPlayerNumberToWords();
		ret += "FOLD would take on the attributes of each prototyping. ";
		ret += " She would become part " + this.playerList[0].kernel_sprite;
		for(var i = 1; i<this.playerList.length-1; i++){
			ret += ", part " + this.playerList[i].kernel_sprite ;
		}
		
		ret += ". ";
		if(this.playerList.length != players.length){
			ret += " She would even stand eventually being prototyped with " ;
			ret += players[this.playerList.length].kernel_sprite ;
		}
		for(var i = this.playerList.length+1; i<players.length; i++){
			ret += ", and " + players[i].kernel_sprite;
		}
		
		if(this.playerList.length != players.length){
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
	
	this.convertPlayerNumberToWords = function(){
		if(players.length == 2){
			return "TWO";
		}else if(players.length == 3){
			return "THREE";
		}else if(players.length == 4){
			return "FOUR";
		}else if(players.length == 5){
			return "FIVE";
		}else if(players.length == 6){
			return "SIX";
		}else if(players.length == 7){
			return "SEVEN";
		}else if(players.length == 8){
			return "EIGHT";
		}else if(players.length == 9){
			return "NINE";
		}else if(players.length == 10){
			return "TEN";
		}else if(players.length == 11){
			return "ELEVEN";
		}else if(players.length == 12){
			return "TWELVE";
		}
	}
}