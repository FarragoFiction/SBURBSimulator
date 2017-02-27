//known to lesser mortals as God Tier
function GetTiger(){
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.deadPlayersToGodTier = [];
	
	//doesn't matter if dream self 'cause sacrificial slab.
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.deadPlayersToGodTier = [];
		if(reckoningStarted){
			return false; //can't god tier if you are definitely on skaia. (makes king fight too easy)
		}
		//all dead players who aren't god tier and are destined to be god tier god tier now. 
		var deadPlayers = findDeadPlayers(playerList);
		for(var i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			if(!p.godTier && p.godDestiny){
				this.deadPlayersToGodTier.push(p);
			}
		}
		return this.deadPlayersToGodTier.length > 0;
		
	}
	
	this.renderContent = function(div){
		div.append(this.content());
	}
	
	this.content = function(){
		var ret = getPlayersTitles(this.deadPlayersToGodTier) + " was always destined to take a Legendary Nap, and upon waking, become a God Tier. ";
		
		var withd = findPlayersWithDreamSelves(this.deadPlayersToGodTier);
		var withoutd = findPlayersWithoutDreamSelves(this.deadPlayersToGodTier);
		
		if(withd){
			for(var i = 0; i< withd.length; i++){
				var p = withd[i];
				ret += " Upon being laid to rest on their QUEST BED on the " + p.land + ", the " + p.htmlTitle() + "'s body glows, and rises Skaiaward. "
				ret +="On " + p.moon + ", their dream self takes over and gets a sweet new outfit to boot.  ";
			}
		}
		
		if(withoutd){
			for(var i = 0; i< withoutd.length; i++){
				var p = withoutd[i];
				ret += " Upon a wacky series of events leaving their corpse on their SACRIFICIAL SLAB on " + p.moon + ", the " + p.htmlTitle() + " glows and ascends to the God Tiers with a sweet new outfit."
			}
		}
		
		ret += " They are now extremely powerful. ";
		
		if(findClassPlayer(this.deadPlayersToGodTier, "Page") != null){
			ret += " Everyone fails to ignore the Page's outfit. ";
		}
		
		for(var  i = 0; i<this.deadPlayersToGodTier.length; i++){
			var p = this.deadPlayersToGodTier[i];
			p.godTier = true;
			p.dreamSelf = false;
			p.murderMode = false;
			p.grimDark = false;
			p.triggerLevel = 1;
			p.dead = false;
			p.power += 200;
			p.canGodTierRevive = true;
		}
		return ret;
	}
}