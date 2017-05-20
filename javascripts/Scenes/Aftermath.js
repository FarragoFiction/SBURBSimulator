function Aftermath(session){
	this.session = session;
	this.canRepeat = false;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.trigger = function(playerList){
		this.playerList = playerList;
		return true; //this should never be in the main array. call manually.
	}


	this.democracyBonus = function(){
		var ret = "<Br><br><img src = 'images/sceneIcons/wv_icon.png'>";
		if(this.session.democracyStrength == 0){
			return ret;
		}
		if(this.session.democraticArmy.currentHP > 10 && findLivingPlayers(this.session.players).length > 0 ){
			this.session.mayorEnding = true;
			ret += "The adorable Warweary Villein has been duly elected Mayor by the assembled consorts and Carapacians. "
			ret += " His acceptance speech consists of promising to be a really great mayor that everyone loves who is totally amazing and heroic and brave. "
			ret += " He organizes the consort and Carapacians' immigration to the new Universe. ";
		}else{
			if(findLivingPlayers(this.session.players).length > 0){
				this.session.waywardVagabondEnding = true;
				ret += " The Warweary Villein feels the sting of defeat. Although he helped the Players win their session, the cost was too great.";
				ret += " There can be no democracy in a nation with only one citizen left alive. ";
				ret += " He becomes the Wayward Vagabond, and exiles himself to the remains of the Players old world, rather than follow them to the new one.";
			}else{
				this.session.waywardVagabondEnding = true;
				ret += " The Warweary Villein feels the sting of defeat. He failed to help the Players.";
				ret += " He becomes the Wayward Vagabond, and exiles himself to the remains of the Players' old world. ";
			}
		}
		return ret;
	}

	//oh goodness, what is this?
	this.yellowLawnRing = function(div){
		var living = findLivingPlayers(this.session.players);
		var dead = findDeadPlayers(this.session.players);
		//time players doesn't HAVE to be alive, but it makes it way more likely.
		var singleUseOfSeed = Math.seededRandom();
		var timePlayer = findAspectPlayer(living, "Time")
		if(!timePlayer && singleUseOfSeed > .5){
			timePlayer = findAspectPlayer(this.session.players, "Time")
		}
		if(dead.length >= living.length && timePlayer){
			//console.log("Time Player: " + timePlayer);
			var s = new YellowYard(this.session);
			s.timePlayer = timePlayer;
			s.trigger();
			s.renderContent(div);
		}
	}

	this.mournDead = function(div){
		var dead = findDeadPlayers(this.session.players);
		var living = findLivingPlayers(this.session.players);
		if(dead.length == 0){
			return "";
		}
		var ret = "<br><br>";
		if(living.length > 0){
			ret += " Victory is not without it's price. " + dead.length + " players are dead, never to revive. There is time for mourning. <br>";
		}else{
			ret += " The consorts and Carapacians both Prospitian and Dersite alike mourn their fallen heroes. ";
		}

		for(var i = 0; i< dead.length; i++){
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

	}

	this.drawMourning = function(div, dead_player, friend){
		var divID = (div.attr("id")) + "_" + dead_player.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvasDiv = document.getElementById("canvas"+ divID);

		var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(pSpriteBuffer,friend)

		var dSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(dSpriteBuffer,dead_player)

		copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0)
		copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0)
	}


	this.renderContent = function(div){
		var yellowYard = false;
		var end = "<Br>";
		var living = findLivingPlayers(this.session.players);
		var spacePlayer = findAspectPlayer(this.session.players, "Space");
		//...hrrrm...better debug this. looks like this can be triggered when players AREN"T being revived???
		if(living.length > 0  && (this.session.king.getHP()>0 || (this.session.queen.getHP()>0 && this.session.queen.exiled == false))){

			end += " While various bullshit means of revival were being processed, the Black Royalty have fled Skaia to try to survive the Meteor storm. There is no more time, if the frog isn't deployed now, it never will be. There is no time for mourning. "
			this.session.opossumVictory = true; //still laughing about this. it's when the players don't kill the queen/king because they don't have to fight them because they are al lint he process of god tier reviving. so the royalty fucks off. and when the players wake up, there's no bosses, so they just pop the frog in the skia hole.
			div.append(end);
			end = "<br><br>"
		}else if(living.length>0){
				if(living.length == this.session.players.length){
					end += " All "
				}
				end += living.length + " players are alive.<BR>" ;
				div.append(end);//write text, render mourning
				end = "<Br>";
				this.mournDead(div);
		}

		if(living.length > 0){
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
					end += " Or is it?"
					if(this.session.ectoBiologyStarted == true){
						this.session.makeCombinedSession = true; //triggers opportunity for mixed session
					}
					//I am hella tempted to implement mixed sessions here, like the troll/human session in canon.
					this.session.scratchAvailable = true;
					renderScratchButton(this.session);

				}else{
					end += this.democracyBonus();
					end += " <Br><br> The door to the new universe is revealed. Everyone files in. <Br><Br> Thanks for Playing. ";
					this.session.won = true;
				}
			}else{
				if(this.session.rocksFell){
					end += "<br>With Skaia's destruction, there is nowhere to deploy the frog to. It doesn't matter how much frog breeding the Space Player did."
				}else{
					end += "<br>Unfortunately, the " + spacePlayer.htmlTitle() + " was unable to complete frog breeding duties. ";
					end += " They only got " + Math.round(spacePlayer.landLevel/this.session.minFrogLevel*100) + "% of the way through. ";

					if(spacePlayer.landLevel < 0){
						end += " Stupid lousy goddamned GrimDark players fucking with the frog breeding. Somehow you ended up with less of a frog than when you got into the medium. ";
					}
					end += " Who knew that such a pointless mini-game was actually crucial to the ending? ";
					end += " No universe frog, no new universe to live in. Thems the breaks. ";
				}

				end += " If it's any consolation, it really does suck to fight so hard only to fail at the last minute. <Br><Br>Game Over.";
				end += " Or is it? "
				this.session.scratchAvailable = true;
				renderScratchButton(this.session);
				yellowYard = true;

			}
	}else{
		div.append(end);
		end = "<Br>";
		this.mournDead(div);
		end += this.democracyBonus();
		end += " <br>The players have failed. No new universe is created. Their home universe is left unfertilized. <Br><Br>Game Over. ";
	}
	var strongest = findStrongestPlayer(this.session.players)
	end += "<br> The MVP of the session was: " + strongest.htmlTitle() + " with a power of: " + strongest.power;
	end += "<br>Thanks for Playing!<br>"
	div.append(end);
	var divID = (div.attr("id")) + "_aftermath" ;

	var ch = canvasHeight;
	if(this.session.players.length > 6){
		ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
	}
	var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";

	div.append(canvasHTML);
	var canvasDiv = document.getElementById("canvas"+ divID);
	poseAsATeam(canvasDiv, this.session.players, 2000); //everybody, even corpses, pose as a team.
	if(yellowYard == true){
		this.yellowLawnRing(div);  //can still scratch, even if yellow lawn ring is available
	}
}

	this.content = function(div, i){
		var ret = " TODO: Figure out what a non 2.0 version of the Intro scene would look like. "
		div.append(ret);
	}
}
