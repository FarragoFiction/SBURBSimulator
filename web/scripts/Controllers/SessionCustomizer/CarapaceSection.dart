import '../../SBURBSim.dart';
import "dart:html";
import "dart:async";
import "ItemSection.dart";

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


        drawSylladexShit(row, carapace);
    }

    void drawSylladexShit(TableRowElement row, GameEntity carapace) {

      TableCellElement td = new TableCellElement();
      row.append(td);
      ItemSection itemSection = new ItemSection(carapace, session, td);
      itemSection.draw();
      TableElement itemsTable = new TableElement();
      td.append(itemsTable);
      TableRowElement itemRow1 = new TableRowElement();
      TableRowElement itemRow2 = new TableRowElement();
      TableRowElement itemRow3 = new TableRowElement();
      row.append(itemRow1);
      row.append(itemRow2);
      row.append(itemRow3);


      itemSection.drawSelectedItem(itemRow1);
      drawSpecibus(carapace,itemRow2, itemSection);
      drawSylladex(carapace,itemRow3, itemSection);
    }


    void drawSpecibus(Carapace carapace, TableRowElement carapaceDiv, ItemSection itemSection) {
        TableCellElement specibusContainer = new TableCellElement();
        DivElement label = new DivElement()..setInnerHtml("<b>Specibus:<b> ");
        label.style.display = "inline-block";
        SpanElement specibusElement = new SpanElement()..setInnerHtml(carapace.specibus.name);
        ButtonElement button = new ButtonElement()..text = "Equip Item?";
        specibusContainer.append(button);

        specibusContainer.append(label);
        specibusContainer.append(specibusElement);
        carapaceDiv.append(specibusContainer);

        button.onClick.listen((Event e ) {
            try {
                carapace.specibus = itemSection.selectedItem.copy();
                specibusElement.setInnerHtml(carapace.specibus.baseName);
            }catch(e) {
                window.alert("Failed to make ${itemSection.selectedItem} the specibus. Because $e");
                session.logger.error(e);

            }
        });
    }

    void drawSylladex(Carapace carapace, TableRowElement carapaceDiv, ItemSection itemSection) {
        TableCellElement sylladexContainer = new TableCellElement();
        ButtonElement button = new ButtonElement()..text = "Captchalog Item?";
        button.style.verticalAlign = "top";
        SelectElement select = new SelectElement();
        sylladexContainer.append(button);
        sylladexContainer.append(select);
        select.disabled = true;
        select.size = 6;
        for(Item item in  carapace.sylladex) {
            OptionElement option = new OptionElement();
            option.text = item.baseName;
            option.value = "${carapace.sylladex.inventory.indexOf(item)}";
            select.append(option);
        }

        carapaceDiv.append(sylladexContainer);


        button.onClick.listen((Event e ) {
            try {
                Item item = itemSection.selectedItem.copy();
                carapace.sylladex.add(item);
                OptionElement option = new OptionElement();
                option.text = item.baseName;
                option.value = "${carapace.sylladex.inventory.indexOf(item)}";
                select.append(option);
            }catch(e) {
                window.alert("Failed to add ${itemSection.selectedItem} to sylladex. Because $e");
                session.logger.error(e);
            }
        });
    }
}