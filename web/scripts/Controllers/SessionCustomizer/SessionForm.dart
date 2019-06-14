import '../../SBURBSim.dart';
import "dart:html";
import "dart:async";
import "EntitySection.dart";
import "PlayerSection.dart";
import "ItemSection.dart";

class SessionForm {
    Session session;
    DivElement container;
    //todo guardian section?
    PlayerSection playerSection;
    EntitySection carapaceSection;

    SessionForm(Session this.session, Element parentContainer) {
        container = new DivElement();
        container.classes.add("sessionForm");
        parentContainer.append(container);
        draw();
        playerSection = new PlayerSection(session, container);
        playerSection.draw();
        carapaceSection = new EntitySection(session, container);
        carapaceSection.draw();
    }

    void draw() {
        container.setInnerHtml("Customize Session ${session.session_id}");
        drawBigBadTextBox();
    }

    void drawBigBadTextBox() {
        DivElement badContainer = new DivElement();


        container.append(badContainer);
        LabelElement label = new LabelElement()..setInnerHtml("Add One Big Bad Builder DataString to Test:");
        badContainer.append(label);
        TextAreaElement badArea = new TextAreaElement();
        badArea.cols = 60;
        badArea.rows = 10;
        badContainer.append(badArea);

        DivElement checkBoxContainer = new DivElement();
        badContainer.append(checkBoxContainer);
        LabelElement labelCheckBox = new LabelElement()..setInnerHtml("Should they Spawn Active?:");
        checkBoxContainer.append(labelCheckBox);
        CheckboxInputElement isActive = new CheckboxInputElement();
        checkBoxContainer.append(isActive);

        DivElement buttonContainer = new DivElement();
        ButtonElement buttonElement = new ButtonElement()..text = "Load Big Bad";
        badContainer.append(buttonContainer);
        buttonContainer.append(buttonElement);

        buttonElement.onClick.listen((MouseEvent e) {
            try {
                if (isActive.checked) {
                    BigBad bigBad = new BigBad("N/A", session);
                    bigBad.copyFromDataString(badArea.value);
                    NPCHandler.bigBadsFromFile.add(badArea.value);
                    bigBad.active = true;
                    session.activateBigBad(bigBad);
                    window.alert("Added to active NPCs!!!");

                }else {
                    NPCHandler.bigBadsFromFile.add(badArea.value);
                    BigBad bigBad = new BigBad("N/A", session);
                    bigBad.copyFromDataString(badArea.value);
                    session.npcHandler.bigBads.add(bigBad);
                    window.alert("Added to potential Big Bads!!!");
                }

            }catch(e) {
                print("Error: $e");
                window.alert("Tried to load Big Bad but something went wrong. :( :( :( $e");
            }
        });
    }

}