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
        container.setInnerHtml("TODO: draw form");
    }

}