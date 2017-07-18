part of SBURBSim;


//can be positive or negative. if high enough, can
//turn into romance in a quadrant.
class Relationship {
	var value;
	var target;
	String saved_type = "";
	bool drama = false; //drama is set to true if type of relationship changes.
	String old_type = "";	//wish class variables were a thing.
	String neutral = "Ambivalent";
	String goodMild = "Friends";
	String goodBig = "Totally In Love";
	String badMild = "Rivals";
	String badBig = "Enemies";
	String heart = "Matesprits";
	String diamond = "Moirallegiance";
	String clubs = "Auspisticism";
	String spades = "Kismesissitude";	


	Relationship([this.value, this.target]) {}


	String nounDescription(){
		if(this.saved_type == this.diamond) return "moirail";
		if(this.saved_type == this.goodBig) return "crush";
		if(this.saved_type == this.badBig) return "black crush";
		if(this.saved_type == this.badMild) return "rival";
		if(this.saved_type == this.goodMild) return "friend";
		if(this.saved_type == this.clubs) return "auspistice";
		if(this.saved_type == this.spades) return "kismesis";
		if(this.saved_type == this.neutral) return "friend";
		return "friend";
	}
	dynamic changeType(){
		if(this.value > 20){ //used to be -10 to 10, but too many crushes.
			return this.goodBig;
		}else if(this.value < -20){  //need to calibrate scandalous fuck piles.
			return this.badBig;
		}else if(this.value > 0){
			return this.goodMild;
		}else if (this.value == 0){
			return this.neutral;
		}else{
			return this.badMild;
		}
	}
	void moreOfSame(){
		if(this.value >= 0){
			this.increase();
		}else{
			this.decrease();
		}
	}
	void increase(){
		this.value ++;
	}
	void decrease(){
		this.value += -1;
	}
	void setOfficialRomance(type){
		//don't generate any extra drama, the event that led to this was ALREADY drama.
		this.saved_type = type;
		this.old_type = type;
	}
	dynamic type(){
		//official relationships are different.
		if(this.saved_type == this.heart || this.saved_type == this.spades || this.saved_type == this.diamond || this.saved_type == this.clubs){
			return this.saved_type; //break up in own scene, not here.
		}
		if(this.saved_type == "" ){
			this.drama = false;
			this.saved_type = this.changeType();
			this.old_type = this.saved_type;
			//if it's big drama, you can have your scene
			if(this.saved_type == this.goodBig || this.saved_type == this.badBig){
				this.drama = true;
				this.old_type = this.goodMild;
			}
			return this.saved_type;
		}

		if(seededRandom() > 0.25){
			//enter or leave a relationship, or vaccilate.
			this.old_type = this.saved_type;
			this.saved_type = this.changeType();
		}

		if(this.old_type != this.saved_type){
			this.drama = true;
		}else{
			this.drama = false;
		}
		return this.saved_type;
	}
	dynamic description(){
		return this.saved_type + " with the " + this.target.htmlTitle();
	}




  static dynamic getRelationshipFlavorGreeting(r1, r2, me, you){
		String ret = "";
		if(r1.type() == r1.goodBig && r2.type() == r2.goodBig){
			ret += " Hey! ";
		}else if(r2.type() == r2.goodBig){
			ret += "Hey.";
		}else if(r1.type() == r1.goodBig){
			ret += " Uh, hey!";
		}else if(r1.type() == r1.badBig && r2.type() == r2.badBig){
			ret += " Hey, asshole.";
		}else if(r2.type() == r2.badBig){
			ret += "Er...hey?";
		}else if(r1.type() == r2.badBig){
			ret += "I'll make this quick. ";
		}else{
			ret += "Hey.";
		}
		return ret;

	}



  static String getRelationshipFlavorText(r1, r2, me, you) {



		String ret = "";
		if(r1.type() == r1.goodBig && r2.type() == r2.goodBig || r1.type == r1.heart){
			ret += " The two flirt a bit. ";
		}if(r1.type() == r1.diamonds){
			//print("impromptu feelings jam: " + this.session.session_id);
			ret += " The two have an impromptu feelings jam. ";
			me.sanity += 1;
			you.sanity += 1;
		}else if(r2.type() == r2.goodBig){
			ret += " The" + you.htmlTitle() + " is flustered around the " + me.htmlTitle()+ ". ";
		}else if(r1.type() == r1.goodBig){
			ret += " The" + me.htmlTitle() + " is flustered around the " + you.htmlTitle()+ ". ";
		}else if(r1.type() == r1.badBig && r2.type() == r2.badBig || r1.type == r1.spades){
			ret += " The two are just giant assholes to each other. ";
		}else if(r2.type() == r2.badBig){
			ret += you.htmlTitle() + " is irritable around the " + me.htmlTitle() + ". ";
		}else if(r1.type() == r2.badBig){
			ret += " The" + me.htmlTitle() + " is irritable around the " + you.htmlTitle() + ". ";
		}
		return ret;
	}


