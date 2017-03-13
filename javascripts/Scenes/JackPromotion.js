function JackPromotion(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		return (jackStrength > queenStrength*2) && (jackStrength > 0) && !queenUncrowned;
	}
	
	this.content = function(){
		jackStrength = kingStrength * 2;
		var ret = " In a shocking turn of events, Jack Noir claims the Black Queen's RING OF ORBS " + this.convertPlayerNumberToWords();
		ret += "FOLD. "
		if(queenStrength > 0){
			ret += "He easily defeats the weakened queen and uses her ring to obtain her power. ";
		}else{
			ret += " He pries the ring off her still twitching finger. ";
		}
		ret += " You'd think this would be no worse than having the Black Queen around, but Jack is kind of a big deal. ";
		ret += " He immediately decides to show everybody his stabs. ";
		var badPrototyping = findBadPrototyping(this.playerList);
				queenStrength = 0;

		if( badPrototyping == "First Guardian"){
			ret += " He is now in charge of random teleporation murders. ";
		}
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