var charCreatorHelperGlobalVar;
var playersGlobalVar = [];
var easterEggEngineGlobalVar;
var simulationMode  = false;
window.onload = function() {
	$(this).scrollTop(0);
	loadNavbar();
	//charCreatorHelperGlobalVar = new CharacterCreatorHelper(curSessionGlobalVar.players);
	easterEggEngineGlobalVar = new CharacterEasterEggEngine();
	playersGlobalVar = easterEggEngineGlobalVar.processEasterEggsViewer();
	charCreatorHelperGlobalVar = new CharacterCreatorHelper(playersGlobalVar);
	charCreatorHelperGlobalVar.drawAllPlayerSummaries();
	console.log("TODO: draw summary of first 12 players, allow pagination, allow searching for chat handle and jumping to page")
}