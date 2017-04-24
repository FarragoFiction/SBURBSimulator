function VoidyStuff(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.player = findAspectPlayer(this.session.availablePlayers, "Void");
		return this.player != null;
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	this.content = function(){
		removeFromArray(this.player, this.session.availablePlayers);
		var ret = "The " + this.player.htmlTitle() + " is doing...something. It's kind of hard to see.";
		var rand = Math.seededRandom();

		if(rand > .3){
			this.player.boostAllRelationships();
		}else if(rand > .5){
			this.player.damageAllRelationships();
			ret += " Everybody seems to be pretty pissed at them, though. ";
			if(Math.seededRandom() > .9){  //randomly go grim dark when you aren't looking
				this.player.corruptionLevelOther += getRandomInt(1,100);
				ret += " You get a bad feeling about this. ";
			}else if(Math.seededRandom() > .9){
				this.player.triggerLevel = 3;
				this.player.murderMode = true;
				ret += " You get a bad feeling about this. ";
			}else if (Math.seededRandom() > .95){
				this.player.dead = true;
				this.causeOfDeath = "doing voidy shenanigans, probably"
				ret += " You get a bad feeling about this. ";
			}
		}else{
			this.player.increasePower();
		}

		if(Math.seededRandom() > .5 && this.player.land != null){
			this.player.landLevel ++;
			ret += " Their consorts seem pretty happy, though. " ;
		}else{
			this.session.queenStrength += -5;
			this.session.jackStrength += -5;
			this.session.kingStrength += -5;
			ret += " The Dersites sure seem to be mad at them, though. ";
		}

		if(this.player.godDestiny && Math.seededRandom()>0.8 && this.player.land != null){  //just randomly freaking god tier.
			this.player.godTier = true;
			this.player.dreamSelf = false;
			ret += " What was that dark blue light on " + this.player.shortLand() + "? ";
		}
		if(this.player.leader && !this.session.ectoBiologyStarted && Math.seededRandom() > .8){
			this.player.performEctobiology();
			ret += " Wait. Are those BABIES!? What is even going on here?";
		}

		if(this.player.landLevel >= 6 && this.player.land != null && !this.player.denizenFaced && Math.seededRandom() > .5){
			this.player.denizenFaced = true;
			ret += " Why is the denizen, " + this.player.getDenizen() + " bellowing so loudly on " + this.player.shortLand() + "? ";
			if(Math.seededRandom() >.5){
				this.player.power = this.player.power*2;  //current and future doubling of power.
				this.player.leveledTheHellUp = true;
				this.player.denizenDefeated = true;
			}else{
				if(this.player.getFriends().length < this.player.getEnemies().length){
					this.player.denizenFaced = true;
					this.player.denizenDefeated = false;
					ret += " That didn't sound good... ";
					this.player.dead = true;
					this.player.causeOfDeath = "fighting their Denizen way too early";
				}else{
					this.player.denizenDefeated = false;
				}
			}
		}

		return ret;
	}
}
