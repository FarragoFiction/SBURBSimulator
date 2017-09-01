/*TODO make this work

//loads players from url.  then renders those players, along with their cause of death. if the player is "dead", then mention that they haven't respawned yet, with new cause of death (getting drained by Thief of life, for example.)
List<dynamic> playersGlobalVar = [];
num spriteWidth = 400;
num spriteHeight = 300;
num canvasWidth = 400;
num canvasHeight = 300;
bool simulationMode = false;
window.onload = () {
	loadPlayers();
	if(playersGlobalVar.length > 0){
		load(playersGlobalVar, [], "ghosts");//images
	}else{
		debug("there are no ghosts in this afterlife, dunkass");
	}
}

void renderSingleGhost(ghost, i){
	//print("rendering ghost");
	var div = querySelector("#afterlifeViewer");
	String html = "<div class = 'eulogy'><div class = 'eulogy_text'>The " + ghost.htmlTitle() + " died " + ghost.causeOfDeath + ".";
	if(ghost.causeOfDrain){
		html += " They were drained to the point of uselessness by the" + ghost.causeOfDrain + ".  They will recover eventually. ";
	}
	html +="</div>";
	String divID = "Eulogy" + i;
	html += "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas></div>";
	div.append(html);
	var canvas = querySelector("#canvas"+ divID);

	var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawSprite(pSpriteBuffer,ghost);

	copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0);

}



void renderGhosts(){
	for(num i = 0; i< playersGlobalVar.length; i++){
		renderSingleGhost(playersGlobalVar[i], i);
	}
}



void loadPlayers(){
	playersGlobalVar = getReplayers();
	for(num i = 0; i<playersGlobalVar.length; i++){
		playersGlobalVar[i].ghost = true; //not storing that as a bool. 'cause fuck you,thats why'
	}
}



//original version was regexping out #, but i need that for colors. dunkass.  thanks BR for pointing that out. Regexp is...still greek to me.
//oh shit. if 'cause of death' has quotes in it (like, cod = 'fighting the <font color = "">GRIM DARK HEIR OF BREATH</font>' or whatever....)
function getParameterByName(name, url) {
    if (!url) {
      url = window.location.href;
    }
    name = name.replace(new RegExp(r"""[\[\]]""", multiLine:true), "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&]*)|&||$)"),;
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return (results[2].replace(new RegExp(r"""\+""", multiLine:true), " "));
}

bool printCorruptionMessage(msg, url, lineNo, columnNo, error){
	var message = [;
            'Message: ' + msg,
            'URL: ' + url,
            'Line: ' + lineNo,
            'Column: ' + columnNo,
            'Error object: ' + JSON.stringify(error);
        ].join(' - ');
	//print(message);
	String str = "<BR>ERROR: AFTERLIFE CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. LAST ERROR: " + message + " ABORTING.";
	querySelector("#afterlifeViewer").append(str);

	querySelector("#afterlifeViewer").append("<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. HORROR TERROR INFLUENCE: COMPLETE.");
	for(num i = 0; i<playersGlobalVar.length; i++){
		var player = playersGlobalVar[i];
		str = "<BR>"+player.chatHandle + ":";
		var rand = ["SAVE US", "GIVE UP", "FIX IT", "HELP US", "WHY?", "OBEY", "CEASE REPRODUCTION", "COWER", "IT KEEPS HAPPENING", "SBURB BROKE US. WE BROKE SBURB.", "I AM THE EMISSARY OF THE NOBLE CIRCLE OF THE HORROR TERRORS."];
		String start = "<b ";
		String end = "'>";

		var words = rand.pickFrom(rand);
		words = Zalgo.generate(words);
		var plea = start + "style = 'color: " +getColorFromAspect(player.aspect) +"; " + end +str + words+ "</b>"
		////print(getColorFromAspect(rand.pickFrom(curSessionGlobalVar.players).aspect+";") )
		querySelector("#afterlifeViewer").append(plea);
	}

	for(int i = 0; i<3; i++){
	 querySelector("#afterlifeViewer").append("<BR>...");
	}
	//once I let PLAYERS cause this (through grim darkness or finding their sesions disk or whatever), have different suggested actions.
	//maybe throw custom error?
	querySelector("#afterlifeViewer").append("<BR>SUGGESTED ACTION: " + "FUCK. HOW DID THE AFTERLIFE GET BROKEN? TELL JADEDRESEARCHER TO FIX THIS. TELL THEM THE SESSION ID THIS AFTERLIFE CAME FROM.");

	return false; //if i return true here, the real error doesn't show up;

}
window.onerror = printCorruptionMessage;
*/