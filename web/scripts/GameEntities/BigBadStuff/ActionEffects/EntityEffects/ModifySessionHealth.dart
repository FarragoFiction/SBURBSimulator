import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class ModifySessionHealth extends EffectEntity {
    TextAreaElement actionStringBox;
    @override
    int  importantInt = 0;

    @override
    String importantWord = "";
    @override
    String name = "ModifySessionHealth";
    ModifySessionHealth(SerializableScene scene) : super(scene);


  @override
  void syncFormToMe() {
      actionStringBox.value = "$importantInt";
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);
        DivElement me = new DivElement();
        container.append(me);
        List<String> allStatsKnown = new List<String>.from(Stats.byName.keys);

        me.setInnerHtml("<b>ModifySessionHealth (since this isn't targeting a specific entity, can use this even if only land targets):</b> <br>");
        //stat time

        actionStringBox = new TextAreaElement();
        me.append(actionStringBox);
        actionStringBox.value = "$importantInt";
        actionStringBox.onChange.listen((Event e) => syncToForm());
        syncToForm();
    }

  @override
  void syncToForm() {
      importantInt = int.parse(actionStringBox.value);
      scene.syncForm();
  }

  @override
  void effectEntities(GameEntity effector,List<GameEntity> entities) {
      scene.session.sessionHealth += importantInt;
      DivElement div = new DivElement()..text = "Session Health is now ${scene.session.sessionHealth}";
      scene.myElement.append(div);
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new ModifySessionHealth(scene);
  }
}