function GrimDarkQuests(session){
	this.session = session;
	this.canRepeat = true;
	this.players = [];
	//grim dark players don't do their jobs. they try to crash the session.
	this.trigger = function(playerList){
		this.players = [];
		var living = findLivingPlayers(playerList);
		for (var i = 0; i<living.length; i++){
			var player = living[i];
			if(player.grimDark>2){
				 this.players.push(player)
			}else if(player.grimDark>1 && Math.seededRandom() > .5){
				this.players.push(player)
			}
		}

		return this.players.length>0;
	}

	//power of friendship defeats corruptions.
	this.checkSnapOutOfIt = function(player){
		var bestFriend = player.getBestFriend();
		if(bestFriend){
			var r = player.getRelationshipWith(bestFriend);
			if(r.value > 10){
				var ret =  "The " + player.htmlTitle() + " suddenly snaps out of it.  Their friendship with the " + bestFriend.htmlTitle() + " has managed to free them of the Horrorterror's influence. ";
				if(bestFriend.grimDark > 1) ret += " The irony of this does not escape anyone. "
				player.grimDark = 1;
				return ret;
			}
		}
		return null;

	}

	this.workToCrashSession = function(player){
			var tasks = ["try to explode a gate using dark magicks. ", "try to destroy a temple meant to help them with their Quests.","search for the game disk for SBURB itself.","seek the counsel of the nobel circle of the Horrorterrors.","begin asking the local consorts VERY uncomfortable questsions.","meet with the Black Queen to discuss game destroying options.","attempt to use their powers to access the Game's source code.","exploit glitches to access areas of the game meant never to be seen by players.","seek forbidden knowledge hidden deep within the glitchiest parts of the Furthest Ring."];
			var quip = "";
			this.session.sessionHealth += -1* player.power; //more powerful the player, the more damage they do. get rid of grimDark bonus
			player.landLevel += -1; //if they manage to snap out of this, they are gonna still have a bad time. why did they think this was a good idea?
			if(player.power < 210){
				quip = "Luckily, they kind of suck at this game. "
			}else if(player.power > 250){
				quip = " They seem strong enough to do some serious damage. "
			}else if(player.power > 300){
				quip = " Oh shit. This looks bad. "
			}
			return "The "+ player.htmlTitle() + " is trying to break SBURB itself. They " + getRandomElementFromArray(tasks) + quip;

	}

	this.crashSession = function(){
		this.session.crashedFromPlayerActions = true;
		throw new PlayersCrashedSession(getPlayersTitlesNoHTML(this.players) + " has foolishly crashed session: " + this.session.session_id);
	}


	this.renderContent = function(div){
		//console.log("trying to crash session like an idiot: " + this.session.session_id)
		div.append("<br>"+this.content(div));
		if(this.session.sessionHealth <= 0){
			div.append("<br><br>YOU MANIACS! YOU BLEW IT UP! AH, DAMN YOU! GOD DAMN YOU ALL TO HELL! <br><br>Just joking. Well, I mean. Not about them blowing it up. Sessions fucked. But. I mean, come on. What did you THINK would happen? Stupid, lousy goddamned GrimDark players crashing my fucking sessions.");
			this.crashSession();
		}
	}

	this.content = function(){
			var ret = "";
			for(var i = 0; i<this.players.length; i++){
				if(this.session.sessionHealth <= 0) return ret;
				var player = this.players[i];
				var snop = this.checkSnapOutOfIt(player);
				if(snop){
					//console.log("Grim dark player snapped out of it through the power of friendship in session " + this.session.session_id)
					ret += snop;
				}else{
					ret += this.workToCrashSession(player)
				}
			}
			return ret;
	}
}


https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error#Custom_Error_Types
function PlayersCrashedSession(message) {
  this.name = 'PlayersCrashedSession';
  this.message = message || 'PlayersCrashedSession';
  this.stack = (new Error()).stack;
}
PlayersCrashedSession.prototype = Object.create(Error.prototype);
PlayersCrashedSession.prototype.constructor = PlayersCrashedSession;
