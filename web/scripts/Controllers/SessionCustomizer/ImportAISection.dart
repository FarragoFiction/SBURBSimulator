import "dart:html";
import '../../SBURBSim.dart';

/*
  add and remove scenes. drop down of scenes, text box for importing, button to remove selected scene
  and button to import scene.
 */
class ImportAISection {
  Session session;
  Element container;
  GameEntity gameEntity;

  ImportAISection(GameEntity this.gameEntity, Session this.session, Element parentContainer) {
    container = new DivElement();
    container.classes.add("itemSection");
    parentContainer.append(container);
    draw();
  }

  //todo actually hook this shit up
  void draw() {
    TableElement table = new TableElement();
    TableRowElement tr = new TableRowElement();
    TableCellElement td = new TableCellElement();
    container.append(table);
    table.append(tr);
    tr.append(td);

    SelectElement listSerializableScenes = new SelectElement();
    listSerializableScenes.multiple = true;
    listSerializableScenes.size = 13;
    listSerializableScenes.style.width = "150px";
    td.append(listSerializableScenes);
    for(String s in gameEntity.serializableSceneStrings) {
      OptionElement o = new OptionElement()..value = s..text=s;
      o.style.width = "150px";
      listSerializableScenes.append(o);
    }
    if(listSerializableScenes.options.isNotEmpty) listSerializableScenes.options[0].selected;
    ButtonElement removeScene = new ButtonElement()..text = "Remove Selected Scene";
    removeScene.onClick.listen((Event e) {
      if(listSerializableScenes.selectedIndex != -1) {
        OptionElement o = listSerializableScenes.options[listSerializableScenes
            .selectedIndex];
        gameEntity.serializableSceneStrings.remove(o.value);
        o.remove();
      }
    });
    td.append(removeScene);

    TableCellElement td2 = new TableCellElement();
    tr.append(td2);

    TextAreaElement dataBox = new TextAreaElement();
    td.append(dataBox);

    ButtonElement addScene = new ButtonElement()..text = "Add Scene";
    addScene.onClick.listen((Event e) {
      try {
        //so i can confirm it parses
        new SerializableScene(session).copyFromDataString(dataBox.value);
        gameEntity.serializableSceneStrings.add(dataBox.value);
        listSerializableScenes.append(new OptionElement()
          ..value = dataBox.value
          ..text = dataBox.value);
      }catch(e) {
        window.alert("Something is wrong with this scene: $e");
      }
    });
    td.append(addScene);


  }
}