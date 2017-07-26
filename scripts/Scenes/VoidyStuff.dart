part of SBURBSim;

typedef ShenaniganCallback(Element normalDiv, Element newDiv);

class VoidyStuff extends Scene {
	bool canRepeat = true;
	List<dynamic> playerList = [];  //what players are already in the medium when i trigger?
	var player = null;
	var enablingPlayer = null;	


	VoidyStuff(Session session): super(session);


	@override
	bool trigger(playerList){
		this.playerList = playerList;
		this.player = null;
		if(rand.nextDouble() > .5){
			this.enablingPlayer = findAspectPlayer(this.session.availablePlayers, "Void");
			if(this.enablingPlayer == null) this.enablingPlayer = findAspectPlayer(this.session.availablePlayers, "Rage"); //if there is no void player
		}else{
			this.enablingPlayer = findAspectPlayer(this.session.availablePlayers, "Rage");
			if(this.enablingPlayer == null) this.enablingPlayer = findAspectPlayer(this.session.availablePlayers, "Void"); //if there is no rage player
		}

		if(this.enablingPlayer){
			if(this.enablingPlayer.isActive() || rand.nextDouble() > .5){
				this.player = this.enablingPlayer;
			}else{  //somebody else can be voided.
				this.player = rand.pickFrom(this.session.availablePlayers);  //don't forget that light players will never have void display none
			}
		}
		return this.player != null;
	}

