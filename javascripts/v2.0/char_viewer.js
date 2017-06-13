var charCreatorHelperGlobalVar;
var playersGlobalVar = [];
var easterEggEngineGlobalVar;
window.onload = function() {
	$(this).scrollTop(0);
	loadNavbar();
	//charCreatorHelperGlobalVar = new CharacterCreatorHelper(curSessionGlobalVar.players);
	easterEggEngineGlobalVar = new CharacterEasterEggEngine();
	playersGlobalVar = easterEggEngineGlobalVar.processEasterEggsViewer();
	console.log("TODO: draw summary of first 12 players, allow pagination, allow searching for chat handle and jumping to page")
}