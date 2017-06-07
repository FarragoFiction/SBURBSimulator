//loads players from url.  then renders those players, along with their cause of death. if the player is "dead", then mention that they haven't respawned yet, with new cause of death (getting drained by Thief of life, for example.)
var playersGlobalVar = [];
var spriteWidth = 400;
var spriteHeight = 300;
var canvasWidth = 400;
var canvasHeight = 300;
var simulationMode = false;
window.onload = function() {
	loadPlayers();
	if(playersGlobalVar.length > 0){
		load(playersGlobalVar, [], "ghosts");//images
	}else{
		debug("there are no ghosts in this afterlife, dunkass")
	}
}

function renderSingleGhost(ghost,i){
	console.log("rendering ghost")
	var div = $("#afterlifeViewer")
	var html = "<div class = 'eulogy'><div class = 'eulogy_text'>The " + ghost.htmlTitle() + " died " + ghost.causeOfDeath + ".";
	if(ghost.causeOfDrain){
		html += " They were drained to the point of uselessness by the" + ghost.causeOfDrain + ".  They will recover eventually. "
	}
	html +="</div>"
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

function loadPlayers(){
	playersGlobalVar = getReplayers();
	for(var i = 0; i<playersGlobalVar.length; i++){
		playersGlobalVar[i].ghost = true; //not storing that as a bool. 'cause fuck you,thats why'
	}
}

//original version was regexping out #, but i need that for colors. dunkass.  thanks BR for pointing that out. Regexp is...still greek to me.
//oh shit. if 'cause of death' has quotes in it (like, cod = 'fighting the <font color = "">GRIM DARK HEIR OF BREATH</font>' or whatever....)
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

function printCorruptionMessage(msg, url, lineNo, columnNo, error){
	var message = [
            'Message: ' + msg,
            'URL: ' + url,
            'Line: ' + lineNo,
            'Column: ' + columnNo,
            'Error object: ' + JSON.stringify(error)
        ].join(' - ');
	console.log(message);
	var str = "<BR>ERROR: AFTERLIFE CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. LAST ERROR: " + message + " ABORTING."
	$("#afterlifeViewer").append(str);

	$("#afterlifeViewer").append("<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. HORROR TERROR INFLUENCE: COMPLETE.");
	for(var i = 0; i<playersGlobalVar.length; i++){
		var player = playersGlobalVar[i];
		str = "<BR>"+player.chatHandle + ":"
		var rand = ["SAVE US", "GIVE UP", "FIX IT", "HELP US", "WHY?", "OBEY", "CEASE REPRODUCTION", "COWER", "IT KEEPS HAPPENING", "SBURB BROKE US. WE BROKE SBURB.", "I AM THE EMISSARY OF THE NOBLE CIRCLE OF THE HORROR TERRORS."]
		var start = "<b "
		var end = "'>"

		var words = getRandomElementFromArray(rand)
		words = Zalgo.generate(words);
		var plea = start + "style = 'color: " +getColorFromAspect(player.aspect) +"; " + end +str + words+ "</b>"
		//console.log(getColorFromAspect(getRandomElementFromArray(curSessionGlobalVar.players).aspect+";") )
		$("#afterlifeViewer").append(plea);
	}

	for(var i = 0; i<3; i++){
	 $("#afterlifeViewer").append("<BR>...");
	}
	//once I let PLAYERS cause this (through grim darkness or finding their sesions disk or whatever), have different suggested actions.
	//maybe throw custom error?
	$("#afterlifeViewer").append("<BR>SUGGESTED ACTION: " + "FUCK. HOW DID THE AFTERLIFE GET BROKEN? TELL JADEDRESEARCHER TO FIX THIS. TELL THEM THE SESSION ID THIS AFTERLIFE CAME FROM.");

	return false; //if i return true here, the real error doesn't show up

}
window.onerror = printCorruptionMessage;
