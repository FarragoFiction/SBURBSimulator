import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class GiveMinion extends EffectEntity {
    TextAreaElement actionStringBox;
    @override
    int  importantInt = 0;

    @override
    String name = "GiveMinion";
    GiveMinion(SerializableScene scene) : super(scene);



  @override
  void syncFormToMe() {
      actionStringBox.value = importantWord;
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);
        DivElement me = new DivElement();
        container.append(me);

        me.setInnerHtml("<b>Spawn and Give a  Minion:</b> <br>");
        //stat time
        AnchorElement a = new AnchorElement(href:"GameEntityCreation.html")..text = "Minion Builder";
        a.style.backgroundColor = "white";
        a.style.padding = "5px";
        a.target = "_blank";
        me.append(a);
        actionStringBox = new TextAreaElement();
        me.append(actionStringBox);
        actionStringBox.value = importantWord;
        actionStringBox.onChange.listen((Event e) => syncToForm());
        syncToForm();
    }

  @override
  void syncToForm() {
      importantWord = actionStringBox.value;
      scene.syncForm();
  }

  @override
  void effectEntities(GameEntity effector,List<GameEntity> entities) {
      String text = "";
      List<GameEntity> renderableTargets = new List<GameEntity>();
    entities.forEach((GameEntity e) {
        if(e.renderable()) renderableTargets.add(e);
        GameEntity minion = new GameEntity("Minion",scene.session);
        minion.copyFromDataString(importantWord);
        //in theory, allows minions to have scenes attached, if you figure out how to give them some
        //but only becomes relevant if the minion activates which SHOULD
        //only be on reckoning if they have a scepter.
        e.addCompanion(minion);
        text = "$text ${e.htmlTitle()} acquires a new minion: ${minion.htmlTitleWithTip()}.";
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
    return new GiveMinion(scene);
  }
}