	@override
	void renderContent(div){
		this.player.increasePower();
		this.player.increasePower();
		if(this.enablingPlayer.aspect == "Void") this.player.corruptionLevelOther += rand.nextIntRange(1,5); //void isn't a safe place to be.
		//div.append("<br>"+this.content());
		div.append("<br><img src = 'images/sceneIcons/shenanigans_icon.png'> ");
		this.chooseShenanigans(div);
	}
	void chooseShenanigans(div){
		removeFromArray(this.player, this.session.availablePlayers);
		String ret = "";
		String classDiv = "";
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

		String normalDivHTML = "<span id = '" +div.id+ "voidyStuffNormal'>  </span> ";
		div.append(normalDivHTML);
		var normalDiv = querySelector("#"+div.id+ "voidyStuffNormal");

		String newDivHTML = "<span class ='"+classDiv+"' id = '" +div.id+ "voidyStuffSpecial'>  </span> ";
		div.append(newDivHTML);
		normalDiv = querySelector("#"+div.id+ "voidyStuffNormal");
		var newDiv = querySelector("#"+div.id+ "voidyStuffSpecial");
		//don't godtier as soon as you get in, too unfair to the other players.
		if(this.player.godDestiny && this.player.getStat("power") > 10 && !this.player.godTier && rand.nextDouble()>0.8 && this.player.land != null){
			this.godTier(normalDiv, newDiv);
			this.endingPhrase(classDiv, newDiv);
			return;
		}else if(this.player.leader && !this.session.ectoBiologyStarted && rand.nextDouble() > .8){
				this.ectoBiologyStarted(normalDiv, newDiv);
				this.endingPhrase(classDiv, newDiv);
				return;
		}else if(this.player.landLevel >= 6 && this.player.land != null && !this.player.denizenDefeated && rand.nextDouble() > .8){
			this.fightDenizen(normalDiv, newDiv);
			this.endingPhrase(classDiv, newDiv);
			return;
		}else if(this.player.sanity < 5 && !this.player.murderMode && rand.nextDouble() > 0.9){
			print("flipping shit through voidy stuff");
			this.goMurderMode(normalDiv, newDiv);
			this.endingPhrase(classDiv, newDiv);
			return;
		}else{ //pick from random array.
				//TODO is there a dart equivalent to bind?
				//var options = [this.findFraymotif.bind(this,normalDiv,newDiv),this.makeEnemies.bind(this,normalDiv,newDiv), this.makeFriends.bind(this,normalDiv, newDiv),this.dolandQuests.bind(this,normalDiv,newDiv),this.weakenDesites.bind(this,normalDiv,newDiv),this.weakenDesites.bind(this,normalDiv,newDiv),this.weakenDesites.bind(this,normalDiv,newDiv)];
				var options = [this.findFraymotif, this.makeEnemies, this.makeFriends, this.dolandQuests, this.weakenDesites,this.dolandQuests, this.weakenDesites,this.dolandQuests, this.weakenDesites];
        ShenaniganCallback chosen = rand.pickFrom(options);
        chosen(normalDiv, newDiv);
		}

		this.endingPhrase(classDiv, newDiv);
	}
	void endingPhrase(classDiv, newDiv){
		if(classDiv == "rage"){
			this.rageEndingPhrase(newDiv);
		}else if(classDiv == "void"){
			this.voidEndingPhrase(newDiv);
		}else if(classDiv == "light"){
			this.voidEndingPhrase(newDiv);
		}
	}
	void voidEndingPhrase(newDiv){
		String ret = " The " + this.player.htmlTitle();
		var phrases = ["is sneaking around like a cartoon burglar.", "is holding up a sign saying 'You don't see me!'. ", "is hiding very obviously behind that lamppost.", "is badly disguised as a consort.", "is badly disguised as a carapacian.","is sneaking around underneath the only cardboard box in all of Paradox Space."];
		newDiv.append( ret + " " + rand.pickFrom(phrases));
	}
	void rageEndingPhrase(newDiv){
		String ret = " The " + this.player.htmlTitle();
		List<String> phrases = ["is probably actually under the influence of psychoactive drugs.","might actually be sleep walking.", "is all up and laughing the whole time.","can't seem to stop laughing.", "has a look of utmost concentration.", "doesn't even seem to know what's going on themselves.", "is badly cosplaying as a consort.", "somehow got a hold of 413 helium balloon and has had them tied to their neck this whole time.", "is wearing a sombrero. How HIGH do you even have to BE?","is screaming. They are not stopping.","has way to many fucking teeth.","wasn't there a second ago.","can see you.","is wearing the worlds strangest face paint.","is slowly but surely breaking everything.","seems to be ignoring gravity.","is walking on walls, somehow.", "wants you to know that they, like, really love you, man.","is humming the tune from Jaws over and over again.","is just breaking all the laws. All of them.","is failing to blink at all.","laughs and laughs and laughs and laughs and laughs and laughs and laughs and laughs."];
		newDiv.append( ret + " " + rand.pickFrom(phrases));
	}
	void findFraymotif(div, specialDiv){
		print("Void/Rage fraymotif acquired: " + this.session.session_id.toString());
		div.append(" What's that music playing? ");
		var f = this.player.getNewFraymotif();
		specialDiv.append("A sweeping musical number kicks in, complete with consort back up dancers. The " + this.player.htmlTitle() + " is the star. It is them. When it is over, they seem to have learned " + f.name + ". ");
	}
	void makeEnemies(div, specialDiv){
		this.player.damageAllRelationships();
		div.append(" Everybody seems to be pretty pissed at them, though. ");
		//brainstorm what they are doing here. rand array.
	}
	void makeFriends(div, specialDiv){
		this.player.boostAllRelationships();
		div.append(" Everybody seems to be pretty happy with them, though. ");
		//brainstorm what they are doing here, rand array.
	}
	void goMurderMode(div, specialDiv){
		this.player.sanity += -30;
		this.player.makeMurderMode();
		div.append(" You get a bad feeling about this. ");
		specialDiv.append("The " + this.player.htmlTitle() + " has taken an acrobatic fucking pirouette off the handle and into a giant pile of crazy.  You almost wish you hadn't seen this. This is completely terrifying.");
	}
	void dolandQuests(div, specialDiv){
		this.player.landLevel +=2;
		div.append(" Their consorts seem pretty happy, though. ") ;
		if(rand.nextDouble() > .95){ //small chance of serious.
			specialDiv.append( "The " + this.player.htmlTitle() + " is " + getRandomQuestFromAspect(rand, this.player.aspect,false) + ". ");
		}else{
			var specialStuff = ["teaching the local consorts all the illest of beats","explaining the finer points of the human game 'hopscotch' to local consorts","passing out banned orange fruits that may or may not exist to hungry local consorts","throwing a birthday party for the local consorts"];
			specialStuff.addAll(["reenacting tear jerking scenes from classic cinema with local consorts","adopting a local consort as their beloved daughter","explaining that all conflict will be resolved through the medium of rap, going forwards","passing out rumpled headgear like cheap cigars"]);
			specialStuff.addAll(["completely destabilizing the local consort economy by just handing out fat stacks of boonbucks","showing the local consorts how to draw graffiti all over the Denizen temples","explaining that each local consort is probably the hero of legend or some shit","encouraging local consorts to form secret societies around household items"]);

			specialDiv.append( "The " + this.player.htmlTitle() + " is " + rand.pickFrom(specialStuff) + ". ");
		}

	}
	void weakenDesites(div, specialDiv){
		this.session.queen.addStat("power",-5);
		this.session.jack.addStat("power",-5);
		this.session.king.addStat("power",-5);
		div.append( " The Dersites sure seem to be mad at them, though. ");
		specialDiv.append( "The " + this.player.htmlTitle() + " " + rand.pickFrom(lightQueenQuests));
	}
	void fightDenizen(div, specialDiv){
		this.player.denizenFaced = true;
		var denizen = this.player.denizen;
		div.append(" Why is the " + denizen.name + " bellowing so loudly on " + this.player.shortLand() + "? ");
		String ret = "The " + this.player.htmlTitle() + " is fighting " +denizen.name + ".  It is bloody, brutal and short. ";

		if(rand.nextDouble() >.5){
			this.player.addStat("power",this.player.getStat("power")*2);  //current and future doubling of power.
			this.player.leveledTheHellUp = true;
			this.player.denizenDefeated = true;
			this.player.fraymotifs.addAll(this.player.denizen.fraymotifs);
			this.player.grist += denizen.grist;
			ret += denizen.name + " lies dead on the ground. ";
			specialDiv.append(ret);
		}else{ //no CHOICE.  either you are berserking, or the denizen doesn't notice you in time to give you one.
				this.player.denizenFaced = true;
				this.player.denizenDefeated = false;
				div.append(" That didn't sound good... ");
				this.player.dead = true;
				if(this.enablingPlayer.aspect == "Void") this.player.makeDead("fighting their Denizen way too early, cloaked in Void");
				if(this.enablingPlayer.aspect == "Rage") this.player.makeDead("fighting their Denizen way too early, lost in Madness");
				ret += " The " +this.player.htmlTitleBasic() + " lies dead on the ground. ";
				specialDiv.append(ret);

				var divID = (specialDiv.id) + "denizenDeath";
				String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
				specialDiv.append(canvasHTML);
				var canvas = querySelector("#canvas"+ divID);

				var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
				drawSprite(pSpriteBuffer,this.player);

				copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0);
		}
	}
	void ectoBiologyStarted(div, specialDiv){
		//print("Void/Rage ecto babies: " + this.session.session_id);
		var playersMade = this.player.performEctobiology(this.session);
		div.append(" Wait. Are those BABIES!? What is even going on here?");
		var divID = (specialDiv.id) + "_babies";
		var ch = canvasHeight;
		if(this.session.players.length > 6){
			ch = canvasHeight*1.5;
		}
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+ch + "'>  </canvas>";
		specialDiv.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = querySelector("#canvas"+ divID);
		poseBabiesAsATeam(canvasDiv, this.player, playersMade, getGuardiansForPlayers(playersMade));

	}
	void godTier(div, specialDiv){
		if(this.enablingPlayer.aspect == "Void"){
			this.player.makeDead("hidden in void on their way to godhood");
		} else{
			this.player.makeDead("with ridiculous bullshit clown shenanigans");
		}
		this.player.makeGodTier();
		this.session.godTier = true;

		div.append(" What was that light on " + this.player.shortLand() + "? ");
		var f = this.session.fraymotifCreator.makeFraymotif(rand, [this.player], 3);//first god tier fraymotif
		this.player.fraymotifs.add(f);
		specialDiv.append("Holy shit. Did the " + this.player.htmlTitleBasic() + " just randomly go GodTier? What the fuck is going on? Did they even die? This is some flagrant bullshit. Somehow they learned " + f.name + " too." );
		var divID = (specialDiv.id) + "godBS";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		specialDiv.append(canvasHTML);
		var canvas = querySelector("#canvas"+ divID);
		drawGetTiger(canvas, [this.player]); //only draw revivial if it actually happened.

	}




}
