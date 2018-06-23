import 'dart:html';
import "dart:async";

class TodoHandler {

  static String BIGBADTODO = "Big Bad TODO";
  static String SESSIONCUSTOMIZERTODO = "Session Customizer TODO";
  static String BUGFIXTODO = "Bug Fix TODO";

  static List<String> get allTODOs => <String>[BIGBADTODO, SESSIONCUSTOMIZERTODO, BUGFIXTODO];

   String header;
   Element container;
   UListElement highPriority;
   UListElement mediumPriority;
   UListElement lowPriority;

   TodoHandler(String this.header, DivElement div) {
    container = new DivElement();
    container.setInnerHtml("<h1>$header</h1>");
    div.append(container);
    setup();
   }



   void setup() {
    highPriority = new UListElement();
    highPriority.style.border = "3px solid red";
    highPriority.style.backgroundColor = "#ffd6d6";
    container.append(highPriority);

    mediumPriority = new UListElement();
    mediumPriority.style.border = "3px solid yellow";
    mediumPriority.style.backgroundColor = "#fffac3";

    container.append(mediumPriority);

    lowPriority = new UListElement();
    lowPriority.style.border = "3px solid green";
    lowPriority.style.backgroundColor = "#cdffce";

    container.append(lowPriority);
    
    if(header == BIGBADTODO) setupBigBadTODO();
    if(header == SESSIONCUSTOMIZERTODO) setupSessionCustomizerTODO();
    if(header == BUGFIXTODO) setupBugFixTODO();

   }
  
  void setupBugFixTODO() {
     todo("make AB sane",highPriority);
     todo("make sure custom sessions work both in general and with session customiser",highPriority);
  }
  
  void setupSessionCustomizerTODO() {
     todo("ability to serialize a land (for now just major parts, no traits).",highPriority);
     todo("ability to serialize a session (players, carapaces, big bads, etc)",highPriority);
     todo("press button, get datastring for land", highPriority);
     todo("create/destroy players", highPriority);
     todo("ability to save/load an entity (carapace, player, whatever)", highPriority);
     todo("load old session url maybe?",mediumPriority);
     todo("any loaded big bads should be part of serialized session",mediumPriority);
     todo("Sylladex Section lets you remove the selected item from the sylladex", highPriority);
     todo("can serialize a sylladex (just item numbers in allItems list, assume is stable)", highPriority);
     todo("can save a session to a .txt file", highPriority);
     todo("can load a session from a .txt file", highPriority);
     todo("if only one player, use dead session controller", mediumPriority);
     todo("make sure it works for special sessions like 13 or 413! (fix bugs in AB this caused)", highPriority);
     todo("Each Player has a QuirkSection that lets  you modify quirks.", mediumPriority);
     todo("players/carapaces get one custom fraymotif name (all custom fraymotifs just do everything at once)", mediumPriority);
     todo("PlayerSection lets you pick initial relationships. (drop down of types, drop down of targets)", highPriority);
     todo("Can give a session a Name.", lowPriority);
     todo("Can choose 13 sessions to save to localStorage (if they aren't too big? Only have 2.2 mb)", lowPriority);
     todo("can view list of your saved sessions, load them into this page, etc", lowPriority);
     todo("pretty everything up??? ask PL for help???", lowPriority);
  }

