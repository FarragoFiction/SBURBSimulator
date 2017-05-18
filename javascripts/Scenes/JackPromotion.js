function JackPromotion(session){
	this.canRepeat = false;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		if(this.session.jack.getHP() <= 0) return false;  //jack can't be dead.
		if(this.session.queensRing == null) return false; //all is moot if no ring
		if(this.session.jack.crowned != null) return false; //don't steal the ring from yourself, dunkass

		//jack is alive, and stronger than queen. (even if queen is dead, this means her lackeys are undisciplined)
		if(this.session.jack.getPower() > this.session.queen.getPower()){
			return true;
		}

		return false;
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
				if(Math.seededRandom() > .5){
					//and now the players still have to fight her.  ringless sure, but....
					this.session.queen.power = 50; //she gets a morale boost, any weakening she had is reduced.
					ret += " At this point you would EXPECT him to kill the weakened Queen, but somehow they end up making out??? Dersites, am I right?  He still ends up with the RING, though."
				}else{
					ret += "He easily murders the weakened queen and uses her ring to obtain her power. ";
					this.session.queen.currentHP = -9999; //actually kill her you dunkass. not KISS her.
				}

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
