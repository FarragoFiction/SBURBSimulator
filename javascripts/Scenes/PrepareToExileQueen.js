function PrepareToExileQueen(){
	
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null; 
	
	this.findSufficientPlayer = function(){
		this.player =  findAspectPlayer(availablePlayers, "Void");
		
		if(this.player == null){
			this.player =  findAspectPlayer(availablePlayers, "Mind");
		}else if(this.player == null){
			this.player =  findClassPlayer(availablePlayers, "Thief");
		}else if(this.player == null){
			this.player =  findClassPlayer(availablePlayers, "Rogue");
		}
	}
	
	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}
	
	this.trigger = function(playerList){
		this.player = null;
		this.playerList = playerList;
		this.findSufficientPlayer(availablePlayers);
		return (this.player != null) && (queenStrength > 0);
	}
	
	this.spyContent = function(){
		var ret = "The " + this.player.htmlTitle() + " performs a daring spy mission,";
		if(this.player.power > kingStrength/100){
			queenStrength += -10;
			ret += " gaining valuable intel to use on the Black Queen. ";
		}else{
			ret += " but hilariously bungles it. ";
		}
		return ret;
	}
	
	this.assasinationContent = function(){
		var ret = "The " + this.player.htmlTitle() + " performs a daring assasination mission against one of the Black Queen's agents,";
		if(this.player.power > kingStrength/100){
			queenStrength += -15;
			ret += " losing her a valuable ally. ";
		}else{
			ret += " but hilariously bungles it. ";
		}
		return ret;
	}
	
	this.harrassContent = function(){
		var ret = "The " + this.player.htmlTitle() + " makes a general nuisance of themselves to the Black Queen. ";
		queenStrength += -5;
		return ret;
	}
	
	this.content = function(){
		this.player.increasePower();
		removeFromArray(this.player, availablePlayers);
		var rand = Math.random();
		if(rand > .3){
			return this.harrassContent();
		}else if(rand > .6){
			return this.spyContent();
		}else{
			return this.assasinationContent();
		}
	}
}