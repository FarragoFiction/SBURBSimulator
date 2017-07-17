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

function renderHeader(){
	var header = ""
	if(getParameterByName("reddit")  == "true") header += " reddit"
	if(getParameterByName("tumblr")  == "true") header += " tumblr"
	if(getParameterByName("discord")  == "true") header += " discord"
	if(getParameterByName("creditsBuckaroos")  == "true") header += " creditsBuckaroos"
	if(getParameterByName("ideasWranglers")  == "true") header += " ideasWranglers"
	if(getParameterByName("patrons")  == "true") header += " patrons"
	if(getParameterByName("patrons2")  == "true") header += " patrons2"
	if(getParameterByName("patrons3")  == "true") header += " patrons3"
	if(getParameterByName("canon")  == "true") header += " canon"
	if(getParameterByName("otherFandoms")  == "true") header += " otherFandoms"
	if(getParameterByName("creators")  == "true") header += " creators"
	if(getParameterByName("bards")  == "true") header += " bards<span class='void'>Not gonna lie, gonna add a secret boss for each one of these assholes</span>"
	header += ""
	if(header!= "" ) $("#header").html(header);

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
	charCreatorHelperGlobalVar.draw12PlayerSummaries();
}
