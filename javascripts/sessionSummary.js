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
	this.ectoBiologyStarted = null;
	this.denizenFought = null;
	this.denizenBeat = null;
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
	//set when generatingHTML
	this.threeTimesSessionCombo = false;
	this.fourTimesSessionCombo = false;
	this.fiveTimesSessionCombo = false;
	this.holyShitMmmmmonsterCombo = false;
	this.frogStatus = null;
	this.godTier = false;
	this.questBed = false;
	this.sacrificialSlab = false;

	//thanks to bob for helping me puzzle out the logic to make filters AND not OR.
	//why was that so hard???
	this.satifies_filter_array = function(filter_array){
		//console.log(filter_array)
		for(var i = 0; i< filter_array.length; i++){
			var filter = filter_array[i];

			if(filter == "numberNoFrog"){
				if(this.frogStatus  != "No Frog"){
				//	console.log("not no frog")
					return false;
				}
			}else if(filter == "numberSickFrog"){
				if(this.frogStatus  != "Sick Frog"){
					//console.log("not sick frog")
					return false;
				}
			}else if(filter == "numberFullFrog"){
				if(this.frogStatus  != "Full Frog"){
					//console.log("not full frog")
					return false;
				}
			}else if(filter == "timesAllDied"){
				if(this.numLiving != 0){
					//console.log("not all dead")
					return false;
				}
			}else if(filter == "timesAllLived"){
				if(this.numDead != 0){  //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want that.
					//console.log("not all alive")
					return false;
				}

			}else if(filter == "comboSessions"){
				if(!this.parentSession){  //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want that.
					//console.log("not combo session")
					return false;
				}

			}else if(!this[filter]){
				//console.log("property not true: " + filter)
				return false;
			}
		}
		//console.log("i pass all filters")
		return true;
	}

	this.decodeLineageGenerateHTML = function(){
			var html = "";
			var lineage = this.parentSession.getLineage(); //i am not a session so remember to tack myself on at the end.
			html += "<Br><b> Session</b>: <a href = 'index2.html?seed=" + lineage[0].session_id + "'>" +lineage[0].session_id + "</a> "
			for(var i = 1; i< lineage.length; i++){
				html += " combined with: " + "<a href = 'index2.html?seed=" + lineage[i].session_id + "'>" +lineage[i].session_id + "</a> "
			}
			html += " combined with: " + "<a href = 'index2.html?seed=" + this.session_id + "'>" +this.session_id + "</a> "
			if((lineage.length +1) == 3){
				this.threeTimesSessionCombo = true;
				html += " 3x SESSIONS COMBO!!!"
			}
			if((lineage.length +1) == 4){
				this.fourTimesSessionCombo = true;
				html += " 4x SESSIONS COMBO!!!!"
			}
			if((lineage.length +1 ) ==5){
				this.fiveTimesSessionCombo = true;
				html += " 5x SESSIONS COMBO!!!!!"
			}
			if((lineage.length +1) > 5){
				this.holyShitMmmmmonsterCombo = true;
				html += " The session pile doesn't stop from getting taller. "
			}
			return html;

	}
	
	this.getSessionSummaryJunior = function(){
		return new SessionSummaryJunior(this.players);
	}
	
	

	//generate own html, complete with div.  just return it, dn't add it to anything
	this.generateHTML = function(){
		var html = "<div class = 'sessionSummary' id = 'summarizeSession" + this.session_id +"'>";
		for(var propertyName in this) {
				if(propertyName == "players"){
					html += "<Br><b>" + propertyName + "</b>: " + getPlayersTitlesBasic(this.players);
				}else if(propertyName == "mvp"){
					html += "<Br><b>" + propertyName + "</b>: " + this.mvp.htmlTitle() + " With a Power of: " + this.mvp.power;
				}else if(propertyName == "frogLevel"){
					html += "<Br><b>" + propertyName + "</b>: " + this.frogLevel + " (" + this.frogStatus +")";
				}else if(propertyName == "session_id"){
					if(this.parentSession){
						html += this.decodeLineageGenerateHTML();
					}else{
						html += "<Br><b> Session</b>: <a href = 'index2.html?seed=" + this.session_id + "'>" +this.session_id + "</a>"
					}
				}else if(propertyName == "satifies_filter_array" || propertyName == "frogStatus" || propertyName == "decodeLineageGenerateHTML"|| propertyName == "threeTimesSessionCombo" || propertyName == "fourTimesSessionCombo"  || propertyName == "fiveTimesSessionCombo"  || propertyName == "holyShitMmmmmonsterCombo"  || propertyName != "getSessionSummaryJunior" ){
					//do nothing. properties used elsewhere.
				}else if(propertyName != "generateHTML"){
					html += "<Br><b>" + propertyName + "</b>: " + this[propertyName] ;
				}
		}

		html += "</div><br>"
		return html;
	}

}

