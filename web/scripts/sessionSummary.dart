part of SBURBSim;
//TODO NOTE FROM JR: This is for the rare session finder and will be a BITCH to convert. wait on this.
//how AuthorBot summarizes a session
//eventually moon prophecies will use this.
//a prophecy can be any of these values that don't match the values in the current session summary.

class SessionSummary{ //since stats will be hash, don't need to make junior
  int session_id = null;
  Session parentSession; //pretty sure this has to be a full session so i can get lineage
  Map<String, bool> bool_stats; //most things
  Map<String, num> num_stats; //frog status
  Map<String, String> string_stats;  //num living, etc
  List<Map> miniPlayers = []; //array of hashes from players
  List<Player> players = []; //TODO do i need this AND that miniPlayers thing???
  Player mvp;


  SessionSummary(this.session_id);

  void setBoolStat(String statName, bool statValue) {
      this.bool_stats[statName] = statValue;
  }

  bool getBoolStat(String statName) {
     bool ret = this.bool_stats[statName];
    if (ret == null) throw "What Kind of Stat is: $statName???";
    return ret;
  }

  void setNumStat(String statName, num statValue) {
    this.num_stats[statName] = statValue;
  }

  num getNumStat(String statName) {
    num ret = this.num_stats[statName];
    if (ret == null) throw "What Kind of Stat is: $statName???";
    return ret;
  }

  void setStringStat(String statName, String statValue) {
    this.string_stats[statName] = statValue;
  }

  String getStringStat(String statName) {
    String ret = this.string_stats[statName];
    if (ret == null) throw "What Kind of Stat is: $statName???";
    return ret;
  }

  void setMiniPlayers(List<Player> players){
    for(num i = 0; i<players.length; i++){
      this.miniPlayers.add({"class_name": players[i].class_name, "aspect": players[i].aspect});
    }
  }

  bool matchesClass(List<String> classes){
    for(num i = 0; i<classes.length; i++){
      var class_name = classes[i];
      for(num j = 0; j<this.miniPlayers.length; j++){
        var miniPlayer = this.miniPlayers[j];
        if(miniPlayer["class_name"] == class_name) return true;
      }
    }
    return false;
  }

  bool matchesAspect(List<String> aspects){
    for(num i = 0; i<aspects.length; i++){
      var aspect = aspects[i];
      for(num j = 0; j<this.miniPlayers.length; j++){
        var miniPlayer = this.miniPlayers[j];
        if(miniPlayer["aspect"] == aspect) return true;
      }
    }
    return false;
  }

  bool miniPlayerMatchesAnyClasspect(miniPlayer, List<String> classes, List<String>  aspects){
    //is my class in the class array AND my aspect in the aspect array.
    if(classes.indexOf(miniPlayer.class_name) != -1 && aspects.indexOf(miniPlayer.aspect) != -1) return true;
    return false;
  }

  bool matchesBothClassAndAspect(List<String> classes, List<String> aspects){
    for(num j = 0; j<this.miniPlayers.length; j++){
      if(this.miniPlayerMatchesAnyClasspect(this.miniPlayers[j],classes,aspects)) return true;
    }
    return false;
  }
  bool matchesClasspect(List<String> classes, List<String> aspects){
    if(aspects.length > 0 && classes.length == 0){
      return this.matchesAspect(aspects);
    }else if(classes.length > 0 && aspects.length == 0){
      return this.matchesClass(classes);
    }else if(aspects.length > 0 && classes.length >0){
      print("returning and");
      return this.matchesBothClassAndAspect(classes, aspects);
    }else{
      return true; //no filters, all are accepted.
    }

  }
  bool satifies_filter_array(List<String> filter_array){
    //print(filter_array);
    for(num i = 0; i< filter_array.length; i++){
      var filter = filter_array[i];

      if(filter == "numberNoFrog"){
        if(this.getStringStat("frogStatus")  != "No Frog"){
          //	print("not no frog");
          return false;
        }
      }else if(filter == "numberSickFrog"){
        if(this.getStringStat("frogStatus")  != "Sick Frog"){
          //print("not sick frog");
          return false;
        }
      }else if(filter == "numberFullFrog"){
        if(this.getStringStat("frogStatus")  != "Full Frog"){
          //print("not full frog");
          return false;
        }
      }else if(filter == "numberPurpleFrog"){
        if(this.getStringStat("frogStatus")  != "Purple Frog"){
          //print("not full frog");
          return false;
        }
      }else if(filter == "timesAllDied"){
        if(this.getNumStat("numLiving") != 0){
          //print("not all dead");
          return false;
        }
      }else if(filter == "timesAllLived"){
        if(this.getNumStat("numDead") != 0){  //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want that.
          //print("not all alive");
          return false;
        }

      }else if(filter == "comboSessions"){
        if(this.parentSession == null){  //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want that.
          //print("not combo session");
          return false;
        }

      }else if(this.getBoolStat(filter) == null && this.getStringStat(filter) == null && this.getNumStat(filter) == null){
        //print("property not true: " + filter);
        return false;
      }
    }
    //print("i pass all filters");
    return true;
  }
  dynamic decodeLineageGenerateHTML(){
    String html = "";
    var params = window.location.href.substring(window.location.href.indexOf("?")+1); //what am i doing with params here?
    if (params == window.location.href) params = "";
    var lineage = this.parentSession.getLineage(); //i am not a session so remember to tack myself on at the end.
    String scratched = "";
    if(lineage[0].scratched) scratched = "(scratched)";
    html += "<Br><b> Session</b>: <a href = 'index2.html?seed=" + lineage[0].session_id +"&"+params+ "'>" +lineage[0].session_id + scratched +"</a> ";
    for(num i = 1; i< lineage.length; i++){
      String scratched = "";
      if(lineage[i].scratched) scratched = "(scratched)";
      html += " combined with: " + "<a href = 'index2.html?seed=" + lineage[i].session_id +"&"+params+ "'>" +lineage[i].session_id + scratched +"</a> ";
    }
    scratched = "";
    if(this.getBoolStat("scratched")) scratched = "(scratched)";
    html += " combined with: " + "<a href = 'index2.html?seed=" + this.session_id.toString() +"&"+params+ "'>" +this.session_id + scratched + "</a> ";
    if((lineage.length +1) == 3){
      this.setBoolStat("threeTimesSessionCombo", true)
      html += " 3x SESSIONS COMBO!!!";
    }
    if((lineage.length +1) == 4){
      this.setBoolStat("fourTimesSessionCombo",true);
      html += " 4x SESSIONS COMBO!!!!";
    }
    if((lineage.length +1 ) ==5){
      this.setBoolStat("fiveTimesSessionCombo",true);
      html += " 5x SESSIONS COMBO!!!!!";
    }
    if((lineage.length +1) > 5){
      this.setBoolStat("holyShitMmmmmonsterCombo",true);
      html += " The session pile doesn't stop from getting taller. ";
    }
    return html;

  }
  dynamic getSessionSummaryJunior(){
    throw "TODO: Do I still need a separate Junior Object???";
    //return new SessionSummaryJunior(this.players,this.session_id);
  }
  dynamic generateHTML(){
    var params = window.location.href.substring(window.location.href.indexOf("?")+1);
    if (params == window.location.href) params = "";
    String html = "<div class = 'sessionSummary' id = 'summarizeSession" + this.session_id.toString() +"'>";
    for(var propertyName in this) {
      if(propertyName == "players"){
        html += "<Br><b>" + propertyName + "</b>: " + getPlayersTitlesBasic(this.players);
      }else if(propertyName == "mvp"){
        html += "<Br><b>" + propertyName + "</b>: " + this.mvp.htmlTitle() + " With a Power of: " + this.mvp.getStat("power");
      }else if(propertyName == "frogLevel"){
        html += "<Br><b>" + propertyName + "</b>: " + this.frogLevel + " (" + this.frogStatus +")";
      }else if(propertyName == "session_id"){
        if(this.parentSession){
          html += this.decodeLineageGenerateHTML();
        }else{
          String scratch = "";
          if(this.scratched) scratch = "(scratched)";

          html += "<Br><b> Session</b>: <a href = 'index2.html?seed=" + this.session_id + "&"+params+"'>" +this.session_id + scratch +  "</a>";
        }
      }else if(propertyName == "matchesClass" || propertyName == "matchesAspect" || propertyName == "miniPlayerMatchesAnyClasspect" || propertyName == "matchesBothClassAndAspect" || propertyName == "matchesClasspect" ||propertyName == "matchesClass" || propertyName == "miniPlayers" || propertyName == "setMiniPlayers" || propertyName == "scratched" || propertyName == "ghosts" || propertyName == "satifies_filter_array" || propertyName == "frogStatus" || propertyName == "decodeLineageGenerateHTML"|| propertyName == "threeTimesSessionCombo" || propertyName == "fourTimesSessionCombo"  || propertyName == "fiveTimesSessionCombo"  || propertyName == "holyShitMmmmmonsterCombo" || propertyName == "parentSession"  ){
        //do nothing. properties used elsewhere.
      }else if(propertyName != "generateHTML" && propertyName != "getSessionSummaryJunior"){
        html += "<Br><b>" + propertyName + "</b>: " + this[propertyName] ;
      }
    }

    html += "</div><br>";
    return html;
  }


}

