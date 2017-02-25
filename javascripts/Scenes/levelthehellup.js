function LevelTheHellUp(){
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		for(var i = 0; i<playerList.length; i++){  //can happen even after death, because why not?
			var p = playerList[i];
			if(p.leveledTheHellUp){
				return true;
			}
		}
		return false;
	}

	this.getBoonies = function(p){
		var num = + p.power * 15;
		var denomination = " BOONDOLLARS";
		if(num > 1000000){
			num = Math.floor(num/1000000)
			denomination = " BOONMINTS"
		}else if(num > 100000){
			num = Math.floor(num/100000)
			denomination = " BOONBANKS"
		}
		else if(num > 10000){
			num = Math.floor(num/10000)
			denomination = " BOONBONDS"
		}else if(num > 1000){
			num = Math.floor(num/1000)
			denomination = " BOONBUCKS"
		}
		num += Math.floor(Math.random()*75);
		return num + denomination;
	}

	this.content = function(){
		var ret = "";
		for(var i = 0; i<this.playerList.length; i++){
			var p = this.playerList[i];
			if(p.leveledTheHellUp){
				var levelName = p.getNextLevel(); //could be undefined
				if(levelName){
					ret += " The " + p.htmlTitle();
					if(p.dead){
						ret += "'s corpse "
					}
					ret += " skyrockets up the ECHELADDER to a new rung: " + levelName;
					ret +=	" and earns " + this.getBoonies(p) + ". ";
			}
				p.leveledTheHellUp = false;
			}
		}
		return ret;
	}
}
