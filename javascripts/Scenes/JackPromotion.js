function JackPromotion(session){
	this.canRepeat = false;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		return (this.session.jackStrength > this.session.queenStrength*2) && (this.session.jackStrength > 0) && this.session.queenStrength >  -9999;
	}
	
	this.addImportantEvent = function(){
		var current_mvp =  findStrongestPlayer(this.session.players)
		this.session.addImportantEvent(new JackPromoted(this.session, current_mvp.power) );
	}

	this.content = function(){
		var alternate_timeline = this.addImportantEvent();
		console.log("do something with alternate timeline " + this.session.session_id)
		this.session.jackStrength = this.session.kingStrength * 2;
		var ret = " In a shocking turn of events, Jack Noir claims the Black Queen's RING OF ORBS " + this.session.convertPlayerNumberToWords();
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

	
}