/* TODO fix this l8r
class SessionSummary {
	var session_id = null;
	var crashedFromSessionBug = null;
	var crashedFromPlayerActions = null;
	var blackKingDead = null;
	var won = null;
	var opossumVictory = null;
	var mayorEnding = null;
	var waywardVagabondEnding = null;
	var badBreakDeath = null;
	var choseGodTier = null;
	var luckyGodTier = null;
	var rocksFell = null;
	var num_scenes = null;
	var players = null;  //can ask for sessions with a blood player and a murder mode, for example
	var mvp = null;
	var scratchAvailable = null;
	var scratched = null;
	var parentSession = null;
	var yellowYard = null;
	var numLiving = null;
	var numDead = null;
	var ectoBiologyStarted = null;
	var denizenBeat = null;
	var plannedToExileJack = null;
	var exiledJack = null;
	var exiledQueen = null;
	var jackGotWeapon = null;
	var jackRampage = null;
	var jackScheme = null;
	var kingTooPowerful = null;
	var queenRejectRing = null;
	var democracyStarted = null;
	var murderMode = null;
	var grimDark = null;
	var frogLevel = null;
	var hasDiamonds = null;
	var hasSpades = null;
	var hasClubs = null;
	var hasHearts = null;
	var hasBreakups = null;	//set when generatingHTML
	bool threeTimesSessionCombo = false;
	bool fourTimesSessionCombo = false;
	bool fiveTimesSessionCombo = false;
	bool holyShitMmmmmonsterCombo = false;
	var frogStatus = null;
	bool godTier = false;
	bool questBed = false;
	bool sacrificialSlab = false;
	var heroicDeath = null;
	var justDeath = null;
	var rapBattle = null;
	var sickFires = null;
	var hasLuckyEvents = null;
	var hasUnluckyEvents = null;
	var hasFreeWillEvents = null;
	var averageMinLuck = null;
	var averageMaxLuck = null;
	var averagePower = null;
	var averageMobility = null;
	var averageFreeWill = null;
	var averageHP = null;
	var averageRelationshipValue = null;
	var averageSanity = null;
	var sizeOfAfterLife = null;
	var ghosts = null;
	List<dynamic> miniPlayers = []; //array of mini player objects

	


	SessionSummary() {}


	void setMiniPlayers(players){

		for(num i = 0; i<players.length; i++){
			this.miniPlayers.add({"class_name": players[i].class_name, "aspect": players[i].aspect});
		}
	}
	bool matchesClass(classes){
			for(num i = 0; i<classes.length; i++){
				var class_name = classes[i];
				for(num j = 0; j<this.miniPlayers.length; j++){
					var miniPlayer = this.miniPlayers[j];
					if(miniPlayer.class_name == class_name) return true;
				}
			}
			return false;
	}
	bool matchesAspect(aspects){
		for(num i = 0; i<aspects.length; i++){
			var aspect = aspects[i];
			for(num j = 0; j<this.miniPlayers.length; j++){
				var miniPlayer = this.miniPlayers[j];
				if(miniPlayer.aspect == aspect) return true;
			}
		}
		return false;
	}
	bool miniPlayerMatchesAnyClasspect(miniPlayer, classes, aspects){
		//is my class in the class array AND my aspect in the aspect array.
		if(classes.indexOf(miniPlayer.class_name) != -1 && aspects.indexOf(miniPlayer.aspect) != -1) return true;
		return false;
	}
	bool matchesBothClassAndAspect(classes, aspects){
		for(num j = 0; j<this.miniPlayers.length; j++){
			if(this.miniPlayerMatchesAnyClasspect(this.miniPlayers[j],classes,aspects)) return true;
		}
		return false;
	}
	bool matchesClasspect(classes, aspects){
		if(aspects.length > 0 && classes.length == 0){
			return this.matchesAspect(aspects);
		}else if(classes.length > 0 && aspects.length == 0){
			return this.matchesClass(classes);
		}else if(aspects.length > 0 && classes.length >0){
			print("returning and");
			return this.matchesBothClassAndAspect(classes, aspects);
		}else{
			return true; //no filters, all are accepted.
		}

	}
	bool satifies_filter_array(filter_array){
		//print(filter_array);
		for(num i = 0; i< filter_array.length; i++){
			var filter = filter_array[i];

			if(filter == "numberNoFrog"){
				if(this.frogStatus  != "No Frog"){
				//	print("not no frog");
					return false;
				}
			}else if(filter == "numberSickFrog"){
				if(this.frogStatus  != "Sick Frog"){
					//print("not sick frog");
					return false;
				}
			}else if(filter == "numberFullFrog"){
				if(this.frogStatus  != "Full Frog"){
					//print("not full frog");
					return false;
				}
			}else if(filter == "numberPurpleFrog"){
			    if(this.frogStatus  != "Purple Frog"){
                    //print("not full frog");
                    return false;
                }
			}else if(filter == "timesAllDied"){
				if(this.numLiving != 0){
					//print("not all dead");
					return false;
				}
			}else if(filter == "timesAllLived"){
				if(this.numDead != 0){  //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want that.
					//print("not all alive");
					return false;
				}

			}else if(filter == "comboSessions"){
				if(!this.parentSession){  //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want that.
					//print("not combo session");
					return false;
				}

			}else if(!this[filter]){
				//print("property not true: " + filter);
				return false;
			}
		}
		//print("i pass all filters");
		return true;
	}
	dynamic decodeLineageGenerateHTML(){
			String html = "";
			var params = window.location.href.substr(window.location.href.indexOf("?")+1);
			if (params == window.location.href) params = "";
			var lineage = this.parentSession.getLineage(); //i am not a session so remember to tack myself on at the end.
			String scratched = "";
			if(lineage[0].scratched) scratched = "(scratched)";
			html += "<Br><b> Session</b>: <a href = 'index2.html?seed=" + lineage[0].session_id +"&"+params+ "'>" +lineage[0].session_id + scratched +"</a> ";
			for(num i = 1; i< lineage.length; i++){
				String scratched = "";
				if(lineage[i].scratched) scratched = "(scratched)";
				html += " combined with: " + "<a href = 'index2.html?seed=" + lineage[i].session_id +"&"+params+ "'>" +lineage[i].session_id + scratched +"</a> ";
			}
			String scratched = "";
			if(this.scratched) scratched = "(scratched)";
			html += " combined with: " + "<a href = 'index2.html?seed=" + this.session_id +"&"+params+ "'>" +this.session_id + scratched + "</a> ";
			if((lineage.length +1) == 3){
				this.threeTimesSessionCombo = true;
				html += " 3x SESSIONS COMBO!!!";
			}
			if((lineage.length +1) == 4){
				this.fourTimesSessionCombo = true;
				html += " 4x SESSIONS COMBO!!!!";
			}
			if((lineage.length +1 ) ==5){
				this.fiveTimesSessionCombo = true;
				html += " 5x SESSIONS COMBO!!!!!";
			}
			if((lineage.length +1) > 5){
				this.holyShitMmmmmonsterCombo = true;
				html += " The session pile doesn't stop from getting taller. ";
			}
			return html;

	}
	dynamic getSessionSummaryJunior(){
		return new SessionSummaryJunior(this.players,this.session_id);
	}
	dynamic generateHTML(){
		var params = window.location.href.substr(window.location.href.indexOf("?")+1);
		if (params == window.location.href) params = "";
		String html = "<div class = 'sessionSummary' id = 'summarizeSession" + this.session_id +"'>";
		for(var propertyName in this) {
				if(propertyName == "players"){
					html += "<Br><b>" + propertyName + "</b>: " + getPlayersTitlesBasic(this.players);
				}else if(propertyName == "mvp"){
					html += "<Br><b>" + propertyName + "</b>: " + this.mvp.htmlTitle() + " With a Power of: " + this.mvp.getStat("power");
				}else if(propertyName == "frogLevel"){
					html += "<Br><b>" + propertyName + "</b>: " + this.frogLevel + " (" + this.frogStatus +")";
				}else if(propertyName == "session_id"){
					if(this.parentSession){
						html += this.decodeLineageGenerateHTML();
					}else{
						String scratch = "";
						if(this.scratched) scratch = "(scratched)";

						html += "<Br><b> Session</b>: <a href = 'index2.html?seed=" + this.session_id + "&"+params+"'>" +this.session_id + scratch +  "</a>";
					}
				}else if(propertyName == "matchesClass" || propertyName == "matchesAspect" || propertyName == "miniPlayerMatchesAnyClasspect" || propertyName == "matchesBothClassAndAspect" || propertyName == "matchesClasspect" ||propertyName == "matchesClass" || propertyName == "miniPlayers" || propertyName == "setMiniPlayers" || propertyName == "scratched" || propertyName == "ghosts" || propertyName == "satifies_filter_array" || propertyName == "frogStatus" || propertyName == "decodeLineageGenerateHTML"|| propertyName == "threeTimesSessionCombo" || propertyName == "fourTimesSessionCombo"  || propertyName == "fiveTimesSessionCombo"  || propertyName == "holyShitMmmmmonsterCombo" || propertyName == "parentSession"  ){
					//do nothing. properties used elsewhere.
				}else if(propertyName != "generateHTML" && propertyName != "getSessionSummaryJunior"){
					html += "<Br><b>" + propertyName + "</b>: " + this[propertyName] ;
				}
		}

		html += "</div><br>";
		return html;
	}


}



//junior only cares about players.
class SessionSummaryJunior {
	var players;
	var session_id;
	var ships = null;
	var averageMinLuck = null;
	var averageMaxLuck = null;
	var averagePower = null;
	var averageMobility = null;
	var averageFreeWill = null;
	var averageHP = null;
	var averageRelationshipValue = null;
	var averageSanity = null;	


	SessionSummaryJunior(this.players, this.session_id) {}


	dynamic generateHTML(){
		this.getAverages();
		var params = window.location.href.substr(window.location.href.indexOf("?")+1);
		if (params == window.location.href) params = "";
		String html = "<div class = 'sessionSummary' id = 'summarizeSession" + this.session_id +"'>";
		html += "<Br><b> Session</b>: <a href = 'index2.html?seed=" + this.session_id + "&"+params+"'>" +this.session_id + "</a>";
		html += "<Br><b>Players</b>: " + getPlayersTitlesBasic(this.players);
		html += "<Br><b>Potential God Tiers</b>: " + getPlayersTitlesBasic(this.grabPotentialGodTiers(this.players));


		html += "<Br><b>Initial Average Min Luck</b>: " + this.averageMinLuck;
		html += "<Br><b>Initial Average Max Luck</b>: " + this.averageMaxLuck;
		html += "<Br><b>Initial Average Power</b>: " + this.averagePower;
		html += "<Br><b>Initial Average Mobility</b>: " + this.averageMobility;
		html += "<Br><b>Initial Average Free Will</b>: " +this.averageFreeWill;
		html += "<Br><b>Initial Average HP</b>: " + this.averageHP;
		html += "<Br><b>Initial Relationship Value</b>: " + this.averageRelationshipValue;
		html += "<Br><b>Initial Trigger Level</b>: " +this.averageRelationshipValue;

		html += "<Br><b>Sprites</b>: " + this.grabAllSprites().toString();
		html += "<Br><b>Lands</b>: " + this.grabAllLands().toString();
		html += "<Br><b>Interests</b>: " + this.grabAllInterest().toString();
		html += "<Br><b>Initial Ships</b>:<Br> " + this.initialShips().toString();
		html += "</div><br>";
		return html;
	}
	void getAverages(){
		this.averageMinLuck = getAverageMinLuck(this.players);;
		this.averageMaxLuck = getAverageMaxLuck(this.players);;
		this.averagePower = getAveragePower(this.players);;
		this.averageMobility = getAverageMobility(this.players);;
		this.averageFreeWill = getAverageFreeWill(this.players);;
		this.averageHP = getAverageHP(this.players);;
		this.averageRelationshipValue = getAverageRelationshipValue(this.players);;
		this.averageRelationshipValue =  getAverageSanity(this.players);;
	}
	dynamic grabPotentialGodTiers(){
		List<dynamic> ret = [];
		for(num i = 0; i<this.players.length; i++){
			var player = this.players[i];
			if(player.godDestiny) ret.add(player);
		}
		return ret;
	}
	dynamic grabAllInterest(){
		List<dynamic> ret = [];
		for(num i = 0; i<this.players.length; i++){
			var player = this.players[i];
			ret.add(player.interest1);
			ret.add(player.interest2);

		}
		return ret;
	}
	dynamic grabAllSprites(){
		List<dynamic> ret = [];
		for(num i = 0; i<this.players.length; i++){
			var player = this.players[i];
			ret.add(player.object_to_prototype.htmlTitle());

		}
		return ret;
	}
	dynamic grabAllLands(){
		List<dynamic> ret = [];
		for(num i = 0; i<this.players.length; i++){
			var player = this.players[i];
			ret.add(player.land);

		}
		return ret;
	}
	void initialShips(){
		var shipper = new UpdateShippingGrid();
		if(!this.ships){
			shipper.createShips(this.players);
			this.ships = shipper.getGoodShips();
		}
		return  shipper.printShips(this.ships);
	}

}




class MultiSessionSummary {
	List<dynamic> ghosts = [];
	num total = 0;
	num badBreakDeath = 0;
	num choseGodTier = 0;
	num luckyGodTier = 0;
	num averageMinLuck = 0;
	num averageMaxLuck = 0;
	num averagePower = 0;
	num averageMobility = 0;
	num averageFreeWill = 0;
	num averageHP = 0;
	num averageRelationshipValue = 0;
	num averageSanity = 0;
	num sizeOfAfterLife = 0;
	num averageAfterLifeSize = 0;
	num totalDeadPlayers = 0;
	num crashedFromSessionBug = 0;
	num crashedFromPlayerActions = 0;
	num won = 0;
	num scratched = 0;
	num scratchAvailable = 0;
	num yellowYard = 0;
	num timesAllLived = 0;
	num blackKingDead = 0;
	num timesAllDied = 0;
	num ectoBiologyStarted = 0;
	num denizenBeat = 0;
	num plannedToExileJack = 0;
	num exiledJack = 0;
	num exiledQueen = 0;
	num totalLivingPlayers = 0;
	num survivalRate = 0;
	num jackGotWeapon = 0;
	num jackRampage = 0;
	num jackScheme = 0;
	num kingTooPowerful = 0;
	num queenRejectRing = 0;
	num democracyStarted = 0;
	num murderMode = 0;
	num grimDark = 0;
	num hasDiamonds = 0;
	num hasSpades = 0;
	num hasClubs = 0;
	num hasHearts = 0;
	num hasBreakups = 0;
	num comboSessions = 0;
	num threeTimesSessionCombo = 0;
	num fourTimesSessionCombo = 0;
	num fiveTimesSessionCombo = 0;
	num holyShitMmmmmonsterCombo = 0;
	num numberFullFrog = 0;
	num numberPurpleFrog = 0;
	num numberSickFrog = 0;
	num numberNoFrog = 0;
	num godTier = 0;
	num questBed = 0;
	num sacrificialSlab = 0;
	num heroicDeath = 0;
	num justDeath = 0;
	num rapBattle = 0;
	num sickFires = 0;
	num hasLuckyEvents = 0;
	num hasUnluckyEvents = 0;
	num hasFreeWillEvents = 0;
	num rocksFell = 0;
	num opossumVictory = 0;
	num averageNumScenes = 0;
	num waywardVagabondEnding = 0;
	num mayorEnding = 0;
	List<dynamic> checkedCorpseBoxes = [];	this.classes = {};
	this.aspects = {};

	


	MultiSessionSummary(this.) {}


	void setClasses(){
		var labels = ["Knight","Seer","Bard","Maid","Heir","Rogue","Page","Thief","Sylph","Prince","Witch","Mage"];
		for(num i = 0; i<labels.length; i++){
				this.classes[labels[i]] = 0;
		}
	}
	void integrateClasses(miniPlayers){
			for(num i = 0; i<miniPlayers.length; i++){
				this.classes[miniPlayers[i].class_name] ++;
			}

	}
	void integrateAspects(miniPlayers){
		for(num i = 0; i<miniPlayers.length; i++){
			this.aspects[miniPlayers[i].aspect] ++;
		}
	}
	void setAspects(){
		var labels = ["Blood","Mind","Rage","Time","Void","Heart","Breath","Light","Space","Hope","Life","Doom"];
		for(num i = 0; i<labels.length; i++){
				this.aspects[labels[i]] = 0;
		}
	}
	void filterCorpseParty(that){
		List<dynamic> filteredGhosts = [];
		that.checkedCorpseBoxes = []; //reset
		var classFiltered = querySelector("input:checkbox[name=CorpsefilterClass]:checked").length > 0;
		var aspectFiltered = querySelector("input:checkbox[name=CorpsefilterAspect]:checked").length > 0;
		for(num i = 0; i<that.ghosts.length; i++){
			var ghost = that.ghosts[i];
			//add self to filtered ghost if my class OR my aspect is checked. How to tell?  .is(":checked");
			if(classFiltered && !aspectFiltered){
				if(querySelector("#"+ghost.class_name).is(":checked")){
					filteredGhosts.add(ghost);
				}
			}else if(aspectFiltered && !classFiltered){
				if(querySelector("#"+ghost.aspect).is(":checked")){
					filteredGhosts.add(ghost);
				}
			}else if(aspectFiltered && classFiltered){
				if(querySelector("#"+ghost.class_name).is(":checked") && querySelector("#"+ghost.aspect).is(":checked")){
					filteredGhosts.add(ghost);
				}
			}else{//nothing filtered.
				filteredGhosts.add(ghost);
			}

		}

		var labels = ["Knight","Seer","Bard","Maid","Heir","Rogue","Page","Thief","Sylph","Prince","Witch","Mage","Blood","Mind","Rage","Time","Void","Heart","Breath","Light","Space","Hope","Life","Doom"];
		bool noneChecked = true;
		for(num i = 0; i<labels.length; i++){
			var l = labels[i];
			if(querySelector("#"+l).is(":checked")){
				that.checkedCorpseBoxes.add(l);
				noneChecked = false;
			}
		}

		if(noneChecked) filteredGhosts = that.ghosts; //none means 'all' basically
		querySelector("#multiSessionSummaryCorpseParty").html(that.generateCorpsePartyInnerHTML(filteredGhosts));
		that.wireUpCorpsePartyCheckBoxes();

	}
	void wireUpCorpsePartyCheckBoxes(){
		//i know what the labels are, they are just the classes and aspects.
		var that = this;
		var labels = ["Knight","Seer","Bard","Maid","Heir","Rogue","Page","Thief","Sylph","Prince","Witch","Mage","Blood","Mind","Rage","Time","Void","Heart","Breath","Light","Space","Hope","Life","Doom"];
		for(num i = 0; i<labels.length; i++){
			var l = labels[i];
			querySelector("#"+l).change((){
				that.filterCorpseParty(that);
			});
		}

		for(num i = 0; i<this.checkedCorpseBoxes.length; i++){
			var l = this.checkedCorpseBoxes[i];
			querySelector("#"+l).prop("checked", "true");
		}
	}
	dynamic generateHTMLForClassPropertyCorpseParty(label, value, total){
	//		//<input disabled='true' type='checkbox' name='filter' value='"+propertyName +"' id='" + propertyName + "' onchange='filterSessionSummaries()'>"
	String input = "<input type='checkbox' name='CorpsefilterClass' value='"+label +"' id='" + label + "'>";
	String html = "<Br>" +input + label + ": " + value + "(" + Math.round( 100* value/total) + "%)";
	return html;

}
	dynamic generateHTMLForAspectPropertyCorpseParty(label, value, total){
	//		//<input disabled='true' type='checkbox' name='filter' value='"+propertyName +"' id='" + propertyName + "' onchange='filterSessionSummaries()'>"
	String input = "<input type='checkbox' name='CorpsefilterAspect' value='"+label +"' id='" + label + "'>";
	String html = "<Br>" +input + label + ": " + value + "(" + Math.round( 100* value/total) + "%)";
	return html;

}
	dynamic generateCorpsePartyHTML(filteredGhosts){
		String html = "<div class = 'multiSessionSummary'>Corpse Party: (filtering here will ONLY modify the corpse party, not the other boxes) <button onclick='toggleCorpse()'>Toggle View </button>";
		html += "<div id = 'multiSessionSummaryCorpseParty'>"
		html += this.generateCorpsePartyInnerHTML(filteredGhosts);
		html += "</div></div>";
		return html;
	}
	void generateCorpsePartyInnerHTML(filteredGhosts){
		//first task. convert ghost array to map. or hash. or whatever javascript calls it. key is what I want to display on the left.
		//value is how many times I see something that evaluates to that key.
		// about players killing each other.  look for "died being put down like a rabid dog" and ignore the rest.  or  "fighting against the crazy X" to differentiate it from STRIFE.
		//okay, everything else should be fine. this'll probably still be pretty big, but can figure out how i wanna compress it later. might make all minion/denizen fights compress down to "first goddamn boss fight" and "denizen fight" respectively, but not for v1. want to see if certain
		//aspect have  a rougher go of it.
		String html = "";
		var corpsePartyClasses = {Knight: 0, Seer:0, Bard: 0, Maid: 0, Heir: 0, Rogue: 0, Page: 0, Thief: 0, Sylph:0, Prince:0, Witch:0, Mage:0};
		var corpsePartyAspects = {Blood: 0, Mind: 0, Rage: 0, Time: 0, Void: 0, Heart: 0, Breath: 0, Light: 0, Space: 0, Hope: 0, Life: 0, Doom: 0};
		var corpseParty = {} ;//now to refresh my memory on how javascript hashmaps work;
		html+="<br><b>  Number of Ghosts: </b>: " + filteredGhosts.length;
		for(num i = 0; i<filteredGhosts.length; i++){
				var ghost = filteredGhosts[i];
				if(ghost.causeOfDeath.startsWith("fighting against the crazy")){
					if (!corpseParty["fighting against a MurderMode player"]) corpseParty["fighting against a MurderMode player"] = 0 ;//otherwise NaN;
					corpseParty["fighting against a MurderMode player"] ++;
				}else if(ghost.causeOfDeath.startsWith("being put down like a rabid dog")){
					if (!corpseParty["being put down like a rabid dog"]) corpseParty["being put down like a rabid dog"] = 0 ;//otherwise NaN;
					corpseParty["being put down like a rabid dog"] ++;
				}else if(ghost.causeOfDeath.indexOf("Minion") !=  -1){
					if (!corpseParty["fighting a Denizen Minion"]) corpseParty["fighting a Denizen Minion"] = 0 ;//otherwise NaN;
					corpseParty["fighting a Denizen Minion"] ++;
				}else{//just use as is
					if (!corpseParty[ghost.causeOfDeath]) corpseParty[ghost.causeOfDeath] = 0 ;//otherwise NaN;
					corpseParty[ghost.causeOfDeath] ++;
				}

				if (!corpsePartyClasses[ghost.class_name]) corpsePartyClasses[ghost.class_name] = 0 ;//otherwise NaN;
				if (!corpsePartyAspects[ghost.aspect]) corpsePartyAspects[ghost.aspect] = 0 ;//otherwise NaN;
				corpsePartyAspects[ghost.aspect] ++;
				corpsePartyClasses[ghost.class_name] ++;
		}

		for(var corpseType in corpsePartyClasses){
			html += this.generateHTMLForClassPropertyCorpseParty(corpseType, corpsePartyClasses[corpseType], filteredGhosts.length);
		}

		for(var corpseType in corpsePartyAspects){
			html += this.generateHTMLForAspectPropertyCorpseParty(corpseType, corpsePartyAspects[corpseType], filteredGhosts.length);
		}

		for(var corpseType in corpseParty){
			html += "<Br>" +corpseType + ": " + corpseParty[corpseType] + "(" + Math.round( 100* corpseParty[corpseType]/filteredGhosts.length) + "%)";//todo maybe print out percentages here. we know how many ghosts there are.;
		}
		return html;

	}
	void isRomanceProperty(propertyName){
		return propertyName == "hasDiamonds" || propertyName == "hasSpades" ||propertyName == "hasClubs" || propertyName == "hasHearts"  || propertyName == "hasBreakups";
	}
	bool isDramaticProperty(propertyName){
		if(propertyName == "exiledJack" || propertyName == "plannedToExileJack" ||propertyName == "exiledQueen" || propertyName == "jackGotWeapon"  || propertyName == "jackScheme") return true;
		if(propertyName == "kingTooPowerful" || propertyName == "queenRejectRing" ||propertyName == "murderMode" || propertyName == "grimDark"  || propertyName == "denizenFought") return true;
		if(propertyName == "denizenBeat" || propertyName == "godTier" ||propertyName == "questBed" || propertyName == "sacrificialSlab"  || propertyName == "heroicDeath") return true;
		if(propertyName == "justDeath" || propertyName == "rapBattle" ||propertyName == "sickFires" || propertyName == "hasLuckyEvents"  || propertyName == "hasUnluckyEvents") return true;
		if(propertyName == "hasFreeWillEvents" ||propertyName == "jackRampage" || propertyName == "democracyStarted" ) return true;
		return false;
	}
	bool isEndingProperty(propertyName){
		if(propertyName == "yellowYard" || propertyName == "timesAllLived" ||propertyName == "timesAllDied" || propertyName == "scratchAvailable"  || propertyName == "won") return true;
		if(propertyName == "crashedFromPlayerActions" || propertyName == "ectoBiologyStarted" ||propertyName == "comboSessions" || propertyName == "threeTimesSessionCombo")return true;
		if(propertyName == "fourTimesSessionCombo" || propertyName == "fiveTimesSessionCombo" ||propertyName == "holyShitMmmmmonsterCombo" || propertyName == "numberFullFrog") return true;
		if(propertyName == "numberPurpleFrog" ||propertyName == "numberFullFrog" || propertyName == "numberSickFrog" || propertyName == "numberNoFrog" || propertyName == "rocksFell" || propertyName == "opossumVictory") return true;
		if(propertyName == "blackKingDead" || propertyName == "mayorEnding" || propertyName == "waywardVagabondEnding") return true;
		return false;
	}
	void isAverageProperty(propertyName){
		return propertyName == "sizeOfAfterLife" || propertyName == "averageAfterLifeSize" ||propertyName == "averageSanity" || propertyName == "averageRelationshipValue"  || propertyName == "averageHP" || propertyName == "averageFreeWill" || propertyName == "averageMobility" || propertyName == "averagePower" || propertyName == "averageMaxLuck" || propertyName == "averageMinLuck";
	}
	bool isPropertyToIgnore(propertyName){
		if(propertyName == "totalLivingPlayers" || propertyName == "survivalRate" || propertyName == "ghosts" || propertyName == "generateCorpsePartyHTML" || propertyName == "generateHTML") return true;
		if(propertyName == "generateCorpsePartyInnerHTML"  || propertyName == "isRomanceProperty" || propertyName == "isDramaticProperty" || propertyName == "isEndingProperty" || propertyName == "isAverageProperty" || propertyName == "isPropertyToIgnore") return true;
		if(propertyName == "wireUpCorpsePartyCheckBoxes"  || propertyName == "isFilterableProperty" || propertyName == "generateClassFilterHTML" || propertyName == "generateAspectFilterHTML" || propertyName == "generateHTMLForProperty" || propertyName == "generateRomanceHTML") return true;
		if(propertyName == "filterCorpseParty" || propertyName == "generateHTMLForClassPropertyCorpseParty"|| propertyName == "generateHTMLForAspectPropertyCorpseParty" || propertyName == "generateDramaHTML" || propertyName == "generateMiscHTML" || propertyName == "generateAverageHTML" || propertyName == "generateHTMLOld" || propertyName == "generateEndingHTML") return true;
		if(propertyName == "setAspects" || propertyName == "setClasses" || propertyName == "integrateAspects" || propertyName == "integrateClasses" || propertyName == "classes" || propertyName == "aspects") return true;
		if(propertyName == "wireUpClassCheckBoxes" || propertyName == "checkedCorpseBoxes" || propertyName == "wireUpAspectCheckBoxes" || propertyName == "filterClaspects") return true;
//

		return false;
	}
	void isFilterableProperty(propertyName){
		return !(propertyName == "sizeOfAfterLife" || propertyName == "averageNumScenes" || propertyName == "averageAfterLifeSize" ||propertyName == "averageSanity" || propertyName == "averageRelationshipValue"  || propertyName == "averageHP" || propertyName == "averageFreeWill" || propertyName == "averageMobility" || propertyName == "averagePower" || propertyName == "averageMaxLuck" || propertyName == "averageMinLuck");
	}
	dynamic generateHTML(){
		String html = "<div class = 'multiSessionSummary' id = 'multiSessionSummary'>";
		String header = "<h2>Stats for All Displayed Sessions: </h2>(When done finding, can filter)";
		html += header;

		List<dynamic> romanceProperties = [];
		List<dynamic> dramaProperties = [];
		List<dynamic> endingProperties = [];
		List<dynamic> averageProperties = [];
		List<dynamic> miscProperties = [];  //catchall if i missed something.

		for(var propertyName in this) {
			if(propertyName == "total"){ //it's like a header.
				html += "<Br><b> ";
				html +=  propertyName + "</b>: " + this[propertyName] ;
				html += " (" + Math.round(100* (this[propertyName]/this.total)) + "%)";
			}else if(propertyName == "totalDeadPlayers"){
				html += "<Br><b>totalDeadPlayers: </b> " + this.totalDeadPlayers + " ("+this.survivalRate + " % survival rate)"; //don't want to EVER ignore this.
			}else if(propertyName == "crashedFromSessionBug"){
				html += this.generateHTMLForProperty(propertyName) ;//don't ignore bugs, either.;
			}else if(this.isRomanceProperty(propertyName)){
				romanceProperties.add(propertyName);
			}else if(this.isDramaticProperty(propertyName)){
				dramaProperties.add(propertyName);
			}else if(this.isEndingProperty(propertyName)){
				endingProperties.add(propertyName);
			}else if(this.isAverageProperty(propertyName)){
				averageProperties.add(propertyName);
			}else if(!this.isPropertyToIgnore(propertyName)){
				miscProperties.add(propertyName);
			}
		}
		html += "</div><br>";
		html += this.generateRomanceHTML(romanceProperties);
		html += this.generateDramaHTML(dramaProperties);
		html += this.generateMiscHTML(miscProperties);
		html += this.generateEndingHTML(endingProperties);
		html += this.generateClassFilterHTML();
		html += this.generateAspectFilterHTML();
		html += this.generateAverageHTML(averageProperties);
		html += this.generateCorpsePartyHTML(this.ghosts);
		//MSS and SS will need list of classes and aspects. just strings. nothing beefier.
		//these will have to be filtered in a special way. just render and display stats for now, though. no filtering.

		html += "</div><Br>";
		return html;

	}
	dynamic generateClassFilterHTML(){
		String html = "<div class = 'multiSessionSummary topAligned' id = 'multiSessionSummaryClasses'>Classes:";
		for(var propertyName in this.classes) {
			String input = "<input type='checkbox' name='filterClass' value='"+propertyName +"' id='class" + propertyName  + "' onchange='filterSessionSummaries()'>";
			html += "<Br>" +input + propertyName + ": " + this.classes[propertyName] + "(" + Math.round( 100* this.classes[propertyName]/this.total) + "%)";
		}
		html += "</div>";
		return html;
	}
	dynamic generateAspectFilterHTML(){
		String html = "<div class = 'multiSessionSummary topAligned' id = 'multiSessionSummaryAspects'>Aspects:";
		for(var propertyName in this.aspects) {
			String input = "<input type='checkbox' name='filterAspect' value='"+propertyName +"' id='aspect" + propertyName +  "' onchange='filterSessionSummaries()'>";
			html += "<Br>" +input + propertyName + ": " + this.aspects[propertyName] + "(" + Math.round( 100* this.aspects[propertyName]/this.total) + "%)";
		}
		html += "</div>";
		return html;
	}
	dynamic generateHTMLForProperty(propertyName){
		String html = "";
		if(this.isFilterableProperty(propertyName)){
			html += "<Br><b> <input disabled='true' type='checkbox' name='filter' value='"+propertyName +"' id='" + propertyName + "' onchange='filterSessionSummaries()'>";
			html +=  propertyName + "</b>: " + this[propertyName] ;
			html += " (" + Math.round(100* (this[propertyName]/this.total)) + "%)";
		}else{
			html += "<br><b>" + propertyName + "</b>: " + this[propertyName];
		}
		return html;
	}
	dynamic generateRomanceHTML(properties){
		String html = "<div  class = 'bottomAligned multiSessionSummary'>Romance: <button onclick='toggleRomance()'>Toggle View </button>";
		html += "<div id = 'multiSessionSummaryRomance' >"
		for(num i = 0; i<properties.length; i++){
			var propertyName = properties[i];
			html += this.generateHTMLForProperty(propertyName);
		}
		html += "</div></div>";
		//print(html);
		return html;
	}
	dynamic generateDramaHTML(properties){
		String html = "<div class = 'bottomAligned multiSessionSummary' >Drama: <button onclick='toggleDrama()'>Toggle View </button>";
		html += "<div id = 'multiSessionSummaryDrama' >"
		for(num i = 0; i<properties.length; i++){
			var propertyName = properties[i];
			html += this.generateHTMLForProperty(propertyName);
		}
		html += "</div></div>";
		return html;
	}
	dynamic generateEndingHTML(properties){
		String html = "<div class = 'topligned multiSessionSummary'>Ending: <button onclick='toggleEnding()'>Toggle View </button>";
		html += "<div id = 'multiSessionSummaryEnding' >"
		for(num i = 0; i<properties.length; i++){
			var propertyName = properties[i];
			html += this.generateHTMLForProperty(propertyName);
		}
		html += "</div></div>";
		return html;
	}
	dynamic generateMiscHTML(properties){
		String html = "<div class = 'bottomAligned multiSessionSummary' >Misc <button onclick='toggleMisc()'>Toggle View </button>";
		html += "<div id = 'multiSessionSummaryMisc' >"
		for(num i = 0; i<properties.length; i++){
			var propertyName = properties[i];
			html += this.generateHTMLForProperty(propertyName);
		}
		html += "</div></div>";
		return html;
	}
	dynamic generateAverageHTML(properties){
		String html = "<div class = 'topAligned multiSessionSummary' >Averages <button onclick='toggleAverage()'>Toggle View </button>";
		html += "<div id = 'multiSessionSummaryAverage' >"
		for(num i = 0; i<properties.length; i++){
			var propertyName = properties[i];
			html += this.generateHTMLForProperty(propertyName);
		}
		html += "</div></div>";
		return html;
	}


}





void summaryHasProperty(summary, property){
	return summary[propertyName];
}



dynamic collateMultipleSessionSummariesJunior(sessionSummaryJuniors){
	var mss = new MultiSessionSummaryJunior();
	mss.numSessions = sessionSummaryJuniors.length;
	for(num i = 0; i<sessionSummaryJuniors.length; i++){
		var ssj =sessionSummaryJuniors[i];
		mss.numPlayers += ssj.players.length;
		mss.numShips += ssj.ships.length;
		mss.averageMinLuck += ssj.averageMinLuck;
		mss.averageMaxLuck += ssj.averageMaxLuck;
		mss.averagePower += ssj.averagePower;
		mss.averageMobility += ssj.averageMobility;
		mss.averageFreeWill += ssj.averageFreeWill;
		mss.averageHP += ssj.averageHP;
		mss.averageSanity += ssj.averageSanity;
		mss.averageRelationshipValue += ssj.averageRelationshipValue;
	}

	mss.averageMinLuck = Math.round(mss.averageMinLuck/sessionSummaryJuniors.length);
	mss.averageMaxLuck = Math.round(mss.averageMaxLuck/sessionSummaryJuniors.length);
	mss.averagePower = Math.round(mss.averagePower/sessionSummaryJuniors.length);
	mss.averageMobility = Math.round(mss.averageMobility/sessionSummaryJuniors.length);
	mss.averageFreeWill = Math.round(mss.averageFreeWill/sessionSummaryJuniors.length);
	mss.averageHP = Math.round(mss.averageHP/sessionSummaryJuniors.length);
	mss.averageSanity = Math.round(mss.averageSanity/sessionSummaryJuniors.length);
	mss.averageRelationshipValue = Math.round(mss.averageRelationshipValue/sessionSummaryJuniors.length);
	return mss;
}



dynamic collateMultipleSessionSummaries(sessionSummaries){
	var mss = new MultiSessionSummary();
	mss.setClasses();
	mss.setAspects();
	for(num i = 0; i<sessionSummaries.length; i++){
		var ss = sessionSummaries[i];
		mss.total ++;
		mss.integrateAspects(ss.miniPlayers);
		mss.integrateClasses(ss.miniPlayers);


		if(ss.badBreakDeath) mss.badBreakDeath ++;
		if(ss.mayorEnding) mss.mayorEnding ++;
		if(ss.waywardVagabondEnding) mss.waywardVagabondEnding ++;
		if(ss.choseGodTier) mss.choseGodTier ++;
		if(ss.luckyGodTier) mss.luckyGodTier ++;
		if(ss.blackKingDead) mss.blackKingDead ++;
		if(ss.crashedFromSessionBug) mss.crashedFromSessionBug ++;
		if(ss.opossumVictory) mss.opossumVictory ++;
		if(ss.rocksFell) mss.rocksFell ++;
		if(ss.crashedFromPlayerActions) mss.crashedFromPlayerActions ++;
		if(ss.scratchAvailable) mss.scratchAvailable ++;
		if(ss.yellowYard) mss.yellowYard ++;
		if(ss.numLiving == 0) mss.timesAllDied ++;
		if(ss.numDead == 0) mss.timesAllLived ++;
		if(ss.ectoBiologyStarted) mss.ectoBiologyStarted ++;
		if(ss.denizenBeat) mss.denizenBeat ++;
		if(ss.plannedToExileJack) mss.plannedToExileJack ++;
		if(ss.exiledJack) mss.exiledJack ++;
		if(ss.exiledQueen) mss.exiledQueen ++;
		if(ss.jackGotWeapon) mss.jackGotWeapon ++;
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
		if(ss.hasBreakups) mss.hasBreakups ++;
		if(ss.hasHearts) mss.hasHearts ++;
		if(ss.parentSession) mss.comboSessions ++;
		if(ss.threeTimesSessionCombo) mss.threeTimesSessionCombo ++;
		if(ss.fourTimesSessionCombo) mss.fourTimesSessionCombo ++;
		if(ss.fiveTimesSessionCombo) mss.fiveTimesSessionCombo ++;
		if(ss.holyShitMmmmmonsterCombo) mss.holyShitMmmmmonsterCombo ++;
		if(ss.frogStatus == "No Frog") mss.numberNoFrog ++;
		if(ss.frogStatus == "Sick Frog") mss.numberSickFrog ++;
		if(ss.frogStatus == "Full Frog") mss.numberFullFrog ++;
		if(ss.frogStatus == "Purple Frog") mss.numberPurpleFrog ++;
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
		if(ss.scratched) mss.scratched ++;

		if(ss.won) mss.won ++;

		mss.sizeOfAfterLife += ss.sizeOfAfterLife;
		mss.ghosts = mss.ghosts.concat(ss.ghosts);
		mss.averageMinLuck += ss.averageMinLuck;
		mss.averageMaxLuck += ss.averageMaxLuck;
		mss.averagePower += ss.averagePower;
		mss.averageMobility += ss.averageMobility;
		mss.averageFreeWill += ss.averageFreeWill;
		mss.averageHP += ss.averageHP;
		mss.averageSanity += ss.averageSanity;
		mss.averageRelationshipValue += ss.averageRelationshipValue;
		mss.averageNumScenes += ss.num_scenes;


		mss.totalDeadPlayers += ss.numDead;
		mss.totalLivingPlayers += ss.numLiving;
	}
	mss.averageAfterLifeSize = Math.round(mss.sizeOfAfterLife/sessionSummaries.length);
	mss.averageMinLuck = Math.round(mss.averageMinLuck/sessionSummaries.length);
	mss.averageMaxLuck = Math.round(mss.averageMaxLuck/sessionSummaries.length);
	mss.averagePower = Math.round(mss.averagePower/sessionSummaries.length);
	mss.averageMobility = Math.round(mss.averageMobility/sessionSummaries.length);
	mss.averageFreeWill = Math.round(mss.averageFreeWill/sessionSummaries.length);
	mss.averageHP = Math.round(mss.averageHP/sessionSummaries.length);
	mss.averageSanity = Math.round(mss.averageSanity/sessionSummaries.length);
	mss.averageRelationshipValue = Math.round(mss.averageRelationshipValue/sessionSummaries.length);
	mss.averageNumScenes = Math.round(mss.averageNumScenes/sessionSummaries.length);
	mss.survivalRate = Math.round(100 * (mss.totalLivingPlayers/(mss.totalLivingPlayers + mss.totalDeadPlayers)));
	return mss;
}



void round2Places(num){
	return Math.round(num*100)/100;
}


//only initial stats.
class MultiSessionSummaryJunior {
	num numSessions = 0;
	num numPlayers = 0;
	num numShips = 0;
	var averageMinLuck = null;
	var averageMaxLuck = null;
	var averagePower = null;
	var averageMobility = null;
	var averageFreeWill = null;
	var averageHP = null;
	var averageRelationshipValue = null;
	var averageSanity = null;	


	MultiSessionSummaryJunior(this.) {}


	dynamic generateHTML(){
		String html = "<div class = 'multiSessionSummary' id = 'multiSessionSummary'>";
		String header = "<h2>Stats for All Displayed Sessions: </h2><br>";
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
		html += "<Br><b>averageSanity:</b> " + this.averageSanity;

		html += "<Br><b>Average Initial Ships Per Session:</b> " + round2Places(this.numShips/this.numSessions);
		html += "<Br><br><b>Filter Sessions By Number of Players:</b><Br>2 <input id='num_players' type='range' min='2' max='12' value='2'> 12"
		html += "<br><input type='text' id='num_players_text' value='2' size='2' disabled>";
		html += "<br><br><button id = 'button' onclick='filterSessionsJunior()'>Filter Sessions</button>";
		html += "</div><Br>";
		return html;
	}

}



void toggleCorpse(){
		querySelector('#multiSessionSummaryCorpseParty').toggle();
		displayCorpse = !displayCorpse;
		if(displayCorpse){
			querySelector("#avatar").attr("src","images/corpse_party_robot_author.png");
		}else{
			querySelector("#avatar").attr("src","images/robot_author.png");
		}
}



void toggleRomance(){
		querySelector('#multiSessionSummaryRomance').toggle();
		displayRomance = !displayRomance;
}



void toggleDrama(){
		querySelector('#multiSessionSummaryDrama').toggle();
		displayDrama = !displayDrama;
}



void toggleMisc(){
		querySelector('#multiSessionSummaryMisc').toggle();
		displayMisc = !displayMisc;
}



void toggleEnding(){
		querySelector('#multiSessionSummaryEnding').toggle();
		displayEnding = !displayEnding;
}



void toggleAverage(){
		querySelector('#multiSessionSummaryAverage').toggle();
		displayAverages = !displayAverages;
}
*/