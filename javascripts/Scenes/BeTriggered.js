function BeTriggered(){
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.triggeredPlayers = [];
	this.triggers = [];
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.triggeredPlayers = [];
		this.triggers = [];
		for(var i = 0; i<availablePlayers.length; i++){
			var p = availablePlayers[i];
			var trigger = this.IsPlayerTriggered(p)
			if(trigger != " absolutely nothing " && Math.seededRandom()>.6){ //mostly DON'T flip out
				this.triggers.push(trigger);
				this.triggeredPlayers.push(p);
			}
		}
		return this.triggeredPlayers.length > 0;
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	this.IsPlayerTriggered = function(player){
		//are any of your friends  dead?
		var deadPlayers = findDeadPlayers(players);
		var deadFriends = player.getFriendsFromList(deadPlayers);
		var livePlayers = findLivingPlayers(players);
		var worstEnemy = player.getWorstEnemyFromList(players);
		var bestFriend = player.getBestFriendFromList(players);

		//small chance
		if(deadPlayers.length > 0){
			if(Math.seededRandom() > 0.9){
				player.triggerLevel ++;
				return deadPlayers.length +" dead players ";
			}

			if(worstEnemy != null && !worstEnemy.dead && player.getRelationshipWith(worstEnemy).type() == player.getRelationshipWith(worstEnemy).badBig){
				player.triggerLevel ++;
				player.triggerLevel ++;
				player.triggerLevel ++;
				return deadPlayers.length + " players are dead (and that asshole the " + worstEnemy.htmlTitle() + " MUST be to blame) ";
			}
		}

		//bigger chance
		if(deadFriends.length > 0){
			if(Math.seededRandom() > 0.5){
				player.triggerLevel ++;
				return deadFriends.length + " dead friends";
			}

			//if someone you have a crush on dies, you're triggered. period. (not necessarily gonna lose your shit, though.)
			if(bestFriend != null && bestFriend.dead && player.getRelationshipWith(bestFriend).type() == player.getRelationshipWith(bestFriend).bigGood){
				player.triggerLevel ++;
				player.triggerLevel ++;
				player.triggerLevel ++;
				return " their dead crush, the " + bestFriend.htmlTitle() + " ";
			}
		}

		//huge chance, the dead outnumber the living.
		if(deadPlayers.length > livePlayers.length){
			if(Math.seededRandom() > 0.1){
				player.triggerLevel ++;
				player.triggerLevel ++;
				player.triggerLevel ++;
				return " how absolutely fucked they are ";
			}
		}

		if(player.doomedTimeClones > 0 && Math.seededRandom() > .9){
			return " their own doomed Time Clones ";
		}

		if(player.denizenFaced && player.denizenDefeated && Math.seededRandom() > .95){
			return " how terrifying " +player.getDenizen() + " was " ;
		}

		//TODO have triggers specific to classes or aspects, like time players having to abort a timeline.
		return " absolutely nothing ";

	}

	this.content = function(){
		var ret = "";
		for(var i = 0; i<this.triggeredPlayers.length; i++){
			var p = this.triggeredPlayers[i];
			removeFromArray(p, availablePlayers);
			ret += " The " +p.htmlTitle() + " is currently too busy flipping the fuck out about "
			ret += this.triggers[i] + " to be anything but a useless piece of gargbage. ";
			p.triggerLevel ++;
			if(p.triggerLevel > 5){
				ret += " Their freakout level is getting dangerously high. ";
			}
		}
		return ret;
	}
}
