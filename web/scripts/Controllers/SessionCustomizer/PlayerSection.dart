import '../../GameEntities/GameEntity.dart';
import '../../GameEntities/player.dart';
import '../../SessionEngine/session.dart';
import "EntitySection.dart";
import 'dart:html';

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
  void drawPortrait(GameEntity entity, TableCellElement name) {
      CanvasElement img = new CanvasElement(width: 400, height: 300);
      name.append(img);
      Player p = entity as Player;
      p.initSpriteCanvas();
      img.context2D.drawImage(p.canvas, 0,0);
  }

}