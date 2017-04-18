//not a player, but more than just a session stat.
//Game entities have HP, luck, even relationship options (though only pale and ashen.)
//maybe time clones are this? sprites?
//definitely jack/queen/jing, tho
//the mayor?
function GameEntity(session){
		this.session = session;
		this.minLuck = 0;
		this.maxLuck = 0;
		this.relationships = [];
		this.power = 0;
		this.dead = false;
		this.landLevel  = 100; //use this instead of hp so thief of life can steal from you?
}
