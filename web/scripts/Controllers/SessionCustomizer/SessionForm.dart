import '../../SBURBSim.dart';
import "dart:html";
import "dart:async";

class SessionForm {
    Session session;
    DivElement container;
    SessionForm(Session this.session, Element parentContainer) {
        container = new DivElement();
        container.classes.add("sessionForm");
        parentContainer.append(container);
        draw();
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
            window.alert("todo");
            BigBad bigBad = new BigBad("N/A", session);
            bigBad.copyFromDataString(badArea.value);
            if(isActive.checked) {
                bigBad.active = true;
            }
            session.bigBads.add(bigBad);
        });



    }

}