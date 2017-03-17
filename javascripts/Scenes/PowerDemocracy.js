function PowerDemocracy(){
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	
	//a player has to be not busy to be your friend right now.
	this.trigger = function(playerList){
		this.playerList = playerList;

		
		return (democracyStrength > 0);
	}
	
	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	
	this.content = function(){
		var ret = "";
		var rand = Math.seededRandom();
		if(rand < .25){
			ret += getRandomElementFromArray(democracyTasks);
			democracyStrength += 5;
		}else if(rand < .5){
			ret += getRandomElementFromArray(democracyTasks);
			democracyStrength += 10;
		}else if(rand < .75){
			ret += getRandomElementFromArray(democracySuperTasks);
			democracyStrength += 50;
		}else{
			//do nothing.
			ret += getRandomElementFromArray(mayorDistractionTasks);
		}
		return ret;
	}
}