  void setupBigBadTODO() {
       todo("active/passive player targeting", mediumPriority);
       todo("GHAO/DQON: target condition (land or entity) entity named X is dead.  Need so GHAO summons DQON on death.(not dead just checksk for active and alive).", highPriority);
       todo("target players with a Disaster/Illegal/Corrupt sprite (diaster for rage virus)", highPriority);
       todo("shogun:ability to target entities with particular serializable scenes (lets me give them a scene and then target them, basically mark them as my minion)",highPriority);
       todo("MyStatIsGreaterThanValue as a land filter, tg says", highPriority);
       todo("shogun: turn on codtier easter egg", highPriority);
       todo("shogun: ability to set class/aspect (only works on players)", highPriority);
       todo("optional life sim card for a big bad (given on summon)",mediumPriority);
       todo("target entity has name with word X (lets big bads target specific other big bads, like that clown and pistol shrimp, or shogun and big meat jr)",highPriority);
       todo("SEASONAL BIG BADS, (ultimate dad for fathers day in us/uk/etc) target condition for land/entity of MONTH IS, and DAY is. (could do day of week but that would just be a bitch to debug i think). DO NOT OVER USE THIS. easter, halloween, april fools, xmas, things like that. a big bad that only shows up on the 13th of each month oh god. fuck yes.", highPriority);
       todo("every 13th any time a big bad tries to spawn, shogun spawns instead",highPriority);
       todo("new years eve is grandpa with a knife, new years day is baby with a gun (actually two). spot the refrance",highPriority);
       todo("change player hair/blood color",lowPriority);
       todo("list of birthday big bads, can't be overridden",highPriority);
       todo("allow you to add references to optional data, like land denizen, consorts, owner or player's land name (will not work if you aren't targeting a land/player but that's on you, yo)",mediumPriority);
     todo("have defeatScenes that the big bad gives to all players when they activate. defeat scenes have a locked specialTarget of the big bad. can't target anything else (but can have target conditions to turn on/off the scene, like isUnconditionallyImmortal or isStrifable). these scenes make them mortal, strifable, weaker, etc. ",highPriority);
    todo("fuck the world, make game entities serializable first before i modify big bads too much.", highPriority);
    todo("Combo players get special serialized scenes about helping the native players god tier, skip quests, etc.", highPriority);
    todo("big bads need low, medium, high values for all stats. what am i saying i mean 'Planetary, Galactic, Cosmic'. sorry about that, shogun", highPriority);
    todo("target condition: winning players (purple frog, shogun etc pick this) useful for big giant boss fights at the last minute, or big bads that change their behavior at the last minute", highPriority);
    todo("once a game entities specibus/sylladex is serializable, shove that into big bads too", highPriority);
    todo("fucking do SOMETHING with land hp, maybe it auto blows up on 0, or it's value effects associated entity stats? (especially need for black king/queen)",mediumPriority);
    todo("action effect, add land feature (smells like sweet, has consorts, etc, has strong denizen, etc)", mediumPriority);
    todo("action effect remove action with datastring of x", highPriority);
    todo("action effect, remove land feature (smells like sweet, has consorts, etc, has strong denizen, etc)", mediumPriority);
    todo("big bads need 0 or more custom fraymotif names", mediumPriority);
    todo("LAND EFFECT: set quests to done (pre, denizen or post) (doing this effectively skips them, no reward of any kind)", mediumPriority);
    todo("defeat system is list of scenes (like start or scenes) BUT the scenes are given to the player uppong summoning, not used by big bad", highPriority);
    todo("hasSpritePrototypedWith (if they aren't a player automatically false)", lowPriority);
    todo("isPrototypedWith (for sprites or carapace with rings)", mediumPriority);
    todo("isFromDystopia (i.e. Troll Empress)", mediumPriority);
    todo("hasQuirk", mediumPriority); //bbb that hates unreadable quirks
    todo("put shogun in session 13, and as the effect of killing FU meta player",highPriority);
    todo("hasRelationshipWithMe (either 'any' or list of relatinships types", mediumPriority);
    todo("land condition: isMeteored (i.e. reckoning is going)", lowPriority);
    todo("isDoomed", lowPriority);
    todo("smokey the bear needs shovelkind", mediumPriority);
    todo("effect entity: create minion (from scratch, with set name, like Science experiment or Living Puppet or whatever)",mediumPriority);
    todo("effect: add fraymotif named x", mediumPriority);
    todo("land target based on planet health", mediumPriority);
    todo("effect: set god destiny to false (put this on lands means they destroyed quest bed)", mediumPriority);
    todo("isBrainGhost",lowPriority);
    todo("target based on 'recently broke up' or 'recently got together' with someone",lowPriority);
    todo("ability to access pesterchum as an action (i guess they'd message the first player in their list, and ignoring it otherwise?)",lowPriority);
    todo("big bads have intro mod flavor text (like dystopic empire)",mediumPriority);
    todo("teach AB to write bigBadSummaries to cache",mediumPriority);
    todo("FORM BUG: big bad needs to be in default state before loading still, need to refresh page to clear shit out", highPriority);
    todo("big bads have outro mod flavor text (if they aren't defeated, how do they effect child universe, like dystopic empire)", mediumPriority);
    todo("hasStat over/under X/MyValue target", highPriority);
    todo("setUnavailable slash waste time (check to see when bigbads proc)", highPriority);
    todo("give fraymotif named X effect", highPriority);
    todo("give item (from list) effect", highPriority);
    todo("destroy all items in specibus", mediumPriority);
    todo("take all items in specibus", mediumPriority);
    todo("ressurrect", mediumPriority);
    todo("createRelationship of Type X with me", lowPriority);

  }


  static void todo(String todo, Element priority) {
    LIElement tmp = new LIElement();
    tmp.setInnerHtml("$todo");
    priority.append(tmp);
  }



}


class FAQHandler {

  static String SCENEFAQ = "AI Engine FAQ";
  static String BIGBADFAQ = "Big Bad FAQ";
   Element container;
   String header;

   FAQHandler(String this.header, DivElement div) {
     container = new DivElement();
     container.setInnerHtml("<h1>$header</h1>");
     div.append(container);
     setup();
   }

   void setup() {
    if(header == SCENEFAQ) setupSceneFAQ();
    if(header == BIGBADFAQ) setupBBFAQ();
  }

