import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";
import "dart:async";


Element div;
UListElement todoElement;
BigBad bigBad = new BigBad("Sample Big Bad", new Session(-13));
void main() {
  loadNavbar();
  start();

}

Future<Null> start() async {
  await globalInit();
  bigBad.session.setupMoons("BigBad setup");

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

  todo("flavor text has a 'owner' tag after all, so that mind control can work (mind control is a list of scenes that an effect has, or a tag that it's a coy of the owner))");
  todo("maybe a bool for all target conditions for NOT. is NOT carapace, is NOT time player, etc.");
  todo("big bads need 0 or more custom fraymotif names");
  todo("big bads need low, medium, high values for all stats. what am i saying i mean 'Planetary, Galactic, Cosmic'. sorry about that, shogun");

  todo("make scene effects like kill, empower, drain, cause strife, order (add one new high priority scene), control (overwrite their ai to be my ai), spawn Savior (like troll kid rock)");
  todo("isAspect Player (any just checks for is a player)");
  todo("target condition: isMe (just makes a new list only containing game entity)");
  todo("isClass Player (any just checks for is a player)");
  todo("hasInterest (if they aren't a player automatically false)");
  todo("player effect, drain/add grist");
  todo("land condition: isMoon");
  todo("land condition: isLand");
  todo("land condition: isDestroyed");
  todo("land effect, rename land (can rename whole thing, reference original name, or parts of original name (first word, second word)");
  todo("figure out how effects will work (even summon scenes can have effects)");
  todo("hasSpritePrototypedWith (if they aren't a player automatically false)");
  todo("isPrototypedWith (for sprites or carapace with rings)");
  todo("isFromDystopia (i.e. Troll Empress)");
  todo("land condition: has trait X (like type of consorts or smells or whatever? think about this more) (use case: if a planet with crocodiles is destroyed, Crocodile Guardian arrives, pissed at Big Bads)");
  todo("maybe has word in land name (like Angels)");
  todo("isDead (would that even work?)");
  todo("isAlive (would that even work?)");
  todo("hasQuirk"); //bbb that hates unreadable quirks
  todo("isGodTier");
  todo("hasRelationshipWithMe (either 'any' or list of relatinships types");
  todo("land condition: isMeteored (i.e. reckoning is going)");
  todo("isGrimDark");
  todo("isUnconditionallyImmortal");
  todo("isDoomed");
  todo("isWasted");
  todo("isTrickster");
  todo("isDreamSelf");
  todo("isMurderMode");
  todo("isRobot");
  todo("isBrainGhost");
  todo("magical item that grants unconditional immortality to the wearer???");
  todo("scenes can have different outcome by being duplicated more or less with different triggers and effects ");
  todo("target based on 'recently broke up' or 'recently got together' with someone");




  todo("big bads have intro mod flavor text (like dystopic empire)");
  todo("scenes should have effects, summon scenes all start with 'is active'");
  todo("teach AB to write bigBadSummaries to cache");
  todo("have anything flagged as a big bad be something players try to strife, if it seems defeatable");
  todo("any CROWNED CARAPACE that has killed a player is flagged as big bad");
  todo("any unconditionally immortal player that has killed a player is flagged as big bad");
  todo("FORM BUG: big bad needs to be in default state before loading still, need to refresh page to clear shit out");
  todo("big bads have outro mod flavor text (if they aren't defeated, how do they effect child universe, like dystopic empire)");
  todo("more living conditions: is meta player, is god tier, is player, is Sprite, isRobot, is consort, is denizen, is alive, is dead, isAspect, isClass");
  todo("more land contions: owned by Aspect player,owned by Class player, owned by Meta Player, owned by God Tier, corrupt");
  todo("side apps, like big bad gotcha, or big bad betting battles");

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

