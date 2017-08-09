import '../SBURBSim.dart';
import '../navbar.dart';
import 'dart:html';
import 'dart:async';

Random rand;
TournamentController self; //want to access myself as more than just a sim controller occasionally
void main() {
  doNotRender = true;
  loadNavbar();
  window.onError.listen((Event event){
    ErrorEvent e = event as ErrorEvent;
    printCorruptionMessage(e);
    return;
  });
  new TournamentController();
  self = SimController.instance;

  if(getParameterByName("abj","")  == "interesting!!!"){
    self.abj = true;
    querySelector("#judge").setInnerHtml("Wait, no, get me out of here, I want the  <a href = 'tournament_arc.html'>AuthorBot</a> again.");
  }
  loadNavbar();
  self.displayPotentialFighters();
  self.numSimulationsToDo = 10;
  self.makeDescriptionList();
}


class TournamentController extends SimController {
  bool abj = false;
  int numSimulationsToDo = 0;
  int tierNumber = 0;

  TournamentController() : super();

  void makeDescriptionList(){
    String divHTML = "<div class = 'descriptionBox' id = 'description$tierNumber'></div>";
    appendHtml(querySelector("#descriptions"),divHTML);
    hide(querySelector("#description${(tierNumber-1)}")); //only current is shown.
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


}