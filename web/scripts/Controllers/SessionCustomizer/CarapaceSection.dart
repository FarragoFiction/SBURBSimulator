import '../../SBURBSim.dart';
import "dart:html";
import "dart:async";
import "ItemSection.dart";

//lists all carapaces, lets you activate them or not
class CarapaceSection {
    Session session;
    Element container;
    List<GameEntity> allCarapaces;
    ItemSection itemSection;
    CarapaceSection(Session this.session, Element parentContainer, ItemSection this.itemSection) {
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
        TableElement carapaceDiv = new TableElement();
        TableRowElement row = new TableRowElement();
        carapaceDiv.append(row);
        carapaceDiv.classes.add("carapaceForm");

        container.append(carapaceDiv);

        TableCellElement name = new TableCellElement()..setInnerHtml("${carapace.name}");
        DivElement img = new DivElement();
        ImageElement portrait = new ImageElement(src: "images/BigBadCards/${carapace.initials.toLowerCase()}.png");
        img.append(portrait);
        if((carapace as Carapace).type == Carapace.DERSE) {
            portrait.classes.add("derse");
        }else {
            portrait.classes.add("prospit");
        }
        portrait.height = 150;
        name.append(img);
        row.append(name);


        DivElement checkBoxContainer = new DivElement();
        name.append(checkBoxContainer);
        LabelElement labelCheckBox = new LabelElement()..setInnerHtml("Should they Spawn Active?:");
        checkBoxContainer.append(labelCheckBox);
        CheckboxInputElement isActive = new CheckboxInputElement();
        isActive.checked = carapace.active;
        checkBoxContainer.append(isActive);

        isActive.onChange.listen((Event e) {
            carapace.active = isActive.checked;
        });

        drawSpecibus(carapace,row);
        drawSylladex(carapace,row);
    }

    void drawSpecibus(Carapace carapace, TableRowElement carapaceDiv) {
        TableCellElement specibusContainer = new TableCellElement();
        LabelElement label = new LabelElement()..setInnerHtml("<b>Specibus:<b> ");
        SpanElement specibusElement = new SpanElement()..setInnerHtml(carapace.specibus.name);
        specibusContainer.append(label);
        specibusContainer.append(specibusElement);
        carapaceDiv.append(specibusContainer);
        ButtonElement button = new ButtonElement()..text = "Make Selected Item Specibus?";
        button.onClick.listen((Event e ) {
            try {
                carapace.specibus = itemSection.selectedItem;
                specibusElement.setInnerHtml(carapace.specibus.name);
            }catch(e) {
                window.alert("Failed to make ${itemSection.selectedItem} the specibus.");
            }
        });
        specibusContainer.append(button);
    }

    void drawSylladex(Carapace carapace, TableRowElement carapaceDiv) {
        TableCellElement sylladexContainer = new TableCellElement();
        SelectElement select = new SelectElement();
        sylladexContainer.append(select);
        select.disabled = true;
        select.size = 13;
        for(Item item in  carapace.sylladex) {
            OptionElement option = new OptionElement();
            option.text = item.baseName;
            option.value = "${carapace.sylladex.inventory.indexOf(item)}";
            select.append(option);
        }
        carapaceDiv.append(sylladexContainer);

        ButtonElement button = new ButtonElement()..text = "Add Selected Item to Sylladex?";
        button.onClick.listen((Event e ) {
            try {
                Item item = itemSection.selectedItem;
                carapace.sylladex.add(item);
                OptionElement option = new OptionElement();
                option.text = item.baseName;
                option.value = "${carapace.sylladex.inventory.indexOf(item)}";
                select.append(option);
            }catch(e) {
                window.alert("Failed to add ${itemSection.selectedItem} to sylladex.");
            }
        });
        sylladexContainer.append(button);
    }
}