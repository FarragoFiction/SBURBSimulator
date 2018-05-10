import '../../SBURBSim.dart';
import "dart:html";
import "dart:async";


//lists all carapaces, lets you activate them or not
class CarapaceSection {
    Session session;
    Element container;
    List<GameEntity> allCarapaces;
    CarapaceSection(Session this.session, Element parentContainer) {
        container = new DivElement();
        container.classes.add("carapaceSection");
        parentContainer.append(container);
        allCarapaces  = new List.from(session.prospit.associatedEntities);
        allCarapaces.addAll(session.derse.associatedEntities);
        draw();
    }

    void draw() {
        container.setInnerHtml("Customize Carapaces");
        for(GameEntity c in  allCarapaces) {
            drawOneCarapace(c);
        }
    }

    void drawOneCarapace(GameEntity carapace) {
        DivElement carapaceDiv = new DivElement();
        carapaceDiv.classes.add("carapaceForm");

        container.append(carapaceDiv);

        DivElement name = new DivElement()
            ..setInnerHtml("${carapace.name}");
        DivElement img = new DivElement();
        ImageElement portrait = new ImageElement(src: "images/BigBadCards/${carapace.initials.toLowerCase()}.png");
        img.append(portrait);
        if((carapace as Carapace).type == Carapace.DERSE) {
            portrait.classes.add("derse");
        }else {
            portrait.classes.add("prospit");
        }
        portrait.height = 100;
        name.append(img);
        carapaceDiv.append(name);


        DivElement checkBoxContainer = new DivElement();
        carapaceDiv.append(checkBoxContainer);
        LabelElement labelCheckBox = new LabelElement()..setInnerHtml("Should they Spawn Active?:");
        checkBoxContainer.append(labelCheckBox);
        CheckboxInputElement isActive = new CheckboxInputElement();
        isActive.checked = carapace.active;
        checkBoxContainer.append(isActive);

        isActive.onChange.listen((Event e) {
            carapace.active = isActive.checked;
        });
    }
}