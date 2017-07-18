part of SBURBSim;


class ExileQueen extends Scene {
	bool canRepeat = false;
	List<dynamic> playerList = [];  //what players are already in the medium when i trigger?

	


	ExileQueen(Session session): super(session);

	@override
	dynamic trigger(playerList){
		this.playerList = playerList;
		return (this.session.queen.getStat("power")<10 && !this.session.queen.exiled );
	}
	dynamic content(){
		print("trying to exile queen: " + this.session.session_id);
		String ret = "";
		if(this.session.queen.getStat("currentHP") > 0 && this.session.queen.crowned){
			ret = " The plan has been performed flawlessly.  The Black Queen has been exiled to the post-Apocalyptic version of Earth, never to be heard from again. ";
			ret += " Her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is destroyed before her exile in a daring mission. ";
			this.session.destroyBlackRing();
		}else if(this.session.queen.crowned && this.session.queen.getStat("currentHP") <= 0){
			ret += "There were some hitches in the plan, and the Black Queen is now a corpse rather than an exile. ";
			ret += " Her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is recovered and destroyed in a daring mission. ";
			this.session.destroyBlackRing();
		}else if(this.session.queen.getStat("currentHP") > 0){
			ret += " The plan has been performed flawlessly.  The Black Queen has been exiled to the post-Apocalyptic version of Earth, never to be heard from again. Too bad you couldn't get her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD at the same time, but at least that's one boss fight outta the way. ";;
		}else{
			ret += "There were some hitches in the plan, and the Black Queen is now a corpse rather than an exile. She doesn't even have her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD to destroy. Whatever. You exile her corpse anyways. NEVER turn your back on the body. ";
		}

		this.session.queen.hp = -999990; //effectively dead.
		this.session.queen.dead = true;
		this.session.queen.currentHP = -999990; //effectively dead.
		this.session.queen.exiled = true;
		return ret;
	}
	@override
	void renderContent(div){
		div.append("<br>"+this.content());
	}


}
