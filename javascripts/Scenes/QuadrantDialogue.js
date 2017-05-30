function KingPowerful(session){
	this.session=session;
	this.canRepeat = true;
	this.player1 = null;
	this.player2 = null;

	this.trigger = function(){
		this.player1 = null;
		this.player2 = null;
		/*
			two ways I can do this:
			Either I can select a player at random, and if they are in a quadrant, return true.
			OR, pass a random number test, then  filter players down to only those who are in a quadrant, and return true.
			
			First one is probably easiest, but hardest to modify rate of triggering.
			Stop picking the laziest way to do things, dunkass.
		*/
		if(Math.seededRandom() > 0.5){
			findRandomQuadrantedAvailablePlayer();
			findQuardrantMate();
		}
		return false;
	}
	
	this.findRandomQuadrantedAvailablePlayer(){
		//set this.player1 to be a random quadranted player.
	}
	
	this.findQuardrantMate(){
		//set this.player2 to be one of player1's quadrant mates. first diamond, then heart, then spade, then clubs.
	}

	this.renderContent = function(div){
		if(this.player1.aspect != "Time") removeFromArray(this.player1, this.session.availablePlayers);
		if(this.player2.aspect != "Time") removeFromArray(this.player2, this.session.availablePlayers);
		
		
	}

	this.content = function(){
		return "NEVER RUN IN 1.0 YOU DUNKASS."
	}


}
