//not a player, but more than just a session stat.
//Game entities have HP, luck, even relationship options (though only pale and ashen.)
//maybe time clones are this? sprites?
//definitely jack/queen/jing, tho
//the mayor?
//don't want to just add luck to jack/queen/keen fights. refactoring everything. back to multi-round fights and all.
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
}
