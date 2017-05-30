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
		
		/*
				Since this dialogue has no "purpose", no information that HAS to be conveyed, can treat it as more dynamic.
				Go for bullshit elder scrolls pairs. 
				
				Greeting (based on quadrant, not generic greetings)
				Greeting
				
				chatPair1, chatPair2, chatPair3
				
				where chatPair is a call and response about one of several topics, each of which have multiple random call/response things it can deploy
				
				Have you heard about Kvatch?
				No.
				
				I have been to the Imperial City recently.
				I've heard others say the same.
				
				I have nothing more to say to you.
				Good day.
				
				<3<3<3 elder scrolls. They are such ASSHOLES to each other.
				
				Chat pairs can be generated from: interests in common, quadrants, and relationship value (quardrant and value being separate allows impending breakups to be foreshadowed.)
				ALSO, flipOutReason (but only for diamonds. so maybe that's just a quadrant thing.)
				
				
		*/
		
	}

	this.content = function(){
		return "NEVER RUN IN 1.0 YOU DUNKASS."
	}


}
