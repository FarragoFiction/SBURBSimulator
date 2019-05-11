import "../../../../SBURBSim.dart";
import 'dart:html';

//if you do it to yourself instead of target, makes it a single use action. nice, tg is smart (thanks tg)
class RemoveThisAction extends EffectEntity {
    TextAreaElement actionStringBox;
    @override
    int  importantInt = 0;

    @override
    String name = "RemoveThisAction";
    RemoveThisAction(SerializableScene scene) : super(scene);




  @override
  void syncFormToMe() {
  }

  @override
  void syncToForm() {
      scene.syncForm();
  }

  @override
  void effectEntities(GameEntity effector,List<GameEntity> entities) {
      String text = "";
      List<GameEntity> renderableTargets = new List<GameEntity>();
    entities.forEach((GameEntity e) {
        if(e.renderable()) renderableTargets.add(e);
        List<SerializableScene> s = e.removeSerializableSceneFromString(this.scene.toDataString());
        if(s == null || s.isEmpty) {
            text = "$text ${e.htmlTitle()} no longer wants to do this action, but can't figure out how to stop. Addiction is a powerful thing. Their scenes are ${e.scenes}} and scenes to add is ${e.scenesToAdd}. Tell JR if you are seeing this because game entities shouldn't be addicted.";

        }else {
            text = "$text ${e.htmlTitle()} no longer wants to do this action.";
        }
    });

    ButtonElement toggle = new ButtonElement()..text = "Show Details?";
    scene.myElement.append(toggle);

    DivElement div = new DivElement()..setInnerHtml(text);
    div.style.display = "none";

      toggle.onClick.listen((Event e) {
          if(div.style.display == "none") {
              toggle.text = "Hide Details?";
              div.style.display = "block";
          }else {
              toggle.text = "Show Details?";
              div.style.display = "none";
          }
      });


    scene.myElement.append(div);
    if(renderableTargets.isNotEmpty && !scene.posedAsATeamAlready) {
        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        scene.myElement.append(canvasDiv);
        Drawing.poseAsATeam(canvasDiv, renderableTargets);
        scene.posedAsATeamAlready = true;
    }
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new RemoveThisAction(scene);
  }
    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>RemoveThis Action:</b> <br>Useful for single use scenes or no longer valid scenes. <br><br>");
        syncToForm();
    }
}