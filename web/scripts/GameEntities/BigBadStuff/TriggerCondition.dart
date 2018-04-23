
//everything inside of this must be true
/*
    Needs to be created via a form in BigBadBuilder but how?
 */
import "../../SBURBSim.dart";
import 'dart:html';
abstract class TriggerCondition {
    Session session;
    static String BIGBADNAME = BigBad.BIGBADNAME;
    //could just be a carapace or a player I don't care
    GameEntity bigBad;
    //definitely replace this.
    String flavorText = "$BIGBADNAME suddenly appears for probably no reason.";
    TriggerCondition(Session this.session);

    //TODO how to actually set up the triggers? sub classes? where are my notes...

    bool triggered();
    void renderForm(Element div);

    static SelectElement drawSelectTriggerConditions(Element div) {
        //TODO call listPossibleTriggers to make the options, select teh first one by default.
    }

    static List<TriggerCondition> listPossibleTriggers(Session session) {
        List<TriggerCondition> ret = new List<TriggerCondition>();
        ret.add(new ItemTraitTriggerCondition(session));
        ret.add(new CrownedCarapaceTriggerCondition(session));

        //TODO should have drop down of one instance of each trigger, and a button to add a copy of one to the big bad
        //todo once you've added the copy it renders itself as a sub form
        return ret;
    }

}

class ItemTraitTriggerCondition extends TriggerCondition{
    static String BIGBADNAME = BigBad.BIGBADNAME;
    static String ITEMTRAITNAME = "ITEMTRAITNAME";
    static String ITEMAME = "ITEMNAME";

    static String ITEMTRAITOWNERNAME = "PLAYER";
    ItemTrait itemTrait;
    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.
    @override
    String flavorText = "$BIGBADNAME suddenly appears because the ${ITEMTRAITOWNERNAME} is holding a ${ITEMAME} that is $ITEMTRAITNAME.";

  ItemTraitTriggerCondition(Session session) : super(session);

  @override
  bool triggered() {
    // TODO: check sylladex and specibus of all players, do they have an item with this trait?
  }
  @override
  void renderForm(Element div) {
    // TODO: implement renderForm, should have list of all traits in system (do i even have that? oh uup)
      Set<ItemTrait> allTraits = ItemTraitFactory.allTraits;
  }
}

class CrownedCarapaceTriggerCondition extends TriggerCondition {
    static String BIGBADNAME = BigBad.BIGBADNAME;

    static String CARAPACENAME = "CARAPACENAME";
    static String CROWNNAME = "CROWNNAME";

    String carapaceInitials;
    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.
    @override
    String flavorText = "$BIGBADNAME suddenly appears because the ${CARAPACENAME} has summoned them with the ULTIMATE POWER a ${CROWNNAME} represents.";

  CrownedCarapaceTriggerCondition(Session session) : super(session);

    @override
    bool triggered() {
        // TODO: check session active npcs, does initials have crown?
    }
    @override
    void renderForm(Element div) {
        // TODO: implement renderForm, should have list of all carapace initials
        List<GameEntity> allCarapaces = new List.from(session.prospit.associatedEntities);
        allCarapaces.addAll(session.derse.associatedEntities);
        //TODO
    }
}