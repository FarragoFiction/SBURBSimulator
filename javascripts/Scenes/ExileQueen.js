function ExileQueen(session){
	this.session = session;
	this.canRepeat = false;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		return (this.session.queen.getPower()<10 );
	}

	this.content = function(){
		console.log("trying to exile queen: " + this.session.session_id)
		var ret = ""
		if(this.session.queen.getHP() > 0 && this.session.queen.crowned){
			ret = " The plan has been performed flawlessly.  The Black Queen has been exiled to the post-Apocalyptic version of Earth, never to be heard from again. ";
			ret += " Her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is destroyed before her exile in a daring mission. ";
			this.session.queensRing = null; //no longer exists.
		}else if(this.session.queen.crowned && this.session.queen.getHP() <= 0){
			ret += "There were some hitches in the plan, and the Black Queen is now a corpse rather than an exile. "
			ret += " Her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is recovered and destroyed in a daring mission. ";
			this.session.queensRing = null; //no longer exists.
		}else if(this.session.queen.getHP() > 0){
			ret += " The plan has been performed flawlessly.  The Black Queen has been exiled to the post-Apocalyptic version of Earth, never to be heard from again. Too bad you couldn't get her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD at the same time, but at least that's one boss fight outta the way. ";;
		}else{
			ret += "There were some hitches in the plan, and the Black Queen is now a corpse rather than an exile. She doesn't even have her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD to destroy. Whatever. You exile her corpse anyways. NEVER turn your back on the body. ";
		}

		this.session.queen.power = 11; //don't trigger this again. her corpse can be a little strong, whatever.
		this.session.queen.hp = -999990; //effectively dead.
		this.session.queen.currentHP = -999990; //effectively dead.
		return ret;
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

}
