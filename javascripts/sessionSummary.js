//how AuthorBot summarizes a session
//eventually moon prophecies will use this.
//a prophecy can be any of these values that don't match the values in the current session summary.
function SessionSummary(){
	this.session_id = null;
	this.crashedFromSessionBug = null;
	this.crashedFromPlayerActions = null;
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
	this.heroicDeath = null;
	this.justDeath = null;
	this.rapBattle = null;
	this.sickFires = null;
	this.hasLuckyEvents = null;
	this.hasUnluckyEvents = null;
	this.hasFreeWillEvents = null;
	this.averageMinLuck = null;
	this.averageMaxLuck = null;
	this.averagePower = null;
	this.averageMobility = null;
	this.averageFreeWill = null;
	this.averageHP = null;
	this.averageRelationshipValue = null;
	this.averageTriggerLevel = null;
	this.sizeOfAfterLife = null;

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
		return new SessionSummaryJunior(this.players,this.session_id);
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
				}else if(propertyName == "satifies_filter_array" || propertyName == "frogStatus" || propertyName == "decodeLineageGenerateHTML"|| propertyName == "threeTimesSessionCombo" || propertyName == "fourTimesSessionCombo"  || propertyName == "fiveTimesSessionCombo"  || propertyName == "holyShitMmmmmonsterCombo" || propertyName == "parentSession"  ){
					//do nothing. properties used elsewhere.
				}else if(propertyName != "generateHTML" && propertyName != "getSessionSummaryJunior"){
					html += "<Br><b>" + propertyName + "</b>: " + this[propertyName] ;
				}
		}

		html += "</div><br>"
		return html;
	}

}

//junior only cares about players.
function SessionSummaryJunior(players,session_id){
	this.players = players;
	this.session_id = session_id;
	this.ships = null;
	this.averageMinLuck = null;
	this.averageMaxLuck = null;
	this.averagePower = null;
	this.averageMobility = null;
	this.averageFreeWill = null;
	this.averageHP = null;
	this.averageRelationshipValue = null;
	this.averageTriggerLevel = null;

	this.generateHTML = function(){
		this.getAverages();
		var html = "<div class = 'sessionSummary' id = 'summarizeSession" + this.session_id +"'>";
		html += "<Br><b> Session</b>: <a href = 'index2.html?seed=" + this.session_id + "'>" +this.session_id + "</a>"
		html += "<Br><b>Players</b>: " + getPlayersTitlesBasic(this.players);
		html += "<Br><b>Potential God Tiers</b>: " + getPlayersTitlesBasic(this.grabPotentialGodTiers(this.players));


		html += "<Br><b>Initial Average Min Luck</b>: " + this.averageMinLuck;
		html += "<Br><b>Initial Average Max Luck</b>: " + this.averageMaxLuck
		html += "<Br><b>Initial Average Power</b>: " + this.averagePower
		html += "<Br><b>Initial Average Mobility</b>: " + this.averageMobility
		html += "<Br><b>Initial Average Free Will</b>: " +this.averageFreeWill
		html += "<Br><b>Initial Average HP</b>: " + this.averageHP
		html += "<Br><b>Initial Relationship Value</b>: " + this.averageRelationshipValue
		html += "<Br><b>Initial Trigger Level</b>: " +this.averageRelationshipValue

		html += "<Br><b>Sprites</b>: " + this.grabAllSprites().toString();
		html += "<Br><b>Lands</b>: " + this.grabAllLands().toString();
		html += "<Br><b>Interests</b>: " + this.grabAllInterest().toString();
		html += "<Br><b>Initial Ships</b>:<Br> " + this.initialShips().toString();
		html += "</div><br>"
		return html;
	}

	this.getAverages = function(){
		this.averageMinLuck = getAverageMinLuck(this.players);;
		this.averageMaxLuck = getAverageMaxLuck(this.players);;
		this.averagePower = getAveragePower(this.players);;
		this.averageMobility = getAverageMobility(this.players);;
		this.averageFreeWill = getAverageFreeWill(this.players);;
		this.averageHP = getAverageHP(this.players);;
		this.averageRelationshipValue = getAverageRelationshipValue(this.players);;
		this.averageRelationshipValue =  getAverageTriggerLevel(this.players);;
	}


	this.grabPotentialGodTiers = function(){
		var ret = [];
		for(var i = 0; i<this.players.length; i++){
			var player = this.players[i];
			if(player.godDestiny) ret.push(player);
		}
		return ret;
	}

	this.grabAllInterest = function(){
		var ret = [];
		for(var i = 0; i<this.players.length; i++){
			var player = this.players[i];
			ret.push(player.interest1);
			ret.push(player.interest2);

		}
		return ret;
	}

	this.grabAllSprites = function(){
		var ret = [];
		for(var i = 0; i<this.players.length; i++){
			var player = this.players[i];
			ret.push(player.kernel_sprite);

		}
		return ret;
	}

	this.grabAllLands = function(){
		var ret = [];
		for(var i = 0; i<this.players.length; i++){
			var player = this.players[i];
			ret.push(player.land);

		}
		return ret;
	}

	this.initialShips = function(){
		var shipper = new UpdateShippingGrid();
		if(!this.ships){
			shipper.createShips(this.players);
			this.ships = shipper.getGoodShips()
		}
		return  shipper.printShips(this.ships)
	}
}


