function MurderPlayers(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.murderers = [];

	this.trigger = function(playerList){
		this.playerList = playerList;
		this.murderers = [];
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			if(this.session.availablePlayers[i].murderMode){
				this.murderers.push(this.session.availablePlayers[i]);
			}
		}

		return this.murderers.length > null;
	}

	this.addImportantEvent = function(player){
		//console.log( "A player is dead. Dream Self: " + player.isDreamSelf + " God Destiny: " + player.godDestiny + " GodTier: " + player.godTier);

		if(player.isDreamSelf == true && player.godDestiny == false && player.godTier == false){
			var current_mvp =  findStrongestPlayer(this.session.players)
			return this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
		}
	}

	this.renderContent = function(div){
		div.append("<br> <img src = 'images/sceneIcons/murder_icon.png'>"+this.contentForRender(div));
	}

	this.friendsOfVictimHateYou = function(victim, murderer){
		var livePlayers = findLivingPlayers(this.session.players); //reroll it 'cause people might have died during this set of murders.'
		//just, fuck that guy.
		var ret = "";
		for(var i = 0; i<livePlayers.length; i++){
			var p = livePlayers[i];
			if(p != murderer && p != victim){
				var rm = p.getRelationshipWith(murderer);
				var rv = p.getRelationshipWith(victim);
				//more they liked the victim, the more they hate you.
				if(rv.saved_type == rv.diamond){
					rm.value = -100;
					p.sanity += -100;
					ret += " The " + p.htmlTitle() + " is enraged that their Moirail was killed. ";
				}else if(rv.saved_type == rv.heart){
					rm.value = -100;
					p.sanity += -100;
					ret += " The " + p.htmlTitle() + " is enraged that their Matesprit was killed. ";
				}else if(rv.saved_type == rv.spades){
					rm.value = -100;
					p.sanity += -100;
					ret += " The " + p.htmlTitle() + " is enraged that their Kismesis was killed. ";
				}else if (rv.type() == rv.goodBig){
					rm.value = -20;
					ret += " The " + p.htmlTitle() + " is enraged that their crush was killed. ";
				}else if(rv.type() == rv.badBig && p.isTroll){
					rm.value = -20;
					ret += " The " + p.htmlTitle() + " is enraged that their spades crush was killed. ";
				}else if(rv.type() == rv.badBig && !p.isTroll){
					rm.increase();
					ret += " The " + p.htmlTitle() + " is pretty happy that their enemy was killed. ";
				}else if(rv.value > 0){  //iff i actually liked the guy.
					for(var j = 0; j< rv.value; j++){
						rm.decrease();
					}
					ret += " The " + p.htmlTitle() + " is pretty pissed that their friend was killed. ";
				}
			}
		}
		return ret;

	}

	//not necessarily murder mode player, could be self defense.
	this.renderMurder = function(div,murderer, victim){
		var divID = (div.attr("id")) + "_" + victim.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvas = document.getElementById("canvas"+ divID);

		var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(pSpriteBuffer,murderer)

		var dSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(dSpriteBuffer,victim)

		copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0)
		copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,200,0)

	}

	//diamond faces murderer, calms them the hell down and hug bumps are shared.
	this.renderDiamonds = function(div, murderer, diamond){

		var divID = (div.attr("id")) + "_" + diamond.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvas = document.getElementById("canvas"+ divID);

		var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(pSpriteBuffer,murderer)


		var dSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSpriteTurnways(dSpriteBuffer,diamond)

		//used to check if troll was involved. what the fuck ever. everybody uses the quadrant system. it's just easier.
		var diSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawDiamond(diSpriteBuffer)
		copyTmpCanvasToRealCanvasAtPos(canvas, diSpriteBuffer,175,0)

		setTimeout(function(){
			copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0)
			copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,150,0)
		},1000);
	}



	//random Auspistice settles their shit down.  this will probably be pretty rare.
	this.renderClubs = function(div, murderer, victim, club){
		//alert("clubs)")
		var divID = (div.attr("id")) + "_" + club.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvas = document.getElementById("canvas"+ divID);

		var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(pSpriteBuffer,murderer)

		var vSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(vSpriteBuffer,victim)

		var dSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSpriteTurnways(dSpriteBuffer,club)  //facing non-middle leafs

		//used to check if troll was involved. what the fuck ever. everybody uses the quadrant system. it's just easier.
		var diSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawClub(diSpriteBuffer,1000) //Auspisticism
		copyTmpCanvasToRealCanvasAtPos(canvas, diSpriteBuffer,475,50)

		setTimeout(function(){
			copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0)
			copyTmpCanvasToRealCanvasAtPos(canvas, vSpriteBuffer,200,0)
			copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,500,0)
		},1000);
	}

	this.contentForRender = function(div){
		var livePlayers = this.session.availablePlayers; //just because they are alive doesn't mean they are in the medium
		var ret = "";
		for(var i = 0; i<this.murderers.length; i++){
			var m = this.murderers[i];
			var worstEnemy = m.getWorstEnemyFromList(this.session.availablePlayers);
			if(worstEnemy) m.interactionEffect(worstEnemy);
			if(worstEnemy && worstEnemy.sprite.name == "sprite") console.log("trying to kill somebody not in the medium yet: " + worstEnemy.title() + " in session: " + this.session.session_id)
			var living = findLivingPlayers(this.session.players)
			removeFromArray(worstEnemy, living)
			var ausp = getRandomElementFromArray(living)
			if(ausp == worstEnemy || ausp == m){
				ausp = null;
			}
			//var notEnemy = m.getWorstEnemyFromList(this.session.availablePlayers);
			removeFromArray(m, this.session.availablePlayers);

			if(worstEnemy && worstEnemy.dead == false && this.canCatch(m,worstEnemy)){
				removeFromArray(worstEnemy, this.session.availablePlayers);
				//if blood player is at all competant, can talk down murder mode player.
				if(worstEnemy.aspect == "Blood" && worstEnemy.power > 2){
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += ", but instead the Bloody Thing happens and the " + m.htmlTitleBasic() + " is calmed down, and hug bumps are shared. ";
					if(m.dead) ret += " It is especially tragic that the burgeoning palemance is cut short with the " + m.htmlTitleBasic() + "'s untimely death. ";
					m.unmakeMurderMode();
					worstEnemy.checkBloodBoost(livePlayers);
					makeDiamonds(m, worstEnemy)
					this.renderDiamonds(div, m, worstEnemy);

					return ret; //don't try to murder. (and also blood powers stop any other potential murders);
				}
				var r = worstEnemy.getRelationshipWith(m)
				if(r.type() == r.goodBig ){
					//moiralligance.
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += ", but instead gets talked down hardcore. Shit is downright tender.";
					if(m.dead == true){ //they could have been killed by another murder player in this same tick
						ret += " The task is made especially easy (yet tragic) by the " + m.htmlTitle() + " being in the middle of dying. "
					}
					m.unmakeMurderMode();
					m.sanity = 1;
					makeDiamonds(m, worstEnemy)
					this.renderDiamonds(div, m, worstEnemy);

				}else if(ausp != null && r.type() == r.badBig){  //they hate you back....
					///auspitism, but who is middle leaf?
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += "(who hates them back just as much), but instead is interupted by the " + ausp.htmlTitle() + ", who convinces everyone to settle their shit down. ";
					if(m.dead == true){ //they could have been killed by another murder player in this same tick
						ret += " The task is made especially easy by the " + m.htmlTitle() + " dying partway through. "
					}
					m.unmakeMurderMode();
					m.sanity = 1;
					this.renderClubs(div, m, worstEnemy,ausp);
					makeClubs(ausp, m, worstEnemy)

				}else if(worstEnemy.power * worstEnemy.getPVPModifier("Defender") < m.power*m.getPVPModifier("Murderer")){
					var alt = this.addImportantEvent(worstEnemy);
					if(alt && alt.alternateScene(div)){
						//do nothing, alt scene will handle this.
					}else{
						m.increasePower();
						m.sanity += Math.abs(m.sanity); //killing someone really takes the edge off.

						ret += " The " + m.htmlTitle() + " brutally murders that asshole, the " + worstEnemy.htmlTitle() +". " + getPVPQuip(worstEnemy,m, "Defender", "Murderer");
						if(m.dead == true){ //they could have been killed by another murder player in this same tick
							ret += " Every one is very impressed that they managed to do it while dying."
						}
						ret += this.friendsOfVictimHateYou(worstEnemy, m);
						worstEnemy.makeDead("fighting against the crazy " + m.title());
						m.pvpKillCount ++;
						this.session.murdersHappened = true;
						var r = worstEnemy.getRelationshipWith(m);
						r.value = -10; //you are not happy with murderer
						m.victimBlood = worstEnemy.bloodColor;
						this.renderMurder(div, m, worstEnemy)
					}
				}else{
					var alt = this.addImportantEvent(worstEnemy)
					if(alt && alt.alternateScene(div)){
						//do nothing, alt scene will handle this
					}else{
						worstEnemy.increasePower();

						ret += " The " + m.htmlTitle() + " attempts to brutally murder that asshole, the " + worstEnemy.htmlTitle();
						ret += ", but instead gets murdered first, in self-defense. " + getPVPQuip(m,worstEnemy, "Murderer", "Defender");
						if(m.dead == true){ //they could have been killed by another murder player in this same tick
							ret += " The task is made especially easy by the " + m.htmlTitle() + " being already in the proccess of dying. "
						}
						m.makeDead("being put down like a rabid dog by the " + worstEnemy.title());
						worstEnemy.pvpKillCount ++;
						this.session.murdersHappened = true;
						var r = worstEnemy.getRelationshipWith(m);
						r.value = -10; //you are not happy with murderer
						worstEnemy.victimBlood = m.bloodColor;
						this.renderMurder(div,worstEnemy, m);
					}
				}
			}else{

				m.sanity += 3;
				if(m.sanity>0){
					//alert("shit settled")
					ret += " The " + m.htmlTitle() + " has officially settled their shit. ";
					m.unmakeMurderMode();
				}else{
					if(!m.dead && worstEnemy && !this.canCatch(m,worstEnemy)){
						//console.log("murder thwarted by mobility: " + this.session.session_id)
						if(worstEnemy.sprite.name == "sprite"){
							ret += " The " + m.htmlTitle() + " is too enraged to think things through.  The " + worstEnemy.htmlTitle() + " that they want to kill isn't even in the Medium, yet, dunkass!"
						}else if(worstEnemy.aspect == "Void"){
							console.log("void avoiding murderer: " + this.session.session_id)
							ret += " The " + m.htmlTitle() + " can't even find the " + worstEnemy.htmlTitle() + " in order to kill them! It's like they're fucking INVISIBLE or something. It's hard to stay enraged while wandering around, lost."
						}else if (worstEnemy.aspect == "Space"){
							ret += " The " + m.htmlTitle() + " can't even find the " + worstEnemy.htmlTitle() + " in order to kill them! They probably aren't even running away, but somehow the " + m.htmlTitle() + " keeps getting turned around. It's hard to stay enraged while wandering around, lost."
						}else{
							ret += " The " + m.htmlTitle() + " can't even find the " + worstEnemy.htmlTitle() + " in order to kill them! Do they just never stay in one spot for more than five seconds? Flighty bastard. It's hard to stay enraged while wandering around lost."
						}
						m.sanity += 3;
					}else if(!m.dead){
						ret += " The " + m.htmlTitle() + " can't find anybody they hate enough to murder. They calm down a little. ";
					}
				}
			}
		}
		removeFromArray(m, this.session.availablePlayers);
		return ret;
	}


	this.canCatch = function(m, worstEnemy){
		if(worstEnemy.sprite.name == "sprite") return false; //not in medium, dunkass.
		if(worstEnemy.mobility > m.mobility) return false;
		if(worstEnemy.aspect == "Void" && worstEnemy.isVoidAvailable() && worstEnemy.power >50) return false;
		if(worstEnemy.aspect == "Space" && worstEnemy.power > 50){
			console.log("high level space player avoiding a murderer" + this.session.session_id)
			return false;  //god tier calliope managed to hide from a Lord of Time. space players might not move around a lot, but that doesn't mean they are easy to catch.
		}
		return true;
	}

	this.content = function(){
		var livePlayers = this.playerList; //just because they are alive doesn't mean they are in the medium
		for(var i = 0; i<this.murderers.length; i++){
			var m = this.murderers[i];
			var worstEnemy = m.getWorstEnemyFromList(livePlayers);
			removeFromArray(m, this.session.availablePlayers);
			var ret = "";
			if(worstEnemy && worstEnemy.dead == false && this.canCatch(m,worstEnemy)){ //gotta fucking catch them.
				removeFromArray(worstEnemy, this.session.availablePlayers);
				//if blood player is at all competant, can talk down murder mode player.
				if(worstEnemy.aspect == "Blood" && worstEnemy.power > 2){
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += ", but instead the Bloody Thing happens and the " + m.htmlTitle() + " is calmed down, and hug bumps are shared. ";
					m.unmakeMurderMode();
					worstEnemy.checkBloodBoost(livePlayers);
					m.sanity = 1;
					return ret; //don't try to murder. (and also blood powers stop any other potential murders);
				}

				var r = worstEnemy.getRelationshipWith(m)
				if(r.type() == r.goodBig ){
					//moiralligance.
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += ", but instead gets talked down hardcore. Shit is downright tender.";
					m.unmakeMurderMode();
					m.sanity = 1;
					this.renderDiamonds(div, m, worstEnemy);
				}else if(worstEnemy.power * worstEnemy.getPVPModifier("Defender") < m.power*m.getPVPModifier("Murderer")){
					m.increasePower();

					ret += " The " + m.htmlTitle() + " brutally murders that asshole, the " + worstEnemy.htmlTitle() +". "+ getPVPQuip(worstEnemy,m, "Defender", "Murderer");
					ret += this.friendsOfVictimHateYou(worstEnemy, m);
					worstEnemy.makeDead("fighting against the crazy " + m.title())
					m.pvpKillCount ++;
					this.session.murdersHappened = true;
					m.victimBlood = worstEnemy.bloodColor;
				}else{
					worstEnemy.increasePower();
					ret += " The " + m.htmlTitle() + " attempts to brutally murder that asshole, the " + worstEnemy.htmlTitle();
					ret += ",but instead gets murdered first, in self-defense. "+ getPVPQuip(m,worstEnemy, "Murderer", "Defender");
					m.makeDead("being put down like a rabid dog by " + worstEnemy.title())
					worstEnemy.pvpKillCount ++;
					this.session.murdersHappened = true;
					worstEnemy.victimBlood = m.bloodColor;
				}
			}else{

				if(worstEnemy && !worstEnemy.dead && !this.canCatch(m,worstEnemy)){
					if(worstEnemy.aspect == "Void"){
						ret += " The " + m.htmlTitle() + " can't even find the " + worstEnemy.htmlTitle() + " in order to kill them! It's like they're fucking INVISIBLE or something."
					}else if (worstEnemy.aspect == "Space"){
						ret += " The " + m.htmlTitle() + " can't even find the " + worstEnemy.htmlTitle() + " in order to kill them! They probably aren't even running away, but somehow the " + m.htmlTitle() + " keeps getting turned around. "
					}else{
						ret += " The " + m.htmlTitle() + " can't even find the " + worstEnemy.htmlTitle() + " in order to kill them! Do they just never stay in one spot for more than five seconds? Flighty bastard. It's hard to stay enraged while wandering around lost."
					}

					m.sanity += 3;
				}else{
					ret += " The " + m.htmlTitle() + " can't find anybody they hate enough to murder. They calm down a little. ";
				}
				m.sanity += 1;
			}
		}
		removeFromArray(m, this.session.availablePlayers);
		return ret;
	}
}
