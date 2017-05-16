function JackPromotion(session){
	this.canRepeat = false;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		return (this.session.queen.crowned == null) && (this.session.jack.getHP() > 0) && (this.session.jack.getPower() > this.session.queen.getPower());
	}

	this.addImportantEvent = function(){
		var current_mvp =  findStrongestPlayer(this.session.players)
		return this.session.addImportantEvent(new JackPromoted(this.session, current_mvp.power) );
	}


	this.content = function(){
		this.session.jack.crowned = this.session.queensRing;
		this.session.queen.crowned = null;
		var ret = " In a shocking turn of events, Jack Noir claims the Black Queen's RING OF ORBS " + this.session.convertPlayerNumberToWords();
		ret += "FOLD. "
		if(this.session.queen.crowned && !this.session.queen.exiled){
			if(this.session.queen.getHP() > 0){
				ret += "He easily defeats the weakened queen and uses her ring to obtain her power. ";
				this.session.queen.currentHP = -9999; //actually kill her you dunkass.
			}else{
				ret += " He pries the ring off her still twitching finger. ";
			}
		}else{
			ret += "It's not hard at all to get his Crew to pull off a heist to get the RING OF ORBS "+ this.session.convertPlayerNumberToWords();
			ret += "FOLD. "
			if(this.session.queen.getHP() > 0 && !this.session.queen.exiled){
				ret += "He easily defeats the weakened queen while he's at it. ";
			}
		}
		ret += " You'd think this would be no worse than having the Black Queen around, but Jack is kind of a big deal. ";
		ret += " He immediately decides to show everybody his stabs. ";
		var badPrototyping = findBadPrototyping(this.playerList);


		if( badPrototyping == "First Guardian"){
			ret += " He is now in charge of random teleporation murders. ";
		}
		return ret;
	}

	this.renderContent = function(div){
		var alt = this.addImportantEvent();
		//console.log("Alt for jack promotion is: " + alt);
		if(alt && alt.alternateScene(div)){
			return;
		}
		div.append("<br>"+this.content());
	}


}
