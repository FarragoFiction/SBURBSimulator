function ExileQueen(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		//trying to make queen's corpse stop being exiled.
		return (queenStrength < 10) && (jackStrength > 0) && (!queenUncrowned) && (queenStrength >0);
	}
	
	this.content = function(){
		queenStrength = 0;
		var ret = " The plan has been performed flawlessly.  The Black Queen has been exiled to the post-Apocalyptic version of Earth, never to be heard from again. ";
		ret += " Her RING OF ORBS " + this.convertPlayerNumberToWords() + "FOLD is destroyed before her exile in a daring mission. ";
		queenUncrowned = true; //jack can't steal ring
		return ret;
	}
	
	this.renderContent = function(div){
		div.append("<br>"+this.content());
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