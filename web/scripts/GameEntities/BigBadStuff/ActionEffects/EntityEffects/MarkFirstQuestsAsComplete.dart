import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MarkFirstQuestsAsComplete extends EffectEntity {
    @override
    String name = "MarkFirstQuestsAsComplete";
    MarkFirstQuestsAsComplete(SerializableScene scene) : super(scene);

  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>MarkFirstQuestsAsComplete:</b> <br>a player's first set of quests are marked as complete (but without getting the rewards and exp from them). <br><br>");
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
            if(land.currentQuestChain is PreDenizenQuestChain || (land.currentQuestChain == null && !land.firstCompleted)) {
              String previousQuest = "Who Cares";
              if(land.currentQuestChain != null) {
                land.currentQuestChain.finished;
                previousQuest = land.currentQuestChain.name;
              }
                land.firstCompleted = true;
              land.currentQuestChain = land.selectQuestChainFromSource(scene.session.players, land.secondQuests);
              DivElement results = new DivElement()..setInnerHtml("${e.htmlTitle()} skips '$previousQuest' and moves on to '${land.currentQuestChain}'.");
              scene.myElement.append(results);
            }
            land.firstCompleted = true;
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
    return new MarkFirstQuestsAsComplete(scene);
  }
}