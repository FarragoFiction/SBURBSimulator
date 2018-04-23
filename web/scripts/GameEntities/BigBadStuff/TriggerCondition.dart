
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
    TriggerCondition(Session this.session, GameEntity bigBad);
    String name = "Generic Trigger";

    //TODO how to actually set up the triggers? sub classes? where are my notes...

    bool triggered();
    void renderForm(Element div);

    TriggerCondition makeNewOfSameType();

    static SelectElement drawSelectTriggerConditions(Element div, Session session, BigBad bigBad) {
        List<TriggerCondition> conditions = listPossibleTriggers(session, bigBad);
        SelectElement select = new SelectElement();
        for(TriggerCondition sample in conditions) {
            OptionElement o = new OptionElement();
            o.value = sample.name;
            o.text = sample.name;
            select.append(o);
        }

        ButtonElement button = new ButtonElement();
        button.text = "Add Trigger Condition";
        button.onClick.listen((e) {
            String type = select.options[select.selectedIndex].value;
            for(TriggerCondition tc in conditions) {
                if(tc.name == type) {
                    TriggerCondition newCondition = tc.makeNewOfSameType();
                    bigBad.triggerConditions.add(newCondition);
                    newCondition.renderForm(div);
                }
            }
        });

        div.append(select);
        div.append(button);
        return select;
    }

    static List<TriggerCondition> listPossibleTriggers(Session session, GameEntity bigBad) {
        List<TriggerCondition> ret = new List<TriggerCondition>();
        ret.add(new ItemTraitTriggerCondition(session, bigBad));
        ret.add(new CrownedCarapaceTriggerCondition(session,bigBad));
        return ret;
    }

}

class ItemTraitTriggerCondition extends TriggerCondition{
    static String BIGBADNAME = BigBad.BIGBADNAME;
    static String ITEMTRAITNAME = "ITEMTRAITNAME";
    static String ITEMAME = "ITEMNAME";

    @override
    String name = "PlayerHasItemWithTrait";

    static String ITEMTRAITOWNERNAME = "PLAYER";
    ItemTrait itemTrait;
    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.
    @override
    String flavorText = "$BIGBADNAME suddenly appears because the $ITEMTRAITOWNERNAME is holding a $ITEMAME that is $ITEMTRAITNAME.";

  ItemTraitTriggerCondition(Session session, GameEntity bigBad) : super(session, bigBad);

  @override
  bool triggered() {
    // TODO: check sylladex and specibus of all players, do they have an item with this trait?
  }
  @override
  void renderForm(Element div) {
    // TODO: implement renderForm, should have list of all traits in system (do i even have that? oh uup)
      Set<ItemTrait> allTraits = ItemTraitFactory.allTraits;
      div.appendHtml("TODO: Render Item Trait Form");

  }
  @override
  TriggerCondition makeNewOfSameType() {
    return new ItemTraitTriggerCondition(session, bigBad);
  }
}

class CrownedCarapaceTriggerCondition extends TriggerCondition {
    static String BIGBADNAME = BigBad.BIGBADNAME;

    static String CARAPACENAME = "CARAPACENAME";
    static String CROWNNAME = "CROWNNAME";

    @override
    String name = "CrownedCarapaceExists";

    String carapaceInitials;
    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.
    @override
    String flavorText = "$BIGBADNAME suddenly appears because the ${CARAPACENAME} has summoned them with the ULTIMATE POWER a ${CROWNNAME} represents.";

  CrownedCarapaceTriggerCondition(Session session, GameEntity bigBad) : super(session, bigBad);

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
        div.appendHtml("TODO: Render Crowned Carapace Form");
    }
  @override
  TriggerCondition makeNewOfSameType() {
    return new CrownedCarapaceTriggerCondition(session, bigBad);
  }
}