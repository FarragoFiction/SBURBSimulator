function Player(session,class_name, aspect, land, kernel_sprite, moon, godDestiny){

  //call if I overrode claspect or interest or anything
	this.reinit = function(){
		//console.log("player reinit");
		this.chatHandle = getRandomChatHandle(this.class_name,this.aspect,this.interest1, this.interest2);
		this.mylevels = getLevelArray(this);//make them ahead of time for echeladder graphic
		this.land = getRandomLandFromAspect(this.aspect);
	}
	this.baby = null;
	this.ectoBiologicalSource = null; //might not be created in their own session now.
	this.class_name = class_name;
	this.guardian = null; //no longer the sessions job to keep track.
	this.number_confessions = 0;
	this.number_times_confessed_to = 0;
	this.wasteInfluenced = false; //doomed time clones might be sent back by Waste of Mind and Observer.
	this.aspect = aspect;
	this.land = land;
	this.interest1 =null;
	this.interest2 = null;
	this.chatHandle = null;
	this.kernel_sprite = kernel_sprite;
	this.relationships = [];
	this.moon = moon;
	this.power = 1;
	this.leveledTheHellUp = false; //triggers level up scene.
	this.mylevels = null
	this.level_index = -1; //will be ++ before i query
	this.godTier = false;
	this.victimBlood = null; //used for murdermode players.
	this.hair = null
	//this.hair = 16;
	this.hairColor = null
	this.dreamSelf = true;
	this.isTroll = false; //later
	this.bloodColor = "#ff0000" //human red.
	this.leftHorn = null;
	this.rightHorn = null;
	this.lusus = "Adult Human"
	this.quirk = null;
	this.dead = false;
	this.godDestiny = godDestiny;
	//should only be false if killed permananetly as god tier
	this.canGodTierRevive = true;  //even if a god tier perma dies, a life or time player or whatever can brings them back.
	this.isDreamSelf = false;
	//players can be triggered for various things. higher their triggerLevle, greater chance of going murdermode or GrimDark.
	this.triggerLevel = -2; //make up for moon bonus
	this.murderMode = false;  //kill all players you don't like. odds of a just death skyrockets.
	this.leftMurderMode = false; //have scars, unless left via death.
  this.grimDark = false;  //all relationships set to 0. power up a lot. odds of  a just death skyrockets.
	this.leader = false;
	this.landLevel = 0; //at 10, you can challenge denizen.  only space player can go over 100 (breed better universe.)
	this.denizenFaced = false; //when faced, you double in power (including future power increases.)
	this.denizenDefeated = false;
	this.causeOfDeath = ""; //fill in every time you die. only matters if you're dead at end
	this.doomedTimeClones =  []; //help fight the final boss(es).


	this.fromThisSession = function(session){
		return (this.ectoBiologicalSource == null || this.ectoBiologicalSource == session.session_id)
	}


	this.chatHandleShort = function(){
		return this.chatHandle.match(/\b(\w)|[A-Z]/g).join('').toUpperCase();
	}

	this.chatHandleShortCheckDup = function(otherHandle){
		var tmp= this.chatHandle.match(/\b(\w)|[A-Z]/g).join('').toUpperCase();
		if(tmp == otherHandle){
			tmp = tmp + "2";
		}
		return tmp;
	}

		//people like them less and also they are more triggered.
	this.consequencesForTerriblePlayer  = function(){
		if((terrible_interests.indexOf(this.interest1) != -1)){
			this.damageAllRelationshipsWithMe();
			this.damageAllRelationshipsWithMe();
			this.damageAllRelationshipsWithMe();
			this.triggerLevel ++;
		}

		if((terrible_interests.indexOf(this.interest2) != -1)){
			this.damageAllRelationshipsWithMe();
			this.damageAllRelationshipsWithMe();
			this.damageAllRelationshipsWithMe();
			this.triggerLevel ++;
		}
	}

	//people like them more and also they are less triggered.
	this.consequencesForGoodPlayer = function(){
		if((social_interests.indexOf(this.interest1) != -1)){
			this.boostAllRelationshipsWithMe();
			this.boostAllRelationshipsWithMe();
			this.boostAllRelationshipsWithMe();
			this.triggerLevel +=-1;
		}

		if((social_interests.indexOf(this.interest2) != -1)){
			this.boostAllRelationshipsWithMe();
			this.boostAllRelationshipsWithMe();
			this.boostAllRelationshipsWithMe();
			this.triggerLevel +=-1;
		}
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
		if(this.dead){
			ret += "'s Corpse"
		}
		return ret;
	}

	this.htmlTitleBasic = function(){
			return getFontColorFromAspect(this.aspect) + this.titleBasic() + "</font>"
	}

	this.titleBasic = function(){
		var ret = "";

		ret+= this.class_name + " of " + this.aspect;
		return ret;
	}

	//old method from 1.0
	this.getRandomLevel = function(){
		if(Math.seededRandom() > .5){
			return getRandomLevelFromAspect(this.aspect);
		}else{
			return getRandomLevelFromClass(this.class_name);
		}
	}

//new method having to pick 16 levels before entering the medium
	this.getNextLevel = function(){
		this.level_index ++;
		var ret= this.mylevels[this.level_index];
		return ret;
	}

	this.getRandomQuest = function(){
		if(Math.seededRandom() > .5 || this.aspect == "Space"){ //space players pretty much only get FrogBreeding duty.
			return getRandomQuestFromAspect(this.aspect);
		}else{
			return getRandomQuestFromClass(this.class_name);
		}

	}

	this.decideHemoCaste  =function (){
		if(this.aspect != "Blood"){  //sorry karkat
			this.bloodColor = getRandomElementFromArray(bloodColors);
		}
	}

	this.decideLusus = function(player){
		if(this.bloodColor == "#610061" || this.bloodColor == "#99004d" || this.bloodColor == "#631db4" ){
			this.lusus = getRandomElementFromArray(seaLususTypes);
		}else{
			this.lusus = getRandomElementFromArray(landlususTypes);
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
			if(Math.seededRandom() > .9){ //just deaths are rarer without things like triggers.
				ret = true;
			}
			//way more likely to be a just death if you're being an asshole.
			if((this.murderMode || this.grimDark) && Math.seededRandom()>.2){
				ret = true;
			}
		}

		//return true; //for testing
		return ret;
	}

	//more likely if lots of people like you
	this.heroicDeath = function(){
		var ret = false;
		//if far more enemies than friends.
		if(this.getFriends().length > this.getEnemies().length ){
			if(Math.seededRandom() > .6){
				ret = true;
			}
			//extra likely if you just killed the king/queen, you hero you.
			if(curSessionGlobalVar.kingStrength <=0 && Math.seededRandom()>.2){
				ret = true;
			}
		}
		if(ret){
			//console.log("heroic death");
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

	this.generateBlandRelationships = function(friends){
		for(var i = 0; i<friends.length; i++){
			if(friends[i] != this){  //No, Karkat, you can't be your own Kismesis.
				//one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
				//that it needs to be a thing.
				var r = randomBlandRelationship(friends[i])
				if(this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d"){
					r.value = -20; //biological imperitive to fight for throne.
					this.triggerLevel ++;
					friends[i].triggerLevel ++;
				}
				this.relationships.push(r);
			}
		}
	}

	this.generateRelationships = function(friends){
		for(var i = 0; i<friends.length; i++){
			if(friends[i] != this){  //No, Karkat, you can't be your own Kismesis.
				//one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
				//that it needs to be a thing.
				var r = randomRelationship(friends[i])
				if(this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d"){
					r.value = -20; //biological imperitive to fight for throne.
					this.triggerLevel ++;
					friends[i].triggerLevel ++;
				}
				this.relationships.push(r);
			}else{
				//console.log(this.title() + "Not generating a relationship with: " + friends[i].title());
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
	//you like people more
	this.boostAllRelationships = function(){
		for(var i = 0; i<this.relationships.length; i++){
			this.relationships[i].increase();
		}
	}

	//you like people less
	this.damageAllRelationships = function(){
		for(var i = 0; i<this.relationships.length; i++){
			this.relationships[i].decrease();
		}
	}

	//people like you more
	this.boostAllRelationshipsWithMe = function(){
		for(var i = 0; i<session.players.length; i++){
			var r = this.getRelationshipWith(session.players[i])
			if(r){
				r.increase();
			}
		}
	}

	//people like you less
	this.damageAllRelationshipsWithMe = function(){
		for(var i = 0; i<curSessionGlobalVar.players.length; i++){
			var r = this.getRelationshipWith(curSessionGlobalVar.players[i])
			if(r){
				r.decrease();
			}
		}
	}

	this.getRelationshipWith = function(player){
		for(var i = 0; i<this.relationships.length; i++){
			if(this.relationships[i].target == player){
				return this.relationships[i];
			}
		}
		//this should only be happening if this == player. what is going on here!???
		//ah, was trying to make consequences for interets before making relationships
		//console.log("I am : " + this.title() + " and I couldn't find a relationship with: " + player.title() + " even though I have this many relationships " + this.relationships.length);
	}

	this.getWhoLikesMeBestFromList = function(potentialFriends){
		var bestRelationshipSoFar = this.relationships[0];
		var friend = bestRelationshipSoFar.target;
		for(var i = 0; i<potentialFriends.length; i++){
			var p =  potentialFriends[i];
			if(p!=this){
				var r = p.getRelationshipWith(this);
				if(r && r.value > bestRelationshipSoFar.value){
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
				if(r && r.value < worstRelationshipSoFar.value){
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


	this.getBestFriend = function(){
		var bestRelationshipSoFar = this.relationships[0];
		for(var i = 1; i<this.relationships.length; i++){
			var r = this.relationships[i];
			if(r.value > bestRelationshipSoFar.value){
				bestRelationshipSoFar = r;
			}
		}
		return bestRelationshipSoFar.target;
	}

	this.getBestFriendFromList = function(potentialFriends, debugCallBack){
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
		//I SHOULD NOT HAVE A RELATIONSHIP WITH MYSELF. but if i do, don't return it.
		if(bestRelationshipSoFar.value > 0 && bestRelationshipSoFar.target != this){
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
		//I SHOULD NOT HAVE A RELATIONSHIP WITH MYSELF. but if i do, don't return it.
		if(worstRelationshipSoFar.value < 0 && worstRelationshipSoFar.target != this){
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
		color = "#3da35a";
	}else if(aspect == "Light"){
		color = "#ff9933";
	}else if(aspect == "Void"){
		color = "#000066";
	}else if(aspect == "Rage"){
		color = "#9900cc";
	}else if(aspect == "Hope"){
		color = "#ffcc66";
	}else if(aspect == "Life"){
		color = "#494132";
	}
	return color;
}

function getShirtColorFromAspect(aspect){
	var color = "";
	if(aspect == "Space"){
		color = "#030303";
	}else if(aspect == "Time"){
		color = "#b70d0e";
	}else if(aspect == "Breath"){
		color = "#0087eb";
	}else if(aspect == "Doom"){
		color = "#204020";
	}else if(aspect == "Blood"){
		color = "#3d190a";
	}else if(aspect == "Heart"){
		color = "#6b0829";
	}else if(aspect == "Mind"){
		color = "#3da35a";
	}else if(aspect == "Light"){
		color = "#ff7f00";
	}else if(aspect == "Void"){
		color = "#000066";
	}else if(aspect == "Rage"){
		color = "#9900cc";
	}else if(aspect == "Hope"){
		color = "#ffe094";
	}else if(aspect == "Life"){
		color = "#ccc4b5";
	}
	return color;
}

function getDarkShirtColorFromAspect(aspect){
	var color = "";
	if(aspect == "Space"){
		color = "#242424";
	}else if(aspect == "Time"){
		color = "#970203";
	}else if(aspect == "Breath"){
		color = "#0070ED";
	}else if(aspect == "Doom"){
		color = "#11200F";
	}else if(aspect == "Blood"){
		color = "#2C1207";
	}else if(aspect == "Heart"){
		color = "#6B0829";
	}else if(aspect == "Mind"){
		color = "#3DA35A";
	}else if(aspect == "Light"){
		color = "#D66E04";
	}else if(aspect == "Void"){
		color = "#02285B";
	}else if(aspect == "Rage"){
		color = "#1E0C47";
	}else if(aspect == "Hope"){
		color = "#E8C15E";
	}else if(aspect == "Life"){
		color = "#CCC4B5";
	}
	return color;
}

function getFontColorFromAspect(aspect){
	return "<font color= '" + getColorFromAspect(aspect) + "'> ";
}



function randomPlayerWithClaspect(session, c,a){
	//console.log("random player");
	var l = getRandomLandFromAspect(a);
	var k = getRandomElementFromArray(prototypings);
	if(c == "Witch" || Math.seededRandom() > .99){
		k = getRandomElementFromArray(disastor_prototypings);
	}else if(Math.seededRandom() > .9){
		k = getRandomElementFromArray(fortune_prototypings);
	}

	var gd = false;
	if(Math.seededRandom() > .5){
		gd =true;
	}
	var m = getRandomElementFromArray(moons);
	var p =  new Player(session,c,a,l,k,m,gd);
	//no longer any randomness directly in player class. don't want to eat seeds if i don't have to.
	p.baby = getRandomInt(1,3)
	p.interest1 = getRandomElementFromArray(interests);
	p.interest2 = getRandomElementFromArray(interests);
	p.chatHandle = getRandomChatHandle(p.class_name,p.aspect,p.interest1, p.interest2);
	p.mylevels = getLevelArray(p);//make them ahead of time for echeladder graphic
	p.hair = getRandomInt(1,35);
	p.hairColor = getRandomElementFromArray(human_hair_colors);
	p.leftHorn =  getRandomInt(1,46);
	p.rightHorn = p.leftHorn;
	if(Math.seededRandom() > .7 ){ //preference for symmetry
			p.rightHorn = getRandomInt(1,46);
	}
	return p;

}
function randomPlayer(session){
	//remove class AND aspect from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = getRandomElementFromArray(available_aspects);
	removeFromArray(a, available_aspects);
	return randomPlayerWithClaspect(session,c,a);

}

function randomPlayerWithoutRemoving(session){
	//remove class AND aspect from available
	var c = getRandomElementFromArray(available_classes);
	//removeFromArray(c, available_classes);
	var a = getRandomElementFromArray(available_aspects);
	//removeFromArray(a, available_aspects);
	return randomPlayerWithClaspect(session,c,a);

}

function randomSpacePlayer(session){
	//remove class from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = required_aspects[0];
	return randomPlayerWithClaspect(session,c,a);
}

function randomTimePlayer(session){
	//remove class from available
	var c = getRandomElementFromArray(available_classes);
	removeFromArray(c, available_classes);
	var a = required_aspects[1];
	return randomPlayerWithClaspect(session,c,a);
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
		var ret = playerList[0].htmlTitleBasic();
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
//don't override existing source
function setEctobiologicalSource(playerList,source){
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.ectoBiologicalSource == null){
			p.ectoBiologicalSource = source;
		}
	}
}


function findPlayersWithoutEctobiologicalSource(playerList){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		if(p.ectoBiologicalSource == null){
			ret.push(p);
		}
	}
	return ret;
}

//deeper than a snapshot, for yellowyard aliens
//have to treat properties that are objects differently. luckily i think those are only player and relationships.
function clonePlayer(player, session, isGuardian){
	console.log("oh god, what about relationships? can't just simply clone them here, because not all clones are made yet.")
	var clone = new Player();
	for(var propertyName in player) {
		if(propertyName == "guardian"){
			if(!isGuardian){ //no infinite recursion, plz
				clone.guardian = clonePlayer(player.guardian, session, true);
				clone.guardian.guardian = clone;
		}
	}else{
				clone[propertyName] = player[propertyName]
		}
	}
	return clone;
}

function findPlayersFromSessionWithId(playerList, source){
	ret = [];
	for(var i= 0; i<playerList.length; i++){
		var p = playerList[i];
		//if it' snull, you could be from here, but not yet ectoborn
		if(p.ectoBiologicalSource == source || p.ectoBiologicalSource == null){
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

function getGuardiansForPlayers(playerList){
	var tmp = [];
	for(var i= 0; i<playerList.length; i++){
		var g = playerList[i].guardian;
		tmp.push(g);
	}
	return tmp;
}
