
/*TODO  Fix l8r
var charCreatorHelperGlobalVar;
List<dynamic> playersGlobalVar = [];
var easterEggEngineGlobalVar;
bool simulationMode = false;
List<dynamic> teamsGlobalVar = [];
bool abj = false;  //<-- pro tip, ABJ follows the "Andrew Hussie School of StoryTelling", more deaths = more drama;
bool tournamentMode = true;
//for whole tournament
String mvpName = "";
String mvpScore = "";
List<dynamic> startingTeams = [];
num lastTeamIndex = -2; //each round starts at index + 2
num tierNumber = 0; //starts at zero before fight, then at 1.
//objects representing how things went.
List<dynamic> tiers = [];
var currentTier; //tier object that i add rounds to.
var allColors = ["#ffdf99","#29ded8","#29de69","#e88cff","#ff8cc5","#b58cff","#8cfff0","#8cffaf","#ddff8c","#ffe88c","#ffa28c","#ffefdb","#faffdb","#dbffef","#dbebff","#ffdbf8","#dfffdb","#ffc5c5","#ff99b8","#ff99fe","#d099ff","#99b1ff","#99ffed","#c9ff99"];
List<dynamic> remainingColors = [];

window.onload = () {
	querySelector(this).scrollTop(0);
	if(getParameterByName("abj")  == "interesting!!!"){
		abj = true;
		querySelector("#judge").html("Wait, no, get me out of here, I want the  <a href = 'tournament_arc.html'>AuthorBot</a> again.");
	}
	loadNavbar();
	simulationMode = true; //dont' render graphics.
	displayPotentialFighters();
	numSimulationsToDo = 10;
	makeDescriptionList();
}

void resetColors(){
	remainingColors = [];
	for(num i = 0; i<allColors.length; i++){
		remainingColors.add(allColors[i]);
	}
}



void setStartingTeams(){
	for(var i =0; i<teamsGlobalVar.length; i++){
		startingTeams.add(teamsGlobalVar[i]);
	}
}



void createEndingTable(){
	String html = "(matching colors means they faced each other that tier) <div class = 'tournamentResults'><table id = 'endingTable' >";
	html += createEndingTableHeader();
	//for loop on number of tiers.
	for(num i = 0; i<startingTeams.length; i++){
		html += createEndingTableRow(startingTeams[i]);
	}
	html += "</table></div>" ;//i tried scrolls to make it look better, but it made it harder to navigate, so, fuck that shit.;
	querySelector("#descriptions").append(html);
}


dynamic createEndingTableHeader(){
	String html = "<tr>";
	for(num i = 1; i<=tiers.length; i++){
		html += "<th>Tier: " +i+ " </th>";
	}
	html += "</tr>";
	return html;
}



dynamic createEndingTableRow(team){
	String html = "<tr>";
	for(num i = 0; i<tiers.length; i++){
		var round = tiers[i].findRoundForTeam(team);
		if(round){
			var teamInRound = round.getTeam(team.name);
			if(teamInRound.lostRound){
				html += "<td style = 'text-decoration: line-through;' class = 'tournamentCell' bgcolor='" +round.color + "'>"
			}else{
				html += "<td class = 'tournamentCell' bgcolor='" +round.color + "'>";
			}

			html += team.name + ": " +teamInRound.score();
			html += "<div class = 'mvp'><b>MVP:</b>  " + teamInRound.mvp_name + " with a power of: " + Math.round(teamInRound.mvp_score) + "</div>"
			html += " </td>";
		}else{ //was disqualified
			html += "<td></td>";
		}
	}
	html += "</tr>";
	return html;
}





//hide the teams and button. randomize the teams and reDescribe them to show new order.
//render AB in center, facing left team.
//then, render first team on left of AB, and second team on right of AB.
//then, pass first team to AB (upgrade her to have 'url params' from var as well as actual window location.)
//number to simulate is 10.
//when each session is done, need to call a callback in this file instead of printSTats or whatever (minor AB upgrade)
//callback should note if win (+1 to displayed score), or if grimDark crash (-1 to displayed score, AB flashes corrupt red.)  should also pass MVP value and title (wanna keep track of.)
//when done, callback to this page so it knows to start next team. AB faces right. repeat.
//when both teams done, compare scores, show winner, and strikethrough loser.
//queue up next 2.
//when done, erase all losers, and start again with new teams (teamsGlobalVar should be object[], not string[])
dynamic startTournament(){
	if (startingTeams.length == 0) setStartingTeams();; //don't THINK i have to make a copy of it, because i just throw away old array when i'm done, i don't modify it.
	currentTier = new Tier(); //add rounds to it as it goes on.
	resetColors();
	tierNumber ++;
	querySelector("#currentTier").html("Current Tier: " + tierNumber);
	lastTeamIndex = -2;
	querySelector("#teams").hide();
	querySelector("#roundTitle").css('display', 'inline-block');
	querySelector("#team1").css('display', 'inline-block');
	querySelector("#ab").css('display', 'inline-block');
	querySelector("#team2").css('display', 'inline-block');
	//render team 1 and team2
	teamsGlobalVar = shuffle(teamsGlobalVar); //if these were svgs, could be animated???
	makeDescriptionList();
	displayTeamsTournament(querySelector("#description"+tierNumber));
	querySelector("#tournamentButtonDiv").hide();
	if(teamsGlobalVar.length == 1) return missionComplete();
	startRound();
}



void missionComplete(){
	//have some sort of css pop up with winner, hide tournament, show all team descriptions (hopefully in horizontally scrolling line)
	currentTier.rounds.add(new Round(teamsGlobalVar[0], null,takeColor()));  //so i can display winner.
	tiers.add(currentTier);
	querySelector("#tournament").hide();
	querySelector("#winner").html("<h1>Winner: " + teamsGlobalVar[0].name+"</h1>");
	//showAllTiers();
	hideAllTiers();
	createEndingTable();
}



void hideAllTiers(){
	for(num i = 1; i<(tierNumber+1); i++){
		//querySelector("#description"+(i)).css('display', 'inline-block');
		querySelector("#description"+(i)).prepend("Tier: " + (i)); //label
		querySelector("#description"+(i)).hide();
	}
}



void showAllTiers(){
	for(num i = 1; i<(tierNumber+1); i++){
		//querySelector("#description"+(i)).css('display', 'inline-block');
		querySelector("#description"+(i)).prepend("Tier: " + (i)); //label
		querySelector("#description"+(i)).show();
	}
}



void makeDescriptionList(){
	String divHTML = "<div class = 'descriptionBox' id = 'description"+tierNumber +  "'></div>";
	querySelector("#descriptions").append(divHTML);

	querySelector("#description"+(tierNumber-1)).hide(); //only current is shown.
}



void startRound(){
	setTimeout((){
		startRoundPart2();
	},1000);
}



dynamic startRoundPart2(){
	lastTeamIndex += 2;
	if(lastTeamIndex >= teamsGlobalVar.length) return doneWithTier();
	var team1 = teamsGlobalVar[lastTeamIndex];
	var team2 = teamsGlobalVar[lastTeamIndex+1]  ;//if no team 2, they win???;
	if(team2 == null) return doneWithRound();
	String team1Title = "<span class = 'vsName' id = 'team1Title'>"+ team1 + "</span>";
	String team2Title = "<span class = 'vsName' id = 'team2Title'>"+ team2 + "</span>";
	querySelector("#roundTitle").html(team1Title +" vs " + team2Title);
	renderTeam(team1, querySelector("#team1"));
	renderTeam(team2, querySelector("#team2"));
	clearTeam(querySelector("#team1"))
	clearTeam(querySelector("#team2"))
	abLeft();
	fight();
}



dynamic takeColor(){
	var color = getRandomElementFromArray(remainingColors);
	remainingColors.removeFromArray(color);
	return color;
}




dynamic doneWithRound(){
	var team1 = teamsGlobalVar[lastTeamIndex];
	var team2 = teamsGlobalVar[lastTeamIndex+1];
	currentTier.rounds.add(new Round(team1, team2,takeColor()));
	if(!team2) return doneWithTier();
	if(team1.score() > team2.score()){
		team2.lostRound = true;
	}else if(team1.score() < team2.score()){
		team1.lostRound = true;
	}else{
		team1.lostRound = false;
		team2.lostRound = false; //tie.
	}

	if(team1.lostRound){
		var listDiv = querySelector("#"+team1.name+tierNumber);
		var roundDiv = querySelector("#team1");
		markLoser(listDiv);
		markLoser(roundDiv);
	}
	if(team2.lostRound){
		var listDiv = querySelector("#"+team2.name+tierNumber);
		var roundDiv = querySelector("#team2");
		markLoser(listDiv);
		markLoser(roundDiv);
	}
	startRound();
}




void clearTeam(teamDiv){
	teamDiv.removeClass("loser");
}



void markLoser(loser){
	////print("marking loser");
	////print(loser);
	loser.addClass("loser");
}



void doneWithTier(){
	//remove all losers. clear out all "wonRounds" rerender Combatants. start round up with lastTeamIndex of 0.
	//alert("ready for round " + (tierNumber+1) + "?")
	tiers.add(currentTier);
	removeLosers();
	startTournament();
}



void removeLosers(){
	List<dynamic> toSave = [];
	for(num i = 0; i<teamsGlobalVar.length; i++){
		var team = teamsGlobalVar[i];
		if(team.lostRound){
			//do nothing.
		}else{
			team = team.resetStats(); //<--otherwise will think they are done nxt round casue already did 10 sessions.
			toSave.add(team);
		}
	}
	teamsGlobalVar = toSave;
}



dynamic fight(){
	querySelector("#story").html("");
	initial_seed = getRandomSeed(); //pick a random session
	Math.seed = initial_seed;
	var team = teamsGlobalVar[lastTeamIndex];
	if(team.numberSessions >= numSimulationsToDo){
			team = teamsGlobalVar[lastTeamIndex+1];
			////print("switiching teams in fight");
	}
	////print("number of sessions for team: " + team + " is " + team.numberSessions);

	if(team.numberSessions >= numSimulationsToDo) return doneWithRound();
	//var team2 = teamsGlobalVar[lastTeamIndex+1]  ;//if no team 2, they win???;
	String selfInsert = "";
	if(!isClassOrAspectStuck(team)) selfInsert = "&selfInsertOC=true"
	simulatedParamsGlobalVar = team.name + "=true"+selfInsert; //which session are we checking?
	startSession(aBCallBack);
}



//don't add selfInsertOC to claspect stuck
dynamic isClassOrAspectStuck(team){
	var stuck = team.name.split("Stuck");
	return stuck.length == 2;
}



//what will happen if scratch? Will it return here still?;
//need to make sure scratched sessions don't count. (they get stat boost after all)
dynamic aBCallBack(sessionSummary){
	if(abj) return abjCallBack(sessionSummary);
	var team = teamsGlobalVar[lastTeamIndex];
	num teamNum = 1;
	if(team.numberSessions >= numSimulationsToDo){
		////print("switching to team 2 in callback");
		teamNum = 2;
		team = teamsGlobalVar[lastTeamIndex+1];
		abRight();
	}else{
		abLeft();
	}
	team.numberSessions ++;
	if(sessionSummary.won) team.win ++;
	if(sessionSummary.crashedFromPlayerActions){
		 team.crash ++;
		//grim dark ab turnways if 1
		if(teamNum == 1){
			abLeft(true);
		}else{
			abRight(true);
		}
	}else{
		if(teamNum == 1){
			abLeft();
		}else{
			abRight();
		}
	}
	if(sessionSummary.mvp.getStat(Stats.POWER) > team.mvp_score){
		team.mvp_name = sessionSummary.mvp.htmlTitle();
		team.mvp_score = sessionSummary.mvp.getStat(Stats.POWER);
	}

	if(team.mvp_score > mvpScore){
		mvpScore = team.mvp_score;
		mvpName = team.mvp_name;
	}
	renderTeam(team, querySelector("#team"+teamNum));
	renderGlobalMVP();
	fight();

}



void abjCallBack(sessionSummary){
	////print(sessionSummary);
	var team = teamsGlobalVar[lastTeamIndex];
	num teamNum = 1;
	if(team.numberSessions >= numSimulationsToDo){
		////print("switching to team 2 in callback");
		teamNum = 2;
		team = teamsGlobalVar[lastTeamIndex+1];
		abRight();
	}else{
		abLeft();
	}
	team.numberSessions ++;
	if(sessionSummary.numLiving == 0) team.numTotalPartyWipe ++;
	if( sessionSummary.numLiving == 0){
		//grim dark ab turnways if 1
		if(teamNum == 1){
			abLeft(true);
		}else{
			abRight(true);
		}
	}else{
		if(teamNum == 1){
			abLeft();
		}else{
			abRight();
		}
	}
	if(sessionSummary.mvp.getStat(Stats.POWER) > team.mvp_score){
		team.mvp_name = sessionSummary.mvp.htmlTitle();
		team.mvp_score = sessionSummary.mvp.getStat(Stats.POWER);
	}

	if(team.mvp_score > mvpScore){
		mvpScore = team.mvp_score;
		mvpName = team.mvp_name;
	}
	renderTeam(team, querySelector("#team"+teamNum));
	renderGlobalMVP();
	fight();

}



void renderGlobalMVP(){
	querySelector("#globalMVP").html("Overall MVP:  " + mvpName + " with a power of: " + mvpScore +"<br>");
}



void abLeft(glitch){
	if(abj){
		if(glitch){
			querySelector("#avatar").attr("src", "images/abj_interesting_turnways.png");
		}else{
			querySelector("#avatar").attr("src", "images/authorbot_jr_scout_turnways.png");
		}
	}else{
		if(glitch){
			querySelector("#avatar").attr("src", "images/guide_bot_turnways_glitch.gif");
		}else{
			querySelector("#avatar").attr("src", "images/guide_bot_turnways.png");
		}
	}

	querySelector("#team1Title").css("color", "red");
	querySelector("#team2Title").css("color", "black");
}



void abRight(glitch){

	if(abj){
		if(glitch){
			querySelector("#avatar").attr("src", "images/abj_interesting.png");
		}else{
			querySelector("#avatar").attr("src", "images/authorbot_jr_scout.png");
		}
	}else{

		if(glitch){
			querySelector("#avatar").attr("src", "images/guide_bot_glitch.gif");
		}else{
			querySelector("#avatar").attr("src", "images/guide_bot.png");
		}
	}

	querySelector("#team2Title").css("color", "red");
	querySelector("#team1Title").css("color", "black");
}



dynamic renderTeam(team, div){
	if(abj) return renderTeamABJ(team, div);
	String num = "# of Sessions: " + team.numberSessions;
	String win = "<br># of Won Sessions: " + team.win;
	String crash = "<br> # of GrimDark Crash Sessions: " + team.crash;
	String score = "<br><h1>Score:  " + team.score() + "</h1><hr>";
	String mvp = "<br>MVP:  " + team.mvp_name + " with a power of: " + team.mvp_score;
	if(team.lostRound){
		div.css("text-decoration", "overline;");
	}
	div.html("<div class = 'scoreBoard'>" + score + num + win + crash + mvp + "</div>");
	querySelector("#score_" + team.name+tierNumber).html("<B>Score</b>: " + team.score());
	querySelector("#mvp_" + team.name+tierNumber).html("<b>MVP:</b>  " + team.mvp_name + " with a power of: " + team.mvp_score);
}



void renderTeamABJ(team, div){
	String num = "# of Sessions: " + team.numberSessions;
	String win = "<br># of Total Party Wipes: " + team.numTotalPartyWipe;
	String score = "<br><h1>Score:  " + team.score() + "</h1><hr>";
	String mvp = "<br>MVP:  " + team.mvp_name + " with a power of: " + team.mvp_score;
	if(team.lostRound){
		div.css("text-decoration", "overline;");
	}
	div.html("<div class = 'scoreBoard'>" + score + num + win  + mvp + "</div>");
	querySelector("#score_" + team.name+tierNumber).html("<B>Score</b>: " + team.score());
	querySelector("#mvp_" + team.name+tierNumber).html("<b>MVP:</b>  " + team.mvp_name + " with a power of: " + team.mvp_score);
}





//all selected tiers will render example chars and a text explanation.handle up to ALL chosen.
//KnightStuck: randomly generated players that are forced to be Knights only.
//IF use rare session finder, will have to have params ALSO able to come internally, not just from url
//fighters chosen become a "bracket"
//do i want symbols for teams?
void displayPotentialFighters(){
	//tiers are EXACTLY the same name as the param, so can generate a "URL" of the right format, for AB to check.
	var fanTeams = ["reddit","tumblr","discord","creditsBuckaroos","ideasWranglers","patrons","patrons2","patrons3","canon","otherFandoms","creators"];
	var classTeams = ["KnightStuck", "SeerStuck","BardStuck","HeirStuck","MaidStuck","RogueStuck","PageStuck","ThiefStuck","SylphStuck","PrinceStuck","WitchStuck","MageStuck"];
	var aspectTeams = ["BloodStuck", "MindStuck","RageStuck","VoidStuck","TimeStuck","HeartStuck","BreathStuck","LightStuck","SpaceStuck","HopeStuck","LifeStuck","DoomStuck"];
	var teams = fanTeams.concat(classTeams);
	teams = teams.concat(aspectTeams);
	String html = "<b>Choose Combatants!</b><Br><select multiple size = '" + teams.length + "' id = 'tiers' name='tier'>";
	for(num i = 0; i< teams.length; i++){
			html += '<option value="' + teams[i] +'">' + teams[i]+'</option>'
	}
	html += '</select>';
	querySelector("#teams").append(html);
	wireUpTeamSelector();
}



void wireUpTeamSelector(){
	querySelector("#teams").change(() {
		teamsGlobalVar = [];
		querySelector('#teams :selected').each((i, selected){
			teamsGlobalVar.add(new Team(querySelector(selected).text(), abj));
		});
		displayTeams(querySelector("#description"+tierNumber));
		querySelector("#tournamentButtonDiv").css('display', 'inline-block');
	});

}



//oncoe tournament starts, div should be unique for that tier
void displayTeams(Element div){
	//when teams are displayed, also make sure button to start tournament is displayed. Hides team selector, shows AB in middle, with current fighters on either sidebar
	//points go up with each won session, AB glitches red with each grim dark crash and a point is lost.
	//loser is crossed off from team description, and next pair go.
	String html = "";

	for(num i = 0; i < teamsGlobalVar.length; i++){
		html +=displayTeamInList(teamsGlobalVar[i]);
	}
	div.html(html);

}



//pairs teams up instead of straight line.
void displayTeamsTournament(Element div){
	//when teams are displayed, also make sure button to start tournament is displayed. Hides team selector, shows AB in middle, with current fighters on either sidebar
	//points go up with each won session, AB glitches red with each grim dark crash and a point is lost.
	//loser is crossed off from team description, and next pair go.
	String html = "<div>"; //empty so that can end it for i = 0;

	for(num i = 0; i < teamsGlobalVar.length; i++){
		if(i%2 == 0){
			html += "</div><div class = 'twoTeams'>"
		}
		html +=displayTeamInList(teamsGlobalVar[i]);
	}
	if(teamsGlobalVar.length %2 != 0) html += "</div>" ;//didn't get closed;

	div.html(html);

}



dynamic displayTeamInList(team){
	String html = "";
	String divStart = "<div id = '" +team.name + tierNumber+"' class = 'teamDescription'>";
	String divEnd = "</div>";
	html += divStart + getTeamDescription(team) + divEnd;
	return html;
}



//when tournament starts up, drop down is set to none, and this is left most thing.
dynamic getTeamDescription(team){
	var stuck = team.name.split("Stuck");
	if(tierNumber > 0) return team.name + ": <div class = 'score' id = 'score_" + team.name + tierNumber +"'></div>";
	if(stuck.length == 2) return "<h2>" +stuck[0] +"Stuck</h2> <div id = 'score_" + team.name + tierNumber +"'></div><div id = 'mvp_" + team.name + tierNumber +"'></div><hr> A random team of only  " + stuck[0] + " Players. (With Time/Space guaranteed)";

	return "<h2>" + team + "</h2><div id = 'score_" + team.name + tierNumber+"'></div><div id = 'mvp_" + team.name + tierNumber +"'></div> <hr>Players chosen randomly from the " + team + " fan OCs";

}



//who fought in this tier
class Tier {
	List<dynamic> rounds = [];	


	Tier(this.) {}


	dynamic findRoundForTeam(team){
		for(num i = 0; i<this.rounds.length; i++){
			if(this.rounds[i].hasTeam(team)) return this.rounds[i];
		}
	}

}



//who found in this round.
class Round {
	var team1;
	var team2;
	var color;	


	Round(this.team1, this.team2, this.color) {}


	bool hasTeam(team){
		if(!team) return false;
		if(this.team1.name == team.name || (this.team2 && this.team2.name == team.name)) return true;
		return false;
	}
	dynamic getTeam(teamName){
		if(teamName == this.team1) return this.team1;
		if(teamName == this.team2) return this.team2;
		return null;

	}

}




class Team {
	var name;
	num numberSessions = 0;
	num win = 0;
	num numTotalPartyWipe = 0; //only stat ABJ cares about.
	num crash = 0;
	String mvp_name = "";
	num mvp_score = 0;
	var abj;
	bool lostRound = false; //set to true if they lost.  cause them to render different.

	//DEPRECATED
	


	Team(this.name, this.abj) {}


	void resetStatsDEPRECATED(){
		this.numberSessions = 0;
		this.win = 0;
		this.numTotalPartyWipe = 0;
		this.crash = 0;
		this.mvp_name = "";
		this.mvp_score = 0;
		this.lostRound = false;
	}
	void resetStats(){
		return new Team(this.name, this.abj);
	}
	dynamic score(){
		if(this.abj) return this.numTotalPartyWipe;
		return this.win - this.crash;
	}
	void scoreABJ(){
		this.numTotalPartyWipe;
	}
	dynamic toString(){
		return this.name;
	}

}

*/