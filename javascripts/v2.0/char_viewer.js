var charCreatorHelperGlobalVar;
var playersGlobalVar = [];
var easterEggEngineGlobalVar;
var simulationMode  = false;
window.onload = function() {
	$(this).scrollTop(0);
	loadNavbar();
	loadFuckingEverything(true);



}

function renderPlayersForEditing (){
	easterEggEngineGlobalVar = new CharacterEasterEggEngine();
	easterEggEngineGlobalVar.loadArraysFromFile(callBackForLoadOCsFromFile);
}

//won'te be needed for AB or for simulation because instead of it being like reddit=true, SESSIONS with fan OCS will be generated right here.
//range slider for "number of players", and will auto select that number of players from list (repeats if necessary.)
//check box for "guarantee space/time".
//just generates a URL for the session. that you click right on this page. so only this page needs to load the ocs from file.
function callBackForLoadOCsFromFile(){
	playersGlobalVar = easterEggEngineGlobalVar.processEasterEggsViewer();
	charCreatorHelperGlobalVar = new CharacterCreatorHelper(playersGlobalVar);
	charCreatorHelperGlobalVar.draw12PlayerSummaries();
	console.log("TODO: draw summary of first 12 players, allow pagination, allow searching for chat handle and jumping to page")
}


function draw12(){
	alert("draw 12")
	charCreatorHelperGlobalVar.draw12PlayerSummaries();
}
