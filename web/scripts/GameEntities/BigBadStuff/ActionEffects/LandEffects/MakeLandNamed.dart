import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MakeLandNamed extends EffectLand {

    TextInputElement input;
    @override
    String importantWord = "Land of X and Y";
    @override
    String name = "MakeLandNamed";
    MakeLandNamed(SerializableScene scene) : super(scene);


  @override
  void copyFromJSON(JSONObject json) {
    // nothing to do
  }

  @override
  void syncFormToMe() {
      input.value = importantWord;
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>MakeLandNamed:</b> ");
        input = new TextInputElement();
        input.value = importantWord;
        input.onChange.listen((Event e) {
            syncToForm();
        });
        me.append(input);
        syncToForm();
    }

  @override
  void syncToForm() {
      importantWord = input.value;
      scene.syncForm();
  }
  @override
  void effectLands(List<Land> entities) {
    entities.forEach((Land e) {
        e.name = importantWord;
    });
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new MakeLandNamed(scene);
  }
}