  void setupBBFAQ() {
    //faq("","");
    faq("What is this for?", "You (i.e. Shogun) can make an entire Big Bad here to give to JR.");
    faq("How does this system work?", "All BigBads in the system are evaluated to see if at least one of their SummonScenes can be triggered (i.e. has a target). Once triggered, the Big Bad will act like a normal Entity. <br><br>Entities have a list of scenes/actions they can do each turn. They work through them in order, and the first time they can complete an action that marks them as 'finished', they stop looking at other actions. <br><br>Thus, the higher up an action is in the list of scenes, the higher 'priority' it is. <br><br>My intent is to shuffle these created scenes before they are used to give the most unpredictable (yet logic based) AI routines for the entities possible.");
   commonFAQParts();
  }

  void commonFAQParts() {
    faq("What is an Entity Target Condition?", "When a scene decides whether or not it triggers, it takes all potential targets (i.e. any player or npc with AI (as opposed to things like consorts) and begins filtering them by all Entity Target Conditions in a scenes. <br><Br> For example, if you target isAlive, then all dead entities will be removed as valid targets. <br><br>Once all Entity Target conditions have been processed, if any Entity Targets remain (or any Land targets) the scene triggers and is displayed on screen and has an effect on the session.");
    faq("What is a Land Target Condition?", "When a scene decides whether or not it triggers, it takes all potential targets (i.e. any player's land, as well as prospit and derse, and begins filtering them by all Land Target Conditions in a scenes. <br><Br> For example, if you target isMoon, then all Planets will be removed as valid targets. <br><br>Once all Land Target conditions have been processed, if any Land Targets remain (or any Entity targets) the scene triggers and is displayed on screen and has an effect on the session.");
    faq("What if I set NO Target Conditions?", "The system considers it to be the same thing as saying 'there are no valid targets'. This is why if you leave Land Target Conditions blank, no lands are ever chosen, only Entities. <br><Br> If you want EVERYTHING to be valid, choose 'isRandom' with an odds of 100%");
    faq("What is an Entity Action Effect?", "It is a single effect that is applied to ALL valid targets entities. <Br><Br>For example, a target might be killed, or have it's stats changed. Should you want it to apply to only a single target, chose the 'Target One Valid Target (vs target All Valid Targets)' option.");
    faq("What is a Land Action Effect?", "It is a single effect that is applied to ALL valid target lands.<br><Br>For example, a land may be blown up, or have it's consorts modified. Should you want it to apply to only a single target, chose the 'Target One Valid Target (vs target All Valid Targets)' option.");
    faq("What is 'Append Target Name(s)'?", "Unless you lock your target to being a single carapace, you can't predict ahead of time who will be targeted exactly. Pressing this button will allow a placeholder for the target (or targets) names to be added to the flavor text. ");
    faq("What is 'Append Scene Owner Name'?", "Unless you are making a carapace scene, you can't know exactly who will own your scene when it finally gets on screen. Pressing this button will allow a placeholder for the scene owner's name to be added to the flavor text. ");
    faq("How does 'isRandom' work?", "isRandom goes through each valid target and has an X% chance of selecting that target. Functionally, that means most of the time X% of valid targets will be chosen.  If you want the scene to have a flat 2% chance of happening, targetSelf (guaranteed to have only one valid target).<br><Br>Example: There is a 2% random filter on a scene. 3/100 valid targets are chosen to apply an effect to. <br><br>Further Example: There is a 2% random filter on a scene. 0/100 targets are chosen, and the scene does not trigger. The next scene in the list is then checked.");
    faq("Why isn't INSERT_FEATURE_HERE available?", "Some things I just haven't gotten to yet. Some things would be too hard (or too rarely used) to justify implementing. Feel free to brainstorm things you might be needed, and I'll try to keep a list of things I plan on trying to get to ordered by priority.");
    faq("What if a Scene effects both Entities and Lands?", "Then the effects for entities will apply to entities and the efects for Lands will apply to lands. ");
    faq("Can I script actions for a scene owner to take even if they are dead?", "Sadly, no. The dead don't clog the system up with AI (which is why that lively corpses bug is so fucking confusing).");
  }

   void setupSceneFAQ() {
    //faq("","");
    faq("What is this for?", "You (i.e. a wrangler) can make an individual scene here to give to JR. The scene will be assigned to a carapace or class or aspect. It will then be available for Entities in the system that hit a qualifying event (being crowned for a Carapace and becoming a Villain for a player). ");
    faq("How does this system work?", "Entities have a list of scenes/actions they can do each turn. They work through them in order, and the first time they can complete an action that marks them as 'finished', they stop looking at other actions. <br><br>Thus, the higher up an action is in the list of scenes, the higher 'priority' it is. <br><br>My intent is to shuffle these created scenes before they are used to give the most unpredictable (yet logic based) AI routines for the entities possible.");
    commonFAQParts();
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
    container.append(tmp);
  }


}