function MultiSessionSummary(){
	this.total = 0;
	this.averageMinLuck = 0;
	this.averageMaxLuck = 0;
	this.averagePower = 0;
	this.averageMobility = 0;
	this.averageFreeWill = 0;
	this.averageHP = 0;
	this.averageRelationshipValue = 0;
	this.averageTriggerLevel = 0;
	this.sizeOfAfterLife = 0;
	this.crashedFromSessionBug = 0;
	this.crashedFromPlayerActions = 0;
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
	this.heroicDeath = 0;
	this.justDeath = 0;
	this.rapBattle = 0;
	this.sickFires = 0;
	this.hasLuckyEvents = 0;
	this.hasUnluckyEvents = 0;
	this.hasFreeWillEvents = 0;
	


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
			}else if(propertyName == "sizeOfAfterLife" || propertyName == "averageTriggerLevel" || propertyName == "averageRelationshipValue"  || propertyName == "averageHP" || propertyName == "averageFreeWill" || propertyName == "averageMobility" || propertyName == "averagePower" || propertyName == "averageMaxLuck" || propertyName == "averageMinLuck"){
				html += "<br><b>" + propertyName + "</b>: " + this[propertyName];
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

function collateMultipleSessionSummariesJunior(sessionSummaryJuniors){
	var mss = new MultiSessionSummaryJunior();
	mss.numSessions = sessionSummaryJuniors.length;
	for(var i = 0; i<sessionSummaryJuniors.length; i++){
		var ssj =sessionSummaryJuniors[i];
		mss.numPlayers += ssj.players.length;
		mss.numShips += ssj.ships.length;
		mss.averageMinLuck += ssj.averageMinLuck
		mss.averageMaxLuck += ssj.averageMaxLuck
		mss.averagePower += ssj.averagePower
		mss.averageMobility += ssj.averageMobility
		mss.averageFreeWill += ssj.averageFreeWill
		mss.averageHP += ssj.averageHP
		mss.averageTriggerLevel += ssj.averageTriggerLevel
		mss.averageRelationshipValue += ssj.averageRelationshipValue
	}

	mss.averageMinLuck = Math.round(mss.averageMinLuck/sessionSummaryJuniors.length)
	mss.averageMaxLuck = Math.round(mss.averageMaxLuck/sessionSummaryJuniors.length)
	mss.averagePower = Math.round(mss.averagePower/sessionSummaryJuniors.length)
	mss.averageMobility = Math.round(mss.averageMobility/sessionSummaryJuniors.length)
	mss.averageFreeWill = Math.round(mss.averageFreeWill/sessionSummaryJuniors.length)
	mss.averageHP = Math.round(mss.averageHP/sessionSummaryJuniors.length)
	mss.averageTriggerLevel = Math.round(mss.averageTriggerLevel/sessionSummaryJuniors.length)
	mss.averageRelationshipValue = Math.round(mss.averageRelationshipValue/sessionSummaryJuniors.length)
	return mss;
}

function collateMultipleSessionSummaries(sessionSummaries){
	var mss = new MultiSessionSummary();
	for(var i = 0; i<sessionSummaries.length; i++){
		var ss = sessionSummaries[i];
		mss.total ++;
		if(ss.crashedFromSessionBug) mss.crashedFromSessionBug ++;
		if(ss.crashedFromPlayerActions) mss.crashedFromPlayerActions ++;
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
		if(ss.justDeath) mss.justDeath ++;
		if(ss.heroicDeath) mss.heroicDeath ++;
		if(ss.rapBattle) mss.rapBattle ++;
		if(ss.sickFires) mss.sickFires ++;
		if(ss.hasLuckyEvents) mss.hasLuckyEvents ++;
		if(ss.hasUnluckyEvents) mss.hasUnluckyEvents ++;
		if(ss.hasFreeWillEvents) mss.hasFreeWillEvents ++;
		
		mss.sizeOfAfterLife += ss.sizeOfAfterLife;
		mss.averageMinLuck += ss.averageMinLuck
		mss.averageMaxLuck += ss.averageMaxLuck
		mss.averagePower += ss.averagePower
		mss.averageMobility += ss.averageMobility
		mss.averageFreeWill += ss.averageFreeWill
		mss.averageHP += ss.averageHP
		mss.averageTriggerLevel += ss.averageTriggerLevel
		mss.averageRelationshipValue += ss.averageRelationshipValue


		mss.totalDeadPlayers += ss.numDead;
		mss.totalLivingPlayers += ss.numLiving;
	}
	mss.averageMinLuck = Math.round(mss.averageMinLuck/sessionSummaries.length)
	mss.averageMaxLuck = Math.round(mss.averageMaxLuck/sessionSummaries.length)
	mss.averagePower = Math.round(mss.averagePower/sessionSummaries.length)
	mss.averageMobility = Math.round(mss.averageMobility/sessionSummaries.length)
	mss.averageFreeWill = Math.round(mss.averageFreeWill/sessionSummaries.length)
	mss.averageHP = Math.round(mss.averageHP/sessionSummaries.length)
	mss.averageTriggerLevel = Math.round(mss.averageTriggerLevel/sessionSummaries.length)
	mss.averageRelationshipValue = Math.round(mss.averageRelationshipValue/sessionSummaries.length)
	mss.survivalRate = Math.round(100 * (mss.totalLivingPlayers/(mss.totalLivingPlayers + mss.totalDeadPlayers)));
	return mss;
}

function round2Places(num){
	return Math.round(num*100)/100
}
//only initial stats.
function MultiSessionSummaryJunior(){
	this.numSessions = 0;
	this.numPlayers = 0;
	this.numShips = 0;
	this.averageMinLuck = null;
	this.averageMaxLuck = null;
	this.averagePower = null;
	this.averageMobility = null;
	this.averageFreeWill = null;
	this.averageHP = null;
	this.averageRelationshipValue = null;
	this.averageTriggerLevel = null;

	this.generateHTML = function(){
		var html = "<div class = 'multiSessionSummary' id = 'multiSessionSummary'>";
		var header = "<h2>Stats for All Displayed Sessions: </h2><br>"
		html += header;
		html += "<Br><b>Number of Sessions:</b> " + this.numSessions;
		html += "<Br><b>Average Players Per Session:</b> " + round2Places(this.numPlayers/this.numSessions);

		html += "<Br><b>averageMinLuck:</b> " + this.averageMinLuck;
		html += "<Br><b>averageMaxLuck:</b> " + this.averageMaxLuck;
		html += "<Br><b>averagePower:</b> " + this.averagePower;
		html += "<Br><b>averageMobility:</b> " + this.averageMobility;
		html += "<Br><b>averageFreeWill:</b> " + this.averageFreeWill;
		html += "<Br><b>averageHP:</b> " + this.averageHP;
		html += "<Br><b>averageRelationshipValue:</b> " + this.averageRelationshipValue;
		html += "<Br><b>averageTriggerLevel:</b> " + this.averageTriggerLevel;

		html += "<Br><b>Average Initial Ships Per Session:</b> " + round2Places(this.numShips/this.numSessions);
		html += "<Br><br><b>Filter Sessions By Number of Players:</b><Br>2 <input id='num_players' type='range' min='2' max='12' value='2'> 12"
		html += "<br><input type='text' id='num_players_text' value='2' size='2' disabled>"
		html += "<br><br><button id = 'button' onclick='filterSessionsJunior()'>Filter Sessions</button>"
		html += "</div><Br>"
		return html;
	}
}
