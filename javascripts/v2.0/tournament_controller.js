var charCreatorHelperGlobalVar;
var playersGlobalVar = [];
var easterEggEngineGlobalVar;
var simulationMode  = false;
window.onload = function() {
	$(this).scrollTop(0);
	loadNavbar();
	renderHeader();
	var params = window.location.href.substr(window.location.href.indexOf("?")+1)
	if (params == window.location.href) params = ""
	$("#character_creator").append("<a target='_blank' href = 'index2.html?selfInsertOC=true&" + params + "'>Send Random Fan OCs From This Category Into SBURB?</a> &nbsp &nbsp &nbsp<a target='_blank' href = 'rare_session_finder.html?selfInsertOC=true&" + params + "'>AB Report For Fan OCs From This Category</a><Br><Br><Br>");
	loadFuckingEverything(true);



}
