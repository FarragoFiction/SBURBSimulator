//how AuthorBot summarizes a session
//eventually moon prophecies will use this.
//a prophecy can be any of these values that don't match the values in the current session summary.
function SessionSummary(){
	this.session_id = null;
	this.num_scenes = null;
	this.players = null;  //can ask for sessions with a blood player and a murder mode, for example
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
	this.kingTooPowerful = null;
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
		console.log("add combo session stat")
		var html = "<div class = 'sessionSummary' id = 'summarizeSession" + this.session_id +"'>";
		for(var propertyName in this) {
				if(propertyName == "players"){
					html += "<Br><b>" + propertyName + "</b>: " + getPlayersTitlesBasic(this.players);
				}else if(propertyName == "mvp"){
					html += "<Br><b>" + propertyName + "</b>: " + this.mvp.htmlTitleBasic() + " With a Power of: " + this.mvp.power;
				}else if(propertyName == "session_id"){
					html += "<Br><b> Session</b>: <a href = 'index2.html?seed=" + this.session_id + "'>" +this.session_id + "</a>" 
				}else if(propertyName != "generateHTML"){
					html += "<Br><b>" + propertyName + "</b>: " + this[propertyName] ;
				}
		}
		
		html += "</div><br>"
		return html;
	}
	
}


function MultiSessionSummary(){
	this.total = 0;
	this.scratchAvailable = 0;
	this.yellowYard = 0;
	this.timesAllLived = 0;
	this.timesAllDied = 0;
	this.ectobiologyStarted = 0;
	this.denizenFought = 0;
	this.plannedToExileJack = 0;
	this.exiledJack = 0;
	this.exiledQueen = 0;
	this.jackGotWeapon = 0;
	this.jackPromoted = 0;
	this.jackRampage = 0;
	this.jackScheme = 0;
	this.kingTooPowerful = 0;
	this.queenRejectRing = 0;
	this.democracyStarted = 0;
	this.murderMode = 0;
	this.grimDark = 0;
	this.hasDiamonds = 0;
	this.hasSpades = 0;
	this.hasClubs = 0;
	this.hasHearts = 0;
	
	this.generateHTML = function(){
		var html = "<div class = 'multiSessionSummary' id = 'multiSessionSummary'>";
		var header = "<h2>Stats for All Displayed Sessions:</h2>"
		html += header;
		//http://stackoverflow.com/questions/85992/how-do-i-enumerate-the-properties-of-a-javascript-object
		for(var propertyName in this) {
				if(propertyName != "generateHTML"){
					html += "<Br><b>" + propertyName + "</b>: " + this[propertyName] ;
					html += " (" + Math.round(100* (this[propertyName]/this.total)) + "%)";
				}
		}
		
		html += "</div><Br>"
		return html;
	}

}


function collateMultipleSessionSummaries(sessionSummaries){
	var mss = new MultiSessionSummary();
	for(var i = 0; i<sessionSummaries.length; i++){
		var ss = sessionSummaries[i];
		mss.total ++;
		if(ss.scratchAvailable) mss.scratchAvailable ++;
		if(ss.yellowYard) mss.yellowYard ++;
		if(ss.numLiving == 0) mss.timesAllDied ++;
		if(ss.numDead == 0) mss.timesAllLived ++;
		if(ss.ectobiologyStarted) mss.ectobiologyStarted ++;
		if(ss.denizenFought) mss.denizenFought ++;
		if(ss.plannedToExileJack) mss.plannedToExileJack ++;
		if(ss.exiledJack) mss.exiledJack ++;
		if(ss.exiledQueen) mss.exiledQueen ++;
		if(ss.jackGotWeapon) mss.jackGotWeapon ++;
		if(ss.jackPromoted) mss.jackPromoted ++;
		if(ss.jackRampage) mss.jackRampage ++;
		if(ss.jackScheme) mss.jackScheme ++;
		if(ss.kingTooPowerful) mss.kingTooPowerful ++;
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