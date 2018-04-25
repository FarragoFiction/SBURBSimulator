import "../../../SBURBSim.dart";
import 'dart:html';
class ItemTraitTriggerCondition extends TriggerCondition{
    static String BIGBADNAME = BigBad.BIGBADNAME;
    static String ITEMTRAITNAME = "ITEMTRAITNAME";
    static String ITEMAME = "ITEMNAME";

    Map<String, ItemTrait> _allTraits  = new Map<String, ItemTrait>();

    Map<String, ItemTrait> get allTraits {
        //print("getting allTraits");
        if(_allTraits == null || _allTraits.isEmpty) {
            //print("Setting all traits");
            Set<ItemTrait> allTraitsKnown = ItemTraitFactory.allTraits;
            for(ItemTrait trait in allTraitsKnown) {
                //print("setting trait $trait");
                _allTraits[trait.toString()] = trait;
            }
        }

        return _allTraits;
    }

    SelectElement select;

    @override
    String name = "PlayerHasItemWithTrait";

    static String ITEMTRAITOWNERNAME = "PLAYER";
    ItemTrait itemTrait;

    @override
    String get importantWord => itemTrait.toString();

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
            _allTraits[trait.toString()]= trait;
            OptionElement o = new OptionElement();
            o.value = trait.toString();
            o.text = trait.toString();
            select.append(o);
            if(trait.toString() == itemTrait.toString()) {
                print("selecting ${o.value}");
                o.selected = true;
            }else {
                //print("selecting ${o.value} is not ${itemTrait.toString()}");
            }

        }
        if(itemTrait == null) select.selectedIndex = 0;
        select.onChange.listen((e) => syncToForm());
        syncToForm();

    }
    @override
    TriggerCondition makeNewOfSameType() {
        return new ItemTraitTriggerCondition(scene);
    }




    @override
    void syncFormToMe() {
        print("syncing item trait form with trait of $itemTrait");
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
    @override
    void copyFromJSON(JSONObject json) {
        String key = json[TriggerCondition.IMPORTANTWORD];
        print("key is $key and itemTraits are ${allTraits}");
        itemTrait = allTraits[key];
    }
}