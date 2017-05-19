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
		this.player.corruptionLevelOther += getRandomInt(1,10); //void isn't a safe place to be.
		//div.append("<br>"+this.content());
		div.append("<br>")
		this.chooseShenanigans(div);
	}

	this.chooseShenanigans = function(div){
		removeFromArray(this.player, this.session.availablePlayers);
		var ret = "";
		var classDiv = "";
		if(this.enablingPlayer.aspect == "Void"){
			var light = findAspectPlayer(findLivingPlayers(curSessionGlobalVar.players), "Light");
			classDiv = "void";

			if(light){
				var relationship = this.enablingPlayer.getRelationshipWith(light);
				if(Math.abs(relationship.value) >10){  //we spend a lot of time together, whether we love or hate each other.
					console.log("light class void stuff in " + this.session.session_id);
					classDiv = "light";  //void players can't be hidden in the light.
				}
			}
		}else if(this.enablingPlayer.aspect == "Rage"){
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
		div.append(ret);
		//make array of functions. call one at random.
		//div you pass to fucntion is created here. div class is VOID, nothing or RAGE.

		var normalDivHTML = "<span id = '" +div.attr("id")+ "voidyStuffNormal'>  </span> "
		div.append(normalDivHTML);
		var normalDiv = $("#"+div.attr("id")+ "voidyStuffNormal")

		var newDivHTML = "<span class ='"+classDiv+"' id = '" +div.attr("id")+ "voidyStuffSpecial'>  </span> "
		div.append(newDivHTML);
		var normalDiv = $("#"+div.attr("id")+ "voidyStuffNormal")
		var newDiv = $("#"+div.attr("id")+ "voidyStuffSpecial")
		if(this.player.godDestiny && !this.player.godTier && Math.seededRandom()>0.8 && this.player.land != null){
			this.godTier(normalDiv, newDiv);
			this.endingPhrase(classDiv, newDiv);
			return;
		}else if(this.player.leader && !this.session.ectoBiologyStarted && Math.seededRandom() > .8){
				this.ectoBiologyStarted(normalDiv, newDiv)
				this.endingPhrase(classDiv, newDiv);
				return;
		}else{ //pick from random array.
				var options = [this.makeEnemies.bind(this,normalDiv,newDiv), this.makeFriends.bind(this,normalDiv, newDiv),this.goMurderMode.bind(this,normalDiv,newDiv),this.dolandQuests.bind(this,normalDiv,newDiv),this.weakenDesites.bind(this,normalDiv,newDiv),this.fightDenizen.bind(this,normalDiv,newDiv)];
				getRandomElementFromArray(options)();
		}

		this.endingPhrase(classDiv, newDiv);
	}

	this.endingPhrase = function(classDiv, newDiv){
		if(classDiv == "rage"){
			this.rageEndingPhrase(newDiv);
		}else if(classDiv == 'void'){
				this.voidEndingPhrase(newDiv);
		}
	}

	this.voidEndingPhrase = function(newDiv){
		var ret = " The " + this.player.htmlTitle();
		var phrases = ["is sneaking around like a cartoon burglar.", "is holding up a sign saying 'You don't see me!'. ", "is hiding very obviously behind that lamppost.", "is badly disguised as a consort.", "is badly disguised as a carapacian.","is sneaking around underneath the only cardboard box in all of Paradox Space."];
		newDiv.append( ret + " " + getRandomElementFromArray(phrases));
	}

	this.rageEndingPhrase = function(newDiv){
		var ret = " The " + this.player.htmlTitle();
		var phrases = ["is probably actually under the influence of psychoactive drugs.","might actually be sleep walking.", "is all up and laughing the whole time.","can't seem to stop laughing.", "has a look of utmost concentration.", "doesn't even seem to know what's going on themselves.", "is badly cosplaying as a consort.", "somehow got a hold of 413 helium balloon and has them tied to their neck.", "is wearing a sombrero. How HIGH do you even have to BE?"];
		newDiv.append( ret + " " + getRandomElementFromArray(phrases));
	}


	//these methods are called shuffled randomly in an array,
	//then called in order till one of them returns true.
	this.makeEnemies = function(div, specialDiv){
		this.player.damageAllRelationships();
		div.append(" Everybody seems to be pretty pissed at them, though. ");
		//brainstorm what they are doing here. rand array.
	}

	this.makeFriends = function(div,specialDiv){
		this.player.boostAllRelationships();
		div.append(" Everybody seems to be pretty happy with them, though. ");
		//brainstorm what they are doing here, rand array.
	}


	this.goMurderMode = function(div,specialDiv){
		this.player.triggerLevel += 3;
		this.player.murderMode = true;
		div.append(" You get a bad feeling about this. ");
		specialDiv.append("The " + this.player.htmlTitle() + " has taken an acrobatic fucking pirouette off the handle and into a giant pile of crazy.  You almost wish you hadn't seen this. This is completely terrifying.");
	}

	this.dolandQuests = function(div,specialDiv){
		this.player.landLevel ++;
		div.append(" Their consorts seem pretty happy, though. ") ;
		//should i just have land quests print out here, or something special? want it to be random bullshit.
	}

	this.weakenDesites = function(div,specialDiv){
		this.session.queen.power += -5;
		this.session.jack.power += -5;
		this.session.king.power += -5;
		div.append( " The Dersites sure seem to be mad at them, though. ");
		specialDiv.append( "The " + this.player.htmlTitle() + " " + getRandomElementFromArray(lightQueenQuests))
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
	this.godTier = function(div, specialDiv){
		if(this.enablingPlayer.aspect == "Void"){
			this.player.makeDead("hidden in void on their way to godhood")
		} else{
			this.player.makeDead("with ridiculous bullshit clown shenanigans")
		}
		this.player.makeGodTier();
		this.session.godTier = true;

		div.append(" What was that light on " + this.player.shortLand() + "? ");
		specialDiv.append("Holy shit. Did the " + this.player.htmlTitleBasic() + " just randomly go GodTier? What the fuck is going on? How did they even die? This is some flagrant bullshit. " );
		var divID = (specialDiv.attr("id")) + "godBS"
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		specialDiv.append(canvasHTML);
		var canvas = document.getElementById("canvas"+ divID);
		drawGetTiger(canvas, [this.player],repeatTime) //only draw revivial if it actually happened.

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
