import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";
import "dart:async";


Element div;
SerializableScene scene = new SerializableScene(new Session(-13));
UListElement todoElement;
DivElement faqElement;
void main() {
  loadNavbar();
  start();

}

Future<Null> start() async {
  await globalInit();
  scene.session.setupMoons("BigBad setup");

  div = querySelector("#story");
  todoElement = new UListElement();
  todoElement.style.border = "1px solid black";
  div.append(todoElement);

  todo("ability to remove triggers/actions");
  todo("loaded scenes not fucking up if there were already triggers/actions");
  todo("ability to load a scene into a player/carapace for testing in the sessionCustomizer.");

  setUpForm();
  faqElement = new DivElement();
  faqElement.style.border = "1px solid black";
  faqElement.setInnerHtml("<h1>FAQ</h1>");
  div.append(faqElement);
  setupFAQ();
}

void setUpForm() {
  DivElement formElement = new DivElement();
  div.append(formElement);
  scene.renderForm(formElement);
}


void todo(String todo) {
  LIElement tmp = new LIElement();
  tmp.setInnerHtml("TODO: $todo");
  todoElement.append(tmp);
}

void setupFAQ() {
  //faq("","");
  faq("What is this for?","You (i.e. a wrangler) can make an individual scene here to give to JR. The scene will be assigned to a carapace or class or aspect. It will then be available for Entities in the system that hit a qualifying event (being crowned for a Carapace and becoming a Villain for a player). ");
  faq("How does this system work?","Entities have a list of scenes/actions they can do each turn. They work through them in order, and the first time they can complete an action that marks them as 'finished', they stop looking at other actions. <br><br>Thus, the higher up an action is in the list of scenes, the higher 'priority' it is. <br><br>My intent is to shuffle these created scenes before they are used to give the most unpredictable (yet logic based) AI routines for the entities possible.");
  faq("What is an Entity Target Condition?","When a scene decides whether or not it triggers, it takes all potential targets (i.e. any player or npc with AI (as opposed to things like consorts) and begins filtering them by all Entity Target Conditions in a scenes. <br><Br> For example, if you target isAlive, then all dead entities will be removed as valid targets. <br><br>Once all Entity Target conditions have been processed, if any Entity Targets remain (or any Land targets) the scene triggers and is displayed on screen and has an effect on the session.");
  faq("What is a Land Target Condition?","When a scene decides whether or not it triggers, it takes all potential targets (i.e. any player's land, as well as prospit and derse, and begins filtering them by all Land Target Conditions in a scenes. <br><Br> For example, if you target isMoon, then all Planets will be removed as valid targets. <br><br>Once all Land Target conditions have been processed, if any Land Targets remain (or any Entity targets) the scene triggers and is displayed on screen and has an effect on the session.");
  faq("What if I set NO Target Conditions?","The system considers it to be the same thing as saying 'there are no valid targets'. This is why if you leave Land Target Conditions blank, no lands are ever chosen, only Entities. <br><Br> If you want EVERYTHING to be valid, choose 'isRandom' with an odds of 100%");
  faq("What is an Entity Action Effect?","It is a single effect that is applied to ALL valid targets entities. <Br><Br>For example, a target might be killed, or have it's stats changed. Should you want it to apply to only a single target, chose the 'Target One Valid Target (vs target All Valid Targets)' option.");
  faq("What is a Land Action Effect?","It is a single effect that is applied to ALL valid target lands.<br><Br>For example, a land may be blown up, or have it's consorts modified. Should you want it to apply to only a single target, chose the 'Target One Valid Target (vs target All Valid Targets)' option.");
  faq("What is 'Append Target Name(s)'?","Unless you lock your target to being a single carapace, you can't predict ahead of time who will be targeted exactly. Pressing this button will allow a placeholder for the target (or targets) names to be added to the flavor text. ");
  faq("What is 'Append Scene Owner Name'?","Unless you are making a carapace scene, you can't know exactly who will own your scene when it finally gets on screen. Pressing this button will allow a placeholder for the scene owner's name to be added to the flavor text. ");
  faq("How does 'isRandom' work?","isRandom goes through each valid target and has an X% chance of selecting that target. Functionally, that means most of the time X% of valid targets will be chosen.<br><Br>Example: There is a 2% random filter on a scene. 3/100 valid targets are chosen to apply an effect to. <br><br>Further Example: There is a 2% random filter on a scene. 0/100 targets are chosen, and the scene does not trigger. The next scene in the list is then checked.");
  faq("Why isn't INSERT_FEATURE_HERE available?","Some things I just haven't gotten to yet. Some things would be too hard (or too rarely used) to justify implementing. Feel free to brainstorm things you might be needed, and I'll try to keep a list of things I plan on trying to get to ordered by priority.");
  faq("What if a Scene effects both Entities and Lands?","Then the effects for entities will apply to entities and the efects for Lands will apply to lands. ");
  faq("Can I script actions for a scene owner to take even if they are dead?","Sadly, no. The dead don't clog the system up with AI (which is why that lively corpses bug is so fucking confusing).");


}

void faq(String questionText, String answerText) {
  DivElement tmp = new DivElement();
  tmp.style.padding = "10px";
  tmp.style.margin = "10px";
  tmp.style.backgroundColor = "#bbbbbb";
  DivElement question = new DivElement();
  question.setInnerHtml("<b>Q: $questionText</b>");
  DivElement answer = new DivElement();
  answer.setInnerHtml("A: $answerText");

  tmp.append(question);
  tmp.append(answer);
  faqElement.append(tmp);
}


