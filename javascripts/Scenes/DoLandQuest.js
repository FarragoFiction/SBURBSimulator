
//all available players do this. (so put this quest at the end, right before solving puzzles and dream bs.)
//get quest from either class or aspect array in random tables. if space, only aspect array (frog);

//can get help from another player, different bonuses based on claspect if so.
function DoLandQuest(session){
	this.canRepeat = true;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.playersPlusHelpers = []; //who is doing a land quest this turn?
	this.landLevelNeeded = 12;

	this.trigger = function(playerList){
		//console.log("do land quest trigger?")
		this.playersPlusHelpers = [];

		for(var i = 0; i<this.session.availablePlayers.length; i++){
			var p = this.session.availablePlayers[i]
			if(p.power > 2 && p.grimDark < 3){ //can't be first thing you do in medium.
				if(p.land != null){  //everyone can go over 100%, because post denizen quests are a thing now.
					var chance = Math.seededRandom();
					var helper = this.lookForHelper(p);
					if(helper && helper.grimDark >= 3) helper = null;  //grim dark players aren't going to do quests.

					if(p.land == null){//seriously don't do land quests without a land
						//console.log("not doing land quests because don't have a land")
					}else{
						var playerPlusHelper = [p,helper];

						if((p.aspect == "Blood" || p.class_name == "Page") ){// if page or blood player, can't do it on own.
							if(playerPlusHelper[1] != null){
								this.playersPlusHelpers.push(playerPlusHelper);
								removeFromArray(p, this.session.availablePlayers);
								removeFromArray(helper, this.session.availablePlayers); //don't let my helper do their own quests.
							}
						}else{
							this.playersPlusHelpers.push(playerPlusHelper);
							removeFromArray(p, this.session.availablePlayers);
							removeFromArray(helper, this.session.availablePlayers); //don't let my helper do their own quests.
						}
					}
				}else{
					//console.log("not doing land quests at " + p.land)
				}
			}
		}
		//console.log(this.playersPlusHelpers.length + " players are available for quests.");
		return this.playersPlusHelpers.length > 0;
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content(div));

	}

	this.addImportantEvent = function(){
			var current_mvp =  findStrongestPlayer(this.session.players)
			return this.session.addImportantEvent(new FrogBreedingNeedsHelp(this.session, current_mvp.power) );
	}
	//high mobility players chosen first as helpers. both a blessing and a curse.
	this.lookForHelper = function(player,div){
		var helper = null;

		//space player can ONLY be helped by knight, and knight prioritizes this
		if(player.aspect == "Space"){//this shit is so illegal
			helper = findClassPlayer(this.session.availablePlayers, "Knight");
			if(helper != player){ //a knight of space can't help themselves.
				return helper;
			}else{

			}
		}

		if(player.aspect == "Time" && Math.seededRandom() > .2){ //time players often partner up with themselves
			return player;
		}

		if(player.aspect == "Blood" || player.class_name == "Page"){ //they NEED help.
			if(this.session.availablePlayers.length > 1){
				helper = findHighestMobilityPlayer(this.session.availablePlayers); //mobility might be useful in a fight, but it curses you to not get your shit done on your own planet.
			}else{
				this.player1 = null;
				return null;
			}
		}


		//if i'm not blood or page, or space, or maybe time random roll for a friend.
		if(this.session.availablePlayers.length > 1 && Math.seededRandom() > .5){
			helper = findHighestMobilityPlayer(this.session.availablePlayers);
			if(player == helper ){
				return null;
			}
		}
		if(helper != player || player.aspect == "Time"){
			return helper;
		}

		return null;

	}

	this.calculateClasspectBoost = function(player, helper){
		player.interactionEffect(helper);
		helper.interactionEffect(player);
		var ret = "";
		if(helper == player){
			player.landLevel ++;
			player.increasePower();
			return " Partnering up with your own time clones sure is efficient. ";
		}
		//okay, now that i know it's not a time clone, look at my relationship with my helper.
		var r1 = player.getRelationshipWith(helper);
		var r2 = helper.getRelationshipWith(player);

		if(helper.aspect == "Blood"){
			player.boostAllRelationships();
			player.boostAllRelationshipsWithMe();
			player.triggerLevel += -1;
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " spends a great deal of time helping the " + player.htmlTitle() + " out with their relationship drama. " ;
			}else{
				ret += " The " + helper.htmlTitle() + " spends a great deal of time lecturing the " + player.htmlTitle() + " about the various ways a player can be triggered into going shithive maggots. " ;
			}
		}

		if(helper.aspect == "Time" || helper.aspect == "Light" || helper.aspect == "Hope" || helper.aspect == "Mind" || helper.className == "Page" || helper.className == "Seer"){
			player.landLevel ++;
			helper.increasePower();
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " is doing a kickass job of helping the " + player.htmlTitle() + ". " ;
			}else{
				ret += " The " + helper.htmlTitle() + " delights in rubbing how much better they are at the game in the face of the " + player.htmlTitle() + ". " ;
			}
		}

		if(helper.aspect == "Rage"){
			player.damageAllRelationships();
			player.damageAllRelationshipsWithMe();
			player.triggerLevel += 1;
			helper.triggerLevel += 1;
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " spends a great deal of time shit talking about the other players. ";
			}else{
				ret += " The " + helper.htmlTitle() + " spends a great deal of time making the " + player.htmlTitle() + " aware of every bad thing the other players have said behind their back. " ;
			}
		}

		if(helper.aspect == "Doom"){
			player.landLevel += 1;
			helper.landLevel +=-1;
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " figures the " + player.htmlTitle() + " could make better use of some quest items, so generously donates them to the cause. ";
			}else{
				ret += " The " + helper.htmlTitle() + " condescendingly says that since the " + player.htmlTitle() + "  is so bad at the game, they'll donate some of their quest items to them. ";
			}
		}

		if(helper.className == "Thief"){
			player.landLevel += -1;
			helper.landLevel ++;
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " covertly spends at least half of their time diverting resources to complete their own quests. ";
			}else{
				ret += " The " + helper.htmlTitle() + " blatantly steals resources from the" + player.htmlTitle() + ", saying that THEIR quests are just so much more important. " ;
			}
		}


		return ret;

	}

	this.spreadCoruption = function(player1, player2){
		var ret = false;
		if(player2 && player2.grimDark>0){
			player1.corruptionLevelOther += 25;
			ret = true;
		}

		if(player2 && player1.grimDark>0){
			player2.corruptionLevelOther += 25;
			ret = true;
		}

		if(corruptedOtherLandTitles.indexOf(player1.land1) != -1 || corruptedOtherLandTitles.indexOf(player1.land2) != -1 ){
			player1.corruptionLevelOther += 25;
			ret = true;
			if(player2) player2.corruptionLevelOther += 25;
		}

		if(player1.object_to_prototype.corrupted){
			console.log("corrupt sprite: " + this.session.session_id)
			player1.corruptionLevelOther += 25;
			ret = true;
			if(player2) player2.corruptionLevelOther += 25;
		}

		if(ret){
			//console.log("Spreading corruptin in: " + this.session.session_id)
			return "The corruption is spreading."
		}
		return "";

	}

	this.spriteContent = function(player){
		var ret = player.sprite.htmlTitle()
		if(player.sprite.corrupted){
			player.landLevel += -0.75;
			ret = " Oh god. What is going on. Why does just listening to " + player.sprite.htmlTitle() + " make your ears bleed!? "
		}else if(player.sprite.helpfulness > 0){
			//console.log("good sprite: " + this.session.session_id)
			player.landLevel += 1;
		}else if(player.sprite.helpfulness < 0){
			//console.log("bad sprite: " + this.session.session_id)
			player.landLevel += -0.5;
			player.triggerLevel += 0.1;
		}else{
			//console.log("normal sprite: " + this.session.session_id)
			player.landLevel += 0.5;
		}
		ret +=  " " + player.sprite.helpPhrase + " "; //best idea.
		return ret;
	}

	this.contentForPlayer = function(player, helper){
		var ret = "";
		ret += "The " + player.htmlTitle()  ;
		player.increasePower();
		player.landLevel ++;
		if(helper){
			ret += " and the " + helper.htmlTitle() + " do " ;
			helper.increasePower();
			player.landLevel ++;
		}else{
			ret += " does";
		}

		if(Math.seededRandom() >0.8){
			ret += " quests at " + player.shortLand();
		}else{
			ret += " quests in the " + player.land;
		}
		ret += ", " + player.getRandomQuest() + ". ";
		if(helper){
			ret += this.calculateClasspectBoost(player, helper);
		}
		if(helper != null && player  != helper ){
			r1 = player.getRelationshipWith(helper);
			r2 = helper.getRelationshipWith(player);
			ret += getRelationshipFlavorText(r1,r2, player, helper);
		}
		ret += this.spriteContent(player);
		ret += this.spreadCoruption(player, helper);
		return ret;
	}

	this.content = function(div){
		var ret = "";
		for(var i = 0; i<this.playersPlusHelpers.length; i++){
			var player = this.playersPlusHelpers[i][0];

			var living = findLivingPlayers(this.session.players);
			var dead = findDeadPlayers(this.session.players)
			if(living.length == 1 && dead.length > 2){
				console.log("SWEET BIKE STUNTS, BRO: " + this.session.session_id)
				var realSelf = "";
				if(!player.isDreamSelf && !player.godTier){
					console.log("Real self stunting in: " + this.session.session_id)
					realSelf =  "You are duly impressed that they are not a poser who does dreamself stunting.  Realself stunting 5ever, bro."
				}
				return "The " + player.htmlTitle()  + " is " + getRandomElementFromArray(bike_quests) + ". " + realSelf;
			}

			//console.log("doing land quests at: " + player.land)
			var helper = this.playersPlusHelpers[i][1]; //might be null
			if(player.aspect == "Space" && !helper){

				var alt = this.addImportantEvent();
				if(alt && alt.alternateScene(div)){
					//do nothing, alternate scene handles it
				}else{
					ret += this.contentForPlayer(player, helper);
				}
			}else{
				ret += this.contentForPlayer(player, helper);
			}
			if(player.denizen_index == 3 && !player.denizenDefeated ){
				ret += " They finally finished off all the main quests on " + player.land + ". They should be ready to face their Denizen. ";
			}
		}

		return ret;
	}

}
