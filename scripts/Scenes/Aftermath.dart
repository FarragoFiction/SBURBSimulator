part of SBURBSim;

class Aftermath extends Scene {
	bool canRepeat = false;
	List<dynamic> playerList = [];  //what players are already in the medium when i trigger?
	


	Aftermath(Session session): super(session);

	@override
	bool trigger(playerList){
		this.playerList = playerList;
		return true; //this should never be in the main array. call manually.
	}
	dynamic democracyBonus(){
		String ret = "<Br><br><img src = 'images/sceneIcons/wv_icon.png'>";
		if(this.session.democraticArmy.getStat("power") == 0){
			return "";
		}
		if(this.session.democraticArmy.getStat("currentHP") > 10 && findLivingPlayers(this.session.players).length > 0 ){
			this.session.mayorEnding = true;
			ret += "The adorable Warweary Villein has been duly elected Mayor by the assembled consorts and Carapacians. ";
			ret += " His acceptance speech consists of promising to be a really great mayor that everyone loves who is totally amazing and heroic and brave. ";
			ret += " He organizes the consort and Carapacians' immigration to the new Universe. ";
		}else{
			if(findLivingPlayers(this.session.players).length > 0){
				this.session.waywardVagabondEnding = true;
				ret += " The Warweary Villein feels the sting of defeat. Although he helped the Players win their session, the cost was too great.";
				ret += " There can be no democracy in a nation with only one citizen left alive. He is the only remaining living Carapacian in the Democratic Army. ";
				ret += " He becomes the Wayward Vagabond, and exiles himself to the remains of the Players old world, rather than follow them to the new one.";
			}else{
				this.session.waywardVagabondEnding = true;
				ret += " The Warweary Villein feels the sting of defeat. He failed to help the Players.";
				ret += " He becomes the Wayward Vagabond, and exiles himself to the remains of the Players' old world. ";
			}
		}
		return ret;
	}
	void yellowLawnRing(div){
		var living = findLivingPlayers(this.session.players);
		var dead = findDeadPlayers(this.session.players);
		//time players doesn't HAVE to be alive, but it makes it way more likely.
		var singleUseOfSeed = rand.nextDouble();
		var timePlayer = findAspectPlayer(living, "Time");
		if(!timePlayer && singleUseOfSeed > .5){
			timePlayer = findAspectPlayer(this.session.players, "Time");
		}
		if(dead.length >= living.length && timePlayer || this.session.janusReward){
			//print("Time Player: " + timePlayer);
			timePlayer = findAspectPlayer(this.session.players, "Time") ;//NEED to have a time player here.;
			var s = new YellowYard(this.session);
			s.timePlayer = timePlayer;
			s.trigger(null);
			s.renderContent(div);
		}
	}
	String mournDead(div){
		var dead = findDeadPlayers(this.session.players);
		var living = findLivingPlayers(this.session.players);
		if(dead.length == 0){
			return "";
		}
		String ret = "<br><br>";
		if(living.length > 0){
			ret += " Victory is not without it's price. " + dead.length + " players are dead, never to revive. There is time for mourning. <br>";
		}else{
			ret += " The consorts and Carapacians both Prospitian and Dersite alike mourn their fallen heroes. ";
			ret += "<img src = 'images/abj_watermark.png' class='watermark'>";
		}

		for(num i = 0; i< dead.length; i++){
			var p = dead[i];
			ret += "<br><br> The " + p.htmlTitleBasic() + " died " + p.causeOfDeath + ". ";
			var friend = p.getWhoLikesMeBestFromList(living);
			var enemy = p.getWhoLikesMeLeastFromList(living);
			if(friend){
				ret += " They are mourned by the" + friend.htmlTitle() + ". ";
				div.append(ret);
				ret = "";
				this.drawMourning(div, p,friend);
				div.append(ret);
			}else if(enemy){
				ret += " The " +enemy.htmlTitle() + " feels awkward about not missing them at all. <br><br>";
				div.append(ret);
				ret = "";
			}
		}
		div.append(ret);
		return null;
	}
	void drawMourning(div, dead_player, friend){
		var divID = (div.id) + "_" + dead_player.chatHandle;
		String canvasHTML = "<br><canvas id='canvas$divID' width='$canvasWidth' height=$canvasHeight'>  </canvas>";
		div.append(canvasHTML);
		var canvasDiv = querySelector("#canvas"+ divID);

		var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
		drawSprite(pSpriteBuffer,friend);

		var dSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
		drawSprite(dSpriteBuffer,dead_player);

		copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
		copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
	}

