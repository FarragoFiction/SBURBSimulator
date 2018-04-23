
//everything inside of this must be true
/*
    Needs to be created via a form in BigBadBuilder but how?
 */
import "../../SBURBSim.dart";
import 'dart:html';
abstract class TriggerCondition {
    //need to do miins
    static String BIGBADNAME = BigBad.BIGBADNAME;
    //could just be a carapace or a player I don't care
    SerializableScene scene;
    //definitely replace this.
    String name = "Generic Trigger";
    TriggerCondition(SerializableScene scene);


    //TODO how to actually set up the triggers? sub classes? where are my notes...

    bool triggered();
    void renderForm(Element div);
    void syncToForm();
    void syncFormToMe();

    TriggerCondition makeNewOfSameType();

    static SelectElement drawSelectTriggerConditions(Element div, SerializableScene owner) {
        DivElement container = new DivElement();

        DivElement triggersSection = new DivElement();
        triggersSection.setInnerHtml("<h3>Trigger Conditions:</h3>ALL of these must be TRUE<br>");
        div.append(triggersSection);
        div.append(container);
        List<TriggerCondition> conditions = listPossibleTriggers(owner);
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
                    newCondition.scene = owner;
                    owner.triggerConditions.add(newCondition);
                    //bigBad.triggerConditions.add(newCondition);
                    newCondition.renderForm(triggersSection);
                }
            }
        });

        container.append(select);
        container.append(button);
        return select;
    }

    static List<TriggerCondition> listPossibleTriggers(SerializableScene scene) {
        List<TriggerCondition> ret = new List<TriggerCondition>();
        ret.add(new ItemTraitTriggerCondition(scene));
        ret.add(new CrownedCarapaceTriggerCondition(scene));
        return ret;
    }

}

class ItemTraitTriggerCondition extends TriggerCondition{
    static String BIGBADNAME = BigBad.BIGBADNAME;
    static String ITEMTRAITNAME = "ITEMTRAITNAME";
    static String ITEMAME = "ITEMNAME";

    Map<String, ItemTrait> allTraits  = new Map<String, ItemTrait>();

    SelectElement select;

    @override
    String name = "PlayerHasItemWithTrait";

    static String ITEMTRAITOWNERNAME = "PLAYER";
    ItemTrait itemTrait;
    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

  ItemTraitTriggerCondition(SerializableScene scene) : super(scene);

  @override
  bool triggered() {
    // TODO: check sylladex and specibus of all players, do they have an item with this trait?
  }
  @override
  void renderForm(Element div) {
      Set<ItemTrait> allTraitsKnown = ItemTraitFactory.allTraits;
      Session session = scene.session;
      DivElement me = new DivElement();
      div.append(me);
      me.setInnerHtml("<br>ANY player MUST have ANY item with Trait: <br>");

      select = new SelectElement();
      select.size = 13;
      me.append(select);
      for(ItemTrait trait in allTraitsKnown) {
          allTraits[trait.toString()]= trait;
          OptionElement o = new OptionElement();
          o.value = trait.toString();
          o.text = trait.toString();
          select.append(o);
      }

      select.onChange.listen((e) => syncToForm());
      syncToForm();

  }
  @override
  TriggerCondition makeNewOfSameType() {
    return new ItemTraitTriggerCondition(scene);
  }
    @override
    void syncFormToMe() {
        for(OptionElement o in select.options) {
            if(o.value == itemTrait.toString()) {
                o.selected = true;
                return;
            }
        }
    }

    @override
    void syncToForm() {
        String traitName = select.options[select.selectedIndex].value;
        itemTrait = allTraits[traitName];
        //keeps the data boxes synced up the chain
        scene.syncForm();
    }
}

class CrownedCarapaceTriggerCondition extends TriggerCondition {
    static String BIGBADNAME = BigBad.BIGBADNAME;

    static String CARAPACENAME = "CARAPACENAME";
    static String CROWNNAME = "CROWNNAME";

    SelectElement select;

    @override
    String name = "CrownedCarapaceExists";

    String carapaceInitials;
    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

  CrownedCarapaceTriggerCondition(SerializableScene scene) : super(scene);

    @override
    bool triggered() {
        // TODO: check session active npcs, does initials have crown?
    }


    @override
    void renderForm(Element div) {
        Session session = scene.session;
        List<GameEntity> allCarapaces = new List.from(session.prospit.associatedEntities);
        allCarapaces.addAll(session.derse.associatedEntities);
        DivElement me = new DivElement();
        div.append(me);
        me.setInnerHtml("<br>Selected Carapace MUST have a Ring or Scepter: <br>");

        select = new SelectElement();
        select.size = 13;
        me.append(select);
        for(GameEntity carapace in allCarapaces) {
            OptionElement o = new OptionElement();
            o.value = carapace.initials;
            o.text = "${carapace.initials} (${carapace.name})";
            select.append(o);
        }

        select.onChange.listen((e) => syncToForm());
        syncToForm();
    }
  @override
  TriggerCondition makeNewOfSameType() {
    return new CrownedCarapaceTriggerCondition(scene);
  }
  @override
    void syncFormToMe() {
        for(OptionElement o in select.options) {
            if(o.value == carapaceInitials) {
                o.selected = true;
                return;
            }
        }
    }

    @override
    void syncToForm() {
        carapaceInitials = select.options[select.selectedIndex].value;
        //keeps the data boxes synced up the chain
        scene.syncForm();
    }
}