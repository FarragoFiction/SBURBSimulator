
//everything inside of this must be true
/*
    Needs to be created via a form in BigBadBuilder but how?
 */
import "../../../SBURBSim.dart";
import 'dart:html';
abstract class TriggerCondition {
    //need to do miins
    static String BIGBADNAME = BigBad.BIGBADNAME;
    static String IMPORTANTWORD = "importantWord";
    //could just be a carapace or a player I don't care
    SerializableScene scene;
    String importantWord;
    //definitely replace this.
    String name = "Generic Trigger";
    TriggerCondition(SerializableScene scene);

    //the keys for this are used for the form builder and the actions are called when it's time to replace words
    Map<String, Generator> replacements = new Map<String, Generator>();

    bool triggered();
    void renderForm(Element div);
    void syncToForm();
    void syncFormToMe();
    void copyFromJSON(JSONObject json);

    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        json[IMPORTANTWORD] = importantWord;
        json["name"] = name;
        return json;
    }

    String replaceAll(String textWithShitToReplaceProbably) {
        for(String key in replacements.keys) {
            textWithShitToReplaceProbably = textWithShitToReplaceProbably.replaceAll("$key", "${replacements[key]()}");
        }
        return textWithShitToReplaceProbably;
    }

    //need to figure out what type of trigger condition it is.
    static TriggerCondition fromJSON(JSONObject json, SerializableScene scene) {
        String name = json["name"];
        List<TriggerCondition> allConditions = listPossibleTriggers(scene);
        for(TriggerCondition tc in allConditions) {
            if(tc.name == name) {
                TriggerCondition ret = tc.makeNewOfSameType();
                ret.copyFromJSON(json);
                ret.scene = scene;
                return ret;
            }
        }
    }

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
                    print("adding new condition to $owner");
                    //bigBad.triggerConditions.add(newCondition);
                    newCondition.renderForm(triggersSection);
                }
            }
        });

        container.append(select);
        container.append(button);

        //render the ones the big bad starts with
        for(TriggerCondition s in owner.triggerConditions) {
            s.renderForm(triggersSection);
        }
        return select;
    }



    static List<TriggerCondition> listPossibleTriggers(SerializableScene scene) {
        List<TriggerCondition> ret = new List<TriggerCondition>();
        ret.add(new ItemTraitTriggerCondition(scene));
        ret.add(new CrownedCarapaceTriggerCondition(scene));
        return ret;
    }

}

