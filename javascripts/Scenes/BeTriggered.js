function BeTriggered(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.triggeredPlayers = [];
	this.triggers = [];
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.triggeredPlayers = [];
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			var p = this.session.availablePlayers[i];
			if(this.IsPlayerTriggered(p) && Math.seededRandom() >.75){ //don't all flip out/find out at once. if i find something ELSE to flip out before i can flip out about this, well, oh well. SBURB is a bitch. 75 is what it should be when i'm done testing.
				//console.log("shit flipping: " + p.flipOutReason + " in session " + this.session.session_id)
				this.triggeredPlayers.push(p);
			}
		}
		return this.triggeredPlayers.length > 0;
	}

	this.renderContent = function(div){
		div.append("<br><img src = 'images/sceneIcons/flipout_icon_animated.gif'>"+this.content());
	}

	//todo reasons include death of a player, being mind controlled, having doomed time clones, yellow yards, learning about ectobiology, having to run from a fight, being cheated on. basically, anything that modifies trigger level. maybe even if a player does it from an ambiant effect???????????
	this.IsPlayerTriggered = function(player){
		if(player.flipOutReason){
			//console.log("I have a flip out reason: " + player.flipOutReason)
			if(player.flippingOutOverDeadPlayer && player.flippingOutOverDeadPlayer.dead){
				//console.log("I know about a dead player. so i'm gonna start flipping my shit. " + this.session.session_id)
				return true;
			}else if(player.flippingOutOverDeadPlayer){ //they got better.
			//	console.log(" i think i need to know about a dead player to flip my shit. " + player.flippingOutOverDeadPlayer.title())
				player.flipOutReason = null;;
				player.flippingOutOverDeadPlayer = null;
				return false;
			}
			if(player.flipOutReason == "being haunted by their own ghost") console.log("flipping otu over own ghost" + this.session.session_id);
			//"being haunted by the ghost of the Player they killed"
				if(player.flipOutReason == "being haunted by the ghost of the Player they killed") console.log("flipping otu over victim ghost" + this.session.session_id);
			///okay. player.flippingOutOverDeadPlayer apparently can be null even if i totally and completely am flipping otu over a dead player. why.
			//console.log("preparing to flip my shit. and its about " + player.flipOutReason + " which BETTEr fucking not be about a dead player. " + player.flippingOutOverDeadPlayer)
			return true; //i am flipping out over not a dead player, thank you very much.

		}
		if(-1 * player.sanity > Math.seededRandom() * 100 ){
			player.flipOutReason = "how they seem to be going shithive maggots for no goddamned reason"
			return true
		}
	}

	//holy shit this gets repetitive. settle your shit.
	this.IsPlayerTriggeredOld = function(player){
		//are any of your friends  dead?
		var deadPlayers = findDeadPlayers(this.session.players);
		var deadFriends = player.getFriendsFromList(deadPlayers);
		var livePlayers = findLivingPlayers(this.session.players);
		var worstEnemy = player.getWorstEnemyFromList(this.session.players);
		var bestFriend = player.getBestFriendFromList(this.session.players);

		var deadDiamond = player.hasDeadDiamond()
		var deadHeart = player.hasDeadHeart();
		if(deadDiamond && Math.seededRandom() > 0.3){
			player.sanity += -1000;
			player.damageAllRelationships();
			player.damageAllRelationships();
			player.damageAllRelationships();
			//console.log("triggered by dead moirail in session" + this.session.session_id)
			return " their dead Moirail, the " + deadDiamond.htmlTitleBasic() + " ";
		}

		if(deadHeart&& Math.seededRandom() > 0.2){
			player.sanity += -1000;
			//console.log("triggered by dead matesprit in session" + this.session.session_id)
			return " their dead Matesprit, the " + deadHeart.htmlTitleBasic() + " ";
		}
		//small chance
		if(deadPlayers.length > 0){
			if(Math.seededRandom() > 0.9){
				player.sanity += -10;
				return deadPlayers.length +" dead players ";
			}

			if(worstEnemy != null && !worstEnemy.dead && player.getRelationshipWith(worstEnemy).type() == player.getRelationshipWith(worstEnemy).badBig){
				player.sanity += -30;
				player.getRelationshipWith(worstEnemy).decrease();
				return deadPlayers.length + " players are dead (and that asshole the " + worstEnemy.htmlTitle() + " MUST be to blame) ";
			}
		}

		//bigger chance
		if(deadFriends.length > 0){
			if(Math.seededRandom() > 0.5){
				player.sanity += -10;
				return deadFriends.length + " dead friends";
			}

			//if someone you have a crush on dies, you're triggered. period. (not necessarily gonna lose your shit, though.)
			if(bestFriend != null && bestFriend.dead && player.getRelationshipWith(bestFriend).type() == player.getRelationshipWith(bestFriend).bigGood){
				player.sanity += -30;
				return " their dead crush, the " + bestFriend.htmlTitle() + " ";
			}

		}

		//huge chance, the dead outnumber the living.
		if(deadPlayers.length > livePlayers.length){
			if(Math.seededRandom() > 0.1){
				player.sanity += -30;
				return " how absolutely fucked they are ";
			}
		}

		if(player.doomedTimeClones.length > 0 && Math.seededRandom() > .9){
			player.sanity += -10;
			return " their own doomed Time Clones ";
		}

		if(player.denizenFaced && player.denizenDefeated && Math.seededRandom() > .95){
			player.sanity += -10;
			return " how terrifying " +player.getDenizen() + " was " ;
		}

		//TODO have triggers specific to classes or aspects, like time players having to abort a timeline.
		return " absolutely nothing ";

	}

	this.content = function(){
		var ret = "";
		for(var i = 0; i<this.triggeredPlayers.length; i++){
			var p = this.triggeredPlayers[i];
			var hope = findAspectPlayer(findLivingPlayers(this.session.players), "Hope");
			if(hope && hope.power > 100){

				//console.log("Hope Survives: " + this.session.session_id)
				ret += " The " +p.htmlTitle() + " should probably be flipping the fuck out about  " + p.flipOutReason;
				ret += " and being completely useless, but somehow the thought that the " + hope.htmlTitle() + " is still alive fills them with determination, instead.";  //hope survives.
				hope.increasePower();
				p.increasePower();
				p.flipOutReason = null;
				p.flippingOutOverDeadPlayer = null;

			}else{
				removeFromArray(p, this.session.availablePlayers);
				ret += " The " +p.htmlTitle() + " is currently too busy flipping the fuck out about "
				ret += p.flipOutReason + " to be anything but a useless piece of gargbage. ";
				p.sanity += -10;
				p.flipOutReason = null;
				p.flippingOutOverDeadPlayer = null;
				if(p.sanity < -5){
					ret += " Their freakout level is getting dangerously high. ";
				}
			}
		}
		return ret;
	}
}
