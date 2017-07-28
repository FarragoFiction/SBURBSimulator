part of SBURBSim;


class ExileQueen extends Scene {


	


	ExileQueen(Session session): super(session, false);

	@override
	bool trigger(playerList){
		this.playerList = playerList;
		return (this.session.queen.getStat("power")<10 && !this.session.queen.exiled );
	}
	dynamic content(){
		print("trying to exile queen: " + this.session.session_id.toString());
		String ret = "";
		if(this.session.queen.getStat("currentHP") > 0 && this.session.queen.crowned != null){
			ret = " The plan has been performed flawlessly.  The Black Queen has been exiled to the post-Apocalyptic version of Earth, never to be heard from again. ";
			ret += " Her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is destroyed before her exile in a daring mission. ";
			this.session.destroyBlackRing();
		}else if(this.session.queen.crowned !=null  && this.session.queen.getStat("currentHP") <= 0){
			ret += "There were some hitches in the plan, and the Black Queen is now a corpse rather than an exile. ";
			ret += " Her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is recovered and destroyed in a daring mission. ";
			this.session.destroyBlackRing();
		}else if(this.session.queen.getStat("currentHP") > 0){
			ret += " The plan has been performed flawlessly.  The Black Queen has been exiled to the post-Apocalyptic version of Earth, never to be heard from again. Too bad you couldn't get her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD at the same time, but at least that's one boss fight outta the way. ";;
		}else{
			ret += "There were some hitches in the plan, and the Black Queen is now a corpse rather than an exile. She doesn't even have her RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD to destroy. Whatever. You exile her corpse anyways. NEVER turn your back on the body. ";
		}

		this.session.queen.setStat("currentHP", -999990); //effectively dead.
		this.session.queen.dead = true;
		this.session.queen.exiled = true;
		return ret;
	}
	@override
	void renderContent(Element div){
		appendHtml(div,"<br>"+this.content());
	}


}
