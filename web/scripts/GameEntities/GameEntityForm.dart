
import '../SBURBSim.dart';
import 'dart:html';

class GameEntityForm {
    GameEntity owner;
    Element container;

    TextInputElement nameElement;
    TextAreaElement dataBox;

    GameEntityForm(GameEntity this.owner, Element parentContainer) {
        container = new DivElement();
        container.classes.add("SceneDiv");

        parentContainer.append(container);

    }

    void drawForm() {
        print("drawing new fraymotif form");
        drawDataBox();
        drawName();
    }

    void syncFormToOwner() {
        print("syncing form to scene");
        nameElement.value = owner.name;

        print("syncing data box to scene");
        syncDataBoxToOwner();
    }

    void syncDataBoxToOwner() {
        print("trying to sync data box, owner is ${owner}");
        dataBox.value = owner.toDataString();
    }

    void drawDataBox() {
        print("drawing data box");
        dataBox = new TextAreaElement();
        dataBox.value = owner.toDataString();
        dataBox.cols = 60;
        dataBox.rows = 10;
        dataBox.onChange.listen((e) {
            print("syncing template to data box");
            try {

                owner.copyFromDataString(dataBox.value);

                print("loaded scene");
                syncFormToOwner();
                print("synced form to scene");
            }catch(e, trace) {
                window.alert("something went wrong! $e, $trace");
            }
        });
        container.append(dataBox);
    }

    void drawName() {
        DivElement subContainer = new DivElement();
        LabelElement nameLabel = new LabelElement();
        nameLabel.text = "Name:";
        nameElement = new TextInputElement();
        nameElement.value = owner.name;
        subContainer.append(nameLabel);
        subContainer.append(nameElement);
        container.append(subContainer);

        nameElement.onInput.listen((e) {
            owner.name = nameElement.value;
            syncDataBoxToOwner();
        });
    }
}