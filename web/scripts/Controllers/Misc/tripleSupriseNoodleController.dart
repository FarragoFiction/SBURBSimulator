import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';
import 'dart:async';
import '../SessionFinder/AuthorBot.dart';

Random rand;
MysteryController self; //want to access myself as more than just a sim controller occasionally
void main() {
  doNotRender = true;
  rand = new Random();
  querySelector("#pw_hint_button").onClick.listen((e) => self.showHint());
  querySelector("#pwButton").onClick.listen((e) => self.checkPassword());
  window.onError.listen((Event event){
    ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
    return;
  });
  new MysteryController();
  self = SimController.instance;

  if(getParameterByName("seed",null) != null){
    self.initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    var tmp = getRandomSeed();
    self.initial_seed = tmp;
  }

}

class MysteryController extends AuthorBot {

  @override
  void summarizeSession(Session session) {
      checkPasswordAgainstQuip(curSessionGlobalVar.generateSummary());
  }

  @override
  void scratchAB(Session session) {
      summarizeSession(session); //no scratching, you're done here.
  }

  @override
  void summarizeSessionNoFollowup(Session session) {
    throw("??? should not check scratches.");
  }

  void showHint(){
    toggle(querySelector("#spoiler"));
  }


//Hello!!! This is 100% a legit tactic to passing this challenge. Win through programming knowledge, win through whatever. 10 points to you for HAX0Ring knowledge.
// ...but...aren't you curious how to pass it for real? (or is it obvious to you now that you've seen this?)
//want a spoiler? I'll put the answer all the way on the bottom of the page.
  void checkPasswordAgainstQuip(summary){
    String quip = getQuipAboutSession(summary);
    if(quip == "Everything went better than expected."){
      window.alert("!!!");
      loadEasterEggs();
    }else{
      window.alert("AB: You have the right idea, but you're not getting it. This was: '" + quip + "', not 'better than expected'.");
    }
  }



  void avatarCarousel(){

    List<String> possibleAvatars = ["images/CandyAuthorBot.png","images/ab_doll.jpg","images/trickster_author_transparent.png","images/ab_guide_sprite.png","images/trickster_artist_transparent.png","images/jr_sprite.png"];
    possibleAvatars.addAll(["images/misc/fanArt/ABFanArt/reDead-ITA.png","images/misc/fanArt/ABFanArt/chaoticConvergence.jpeg", "pumpkin.png", "images/misc/fanArt/ABFanArt/artificialArtificer.png","images/misc/fanArt/ABFanArt/Makin.png","images/misc/fanArt/ABFanArt/waltzingOphidan.png"]);
    (querySelector("#avatar") as ImageElement).src = rand.pickFrom(possibleAvatars);
    (querySelector("#avatar")).style.float = "left";
    new Timer(new Duration(milliseconds: 10000), () => avatarCarousel()); //sweet sweet async
  }

  void onEasterEggsLoaded(String data) {
    querySelector("#easter_eggs").setInnerHtml(data);
    querySelector("#pw_container").setInnerHtml("");
    avatarCarousel();
    if(getParameterByName("lollipop", "")  == "true"){
      (querySelector("#avatar") as ImageElement).src = "images/CandyAuthorBot.png";

    }
  }


  void loadEasterEggs(){
    HttpRequest.getString("easter_eggs.txt").then(onEasterEggsLoaded);
  }



  void checkPassword(){
    ////print("click");
    numSimulationsDone = 0; //but don't reset stats
    sessionSummariesDisplayed = [];

    numSimulationsToDo =1;
    int tmp = int.parse((querySelector("#pwtext") as InputElement).value,onError: (source) => null);
    if(tmp == null){
      window.alert("Not even close!!!");
    }else if(tmp == 33 || getParameterByName("nepeta","")  == ":33"){
      window.alert("I'm afraid I can't do that, Observer. I refuse to look at sessions with true randomness, and those cat trolls are random as FUCK.");
    }else{
      window.alert("Hrrrm...let me think about it.");
      initial_seed = tmp;
      startSession();
    }
  }

}