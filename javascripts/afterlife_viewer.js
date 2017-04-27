//loads players from url.  then renders those players, along with their cause of death. if the player is "dead", then mention that they haven't respawned yet, with new cause of death (getting drained by Thief of life, for example.)
var playersGlobalVar = [];
window.onload = function() {
	var p = getParameterByName("players")
	if(p){
		loadPlayers(p);
	}else{
		debug("there are no ghosts in this afterlife, dunkass")
	}
}

function loadPlayers(p){
	var decodedPlayers = decodeURI(p);
 	var json = JSON.parse(decodedPlayers);
	for(var i = 0; i<json.length; i++){
		playersGlobalVar.push(objToPlayer(json[i]));
	}
	debug(playersGlobalVar[0].title())
}

//original version was regexping out #, but i need that for colors. dunkass.  thanks BR for pointing that out. Regexp is...still greek to me.
function getParameterByName(name, url) {
    if (!url) {
      url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&]*)|&||$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return (results[2].replace(/\+/g, " "));
}
