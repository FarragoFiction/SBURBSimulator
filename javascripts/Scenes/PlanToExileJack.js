function PlanToExileJack(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.planner = null;
	//blood or page or thief or rogue. 
	this.findSympatheticPlayer = function(){
		this.planner =  findAspectPlayer(availablePlayers, "Mind");
		if(this.planner == null){
			this.planner =  findAspectPlayer(availablePlayers, "Doom");
		}else if(this.planner == null){
			this.planner =  findAspectPlayer(availablePlayers, "Light");
		}else if(this.planner == null){
			this.planner =  findClassPlayer(availablePlayers, "Seer");
		}
	}
	
	this.renderContent = function(div){
		div.append(this.content());
	}
	
	//a player has to be not busy to be your friend right now.
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.findSympatheticPlayer();
		return this.planner != null && jackStrength != 0 && queenStrength != 0; //don't plan to exile jack if he's already fllipping the fuck out.
	}
	
	this.content = function(){
		this.planner.increasePower();
		removeFromArray(this.planner, availablePlayers);
		available_scenes.unshift( new prepareToExileJack());
		available_scenes.unshift( new ExileJack());
		var ret = " The " + this.planner.htmlTitle() + " is getting a bad feeling about Jack Noir. "
		ret += " Even though he is their ally, he has stabbed players on multiple occasions, for example. ";
		ret += "There's only so many 'accidents' a single Desite can reasonably have. ";
		ret += "A plan is pulled together.  If a Queen can be exiled, why not a Jack as well? ";
		ret += " Of course, it wouldn't do to tip Jack off to the change of allegiance. You may as well continue to weaken the Queen while you're at it. ";
		return ret;
	}
}