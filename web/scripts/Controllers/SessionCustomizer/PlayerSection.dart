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
      //TODO have text box where you can import a session data url to get all player data at once
      for(GameEntity c in  allEntities) {
          print("c is $c");
          drawOneEntity(c);
      }
  }

  @override
  void drawOneEntity(GameEntity entity) {
      TableElement carapaceDiv = new TableElement();
      TableRowElement row = new TableRowElement();
      carapaceDiv.append(row);
      carapaceDiv.classes.add("carapaceForm");

      container.append(carapaceDiv);

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