import "dart:html";
import "../SBURBSim.dart";
import '../../scripts/includes/logger.dart';


typedef ShenaniganCallback(Element normalDiv, Element newDiv);

class VoidyStuff extends Scene {

	Player player = null;
	Player enablingPlayer = null;


	VoidyStuff(Session session): super(session);


	@override
	bool trigger(List<Player> playerList){
		this.playerList = playerList;
		this.player = null;
		List<Player> availablePlayers = session.getReadOnlyAvailablePlayers();
		double randomCheck = rand.nextDouble();
		if(randomCheck > .66){
			this.enablingPlayer = findAspectPlayer(availablePlayers, Aspects.VOID);
			if(this.enablingPlayer == null){//if there is no void player
				this.enablingPlayer = findAspectPlayer(availablePlayers, Aspects.RAGE);
				if(this.enablingPlayer == null) this.enablingPlayer = findAspectPlayer(availablePlayers, Aspects.SAND);//if there is no rage player
			}
		}else if (randomCheck < .33){
			this.enablingPlayer = findAspectPlayer(availablePlayers, Aspects.RAGE);
			if(this.enablingPlayer == null) this.enablingPlayer = findAspectPlayer(availablePlayers, Aspects.VOID); //if there is no rage player
			if(this.enablingPlayer == null) this.enablingPlayer = findAspectPlayer(availablePlayers, Aspects.CHAOS);
			if(this.enablingPlayer == null){//if there is no rage player
				this.enablingPlayer = findAspectPlayer(availablePlayers, Aspects.SAND);
				if(this.enablingPlayer == null) this.enablingPlayer = findAspectPlayer(availablePlayers, Aspects.VOID);//if there is no sand player
			}
		}else{
			this.enablingPlayer = findAspectPlayer(availablePlayers, Aspects.SAND);
			if(this.enablingPlayer == null){//if there is no sand player
				this.enablingPlayer = findAspectPlayer(availablePlayers, Aspects.VOID);
				if(this.enablingPlayer == null) this.enablingPlayer = findAspectPlayer(availablePlayers, Aspects.RAGE);//if there is no void player
			}
		}

		if(this.enablingPlayer != null){
			//rage field makes it always act as if passive
			if(!session.mutator.rageField && (this.enablingPlayer.isActive() || rand.nextDouble() > .5)){
				this.player = this.enablingPlayer;
			}else{  //somebody else can be voided.
				this.player = rand.pickFrom(availablePlayers);  //don't forget that light players will never have void display none
			}
		}
		return this.player != null;
	}