	@override
	dynamic renderContent(Element div){
		bool yellowYard = false;
		String end = "<Br>";
		List<Player> living = findLivingPlayers(this.session.players);
		Player spacePlayer = this.session.findBestSpace();
		Player corruptedSpacePlayer = this.session.findMostCorruptedSpace();
		//var spacePlayer = findAspectPlayer(this.session.players, "Space");
		//...hrrrm...better debug this. looks like this can be triggered when players AREN"T being revived???
		if(living.length > 0  && (!this.session.king.dead || !this.session.queen.dead && this.session.queen.exiled == false)){

			end += " While various bullshit means of revival were being processed, the Black Royalty have fled Skaia to try to survive the Meteor storm. There is no more time, if the frog isn't deployed now, it never will be. There is no time for mourning. ";
			this.session.opossumVictory = true; //still laughing about this. it's when the players don't kill the queen/king because they don't have to fight them because they are al lint he process of god tier reviving. so the royalty fucks off. and when the players wake up, there's no bosses, so they just pop the frog in the skia hole.
			div.appendHtml(end,treeSanitizer: NodeTreeSanitizer.trusted);
			end = "<br><br>";
		}else if(living.length>0){
				if(living.length == this.session.players.length){
					end += " All ";
				}
				end += "${living.length} players are alive.<BR>" ;
				div.appendHtml(end,treeSanitizer: NodeTreeSanitizer.trusted);//write text, render mourning
				end = "<Br>";
				this.mournDead(div);
		}

		if(living.length > 0){
			//check for inverted frog.
			if(corruptedSpacePlayer.landLevel <= (this.session.minFrogLevel * -1)){
			    return this.purpleFrogEnding(div, end);
			}
			if(spacePlayer.landLevel >= this.session.minFrogLevel){
				end += "<br><img src = 'images/sceneIcons/frogger_animated.gif'> Luckily, the " + spacePlayer.htmlTitle() + " was diligent in frog breeding duties. ";
				if(spacePlayer.landLevel < 28){
					end += " The frog looks... a little sick or something, though... That probably won't matter. You're sure of it. ";
				}
				end += " The frog is deployed, and grows to massive proportions, and lets out a breath taking Vast Croak.  ";
				if(spacePlayer.landLevel < this.session.goodFrogLevel){
					end += " The door to the new universe is revealed.  As the leader reaches for it, a disaster strikes.   ";
					end += " Apparently the new universe's sickness manifested as its version of SBURB interfering with yours. ";
					end += " Your way into the new universe is barred, and you remain trapped in the medium.  <Br><br>Game Over.";
					end += " Or is it?";
					if(this.session.ectoBiologyStarted == true){
						//spacePlayer.landLevel = -1025; //can't use the frog for anything else, it's officially a universe. wait don't do this, breaks abs frog reporting
						this.session.makeCombinedSession = true; //triggers opportunity for mixed session
					}
					//if skaia is a frog, it can't take in the scratch command.
					this.session.scratchAvailable = false;
					//renderScratchButton(this.session);

				}else{
					end += this.democracyBonus();
					end += " <Br><br> The door to the new universe is revealed. Everyone files in. <Br><Br> Thanks for Playing. ";
					//spacePlayer.landLevel = -1025; //can't use the frog for anything else, it's officially a universe. wait don't do this, breaks abs frog reporting
					this.session.won = true;
				}
			}else{
				if(this.session.rocksFell){
					end += "<br>With Skaia's destruction, there is nowhere to deploy the frog to. It doesn't matter how much frog breeding the Space Player did.";
				}else{
					end += "<br>Unfortunately, the " + spacePlayer.htmlTitle() + " was unable to complete frog breeding duties. ";
					end += " They only got ${(spacePlayer.landLevel/this.session.minFrogLevel*100).round()}% of the way through. ";
					print("${(spacePlayer.landLevel/this.session.minFrogLevel*100).round()} % frog in session: ${this.session.session_id}");
					if(spacePlayer.landLevel < 0){
						end += " Stupid lousy goddamned GrimDark players fucking with the frog breeding. Somehow you ended up with less of a frog than when you got into the medium. ";
					}
					end += " Who knew that such a pointless mini-game was actually crucial to the ending? ";
					end += " No universe frog, no new universe to live in. Thems the breaks. ";
				}

				end += " If it's any consolation, it really does suck to fight so hard only to fail at the last minute. <Br><Br>Game Over.";
				end += " Or is it? ";
				this.session.scratchAvailable = true;
				SimController.instance.renderScratchButton(this.session);
				yellowYard = true;

			}
	}else{
		div.appendHtml(end,treeSanitizer: NodeTreeSanitizer.trusted);
		end = "<Br>";
		this.mournDead(div);
		end += this.democracyBonus();
		end += " <br>The players have failed. No new universe is created. Their home universe is left unfertilized. <Br><Br>Game Over. ";
	}
	Player strongest = findStrongestPlayer(this.session.players);
	end += "<br> The MVP of the session was: " + strongest.htmlTitle() + " with a power of: ${strongest.getStat("power")}";
	end += "<br>Thanks for Playing!<br>";
	div.appendHtml(end,treeSanitizer: NodeTreeSanitizer.trusted);
	String divID = (div.id) + "_aftermath" ;


	//poseAsATeam(canvasDiv, this.session.players, 2000); //everybody, even corpses, pose as a team.
	this.lastRender(div);
	if(yellowYard == true || this.session.janusReward){
		this.yellowLawnRing(div);  //can still scratch, even if yellow lawn ring is available
	}
	return null;
}

