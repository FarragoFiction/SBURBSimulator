//the afterlife is essentially just a list of player snapshots. when a snapshot is added, make them not "dead". ghosts can double die.
function AfterLife(){
	this.ghosts = [];
	this.ghostsBannedFromInteracting = []; //for time reasons, if ghosts didn't interact with session the first time, they can't until the timeline divurges.
	this.timeLineSplitsWhen = null; //what is the event i'm waitin for to allow ghosts back in?

	this.addGhost = function(ghost){
		ghost.ghost = true;
		ghost.dead = false;
		this.ghosts.push(ghost);
	}


	//until the timeline splits, ghosts from first timeline can't interact, because they DIDN't interact.
	this.allowTransTimeLineInteraction = function(){
		console.log("timelines divurged, allowing transTimeline interaction");
		this.ghosts = this.ghosts.concat(this.ghostsBannedFromInteracting);
		this.ghostsBannedFromInteracting = [];
		this.timeLineSplitsWhen = null;
	}

	this.complyWithLifeTimeShenanigans = function(importantEvent){
		console.log("ghosts cant interact with a yellow yyard until timelines divurge");
		this.ghostsBannedFromInteracting = this.ghostsBannedFromInteracting.concat(this.ghosts);
		this.ghosts = [];
		this.timeLineSplitsWhen = importantEvent; //e can be null if undoing an undo
	}

	//mostly life players recycling them. not a double death.
	this.unspawn = function(ghost){
		ghost.dead = true;
	}

	this.findGuardianSpirit = function(player){
		return getRandomElementFromArray(this.findAllAlternateSelves(player.guardian));
	}


	this.findLovedOneSpirit = function(player){
		return getRandomElementFromArray(this.findAllDeadLovedOnes(player));
	};

	this.findHatedOneSpirit = function(player){
		return getRandomElementFromArray(this.findAllDeadLovedOnes(player));
	};

	this.findAllDeadLovedOnes = function(player){
		var lovedOnes = [];
		var hearts = player.getHearts();
		var diamonds = player.getDiamonds();
		var crushes = player.getCrushes();
		var relationships = hearts.concat(diamonds);
		var relationships = relationships.concat(crushes);
		for(var i = 0; i<relationships.length; i++){
			var r = relationships[i];
			lovedOnes = lovedOnes.concat(this.findAllAlternateSelves(r))
		}

		return lovedOnes;
	}

	this.findAllDeadHatedOnes = function(player){
		var hatedOnes = [];
		var clubs = player.getClubs();
		var spades = player.getSpades();
		var crushes = player.getBlackCrushes();
		var relationships = spades.concat(clubs);
		var relationships = relationships.concat(crushes);

		for(var i = 0; i<relationships.length; i++){
			var r = relationships[i];
			hatedOnes = hatedOnes.concat(this.findAllAlternateSelves(r))
		}

		return hatedOnes;
	}

	this.findAllDeadFriends = function(player){
		var lovedOnes = [];
		var relationships = player.getFriends();
		for(var i = 0; i <relationships.length; i++){
			var r = relationships[i];
			lovedOnes = lovedOnes.concat(this.findAllAlternateSelves(r))
		}

		return lovedOnes;
	}

	this.findAllDeadEnemies = function(player){
		var hatedOnes = [];
		var relationships = player.getEnemies();
		for(var i = 0; i <relationships.length; i++){
			var r = relationships[i];
			hatedOnes = hatedOnes.concat(this.findAllAlternateSelves(r))
		}

		return hatedOnes;
	}

	//not a quadrant of anything, probably.
	this.findAssholeSpirit = function(player){
		return getRandomElementFromArray(this.findAllDeadEnemies(player));
	}

	this.findFriendlySpirit = function(player){
		return getRandomElementFromArray(this.findAllDeadFriends(player));
	}

	this.areTwoPlayersTheSame = function(player1, player2){
		return player2.id == player1.id && player2.class_name == player1.class_name && player2.aspect == player1.aspect && player1.hair == player2.hair   //if they STILL match, well fuck it. they are the same person just alternate universe versions of each other.
	}

	//if I am being revived (god tiering on a slab, life player reviving me) I need to find my ghost in the afterlife and remove it entirely.
	this.findClosesToRealSelf = function(player){
		var selves = this.findAllAlternateSelves(player);
		var bestCanidateValue = 9999999;
		var bestCanidate = selves[0];
		//can't just check directly for mvp because i let corpses level up. the revived player could be stronger than the original.
		for(var i = 0; i<selves.length; i++){
			var ghost = selves[i];
			if(ghost.isDreamSelf == player.isDreamSelf && ghost.godTier == player.godTier){ //at least LOOK the same. (call this BEFORE reviving)
				var val = Math.abs(ghost.power - player.power )
				if(val < bestCanidateValue){
					bestCanidateValue = val;
					bestCanidate = ghost;
				}
			}
		}
		return bestCanidate; //no way to know for SURE this is the most recent ghost...but...PRETTY sure???
	}

	this.findAllAlternateSelves = function(player){
		var selves = [];
		for(var i = 0; i<this.ghosts.length; i++){
			var ghost = this.ghosts[i];
			if(this.areTwoPlayersTheSame(player, ghost)){
				selves.push(ghost);
			}
		}
		return selves
	}

	this.findAnyAlternateSelf = function(player){
		return getRandomElementFromArray(this.findAllAlternateSelves(player));
	}

	this.findAnyGhost = function(player){
		return getRandomElementFromArray(this.ghosts);
	}

	this.findAnyUndrainedGhost = function(){
		var ret = [];
		for(var i=0; i<this.ghosts.length; i++){
			if(this.ghosts[i].causeOfDrain == null) ret.push(this.ghosts[i])
		}
		return getRandomElementFromArray(ret);
	}


}

function removeDrainedGhostsFromPacts(ghostPacts){
	var ret = [];
	if(!ghostPacts) return [];
	for(var i = 0; i<ghostPacts.length; i++){
		if(!ghostPacts[i][0].causeOfDrain){
			ret.push(ghostPacts[i])
		}
	}
	return ret;
}
