import '../../GameEntities/GameEntity.dart';
import '../../GameEntities/NPCS.dart';
import '../../GameEntities/Stats/stat.dart';
import '../../GameEntities/player.dart';
import '../../SessionEngine/session.dart';
import '../../fraymotif.dart';
import '../../FraymotifEffect.dart';

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
        drawSpriteShit(row2);

        drawAIShit();


    }

    void drawSpriteShit(TableRowElement row) {
        DivElement spriteShit = new DivElement();
        spriteShit.style.display = "inline-block";
        spriteShit.classes.add("section");
        row.append(spriteShit);

        LabelElement spriteName = new LabelElement()..text = "Sprite Name:";
        TextInputElement input = new TextInputElement()..value = player.object_to_prototype.name;
        input.style.display = "block";
        input.size = 60;

        LabelElement spritePowerName = new LabelElement()..text = "Sprite Power Name:";
        TextInputElement inputPower = new TextInputElement();
        if(player.object_to_prototype.fraymotifs.isNotEmpty) inputPower.value = player.object_to_prototype.fraymotifs.first.name;
        input.style.display = "block";
        input.size = 60;

        LabelElement spritePowerDescription = new LabelElement()..text = "Sprite Power Description:";
        TextInputElement inputDesc = new TextInputElement();
        if(player.object_to_prototype.fraymotifs.isNotEmpty) inputDesc.value = player.object_to_prototype.fraymotifs.first.desc;
        inputDesc.style.display = "block";
        inputDesc.size = 60;

        spriteShit.append(spriteName);
        spriteShit.append(input);
        spriteShit.append(spritePowerName);
        spriteShit.append(inputPower);
        spriteShit.append(spritePowerDescription);
        spriteShit.append(inputDesc);

        input.onChange.listen((Event e) {
            player.object_to_prototype = new PotentialSprite(input.value, null);
        });

        inputPower.onChange.listen((Event e) {
            if( player.object_to_prototype.fraymotifs.isNotEmpty) {
                player.object_to_prototype.fraymotifs.first.name = inputPower.value;
            }else {
                Fraymotif f = new Fraymotif(inputPower.value, 1);
                player.object_to_prototype.fraymotifs.add(f);
            }
            player.object_to_prototype.fraymotifs.first.effects.clear();
            player.object_to_prototype.fraymotifs.first.effects.add(new FraymotifEffect(Stats.POWER, 2, true)); //do damage
            player.object_to_prototype.fraymotifs.first.effects.add(new FraymotifEffect(Stats.HEALTH, 1, true)); //heal
        });

        inputDesc.onChange.listen((Event e) {
            if( player.object_to_prototype.fraymotifs.isNotEmpty) {
                player.object_to_prototype.fraymotifs.first.desc = inputDesc.value;
            }else {
                Fraymotif f = new Fraymotif(inputPower.value, 1);
                f.desc = inputDesc.value;
                player.object_to_prototype.fraymotifs.add(f);

            }
            player.object_to_prototype.fraymotifs.first.effects.clear();
            player.object_to_prototype.fraymotifs.first.effects.add(new FraymotifEffect(Stats.POWER, 2, true)); //do damage
            player.object_to_prototype.fraymotifs.first.effects.add(new FraymotifEffect(Stats.HEALTH, 1, true)); //heal
        });
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
        landShit.style.display = "inline-block";
        landShit.classes.add("section");
        row.append(landShit);
        LabelElement landName = new LabelElement()..text = "Land Name:";
        TextInputElement input = new TextInputElement()..value = player.land.name;
        input.style.display = "block";
        input.size = 60;

        LabelElement denizenName = new LabelElement()..text = "Denizen:";
        TextInputElement denizenInput = new TextInputElement()..value = player.land.denizenFeature.name;

        LabelElement consortName = new LabelElement()..text = "Consorts:";
        TextInputElement consortInput = new TextInputElement()..value = player.land.consortFeature.name;

        LabelElement consortSound = new LabelElement()..text = "who:";
        TextInputElement soundInput = new TextInputElement()..value = player.land.consortFeature.sound;

        landShit.append(landName);
        landShit.append(input);
        landShit.append(denizenName);
        landShit.append(denizenInput);
        landShit.append(consortName);
        landShit.append(consortInput);
        landShit.append(consortSound);
        landShit.append(soundInput);

        input.onChange.listen((Event e) {
            player.land.name = input.value;
        });

        consortInput.onChange.listen((Event e) {
            player.land.consortFeature.name = consortInput.value;
        });

        denizenInput.onChange.listen((Event e) {
            player.land.denizenFeature.name = denizenInput.value;
        });

        soundInput.onChange.listen((Event e) {
            player.land.consortFeature.sound = soundInput.value;
        });

    }

    //TODO eventually support it taking in either an old data string or a new one
    void drawOneImportBox(TableRowElement row) {
        //TableRowElement row = new TableRowElement();
        //container.append(row);
        TableCellElement box = new TableCellElement();
        LabelElement labelElement = new LabelElement();
        labelElement.setInnerHtml("Load Player From Old Data String:");
        TextAreaElement playerData = new TextAreaElement();
        playerData.value = player.toOCDataString();
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