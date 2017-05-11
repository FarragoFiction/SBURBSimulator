function PrepareToExileQueen(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;

	this.findSufficientPlayer = function(){
		this.player =  findAspectPlayer(this.session.availablePlayers, "Void");

		if(this.player == null){
			this.player =  findAspectPlayer(this.session.availablePlayers, "Mind");
		}else if(this.player == null){
			this.player =  findClassPlayer(this.session.availablePlayers, "Thief");
		}else if(this.player == null){
			this.player =  findClassPlayer(this.session.availablePlayers, "Rogue");
		}
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	this.trigger = function(playerList){
		this.player = null;
		this.playerList = playerList;
		this.findSufficientPlayer(this.session.availablePlayers);
		return (this.player != null) && (this.session.queen.getHP() > 0 && !this.session.queen.exiled);
	}

	this.spyContent = function(){
		var ret = "The " + this.player.htmlTitle() + " performs a daring spy mission,";
		if(this.player.power > this.session.queen.getPower()/100){
			this.session.queen.power += -10;
			ret += " gaining valuable intel to use on the Black Queen. ";
		}else{
			ret += " but hilariously bungles it. ";
		}
		return ret;
	}

	this.assasinationContent = function(){
		var ret = "The " + this.player.htmlTitle() + " performs a daring assassination  mission against one of the Black Queen's agents,";
		if(this.player.power > this.session.queen.power/100){
			this.session.queen.power += -15;
			ret += " losing her a valuable ally. ";
		}else{
			ret += " but hilariously bungles it. ";
		}
		return ret;
	}

	this.harrassContent = function(){
		var ret = "The " + this.player.htmlTitle() + " makes a general nuisance of themselves to the Black Queen. ";
		this.session.queen.power += -5;
		return ret;
	}

	this.content = function(){
		this.player.increasePower();
		removeFromArray(this.player, this.session.availablePlayers);
		var rand = Math.seededRandom();
		if(rand > .3){
			return this.harrassContent();
		}else if(rand > .6){
			return this.spyContent();
		}else{
			return this.assasinationContent();
		}
	}
}
