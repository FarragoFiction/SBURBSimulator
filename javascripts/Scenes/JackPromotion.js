function JackPromotion(session){
	this.canRepeat = false;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		if(this.session.jack.getStat("currentHP") <= 0 || this.session.jack.exiled) return false;  //jack can't be dead or exiled.
		if(this.session.queensRing == null) return false; //all is moot if no ring
		if(this.session.jack.crowned != null) return false; //don't steal the ring from yourself, dunkass
		//console.log("jack is alive, there is a queens ring and jack doesn't have it: " + this.session.session_id)
		//jack is alive, and stronger than queen. (even if queen is dead, this means her lackeys are undisciplined)
		if(this.session.jack.getStat("power") > this.session.queen.getStat("power") || this.session.queen.currentHP <= 0){
			return true;
		}

		return false;
	}

	this.addImportantEvent = function(){
		var current_mvp =  findStrongestPlayer(this.session.players)
		return this.session.addImportantEvent(new JackPromoted(this.session, current_mvp.power) );
	}


	this.content = function(){
		var ret = " In a shocking turn of events, Jack Noir claims the Black Queen's RING OF ORBS " + this.session.convertPlayerNumberToWords();
		ret += "FOLD. "
		if(this.session.queen.crowned && !this.session.queen.exiled){
			if(this.session.queen.getStat("currentHP") > 0){
				if(Math.seededRandom() > .5){
					console.log("Jack making out like a bandit in session: " + this.session.session_id); //get it? 'cause cause he is making otu with BQ but also stealing from her???'
					//and now the players still have to fight her.  ringless sure, but....
					this.session.queen.power = 50; //she gets a morale boost, any weakening she had is reduced.
					ret += " At this point you would EXPECT him to kill the weakened Queen, but somehow they end up making out??? Dersites, am I right?  He still ends up with the RING, though."
				}else{
					console.log("jack murdering queen instead of kissing her in sessin: " + this.session.session_id)
					ret += "He easily murders the weakened queen and uses her ring to obtain her power. ";
					this.session.queen.currentHP = -9999; //actually kill her you dunkass. not KISS her.
					this.session.queen.dead = true;
				}

			}else{
				ret += " He pries the ring off her still twitching finger. ";
			}
		}else{
			ret += "It's not hard at all to get his Crew to pull off a heist to get the RING OF ORBS "+ this.session.convertPlayerNumberToWords();
			ret += "FOLD. "
			if(this.session.queen.getStat("currentHP") > 0 && !this.session.queen.exiled){
				if(Math.seededRandom() > .5){
					console.log("Jack making out like a bandit in session: " + this.session.session_id); //get it? 'cause cause he is making otu with BQ but also stealing from her???'
					//and now the players still have to fight her.  ringless sure, but....
					this.session.queen.power = 50; //she gets a morale boost, any weakening she had is reduced.
					ret += " At this point you would EXPECT him to kill the weakened Queen, but somehow they end up making out??? Dersites, am I right?  He still ends up with the RING, though."
				}else{
					console.log("jack murdering queen instead of kissing her in sessin: " + this.session.session_id)
					ret += "He easily defeats the weakened queen while he's at it. ";
					this.session.queen.currentHP = -9999; //actually kill her you dunkass. not KISS her.
				}
			}
		}
		ret += " You'd think this would be no worse than having the Black Queen around, but Jack is kind of a big deal. ";
		ret += " He immediately decides to show everybody his stabs. ";
		var badPrototyping = findBadPrototyping(this.playerList);
		this.session.jack.crowned = this.session.queensRing;
		this.session.queen.crowned = null;

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
		div.append("<br> <img src = 'images/sceneIcons/jack_icon.png'>"+this.content());
	}


}
