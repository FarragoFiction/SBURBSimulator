function Player(class_name, aspect, land, kernel_sprite, moon, godDestiny, interests, chat_handle){
	this.class_name = class_name;
	this.chatHandle = chat_handle;
	this.aspect = aspect;
	this.land = land; //TODO maybe separate this out. lands can be in charge of quests?
	this.kernel_sprite = kernel_sprite;
	this.relationships = [];
	this.moon = moon;
	this.power = 1;
	this.leveledTheHellUp = false; //triggers level up scene.
	this.godTier = false;
	this.hair = getRandomInt(1,34);
	//this.hair = 16;
	this.hairColor = getRandomElementFromArray(human_hair_colors);
	this.dreamSelf = true;
	this.isTroll = false; //later
	this.bloodColor = "#ff0000" //human red.
	this.leftHorn = 0;
	this.interests = interests;
	this.rightHorn = 0;
	this.lusus = "Adult Human"
	this.quirk = null;
	this.dead = false;
	this.godDestiny = godDestiny;
	this.doomedClones = 0; //mostly only used by time player, functions as extra life (i.e. dave got stabbed by jack, but it was just a doomed dave)
	//should only be false if killed permananetly as god tier
	this.canGodTierRevive = true;  //even if a god tier perma dies, a life or time player or whatever can brings them back.
	this.isDreamSelf = false;
	//players can be triggered for various things. higher their triggerLevle, greater chance of going murdermode or GrimDark.
	this.triggerLevel = 0;
	this.murderMode = false;  //kill all players you don't like. odds of a just death skyrockets.
  	this.grimDark = false;  //all relationships set to 0. power up a lot. odds of  a just death skyrockets.
	this.leader = false;
	this.landLevel = 0; //at 10, you can challenge denizen.  only space player can go over 100 (breed better universe.)
	this.denizenFaced = false; //when faced, you double in power (including future power increases.)
	this.denizenDefeated = false;
	this.causeOfDeath = ""; //fill in every time you die. only matters if you're dead at end
	this.doomedTimeClones = 0; //only used by Time player. works as extra lives and power multiplier (against king/queen only).
	//for space player, this is necessary for frog breeding to be minimally succesfull.

	this.chatHandleShort = function(){
		return this.chatHandle.match(/\b(\w)|[A-Z]/g).join('').toUpperCase();
	}
	
	this.title = function(){
		var ret = "";

		if(this.murderMode){
			ret += "Murder Mode ";
		}

		if(this.grimDark){
			ret += "Grim Dark ";
		}

		if(this.godTier){
			ret+= "God Tier "
		}else if(this.isDreamSelf){
			ret+= "Dream ";
		}
		ret+= this.class_name + " of " + this.aspect;
		return ret;
	}
	
	this.titleBasic = function(){
		var ret = "";

		ret+= this.class_name + " of " + this.aspect;
		return ret;
	}


	this.getRandomLevel = function(){
		if(Math.random() > .5){
			return getRandomLevelFromAspect(this.aspect);
		}else{
			return getRandomLevelFromClass(this.class_name);
		}

	}

	this.getRandomQuest = function(){
		if(Math.random() > .5 || this.aspect == "Space"){ //space players pretty much only get FrogBreeding duty.
			return getRandomQuestFromAspect(this.aspect);
		}else{
			return getRandomQuestFromClass(this.class_name);
		}

	}

	this.getDenizen = function(){
		return getDenizenFromAspect(this.aspect);
	}

	//more likely if lots of people hate you
	this.justDeath = function(){
		var ret = false;
		//if much less friends than enemies.
		if(this.getFriends().length < this.getEnemies().length){
			if(Math.random() > .9){ //just deaths are rarer without things like triggers.
				ret = true;
			}
			//way more likely to be a just death if you're being an asshole.
			if((this.murderMode || this.grimDark) && Math.random()>.2){
				ret = true;
			}
		}

		return ret;
	}

	//more likely if lots of people like you
	this.heroicDeath = function(){
		var ret = false;
		//if far more enemies than friends.
		if(this.getFriends().length > this.getEnemies().length ){
			if(Math.random() > .6){
				ret = true;
			}
			//extra likely if you just killed the king/queen, you hero you.
			if(kingStrength <=0 && Math.random()>.2){
				ret = true;
			}
		}
		if(ret){
			console.log("heroic death");
		}
		return ret;
	}

	this.increasePower = function(){
		var powerBoost = 1;

		if(this.aspect == "Blood"){
			this.boostAllRelationships();
		}else if(this.aspect == "Rage"){
			this.damageAllRelationships();
		}
		if(this.class_name == "Page"){  //they don't have many quests, but once they get going they are hard to stop.
			powerBoost = powerBoost * 5;
		}

		if(this.godTier){
			powerBoost = powerBoost * 100;  //god tiers are ridiculously strong.
		}

		if(this.denizenDefeated){
			powerBoost = powerBoost * 2; //permanent doubling of stats forever.
		}

		this.power += powerBoost;

		if(this.power % 10 == 0){
			this.leveledTheHellUp = true;
		}
	}

	this.shortLand = function(){
		return this.land.match(/\b(\w)/g).join('').toUpperCase();
	}

	this.htmlTitle = function(){
		return getFontColorFromAspect(this.aspect) + this.title() + "</font>"
	}
	
	this.htmlTitleBasic = function(){
		return getFontColorFromAspect(this.aspect) + this.titleBasic() + "</font>"
	}

	this.generateRelationships = function(friends){
		for(var i = 0; i<friends.length; i++){
			if(friends[i] != this){  //No, Karkat, you can't be your own Kismesis.
				this.relationships.push(randomRelationship(friends[i]));
			}
		}
	}

	this.checkBloodBoost = function(players){
		if(this.aspect == "Blood"){
			for(var i = 0; i<players.length; i++){
				players[i].boostAllRelationships();
			}
		}
	}

	this.nullAllRelationships = function(){
		for(var i = 0; i<this.relationships.length; i++){
			this.relationships[i].value = 0;
		}
	}

	this.boostAllRelationships = function(){
		for(var i = 0; i<this.relationships.length; i++){
			this.relationships[i].increase();
		}
	}

	this.damageAllRelationships = function(){
		for(var i = 0; i<this.relationships.length; i++){
			this.relationships[i].decrease();
		}
	}

	this.getRelationshipWith = function(player){
		for(var i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].target == player){
				return this.relationships[i];
			}
		}
	}

	this.getWhoLikesMeBestFromList = function(potentialFriends){
		var bestRelationshipSoFar = this.relationships[0];
		var friend = bestRelationshipSoFar.target;
		for(var i = 0; i<potentialFriends.length; i++){
			var p =  potentialFriends[i];
			if(p!=this){
				var r = p.getRelationshipWith(this);
				if(r.value > bestRelationshipSoFar.value){
					bestRelationshipSoFar = r;
					friend = p;
				}
			}
		}
		//can't be my best friend if they're an enemy
		if(bestRelationshipSoFar.value > 0 && potentialFriends.indexOf(friend) != -1){
			return friend;
		}
	}

	this.getWhoLikesMeLeastFromList = function(potentialFriends){
		var worstRelationshipSoFar = this.relationships[0];
		var enemy = worstRelationshipSoFar.target;
		for(var i = 0; i<potentialFriends.length; i++){
			var p =  potentialFriends[i];
			if(p != this){
				var r = p.getRelationshipWith(this);
				if(r.value < worstRelationshipSoFar.value){
					worstRelationshipSoFar = r;
					enemy = p;
				}
			}
		}
		//can't be my worst enemy if they're a friend.
		if(worstRelationshipSoFar.value < 0 && potentialFriends.indexOf(enemy) != -1){
			return enemy;
		}
	}

	this.hasRelationshipDrama = function(){
		for(var i = 0; i<this.relationships.length; i++){
			this.relationships[i].type(); //check to see if there is a relationship change.
			if(this.relationships[i].drama){
				return true;
			}
		}
		return false;
	}

	this.getRelationshipDrama = function(){
		var ret = [];
		for(var i = 0; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.drama){
				ret.push(r);
			}
		}
		return ret;
	}
	
	this.getChatFontColor = function(){
		if(this.isTroll){
			return this.bloodColor;
		}else{
			return getColorFromAspect(this.aspect);
		}
	}

	this.getFriendsFromList = function(potentialFriends){
		var ret = [];
		for(var i = 0; i<potentialFriends.length; i++){
			var p =  potentialFriends[i];
			if(p!=this){
				var r = this.getRelationshipWith(potentialFriends[i]);
				if(r.value > 0){
					ret.push(p);
				}
			}
		}
		return ret;
	}

	this.getEnemiesFromList = function(potentialEnemies){
		var ret = [];
		for(var i = 0; i<potentialEnemies.length; i++){
			var p =  potentialEnemies[i];
			if(p!=this){
				var r = this.getRelationshipWith(potentialEnemies[i]);
				if(r.value < 0){
					ret.push(p);
				}
			}
		}
		return ret;
	}

	this.getBestFriendFromList = function(potentialFriends){
		var bestRelationshipSoFar = this.relationships[0];
		for(var i = 0; i<potentialFriends.length; i++){
			var p =  potentialFriends[i];
			if(p!=this){
				var r = this.getRelationshipWith(potentialFriends[i]);
				if(r.value > bestRelationshipSoFar.value){
					bestRelationshipSoFar = r;
				}
			}
		}
		//can't be my best friend if they're an enemy
		if(bestRelationshipSoFar.value > 0){
			return bestRelationshipSoFar.target;
		}
	}

	this.getWorstEnemyFromList = function(potentialFriends){
		var worstRelationshipSoFar = this.relationships[0];
		for(var i = 0; i<potentialFriends.length; i++){
			var p =  potentialFriends[i];
			if(p!=this){
				var r = this.getRelationshipWith(potentialFriends[i]);
				if(r.value < worstRelationshipSoFar.value){
					worstRelationshipSoFar = r;
				}
			}
		}
		//can't be my worst enemy if they're a friend.
		if(worstRelationshipSoFar.value < 0){
			return worstRelationshipSoFar.target;
		}
	}

	this.getFriends = function(){
		var ret = [];
		for(var i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].value > 0){
				ret.push(this.relationships[i].target);
			}
		}
		return ret;
	}

	this.getEnemies = function(){
		var ret = [];
		for(var i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].value < 0){
				ret.push( this.relationships[i].target);
			}
		}
		return ret;
	}

}

