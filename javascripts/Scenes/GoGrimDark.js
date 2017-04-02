function GoGrimDark(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;

	this.trigger = function(playerList){
		this.playerList = playerList;
		//select a random player. if they've been triggered, random chance of going grim dark (based on how triggered.)
		this.player = getRandomElementFromArray(this.session.availablePlayers);

		if(this.player){

			var moon = 0;
			if(this.player.moon == "Derse"){
				moon = 1;
			}
			if(this.player.triggerLevel + moon > 0 && !this.player.grimDark){  //easier to grimdark if you have access to horror terrors.
				if((Math.seededRandom() * 10) < this.player.triggerLevel +moon-1){
					if(this.player.murderMode && Math.seededRandom() < .5) { //slightly less chance of being both
						return false;
					}
					//console.log("Going Grim dark with trigger of: " + this.player.triggerLevel)
					return true;
				}
			}
		}
		return false;
	}

	this.addImportantEvent = function(){
		var current_mvp =  findStrongestPlayer(this.session.players)
		return this.session.addImportantEvent(new PlayerWentGrimDark(this.session, current_mvp.power,this.player) );
	}

	this.renderContent = function(div){
		var alt = this.addImportantEvent();
		if(alt && alt.alternateScene(div)){
			return;
		}
		div.append("<br>"+this.content());
	}

	this.content = function(){
		this.player.increasePower();
		removeFromArray(this.player, this.session.availablePlayers);
		var ret = "The " + this.player.htmlTitle() + " slips into the fabled blackdeath trance of the woegothics, quaking all the while in the bloodeldritch throes of the broodfester tongues.";
		ret += " It is now painfully obvious to anyone with a brain, they have basically gone completely off the deep end in every way. The "
		ret += this.player.htmlTitle() + " has officially gone grimdark. ";
		this.player.grimDark = true;
		this.player.power = this.player.power +=200; //as much as god tiering, but without the future power boost.
		this.player.nullAllRelationships();
		ret += " They abandon ties to their old life in exchange for power. ";
		return ret;
	}
}
