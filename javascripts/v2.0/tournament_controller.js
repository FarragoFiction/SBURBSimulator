var charCreatorHelperGlobalVar;
var playersGlobalVar = [];
var easterEggEngineGlobalVar;
var simulationMode  = false;
var teamsGlobalVar = [];
window.onload = function() {
	$(this).scrollTop(0);
	loadNavbar();
	displayPotentialFighters();
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
function startTournament(){
	alert("!!!")
}

//all selected tiers will render example chars and a text explanation.handle up to ALL chosen.
//KnightStuck: randomly generated players that are forced to be Knights only.
//IF use rare session finder, will have to have params ALSO able to come internally, not just from url 
//fighters chosen become a "bracket"
//do i want symbols for teams?
function displayPotentialFighters(){
	//tiers are EXACTLY the same name as the param, so can generate a "URL" of the right format, for AB to check.
	var fanTeams = ["reddit","tumblr","discord","creditsBuckaroos","ideasWranglers","patrons","patrons2","patrons3","canon","otherFandoms","creators"];
	var classTeams = ["KnightStuck", "SeerStuck","BardStuck","HeirStuck","MaidStuck","RogueStuck","PageStuck","ThiefStuck","SylphStuck","PrinceStuck","WitchStuck","MageStuck"];
	var aspectTeams = ["BloodStuck", "MindStuck","RageStuck","VoidStuck","TimeStuck","HeartStuck","BreathStuck","ThiefStuck","SpaceStuck","HopeStuck","LifeStuck","DoomStuck"];
	var teams = fanTeams.concat(classTeams);
	var html = "<b>Choose Combatants!</b><Br><select multiple size = '" + teams.length + "' id = 'tiers' name='tier'>";
	for(var i = 0; i< teams.length; i++){
			html += '<option value="' + teams[i] +'">' + teams[i]+'</option>'
	}
	html += '</select>'
	$("#teams").append(html);
	wireUpTeamSelector();
}

function wireUpTeamSelector(){
	$("#teams").change(function() {
		teamsGlobalVar = [];
		$('#teams :selected').each(function(i, selected){
			teamsGlobalVar.push($(selected).text());
		});
		displayTeams();
	});
	
}

function displayTeams(){
	//when teams are displayed, also make sure button to start tournament is displayed. Hides team selector, shows AB in middle, with current fighters on either sidebar
	//points go up with each won session, AB glitches red with each grim dark crash and a point is lost.
	//loser is crossed off from team description, and next pair go.
	var html = "";
	var divStart = "<div class = 'teamDescription'>";
	var divEnd = "</div>";
	for(var i = 0; i < teamsGlobalVar.length; i++){
		html += divStart + getTeamDescription(teamsGlobalVar[i]) + divEnd;
	}
	$("#descriptions").html(html);
	$("#tournamentButtonDiv").css('display', 'inline-block');
}

//when tournament starts up, drop down is set to none, and this is left most thing.
function getTeamDescription(team){
	console.log("~~~~~~~~~~~~~~~~~~TODO~~~~~~~~~~~~~~~ have icon for each category.");
	var stuck = team.split("Stuck");
	if(stuck.length == 2) return "<h1>" +stuck[0] +"Stuck</h1> <hr> A random team of only  " + stuck[0] + "s. (With Time/Space guaranteed)"
	
	if(team == "reddit") return "<h1>reddit</h1><hr> Players chosen randomly from the reddit fan OCs."
	if(team == "tumblr") return "<h1>tumblr</h1><hr> Players chosen randomly from the tumblr fan OCs."
	if(team == "discord") return "<h1>discord</h1><hr> Players chosen randomly from the discord fan OCs."
	if(team == "creditsBuckaroos") return "<h1>creditsBuckaroos</h1><hr> Players chosen randomly from the creditsBuckaroos fan OCs."
	if(team == "ideasWranglers") return "<h1>ideasWranglers</h1><hr> Players chosen randomly from the ideasWranglers fan OCs."
	if(team == "patrons") return "<h1>patrons</h1><hr> Players chosen randomly from the patrons fan OCs."
	if(team == "patrons2") return "<h1>patrons2</h1><hr> Players chosen randomly from the patrons2 fan OCs."
	if(team == "patrons3") return "<h1>patrons3</h1><hr> Players chosen randomly from the patrons3 fan OCs."
	if(team == "canon") return "<h1>canon</h1><hr> Players chosen randomly from the canon fan OCs."
	if(team == "otherFandoms") return "<h1>otherFandoms</h1><hr> Players chosen randomly from the otherFandoms fan OCs."
	if(team == "creators") return "<h1>creators</h1><hr> Players chosen randomly from the creators fan OCs."
}