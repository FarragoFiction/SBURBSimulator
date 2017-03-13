function MurderPlayers(){
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.murderers = [];
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.murderers = [];
		//select a random player. if they've been triggered, random chance of going murderMode if enemies (based on how triggered.)
		this.player = getRandomElementFromArray(availablePlayers);
		for(var i = 0; i<availablePlayers.length; i++){
			if(availablePlayers[i].murderMode){
				this.murderers.push(availablePlayers[i]);
			}
		}

		return this.murderers.length > null;
	}
	
	this.renderContent = function(div){
		div.append("<br>"+this.contentForRender(div));
	}
	
	this.friendsOfVictimHateYou = function(victim, murderer, livePlayers){
		//just, fuck that guy.
		var ret = "";
		for(var i = 0; i<livePlayers.length; i++){
			var p = livePlayers[i];
			if(p != murderer && p != victim){
				var rm = p.getRelationshipWith(murderer);
				var rv = p.getRelationshipWith(victim);
				//more they liked the victim, the more they hate you.
				if(rv.type() == rv.goodBig){
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
		drawSprite(pSpriteBuffer,murderer,1000)

		var dSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(dSpriteBuffer,victim,1000)

		copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,-100,0)
		copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,100,0)

	}
	
	//diamond faces murderer, calms them the hell down and hug bumps are shared.
	this.renderDiamonds = function(div, murderer, diamond){
		var divID = (div.attr("id")) + "_" + diamond.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvas = document.getElementById("canvas"+ divID);
		
		var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(pSpriteBuffer,murderer,1000)

		var dSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSpriteTurnways(dSpriteBuffer,diamond,1000)

		copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,-100,0)
		copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,100,0)
	}
	
	this.contentForRender = function(div){
		var livePlayers = this.playerList; //just because they are alive doesn't mean they are in the medium
		for(var i = 0; i<this.murderers.length; i++){
			var m = this.murderers[i];
			var worstEnemy = m.getWorstEnemyFromList(livePlayers);
			removeFromArray(m, availablePlayers);
			var ret = "";
			if(worstEnemy && worstEnemy.dead == false){
				removeFromArray(worstEnemy, availablePlayers);
				//if blood player is at all competant, can talk down murder mode player.
				if(worstEnemy.aspect == "Blood" && worstEnemy.power > 2){
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += ", but instead the Bloody Thing happens and the " + m.htmlTitle() + " is calmed down, and hug bumps are shared. ";
					m.murderMode = false;
					worstEnemy.checkBloodBoost(livePlayers);
					m.triggerLevel = 1;
					this.renderDiamonds(div, m, worstEnemy);
					//don't hate your new diamond buddy
					var r = m.getRelationshipWith(worstEnemy);
					r.value = 1;
					return ret; //don't try to murder. (and also blood powers stop any other potential murders);
				}
				var r = worstEnemy.getRelationshipWith(m)
				if(r.type() == r.goodBig ){
					//moiralligance.
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += ", but instead gets talked down hardcore. Shit is downright tender.";
					m.murderMode = false;
					m.triggerLevel = 1;
					this.renderDiamonds(div, m, worstEnemy);
					var r = m.getRelationshipWith(worstEnemy);
					r.value = 1;
				}else if(worstEnemy.power < m.power*2){  //more likely to kill enemy than be killed. element of surprise
					m.increasePower();
					
					worstEnemy.causeOfDeath = "fighting the " + m.htmlTitle();
					ret += " The " + m.htmlTitle() + " brutally murders that asshole, the " + worstEnemy.htmlTitle() +". ";
					ret += this.friendsOfVictimHateYou(worstEnemy, m, livePlayers);
					worstEnemy.dead = true;
					m.victimBlood = worstEnemy.bloodColor;
					this.renderMurder(div, m, worstEnemy)
				}else{
					worstEnemy.increasePower();
					
					m.causeOfDeath = "being put down like a rabid dog by " + worstEnemy.htmlTitle()
					ret += " The " + m.htmlTitle() + " attempts to brutally murders that asshole, the " + worstEnemy.htmlTitle();
					ret += ",but instead gets murdered first, in self-defense. ";
					m.dead = true;
					worstEnemy.victimBlood = m.bloodColor;
					this.renderMurder(div,worstEnemy, m);
				}
			}else{
				ret += " The " + m.htmlTitle() + " can't find anybody they hate enough to murder. They calm down a little. ";
				m.triggerLevel += -1;
			}
		}
		removeFromArray(m, availablePlayers);
		return ret;
	}
	

	
	this.content = function(){
		var livePlayers = this.playerList; //just because they are alive doesn't mean they are in the medium
		for(var i = 0; i<this.murderers.length; i++){
			var m = this.murderers[i];
			var worstEnemy = m.getWorstEnemyFromList(livePlayers);
			removeFromArray(m, availablePlayers);
			var ret = "";
			if(worstEnemy && worstEnemy.dead == false){
				removeFromArray(worstEnemy, availablePlayers);
				//if blood player is at all competant, can talk down murder mode player.
				if(worstEnemy.aspect == "Blood" && worstEnemy.power > 2){
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += ", but instead the Bloody Thing happens and the " + m.htmlTitle() + " is calmed down, and hug bumps are shared. ";
					m.murderMode = false;
					worstEnemy.checkBloodBoost(livePlayers);
					m.triggerLevel = 1;
					return ret; //don't try to murder. (and also blood powers stop any other potential murders);
				}
				
				var r = worstEnemy.getRelationshipWith(m)
				if(r.type() == r.goodBig ){
					//moiralligance.
					ret += " The " + m.htmlTitle() + " attempts to murder that asshole, the " + worstEnemy.htmlTitle();
					ret += ", but instead gets talked down hardcore. Shit is downright tender.";
					m.murderMode = false;
					m.triggerLevel = 1;
					this.renderDiamonds(div, m, worstEnemy);
				}else if(worstEnemy.power < m.power*2){  //more likely to kill enemy than be killed. element of surprise
					m.increasePower();
					
					worstEnemy.causeOfDeath = "fighting the " + m.htmlTitle();
					ret += " The " + m.htmlTitle() + " brutally murders that asshole, the " + worstEnemy.htmlTitle() +". ";
					ret += this.friendsOfVictimHateYou(worstEnemy, m, livePlayers);
					worstEnemy.dead = true;
					m.victimBlood = worstEnemy.bloodColor;
				}else{
					worstEnemy.increasePower();
					
					m.causeOfDeath = "being put down like a rabid dog by " + worstEnemy.htmlTitle()
					ret += " The " + m.htmlTitle() + " attempts to brutally murders that asshole, the " + worstEnemy.htmlTitle();
					ret += ",but instead gets murdered first, in self-defense. ";
					m.dead = true;
					worstEnemy.victimBlood = m.bloodColor;
				}
			}else{
				ret += " The " + m.htmlTitle() + " can't find anybody they hate enough to murder. They calm down a little. ";
				m.triggerLevel += -1;
			}
		}
		removeFromArray(m, availablePlayers);
		return ret;
	}
}