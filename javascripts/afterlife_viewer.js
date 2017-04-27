//loads players from url.  then renders those players, along with their cause of death. if the player is "dead", then mention that they haven't respawned yet, with new cause of death (getting drained by Thief of life, for example.)
var playersGlobalVar = [];
window.onload = function() {
	loadPlayers();
}

function loadPlayers(){
	var decodedPlayers = decodeURI(getParameterByName("players"));
	var json = JSON.parse(decodedPlayers);
	for(var i = 0; i<json.length; i++){
		playersGlobalVar.push(objToPlayer(json[i]));
	}
}