	Player trollKidRock(){
		String trollKidRockString = "b=%00%00%00%C2%91%C3%B0%15%10VDD%20&s=,,Rap-Rock,Riches,bawitdaBastard" ;//Ancient, thank you for best meme. ;
		Player trollKidRock = new CharacterEasterEggEngine().playerDataStringArrayToURLFormat([trollKidRockString])[0];
		trollKidRock.session = this.session;
		Fraymotif f = new Fraymotif([],  "BANG DA DANG DIGGY DIGGY", 3) ;//most repetitive song, ACTIVATE!!!;
		f.effects.add(new FraymotifEffect("power",3,true));  //buffs party and hurts enemies
		f.effects.add(new FraymotifEffect("power",1,false));
		f.flavorText = " OWNER plays a 90s hit classic, and you can't help but tap your feet. ENEMY seems to not be able to stand it at all.  A weakness? ";
		trollKidRock.fraymotifs.add(f);

		f = new Fraymotif([],  "BANG DA DANG DIGGY DIGGY", 3) ;//most repetitive song, ACTIVATE!!!;
		f.effects.add(new FraymotifEffect("power",3,true));  //buffs party and hurts enemies
		f.effects.add(new FraymotifEffect("power",1,false));
		f.flavorText = " OWNER plays a 90s hit classic, and you can't help but tap your feet. ENEMY seems to not be able to stand it at all.  A weakness? ";
		trollKidRock.fraymotifs.add(f);

		f = new Fraymotif([],  "BANG DA DANG DIGGY DIGGY", 3) ;//most repetitive song, ACTIVATE!!!;
		f.effects.add(new FraymotifEffect("power",3,true));  //buffs party and hurts enemies
		f.effects.add(new FraymotifEffect("power",1,false));
		f.flavorText = " OWNER plays a 90s hit classic, and you can't help but tap your feet. ENEMY seems to not be able to stand it at all.  A weakness? ";
		trollKidRock.fraymotifs.add(f);

		f = new Fraymotif([],  "BANG DA DANG DIGGY DIGGY", 3) ;//most repetitive song, ACTIVATE!!!;
		f.effects.add(new FraymotifEffect("power",3,true));  //buffs party and hurts enemies
		f.effects.add(new FraymotifEffect("power",1,false));
		f.flavorText = " OWNER plays a 90s hit classic, and you can't help but tap your feet. ENEMY seems to not be able to stand it at all.  A weakness? ";
		trollKidRock.fraymotifs.add(f);
		initializePlayers([trollKidRock], null); //TODO: confirm -PL
		trollKidRock.setStat("currentHP", 1000);
		return trollKidRock;
}
	GameEntity purpleFrog(){
		Player mvp = findStrongestPlayer(this.session.players);
		Map<String,dynamic> tmpStatHolder = {};
		tmpStatHolder["minLuck"] = -100;
		tmpStatHolder["maxLuck"] = 100;
		tmpStatHolder["hp"] = 30000+mvp.getStat("power") * this.session.players.length;  //this will be a challenge. good thing you have troll kid rock to lay down some sick beats.
		tmpStatHolder["mobility"] = -100;
		tmpStatHolder["sanity"] = 0;
		tmpStatHolder["freeWill"] = 200;
		tmpStatHolder["power"] =20000+mvp.getStat("power") * this.session.players.length; //this will be a challenge.
		tmpStatHolder["grist"] = 100000000;
		tmpStatHolder["abscondable"] = false; //this is still the final battle,
		tmpStatHolder["canAbscond"] = false;
		tmpStatHolder["RELATIONSHIPS"] = -100;  //not REAL relationships, but real enough for our purposes.
		//print(purpleFrog);
		GameEntity purpleFrog = new GameEntity(" <font color='purple'>" +Zalgo.generate("Purple Frog") + "</font>", null, this.session);
		purpleFrog.setStatsHash(tmpStatHolder);
		print(purpleFrog);
		//what kind of attacks does a grim dark purple frog have???  Croak Blast is from rp, but what else?

		Fraymotif f = new Fraymotif([], Zalgo.generate("CROAK BLAST"), 3) ;//freeMiliu_2K01 [F☆] came up with this one in the RP :)  :) :);
		f.effects.add(new FraymotifEffect("mobility",3,true));
		f.flavorText = " OWNER uses a weaponized croak. You would be in awe if it weren't so painful. ";
		purpleFrog.fraymotifs.add(f);

		f = new Fraymotif([],  Zalgo.generate("HYPERBOLIC GEOMETRY"), 3);//DM, the owner of the purple frog website came up with this one.;
		f.effects.add(new FraymotifEffect("mobility",3,false));
		f.flavorText = " OWNER somehow corrupts the very fabric of space. Everyone begins to have trouble navigating the corrupted and broken rules of three dimensional space. ";
		purpleFrog.fraymotifs.add(f);

		f = new Fraymotif([],  Zalgo.generate("ANURA JARATE"), 3);//DM, the owner of the purple frog website came up with this one. team fortress + texts from super heroes ftw.;
		f.effects.add(new FraymotifEffect("sanity",3,false));
		f.flavorText = " Did you know that some species of frogs weaponize their own urine? Now you do. You can never unknow this. The entire party is disgusted. ";
		purpleFrog.fraymotifs.add(f);

		f = new Fraymotif([],  Zalgo.generate("LITERAL TONGUE LASHING"), 3);//DM, the owner of the purple frog website came up with this one.;
		f.effects.add(new FraymotifEffect("mobility",2,false));
		f.effects.add(new FraymotifEffect("mobility",2,true));
		f.flavorText = " OWNER uses an incredibly long, sticky tongue to attack the ENEMY, hurting and immobilizing them. ";
		purpleFrog.fraymotifs.add(f);

		return purpleFrog;
	}
	List<Player> getGoodGuys(Player trollKidRock){
		List<Player> living = this.session.players;
		List<Player> allPlayers = this.session.players; //anybody can have doomedclones now, not just time players.

		for(int i = 0; i<allPlayers.length; i++){
			living.addAll(allPlayers[i].doomedTimeClones);
		}
		return living;
	}
	void purpleFrogEnding(Element div, String precedingText){
		//alert("purple frog incoming!!!" + this.session.session_id);
		//maybe load kid rock first and have callback for when he's done.
		//maybe kid rock only shows up for half purple frogs??? need plausible deniability? "Troll Kid Rock??? Never heard of him. Sounds like a cool dude, though."
		Player trollKidRock = this.trollKidRock();
		print(trollKidRock);
		GameEntity purpleFrog = this.purpleFrog();
		precedingText += "<img src = 'images/sceneicons/Purple_Frog_ANGERY.png'> What...what is going on? How...how can you have NEGATIVE 100% of a frog??? This...this doesn't look right.   The vast frog lets out a CROAK, but it HURTS.  It seems...hostile.  Oh fuck. <Br><br> The " + purpleFrog.htmlTitleHP() + " initiates a strife with the Players! Troll Kid Rock appears out of nowhere to help them. (What the hell???)<br><br><canvas id = 'trollKidRockAppears' width ='400' height = '300'></canvas>";
		div.appendHtml(precedingText,treeSanitizer: NodeTreeSanitizer.trusted);

		List<Player> purpleFighters = this.getGoodGuys(trollKidRock);
		//var callBack = this.finishPurpleStrife.bind(this, div, purpleFrog, purpleFighters, trollKidRock);
		//loadAllImagesForPlayerWithCallback(trollKidRock, callBack);
		loadAllImagesForPlayerWithCallback(trollKidRock, () {
			this.finishPurpleStrife(div, purpleFrog, purpleFighters, trollKidRock);
		});
	}
	void finishPurpleStrife(Element div, GameEntity purpleFrog, List<Player> fighters, Player trollKidRock){
		trollKidRock.renderSelf();  //gotta cache his sprite
		var tkrCanvas = querySelector("#trollKidRockAppears");
		drawTimeGears(tkrCanvas);//, trollKidRock);
		drawSinglePlayer(tkrCanvas, trollKidRock);
		fighters.add(Player.makeRenderingSnapshot(trollKidRock)); //sorry trollKidRock you are not REALLY a player.
		purpleFrog.strife(div, fighters,0);
		String ret = "";
		if(purpleFrog.getStat("currentHP") <= 0 || purpleFrog.dead) {
			this.session.won = true;
			ret += "With a final, deafening 'CROAK', the " + purpleFrog.name + " slumps over. While it appears dead, it is merely unconscious. Entire universes swirl within it now that it has settled down, including the Players original Universe. You guess it would make sense that your Multiverse would be such an aggressive, glitchy asshole, if it generated such a shitty, antagonistic game as SBURB.  You still don't know what happened with Troll Kid Rock. You...guess that while regular Universes start with a 'bang', Skaia has decreed that Multiverses have to start with a 'BANG DA DANG DIGGY DIGGY'.  <Br><br> The door to the new multiverse is revealed. Everyone files in. <Br><Br> Thanks for Playing. <span class = 'void'>Though, of course, the Horror Terrors slither in right after the Players. It's probably nothing. Don't worry about it.  THE END</span>";
		}else{
			ret += "With a final, deafening 'CROAK', the " + purpleFrog.name + " floats victorious over the remains of the Players.   The Horror Terrors happily colonize the new Universe, though, so I guess the GrimDark players would be happy with this ending?  <Br><Br> Thanks for Playing. ";
		}
		div.appendHtml(ret,treeSanitizer: NodeTreeSanitizer.trusted);
		this.lastRender(div);
	}
	void lastRender(Element div){
	    div = querySelector("#charSheets");
	    if(div == null || div.text.length == 0) return; //don't try to render if there's no where to render to
		for(int i = 0; i<this.session.players.length; i++){
			String canvasHTML = "<canvas class = 'charSheet' id='lastcanvas${this.session.players[i].id}_${this.session.session_id}' width='800' height='1000'>  </canvas>";
			div.appendHtml(canvasHTML,treeSanitizer: NodeTreeSanitizer.trusted);
			CanvasElement canvasDiv = querySelector("#lastcanvas${this.session.players[i].id}_${this.session.session_id}");
			CanvasElement first_canvas = querySelector("#firstcanvas${this.session.players[i].id}_${this.session.session_id}");
			CanvasElement tmp_canvas = getBufferCanvas(canvasDiv);
			drawCharSheet(tmp_canvas,this.session.players[i]);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, first_canvas,0,0);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, tmp_canvas,400,0);
		}
	}
	void content(Element div, i){
		String ret = " TODO: Figure out what a non 2.0 version of the Intro scene would look like. ";
		div.appendHtml(ret,treeSanitizer: NodeTreeSanitizer.trusted);
	}

}
