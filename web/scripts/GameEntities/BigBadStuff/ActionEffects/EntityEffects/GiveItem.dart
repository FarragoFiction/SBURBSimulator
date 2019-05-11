import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class GiveItem extends EffectEntity {
    TextAreaElement actionStringBox;
    @override
    int  importantInt = 0;

    @override
    String name = "GiveItem";
    GiveItem(SerializableScene scene) : super(scene);



  @override
  void syncFormToMe() {
      actionStringBox.value = importantWord;
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);
        DivElement me = new DivElement();
        container.append(me);

        me.setInnerHtml("<b>Give Item:</b> <br>");
        //stat time
        AnchorElement a = new AnchorElement(href:"ItemCreation.html")..text = "Item Builder";
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
        Item item = new Item("Generic",[]);
        item.copyFromDataString(importantWord);

        e.sylladex.add(item);
        text = "$text ${e.htmlTitle()} captchalogs a new item: ${item.baseName}.";
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
    return new GiveItem(scene);
  }
}