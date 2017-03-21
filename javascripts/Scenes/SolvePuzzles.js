//if i am page or blood player, can't do this alone.

function SolvePuzzles(session){
	this.session = session;
	this.canRepeat = true;	
	this.player1 = null;
	this.player2 = null; //optional
	
	
	this.checkPlayer = function(player){
		this.player1 = player;
		this.player2 = null;
		if(player.aspect == "Blood" || player.class_name == "Page"){
			if(this.session.availablePlayers.length > 1){
				this.player2 = getRandomElementFromArray(this.session.availablePlayers);
				if(this.player2 == this.player1 && this.player2.aspect != "Time"){
					this.player1 = null;
					this.player2 = null;
					return null;
				}
				
			}else{
				this.player1 = null; 
				return null;
			}
		}
		
		//if i'm not blood or page, random roll for a friend.
		if(this.session.availablePlayers.length > 1 && Math.seededRandom() > .5){
			this.player2 = getRandomElementFromArray(this.session.availablePlayers);
			if(this.player2 == this.player1 && this.player1.aspect != "Time"){  //only time player can help themselves out.
				this.player2 == null
			}
		}
		
	}
	this.trigger = function(playerList){
		this.player1 = null; //reset
		this.player2 = null;
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			this.checkPlayer(this.session.availablePlayers[i]);
			if(this.player1 != null && this.player1.land != null){
				return true;
			}
		}
		if(this.player1 == null || this.session.availablePlayers.length == 0 || this.player1.land == null){
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
	
	
	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}
	
	this.content = function(){
		var ret = "";
		//remove player1 and player2 from available player list.
		removeFromArray(this.player1, this.session.availablePlayers);
		removeFromArray(this.player2, this.session.availablePlayers);
		var r1 = null;
		var r2 = null;
		this.player1.increasePower();
		if(this.player2 != null &&  this.player1  != this.player2){  //could be a time double, don't have a relationship with a time double (it never works out)
			this.player1.increasePower();
			r1 = this.player1.getRelationshipWith(this.player2);
			r1.moreOfSame();
			r2 = this.player2.getRelationshipWith(this.player1);
			r2.moreOfSame();
		}
		
		this.checkBloodBoost();
		
		ret += "The " + this.player1.htmlTitle();
		if(this.player2 != null && (this.player2.aspect != this.player1.aspect ||this.player2.aspect == "Time")){ //seriously, stop having clones of non time players!!!!
			ret += " and the " + this.player2.htmlTitle() + " do "; 
		}else{
			ret += " does " 
		}
		ret += " random bullshit sidequests at " + this.player1.shortLand();
		ret += ", solving puzzles and getting coy hints about The Ultimate Riddle. "
		
		if(this.player2 != null && this.player1  != this.player2 ){
			ret += getRelationshipFlavorText(r1,r2, this.player1, this.player2);
		}
		return ret;
	}
	
	
}