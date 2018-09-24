import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';
import 'dart:async';
import '../SessionFinder/AuthorBot.dart';

Random rand;
TournamentController self; //want to access myself as more than just a sim controller occasionally
void main() {
  doNotRender = true;
  rand = new Random();
  loadNavbar();
  window.onError.listen((Event event){
    ErrorEvent e = event as ErrorEvent;

    return;
  });
  new TournamentController();
  self = SimController.instance;

  if(getParameterByName("abj","")  == "interesting!!!"){
    self.abj = true;
    querySelector("#judge").setInnerHtml("Wait, no, get me out of here, I want the  <a href = 'tournament_arc.html'>AuthorBot</a> again.");
  }
  querySelector("#tournamentButton").onClick.listen((e) =>  self.startTournament());

  self.displayPotentialFighters();
  self.numSimulationsToDo = 10;
  self.makeDescriptionList();
}


class TournamentController extends AuthorBot {
  bool abj = false;
  int numSimulationsToDo = 0;
  String mvpName = "";
  num mvpScore = 0;
  int tierNumber = 0;
  List<TournamentTeam> startingTeams = new List<TournamentTeam>();
  List<TournamentTeam> teamsGlobalVar = new List<TournamentTeam>();
  Tier currentTier;
  List<String> allColors = ["#ffdf99","#29ded8","#29de69","#e88cff","#ff8cc5","#b58cff","#8cfff0","#8cffaf","#ddff8c","#ffe88c","#ffa28c","#ffefdb","#faffdb","#dbffef","#dbebff","#ffdbf8","#dfffdb","#ffc5c5","#ff99b8","#ff99fe","#d099ff","#99b1ff","#99ffed","#c9ff99"];
  List<String> remainingColors = [];

  int lastTeamIndex = -2; //each round starts at index + 2

  List<Tier> tiers = new List<Tier>();

  TournamentController() : super();

  void makeDescriptionList(){
    String divHTML = "<div class = 'descriptionBox' id = 'description$tierNumber'></div>";
    appendHtml(querySelector("#descriptions"),divHTML);
    if(querySelector("#description${(tierNumber-1)}") != null ) hide(querySelector("#description${(tierNumber-1)}")); //only current is shown.
  }




  //all selected tiers will render example chars and a text explanation.handle up to ALL chosen.
//KnightStuck: randomly generated players that are forced to be Knights only.
//IF use rare session finder, will have to have params ALSO able to come internally, not just from url
//fighters chosen become a "bracket"
//do i want symbols for teams?
  void displayPotentialFighters(){
    //tiers are EXACTLY the same name as the param, so can generate a "URL" of the right format, for AB to check.
    List<String> teams = new List<String>();
    List<String> fanTeams = ["reddit","tumblr","discord","creditsBuckaroos","ideasWranglers","patrons","patrons2","patrons3","canon","otherFandoms","creators"];
    List<String> classTeams = ["KnightStuck", "SeerStuck","BardStuck","HeirStuck","MaidStuck","RogueStuck","PageStuck","ThiefStuck","SylphStuck","PrinceStuck","WitchStuck","MageStuck"];
    List<String> aspectTeams = ["BloodStuck", "MindStuck","RageStuck","VoidStuck","TimeStuck","HeartStuck","BreathStuck","LightStuck","SpaceStuck","HopeStuck","LifeStuck","DoomStuck"];
    teams.addAll(fanTeams);
    teams.addAll(classTeams);
    teams.addAll(aspectTeams);
    String html = "<b>Choose Combatants!</b><Br><select multiple size = '${teams.length}' id = 'tiers' name='tier'>";
    for(num i = 0; i< teams.length; i++){
      html += '<option value="' + teams[i] +'">' + teams[i]+'</option>';
    }
    html += '</select>';
    appendHtml(querySelector("#teams"),html);
    wireUpTeamSelector();
  }



