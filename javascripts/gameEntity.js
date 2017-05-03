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


		this.setStats = function(minLuck, maxLuck, hp, mobility, triggerLevel, freeWill, power, abscondable, canAbscond, framotifs){
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
		}

		this.htmlTitleHP = function(){
			var ret = "";
			if(this.crowned != null) ret+="Crowned "
			return ret + name +" ( " + Math.round(this.getHP()) + ")"; //TODO denizens are aspect colored.
		}

		//only the crown itself has this called. king and queen just use the crown.
		this.addPrototyping = function(object){
			this.power += 20;

			if(disastor_prototypings.indexOf(object) != -1) {
				//console.log("disastor prototyping " + this.session.session_id)
				this.power += 200;

			}

			//console.log("todo: prototypings can be associated with plus or minus stats and even fraymotifs (vast glub, anyone)???" )
		}

		//a player will try to flee this fight if they are losing.
		//but if any of their good friends are still around, they will stay.
		//if all players are fled, fight is over.
		//some fights you can't run from. king/queen as example.
		//mobility needs to be high enough. mention if you try to flee and get cut off.
		this.willPlayerAbscond = function(player){

		}

		//denizen and king/queen will never flee. but jack and planned mini bosses can.
		//flee if you are losing. mobility needs to be high enough. mention if you try to flee and get cut off.
		this.willIAbscond= function(){

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
			console.log(this.name + ": strife! " + numTurns + " " + this.session.session_id);
			div.append("<br><Br>")
			//as players die or mobility stat changes, might go players, me, me, players or something. double turns.
			if(getAverageMobility(players) > this.getMobility()){ //players turn
				this.playersTurn(div, players);
				if(this.getHP() > 0) this.myTurn(div, players);
			}else{ //my turn
				if(this.getHP() > 0)  this.myTurn(div, players);
				this.playersTurn(div, players);
			}
			if(this.fightOver(div, players)){
				return;
			}else{
				return this.strife(div, players,numTurns);
			}
		}

		this.ending = function(div, players){
			this.fraymotifsUsed = []; //not used yet
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

		this.fightOver = function(div, players){
			var living = findLivingPlayers(players);
			if(living.length == 0){
				if(players.length == 1){
					div.append(" The fight is over. The " + players[0].htmlTitle() + " is dead. ");
				}else{
					div.append(" The fight is over. The players are dead. ");
				}

				this.minorLevelPlayers(players)
				this.ending();
				this.ending(div, players)
				return true;
			}else if(this.getHP() <= 0){
				div.append(" <Br><br> The fight is over. " + this.name + " is dead. ");
				this.levelPlayers(players) //even corpses
				this.ending();
				this.ending(div, players)
				return true;
			}//TODO have alternate win conditions for denizens???
			return false;
		}


		this.playersTurn = function(div, players){
			var living = findLivingPlayers(players);
			for(var i = 0; i<living.length; i++){
				if(!living[i].dead && this.getHP()>0) this.playerdecideWhatToDo(div, living[i]); //player could have died from a counter attack, boss could have died from previous player
			}
		}

		this.playerdecideWhatToDo = function(div, player){
			player.power = Math.max(1, player.power); //negative power is not allowed in an actual fight.
			//for now, only one choice    //free will, triggerLevel and canIAbscond adn mobility all effect what is chosen here.  highTrigger level makes aggrieve way more likely and abscond way less likely. lowFreeWill makes special and fraymotif way less likely. mobility effects whether you try to abascond.
			this.aggrieve(div, player, this );
		}

		//doomed players are just easier to target.
		this.chooseTarget=function(players){
			//TODO more likely to get light, less likely to get void
			var living = findLivingPlayers(players);
			var doomed = findDoomedPlayers(living);
			var ret = getRandomElementFromArray(doomed);
			if(ret){
				console.log("targeting a doomed player.")
				return ret;
			}
			console.log("targeting slowest player out of: " + living.length)
			return findLowestMobilityPlayer(living);
		}

		//higher the free will, smarter the ai. more likely to do special things.
		this.myTurn = function(div, players){
			//free will, triggerLevel and canIAbscond adn mobility all effect what is chosen here.  highTrigger level makes aggrieve way more likely and abscond way less likely. lowFreeWill makes special and fraymotif way less likely. mobility effects whether you try to abascond.
			//special and fraymotif can attack multiple enemies, but aggrieve is one on one.

			//for now, only one choice
			var target = this.chooseTarget(players)
			if(target) this.aggrieve(div, this, target );
			//console.log("have special attacks (like using ghost army, or reviving.). have fraymotifs. have prototypes that change stats of ring/scepter and even add fraymotifs.")


		}

		//hopefully either player or gameEntity can call this.
		this.aggrieve=function(div, offense, defense){
			//mobility, luck hp, and power are used here.
			div.append(" The " + offense.htmlTitleHP() + " targets the " +defense.htmlTitleHP() + ". ");
			//luck dodge
			var offenseRoll = offense.rollForLuck();
			var defenseRoll = defense.rollForLuck();
			if(defenseRoll > offenseRoll*10){
				//console.log("Luck counter: " + this.session.session_id);
				div.append("The attack backfires and causes unlucky damage. The " + defense.htmlTitleHP() + " sure is lucky!!!!!!!!" );
				offense.currentHP += -1* offense.power; //damaged by your own power.
				this.checkForAPulse(offense, defense)
				return;
			}else if(defenseRoll > offenseRoll*5){
				//console.log("Luck dodge: " + this.session.session_id);
				div.append("The attack misses completely after an unlucky distraction.");
				return;
			}
			//mobility dodge
			var rand = getRandomInt(1,100) //don't dodge EVERY time. oh god, infinite boss fights. on average, fumble a dodge every 4 turns.
			if(defense.getMobility() > offense.getMobility() * 10 && rand > 25){
				//console.log("Mobility counter: " + this.session.session_id);
				div.append("The " + offense.htmlTitleHP() + " practically appears to be standing still as they clumsily lunge towards the " + defense.htmlTitleHP() + " They miss so hard the " + defense.htmlTitleHP() + " has plenty of time to get a counterattack in." );
				offense.currentHP += -1* defense.power;
				this.checkForAPulse(offense, defense)
				return;
			}else if(defense.getMobility() > offense.getMobility()*5 && rand > 25){
				//console.log("Mobility dodge: " + this.session.session_id);
				div.append(" The " + defense.htmlTitleHP() + " dodges the attack completely. ");
				return;
			}
			//base damage
			var hit = offense.getPower();
			offenseRoll = offense.rollForLuck();
			defenseRoll = defense.rollForLuck();
			//critical/glancing hit odds.
			if(defenseRoll > offenseRoll*2){ //glancing blow.
				//console.log("Glancing Hit: " + this.session.session_id);
				hit = hit/2;
				div.append(" The attack manages to not hit anything too vital. ");
			}else if(offenseRoll > defenseRoll*2){
				//console.log("Critical Hit: " + this.session.session_id);
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



		//~~~~~~~~~~~~~~~~~~~~~~~~TODO!!!!!!!!!!!!!!!!!!!!!!!  allow doomed time clones to be treated as "players". if they die, add them to afterlife.
}
