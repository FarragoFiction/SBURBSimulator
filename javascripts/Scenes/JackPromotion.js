function JackPromotion(session){
	this.canRepeat = false;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		return (this.session.jackStrength > this.session.queenStrength*2) && (this.session.jackStrength > 0) && this.session.queenStrength >  -9999;
	}

	this.content = function(){
		this.session.jackStrength = this.session.kingStrength * 2;
		var ret = " In a shocking turn of events, Jack Noir claims the Black Queen's RING OF ORBS " + this.convertPlayerNumberToWords();
		ret += "FOLD. "
		if(this.session.queenStrength > 0){
			ret += "He easily defeats the weakened queen and uses her ring to obtain her power. ";
		}else{
			ret += " He pries the ring off her still twitching finger. ";
		}
		ret += " You'd think this would be no worse than having the Black Queen around, but Jack is kind of a big deal. ";
		ret += " He immediately decides to show everybody his stabs. ";
		var badPrototyping = findBadPrototyping(this.playerList);
		this.session.queenStrength = -9999;

		if( badPrototyping == "First Guardian"){
			ret += " He is now in charge of random teleporation murders. ";
		}
		return ret;
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	this.convertPlayerNumberToWords = function(){
		//alien players don't count
		var ps = findPlayersFromSessionWithId(this.session.players, this.session.session_id);
		if(ps.length == 0){
			ps = this.session.players;
		}
		var length = ps.length;
		if(length == 2){
			return "TWO";
		}else if(length == 3){
			return "THREE";
		}else if(length == 4){
			return "FOUR";
		}else if(length == 5){
			return "FIVE";
		}else if(length == 6){
			return "SIX";
		}else if(length == 7){
			return "SEVEN";
		}else if(length == 8){
			return "EIGHT";
		}else if(length == 9){
			return "NINE";
		}else if(length == 10){
			return "TEN";
		}else if(length == 11){
			return "ELEVEN";
		}else if(length == 12){
			return "TWELVE";
		}
	}
}
