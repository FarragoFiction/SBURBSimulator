//how AuthorBot summarizes a session
//eventually moon prophecies will use this.
//a prophecy can be any of these values that don't match the values in the current session summary.
function SessionSummary(){
	this.session_id = null;
	this.num_scenes = null;
	this.player = null;  //can ask for sessions with a blood player and a murder mode, for example
	this.mvp = null;
	this.scratchAvailable = null;
	this.parentSession = null;
	this.yellowYard = null;
	this.numLiving = null;
	this.numDead = null;
	this.ectobiologyStarted = null;
	this.denizenFought = null;
	this.plannedToExileJack = null;
	this.exiledJack = null;
	this.exiledQueen = null;
	this.jackGotWeapon = null;
	this.jackPromoted = null;
	this.jackRampage = null;
	this.jackScheme = null;
	this.kingPowerful = null;
	this.queenRejectRing = null;
	this.democracyStarted = null;
	this.murderMode = null;
	this.grimDark = null;
	this.frogLevel = null;
	this.hasDiamonds = null;
	this.hasSpades = null;
	this.hasClubs = null;
	this.hasHearts = null;
	
	//generate own html, complete with div.  just return it, dn't add it to anything
	this.generateHTML = function(){
		var html = "<div class = 'sessionSummary' id = 'summarizeSession" + this.session_id +"'>";
		html += "<br>TODO TODO TODO<br>"
		
		html += "</div>"
	}
	
}


function MultiSessionSummary(){
	this.scratchAvailable = 0;
	this.yellowYard = 0;
	this.numAllLiving = 0;
	this.numAllDead = 0;
	this.ectobiologyStarted = 0;
	this.denizenFought = 0;
	this.plannedToExileJack = 0;
	this.exiledJack = 0;
	this.exiledQueen = 0;
	this.jackGotWeapon = 0;
	this.jackPromoted = 0;
	this.jackRampage = 0;
	this.jackScheme = 0;
	this.kingPowerful = 0;
	this.queenRejectRing = 0;
	this.democracyStarted = 0;
	this.murderMode = 0;
	this.grimDark = 0;
	this.hasDiamonds = 0;
	this.hasSpades = 0;
	this.hasClubs = 0;
	this.hasHearts = 0;
}


function collateMultipleSessionSummaries(sessionSummaries){
	var mss = new MultiSessionSummary();
	for(var i = 0; i<sessionSummaries.length; i++){
		var ss = sessionSummaries[i];
		if(ss.scratchAvailable) mss.scratchAvailable ++;
		if(ss.yellowYard) mss.yellowYard ++;
		if(ss.numLiving == 0) mss.numAllDead ++;
		if(ss.numDead == 0) mss.numAllLiving ++;
		if(ss.ectobiologyStarted) mss.ectobiologyStarted ++;
		if(ss.denizenFought) mss.denizenFought ++;
		if(ss.plannedToExileJack) mss.plannedToExileJack ++;
		if(ss.exiledJack) mss.exiledJack ++;
		if(ss.exiledQueen) mss.exiledQueen ++;
		if(ss.jackGotWeapon) mss.jackGotWeapon ++;
		if(ss.jackPromoted) mss.jackPromoted ++;
		if(ss.jackRampage) mss.jackRampage ++;
		if(ss.jackScheme) mss.jackScheme ++;
		if(ss.kingPowerful) mss.kingPowerful ++;
		if(ss.queenRejectRing) mss.queenRejectRing ++;
		if(ss.democracyStarted) mss.democracyStarted ++;
		if(ss.murderMode) mss.murderMode ++;
		if(ss.grimDark) mss.grimDark ++;
		if(ss.hasDiamonds) mss.hasDiamonds ++;
		if(ss.hasSpades) mss.hasSpades ++;
		if(ss.hasClubs) mss.hasClubs ++;
		if(ss.hasHearts) mss.hasHearts ++;
	}
	return mss;
}