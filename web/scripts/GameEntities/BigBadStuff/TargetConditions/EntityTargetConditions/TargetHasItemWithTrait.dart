import "../../../../SBURBSim.dart";
import 'dart:html';

//todo use ItmeTraitTriggerCondition as a guide
class TargetHasItemWithTrait extends TargetConditionLiving {
    static String ITEMTRAITNAME = "ITEMTRAITNAME";
    static String ITEMAME = "ITEMNAME";

    @override
    String descText = "<br>Target Entity must have an item with Trait: <br>";
    @override
    String notDescText = "<br>Target Entity must NOT have an item with Trait: <br>";

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
    String name = "HasItemWithTrait";

    ItemTrait itemTrait;

    @override
    String get importantWord => itemTrait.toString();

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetHasItemWithTrait(SerializableScene scene) : super(scene){


    }


    String getItemName() {
        return "TODO: GET CROWN NAME";
    }

    String getItemTraitName() {
        return itemTrait.toString();
    }



    @override
    void renderForm(Element divbluh) {
        List<ItemTrait> allTraitsKnown = new List<ItemTrait>.from(ItemTraitFactory.allTraits);
        allTraitsKnown.sort((ItemTrait a, ItemTrait b) => a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));

        Session session = scene.session;

        setupContainer(divbluh);

        syncDescToDiv();
        DivElement me = new DivElement();
        container.append(me);

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
        if(itemTrait == null) {
            itemTrait = allTraitsKnown.first;
            select.selectedIndex = 0;
        }
        select.onChange.listen((Event e) => syncToForm());
        syncFormToMe();
        scene.syncForm();
    }


    @override
    TargetCondition makeNewOfSameType() {
        return new TargetHasItemWithTrait(scene);
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
        syncFormToNotFlag();
    }

    @override
    String toString() {
        return "TargetHasItemWithTrait: ${getItemTraitName()}";
    }

    @override
    void syncToForm() {
        String traitName = select.options[select.selectedIndex].value;
        itemTrait = allTraits[traitName];
        //keeps the data boxes synced up the chain
        syncNotFlagToForm();

        scene.syncForm();
    }
    @override
    void copyFromJSON(JSONObject json) {
        String key = json[TargetCondition.IMPORTANTWORD];
        //print("key is $key and itemTraits are ${allTraits}");
        itemTrait = allTraits[key];
    }

    @override
    bool conditionForFilter(GameEntity actor, GameEntity entity) {
        for(Item i in entity.sylladex) {
            bool ret = (i.hasTrait(itemTrait));
            if(ret == true) {
                //scene.session.logger.info("TEST $entity has item $i in sylladex with trait $itemTrait");
                return false;
            }else {
                //scene.session.logger.info("TEST $entity's $i does not have trait $itemTrait");

            }
        }
        bool ret = (entity.specibus.hasTrait(itemTrait));
        if(ret == true) {
            // scene.session.logger.info("$entity has specibus with trait $itemTrait");
            return false;
        }
        return true;
    }

}