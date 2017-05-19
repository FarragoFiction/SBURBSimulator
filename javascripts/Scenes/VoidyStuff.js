function VoidyStuff(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;
	this.enablingPlayer = null;
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.player = null;
		if(Math.seededRandom() > .5){
			this.enablingPlayer = findAspectPlayer(this.session.availablePlayers, "Void");
			if(this.enablingPlayer == null) this.enablingPlayer = findAspectPlayer(this.session.availablePlayers, "Rage"); //if there is no void player
		}else{
			this.enablingPlayer = findAspectPlayer(this.session.availablePlayers, "Rage");
			if(this.enablingPlayer == null) this.enablingPlayer = findAspectPlayer(this.session.availablePlayers, "Void"); //if there is no rage player
		}

		if(this.enablingPlayer){
			if(this.enablingPlayer.isActive() || Math.seededRandom() > .5){
				this.player = this.enablingPlayer;
			}else{  //somebody else can be voided.
				this.player = getRandomElementFromArray(this.session.availablePlayers);  //don't forget that light players will never have void display none
			}
		}
		return this.player != null;
	}

	this.renderContent = function(div){
		this.player.increasePower();
		//div.append("<br>"+this.content());
		this.chooseShenanigans(div);
	}

	this.chooseShenanigans = function(div){
		removeFromArray(this.player, this.session.availablePlayers);
		var ret = "";
		var classDiv = "";
		if(enablingPlayer.aspect == "Void"){
			var light = findAspectPlayer(findLivingPlayers(curSessionGlobalVar.players), "Light");
			classDiv = "void";

			if(light){
				var relationship = enablingPlayer.getRelationshipWith(light);
				if(Math.abs(relationship.value) >10){  //we spend a lot of time together, whether we love or hate each other.
					console.log("light class void stuff in " + this.session.session_id);
					classDiv = "light";  //void players can't be hidden in the light.
				}
			}
		}else if(){
			classDiv = "rage";
		}

		if(classDiv == "void"){
			ret += "The " + this.player.htmlTitle() + " is doing...something. It's kind of hard to see.";
		}else if(classDiv == "rage"){
			ret += "The " + this.player.htmlTitle() + " is doing something... motherfucking miraculous. It's kind of hard to look away.";
		}else if(classDiv == "light"){
				ret += "The " + this.player.htmlTitle() + " is doing...something. It's kind of hard to-wait. What? Fucking Light players. Keep it down! The Void player is trying to be sneaky and off screen!";
		}
		if(this.player != this.enablingPlayer) ret+= " You are definitely blaming the " + this.enablingPlayer.htmlTitle() + ", somehow. ";

		//make array of functions. call one at random.
		//div you pass to fucntion is created here. div class is VOID, nothing or RAGE.

		var normalDivHTML = "<div class =''"+classDiv+"' id = '" +div.attr("id")+ "voidyStuffNormal'>  </div> "
		div.append(normalDivHTML);
		var normalDiv = $("#"++div.attr("id")+ "voidyStuffNormal")

		var newDivHTML = "<div class =''"+class+"' id = '" +div.attr("id")+ "voidyStuffSpecial'>  </div> "
		div.append(newDivHTML);
		var normalDiv = $("#"++div.attr("id")+ "voidyStuffNormal")
		var newDiv = $("#"++div.attr("id")+ "voidyStuffSpecial")
		if(this.player.godDestiny && !this.player.godTier && Math.seededRandom()>0.8 && this.player.land != null){
			this.makeGodTier(normalDiv, newDiv);
			return;
		}else if(this.player.leader && !this.session.ectoBiologyStarted && Math.seededRandom() > .8){
				this.ectoBiologyStarted(normalDiv, newDiv)
		}else{ //pick from random array.
				var options = [this.makeEnemies.bind(this,normalDiv,newDiv), this.makeFriends.bind(this,normalDiv, newDiv),this.goGrimDark.bind(this,normalDiv,newDiv),this.goMurderMode.bind(this,normalDiv,newDiv),this.dolandQuests.bind(this,normalDiv,newDiv),this.weakenDesites.bind(this,normalDiv,newDiv),this.fightDenizen.bind(this,normalDiv,newDiv)];
				getRandomElementFromArray(statIncreases)();
		}
	}


	//these methods are called shuffled randomly in an array,
	//then called in order till one of them returns true.
	this.makeEnemies = function(div, specialDiv){

	}

	this.makeFriends = function(div){

	}

	this.goGrimDark = function(div){

	}

	this.goMurderMode = function(div){

	}

	this.dolandQuests = function(div){

	}

	//nah, don't do this naymore, only die from denizen fights
	this.die = function(div){

	}


	this.weakenDesites = function(div){

	}

	//can die from this. not actually a real fight. short and brutal.
	this.fightDenizen = function(div){

	}

	//actually render babies if class would be rage, whimsical overlay???
	this.ectoBiologyStarted = function(div){

	}
	//returns false if you can't be a god tier or already are one
	//make sure to actually render the GetTiger
	//if class would be rage, whimsical overlay?
	this.godTier = function(div){

	}



	//rage players do things ON SCREEN.  void players do it in a hidden div.
	//steal Jack’s scottie dogs You have stolen all of the Archagent’s licorice scottie dogs. ALL OF THEM.
	this.contentOld = function(){
		removeFromArray(this.player, this.session.availablePlayers);
		var ret = "The " + this.player.htmlTitle() + " is doing...something. It's kind of hard to see.";
		if(this.player != this.enablingPlayer) ret+= " You are definitely blaming the " + this.enablingPlayer.htmlTitle() + ", somehow. "
		var rand = Math.seededRandom();

		if(rand > .3){
			this.player.boostAllRelationships();
		}else if(rand > .5){
			this.player.damageAllRelationships();
			ret += " Everybody seems to be pretty pissed at them, though. ";
			if(Math.seededRandom() > .9){  //randomly go grim dark when you aren't looking
				this.player.corruptionLevelOther += getRandomInt(1,100);
				ret += " You get a bad feeling about this. ";
			}else if(Math.seededRandom() > .9){
				this.player.triggerLevel += 3;
				this.player.murderMode = true;
				ret += " You get a bad feeling about this. ";
			}else if (Math.seededRandom() > .95){
				this.makeDead( "doing voidy shenanigans, probably")
				ret += " You get a bad feeling about this. ";
			}
		}else{
			this.player.increasePower();
		}

		if(Math.seededRandom() > .5 && this.player.land != null){
			this.player.landLevel ++;
			ret += " Their consorts seem pretty happy, though. " ;
		}else{
			this.session.queen.power += -5;
			this.session.jack.power += -5;
			this.session.king.power += -5;
			ret += " The Dersites sure seem to be mad at them, though. ";
		}

		if(this.player.godDestiny && !this.player.godTier && Math.seededRandom()>0.8 && this.player.land != null){  //just randomly freaking god tier.
			this.player.makeDead("hidden in void on their way to godhood")
			this.player.makeGodTier();
			this.session.godTier = true;

			ret += " What was that light on " + this.player.shortLand() + "? ";
		}
		if(this.player.leader && !this.session.ectoBiologyStarted && Math.seededRandom() > .8){
			this.player.performEctobiology(this.session);
			ret += " Wait. Are those BABIES!? What is even going on here?";
		}

		if(this.player.landLevel >= 6 && this.player.land != null && !this.player.denizenDefeated && Math.seededRandom() > .5){
			this.player.denizenFaced = true;
			var denizen = this.session.getDenizenForPlayer(this.player);
			ret += " Why is the denizen " + denizen.name + " bellowing so loudly on " + this.player.shortLand() + "? ";
			if(Math.seededRandom() >.5){
				this.player.power = this.player.power*2;  //current and future doubling of power.
				this.player.leveledTheHellUp = true;
				this.player.denizenDefeated = true;
				this.player.grist += denizen.grist;
			}else{
				if(this.player.getFriends().length < this.player.getEnemies().length){
					this.player.denizenFaced = true;
					this.player.denizenDefeated = false;
					ret += " That didn't sound good... ";
					this.player.dead = true;
					this.player.makeDead("fighting their Denizen way too early, cloaked in Void");
				}else{
					this.player.denizenDefeated = false;
				}
			}
		}

		return ret;
	}
}
