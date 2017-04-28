//the afterlife is essentially just a list of player snapshots. when a snapshot is added, make them not "dead". ghosts can double die.
function AfterLife(){
	this.ghosts = [];

	this.addGhost = function(ghost){
		ghost.ghost = true;
		ghost.dead = false;
		this.ghosts.push(ghost);
	}

	//mostly life players recycling them. not a double death.
	this.unspawn = function(ghost){
		ghost.dead = true;
	}


	this.findAllAlternateSelves = function(player){
		var selves = [];
		for(var i = 0; i<ithis.ghosts.length; i++){
			var ghost = this.ghosts[i];
			if(ghost.id == player.id && ghost.class_name == player.class_name && ghost.aspect == player.aspect && player.hair == ghost.hair ){  //if they STILL match, well fuck it. they are the same person just alternate universe versions of each other.
				selves.push(ghost);
			}
		}
		return selves
	}

	this.findAnyAlternateSelf = function(player){
		return getRandomElementInArray(this.findAllAlternateSelves(player));
	}

	this.findAnyGhost = function(player){
		return getRandomElementInArray(this.ghosts);
	}


}