  //TODO if i remember right, this is used for alien players. how does Dart handle list of vars again?
  //is it reflection only?
  static dynamic cloneRelationship(relationship){
		Relationship clone = new Relationship();
		for(var propertyName in relationship) {
			clone[propertyName] = relationship[propertyName];
		}
		return clone;
	}



//when i am cloning players, i need to make sure they don't have a reference to the same relationships the original player does.
//if i fail to do this step, i accidentally give the players the Capgras delusion.
//this HAS to happen before transferFeelingsToClones.
  static	dynamic cloneRelationshipsStopgap(relationships){
		//print("clone relationships stopgap");
		List<dynamic> ret = [];
		for(num i = 0; i<relationships.length; i++){
			var r = relationships[i];
			ret.add(cloneRelationship(r));
		}
		return ret;
	}



//when i clone alien players on arival, i need their cloned relationships to be about the other clones
//not the original players.
//also, I <3 this method name. i <3 this sim.
  static void transferFeelingsToClones(player, clones){
		//print("transfer feelings to clones");
		for(var i =0; i<player.relationships.length; i++){
			var r = player.relationships[i];
			var clone = findClaspectPlayer(clones, r.target.class_name, r.target.aspect);
			//if i can't find a clone, it's probably a dead player that didn't come to the new session.
			//may as well keep the original relationship
			if(clone){
				r.target = clone;
			}

		}
	}



  static void makeHeart(player1, player2){
		player1.session.hasHearts = true;
		var r1 = player1.getRelationshipWith(player2);
		r1.setOfficialRomance(r1.heart);
		var r2 = player2.getRelationshipWith(player1);
		r2.setOfficialRomance(r2.heart);
	}



  static void makeSpades(player1, player2){
		player1.session.hasSpades = true;
		var r1 = player1.getRelationshipWith(player2);
		r1.setOfficialRomance(r1.spades);
		var r2 = player2.getRelationshipWith(player1);
		r2.setOfficialRomance(r2.spades);
	}



  static void makeDiamonds(player1, player2){
		player1.session.hasDiamonds = true;
		var r1 = player1.getRelationshipWith(player2);
		if(r1.value < 0){
			r1.value = 1;  //like you at least a little
		}
		r1.setOfficialRomance(r1.diamond);
		var r2 = player2.getRelationshipWith(player1);
		if(r2.value < 0){
			r2.value = 1;
		}
		r2.setOfficialRomance(r2.diamond);
	}



//clubs, why you so cray cray?
  static void makeClubs(middleLeaf, asshole1, asshole2){
		asshole1.session.hasClubs = true;
		var rmid1 = middleLeaf.getRelationshipWith(asshole1);
		var rmid2 = middleLeaf.getRelationshipWith(asshole2);

		var rass1mid = asshole1.getRelationshipWith(middleLeaf);
		var rass12 = asshole1.getRelationshipWith(asshole2);

		var rass2mid = asshole2.getRelationshipWith(middleLeaf);
		var rass21 = asshole2.getRelationshipWith(asshole1);

		if(rmid1.value > 0){
			rmid1.value = -1;  //hate you at least a little
		}

		if(rmid2.value > 0){
			rmid2.value = -1;  //hate you at least a little
		}

		rmid1.setOfficialRomance(rmid1.clubs);
		rmid2.setOfficialRomance(rmid1.clubs);
		rass1mid.setOfficialRomance(rmid1.clubs);
		rass12.setOfficialRomance(rmid1.clubs);
		rass2mid.setOfficialRomance(rmid1.clubs);
		rass21.setOfficialRomance(rmid1.clubs);
	}



  static dynamic randomBlandRelationship(targetPlayer){
		return new Relationship(1, targetPlayer);
	}



  static dynamic randomRelationship(targetPlayer){
		var r = new Relationship(getRandomInt(-21,21), targetPlayer);

		return r;
	}



//go through every pair of relationships. if both have same type AND they are lucky, be in quadrant.   (clover was VERY 'lucky' in love.)
//high is flushed or pale (if one player much more triggered than other). low is spades. no clubs for now.
//yes, claspect boosts might alter relationships from 'initial' value, but that just means they characters are likelyt o break up. realism.
	static void decideInitialQuadrants(players){
		num rollNeeded = 50;
		for(var i =0; i<players.length; i++){
			var player = players[i];
			var relationships = player.relationships;
			for(num j = 0; j<relationships.length; j++){
				var r = relationships[j];
				var roll = player.rollForLuck();
				if(roll > rollNeeded){
					if(r.type() == r.goodBig){
						var difference = (player.sanity - r.target.sanity).abs();
						if(difference > 2 || roll < rollNeeded + 25){ //pale
							makeDiamonds(player, r.target);
						}else{
							makeHeart(player, r.target);
						}
					}else if(r.type() == r.badBig){
						if(player.sanity > 0 || r.target.sanity > 0 || roll < rollNeeded + 10){ //likely to murder each other
							var ausp = getRandomElementFromArray(players);
							if(ausp && ausp != player && ausp != r.target){
								makeClubs(ausp, player, r.target);
							}
						}else{
							makeSpades(player, r.target);
						}
					}
				}
			}
		}
	}



}


