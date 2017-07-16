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
		this.player.increasePower();
		if(this.enablingPlayer.aspect == "Void") this.player.corruptionLevelOther += getRandomInt(1,5); //void isn't a safe place to be.
		//div.append("<br>"+this.content());
		div.append("<br><img src = 'images/sceneIcons/shenanigans_icon.png'> ")
		this.chooseShenanigans(div);
	}

	this.chooseShenanigans = function(div){
		removeFromArray(this.player, this.session.availablePlayers);
		var ret = "";
		var classDiv = "";
		if(this.enablingPlayer.aspect == "Void"){
			classDiv = "void";

			if(!this.player.isVoidAvailable()){
					classDiv = "light";  //void players can't be hidden in the light.
			}
		}else if(this.enablingPlayer.aspect == "Rage"){
			classDiv = "rage";
		}

		if(classDiv == "void"){
			ret += "The " + this.player.htmlTitle() + " is doing...something. It's kind of hard to see.";
		}else if(classDiv == "rage"){
			ret += "The " + this.player.htmlTitle() + " is doing something... motherfucking miraculous. It's kind of hard to look away.";
		}else if(classDiv == "light"){
				ret += "The " + this.player.htmlTitle() + " is doing...something. It's kind of hard to-wait. What? Fucking Light players. Keep it down! The " + this.player.htmlTitleBasic() + " is trying to be sneaky and off screen!";
		}
		if(classDiv != 'light' && this.player != this.enablingPlayer) ret+= " You are definitely blaming the " + this.enablingPlayer.htmlTitle() + ", somehow. ";
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
		//don't godtier as soon as you get in, too unfair to the other players.
		if(this.player.godDestiny && this.player.power > 10 && !this.player.godTier && Math.seededRandom()>0.8 && this.player.land != null){
			this.godTier(normalDiv, newDiv);
			this.endingPhrase(classDiv, newDiv);
			return;
		}else if(this.player.leader && !this.session.ectoBiologyStarted && Math.seededRandom() > .8){
				this.ectoBiologyStarted(normalDiv, newDiv)
				this.endingPhrase(classDiv, newDiv);
				return;
		}else if(this.player.landLevel >= 6 && this.player.land != null && !this.player.denizenDefeated && Math.seededRandom() > .8){
			this.fightDenizen(normalDiv, newDiv)
			this.endingPhrase(classDiv, newDiv);
			return;
		}else if(this.player.sanity < 5 && !this.player.murderMode && Math.seededRandom() > 0.9){
			console.log("flipping shit through voidy stuff")
			this.goMurderMode(normalDiv, newDiv)
			this.endingPhrase(classDiv, newDiv);
			return;
		}else{ //pick from random array.
				var options = [this.findFraymotif.bind(this,normalDiv,newDiv),this.makeEnemies.bind(this,normalDiv,newDiv), this.makeFriends.bind(this,normalDiv, newDiv),this.dolandQuests.bind(this,normalDiv,newDiv),this.weakenDesites.bind(this,normalDiv,newDiv),this.weakenDesites.bind(this,normalDiv,newDiv),this.weakenDesites.bind(this,normalDiv,newDiv)];
				getRandomElementFromArray(options)();
		}

		this.endingPhrase(classDiv, newDiv);
	}

	this.endingPhrase = function(classDiv, newDiv){
		if(classDiv == "rage"){
			this.rageEndingPhrase(newDiv);
		}else if(classDiv == "void"){
			this.voidEndingPhrase(newDiv);
		}else if(classDiv == "light"){
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
		var phrases = ["is probably actually under the influence of psychoactive drugs.","might actually be sleep walking.", "is all up and laughing the whole time.","can't seem to stop laughing.", "has a look of utmost concentration.", "doesn't even seem to know what's going on themselves.", "is badly cosplaying as a consort.", "somehow got a hold of 413 helium balloon and has had them tied to their neck this whole time.", "is wearing a sombrero. How HIGH do you even have to BE?"];
		newDiv.append( ret + " " + getRandomElementFromArray(phrases));
	}

	this.findFraymotif = function(div, specialDiv){
		console.log("Void/Rage fraymotif acquired: " + this.session.session_id)
		div.append(" What's that music playing? ");
		var f = this.player.getNewFraymotif();
		specialDiv.append("A sweeping musical number kicks in, complete with consort back up dancers. The " + this.player.htmlTitle() + " is the star. It is them. When it is over, they seem to have learned " + f.name + ". ");
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
		this.player.sanity += -30;
		this.player.makeMurderMode();
		div.append(" You get a bad feeling about this. ");
		specialDiv.append("The " + this.player.htmlTitle() + " has taken an acrobatic fucking pirouette off the handle and into a giant pile of crazy.  You almost wish you hadn't seen this. This is completely terrifying.");
	}

	this.dolandQuests = function(div,specialDiv){
		this.player.landLevel +=2;
		div.append(" Their consorts seem pretty happy, though. ") ;
		if(Math.seededRandom() > .95){ //small chance of serious.
			specialDiv.append( "The " + this.player.htmlTitle() + " is " + getRandomQuestFromAspect(this.player.aspect) + ". ");
		}else{
			var specialStuff = ["teaching the local consorts all the illest of beats","explaining the finer points of the human game 'hopscotch' to local consorts","passing out banned orange fruits that may or may not exist to hungry local consorts","throwing a birthday party for the local consorts"];
			specialStuff = specialStuff.concat(["reenacting tear jerking scenes from classic cinema with local consorts","adopting a local consort as their beloved daughter","explaining that all conflict will be resolved through the medium of rap, going forwards","passing out rumpled headgear like cheap cigars"]);
			specialStuff = specialStuff.concat(["completely destabilizing the local consort economy by just handing out fat stacks of boonbucks","showing the local consorts how to draw graffiti all over the Denizen temples","explaining that each local consort is probably the hero of legend or some shit","encouraging local consorts to form secret societies around household items"]);

			specialDiv.append( "The " + this.player.htmlTitle() + " is " + getRandomElementFromArray(specialStuff) + ". ");
		}

	}

	this.weakenDesites = function(div,specialDiv){
		this.session.queen.power += -5;
		this.session.jack.power += -5;
		this.session.king.power += -5;
		div.append( " The Dersites sure seem to be mad at them, though. ");
		specialDiv.append( "The " + this.player.htmlTitle() + " " + getRandomElementFromArray(lightQueenQuests))
	}

	//can die from this. not actually a real fight. short and brutal.
	this.fightDenizen = function(div,specialDiv){
		this.player.denizenFaced = true;
		var denizen = this.player.denizen;
		div.append(" Why is the " + denizen.name + " bellowing so loudly on " + this.player.shortLand() + "? ");
		var ret =  "The " + this.player.htmlTitle() + " is fighting " +denizen.name + ".  It is bloody, brutal and short. ";

		if(Math.seededRandom() >.5){
			this.player.power = this.player.power*2;  //current and future doubling of power.
			this.player.leveledTheHellUp = true;
			this.player.denizenDefeated = true;
			this.player.fraymotifs = this.player.fraymotifs.concat(this.player.denizen.fraymotifs);
			this.player.grist += denizen.grist;
			ret += denizen.name + " lies dead on the ground. "
			specialDiv.append(ret)
		}else{ //no CHOICE.  either you are berserking, or the denizen doesn't notice you in time to give you one.
				this.player.denizenFaced = true;
				this.player.denizenDefeated = false;
				div.append(" That didn't sound good... ");
				this.player.dead = true;
				if(this.enablingPlayer.aspect == "Void") this.player.makeDead("fighting their Denizen way too early, cloaked in Void");
				if(this.enablingPlayer.aspect == "Rage") this.player.makeDead("fighting their Denizen way too early, lost in Madness");
				ret += " The " +this.player.htmlTitleBasic() + " lies dead on the ground. "
				specialDiv.append(ret)

				var divID = (specialDiv.attr("id")) + "denizenDeath";
				var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
				specialDiv.append(canvasHTML);
				var canvas = document.getElementById("canvas"+ divID);

				var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
				drawSprite(pSpriteBuffer,this.player)

				copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0)
		}
	}

	//actually render babies if class would be rage, whimsical overlay???
	this.ectoBiologyStarted = function(div,specialDiv){
		//console.log("Void/Rage ecto babies: " + this.session.session_id);
		var playersMade = this.player.performEctobiology(this.session);
		div.append(" Wait. Are those BABIES!? What is even going on here?");
		var divID = (specialDiv.attr("id")) + "_babies";
		var ch = canvasHeight;
		if(this.session.players.length > 6){
			ch = canvasHeight*1.5;
		}
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";
		specialDiv.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		poseBabiesAsATeam(canvasDiv, this.player, playersMade, getGuardiansForPlayers(playersMade), 4000);

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
		var f = this.session.fraymotifCreator.makeFraymotif([this.player], 3);//first god tier fraymotif
		this.player.fraymotifs.push(f);
		specialDiv.append("Holy shit. Did the " + this.player.htmlTitleBasic() + " just randomly go GodTier? What the fuck is going on? Did they even die? This is some flagrant bullshit. Somehow they learned " + f.name + " too." );
		var divID = (specialDiv.attr("id")) + "godBS"
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		specialDiv.append(canvasHTML);
		var canvas = document.getElementById("canvas"+ divID);
		drawGetTiger(canvas, [this.player],repeatTime) //only draw revivial if it actually happened.

	}



}
