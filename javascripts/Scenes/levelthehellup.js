function LevelTheHellUp(session){
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.session = session;
	this.trigger = function(playerList){
		this.playerList = playerList;
		for(var i = 0; i<playerList.length; i++){  //can happen even after death, because why not?
			var p = playerList[i];
			if(p.leveledTheHellUp){
				return true;
			}
		}
		return false;
	}

	this.getBoonies = function(p){
		var num = + Math.round(p.power) * 15;
		var denomination = " BOONDOLLARS";
		if(num > 1000000){
			num = Math.floor(num/1000000)
			denomination = " BOONMINTS"
		}else if(num > 100000){
			num = Math.floor(num/100000)
			denomination = " BOONBANKS"
		}
		else if(num > 10000){
			num = Math.floor(num/10000)
			denomination = " BOONBONDS"
		}else if(num > 1000){
			num = Math.floor(num/1000)
			denomination = " BOONBUCKS"
		}
		num += Math.floor(Math.seededRandom()*75);
		return num + denomination;
	}

	this.renderForPlayer = function(div,player){
		var levelName = player.getNextLevel(); //could be undefined
		if(!levelName){
			//console.log("Scratched is: " + this.session.scratched + " Player has AAAAAAAALL the levels. All of them. " + this.session.session_id)
			return; //don't make a blank div
		}
		var boonies = this.getBoonies(player)
		var narration = "";
		var repeatTime = 1000;
		var divID = (div.attr("id")) + "_" + player.chatHandle+player.ectoBiologicalSource+player.id;
		var narrationHTML = "<br><div id = 'narration" + divID + "'></div>";

		div.append(narrationHTML);

		var narrationDiv = $("#narration"+divID);
		//different format for canvas code

		if(levelName){
			narration += " The " + player.htmlTitle();

			narration += " skyrockets up the ECHELADDER to a new rung: " + levelName;
			narration +=	" and earns " + boonies + ". ";
		}
		narrationDiv.append(narration);
		if(levelName &&!player.godTier){
				var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
				div.append(canvasHTML);
			  var canvasDiv = document.getElementById("canvas"+ divID);
				drawLevelUp(canvasDiv, player)
		}else if(levelName && player.godTier){
			//god tier has to be taller.
			var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +1000 + "' height="+572 + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = document.getElementById("canvas"+ divID);
			drawLevelUpGodTier(canvasDiv, player)
		}

	}

  //2.0 stuff
	this.renderContent = function(div){
      var narration = "";
			for(var i = 0; i<this.playerList.length; i++){
				var p = this.playerList[i];
				if(p.leveledTheHellUp){
					this.renderForPlayer(div, p);
					p.leveledTheHellUp = false;
				}
			}
	}

	this.content = function(){
		var ret = "";
		for(var i = 0; i<this.playerList.length; i++){
			var p = this.playerList[i];
			if(p.leveledTheHellUp){
				var levelName = p.getNextLevel(); //could be undefined
				if(levelName){
					ret += " The " + p.htmlTitle();

					ret += " skyrockets up the ECHELADDER to a new rung: " + levelName;
					ret +=	" and earns " + this.getBoonies(p) + ". ";
			}
				p.leveledTheHellUp = false;
			}
		}
		return ret;
	}
}
