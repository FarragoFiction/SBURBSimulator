//known to lesser mortals as God Tier
function GetTiger(session){
	this.canRepeat = true;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.deadPlayersToGodTier = [];

	//doesn't matter if dream self 'cause sacrificial slab.
	this.trigger = function(playerList){
		this.playerList = playerList;
		this.deadPlayersToGodTier = [];
		if(this.session.reckoningStarted){
			return false; //can't god tier if you are definitely on skaia. (makes king fight too easy)
		}
		//all dead players who aren't god tier and are destined to be god tier god tier now.
		var deadPlayers = findDeadPlayers(playerList);
		for(var i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			if(!p.godTier && p.godDestiny){
				this.deadPlayersToGodTier.push(p);
			}
		}
		return this.deadPlayersToGodTier.length > 0;

	}

	this.renderContent = function(div){
		div.append(this.content());
		var repeatTime = 1000;
		var divID = (div.attr("id")) + "_tiger";
		var ch = canvasHeight;
		if(this.deadPlayersToGodTier.length > 6){
			ch = canvasHeight*2;
		}
		var players = this.deadPlayersToGodTier;
		if(!players[0].dead){
			var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";
			div.append(canvasHTML);
			//different format for canvas code
			var canvasDiv = document.getElementById("canvas"+ divID);

			drawGetTiger(canvasDiv, players,repeatTime) //only draw revivial if it actually happened.
		}


	}


	this.content = function(){
		var ret = getPlayersTitles(this.deadPlayersToGodTier) + " was always destined to take a Legendary Nap, and upon waking, become a God Tier. ";

		var withd = findPlayersWithDreamSelves(this.deadPlayersToGodTier);
		var withoutd = findPlayersWithoutDreamSelves(this.deadPlayersToGodTier);

		if(withd && Math.seededRandom() > .8){  //MOST players in canon go god tier via sacrificial slab.
			for(var i = 0; i< withd.length; i++){
				var p = withd[i];
				//console.log("Quest bed: " + this.session.session_id)
				ret += " Upon being laid to rest on their QUEST BED on the " + p.land + ", the " + p.htmlTitle() + "'s body glows, and rises Skaiaward. "
				ret +="On " + p.moon + ", their dream self takes over and gets a sweet new outfit to boot.  ";
				this.session.questBed = true;
			}
		}else if(withd){
			//console.log("We COULD have been on my quest bed, but random chance said no. "+ this.session.session_id)
			return;
		}

		if(withoutd){
			for(var i = 0; i< withoutd.length; i++){
				var p = withoutd[i];
				//console.log("sacrificial slab: " + this.session.session_id)
				ret += " Upon a wacky series of events leaving their corpse on their SACRIFICIAL SLAB on " + p.moon + ", the " + p.htmlTitle() + " glows and ascends to the God Tiers with a sweet new outfit."
				this.session.sacrificialSlab = true;
			}
		}
		this.session.godTier = true;
		ret += " They are now extremely powerful. ";

		if(findClassPlayer(this.deadPlayersToGodTier, "Page") != null){
			ret += " Everyone fails to ignore the Page's outfit. ";
		}

		for(var  i = 0; i<this.deadPlayersToGodTier.length; i++){
			var p = this.deadPlayersToGodTier[i];
			p.godTier = true;
			p.dreamSelf = false;
			p.murderMode = false;
			p.grimDark = false;
			p.leftMurderMode = false; //no scars
			p.triggerLevel = 1;
			p.dead = false;
			p.power += 200;
			p.canGodTierRevive = true;
			p.victimBlood = null;
		}
		return ret;
	}
}
