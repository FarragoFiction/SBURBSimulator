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
              window.alert("This data string doesn't work, for some reason. $e");
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
      TableElement carapaceDiv = new TableElement();
      TableRowElement row = new TableRowElement();
      carapaceDiv.append(row);
      carapaceDiv.classes.add("carapaceForm");

      wrapper.append(carapaceDiv);

      TableCellElement name = new TableCellElement()..setInnerHtml("${entity.title()}");
      drawPortrait(entity, name);
      row.append(name);

      drawSylladexShit(row, entity);
  }

  @override
  void drawPortrait(GameEntity entity, TableCellElement name) {
      CanvasElement img = new CanvasElement(width: 400, height: 300);
      name.append(img);
      Player p = entity as Player;
      //async
      PlayerSpriteHandler.drawSpriteFromScratch(img, p);
  }

}