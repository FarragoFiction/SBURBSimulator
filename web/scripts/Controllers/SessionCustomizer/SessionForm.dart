import '../../SBURBSim.dart';
import "dart:html";
import "dart:async";
import "CarapaceSection.dart";
import "ItemSection.dart";

class SessionForm {
    Session session;
    DivElement container;
    CarapaceSection carapaceSection;

    SessionForm(Session this.session, Element parentContainer) {
        container = new DivElement();
        container.classes.add("sessionForm");
        parentContainer.append(container);
        draw();
        carapaceSection = new CarapaceSection(session, container);
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
                    bigBad.active = true;
                    session.activatedNPCS.add(bigBad);
                    window.alert("Added to active NPCs!!!");

                }else {
                    NPCHandler.bigBadsFromFile.add(badArea.value);
                    window.alert("Added to potential Big Bads!!!");
                }

            }catch(e) {
                window.alert("Tried to load Big Bad but something went wrong. :( :( :( $e");
            }
        });
    }

}