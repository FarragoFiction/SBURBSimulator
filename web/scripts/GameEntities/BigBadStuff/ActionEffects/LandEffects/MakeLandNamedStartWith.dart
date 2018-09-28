import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MakeLandNamedStartWith extends EffectLand {

    TextInputElement input;
    @override
    String importantWord = "Titled";
    @override
    String name = "MakeLandNameStartWith";
    MakeLandNamedStartWith(SerializableScene scene) : super(scene);


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
        me.setInnerHtml("<b>MakeLandNameStartWith: (Such as Flaming being added to Land of X and Y to become the Flaming Land of X and Y)</b> ");
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
       // print("making targeted land $e have a new name part $importantWord");
        e.name = "${importantWord} ${e.name}";
    });
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new MakeLandNamedStartWith(scene);
  }
}