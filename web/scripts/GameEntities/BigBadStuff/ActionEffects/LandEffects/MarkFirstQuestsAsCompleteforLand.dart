import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MarkFirstQuestsAsCompleteForLand extends EffectLand {
    @override
    String name = "MarkFirstQuestsAsComplete";
    MarkFirstQuestsAsCompleteForLand(SerializableScene scene) : super(scene);


  @override
  void copyFromJSON(JSONObject json) {
    // nothing to do
  }

  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>MarkFirstQuestsAsComplete:</b> <br>first set of quests are marked as complete (but without getting the rewards and exp from them). <br><br>");
        syncToForm();
    }

  @override
  void syncToForm() {
      scene.syncForm();
  }

    @override
    void effectLands(List<Land> lands) {
      lands.forEach((Land e) {
        e.firstCompleted = true;
      });

    }
  @override
  ActionEffect makeNewOfSameType() {
    return new MarkFirstQuestsAsCompleteForLand(scene);
  }
}