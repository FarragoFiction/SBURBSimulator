import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MakeConsortsInto extends EffectLand {

    TextInputElement input;
    @override
    String name = "MakeConsortsInto";
    MakeConsortsInto(SerializableScene scene) : super(scene);


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
        me.setInnerHtml("<b>MakeConsortsInto:</b> ");
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
        e.consortFeature.name = importantWord;
    });
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new MakeConsortsInto(scene);
  }
}