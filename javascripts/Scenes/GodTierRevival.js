function GodTierRevival(){
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.godsToRevive = []; 
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.godsToRevive = [];
		//all dead players who aren't god tier and are destined to be god tier god tier now. 
		var deadPlayers = findDeadPlayers(playerList);
		for(var i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			//only get one shot at this.
			if(p.godTier && p.canGodTierRevive){
				this.godsToRevive.push(p);
			}
		}
		return this.godsToRevive.length > 0;
		
	}
	
	this.renderContent = function(div){
		div.append(this.content());
	}
	
	this.content = function(){
		var ret = " The game abstraction of the Judgement Clock is ruling on the death of the " + getPlayersTitles(this.godsToRevive ) + ". ";
		
		for(var i = 0; i< this.godsToRevive.length; i++){
			var p = this.godsToRevive[i];
			ret += " The " + p.htmlTitle() + "'s death is judged to be ";
			if(p.justDeath()){
				ret += " JUST.  They do not revive. ";
				p.canGodTierRevive = false;
			}else if (p.heroicDeath()){
				ret += " HEROIC. They do not revive. ";
				p.canGodTierRevive = false;
			}else{
				ret += " neither HEROIC nor JUST.  They revive in a rainbow glow, stronger than ever. ";
				p.dead = false;
				p.canGodTierRevive = true;
				p.increasePower();	
				p.murderMode = false;
				p.grimDark = false;
				p.triggerLevel = 1;
				
			}
			
		}
		return ret;
	}
}