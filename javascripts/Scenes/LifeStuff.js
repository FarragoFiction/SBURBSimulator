function LifeStuff(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.combo = 0;

	//arrays of [life/Doom player, other player] pairs. other player can be a corpse. other player can be null;
	this.enablingPlayerPairs = [];

	//it's weird. even though this class treats Life and Doom players as the same, in practice they behave entirely differently.
	//life players keep people from dying in the first place with high HP, while doom players make them die a LOT and become empowered by the afterlife.
	
	//what kind of priority should this have. players shouldn't fuck around in ream bubbles instead of land quests. but they also shouldn't avoid reviving players.
	//maybe revive stuff always happens, but anything else has a random chance of not happening?
	this.trigger = function(playerList){
		//not just available players. if class that could revive SELF this way, can be called on dead. otherwise requires a living life/doom player.
		if(this.session.afterLife.ghosts.length == 0) return false; //can't exploit the afterlife if there isn't one.
		//first, check the dead.
		var dead = findDeadPlayers(this.session.players)
		for(var i = 0; i<dead.length; i++){
			var d = dead[i];
			if(d.aspect == "Life" || d.aspect == "Doom"){
				if(d.class_name == "Thief" || d.class_name == "Heir"){
					this.enablingPlayerPairs.push([d, null]); //gonna revive myself.
				}
			}
		}
		console.log("modify scratch code so that a life player of sufficient power will kill everyone at the last minute so they can be in the bubbles instead of non existant.") //recusriveSlacker idea
		
		return false;

	}

	//IMPORTANT, ONLY SET AVAILABLE STATUS IF YOU ACTUALLY DO YOUR THING. DON'T SET IT HERE. MIGHT TRIGGER WITH A PRINCE WHO DOESN'T HAVE ANY DEAD SELVES TO DESTROY.
	this.renderContent = function(div){
		//div.append("<br>"+this.content());
		for(var i = 0; i<this.enablingPlayerPairs.length; i++){
			var player = this.enablingPlayerPairs[i][0];
			var other_player = this.enablingPlayerPairs[i][0]; //could be null or a corpse.
			if(player.dead){
				if(player.class_name == "Heir" ||  player.class_name == "Thief"){
					destroyDeadForReviveSelf(div, player);
				}
			}else{
				if(player.class_name == "Mage" ||  player.class_name == "Knight"){
					communeDead(div, player);
				}else if((player.class_name == "Seer" ||  player.class_name == "Page") && other_player && !other_player.dead){
					helpPlayerCommuneDead(div, player, other_player);
				}else if(player.class_name == "Prince"){
					destroyDeadForPower(div, player);
				}else if(player.class_name == "Bard" && other_player && !other_player.dead){
					helpPlayerDestroyDeadForPower(div, player, other_player);
				}else if(player.class_name == "Rogue" ||  player.class_name == "Maid") && other_player && other_player.dead){
					helpDestroyDeadForReviveSelf(div, player, other_player);
				}else if(player.class_name == "Witch" ||  player.class_name == "Sylph") && !this.session.dreamBubbleAfterlife ){
					enableDreamBubbles(div, player);
				}else if(this.session.dreamBubbleAfterlife){
					dreamBubbleAfterlifeAction(div, player);
				}
			}
		}
	}
	
	
	//first try to find dead quadrants.
	//then try to find dead selves.
	//then, whatever.
	this.findGhostToCommuneWith = function(div, player){
		
	}
	
	//only when dream bubble afterlife is true. 1-4 players returned?
	this.findGhostsToCommuneWith = function(div, player){
		
	}
	
	//different flavor of afterlife based on derse or prospit?  derse has horror terror everywhere. prospit after life is filled with visions of the alpha timeline, taunting you.
	//so...if derse bubbles are Tumblr, then prospit are facebook (full of envy)
	//hang out with some random ghosts, get power boost. player on left, pile of ghosts on right.
	this.dreamBubbleAfterlifeAction = function(div, player){
		
	}
	
	//mages/knights call this directly.    flavor text of knowledge or power.
	this.communeDead = function(div, player){
		
	}
	
	//seers/pages call this which calls communeDeadForKnowledge. seer/page gets boost at same time.
	this.helpPlayerCommuneDead = function(div, player1, player2){
		
	}
	

	
	//prince kills their own ghosts and takes their power.  if not prince, can be anybody you kill. mention 'it will be a while before the ghost of X respawns' don't bother actually respawning them , but makes it different than double death
	this.destroyDeadForPower = function(div, player){
		
	}
	
	//bards call this to power up somebody else with the dead. they gain power at same time.
	this.helpPlayerDestroyDeadForPower = function(div, player1, player2){
		
	}
	
	//thief/heir of life/doom //flavor text of absorbing or stealing.  mention 'it will be a while before the ghost of X respawns' don't bother actually respawning them , but makes it different than double death
	this.destroyDeadForReviveSelf = function(div, player){
		
	}
	
	//rogue/maid of life/doom
	this.helpDestroyDeadForReviveSelf = function(div, player1, player2){
		
	}
	

	
	//witches and sylphs do this.  not gonna go with a passive/active whatever here. i just want more odds of dream bubble afterlifes. 
	//different flavor of afterlife based on derse or prospit?  derse has horror terror everywhere. prospit after life is filled with visions of the alpha timeline, taunting you.
	this.enableDreamBubbles = function(div, player){
		this.session.dreamBubbleAfterlife = true;
	}

	//for claspects that can recycyle afterlife.
	this.makeAlive = function(d){
		if(d.stateBackup) d.stateBackup.restoreState(d);
		d.influencePlayer = null;
		d.influenceSymbol = null;
		d.dead = false;
		d.murderMode = false;
		d.grimDark = false;
		d.triggerLevel = 1;
		d.leftMurderMode = false; //no scars
		d.victimBlood = null; //clean face
	}

	this.makeDead = function(d){
		//console.log("make dead " + d.title())
		d.dead = true;
	}



	//1.0 mode is so not a thing anymore. just assume this isn't a thing.
	this.content = function(){
		var ret = "TODO: LIfe stuff. for 1.0";
		
		return ret;

	}

}
