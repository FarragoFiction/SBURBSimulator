import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MarkAllQuestsAsCompleteForLand extends EffectLand {
    @override
    String name = "MarkAllQuestsAsComplete";
    MarkAllQuestsAsCompleteForLand(SerializableScene scene) : super(scene);


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
        me.setInnerHtml("<b>MarkAllQuestsAsComplete:</b> <br>a player's final set of quests are marked as complete or undoable (but without getting the rewards and exp from them). <br><br>");
        syncToForm();
    }

  @override
  void syncToForm() {
      scene.syncForm();
  }
  @override
  void effectLands(List<Land> lands) {
    lands.forEach((Land e) {
      e.thirdCompleted = true;
      e.noMoreQuests = true;
    });

  }

  @override
  ActionEffect makeNewOfSameType() {
    return new MarkAllQuestsAsCompleteForLand(scene);
  }
}