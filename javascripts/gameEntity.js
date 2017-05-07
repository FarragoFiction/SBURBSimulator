//jack/queen/king/denizen.
//multiround, but only takes 1 tick.
//when call fight method, pass in array of players. only those players are involved in fight.
//whoever calls fight is reponsible for high mobility players to be more likely in a fight.
//should use ALL stats. luck, mobility, freeWill, raw power, relationships, etc. Hope powered up by how screwed things are, for example. (number of corpses, lack of Ecto lack of frog, etc. ).
//denizens have a particular stat that won't matter. Can't beat Cetus in a Luck-Off, she is simply the best there is, for example.
//mini boss = denizen minion
//before I decide boss stats, need to have AB compile me a list of average player stats. She's getting kinda...busy though. maybe a secret extra area? same page, but on bottom?
//maybe eventually refactor murder mode to use this engine. both players get converted to game entitites for the fight?
//are sprites a game entity attached to player? have same stats as their prototyping would cause. help player fight. can be killed. leave the player entirely after
//denizen minion fight.
function GameEntity(session, name, crowned){
		this.session = session;
		this.name = name;
		this.grist = 0;
		//if any stat is -1025, it's considered to be infinitie. denizens use. you can't outluck Cetus, she is simply the best there is.
		this.minLuck = 0;
		this.currentHP = 0;
		this.hp = 0;  //what does infinite hp mean? you need to defeat them some other way. alternate win conditions? or can you only do The Choice?
		this.mobility = 0;  //first guardian
		this.maxLuck = 0; //rabbit
		this.triggerLevel = 0; //both players and enemy can be too freaked out or beserk to fight right
		this.freeWill = 0; //jack has extremely high free will. why he is such a wild card
		this.relationships = [];
		this.power = 0;
		this.dead = false;
		this.crowned = crowned;
		this.abscondable = true; //nice abscond
		this.canAbscond = true; //can't abscond bro
		this.fraymotifsUsed = [];  //horrorTerror
		this.playersAbsconded = [];
		this.iAbscond = false;
		this.exiled = false;

		this.getMobility = function(){
			if(this.crowned){
				return this.mobility + this.crowned.mobility;
			}
			return this.mobility;
		}

		this.getMaxLuck = function(){
			if(this.crowned){
				return this.maxLuck + this.crowned.maxLuck;
			}
			return this.maxLuck;
		}

		this.getMinLuck = function(){
			if(this.crowned){
				return this.minLuck + this.crowned.minLuck;
			}
			return this.minLuck;
		}

		this.getFreeWill = function(){
			if(this.crowned){
				return this.freeWill + this.crowned.freeWill;
			}
			return this.freeWill;
		}

		this.getHP= function(){
			if(this.crowned){
				return this.currentHP + this.crowned.hp;  //my hp can be negative. only thing that matters is total is poistive.
			}
			return this.currentHP;
		}
		this.getPower = function(){
			if(this.crowned){
				return this.power + this.crowned.power;
			}
			return this.power;
		}

		this.triggerLevel = function(){
			if(this.crowned){
				return this.triggerLevel + this.crowned.triggerLevel;
			}
			return this.triggerLevel;
		}


		this.setStats = function(minLuck, maxLuck, hp, mobility, triggerLevel, freeWill, power, abscondable, canAbscond, framotifs, grist){
			this.minLuck = minLuck;
			this.hp = hp;
			this.currentHP = this.hp;
			this.mobility = mobility;
			this.maxLuck = maxLuck;
			this.triggerLevel = triggerLevel;
			this.freeWill = freeWill;
			this.power = power;
			this.abscondable = abscondable;
			this.canAbscond = canAbscond;
			this.grist = grist;
		}

		this.htmlTitleHP = function(){
			var ret = "";
			if(this.crowned != null) ret+="Crowned "
			return ret + name +" (" + Math.round(this.getHP()) + " hp, " + Math.round(this.getPower()) + " power)</font>"; //TODO denizens are aspect colored.
		}

		//only the crown itself has this called. king and queen just use the crown.
		this.addPrototyping = function(object){
			this.power += 20;

			if(disastor_prototypings.indexOf(object) != -1) {
				////console.log("disastor prototyping " + this.session.session_id)
				this.power += 200;

			}

			////console.log("todo: prototypings can be associated with plus or minus stats and even fraymotifs (vast glub, anyone)???" )
		}

		//a player will try to flee this fight if they are losing.
		//but if any of their good friends are still around, they will stay.
		//if all players are fled, fight is over.
		//some fights you can't run from. king/queen as example.
		//mobility needs to be high enough. mention if you try to flee and get cut off.
		//if player chooses to abscond, and there are no players left, playersAbscond = true.
		this.willPlayerAbscond = function(div,player,players){
			if(!this.abscondable) return false;
			if(player.doomed) return false; //doomed players accept their fate.
			var reasonsToLeave = 0;
			var reasonsToStay = 1; //grist man.
			reasonsToStay += this.getFriendsFromList(players);
			var hearts = this.getHearts();
			var diamonds = this.getDiamonds();
			for(var i = 0; i<hearts.length; i++){
				if(players.indexOf(hearts[i] != -1)) reasonsToStay ++;  //extra reason to stay if they are your quadrant.
			}
			for(var i = 0; i<diamonds.length; i++){
				if(players.indexOf(diamonds[i] != -1)) reasonsToStay ++;  //extra reason to stay if they are your quadrant.
			}

			reasonsToLeave += 2 * this.power/player.currentHP;  //if you could kill me in two hits, that's one reason to leave. if you could kill me in one, that's two reasons.

			//console.log("reasons to stay: " + reasonsToStay + " reasons to leave: " + reasonsToLeave)
			if(reasonsToLeave > reasonsToStay * 2){
				if(player.mobility > this.mobility){
					//console.log(" player actually absconds: " + this.session.session_id)
					div.append(" The " + player.htmlTitleHP() + " absconds right the fuck out of this fight. ")
					this.playersAbsconded.push(player);
					this.remainingPlayersHateYou(div, player, players);
					return true;
				}else{
					div.append(" The " + player.htmlTitleHP() + " tries to absconds right the fuck out of this fight, but the " + this.htmlTitleHP() + " blocks them. Can't abscond, bro. ")
					return false;
				}
			}else if(reasonsToLeave > reasonsToStay){
				if(player.mobility > this.mobility){
					//console.log(" player actually absconds: " + this.session.session_id)
					div.append(" Shit. The " + player.htmlTitleHP() + " doesn't know what to do. They don't want to die... They abscond. ")
					this.playersAbsconded.push(player);
					this.remainingPlayersHateYou(div, player, players);
					return true;
				}else{
					div.append(" Shit. The " + player.htmlTitleHP() + " doesn't know what to do. THey don't want to die... Before they can decide whether or not to abscond " + this.htmlTitleHP() + " blocks their escape route. Can't abscond, bro. ")
					return false;
				}
			}
			return false;
		}

		this.remainingPlayersHateYou = function(div, player, players){
				if(players.length == 1){
					return null;
				}
				div.append(" The remaining players are not exactly happy to be abandoned. ")
				for(var i = 0; i<players.length; i++){
					var p = players[i];
					if(p != player && this.playersAbsconded.indexOf(p) == -1){ //don't be a hypocrite and hate them if you already ran.
						var r = p.getRelationshipWith(player);
						r.value += -5;
					}
				}
		}

		//denizen and king/queen will never flee. but jack and planned mini bosses can.
		//flee if you are losing. mobility needs to be high enough. mention if you try to flee and get cut off.
		this.willIAbscond= function(div,players,numTurns){
				if(!this.canAbscond || numTurns < 2) return false; //can't even abscond. also, don't run away after starting the fight, asshole.
				var playerPower = 0;
				var living = this.getLivingMinusAbsconded(players)
				for(var i = 0; i<living.length; i++){
					playerPower += living[i].power;
				}
				//console.log("playerPower is: " + playerPower)
				if(playerPower > this.getHP()*2){
						this.iAbscond = true;
						//console.log("absconding when turn number is: " +numTurns);
						return true;
				}
				return false;
		}

		this.processAbscond = function(div,players){
			if(this.iAbscond){
				//console.log("game entity abscond: " + this.session.session_id);
				div.append("The " + this.htmlTitleHP() + " has had enough of this bullshit. They just fucking leave. ");
				return;
			}else{
				//console.log("players abscond: " + this.session.session_id);
				div.append(" The fight is over due to a lack of player presence. ");
				return;
			}

		}


		//before a fight is called, decide who is in it. denizens are one on one, jack catches slower player and friends
		//king/queen are whole party. if you want to comment on who's in it, do it before here.
		//time clones count as players. have "doomed" in their title. that means players have a "doomed" stat.
		//target doomed players preferientially, even over any other algorithm.
		/*
		players can fight, flee (if available) or special. rpg rules, yo.
		fight uses power directly, flee uses mobility.  special is different for differnt players. if you have ghostPacts you can revive or do a ghostAttack, for example.
		need to brainstorm special effects.  hope player have hope field if they are last man standing, for example. some players can make zombies of corpses. only in boss fights.

		enemies can fight, flee (if available) or special.  special varies based on enemy.  denizens can do shit like "echolocataclysm", anything prototyped depends on its
		prototyping. vast glub for horror terror is example.
		*/
		this.strife = function(div, players, numTurns){
			numTurns += 1;
			//console.log(this.name + ": strife! " + numTurns + " turns against: " + getPlayersTitlesNoHTML(players) + this.session.session_id);
			div.append("<br><Br>")
			//as players die or mobility stat changes, might go players, me, me, players or something. double turns.
			if(getAverageMobility(players) > this.getMobility()){ //players turn
				if(!this.fightOverAbscond(div, players) )this.playersTurn(div, players,numTurns);
				if(this.getHP() > 0 && !this.fightOverAbscond(div, players)) this.myTurn(div, players,numTurns);
			}else{ //my turn
				if(this.getHP() > 0 && !this.fightOverAbscond(div,players))  this.myTurn(div, players,numTurns);
				if(!this.fightOverAbscond(div, players) )this.playersTurn(div, players,numTurns);
			}

			if(this.fightOver(div, players) ){
				this.ending(div,players);
				return;
			}else{
				if(this.fightOverAbscond(div,players)){
					 	this.processAbscond(div,players);
						this.ending(div,players);
					 	return;
				}
				return this.strife(div, players,numTurns);
			}
		}

		//if i abscond fight is over
		//if all living players abscond, fight is over
		this.fightOverAbscond = function(div, players){
			//console.log("checking if fight is over beause of abscond " + this.playersAbsconded.length)
			if(this.iAbscond){
				return true;
			}
			if(this.playersAbsconded.length == 0) return false;

			var living = findLivingPlayers(players);
			if(living.length == 0) return false;  //technically, they havent absconded
			for (var i = 0; i<living.length; i++){
				//console.log("has: " + living[i].title() + " run away?")
				if(this.playersAbsconded.indexOf(living[i]) == -1){
					return false; //found living player that hasn't yet absconded.
				}
			}
			return true;

		}

		this.ending = function(div, players){
			this.fraymotifsUsed = []; //not used yet
			this.playersAbsconded = [];
			this.iAbscond = false;
			this.healPlayers(players);
		}


		this.healPlayers = function(players){
			for(var i = 0; i<players.length; i++){
				var player = players[i];
				if(!player.doomed &&  !player.dead && player.currentHP < player.hp) player.currentHP = player.hp;
			}
		}

		this.levelPlayers = function(stabbings){
			for(var i = 0; i<stabbings.length; i++){
				stabbings[i].increasePower();
				stabbings[i].increasePower();
				stabbings[i].increasePower();
				stabbings[i].leveledTheHellUp = true;
				stabbings.level_index +=2;
			}
		}


		this.minorLevelPlayers = function(stabbings){
			for(var i = 0; i<stabbings.length; i++){
				stabbings[i].increasePower();
			}
		}

		this.getLivingMinusAbsconded = function(players){
			var living = findLivingPlayers(players);
			for(var i = 0; i<this.playersAbsconded.length; i++){
				removeFromArray(this.playersAbsconded[i], living);
			}
			return living
		}

		this.fightOver = function(div, players){
			var living = this.getLivingMinusAbsconded(players);
			if(living.length == 0 && players.length > this.playersAbsconded.length){
				if(players.length == 1){
					div.append(" The fight is over. The " + players[0].htmlTitle() + " is dead. ");
				}else{
					div.append(" The fight is over. The players are dead. ");
				}

				this.minorLevelPlayers(players)
				this.ending(div, players)
				return true;
			}else if(this.getHP() <= 0){
				div.append(" <Br><br> The fight is over. " + this.name + " is dead. ");
				this.levelPlayers(players) //even corpses
				this.givePlayersGrist(players);
				this.ending(div, players)
				return true;
			}//TODO have alternate win conditions for denizens???
			return false;
		}

		this.givePlayersGrist = function(players){
			for(var i = 0; i<players.length; i++){
				players.grist += this.grist/players.length;
			}
		}

		this.playersTurn = function(div, players){
			var living = this.getLivingMinusAbsconded(players);
			for(var i = 0; i<living.length; i++){
				if(!living[i].dead && this.getHP()>0 && this.playersAbsconded.indexOf(living[i]) == -1) this.playerdecideWhatToDo(div, living[i],living); //player could have died from a counter attack, boss could have died from previous player
			}

			var dead = findDeadPlayers(players);
			//give dead a chance to autoRevive
			for(var i = 0; i<dead.length; i++){
				if(!dead[i].doomed) this.tryAutoRevive(div, dead[i]);
			}
		}

		this.tryAutoRevive = function(div, deadPlayer){

			//first try using pacts
			var undrainedPacts = removeDrainedGhostsFromPacts(deadPlayer.ghostPacts);
			if(undrainedPacts.length > 0){
				console.log("using a pact to autorevive in session " + this.session.session_id)
				var source = undrainedPacts[0][0];
				source.causeOfDrain = deadPlayer.htmlTitle();
				var ret = " In the afterlife, the " + deadPlayer.htmlTitleBasic() +" reminds the " + source.htmlTitleBasic() + " of their promise of aid. The ghost agrees to donate their life force to return the " + deadPlayer.htmlTitleBasic() + " to life "
				if(deadPlayer.godTier) ret += ", but not before a lot of grumbling and arguing about how the pact shouldn't even be VALID anymore since the player is fucking GODTIER, they are going to revive fucking ANYWAY. But yeah, MAYBE it'd be judged HEROIC or some shit. Fine, they agree to go into a ghost coma or whatever. "
				ret += "It will be a while before the ghost recovers."
				div.append(ret);
				var myGhost = this.session.afterLife.findClosesToRealSelf(deadPlayer)
				removeFromArray(myGhost, this.session.afterLife.ghosts);
				var canvas = drawReviveDead(div, deadPlayer, source, undrainedPacts[0][1]);
				deadPlayer.makeAlive();
			}else if((deadPlayer.aspect == "Doom" || deadPlayer.aspect == "Life")&& (deadPlayer.class_name == "Heir" || deadPlayer.class_name == "Thief")){
				var ghost = this.session.afterLife.findAnyUndrainedGhost();
				var myGhost = this.session.afterLife.findClosesToRealSelf(deadPlayer)
				if(!ghost || ghost == myGhost) return;
				ghost.causeOfDrain = deadPlayer.htmlTitle();

				removeFromArray(myGhost, this.session.afterLife.ghosts);
				if(deadPlayer.class_name  == "Thief" ){
					console.log("thief autorevive in session " + this.session.session_id)
					div.append(" The " + deadPlayer.htmlTitleBasic() + " steals the essence of the " + ghost.htmlTitle() + " in order to revive and keep fighting. It will be a while before the ghost recovers.");
				}else if(deadPlayer.class_name  == "Heir" ){
					console.log("heir autorevive in session " + this.session.session_id)
					div.append(" The " + deadPlayer.htmlTitleBasic() + " inherits the essence and duties of the " + ghost.htmlTitle() + " in order to revive and continue their battle. It will be a while before the ghost recovers.");
				}
				var canvas = drawReviveDead(div, deadPlayer, ghost, deadPlayer.aspect);
				deadPlayer.makeAlive();
			}
		}

		this.playerdecideWhatToDo = function(div, player,players){
			console.log("dear Future JR: seriously don't forget to let maids/rogue heal players, but gotta debug yellow yards now. -pastjr")
			player.power = Math.max(1, player.power); //negative power is not allowed in an actual fight.
			//for now, only one choice    //free will, triggerLevel and canIAbscond adn mobility all effect what is chosen here.  highTrigger level makes aggrieve way more likely and abscond way less likely. lowFreeWill makes special and fraymotif way less likely. mobility effects whether you try to abascond.
			if(!this.willPlayerAbscond(div,player,players)){
				var undrainedPacts = removeDrainedGhostsFromPacts(player.ghostPacts);
				if(undrainedPacts.length > 0 ){
					var didGhostAttack = this.ghostAttack(div, player, getRandomElementFromArray(undrainedPacts)[0]); //maybe later denizen can do ghost attac, but not for now
					if(!didGhostAttack){
						this.aggrieve(div, player, this );
					}
				}else{
					this.aggrieve(div, player, this );
				}
			}
		}

		//only do attack if i don't expect to one shot the enemy
		//return false if i don't do ghsot attack
		this.ghostAttack = function(div, player, ghost){
			if(!ghost) return false;
			if(player.power < this.getHP()){
					console.log("ghost attack in: " + this.session.session_id)
					console.log(ghost);
					ghost.causeOfDrain = player.htmlTitle();
					this.currentHP += -1* ghost.power;
					div.append(" The " + player.htmlTitleBasic() + " cashes in their promise of aid. The ghost of the " + ghost.htmlTitleBasic() + " unleashes an unblockable ghostly attack channeled through the living player. " + ghost.power + " damage is done to " + this.htmlTitleHP() + ". The ghost will need to rest after this for awhile. " );
					if(!this.checkForAPulse(this, player)){

						div.append("The " + this.htmlTitleHP() + " is dead. ");
					}
					this.drawGhostAttack(div, player, ghost);
					return true;
			}
			return false;
		}

		//draw ghost on top of player, ghost lightning.
		this.drawGhostAttack = function(div, player,ghost){
			var canvasId = div.attr("id") + "attack" +player.chatHandle+ghost.chatHandle+player.power+ghost.power
			var canvasHTML = "<br><canvas id='" + canvasId +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvas = document.getElementById(canvasId);
			var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
			drawSprite(pSpriteBuffer,player)
			var gSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
			drawSpriteTurnways(gSpriteBuffer,ghost)



			drawWhatever(canvas, "drain_lightning.png");

			copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,200,0)
			copyTmpCanvasToRealCanvasAtPos(canvas, gSpriteBuffer,200,0)
			var canvasBuffer = getBufferCanvas(document.getElementById("canvas_template"))
			return canvas;
		}



		//doomed players are just easier to target.
		this.chooseTarget=function(players){
			//TODO more likely to get light, less likely to get void
			var living = this.getLivingMinusAbsconded(players);
			var doomed = findDoomedPlayers(living);

			var ret = getRandomElementFromArray(doomed);
			if(ret){
				//console.log("targeting a doomed player.")
				return ret;
			}
			//console.log("targeting slowest player out of: " + living.length)
			return findLowestMobilityPlayer(living);
		}

		//higher the free will, smarter the ai. more likely to do special things.
		this.myTurn = function(div, players,numTurns){
			//console.log("Hp during my turn is: " + this.getHP())
			//free will, triggerLevel and canIAbscond adn mobility all effect what is chosen here.  highTrigger level makes aggrieve way more likely and abscond way less likely. lowFreeWill makes special and fraymotif way less likely. mobility effects whether you try to abascond.
			//special and fraymotif can attack multiple enemies, but aggrieve is one on one.
			if(!this.willIAbscond(div,players,numTurns)){
				var target = this.chooseTarget(players)
				if(target) this.aggrieve(div, this, target );
			}
			////console.log("have special attacks (like using ghost army, or reviving.). have fraymotifs. have prototypes that change stats of ring/scepter and even add fraymotifs.")


		}

		//hopefully either player or gameEntity can call this.
		this.aggrieve=function(div, offense, defense){
			//mobility, luck hp, and power are used here.
			div.append(" The " + offense.htmlTitleHP() + " targets the " +defense.htmlTitleHP() + ". ");
			//luck dodge
			var offenseRoll = offense.rollForLuck();
			var defenseRoll = defense.rollForLuck();
			if(defenseRoll > offenseRoll*10){
				////console.log("Luck counter: " + this.session.session_id);
				div.append("The attack backfires and causes unlucky damage. The " + defense.htmlTitleHP() + " sure is lucky!!!!!!!!" );
				offense.currentHP += -1* offense.power; //damaged by your own power.
				this.checkForAPulse(offense, defense)
				return;
			}else if(defenseRoll > offenseRoll*5){
				////console.log("Luck dodge: " + this.session.session_id);
				div.append("The attack misses completely after an unlucky distraction.");
				return;
			}
			//mobility dodge
			var rand = getRandomInt(1,100) //don't dodge EVERY time. oh god, infinite boss fights. on average, fumble a dodge every 4 turns.
			if(defense.getMobility() > offense.getMobility() * 10 && rand > 25){
				////console.log("Mobility counter: " + this.session.session_id);
				div.append("The " + offense.htmlTitleHP() + " practically appears to be standing still as they clumsily lunge towards the " + defense.htmlTitleHP() + " They miss so hard the " + defense.htmlTitleHP() + " has plenty of time to get a counterattack in." );
				offense.currentHP += -1* defense.power;
				this.checkForAPulse(offense, defense)
				return;
			}else if(defense.getMobility() > offense.getMobility()*5 && rand > 25){
				////console.log("Mobility dodge: " + this.session.session_id);
				div.append(" The " + defense.htmlTitleHP() + " dodges the attack completely. ");
				return;
			}
			//base damage
			var hit = offense.getPower();
			offenseRoll = offense.rollForLuck();
			defenseRoll = defense.rollForLuck();
			//critical/glancing hit odds.
			if(defenseRoll > offenseRoll*2){ //glancing blow.
				////console.log("Glancing Hit: " + this.session.session_id);
				hit = hit/2;
				div.append(" The attack manages to not hit anything too vital. ");
			}else if(offenseRoll > defenseRoll*2){
				////console.log("Critical Hit: " + this.session.session_id);
				hit = hit*2;
				div.append(" Ouch. That's gonna leave a mark. ");
			}else{
				div.append(" A hit! ");
			}


			defense.currentHP += -1* hit;

			if(!this.checkForAPulse(defense, offense)){

				div.append("The " + defense.htmlTitleHP() + " is dead. ");
			}
			if(!this.checkForAPulse(offense, defense)){
				div.append("The " + offense.htmlTitleHP() + " is dead. ");
			}
			offense.interactionEffect(defense); //only players have this. doomed time clones or bosses will do nothing.
		}

		this.makeDead = function(causeOfDeath){
			//does nothing. game entities are assumed to be dead if zero hp
		}

		this.checkForAPulse =function(player, attacker){
			if(player.getHP() <= 0){
				var cod = "fighting the " + attacker.htmlTitleHP();
				if(this.name == "Jack"){
					cod =  "after being shown too many stabs from Jack";
				}else if(this.name == "Black King"){
					cod = "fighting the Black King";
				}
				player.makeDead(cod);

				return false;
			}
			return true;
		}

		this.interactionEffect = function(player){
			//none
		}


		this.rollForLuck = function(){
			return getRandomInt(this.getMinLuck(), this.getMaxLuck());
		}

		//place holders for now. being in diamonds with jack is NOT a core feature.
		this.boostAllRelationshipsWithMeBy = function(amount){

		};

		this.boostAllRelationshipsBy = function(amount){

		};

		this.getFriendsFromList = function(){
			return [];
		}

		this.getHearts = function(){
			return [];
		}
		this.getDiamonds = function(){
			return [];
		}



		//~~~~~~~~~~~~~~~~~~~~~~~~TODO!!!!!!!!!!!!!!!!!!!!!!!  allow doomed time clones to be treated as "players". if they die, add them to afterlife.
}
