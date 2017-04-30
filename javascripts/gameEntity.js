//jack/queen/king/denizen.
//multiround, but only takes 1 tick.
//when call fight method, pass in array of players. only those players are involved in fight.
//whoever calls fight is reponsible for high mobility players to be more likely in a fight.
//should use ALL stats. luck, mobility, freeWill, raw power, relationships, etc. Hope powered up by how screwed things are, for example. (number of corpses, lack of Ecto lack of frog, etc. ).
//denizens have a particular stat that won't matter. Can't beat Cetus in a Luck-Off, she is simply the best there is, for example.
//before I decide boss stats, need to have AB compile me a list of average player stats. She's getting kinda...busy though. maybe a secret extra area? same page, but on bottom?
function GameEntity(session, name){
		this.session = session;
		this.name = name;
		//if any stat is -1025, it's considered to be infinitie. denizens use. you can't outluck Cetus, she is simply the best there is.
		this.minLuck = 0;
		this.hp = 0;  //what does infinite hp mean? you need to defeat them some other way. alternate win conditions? or can you only do The Choice?
		this.mobility = 0;
		this.maxLuck = 0;
		this.triggerLevel; //both players and enemy can be too freaked out or beserk to fight right
		this.freeWill = 0; //jack has extremely high free will. why he is such a wild card
		this.relationships = [];
		this.power = 0;
		this.dead = false;
		this.escapeable = true;
		this.canFlee = true;

		//each prototype increases base power. some prototypes also modify other stats. have arrays just like fortune/disastor prototypings.
		//if it's a player...copy all player stats?
		this.addPrototype = function(object){

		}

		//if jack gets the queen rings, her stats are added onto his.
		this.addStatsFromObject = function(object){

		}

		//a player will try to flee this fight if they are losing.
		//but if any of their good friends are still around, they will stay.
		//if all players are fled, fight is over.
		//some fights you can't run from. king/queen as example.
		//mobility needs to be high enough. mention if you try to flee and get cut off.
		this.willPlayerFlee = function(player){

		}

		//denizen and king/queen will never flee. but jack and planned mini bosses can.
		//flee if you are losing. mobility needs to be high enough. mention if you try to flee and get cut off.
		this.willIFlee= function(){

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
		this.fight = function(div, players){
				//a fight is involved. mutiple things happen before this finally returns. keep going until one side is all dead, or fled.
		}


		//some denizens have infinitei HP. what does this mean? how are you supposed to beat them?
		this.winConditionMet = function(){

		}



		//place holders for now. being in diamonds with jack is NOT a core feature.
		this.boostAllRelationshipsWithMeBy = function(amount){

		};

		this.boostAllRelationshipsBy = function(amount){

		};



		//~~~~~~~~~~~~~~~~~~~~~~~~TODO!!!!!!!!!!!!!!!!!!!!!!!  allow doomed time clones to be treated as "players". if they die, add them to afterlife.
}
