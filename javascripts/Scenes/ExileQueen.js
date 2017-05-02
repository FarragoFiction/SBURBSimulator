function ExileQueen(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		//trying to make queen's corpse stop being exiled.
		return (this.session.queen.getPower()<10 && this.session.queen.crowned != null);
	}

	this.content = function(){
		var ret = ""
		if(this.session.queen.getHP() > 0){
			var ret = " The plan has been performed flawlessly.  The Black Queen has been exiled to the post-Apocalyptic version of Earth, never to be heard from again. ";
			ret += " Her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is destroyed before her exile in a daring mission. ";
		}else{
			ret += "There were some hitches in the plan, and the Black Queen is now a corpse rather than an exile. "
			ret += " Her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is recovered and destroyed in a daring mission. ";
		}

		this.session.queensRing = null; //no longer exists.
		this.session.queen.hp = 0; //effectively dead.
		return ret;
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

}