function getColorFromAspect(aspect){
	var color = "";
	if(aspect == "Space"){
		color = "#00ff00";
	}else if(aspect == "Time"){
		color = "#ff0000";
	}else if(aspect == "Breath"){
		color = "#3399ff";
	}else if(aspect == "Doom"){
		color = "#003300";
	}else if(aspect == "Blood"){
		color = "#993300";
	}else if(aspect == "Heart"){
		color = "#ff3399";
	}else if(aspect == "Mind"){
		color = "#00ffcc";
	}else if(aspect == "Light"){
		color = "#ff9933";
	}else if(aspect == "Void"){
		color = "#000066";
	}else if(aspect == "Rage"){
		color = "#9900cc";
	}else if(aspect == "Hope"){
		color = "#ffcc66";
	}else if(aspect == "Life"){
		color = "#ccc3bf";
	}
	return color;
}


function getFontColorFromAspect(aspect){
	return "<font color= '" + getColorFromAspect(aspect) + "'> ";
}

function randomPlayerWithClaspect(c,a){
	var l = getRandomLandFromAspect(a);
	var k = getRandomElementFromArray(prototypings);
	if(c == "Witch" || Math.random() > .99){
		k = getRandomElementFromArray(disastor_prototypings);
	}else if(Math.random() > .9){
		k = getRandomElementFromArray(fortune_prototypings);
	}

	var gd = false;
	if(Math.random() > .5){
		gd =true;
	}
	var m = getRandomElementFromArray(moons);

	var i1 = getRandomElementFromArray(interests);
	var i2 = getRandomElementFromArray(interests);
	var i = i1 + " and " + i2; 
	var ch = getRandomChatHandle(c,a);;
	return new Player(c,a,l,k,m,gd, i,ch);
}
function randomPlayer(){
	//remove class AND aspect from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = getRandomElementFromArray(available_aspects);
	removeFromArray(a, available_aspects);
	return randomPlayerWithClaspect(c,a);

}

