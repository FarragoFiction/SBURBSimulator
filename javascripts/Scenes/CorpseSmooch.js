//x times corpse smooch combo. 
function CorpseSmooch(){
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.dreamersToRevive = []; 
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.dreamersToRevive = [];
		//all dead players who aren't god tier and are destined to be god tier god tier now. 
		var deadPlayers = findDeadPlayers(playerList);
		for(var i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			//only get one shot at this. if you're a jerk, no luck.
			if(p.dreamSelf && p.getFriends().length > 0){
				this.dreamersToRevive.push(p);
			}
		}
		//corspses can't smooch themselves. 
		return this.dreamersToRevive.length > 0 && this.dreamersToRevive.length < playerList.length;
		
	}
	
	//prefer to be smooched by prince who doesn't hate you, or person who likes you best. 
	this.content = function(){
		var ret = "";
		var combo = 0;
		for(var i = 0; i<this.dreamersToRevive.length; i++){
			var d = this.dreamersToRevive[i];
			//have best friend mac on you.
			var royalty = d.getWhoLikesMeBestFromList(findLivingPlayers(availablePlayers));
			
			if(!royalty){
				//okay, princes are traditional...
				royalty = findClassPlayer(findLivingPlayers(availablePlayers), "Prince");
			}
			if(!royalty){
				//okay, anybody free?
				royalty = getRandomElementFromArray(findLivingPlayers(availablePlayers));
			}
			
			//shit, maybe your best friend can drop what they are doing to save your ass?
			if(!royalty){
				royalty = d.getWhoLikesMeBestFromList(findLivingPlayers(players));
			}
			//is ANYBODY even alive out there????
			if(!royalty){
				royalty = getRandomElementFromArray(findLivingPlayers(players));
			}
			
			if(royalty){
				royalty.triggerLevel ++;
				ret += " The " + royalty.htmlTitle() + ", as a member of the royalty of " + royalty.moon + ", administers the universal remedy for the unawakened ";
				ret += " to the " + d.htmlTitle() + ". Their dream self takes over on " + d.moon + ". ";
				d.dead = false;
				d.dreamSelf = false;
				d.isDreamSelf = true;
				d.murderMode = false;
				d.grimDark = false;
				d.triggerLevel = 1;
				combo ++;
			}else{
				ret += d.htmlTitle() + "'s corpse waits patiently for the kiss of life. But nobody came. ";
				ret += " Their dream self dies as well. ";
				d.dreamSelf = false;
			}
		}
		if(combo > 1){
			ret += combo +"X CORPSEMOOCH COMBO!!!";
		}
		//x times corpse smooch combo
		return ret;
		
	}
	
}