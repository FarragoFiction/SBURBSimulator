function ExileQueen(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		//trying to make queen's corpse stop being exiled.
		return (this.session.queenStrength < 10) && (this.session.queenStrength > -9999);
	}

	this.content = function(){
		var ret = ""
		if(this.session.queenStrength > 0){
			var ret = " The plan has been performed flawlessly.  The Black Queen has been exiled to the post-Apocalyptic version of Earth, never to be heard from again. ";
			ret += " Her RING OF ORBS " + this.convertPlayerNumberToWords() + "FOLD is destroyed before her exile in a daring mission. ";
		}else{
			ret += "There were some hitches in the plan, and the Black Queen is now a corpse rather than an exile. "
			ret += " Her RING OF ORBS " + this.convertPlayerNumberToWords() + "FOLD is recovered and destroyed in a daring mission. ";
		}

		queenUncrowned = true; //jack can't steal ring
		this.session.queenStrength = -9999;
		return ret;
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	this.convertPlayerNumberToWords = function(){
		if(this.session.players.length == 2){
			return "TWO";
		}else if(this.session.players.length == 3){
			return "THREE";
		}else if(this.session.players.length == 4){
			return "FOUR";
		}else if(this.session.players.length == 5){
			return "FIVE";
		}else if(this.session.players.length == 6){
			return "SIX";
		}else if(this.session.players.length == 7){
			return "SEVEN";
		}else if(this.session.players.length == 8){
			return "EIGHT";
		}else if(this.session.players.length == 9){
			return "NINE";
		}else if(this.session.players.length == 10){
			return "TEN";
		}else if(this.session.players.length == 11){
			return "ELEVEN";
		}else if(this.session.players.length == 12){
			return "TWELVE";
		}
	}
}