function randomPlayerWithoutRemoving(){
	//remove class AND aspect from available
	var c = getRandomElementFromArray(available_classes);
	//removeFromArray(c, available_classes);
	var a = getRandomElementFromArray(available_aspects);
	//removeFromArray(a, available_aspects);
	return randomPlayerWithClaspect(c,a);

}

function randomSpacePlayer(){
	//remove class from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = required_aspects[0];
	return randomPlayerWithClaspect(c,a);
}

function randomTimePlayer(){
	//remove class from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = required_aspects[1];
	return randomPlayerWithClaspect(c,a);
}

function findAspectPlayer(playerList, aspect){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.aspect == aspect){
			//console.log("Found " + aspect + " player");
			return p;
		}
	}
}

function getLeader(playerList){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.leader){
			return p;
		}
	}
}


function findClassPlayer(playerList, class_name){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.class_name == class_name){
			//console.log("Found " + class_name + " player");
			return p;
		}
	}
}

function findStrongestPlayer(playerList){
	var strongest = playerList[0];

	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.power > strongest.power){
			strongest = p;
		}
	}
	return strongest;
}

function findDeadPlayers(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.dead){
			ret.push(p);
		}
	}
	return ret;
}

function findLivingPlayers(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(!p.dead){
			ret.push(p);
		}
	}
	return ret;
}

function getPartyPower(party){
	var ret = 0;
	for(var i = 0; i<party.length; i++){
		ret += party[i].power;
	}
	return ret;
}

function getPlayersTitles(playerList){
	if(playerList.length == 0){
		return "";
	}
		var ret = playerList[0].htmlTitle();
		for(var i = 1; i<playerList.length; i++){
			ret += " and " + playerList[i].htmlTitle();
		}
		return ret;
}

function getPlayersTitlesBasic(playerList){
	if(playerList.length == 0){
		return "";
	}
		var ret = playerList[0].htmlTitle();
		for(var i = 1; i<playerList.length; i++){
			ret += " and " + playerList[i].htmlTitleBasic();
		}
		return ret;
	}

function findPlayersWithDreamSelves(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.dreamSelf){
			ret.push(p);
		}
	}
	return ret;
}

function findPlayersWithoutDreamSelves(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(!p.dreamSelf){
			ret.push(p);
		}
	}
	return ret;
}



function findBadPrototyping(playerList){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i].kernel_sprite;
		if(disastor_prototypings.indexOf(p) != -1){
			return p;
		}
	}
}

function findGoodPrototyping(playerList){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i].kernel_sprite;
		if(fortune_prototypings.indexOf(p) != -1){
			return p;
		}
	}
}