	@override
	void renderContent(Element div){
		this.player.increasePower();
		this.player.increasePower();
		if(this.enablingPlayer.aspect == Aspects.VOID) this.player.corruptionLevelOther += rand.nextIntRange(1,5); //void isn't a safe place to be.
		//div.append("<br>"+this.content());
        appendHtml(div,"<br><img src = 'images/sceneIcons/shenanigans_icon.png'> ");
		this.chooseShenanigans(div);
	}
	void chooseShenanigans(Element div){
		session.removeAvailablePlayer(player);
		String ret = "";
		String classDiv = "";
		if(this.enablingPlayer.aspect == Aspects.VOID){
			classDiv = "void";

			if(!this.player.isVoidAvailable()){
					classDiv = "light";  //void players can't be hidden in the light.
			}
		}else if(this.enablingPlayer.aspect == Aspects.RAGE) {
			classDiv = "rage";
		}else if(this.enablingPlayer.aspect == Aspects.CHAOS){
			classDiv = "chaos";
		}else if(this.enablingPlayer.aspect == Aspects.SAND){
			classDiv = "sand";
		}


		if(classDiv == "void"){
			ret += "The " + this.player.htmlTitle() + " is doing...something. It's kind of hard to see.";
		}else if(classDiv == "rage"){
			ret += "The " + this.player.htmlTitle() + " is doing something... motherfucking miraculous. It's kind of hard to look away.";
		}else if(classDiv == "light"){
				ret += "The " + this.player.htmlTitle() + " is doing...something. It's kind of hard to-wait. What? Fucking Light players. Keep it down! The " + this.player.htmlTitleBasic() + " is trying to be sneaky and off screen!";
		}else if(classDiv == "chaos"){
				ret += "The " + this.player.htmlTitle() + " is being a chaotic little shitfest. They don't know what they're doing, and they don't care.";
		}else if(classDiv == "sand"){
			ret += "The " + this.player.htmlTitle() + " claims to be doing nothing. They look pretty suspicious.";
		}
		if(classDiv != 'light' && this.player != this.enablingPlayer) ret+= " You are definitely blaming the " + this.enablingPlayer.htmlTitle() + ", somehow. ";
		appendHtml(div, ret);
		//make array of functions. call one at random.
		//div you pass to fucntion is created here. div class is VOID, nothing or RAGE.

		String normalDivHTML = "<span id = '" +div.id+ "voidyStuffNormal'>  </span> ";
		appendHtml(div, normalDivHTML);
		Element normalDiv = querySelector("#"+div.id+ "voidyStuffNormal");

		String newDivHTML = "<span class ='"+classDiv+"' id = '" +div.id+ "voidyStuffSpecial'>  </span> ";
		appendHtml(div, newDivHTML);
		normalDiv = querySelector("#"+div.id+ "voidyStuffNormal");
		Element newDiv = querySelector("#"+div.id+ "voidyStuffSpecial");
		//don't godtier as soon as you get in, too unfair to the other players.
		bool canGod = checkCanGod();
		if(canGod){
			this.godTier(normalDiv, newDiv);
			this.endingPhrase(classDiv, newDiv);
			return;
		}else if(this.player.leader && !this.session.stats.ectoBiologyStarted && rand.nextDouble() > .8){
				this.ectoBiologyStarted(normalDiv, newDiv);
				this.endingPhrase(classDiv, newDiv);
				return;
		}else if(this.player.landLevel >= 6 && this.player.land != null && !this.player.denizenDefeated && rand.nextDouble() > .8){
			this.fightDenizen(normalDiv, newDiv);
			this.endingPhrase(classDiv, newDiv);
			return;
		}else if(this.player.getStat(Stats.SANITY) < 5 && !this.player.murderMode && rand.nextDouble() > 0.9){
			//session.logger.info("AB: flipping shit through voidy stuff");
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

	bool checkCanGod() {
		if(!this.player.godDestiny || this.player.godTier || this.player.land == null ) return false;
		bool ret = false;
		//more likely to happen the longer they've been playing the game.
		if(!player.denizenMinionDefeated) return rand.nextDouble()>0.9;
		if(!player.denizenDefeated) return rand.nextDouble()>0.8;
		if(player.denizenDefeated) return rand.nextDouble()>0.6;
		return false;
	}

	void endingPhrase(String classDiv, Element newDiv){
		if(classDiv == "rage"){
			this.rageEndingPhrase(newDiv);
		}else if(classDiv == "void"){
			this.voidEndingPhrase(newDiv);
		}else if(classDiv == "light"){
			this.voidEndingPhrase(newDiv);
		}
	}
	void voidEndingPhrase(Element newDiv){
		String ret = " The " + this.player.htmlTitle();
		List<String> phrases = ["is sneaking around like a cartoon burglar.", "is holding up a sign saying 'You don't see me!'. ", "is hiding very obviously behind that lamppost.", "is badly disguised as a consort.", "is badly disguised as a carapacian.","is sneaking around underneath the only cardboard box in all of Paradox Space."];
		appendHtml(newDiv, ret + " " + rand.pickFrom(phrases));
	}
	void rageEndingPhrase(Element newDiv){
		String ret = " The " + this.player.htmlTitle();
		List<String> phrases = ["is probably actually under the influence of psychoactive drugs.","might actually be sleep walking.", "is all up and laughing the whole time.","can't seem to stop laughing.", "has a look of utmost concentration.", "doesn't even seem to know what's going on themselves.", "is badly cosplaying as a consort.", "somehow got a hold of 413 helium balloon and has had them tied to their neck this whole time.", "is wearing a sombrero. How HIGH do you even have to BE?","is screaming. They are not stopping.","has way to many fucking teeth.","wasn't there a second ago.","can see you.","is wearing the worlds strangest face paint.","is slowly but surely breaking everything.","seems to be ignoring gravity.","is walking on walls, somehow.", "wants you to know that they, like, really love you, man.","is humming the tune from Jaws over and over again.","is just breaking all the laws. All of them.","is failing to blink at all.","laughs and laughs and laughs and laughs and laughs and laughs and laughs and laughs."];
		appendHtml(newDiv,  ret + " " + rand.pickFrom(phrases));
	}
	void findFraymotif(Element div, Element specialDiv){
		//session.logger.info("AB: Void/Rage fraymotif acquired: ");
		appendHtml(div, " What's that music playing? ");
		Fraymotif f = this.player.getNewFraymotif(this.enablingPlayer);
		appendHtml(specialDiv, "A sweeping musical number kicks in, complete with consort back up dancers. The " + this.player.htmlTitle() + " is the star. It is them. When it is over, they seem to have learned " + f.name + ". ");
	}
	void makeEnemies(Element div, Element specialDiv){
		this.player.damageAllRelationships();
		appendHtml(div, " Everybody seems to be pretty pissed at them, though. ");
		//brainstorm what they are doing here. rand array.
	}
	void makeFriends(Element div, Element specialDiv){
		this.player.boostAllRelationships();
		appendHtml(div, " Everybody seems to be pretty happy with them, though. ");
		//brainstorm what they are doing here, rand array.
	}
	void goMurderMode(Element div, Element specialDiv){
		this.player.addStat(Stats.SANITY, -30);
		this.player.makeMurderMode();
		appendHtml(div, " You get a bad feeling about this. ");
		appendHtml(specialDiv, "The " + this.player.htmlTitle() + " has taken an acrobatic fucking pirouette off the handle and into a giant pile of crazy.  You almost wish you hadn't seen this. This is completely terrifying.");
	}
	void dolandQuests(Element div, Element specialDiv){
		this.player.increaseLandLevel(2.0);
		appendHtml(div, " Their consorts seem pretty happy, though. ") ;
		if(rand.nextDouble() > .95){ //small chance of serious.
			appendHtml(specialDiv, "The " + this.player.htmlTitle() + " is " + rand.pickFrom(this.player.aspect.preDenizenQuests) + ". ");
		}else{
			List<String> specialStuff = ["teaching the local consorts all the illest of beats","explaining the finer points of the human game 'hopscotch' to local consorts","passing out banned orange fruits that may or may not exist to hungry local consorts","throwing a birthday party for the local consorts"];
			specialStuff.addAll(["reenacting tear jerking scenes from classic cinema with local consorts","adopting a local consort as their beloved daughter","explaining that all conflict will be resolved through the medium of rap, going forwards","passing out rumpled headgear like cheap cigars"]);
			specialStuff.addAll(["completely destabilizing the local consort economy by just handing out fat stacks of boonbucks","showing the local consorts how to draw graffiti all over the Denizen temples","explaining that each local consort is probably the hero of legend or some shit","encouraging local consorts to form secret societies around household items"]);

			appendHtml(specialDiv, "The " + this.player.htmlTitle() + " is " + rand.pickFrom(specialStuff) + ". ");
		}

	}
	void weakenDesites(Element div, Element specialDiv){
		this.session.npcHandler.queen.addStat(Stats.POWER,-5);
		this.session.npcHandler.jack.addStat(Stats.POWER,-5);
		this.session.npcHandler.king.addStat(Stats.POWER,-5);
		appendHtml(div, " The Dersites sure seem to be mad at them, though. ");
		appendHtml(specialDiv, "The " + this.player.htmlTitle() + " " + rand.pickFrom(lightQueenQuests));
	}
	void fightDenizen(Element div, Element specialDiv){
		this.player.denizenFaced = true;
		GameEntity denizen = this.player.denizen;
		appendHtml(div, " Why is the " + denizen.name + " bellowing so loudly on " + this.player.shortLand() + "? ");
		String ret = "The " + this.player.htmlTitle() + " is fighting " +denizen.name + ".  It is bloody, brutal and short. ";


		if(rand.nextDouble() >.5){
			this.player.addBuff(new BuffDenizenBeaten());  //current and future doubling of power.
			this.player.leveledTheHellUp = true;
			this.player.denizenDefeated = true;
			this.player.fraymotifs.addAll(this.player.denizen.fraymotifs);
			this.player.grist += denizen.grist;
			ret += denizen.name + " lies dead on the ground. ";
			appendHtml(specialDiv, ret);
		}else{ //no CHOICE.  either you are berserking, or the denizen doesn't notice you in time to give you one.
				this.player.denizenFaced = true;
				this.player.denizenDefeated = false;
				appendHtml(div, " That didn't sound good... ");
				this.player.dead = true;
				if(this.enablingPlayer.aspect == Aspects.VOID) ret += this.player.makeDead("fighting their Denizen way too early, cloaked in Void");
				if(this.enablingPlayer.aspect == Aspects.RAGE) ret += this.player.makeDead("fighting their Denizen way too early, lost in Madness");
				ret += " The " +this.player.htmlTitleBasic() + " lies dead on the ground. ";
				appendHtml(specialDiv, ret);

				String divID = (specialDiv.id) + "denizenDeath";
				String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
				appendHtml(specialDiv, canvasHTML);
				CanvasElement canvas = querySelector("#canvas"+ divID);

				CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
				Drawing.drawSprite(pSpriteBuffer,this.player);

				Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0);
		}
	}
	void ectoBiologyStarted(Element div, Element specialDiv){
		//session.logger.info("AB: Void/Rage ecto babies:" );
		List<Player> playersMade = this.player.performEctobiology(this.session);
		appendHtml(div, " Wait. Are those BABIES!? What is even going on here?");
		String divID = (specialDiv.id) + "_babies";
		int ch = canvasHeight;
		if(this.session.players.length > 6){
			ch = (canvasHeight*1.5).round();
		}
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$ch'>  </canvas>";
		appendHtml(specialDiv, canvasHTML);
		//different format for canvas code
		CanvasElement canvasDiv = querySelector("#canvas"+ divID);
		Drawing.poseBabiesAsATeam(canvasDiv, this.player, playersMade, getGuardiansForPlayers(playersMade));

	}
	void godTier(Element div, Element specialDiv){
	     //session.logger.info("AB:  godtiering through shenanigans in session ${session.session_id}");
		String ret = "";
		if(this.enablingPlayer.aspect == Aspects.VOID){
			ret += this.player.makeDead("hidden in void on their way to godhood");
		} else if(this.enablingPlayer.aspect == Aspects.RAGE){
			ret += this.player.makeDead("with ridiculous bullshit clown shenanigans");
		} else if(this.enablingPlayer.aspect == Aspects.CHAOS){
			ret += this.player.makeDead("vanishing out of existence, returning as a god");
		}
		this.player.makeGodTier();
		this.session.stats.godTier = true;

		appendHtml(div, ret +" What was that light on " + this.player.shortLand() + "? ");
		Fraymotif f = this.session.fraymotifCreator.makeFraymotif(rand, [this.player], 3);//first god tier fraymotif
		this.player.fraymotifs.add(f);
		appendHtml(specialDiv, "Holy shit. Did the " + this.player.htmlTitleBasic() + " just randomly go GodTier? What the fuck is going on? Did they even die? This is some flagrant bullshit. Somehow they learned " + f.name + " too." );
		String divID = (specialDiv.id) + "godBS";
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
		appendHtml(specialDiv, canvasHTML);
		CanvasElement canvas = querySelector("#canvas"+ divID);
		Drawing.drawGetTiger(canvas, [this.player]); //only draw revivial if it actually happened.

	}




}
