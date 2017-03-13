function ExploreMoon(){
	this.canRepeat = true;	
	this.player1 = null;
	this.player2 = null; //optional
	
	this.checkPlayer = function(player){
		this.player1 = player;
		if(this.player1.dreamSelf == false){ //can't explore a moon without a dream self.
			this.player1 = null;
			return null;
		}
		
		if(player.aspect == "Blood" || player.class_name == "Page"){
			if(availablePlayers.length > 1){
				this.player2 = getRandomElementFromArray(availablePlayers);
				if(this.player2 == this.player1){
					this.player1 = null;
					this.player2 = null;
					return null;
				}
				if(this.player1.moon != this.player2.moon || !this.player2.dreamSelf){
					this.player2 = null;
					return null;
				}
				
			}else{
				this.player1 = null; 
				return null;
			}
		}
		
		//if i'm not blood or page, random roll for a friend.
		if(availablePlayers.length > 1 && Math.random() > .5){
			this.player2 = getRandomElementFromArray(availablePlayers);
			if(this.player1 == this.player2 || !this.player2.dreamSelf || this.player1.moon != this.player2.moon){
				this.player2 = null;
			}
		}
		
	}
	
	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}
	this.trigger = function(playerList){
		this.player1 = null; //reset
		this.player2 = null;
		for(var i = 0; i<availablePlayers.length; i++){
			this.checkPlayer(availablePlayers[i]);
			if(this.player1 != null){
				return true;
			}
		}
		if(this.player1 == null || availablePlayers.length == 0){
			return false;
		}
		return true;
		
		
	}
	
	this.checkBloodBoost = function(){
		if(this.player1.aspect == "Blood" && this.player2 != null){
			this.player2.boostAllRelationships
		}
		
		if(this.player2!=null && this.player2.aspect == "Blood"){
			this.player1.boostAllRelationships();
		}
	}
	
	this.content = function(){
		var ret = "";
		//remove player1 and player2 from available player list.
		removeFromArray(this.player1, availablePlayers);
		removeFromArray(this.player2, availablePlayers);
		var r1 = null;
		var r2 = null;
		this.player1.increasePower();
		if(this.player2 != null){
			this.player1.increasePower();
			r1 = this.player1.getRelationshipWith(this.player2);
			r1.moreOfSame();
			r2 = this.player2.getRelationshipWith(this.player1);
			r2.moreOfSame();
		}
		
		this.checkBloodBoost();
		
		ret += "The " + this.player1.htmlTitle();
		if(this.player2 != null){
			ret += " and the " + this.player2.htmlTitle() + " do "; 
		}else{
			ret += " does "
		}
		if(this.player1.moon == "Prospit"){
			ret += "whimsical moon activities, such as attending dance parties, fluttering about aimlessly and chatting up Prospitans. ";
			ret += " The visions of the future provided by Skaia were largely ignored. ";
		}else{
			ret += "whimsical moon activities, such as attending dance parties, cheating at poker and keeping tabs on the lifeblood of Derse. ";
			ret += " The whisperings of the HorrorTerrors provided a nice backdrop. ";
		}
		
		if(this.player2 != null){
			if(r1.type() == " Totally In Love" && r2.type() == "Totally In Love"){
				ret += " The two flirt a bit. ";
			}else if(r2.type() == "Totally In Love"){
				ret += " The" + this.player2.htmlTitle() + " is flustered around the " + this.player1.htmlTitle();
			}else if(r1.type() == "Totally In Love"){
				ret += " The" + this.player1.htmlTitle() + " is flustered around the " + this.player2.htmlTitle();
			}else if(r1.type() == "Rivals" && r2.type() == "Rivals"){
				ret += " The two compete to see who can solve more puzzles. ";
			}else if(r2.type() == "Rivals"){
				ret += this.player2.htmlTitle() + " is irritable around the " + this.player1.htmlTitle() + ". ";
			}else if(r1.type() == "Rivals"){
				ret += " The" + this.player1.htmlTitle() + " is irritable around " + this.player2.htmlTitle();
			}
		}
		return ret;
	}
	
}