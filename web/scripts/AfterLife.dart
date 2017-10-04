import "SBURBSim.dart";

//the afterlife is essentially just a list of player snapshots. when a snapshot is added, make them not "dead". ghosts can double die.
class AfterLife {
    Logger logger = new Logger("Afterlife");
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
		logger.info("timelines divurged, allowing transTimeline interaction");
		//this.ghosts = this.ghosts.concat(this.ghostsBannedFromInteracting);
		this.ghosts.addAll(this.ghostsBannedFromInteracting);
		this.ghostsBannedFromInteracting = [];
		this.timeLineSplitsWhen = null;
	}
	void complyWithLifeTimeShenanigans(importantEvent){
        logger.debug("ghosts cant interact with a yellow yyard until timelines divurge");
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

    List<Player> findAllDeadHatedOnes(Player player){
	    List<Player> hatedOnes = [];
	    List<Relationship> clubs = player.getClubs();
	    List<Relationship> spades = player.getSpades();
	    List<Relationship> crushes = player.getBlackCrushes();
	    List<Relationship> relationships = new List<Relationship>();
	    relationships.addAll(clubs);
	    relationships.addAll(spades);
	    relationships.addAll(crushes);
	    for(num i = 0; i<relationships.length; i++){
		    var r = relationships[i];
		    hatedOnes.addAll(this.findAllAlternateSelves(r.target));
	    }

	    return hatedOnes;
    }

	dynamic findAllDeadFriends(Player player){
		List<dynamic> lovedOnes = [];
		var relationships = player.getFriends();
		for(num i = 0; i <relationships.length; i++){
			var r = relationships[i];

			lovedOnes.addAll(this.findAllAlternateSelves(r));
		}

		return lovedOnes;
	}
	dynamic findAllDeadEnemies(Player player){
		List<dynamic> hatedOnes = [];
		var relationships = player.getEnemies();
		for(num i = 0; i <relationships.length; i++){
			var r = relationships[i];
			hatedOnes.addAll(this.findAllAlternateSelves(r));
		}

		return hatedOnes;
	}
	dynamic findAssholeSpirit(Player player){
		return player.rand.pickFrom(this.findAllDeadEnemies(player));
	}
	dynamic findFriendlySpirit(Player player){
		return player.rand.pickFrom(this.findAllDeadFriends(player));
	}
	bool areTwoPlayersTheSame(Player player1, Player player2){
		return player2.id == player1.id ;   //if they STILL match, well fuck it. they are the same person just alternate universe versions of each other.;
	}
	dynamic findClosesToRealSelf(Player player){
		var selves = this.findAllAlternateSelves(player);
		if(selves.length == 0) return null;
		num bestCanidateValue = 9999999;
		var bestCanidate = selves[0];
		//can't just check directly for mvp because i let corpses level up. the revived player could be stronger than the original.
		for(num i = 0; i<selves.length; i++){
			var ghost = selves[i];
			if(ghost.isDreamSelf == player.isDreamSelf && ghost.godTier == player.godTier){ //at least LOOK the same. (call this BEFORE reviving)
				num val = (ghost.getStat(Stats.POWER) - player.getStat(Stats.POWER) ).abs();
				if(val < bestCanidateValue){
					bestCanidateValue = val;
					bestCanidate = ghost;
				}
			}
		}
		return bestCanidate; //no way to know for SURE this is the most recent ghost...but...PRETTY sure???
	}
	List<Player> findAllAlternateSelves(Player player){
		List<Player> selves = [];
		for(num i = 0; i<this.ghosts.length; i++){
			var ghost = this.ghosts[i];
			if(this.areTwoPlayersTheSame(player, ghost)){
				selves.add(ghost);
			}
		}
		return selves;
	}
	dynamic findAnyAlternateSelf(Player player){
		return player.rand.pickFrom(this.findAllAlternateSelves(player));
	}
	dynamic findAnyGhost(player){
		return player.rand.pickFrom(this.ghosts);
	}
	Player findAnyUndrainedGhost(Random rand){
		List<Player> ret = [];
		for(var i=0; i<this.ghosts.length; i++){
			if(this.ghosts[i].causeOfDrain == null) ret.add(this.ghosts[i]);
		}
		return rand.pickFrom(ret);
	}



}


List<GhostPact> removeDrainedGhostsFromPacts(List<GhostPact> ghostPacts){
	List<GhostPact> ret = [];
	if(ghostPacts == null) return [];
	for(num i = 0; i<ghostPacts.length; i++){
		if(ghostPacts[i].ghost.causeOfDrain != null && ghostPacts[i].ghost.causeOfDrain.isNotEmpty){
			ret.add(ghostPacts[i]);
		}
	}
	return ret;
}
