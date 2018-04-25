import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";


Element div;
UListElement todoElement;
BigBad bigBad = new BigBad("Sample Big Bad", new Session(-13));
void main() {
  loadNavbar();
  globalInit();
  bigBad.session.setupMoons();

  div = querySelector("#story");
  todoElement = new UListElement();
  todoElement.style.border = "1px";
  div.append(todoElement);
  /**
   *  * Add flavor text to SummonScenes
   * Add effects to SerializableScenes
   * Text doc of a few Big Bads
   * BUG FIXES
   * Branch Main and Experimental
   * Big Bad Activation Loop
   * Test for crashes
   * Teach ShogunBot how to make cards for non Carapace Big Bads
   * Find sessions where the current Big Bads are being summoned
   */
  todo("oh god no burn it to the ground, also when rebuilding carapace trigger, have 'any' as option or a specific one");
  todo("serializable scenes have a bool for first or all targets");
  todo("be able to remove triggers from scene, put into TargetCondition (living or land) parent class (i thought i did this)");
  todo("big bads have intro mod flavor text (like dystopic empire)");
  todo("scenes should flavor text with replaceable words and shit. (how to do with such complex triggers?)");
  todo("scenes should have effects, summon scenes all start with 'is active'");
  todo("text doc of big bads");
  todo("split main and experimental");
  todo("big bad activation loop");
  todo("teach shogunbot how to make non carapace cards");
  todo("When a BIG BAD is activated, you can see their image as a img tag");
  todo("find a test sessions where big bad is summoned");
  todo("big bads need 0 or more custom fraymotif names");
  todo("big bads need low, medium, high values for all stats. what am i saying i mean 'Planetary, Galactic, Cosmic'. sorry about that, shogun");
  todo("have anything flagged as a big bad be something players try to strife, if it seems defeatable");
  todo("any CROWNED CARAPACE that has killed a player is flagged as big bad");
  todo("any unconditionally immortal player that has killed a player is flagged as big bad");
  todo("FORM BUG: big bad needs to be in default state before loading still, need to refresh page to clear shit out");
  todo("big bads have outro mod flavor text (if they aren't defeated, how do they effect child universe, like dystopic empire)");
  todo("side apps, like big bad gotcha, or big bad betting battles");
  todo("can lands be resurrected? if so, instead of nulling them out on destruction, maybe i should .dead them? what all would i have to change for that? questing, at the very least. space player frog shit...");

  setUpForm();

}

void setUpForm() {
  DivElement formElement = new DivElement();
  div.append(formElement);
  bigBad.drawForm(formElement);
}


void todo(String todo) {
  LIElement tmp = new LIElement();
  tmp.setInnerHtml("TODO: $todo");
  todoElement.append(tmp);
}




