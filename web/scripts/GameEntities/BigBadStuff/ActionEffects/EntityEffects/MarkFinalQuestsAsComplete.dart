import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MarkAllQuestsAsComplete extends EffectEntity {
    @override
    String name = "MarkAllQuestsAsComplete";
    MarkAllQuestsAsComplete(SerializableScene scene) : super(scene);


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
  void effectEntities(GameEntity effector,List<GameEntity> entities) {
      List<GameEntity> renderableTargets = new List<GameEntity>();
    entities.forEach((GameEntity e) {
        if(e.renderable()) renderableTargets.add(e);
        if(e is Player) {
          Land land = (e as Player).land;
          if(land != null) {
            if(land.currentQuestChain is PostDenizenQuestChain || (land.currentQuestChain == null && !land.secondCompleted)) {
              String previousQuest = "Who Cares";
              if(land.currentQuestChain != null) {
                land.currentQuestChain.finished;
                previousQuest = land.currentQuestChain.name;
              }
              land.currentQuestChain = null;
              DivElement results = new DivElement()..setInnerHtml("${e.htmlTitle()} skips '$previousQuest' and has nothing left to do on ${e.land.name}.");
              scene.myElement.append(results);
            }
            land.thirdCompleted = true;
            land.noMoreQuests = true;
          }
        }
    });
    if(renderableTargets.isNotEmpty && !scene.posedAsATeamAlready) {
        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        scene.myElement.append(canvasDiv);
        Drawing.poseAsATeam(canvasDiv, renderableTargets);
        scene.posedAsATeamAlready = true;
    }
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new MarkAllQuestsAsComplete(scene);
  }
}