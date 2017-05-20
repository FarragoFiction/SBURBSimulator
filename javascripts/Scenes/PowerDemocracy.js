function PowerDemocracy(session){
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.session = session;
	//a player has to be not busy to be your friend right now.
	this.trigger = function(playerList){
		this.playerList = playerList;


		return (this.session.democracyStrength > 0);
	}

	this.renderContent = function(div){
		div.append("<br><img src = 'images/sceneIcons/wv_icon.png'>"+this.content());
	}


	this.content = function(){
		var ret = "";
		var rand = Math.seededRandom();
		if(rand < .25){
			ret += getRandomElementFromArray(democracyTasks);
			this.session.democraticArmy.power += 10;
			this.session.democraticArmy.mobility += 10;
			this.session.democraticArmy.currentHP += 10;
		}else if(rand < .5){
			ret += getRandomElementFromArray(democracyTasks);
			this.session.democraticArmy.power += 20;
			this.session.democraticArmy.mobility += 20;
			this.session.democraticArmy.currentHP += 20;
		}else if(rand < .75){
			ret += getRandomElementFromArray(democracySuperTasks);
   		this.session.democraticArmy.power += 50;
			this.session.democraticArmy.mobility += 50;
			this.session.democraticArmy.currentHP += 50;
		}else{
			//do nothing.
			ret += getRandomElementFromArray(mayorDistractionTasks);
		}
		return ret;
	}
}
