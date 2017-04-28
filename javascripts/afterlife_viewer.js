//loads players from url.  then renders those players, along with their cause of death. if the player is "dead", then mention that they haven't respawned yet, with new cause of death (getting drained by Thief of life, for example.)
var playersGlobalVar = [];
var spriteWidth = 400;
var spriteHeight = 300;
var canvasWidth = 400;
var canvasHeight = 300;
var simulationMode = false;
window.onload = function() {
	var p = getParameterByName("players")
	if(p){
		loadPlayers(p);
		load(playersGlobalVar, [], "ghosts");//images
	}else{
		debug("there are no ghosts in this afterlife, dunkass")
	}
}

function renderSingleGhost(ghost,i){
	console.log("rendering ghost")
	var div = $("#story")
	var html = "<div class = 'eulogy'>The " + ghost.htmlTitle() + " died " + ghost.causeOfDeath + ".";
	var divID = "Eulogy" + i;
	html += "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas></div>";
	div.append(html);
	var canvas = document.getElementById("canvas"+ divID);

	var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
	drawSprite(pSpriteBuffer,ghost)

	copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0)

}

function renderGhosts(){
	for(var i = 0; i< playersGlobalVar.length; i++){
		renderSingleGhost(playersGlobalVar[i], i);
	}
}

function loadPlayers(p){
	var decodedPlayers = decodeURI(p);
 	var json = JSON.parse(decodedPlayers);
	for(var i = 0; i<json.length; i++){
		playersGlobalVar.push(objToPlayer(json[i]));
	}
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
