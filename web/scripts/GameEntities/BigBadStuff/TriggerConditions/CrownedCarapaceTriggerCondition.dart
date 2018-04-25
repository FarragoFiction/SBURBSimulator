import "../../../SBURBSim.dart";
import 'dart:html';

class CrownedCarapaceTriggerCondition extends TriggerCondition {
    static String CARAPACENAME = "CARAPACENAME";
    static String CROWNNAME = "CROWNNAME";

    SelectElement select;

    @override
    String name = "CrownedCarapaceExists";

    @override
    String get importantWord => carapaceInitials;

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
            if(o.value == carapaceInitials) {
                print("selecting ${o.value}");
                o.selected = true;
            }
        }

        if(carapaceInitials == null) select.selectedIndex = 0;
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
    @override
    void copyFromJSON(JSONObject json) {
        carapaceInitials = json[TriggerCondition.IMPORTANTWORD];
    }
}