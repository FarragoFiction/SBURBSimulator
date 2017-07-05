function GiveJackBullshitWeapon(session){
	this.session = session;
	this.canRepeat = false;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		var partyRoll = partyRollForLuck(this.session.players)
		var jackRoll = this.session.jack.rollForLuck()
		//if(partyRoll< jackRoll) console.log("We rolled: " + partyRoll + " jack rolled: " + jackRoll);
		return (!this.session.queen.exiled && !this.session.jack.exiled && this.session.jack.crowned == null) && (this.session.jack.getStat("currentHP") > 0 && partyRoll < jackRoll );
	}

	this.content = function(){
		this.session.jackGotWeapon = true;


		var ret = " Jack Noir is tired of putting up with the STUPID LOUSY WISE AND JUST LEADER, what a royal pain in the ass. ";
		ret += " It's bad enough she makes him handle every single piece of paperwork in all of Derse, does she really need to rub salt in his wounds and make him dress up in frivolous outfits as well?";
		ret += " So, it's no surprise that Jack murders the Black Queen the second he finds a Legendary weapon amongst the confiscated packages of Prospit. ";
		this.session.queen.currentHP = -9999999999; //not even ring can keep her alive.
		this.session.queen.dead = true;
		return ret;
	}

	this.renderContent = function(div){
		div.append("<br><img src = 'images/sceneIcons/jack_icon.png'> "+this.content());
	}

	this.convertPlayerNumberToWords = function(){
		if(players.length == 2){
			return "TWO";
		}else if(players.length == 3){
			return "THREE";
		}else if(players.length == 4){
			return "FOUR";
		}else if(players.length == 5){
			return "FIVE";
		}else if(players.length == 6){
			return "SIX";
		}else if(players.length == 7){
			return "SEVEN";
		}else if(players.length == 8){
			return "EIGHT";
		}else if(players.length == 9){
			return "NINE";
		}else if(players.length == 10){
			return "TEN";
		}else if(players.length == 11){
			return "ELEVEN";
		}else if(players.length == 12){
			return "TWELVE";
		}
	}
}
