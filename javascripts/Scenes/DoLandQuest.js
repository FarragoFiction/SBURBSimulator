
//all available players do this. (so put this quest at the end, right before solving puzzles and dream bs.)
//get quest from either class or aspect array in random tables. if space, only aspect array (frog);

//can get help from another player, different bonuses based on claspect if so.
function DoLandQuest(){
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.playersPlusHelpers = []; //who is doing a land quest this turn?
	
	this.trigger = function(playerList){
		//console.log("do land quest trigger?")
		this.playersPlusHelpers = [];
		
		for(var i = 0; i<availablePlayers.length; i++){
			var p = availablePlayers[i]
			if(p.power > 2){ //can't be first thing you do in medium.
				if(p.landLevel < 6 || p.aspect == "Space"){  //space player is the only one who can go over 100 (for better frog)
					var helper = this.lookForHelper(p);
					var playerPlusHelper = [p,helper];
					
					if((p.aspect == "Blood" || p.class_name == "Page") ){// if page or blood player, can't do it on own.
						if(playerPlusHelper[1] != null){
							this.playersPlusHelpers.push(playerPlusHelper);
							removeFromArray(p, availablePlayers);
							removeFromArray(helper, availablePlayers); //don't let my helper do their own quests.
						}
					}else{
						this.playersPlusHelpers.push(playerPlusHelper);
						removeFromArray(p, availablePlayers);
						removeFromArray(helper, availablePlayers); //don't let my helper do their own quests.
					}					
				}
			}
		}
		//console.log(this.playersPlusHelpers.length + " players are available for quests.");
		return this.playersPlusHelpers.length > 0;
	}
	
	this.renderContent = function(div){
		div.append(this.content());
	}
	
	this.lookForHelper = function(player){
		var helper = null;
		
		//space player can ONLY be helped by knight, and knight prioritizes this
		if(player.aspect == "Space"){
			helper = findClassPlayer(availablePlayers, "Knight");
			if(helper != player){ //a knight of space can't help themselves.
				return helper;
			}else{
				return null
			}
		}
		
		if(player.aspect == "Time" && Math.random() > .2){ //time players often partner up with themselves
			return player;
		}
		
		if(player.aspect == "Blood" || player.class_name == "Page"){ //they NEED help.
			if(availablePlayers.length > 1){
				helper = getRandomElementFromArray(availablePlayers);			
			}else{
				this.player1 = null; 
				return null;
			}
		}

		
		//if i'm not blood or page, or space, or maybe time random roll for a friend.
		if(availablePlayers.length > 1 && Math.random() > .5){
			helper = getRandomElementFromArray(availablePlayers);
			if(player == helper ){  
				return null;
			}
		}
		if(helper != player || player.aspect == "Time"){
			return helper;
		}
		
		return null;
		
	}
	
	this.calculateClasspectBoost = function(player, helper){
		var ret = "";
		if(helper == player){
			player.landLevel ++;
			player.increasePower();
			return " Partnering up with your own time clones sure is efficient. ";
		}
		//okay, now that i know it's not a time clone, look at my relationship with my helper.
		var r1 = player.getRelationshipWith(helper);
		var r2 = helper.getRelationshipWith(player);
		
		if(helper.aspect == "Blood"){
			player.boostAllRelationships();
			player.triggerLevel += -1;
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " spends a great deal of time helping the " + player.htmlTitle() + " out with their relationship drama. " ;
			}else{
				ret += ret += " The " + helper.htmlTitle() + " spends a great deal of time lecturing the " + player.htmlTitle() + " about the various ways a player can be triggered into going shithive maggots. " ;
			}
		}
		
		if(helper.aspect == "Time" || helper.aspect == "Light" || helper.aspect == "Hope" || helper.aspect == "Mind" || helper.className == "Page" || helper.className == "Seer"){
			player.landLevel ++; 
			helper.increasePower();
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " is doing a kickass job of helping the " + player.htmlTitle() + ". " ;
			}else{
				ret += ret += " The " + helper.htmlTitle() + " delights in rubbing how much better they are at the game in the face of the " + player.htmlTitle() + ". " ;
			}
		}
		
		if(helper.aspect == "Rage"){
			player.damageAllRelationships();
			player.triggerLevel += 1;
			helper.triggerLevel += 1;
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " spends a great deal of time shit talking about the other players. ";
			}else{
				ret += ret += " The " + helper.htmlTitle() + " spends a great deal of time making the " + player.htmlTitle() + " aware of every bad thing the other players have said behind their back. " ;
			}
		}
		
		if(helper.aspect == "Doom"){
			player.landLevel += 1;
			helper.landLevel +=-1;
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " figures the " + player.htmlTitle() + " could make better use of some quest items, so generously donates them to the cause. ";
			}else{
				ret += " The " + helper.htmlTitle() + " condescendingly says that since the " + player.htmlTitle() + "  is so bad at the game, they'll donate some of their quest items to them. ";
			}
		}
		
		if(helper.className == "Thief"){
			player.landLevel += -1;
			helper.landLevel ++;
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " covertly spends at least half of their time diverting resources to complete their own quests. ";
			}else{
				ret += ret += " The " + helper.htmlTitle() + " blatantly steals resources from the" + player.htmlTitle() + ", saying that THEIR quests are just so much more important. " ;
			}
		}
		return ret;		
		
	}
	
	this.content = function(){
		var ret = "";
		for(var i = 0; i<this.playersPlusHelpers.length; i++){
			var player = this.playersPlusHelpers[i][0];
			var helper = this.playersPlusHelpers[i][1]; //might be null
			ret += "The " + player.htmlTitle()  ;
			player.increasePower();
			player.landLevel ++;
			if(helper){
				ret += " and the " + helper.htmlTitle() + " do " ;
				helper.increasePower();
				player.landLevel ++;
			}else{
				ret += " does";
			}
			
			if(Math.random() >0.8){
				ret += " quests at " + player.shortLand();
			}else{
				ret += " quests in the " + player.land;
			}
			ret += ", " + player.getRandomQuest() + ". ";
			if(helper){
				ret += this.calculateClasspectBoost(player, helper);
			}
			if(helper != null && player  != helper ){
				r1 = player.getRelationshipWith(helper);
				r1.moreOfSame();
				r2 = helper.getRelationshipWith(player);
				r2.moreOfSame();
				ret += getRelationshipFlavorText(r1,r2, player, helper);
		}
			
		}
		return ret;
	}
	
}