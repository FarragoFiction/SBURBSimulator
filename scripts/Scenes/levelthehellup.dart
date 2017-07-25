part of SBURBSim;


class LevelTheHellUp extends Scene {
	bool canRepeat = true;
	List<dynamic> playerList = [];  //what players are already in the medium when i trigger?


	LevelTheHellUp(Session session): super(session);

	@override
	bool trigger(playerList){
		this.playerList = playerList;
		for(num i = 0; i<playerList.length; i++){  //can happen even after death, because why not?
			var p = playerList[i];
			if(p.leveledTheHellUp){
				return true;
			}
		}
		return false;
	}
	//TODO if i evenually do something with boonies, can have fraymotifs locked to this.
	dynamic getBoonies(p){
		var num = (p.power).round() * 15;
		String denomination = " BOONDOLLARS";
		if(num > 1000000){
			num = (num/1000000).floor();
			denomination = " BOONMINTS";
		}else if(num > 100000){
			num = (num/100000).floor();
			denomination = " BOONBANKS";
		}
		else if(num > 10000){
			num = (num/10000).floor();
			denomination = " BOONBONDS";
		}else if(num > 1000){
			num = (num/1000).floor();
			denomination = " BOONBUCKS";
		}
		num += (rand.nextDouble()*75).floor();
		return num + denomination;
	}
	void renderForPlayer(div, player){
		var levelName = player.getNextLevel(); //could be undefined
		if(!levelName){
			//print("Scratched is: " + this.session.scratched + " Player has AAAAAAAALL the levels. All of them. " + this.session.session_id);
			return; //don't make a blank div
		}
		var boonies = this.getBoonies(player);
		String narration = "";
		num repeatTime = 1000;
		var divID = (div.attr("id")) + "_" + player.chatHandle+player.ectoBiologicalSource+player.id;
		String narrationHTML = "<br><div id ;= 'narration" + divID + "'></div>";

		div.append(narrationHTML);

		var narrationDiv = querySelector("#narration"+divID);
		//different format for canvas code

		if(levelName){
			narration += " The " + player.htmlTitle();

			narration += " skyrockets up the ECHELADDER to a new rung: " + levelName;
			narration +=	" and earns " + boonies + ". ";
		}
		narrationDiv.append(narration);
		if(levelName &&!player.godTier){
				String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth.toString() + "' height;="+canvasHeight.toString() + "'>  </canvas>";
				div.append(canvasHTML);
			  var canvasDiv = querySelector("#canvas"+ divID);
				drawLevelUp(canvasDiv, player);
		}else if(levelName && player.godTier){
			//god tier has to be taller.
			String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +1000.toString() + "' height;="+572.toString() + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);
			drawLevelUpGodTier(canvasDiv, player);
		}

	}
	@override
	void renderContent(div){
      String narration = "";
			for(num i = 0; i<this.playerList.length; i++){
				var p = this.playerList[i];
				if(p.leveledTheHellUp){
					this.renderForPlayer(div, p);
					p.leveledTheHellUp = false;
				}
			}
	}
	dynamic content(){
		String ret = "";
		for(num i = 0; i<this.playerList.length; i++){
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
