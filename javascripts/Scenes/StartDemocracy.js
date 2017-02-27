/*
  A war weary villan will approach certain types of players.
  Breath, Doom, Mind, Seer, Page, or Rogue
  
  They will ask for help overthrowing all Royalty.
  
  Players work to weaken and Exile Queen. 
  
  During Reckoning, WarWeary Villain assembles and army to help fight King.
  
  During ending, if democracy = true, mention that.
*/

function StartDemocracy(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.friend = null;
	
	//blood or page or thief or rogue. 
	this.findSympatheticPlayer = function(){
		this.friend =  findClassPlayer(availablePlayers, "Rogue");
		if(this.friend == null){
			this.friend =  findClassPlayer(availablePlayers, "Page");
		}else if(this.friend == null){
			this.friend =  findAspectPlayer(availablePlayers, "Mind");
		}else if(this.friend == null){
			this.friend =  findAspectPlayer(availablePlayers, "Hope");
		}
	}
	
	this.renderContent = function(div){
		div.append(this.content());
	}
	
	//a player has to be not busy to be your friend right now.
	this.trigger = function(playerList){
		this.playerList = playerList;
		if(kingStrength <= 0 || queenStrength <= 0){  //the dead can't scheme or be schemed against
			return false;
		}
		this.findSympatheticPlayer();
		
		return (democracyStrength <= 0 ) && (this.friend != null);
	}
	
	this.content = function(){
		this.friend.increasePower();
		removeFromArray(this.friend, availablePlayers);
		available_scenes.unshift( new PrepareToExileQueen());  //make it top priority, so unshift, don't push
		available_scenes.unshift( new ExileQueen());  //make it top priority, so unshift, don't push
		available_scenes.unshift( new PowerDemocracy());  //make it top priority, so unshift, don't push

		var ret = " The " + this.friend.htmlTitle() + " is just minding their own business when they are approached by an adorable little Dersite. ";
		ret += " The Dersite introduces himself as a Warweary Villein hoping to recruit a Champion. ";
		ret += " He wishes to end this stupid war, caused by the excesses of the Monarchy. "
		ret += " The Warweary Villein just hates the Monarchy.  They are petty, bossy tyrants and are really full of themselves and are basically awful in every way. "
		ret += " The " + this.friend.htmlTitle() + " can't help but be persuaded by the adorable rant. Look at the little guy's clenched fists! ";
		ret += " A plan is hatched to exile the Queen, and the Dersite promises an army to help fight the King. ";
		democracyStrength += 50;
		return ret;
	}
}