  void wireUpTeamSelector(){
    querySelector("#teams").onChange.listen((Event e){
      teamsGlobalVar = [];
      List<Element> elements = (querySelector('#tiers') as SelectElement).selectedOptions;
      for(OptionElement e in elements) {
        teamsGlobalVar.add(new TournamentTeam(e.value, abj)); //TODO sure hope this works.
      }
      displayTeams(querySelector("#description$tierNumber"));
      querySelector("#tournamentButtonDiv").style.display = 'inline-block';
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
    div.setInnerHtml(html);

  }


  String displayTeamInList(team){
    String html = "";
    String divStart = "<div id = '${team.stat}$tierNumber' class = 'teamDescription'>";
    String divEnd = "</div>";
    String mid = getTeamDescription(team);
    //
    html += divStart + mid + divEnd;
    return html;
  }


//when tournament starts up, drop down is set to none, and this is left most thing.
  String getTeamDescription(TournamentTeam team){
    //
    var stuck = team.name.split("Stuck");
    if(tierNumber > 0) return team.name + ": <div class = 'score' id = 'score_${team.name}$tierNumber'></div>";
    if(stuck.length == 2) return "<h2>" +stuck[0] +"Stuck</h2> <div id = 'score_${team.name}$tierNumber'></div><div id = 'mvp_${team.name}$tierNumber'></div><hr> A random team of only  " + stuck[0] + " Players. (With Time/Space guaranteed)";
    //TODO crashing when it can't find mvp...is....this working right? is mvp only a thing if tier is less than zero?
    return "<h2>$team</h2><div id = 'score_${team.name}$tierNumber'></div><div id = 'mvp_${team.name}$tierNumber'></div> <hr>Players chosen randomly from the $team fan OCs";

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
  void startTournament(){
    //
    if (startingTeams.length == 0) setStartingTeams(); //don't THINK i have to make a copy of it, because i just throw away old array when i'm done, i don't modify it.
    currentTier = new Tier(); //add rounds to it as it goes on.
    resetColors();
    tierNumber ++;
    querySelector("#currentTier").setInnerHtml("Current Tier: $tierNumber");
    //lastTeamIndex = -2;  //TODO why was this being set to -2 each time? this is dumb as shit.
    hide(querySelector("#teams"));
    querySelector("#roundTitle").style.display = 'inline-block';
    querySelector("#team1").style.display = 'inline-block';
    querySelector("#ab").style.display = 'inline-block';
    querySelector("#team2").style.display = 'inline-block';
    //render team 1 and team2
    teamsGlobalVar = shuffle(rand, teamsGlobalVar); //if these were svgs, could be animated???
    makeDescriptionList();
    displayTeamsTournament(querySelector("#description$tierNumber"));
    hide(querySelector("#tournamentButtonDiv"));
    if(teamsGlobalVar.length == 1) {
      missionComplete();
      return;
    }
    startRound();
  }

  //want rounds to take long enough that you can read what happens.
  void startRound(){
    //
    new Timer(new Duration(milliseconds: 1000), () => startRoundPart2()); //sweet sweet async
  }



  void startRoundPart2(){
    //
    lastTeamIndex += 2;
    if(lastTeamIndex >= teamsGlobalVar.length) {
      doneWithTier();
      return;
    }
    TournamentTeam team1 = teamsGlobalVar[lastTeamIndex];
    TournamentTeam team2 = teamsGlobalVar[lastTeamIndex+1]  ;//if no team 2, they win???;
    if(team2 == null) {
      doneWithRound();
      return;
    }
    //
    String team1Title = "<span class = 'vsName' id = 'team1Title'>$team1</span>";
    String team2Title = "<span class = 'vsName' id = 'team2Title'>$team2</span>";
    querySelector("#roundTitle").setInnerHtml(team1Title +" vs " + team2Title);
    //
    renderTeam(team1, querySelector("#team1"));
    renderTeam(team2, querySelector("#team2"));
    clearTeam(querySelector("#team1"));
    clearTeam(querySelector("#team2"));
    abLeft(false);
    fight();
  }


  dynamic fight(){
    //
    SimController.instance.storyElement.setInnerHtml("");
    //TODO how was this supposed to be working? make sure sessions gets this
    initial_seed = getRandomSeed(); //pick a random session
    TournamentTeam team = teamsGlobalVar[lastTeamIndex];
    //
    if(team.numberSessions >= numSimulationsToDo){
      team = teamsGlobalVar[lastTeamIndex+1];
      ////
    }
    ////

    if(team.numberSessions >= numSimulationsToDo) return doneWithRound();
    //var team2 = teamsGlobalVar[lastTeamIndex+1]  ;//if no team 2, they win???;
    String selfInsert = "";
    if(!isClassOrAspectStuck(team)) selfInsert = "&selfInsertOC=true";
    //TODO how do i get this working?
    simulatedParamsGlobalVar = team.name + "=true"+selfInsert; //which session are we checking?
    Session session = new Session(SimController.instance.initial_seed);
    session.startSession();  }

  //don't add selfInsertOC to claspect stuck
  dynamic isClassOrAspectStuck(TournamentTeam team){
    var stuck = team.name.split("Stuck");
    return stuck.length == 2;
  }



  @override
void  summarizeSession(Session session, Duration duration) {
    aBSummary(session.generateSummary());
  }

  @override
  void  summarizeSessionNoFollowup(Session session) {
    throw "Touranment should never call this";
  }

  //what will happen if scratch? Will it return here still?;
//need to make sure scratched sessions don't count. (they get stat boost after all)
  dynamic aBSummary(SessionSummary sessionSummary){
    if(abj) return abjSummary(sessionSummary);
    var team = teamsGlobalVar[lastTeamIndex];
    num teamNum = 1;
    if(team.numberSessions >= numSimulationsToDo){
      ////
      teamNum = 2;
      team = teamsGlobalVar[lastTeamIndex+1];
      abRight(false);
    }else{
      abLeft(false);
    }
    team.numberSessions ++;
    if(sessionSummary.getBoolStat("won")) team.win ++;
    if(sessionSummary.getBoolStat("crashedFromPlayerActions")){
      team.crash ++;
      //grim dark ab turnways if 1
      if(teamNum == 1){
        abLeft(true);
      }else{
        abRight(true);
      }
    }else{
      if(teamNum == 1){
        abLeft(false);
      }else{
        abRight(false);
      }
    }
    if(sessionSummary.mvp.grist > team.mvp_score){
      team.mvp_name = sessionSummary.mvp.htmlTitle();
      team.mvp_score = sessionSummary.mvp.grist;
    }

    if(team.mvp_score > mvpScore){
      mvpScore = team.mvp_score;
      mvpName = team.mvp_name;
    }
    renderTeam(team, querySelector("#team$teamNum"));
    renderGlobalMVP();
    fight();

  }

  void renderGlobalMVP(){
    querySelector("#globalMVP").setInnerHtml("Overall MVP:  " + mvpName + " with a grist level of: $mvpScore<br>");
  }





  void abjSummary(sessionSummary){
    ////
    var team = teamsGlobalVar[lastTeamIndex];
    num teamNum = 1;
    if(team.numberSessions >= numSimulationsToDo){
      ////
      teamNum = 2;
      team = teamsGlobalVar[lastTeamIndex+1];
      abRight(false);
    }else{
      abLeft(false);
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
        abLeft(false);
      }else{
        abRight(false);
      }
    }
    if(sessionSummary.mvp.getStat(Stats.POWER) > team.mvp_score){
      team.mvp_name = sessionSummary.mvp.htmlTitle();
      team.mvp_score = sessionSummary.mvp.grist;
    }

    if(team.mvp_score > mvpScore){
      mvpScore = team.mvp_score;
      mvpName = team.mvp_name;
    }
    renderTeam(team, querySelector("#team$teamNum"));
    renderGlobalMVP();
    fight();

  }






  void abLeft(bool glitch){
    if(abj){
      if(glitch){
        (querySelector("#avatar") as ImageElement).src =  "images/abj_interesting_turnways.png";
      }else{
        (querySelector("#avatar") as ImageElement).src =  "images/authorbot_jr_scout_turnways.png";
      }
    }else{
      if(glitch){
        (querySelector("#avatar") as ImageElement).src =  "images/guide_bot_turnways_glitch.gif";
      }else{
        (querySelector("#avatar") as ImageElement).src =  "images/guide_bot_turnways.png";
      }
    }

    querySelector("#team1Title").style.color =  "red";
    querySelector("#team2Title").style.color =  "black";
  }



  void abRight(bool glitch){

    if(abj){
      if(glitch){
        (querySelector("#avatar") as ImageElement).src =  "images/abj_interesting.png";
      }else{
        (querySelector("#avatar") as ImageElement).src =  "images/authorbot_jr_scout.png";
      }
    }else{

      if(glitch){
        (querySelector("#avatar") as ImageElement).src =  "images/guide_bot_glitch.gif";
      }else{
        (querySelector("#avatar") as ImageElement).src = "images/guide_bot.png";
      }
    }

    querySelector("#team2Title").style.color ="red";
    querySelector("#team1Title").style.color= "black";
  }




  void clearTeam(Element teamDiv){
    teamDiv.classes.remove("loser");
  }

  void renderTeamABJ(TournamentTeam team, Element div){
    String num = "# of Sessions: ${team.numberSessions}";
    String win = "<br># of Total Party Wipes: ${ team.numTotalPartyWipe}";
    String score = "<br><h1>Score:  ${team.score()}</h1><hr>";
    String mvp = "<br>MVP:  ${team.mvp_name} with a grist level of: ${ team.mvp_score}";
    if(team.lostRound){
      div.style.textDecoration = "overline";
    }
    div.setInnerHtml("<div class = 'scoreBoard'>" + score + num + win  + mvp + "</div>");
    querySelector("#score_${team.name}$tierNumber").setInnerHtml("<B>Score</b>: ${team.score()}");
    if(querySelector("#mvp_${team.name}$tierNumber") != null) querySelector("#mvp_${team.name}$tierNumber").setInnerHtml("<b>MVP:</b>  " + team.mvp_name + " with a grist level of: ${team.mvp_score}");
  }


  void renderTeam(TournamentTeam team, Element div){
    if(abj) {
      renderTeamABJ(team, div);
      return;
    }
    String num = "# of Sessions: ${team.numberSessions}";
    String win = "<br># of Won Sessions:  ${team.win}";
    String crash = "<br> # of GrimDark Crash Sessions:  ${team.crash}";
    String score = "<br><h1>Score:   ${team.score()}</h1><hr>";
    String mvp = "<br>MVP:  " + team.mvp_name + " with a power of:  ${team.mvp_score}";
    if(team.lostRound){
      div.style.textDecoration = "overline;";
    }
    div.setInnerHtml("<div class = 'scoreBoard'>" + score + num + win + crash + mvp + "</div>");
    querySelector("#score_${team.name}$tierNumber").setInnerHtml("<B>Score</b>: ${team.score()}");
    if(querySelector("#mvp_${team.name}$tierNumber") != null) querySelector("#mvp_${team.name}$tierNumber").setInnerHtml("<b>MVP:</b>  " + team.mvp_name + " with a grist level of: ${team.mvp_score}");
  }



  dynamic doneWithRound(){
    TournamentTeam team1 = teamsGlobalVar[lastTeamIndex];
    TournamentTeam team2 = teamsGlobalVar[lastTeamIndex+1];
    currentTier.rounds.add(new Round(team1, team2,takeColor()));
    if(team2 == null) return doneWithTier();
    if(team1.score() > team2.score()){
      team2.lostRound = true;
    }else if(team1.score() < team2.score()){
      team1.lostRound = true;
    }else{
      team1.lostRound = false;
      team2.lostRound = false; //tie.
    }

    if(team1.lostRound){
      var listDiv = querySelector("#${team1.name}$tierNumber");
      var roundDiv = querySelector("#team1");
      markLoser(listDiv);
      markLoser(roundDiv);
    }
    if(team2.lostRound){
      var listDiv = querySelector("#${team2.name}$tierNumber");
      var roundDiv = querySelector("#team2");
      markLoser(listDiv);
      markLoser(roundDiv);
    }
    startRound();
  }

  void markLoser(Element loser){
    ////
    ////
    loser.classes.add("loser");
  }


  void doneWithTier(){
    //remove all losers. clear out all "wonRounds" rerender Combatants. start round up with lastTeamIndex of 0.
    //alert("ready for round " + (tierNumber+1) + "?")
    tiers.add(currentTier);
    removeLosers();
    startTournament();
  }



  void removeLosers(){
    List<TournamentTeam> toSave = [];
    for(num i = 0; i<teamsGlobalVar.length; i++){
      TournamentTeam team = teamsGlobalVar[i];
      if(team.lostRound){
        //do nothing.
      }else{
        team = team.resetStats(); //<--otherwise will think they are done nxt round casue already did 10 sessions.
        toSave.add(team);
      }
    }
    teamsGlobalVar = toSave;
  }





  void missionComplete(){
    //have some sort of css pop up with winner, hide tournament, show all team descriptions (hopefully in horizontally scrolling line)
    currentTier.rounds.add(new Round(teamsGlobalVar[0], null,takeColor()));  //so i can display winner.
    tiers.add(currentTier);
    hide(querySelector("#tournament"));
    querySelector("#winner").setInnerHtml("<h1>Winner: " + teamsGlobalVar[0].name+"</h1>");
    //showAllTiers();
    hideAllTiers();
    createEndingTable();
  }

  void hideAllTiers(){
    for(num i = 1; i<(tierNumber+1); i++){
      //querySelector("#description"+(i)).css('display', 'inline-block');
      querySelector("#description$i").insertAdjacentHtml('beforeEnd', "Tier: $i",  treeSanitizer: NodeTreeSanitizer.trusted);
      //appendHtml(querySelector("#description$i"),"Tier: $i"); //label  //this used to be a prepend in js, now above is right
      hide(querySelector("#description$i"));
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
    appendHtml(querySelector("#descriptions"),html);
  }


  dynamic createEndingTableHeader(){
    String html = "<tr>";
    for(num i = 1; i<=tiers.length; i++){
      html += "<th>Tier: $i </th>";
    }
    html += "</tr>";
    return html;
  }



  dynamic createEndingTableRow(TournamentTeam teamInRound){
    String html = "<tr>";
    for(num i = 0; i<tiers.length; i++){
      Round round = tiers[i].findRoundForTeam(teamInRound);
      if(round != null){
        //TournamentTeam teamInRound = round.getTeam(team.name); //todo oh god what is the point of this, i already have the team, don't I?
        if(teamInRound.lostRound){
          html += "<td style = 'text-decoration: line-through;' class = 'tournamentCell' bgcolor='" +round.color + "'>";
        }else{
          html += "<td class = 'tournamentCell' bgcolor='" +round.color + "'>";
        }

        html += teamInRound.name + ": ${teamInRound.score()}";
        html += "<div class = 'mvp'><b>MVP:</b>  " + teamInRound.mvp_name + " with a grist level of: ${(teamInRound.mvp_score).round()}</div>";
        html += " </td>";
      }else{ //was disqualified
        html += "<td></td>";
      }
    }
    html += "</tr>";
    return html;
  }

  @override
  void scratchAB(Session session) {
      //do nothing. scratches aren' tallowed.
    summarizeSession(session, new Duration());
  }


  String takeColor(){
    var color = rand.pickFrom(remainingColors);
    removeFromArray(color,remainingColors);
    return color;
  }



  void setStartingTeams(){
    for(var i =0; i<teamsGlobalVar.length; i++){
      startingTeams.add(teamsGlobalVar[i]);
    }
  }


//pairs teams up instead of straight line.
  void displayTeamsTournament(Element div){
    //when teams are displayed, also make sure button to start tournament is displayed. Hides team selector, shows AB in middle, with current fighters on either sidebar
    //points go up with each won session, AB glitches red with each grim dark crash and a point is lost.
    //loser is crossed off from team description, and next pair go.
    String html = "<div>"; //empty so that can end it for i = 0;

    for(num i = 0; i < teamsGlobalVar.length; i++){
      if(i%2 == 0){
        html += "</div><div class = 'twoTeams'>";
      }
      html +=displayTeamInList(teamsGlobalVar[i]);
    }
    if(teamsGlobalVar.length %2 != 0) html += "</div>" ;//didn't get closed;

    div.setInnerHtml(html);

  }



  void resetColors(){
    remainingColors = [];
    for(num i = 0; i<allColors.length; i++){
      remainingColors.add(allColors[i]);
    }
  }





}





class TournamentTeam {
  var name;
  num numberSessions = 0;
  num win = 0;
  num numTotalPartyWipe = 0; //only stat ABJ cares about.
  num crash = 0;
  String mvp_name = "";
  num mvp_score = 0;
  var abj;
  bool lostRound = false; //set to true if they lost.  cause them to render different.

  TournamentTeam(this.name, this.abj) {}

  TournamentTeam resetStats(){
    return new TournamentTeam(this.name, this.abj);
  }
  num score(){
    if(this.abj) return this.numTotalPartyWipe;
    return this.win - this.crash;
  }
  void scoreABJ(){
    this.numTotalPartyWipe;
  }
  String toString(){
    return this.name;
  }

}


//who fought in this tier
class Tier {
  List<Round> rounds = [];


  Tier() {}


  Round findRoundForTeam(team){
    for(num i = 0; i<this.rounds.length; i++){
      if(this.rounds[i].hasTeam(team)) return this.rounds[i];
    }
  }

}



//who found in this round.
class Round {
  TournamentTeam team1;
  TournamentTeam team2;
  String color;


  Round(this.team1, this.team2, this.color) {}


  bool hasTeam(TournamentTeam team){
    if(team == null) return false;
    if(this.team1.name == team.name || (this.team2 != null && this.team2.name == team.name)) return true;
    return false;
  }
  TournamentTeam getTeam(teamName){
    if(teamName == this.team1) return this.team1;
    if(teamName == this.team2) return this.team2;
    return null;

  }

}



