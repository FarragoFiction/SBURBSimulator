function ExploreMoon(session){
	this.canRepeat = true;
	this.session = session;
	this.player1 = null;
	this.player2 = null; //optional

	this.checkPlayer = function(player){
		this.player1 = player;
		if(this.player1.dreamSelf == false){ //can't explore a moon without a dream self.
			this.player1 = null;
			return null;
		}

		this.getProspitBullshit = function(){
			var possibilities = ["attending dance parties", "fluttering about aimlessly", "chatting up Prospitans", "learning the recipe for HOLY PASTRIES", "listening to sermons on the vast Croak","attending dance offs", "protecting the sacred candy shop from burglars", "racing frogs"];
			var thing1 = getRandomElementFromArray(possibilities);
			possibilities.removeFromArray(thing1);
			var thing2 = getRandomElementFromArray(possibilities);


			var vision = "The visions of the future provided by Skaia were largely ignored.";
			//have different vision based on predicted results. player power >> king power, predict success. player power << king, predict failure.
			var dead = findDeadPlayers(this.session.players);
			var living = findLivingPlayers(this.session.players);

			if(dead.length > 0) vision = "What is that cloud showing? Is that...grub sauce? Please be grub sauce." //the dead won't be rare. replace this if at all possible.
			if(this.session.timeTillReckoning < 3 && getAveragePower(living)>this.session.king.getStat("currentHP")*2) vision = "Wow, everybody sure looks happy in that cloud. Maybe things will turn out after all?";
			if(this.session.timeTillReckoning < 3 && this.session.king.getStat("power")> getAverageHP(living) * 2) vision = "Um...Huh. That's. That's a lot of dead bodies. What's...what's going on in that cloud there?"
			if(this.player1.grimDark > 2 || (this.player2 && this.player2.grimDark > 0)) vision = "Skaia's clouds are dark. " //final option. no visions for grim dark players.

			return "whimsical Prospit activities, such as " + thing1 + " and " + thing2 + ". " + vision;
		}

		this.getDerseBullshit = function(){
			var possibilities = ["attending dance parties", "cheating at poker", "keeping tabs on the lifeblood of Derse", "learning the Derse waltz","understanding the nuances of a stab","lying their asses off to anyone and everyone","attending jazz clubs","setting up black market businesses","dodging the Derse law","smuggling contraband","delivering finely crafted suits"];
			var thing1 = getRandomElementFromArray(possibilities);
			possibilities.removeFromArray(thing1);
			var thing2 = getRandomElementFromArray(possibilities);

			var dead = findDeadPlayers(this.session.players);
			var living = findLivingPlayers(this.session.players);


			var whisper = "The whisperings of the HorrorTerrors provided a nice backdrop.";
			if(dead.length > 0) whisper = "...so, THAT's what it sounds like when a horrorterror laughs. Good to know." //the dead won't be rare. replace this if at all possible.
			if(this.session.timeTillReckoning < 3 && this.session.king.getStat("power")> getAverageHP(living) * 2) whisper = "Oh god, did the Horrorterrors get LOUDER!?"
			if(this.player1.aspect == "Void" || (this.player2 && this.player2.aspect == "Void")) whisper = "The Horrorterrors are strangely quiet, their whisperings strained, like someone trying to speak through a broken speaker.";
			if(this.player1.grimDark > 0 || (this.player2 && this.player2.grimDark > 0)) whisper = "The Horrorterrors whisperings call to them. "

			return "whimsical Derse activities, such as " + thing1 + " and " + thing2 + ". " + whisper;
		}

		if(player.aspect == "Blood" || player.class_name == "Page"){
			if(this.session.availablePlayers.length > 1){
				this.player2 = getRandomElementFromArray(this.session.availablePlayers);
				if(this.player2 == this.player1){
					this.player1 = null;
					this.player2 = null;
					return null;
				}
				if(this.player1.moon != this.player2.moon || !this.player2.dreamSelf){
					this.player2 = null;
					return null;
				}

			}else{
				this.player1 = null;
				return null;
			}
		}

		//if i'm not blood or page, random roll for a friend.
		if(this.session.availablePlayers.length > 1 && Math.seededRandom() > .5){
			this.player2 = getRandomElementFromArray(this.session.availablePlayers);
			if(this.player1 == this.player2 || !this.player2.dreamSelf || this.player1.moon != this.player2.moon){
				this.player2 = null;
			}
		}

	}

	this.renderContent = function(div){
		if(this.player1.moon == "Prospit")div.append("<br><img src = 'images/sceneIcons/prospit_icon.png'> ")
		if(this.player1.moon == "Derse")div.append("<br><img src = 'images/sceneIcons/derse_icon.png'> ")
		div.append(this.content());
	}
	this.trigger = function(playerList){
		this.player1 = null; //reset
		this.player2 = null;
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			this.checkPlayer(this.session.availablePlayers[i]);
			if(this.player1 != null){
				return true;
			}
		}
		if(this.player1 == null || this.session.availablePlayers.length == 0){
			return false;
		}
		return true;


	}

	this.checkBloodBoost = function(){
		if(this.player1.aspect == "Blood" && this.player2 != null){
			this.player2.boostAllRelationships
		}

		if(this.player2!=null && this.player2.aspect == "Blood"){
			this.player1.boostAllRelationships();
		}
	}

	this.content = function(){
		var ret = "";
		//remove player1 and player2 from available player list.
		removeFromArray(this.player1, this.session.availablePlayers);
		removeFromArray(this.player2, this.session.availablePlayers);
		//console.log(this.player1.title() + " is doing moon stuff with their land level at: " + this.player1.landLevel)
		var r1 = null;
		var r2 = null;
		this.player1.increasePower();
		if(this.player2 != null){
			this.player2.increasePower();
			this.player1.interactionEffect(this.player2);
			this.player2.interactionEffect(this.player1);
		}

		this.checkBloodBoost();

		ret += "The " + this.player1.htmlTitle();
		if(this.player2 != null){
			ret += " and the " + this.player2.htmlTitle() + " do ";
		}else{
			ret += " does "
		}
		if(this.player1.moon == "Prospit"){
			ret += this.getProspitBullshit();
		}else{
			ret += this.getDerseBullshit();
			this.player1.corruptionLevelOther += 3;
			if(this.player2) this.player2.corruptionLevelOther += 3;
		}

		if(this.player2 != null){
			var r1 = this.player1.getRelationshipWith(this.player2);
			var r2 = this.player2.getRelationshipWith(this.player1);
			if(r1.type() == " Totally In Love" && r2.type() == "Totally In Love"){
				ret += " The two flirt a bit. ";
			}else if(r2.type() == "Totally In Love"){
				ret += " The" + this.player2.htmlTitle() + " is flustered around the " + this.player1.htmlTitle();
			}else if(r1.type() == "Totally In Love"){
				ret += " The" + this.player1.htmlTitle() + " is flustered around the " + this.player2.htmlTitle();
			}else if(r1.type() == "Rivals" && r2.type() == "Rivals"){
				ret += " The two compete to see who can solve more puzzles. ";
			}else if(r2.type() == "Rivals"){
				ret += this.player2.htmlTitle() + " is irritable around the " + this.player1.htmlTitle() + ". ";
			}else if(r1.type() == "Rivals"){
				ret += " The" + this.player1.htmlTitle() + " is irritable around " + this.player2.htmlTitle();
			}
		}

		if(this.player2 && this.player2.grimDark>0){
			this.player1.corruptionLevelOther += 25;
			ret += " The corruption is spreading. "
		}

		if(this.player2 && this.player1.grimDark>0){
			this.player2.corruptionLevelOther += 25;
			console.log("spreading corruption in: "  + this.session.session_id)
			ret += " The corruption is spreading. "
		}
		return ret;
	}

}
