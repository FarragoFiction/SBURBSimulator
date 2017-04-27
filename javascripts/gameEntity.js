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
		this.minLuck = 0;
		this.maxLuck = 0;
		this.relationships = [];
		this.power = 0;
		this.dead = false;
		this.landLevel  = 100; //use this instead of hp so thief of life can steal from you?


		//place holders for now. being in diamonds with jack is NOT a core feature.
		this.boostAllRelationshipsWithMeBy = function(amount){

		};
		this.boostAllRelationshipsBy = function(amount){

		};
		
		//~~~~~~~~~~~~~~~~~~~~~~~~TODO!!!!!!!!!!!!!!!!!!!!!!!  allow doomed time clones to be treated as "players". if they die, add them to graveyard.
}
