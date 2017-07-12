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
		if(this.players.length > 0 && this.players[0].trickster && Math.random() >.01) return false; //tricksters are too op and distractable, don't often actually try to break sim

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
				player.changeGrimDark(-3) //if you are max grimDark doesn't fully save you...but if you weren't....maybe you get an extra buffer?
				return ret;
			}
		}
		return null;

	}

	this.workToCrashSession = function(player){
			var tasks = ["try to explode a gate using dark magicks. ", "try to destroy a temple meant to help them with their Quests.","search for the game disk for SBURB itself.","seek the counsel of the noble circle of the Horrorterrors. ","begin asking the local consorts VERY uncomfortable questsions.","meet with the Dersites to discuss game destroying options.","attempt to use their powers to access the Game's source code.","exploit glitches to access areas of the game meant never to be seen by players. ","seek forbidden knowledge hidden deep within the glitchiest parts of the Furthest Ring. "];
			if(player.aspect == "Space"){
				tasks.push("try to destroy frog breeding equipment")
				tasks.push("just straight up murdering frogs out of frustration")
				tasks.push("try to tamper with the Forge")
				player.landLevel += -10; //they FOCUS on killing frogs and ruining the game.
				console.log("A grim dark space player is actively trying to breed a corrupt frog in session: " + this.session.session_id)
			}
			var quip = "";
			var amount =0;
			if(player.grimDark < 2){
				amount = -1* player.power/4; //not trying as hard
			}else if(player.grimDark <3){
				amount = -1* player.power/2;
			}else if(player.grimDark <4){
				 amount = -1* player.power; //more powerful the player, the more damage they do. get rid of grimDark bonus
			}
			this.session.sessionHealth += amount;
			player.landLevel += -1; //if they manage to snap out of this, they are gonna still have a bad time. why did they think this was a good idea?
			if(player.power < 250){
				quip = " Luckily, they kind of suck at this game. "
			}else if(player.power > 500){
				quip = " Oh shit. This looks bad. "
			}else if(player.power > 300){
				quip = " They seem strong enough to do some serious damage. "
			}
			return "The "+ player.htmlTitle() + " is trying to break SBURB itself. They " + getRandomElementFromArray(tasks) + quip;

	}

	this.crashSession = function(){
		this.session.crashedFromPlayerActions = true;
		throw new PlayersCrashedSession(getPlayersTitlesNoHTML(this.players) + " has foolishly crashed session: " + this.session.session_id);
	}


	this.renderContent = function(div){
		//console.log("A grim dark player is actively working to crash session " + this.session.session_id + " and this much health remains: " + this.session.sessionHealth )
		//console.log("trying to crash session like an idiot: " + this.session.session_id)
		div.append("<br><img src = 'images/sceneIcons/grimdark_black_icon.png'> "+this.content(div));
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