//junior only cares about players.
function SessionSummaryJunior(players){
	this.players = players;
	this.generateHTML = function(){
		var html = "<div class = 'sessionSummary' id = 'summarizeSession" + this.session_id +"'>";
		html += "<Br><b>Players</b>: " + getPlayersTitlesBasic(this.players);
		html += "</div><br>"
		return html;
	}
}


function MultiSessionSummary(){
	this.total = 0;
	this.totalDeadPlayers = 0;
	this.scratchAvailable = 0;
	this.yellowYard = 0;
	this.timesAllLived = 0;
	this.timesAllDied = 0;
	this.ectoBiologyStarted = 0;
	this.denizenFought = 0;
	this.denizenBeat = 0;
	this.plannedToExileJack = 0;
	this.exiledJack = 0;
	this.exiledQueen = 0;
	this.totalLivingPlayers = 0;
	this.survivalRate = 0;
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
	this.comboSessions = 0;
	this.threeTimesSessionCombo = 0;
	this.fourTimesSessionCombo= 0;
	this.fiveTimesSessionCombo = 0;
	this.holyShitMmmmmonsterCombo = 0;
	this.numberFullFrog = 0;
	this.numberSickFrog = 0;
	this.numberNoFrog = 0;
	this.godTier = 0;
	this.questBed = 0;
	this.sacrificialSlab = 0;
	

	this.generateHTML = function(){
		var html = "<div class = 'multiSessionSummary' id = 'multiSessionSummary'>";
		var header = "<h2>Stats for All Displayed Sessions: </h2>(When done finding, can filter)"
		html += header;
		//http://stackoverflow.com/questions/85992/how-do-i-enumerate-the-properties-of-a-javascript-object
		for(var propertyName in this) {
			if(propertyName == "total"){
				html += "<Br><b> ";
				html +=  propertyName + "</b>: " + this[propertyName] ;
				html += " (" + Math.round(100* (this[propertyName]/this.total)) + "%)";
			}else if(propertyName == "totalDeadPlayers"){
				html += "<Br><b>totalDeadPlayers: </b> " + this.totalDeadPlayers + " ("+this.survivalRate + " % survival rate)";
			}else if(propertyName == "totalLivingPlayers" || propertyName == "survivalRate" ){
				//do nothing
			}else if(propertyName != "generateHTML"){
				html += "<Br><b> <input disabled='true' type='checkbox' name='filter' value='"+propertyName +"' id='" + propertyName + "' onchange='filterSessionSummaries()'>";
				html +=  propertyName + "</b>: " + this[propertyName] ;
				html += " (" + Math.round(100* (this[propertyName]/this.total)) + "%)";
			}
		}

		html += "</div><Br>"
		return html;
	}

}

function summaryHasProperty(summary, property){
	return summary[propertyName]
}

function collateMultipleSessionSummariesJunior(sessionSummaries){
	var mss = new MultiSessionSummaryJunior();
	return mss;
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
		if(ss.ectoBiologyStarted) mss.ectoBiologyStarted ++;
		if(ss.denizenFought) mss.denizenFought ++;
		if(ss.denizenBeat) mss.denizenBeat ++;
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
		if(ss.parentSession) mss.comboSessions ++;
		if(ss.threeTimesSessionCombo) mss.threeTimesSessionCombo ++;
		if(ss.fourTimesSessionCombo) mss.fourTimesSessionCombo ++;
		if(ss.fiveTimesSessionCombo) mss.fiveTimesSessionCombo ++;
		if(ss.holyShitMmmmmonsterCombo) mss.holyShitMmmmmonsterCombo ++;
		if(ss.frogStatus == "No Frog") mss.numberNoFrog ++;
		if(ss.frogStatus == "Sick Frog") mss.numberSickFrog ++;
		if(ss.frogStatus == "Full Frog") mss.numberFullFrog ++;
		if(ss.godTier) mss.godTier ++;
		if(ss.questBed) mss.questBed ++;
		if(ss.sacrificialSlab) mss.sacrificialSlab ++;
		mss.totalDeadPlayers += ss.numDead;
		mss.totalLivingPlayers += ss.numLiving;
	}
	mss.survivalRate = Math.round(100 * (mss.totalLivingPlayers/(mss.totalLivingPlayers + mss.totalDeadPlayers)));
	return mss;
}

//only initial stats.
function MultiSessionSummaryJunior(){
	
	this.generateHTML = function(){
		var html = "<div class = 'multiSessionSummary' id = 'multiSessionSummary'>";
		var header = "<h2>Stats for All Displayed Sessions: </h2>(When done finding, can filter)<br>"
		html += header;
		html += "Holy shit, what should even go here?"
		html += "</div><Br>"
		return html;
	}
}