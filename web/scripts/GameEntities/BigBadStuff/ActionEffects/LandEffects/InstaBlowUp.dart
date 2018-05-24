import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class InstaBlowUp extends EffectLand {
    @override
    String name = "InstaBlowUp";
    InstaBlowUp(SerializableScene scene) : super(scene);


  @override
  void copyFromJSON(JSONObject json) {
    // nothing to do
  }

  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element div) {
        DivElement me = new DivElement();
        div.append(me);
        me.setInnerHtml("<br><br><b>InstaBlowUp:</b> <br>Nuke it from orbit, it's the only way to be sure. <br><br>");
        syncToForm();
    }

  @override
  void syncToForm() {
      scene.syncForm();
  }
  @override
  void effectLands(List<Land> entities) {
    entities.forEach((Land e) {
        e.planetsplode(scene.gameEntity);
    });
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new InstaBlowUp(scene);
  }
}