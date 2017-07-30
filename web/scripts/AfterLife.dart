part of SBURBSim;

//the afterlife is essentially just a list of player snapshots. when a snapshot is added, make them not "dead". ghosts can double die.
class AfterLife {
	List<Player> ghosts = []; //TODO maybe eventually have "ghost" object
	List<Player> ghostsBannedFromInteracting = []; //for time reasons, if ghosts didn't interact with session the first time, they can't until the timeline divurges.
	var timeLineSplitsWhen = null; //what is the event i'm waitin for to allow ghosts back in?

	


	AfterLife() {}


	void addGhost(ghost){
		ghost.ghost = true;
		ghost.dead = false;
		this.ghosts.add(ghost);
	}
	void allowTransTimeLineInteraction(){
		print("timelines divurged, allowing transTimeline interaction");
		//this.ghosts = this.ghosts.concat(this.ghostsBannedFromInteracting);
		this.ghosts.addAll(this.ghostsBannedFromInteracting);
		this.ghostsBannedFromInteracting = [];
		this.timeLineSplitsWhen = null;
	}
	void complyWithLifeTimeShenanigans(importantEvent){
		print("ghosts cant interact with a yellow yyard until timelines divurge");
		this.ghostsBannedFromInteracting.addAll(this.ghosts);
		this.ghosts = [];
		this.timeLineSplitsWhen = importantEvent; //e can be null if undoing an undo
	}
	void unspawn(Player ghost){
		ghost.dead = true;
	}
	Player findGuardianSpirit(Player player){
		return player.rand.pickFrom(this.findAllAlternateSelves(player.guardian));
	}
	Player findLovedOneSpirit(Player player){
		return player.rand.pickFrom(this.findAllDeadLovedOnes(player));
	}
	Player findHatedOneSpirit(Player player){
		return player.rand.pickFrom(this.findAllDeadHatedOnes(player));
	}
	List<Player> findAllDeadLovedOnes(Player player){
		List<Player> lovedOnes = [];
		List<Relationship> hearts = player.getHearts();
		List<Relationship> diamonds = player.getDiamonds();
		List<Relationship> crushes = player.getCrushes();
		List<Relationship> relationships = new List<Relationship>();
    relationships.addAll(hearts);
		relationships.addAll(diamonds);
	  relationships.addAll(crushes);
		for(num i = 0; i<relationships.length; i++){
			var r = relationships[i];
			lovedOnes.addAll(this.findAllAlternateSelves(r.target));
		}

		return lovedOnes;
	}
	dynamic findAllDeadHatedOnes(player){
		List<Player> hatedOnes = [];
    List<Player> clubs = player.getClubs();
    List<Player> spades = player.getSpades();
    List<Player> crushes = player.getBlackCrushes();
		List<Player> relationships = new List<Player>();
		relationships.addAll(spades);
		relationships.addAll(clubs);
		relationships.addAll(crushes);

		for(num i = 0; i<relationships.length; i++){
			Player r = relationships[i];
			hatedOnes.addAll(this.findAllAlternateSelves(r));
		}

		return hatedOnes;
	}
	dynamic findAllDeadFriends(player){
		List<dynamic> lovedOnes = [];
		var relationships = player.getFriends();
		for(num i = 0; i <relationships.length; i++){
			var r = relationships[i];

			lovedOnes.addAll(this.findAllAlternateSelves(r));
		}

		return lovedOnes;
	}
	dynamic findAllDeadEnemies(player){
		List<dynamic> hatedOnes = [];
		var relationships = player.getEnemies();
		for(num i = 0; i <relationships.length; i++){
			var r = relationships[i];
			hatedOnes.addAll(this.findAllAlternateSelves(r));
		}

		return hatedOnes;
	}
	dynamic findAssholeSpirit(player){
		return player.rand.pickFrom(this.findAllDeadEnemies(player));
	}
	dynamic findFriendlySpirit(player){
		return player.rand.pickFrom(this.findAllDeadFriends(player));
	}
	bool areTwoPlayersTheSame(player1, player2){
		return player2.id == player1.id && player2.class_name == player1.class_name && player2.aspect == player1.aspect && player1.hair == player2.hair;   //if they STILL match, well fuck it. they are the same person just alternate universe versions of each other.;
	}
	dynamic findClosesToRealSelf(player){
		var selves = this.findAllAlternateSelves(player);
		num bestCanidateValue = 9999999;
		var bestCanidate = selves[0];
		//can't just check directly for mvp because i let corpses level up. the revived player could be stronger than the original.
		for(num i = 0; i<selves.length; i++){
			var ghost = selves[i];
			if(ghost.isDreamSelf == player.isDreamSelf && ghost.godTier == player.godTier){ //at least LOOK the same. (call this BEFORE reviving)
				num val = (ghost.getStat("power") - player.getStat("power") ).abs();
				if(val < bestCanidateValue){
					bestCanidateValue = val;
					bestCanidate = ghost;
				}
			}
		}
		return bestCanidate; //no way to know for SURE this is the most recent ghost...but...PRETTY sure???
	}
	List<Player> findAllAlternateSelves(player){
		List<Player> selves = [];
		for(num i = 0; i<this.ghosts.length; i++){
			var ghost = this.ghosts[i];
			if(this.areTwoPlayersTheSame(player, ghost)){
				selves.add(ghost);
			}
		}
		return selves;
	}
	dynamic findAnyAlternateSelf(player){
		return player.rand.pickFrom(this.findAllAlternateSelves(player));
	}
	dynamic findAnyGhost(player){
		return player.rand.pickFrom(this.ghosts);
	}
	dynamic findAnyUndrainedGhost(Random rand){
		List<dynamic> ret = [];
		for(var i=0; i<this.ghosts.length; i++){
			if(this.ghosts[i].causeOfDrain == null) ret.add(this.ghosts[i]);
		}
		return rand.pickFrom(ret);
	}



}


//pastJR was a dunkass and made ghostPacts lists of [Player, enablingAspect] pairs. need to make that an object later.
List<dynamic> removeDrainedGhostsFromPacts(ghostPacts){
	List<dynamic> ret = [];
	if(ghostPacts == null) return [];
	for(num i = 0; i<ghostPacts.length; i++){
		if(!ghostPacts[i][0].causeOfDrain.empty){
			ret.add(ghostPacts[i]);
		}
	}
	return ret;
}
