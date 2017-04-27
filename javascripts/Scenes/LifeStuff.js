function LifeStuff(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.combo = 0;

	//arrays of [life/Doom player, other player] pairs. other player can be a corpse. other player can be null;
	this.enablingPlayerPairs = [];

	//if I am a thief or heir, can be called even if I am dead. (my revival mechanism)
	//otherwise, if dreamBubbleAfterlife, any player can call this at any time
	//otherwise, go through all doom/life players.  triggers are different based on class. some won't trigger unless they or someone else is dead, for example.
	//
	this.trigger = function(playerList){
		//not just available players. if class that could revive SELF this way, can be called on dead. otherwise requires a living life/doom player.
		return false;

	}

	//mage, seer, knight, page, prince, bard, thief, rogue, heir, maid, 
	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}
	
	//first try to find dead quadrants.
	//then try to find dead selves.
	//then, whatever.
	this.findGhostToCommuneWith = function(player){
		
	}
	
	//mages call this directly.
	this.communeDeadForKnowledge = function(player){
		
	}
	
	//seers call this which calls communeDeadForKnowledge. seer gets boost at same time.
	this.helpPlayerCommuneDeadForKnowledge = function(player1, player2){
		
	}
	
	//Knights call this directly. more dead, more power.
	this.communeDeadForPower = function(player){
		
	}
	
	//page helps another player gain power from communing with dead. page gets boost at same time.
	this.helpPlayerCommuneDeadForPower = function(player1, player2){
		
	}
	
	//prince kills their own ghosts and takes their power.
	this.destroyDeadForPower = function(player){
		
	}
	
	//bards call this to power up somebody else with the dead. they gain power at same time.
	this.helpPlayerDestroyDeadForPower = function(player1, player2){
		
	}
	
	//thief of life/doom
	this.destroyDeadForReviveSelf = function(player){
		
	}
	
	//rogue of life/doom
	this.helpDestroyDeadForReviveSelf = function(player1, player2){
		
	}
	
	//heirs do this to themselves
	this.useGhostAsBackupLife = function(player){
		
	}
	
	//maids call this for any dead player. calls useGhostAsBackupLife
	this.helpUseGhostAsBackupLife = function(player1, player2){
		
	}
	
	//witches and sylphs do this.  not gonna go with a passive/active whatever here. i just want more odds of dream bubble afterlifes. 
	this.enableDreamBubbles = function(player){
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




	this.content = function(){
		var ret = "TODO: LIfe revive.";
		
		return ret;

	}

}
