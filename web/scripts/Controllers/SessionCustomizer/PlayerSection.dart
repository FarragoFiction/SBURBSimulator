import '../../GameEntities/GameEntity.dart';
import '../../GameEntities/player.dart';
import '../../SessionEngine/session.dart';
import "EntitySection.dart";
import 'dart:html';
import "../../PlayerSpriteHandler.dart";

class PlayerSection extends EntitySection {


  PlayerSection(Session session, Element parentContainer) : super(session, parentContainer) {
      print ("entities are players");
      allEntities  = new List.from(session.players);
  }

  @override
  void draw() {
      container.setInnerHtml("Customize Players");
      container.classes.add("section");

      ButtonElement toggle = new ButtonElement()..text = "Hide";

      DivElement wrapper = new DivElement();
      wrapper.style.display = "block";
      container.append(toggle);
      container.append(wrapper);

      toggle.onClick.listen((Event e) {
          if(wrapper.style.display == "none") {
              wrapper.style.display = "block";
              toggle.text = "Hide";
          }else {
              wrapper.style.display = "none";
              toggle.text = "Show";
          }
      });

      drawLoadPlayersBox(wrapper);

      for(GameEntity c in  allEntities) {
          print("c is $c");
          drawOneEntity(c,wrapper);
      }
  }

  void drawLoadPlayersBox(Element wrapper) {
      DivElement box = new DivElement();
      LabelElement labelElement = new LabelElement();
      labelElement.setInnerHtml("Optional: Load players from old data string");
      TextAreaElement playerData = new TextAreaElement();
      ButtonElement loadButton = new ButtonElement()..text = "Load";
      loadButton.onClick.listen((Event e) {
          try {
              //match number of plaeyrs to number of replayers.
              print("trying to load ${playerData.value}");
              session.processDataString(playerData.value);
              draw(); //blow away old shit and redraw self
          }catch(e){
              window.alert("This data string doesn't work, for some reason. (the reason is JR isn't done) $e");
              session.logger.error(e);
          }
      });

      box.append(labelElement);
      box.append(playerData);
      box.append(loadButton);
      wrapper.append(box);
  }

  @override
  void drawOneEntity(GameEntity entity, Element wrapper) {
      IndividualPlayerSection tmp = new IndividualPlayerSection(entity, wrapper);
      tmp.draw();
  }


}


class IndividualPlayerSection extends IndividualEntitySection{

    Player player;


    IndividualPlayerSection(GameEntity entity, Element parentContainer) : super(entity, parentContainer) {
        player = entity as Player;
    }

    @override
    void draw() {
        container.setInnerHtml(""); //clear it
        TableRowElement row = new TableRowElement();
        container.append(row);
        container.classes.add("carapaceForm");
        name = new TableCellElement()..setInnerHtml("${player.title()}");
        drawPortrait();
        row.append(name);

        drawOneImportBox(row);
        drawSylladexShit(entity);

        TableRowElement row2 = new TableRowElement();
        container.append(row2);
        drawLandShit(row2);
    }

    @override
    void drawPortrait() {
        CanvasElement img = new CanvasElement(width: 400, height: 300);
        img.style.display = "block";
        name.append(img);
        Player p = entity as Player;
        //async
        PlayerSpriteHandler.drawSpriteFromScratch(img, p);
    }

    void drawLandShit(TableRowElement row) {
        DivElement landShit = new DivElement();
        landShit.classes.add("section");
        row.append(landShit);
        LabelElement landName = new LabelElement()..text = "Land Name:";
        TextInputElement input = new TextInputElement()..value = player.land.name;
        input.style.display = "block";
        input.size = 60;

        LabelElement consortName = new LabelElement()..text = "Consorts:";
        TextInputElement consortInput = new TextInputElement()..value = player.land.consortFeature.name;

        LabelElement consortSound = new LabelElement()..text = "who:";
        TextInputElement soundInput = new TextInputElement()..value = player.land.consortFeature.sound;

        landShit.append(landName);
        landShit.append(input);
        landShit.append(consortName);
        landShit.append(consortInput);
        landShit.append(consortSound);
        landShit.append(soundInput);

    }

    //TODO eventually support it taking in either an old data string or a new one
    void drawOneImportBox(TableRowElement row) {
        //TableRowElement row = new TableRowElement();
        //container.append(row);
        TableCellElement box = new TableCellElement();
        LabelElement labelElement = new LabelElement();
        labelElement.setInnerHtml("Load Player From Data String:");
        TextAreaElement playerData = new TextAreaElement();
        ButtonElement loadButton = new ButtonElement()..text = "Load";
        loadButton.onClick.listen((Event e) {
            try {
                //match number of plaeyrs to number of replayers.
                print("trying to load ${playerData.value}");
                player.copyFromOCDataString(playerData.value);
                player.initialize();
                draw(); //blow away old shit and redraw self
            }catch(e){
                window.alert("This data string doesn't work, for some reason. $e");
                player.session.logger.error(e);
            }
        });

        box.append(labelElement);
        box.append(playerData);
        box.append(loadButton);
        row.append(box);
    }

}