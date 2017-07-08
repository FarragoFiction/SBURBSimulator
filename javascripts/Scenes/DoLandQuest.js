
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
		this.playersPlusHelpers = [];
		var availablePlayers = this.session.availablePlayers.slice(); //don't modify available players while you iterate on it, dummy
		for(var j = 0; j<this.session.availablePlayers.length; j++){
			var p = this.session.availablePlayers[j]
			var ph = this.getPlayerPlusHelper(p, availablePlayers);
			if(ph){
				this.playersPlusHelpers.push(ph);
				if(ph[0].aspect != "Time" && ph[0].aspect != "Breath") availablePlayers.removeFromArray(ph[0]);   //for land qeusts only, breath players can do multiple. time players ALWAYS do multiple of everything.
				if(ph[1] && ph[0].aspect != "Time" && ph[0].aspect != "Breath" )availablePlayers.removeFromArray(ph[1])
			}
		}
		//console.log(this.playersPlusHelpers.length + " players are available for quests.");
		return this.playersPlusHelpers.length > 0;
	}


	this.getPlayerPlusHelper = function(p, availablePlayers){
		if(!p.land || p.power < 2 || p.grimDark > 3) return false;  //can't do quests at all.
		var helper = this.lookForHelper(p,availablePlayers);
		if(helper && helper.grimDark >= 3) helper = null;  //grim dark players aren't going to do quests.
		var playerPlusHelper = [p,helper];

		if((p.aspect == "Blood" || p.class_name == "Page") ){// if page or blood player, can't do it on own.
			if(playerPlusHelper[1] != null){
				if((p.landLevel < this.landLevelNeeded || p.aspect == "Space") || Math.seededRandom() > .5){
					return (playerPlusHelper);
				}

			}
		}else{
			if((p.landLevel < this.landLevelNeeded || p.aspect == "Space") || Math.seededRandom() > .5){
				return (playerPlusHelper);
			}
		}
	}

	this.findFraymotif = function(player,helper){
		var f;

		if(player.fraymotifs.length == 0){
			f = this.session.fraymotifCreator.makeFraymotif([player], 1);//shitty intial fraymotif.
			player.fraymotifs.push(f);
			return "The " + player.htmlTitle() + " feels...different. Like they are starting to understand what it MEANS to be a " + player.htmlTitleBasic() +". Huh. What do you think '" + f.name + "' means? ";
		}

		//i expect to do at least 10 land quests, so have a 3/10 chance of getting a fraymotif.
		var randomNumber = Math.seededRandom();
		if(randomNumber > 0.2) return "";

		var f  = player.getNewFraymotif(helper);
		return this.fraymotifFlavorTextForPlayer(player, f)

	}

	this.fraymotifFlavorTextForPlayer = function(player, fraymotif){
		var normalWays = ["The " + player.htmlTitle() + " purchases " + fraymotif.name + "from the fraymotif store like a sensible person. "];
		normalWays.push("The " + player.htmlTitle() + " has finally saved up enough boondollars to buy " + fraymotif.name + "from the fraymotif store. ");
		if(Math.seededRandom() > 0.5) return getRandomElementFromArray(normalWays);
		//otherwise do special shit.
		if(player.class_name == "Thief") return "The " + player.htmlTitle() + " blatantly robs the fraymotif store, scoring " + fraymotif.name + ".  I sure hope it's worth the risk of being put in the slammer. "
		if(player.class_name == "Rogue") return "The " + player.htmlTitle() + " daringly heists fraymotif store, scoring " + fraymotif.name + ".  Nobody will notice it's missing for days. "
		if(player.class_name == "Knight") return "The " + player.htmlTitle() + " vallantly defends the fraymotif store from underlings, scoring " + fraymotif.name + " as a reward. "
		if(player.class_name == "Seer") return "The " + player.htmlTitle() + " is made aware that " + fraymotif.name + " is hidden in a secret location, and claims it. "
		if(player.class_name == "Bard") return "The " + player.htmlTitle() + " just suddenly knows " + fraymotif.name + ".  I sure hope you aren't expecting to find out HOW they learned it. "
		if(player.class_name == "Page") return "The " + player.htmlTitle() + " has worked hard and put in the hours and now knows " + fraymotif.name + ".  Sometimes hard work pays off!. "
		if(player.class_name == "Sylph") return "The " + player.htmlTitle() + " has built up a rapport with the consort running the fraymotif shop. They receive " + fraymotif.name + " on the house. "
		if(player.class_name == "Heir") return "The " + player.htmlTitle() + " finds out that " + fraymotif.name + " was bequeathed to them by a wealthy consort. Their death will not be in vain!  "
		if(player.class_name == "Maid") return "The " + player.htmlTitle() + " helps the consort that runs the fraymotif shop organize everything.  They are rewarded with " + fraymotif.name + ". "
		if(player.class_name == "Prince") return "The " + player.htmlTitle() + " scores " + fraymotif.name + " for a stupidly discounted 'going out of business' price. "
		if(player.class_name == "Witch") return "The " + player.htmlTitle() + " joins a coven of Secret Wizards to learn " + fraymotif.name + ".   "
		if(player.class_name == "Mage") return "The " + player.htmlTitle() + " is pretty sure they have figured out the fraymotif system, at least enough to learn " + fraymotif.name + ". "
		return getRandomElementFromArray(normalWays);
	}


	this.renderContent = function(div){
		var content = this.content(div);
		//if(simulationMode) return;  will doing things like this speed AB up. might want to refactor gameEntity so only one div redered at fight end and not consantly.
		div.append("<br> <img src = 'images/sceneIcons/quest_icon.png'>"+content);

	}

	this.addImportantEvent = function(){
			var current_mvp =  findStrongestPlayer(this.session.players)
			return this.session.addImportantEvent(new FrogBreedingNeedsHelp(this.session, current_mvp.power) );
	}
	//high mobility players chosen first as helpers. both a blessing and a curse.
	this.lookForHelper = function(player,availablePlayers){
		var helper = null;

		//space player can ONLY be helped by knight, and knight prioritizes this
		if(player.aspect == "Space"){//this shit is so illegal
			helper = findClassPlayer(availablePlayers, "Knight");
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
				helper = findHighestMobilityPlayer(availablePlayers); //mobility might be useful in a fight, but it curses you to not get your shit done on your own planet.
			}else{
				this.player1 = null;
				return null;
			}
		}


		//if i'm not blood or page, or space, or maybe time random roll for a friend.
		if(this.session.availablePlayers.length > 1 && Math.seededRandom() > .5){
			helper = findHighestMobilityPlayer(availablePlayers);
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


		if(helper.aspect == "Heart" && helper.class_name == "Sylph"){
			console.log("Will i heal corruption? grim dark is:" + player.grimDark)
			console.log("sylph of heart corruption helping" + this.session.session_id)
			if(player.grimDark > 1){
				return " The " + helper.htmlTitle() + " heals the " + player.htmlTitle() + "'s broken identity', restoring any holds the broodfester tongues of GrimDarkness had on them and increasing their resistance to future infestations. ";
			}
			return " The " + helper.htmlTitle() + " innoculates the " + player.htmlTitle() + "'s identity' against future attacks of GrimDarkness. ";

		}
		player.interactionEffect(helper);
		helper.interactionEffect(player);
		var ret = "";
		if(helper == player){
			player.landLevel ++;
			player.increasePower();
			return " Partnering up with your own time clones sure is efficient. ";
		}

		if(player.grimDark>0 && helper.aspect == "Void"){
			console.log("void corruption helping" + this.session.session_id)
			return " The " + helper.htmlTitle() + " seems to commune with the ambiant corruption in the " + player.htmlTitle() + ", preventing it from piling up enough for them to reach the next tier of GrimDarkness.";
		}

		//okay, now that i know it's not a time clone, look at my relationship with my helper.
		var r1 = player.getRelationshipWith(helper);
		var r2 = helper.getRelationshipWith(player);

		if(helper.aspect == "Breath"){
			this.session.availablePlayers.push(player); //player isn't even involved, at this point.
			helper.increasePower();
			player.landLevel ++;
			if(r2.value > 0){
				ret += " The " + helper.htmlTitle() + " tells the " + player.htmlTitle() + " that they are going to run on ahead and do some quests on " + player.shortLand() + " on their own. The " + player.htmlTitle() + " is freed up to do other shit, now. " ;
				//console.log("breath player doing quests for a friend: " + this.session.session_id)
			}else{
				ret += " The " + helper.htmlTitle() + " gets annoyed with how slow the " + player.htmlTitle() + " is being and runs ahead to get aaaaaaaall the levels and experience. At least the " + player.htmlTitle() + " has less stuff to do for the their main quests, now. " ;
			//	console.log("breath player ignoring enemy to get exp: " + this.session.session_id)
			}
		}

		if(helper.aspect == "Blood"){
			player.boostAllRelationships();
			player.boostAllRelationshipsWithMe();
			player.sanity += 1;
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
			player.sanity += -10;
			helper.sanity += -10;
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
			player1.corruptionLevelOther += 5;
			ret = true;
		}

		if(player2 && player1.grimDark>0){
			player2.corruptionLevelOther += 5;
			ret = true;
		}

		if(corruptedOtherLandTitles.indexOf(player1.land1) != -1 || corruptedOtherLandTitles.indexOf(player1.land2) != -1 ){
			player1.corruptionLevelOther += 5;
			ret = true;
			if(player2) player2.corruptionLevelOther += 5;
		}

		if(player1.object_to_prototype.corrupted && !player1.sprite.dead){
		//	console.log("corrupt sprite: " + this.session.session_id)
			player1.corruptionLevelOther += 5;
			ret = true;
			if(player2) player2.corruptionLevelOther += 5;
		}

		if(ret){
			//console.log("Spreading corruptin in: " + this.session.session_id)
			return "The corruption is spreading."
		}
		return "";

	}

	this.spriteContent = function(player){
		if(player.sprite.dead) return "";//nothing to see here.
		var ret = player.sprite.htmlTitle()
		if(player.sprite.corrupted){
			player.landLevel += -0.75;
		}else if(player.sprite.helpfulness > 0){
			//console.log("good sprite: " + this.session.session_id)
			player.landLevel += 1;
		}else if(player.sprite.helpfulness < 0){
			//console.log("bad sprite: " + this.session.session_id)
			player.landLevel += -0.5;
			player.sanity += -0.1;
		}else{
			//console.log("normal sprite: " + this.session.session_id)
			player.landLevel += 0.5;
		}
		ret +=  " " + player.sprite.helpPhrase + " "; //best idea.
		return ret;
	}

	this.contentForPlayer = function(player, helper){
		var ret = "<Br><Br> ";
		ret += "The " + player.htmlTitle()  ;
		if(player.aspect != "Time") removeFromArray(player, this.session.availablePlayers);

		player.increasePower();
		player.landLevel ++;
		if(helper){
			if(helper.aspect != "Time") removeFromArray(helper, this.session.availablePlayers); //don't let my helper do their own quests.
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
		ret += this.findFraymotif(player, helper);
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
