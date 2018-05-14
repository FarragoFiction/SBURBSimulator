import '../../GameEntities/GameEntity.dart';
import '../../GameEntities/player.dart';
import '../../SessionEngine/session.dart';
import "EntitySection.dart";
import 'dart:html';

class PlayerSection extends EntitySection {
  PlayerSection(Session session, Element parentContainer) : super(session, parentContainer) {
      allEntities  = new List.from(session.players);
  }

  @override
  void drawPortrait(GameEntity entity, TableCellElement name) {
      CanvasElement img = new CanvasElement(width: 400, height: 300);
      name.append(img);
      Player p = entity as Player;
      img.context2D.drawImage(p.canvas, 0,0);
  }

}