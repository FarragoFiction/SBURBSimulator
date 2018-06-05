import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class Corrupt extends EffectLand {
    @override
    String name = "Corrupt";
    Corrupt(SerializableScene scene) : super(scene);


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
        me.setInnerHtml("<b>Corrupt:</b> <br>Make the land spread corruption and have a Zalgo font. <br><br>");
        syncToForm();
    }

  @override
  void syncToForm() {
      scene.syncForm();
  }
  @override
  void effectLands(List<Land> entities) {
    entities.forEach((Land e) {
        e.corrupted = true;
    });
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new Corrupt(scene);
  }
}