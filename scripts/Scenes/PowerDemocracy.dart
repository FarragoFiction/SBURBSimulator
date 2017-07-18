part of SBURBSim;


class PowerDemocracy extends Scene{
	bool canRepeat = true;
	List<dynamic> playerList = [];  //what players are already in the medium when i trigger?



	PowerDemocracy(Session session): super(session);

	@override
	bool trigger(playerList){
		this.playerList = playerList;


		return (this.session.democracyStrength > 0);
	}

	@override
	void renderContent(div){
		div.append("<br><img src = 'images/sceneIcons/wv_icon.png'>"+this.content());
	}
	dynamic content(){
		String ret = "";
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
