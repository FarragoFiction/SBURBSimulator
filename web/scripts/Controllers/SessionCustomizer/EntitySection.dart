import '../../SBURBSim.dart';
import 'ImportAISection.dart';
import "dart:html";
import "dart:async";
import "ItemSection.dart";


//lists all carapaces, lets you activate them or not
class EntitySection {
    Session session;
    Element container;
    List<GameEntity> allEntities;

    EntitySection(Session this.session, Element parentContainer) {
        container = new DivElement();
        container.classes.add("carapaceSection");
        parentContainer.append(container);
        allEntities  = new List.from(session.prospit.associatedEntities);
        allEntities.addAll(session.derse.associatedEntities);
    }

    void draw() {
        container.setInnerHtml("Customize Carapaces");
        container.classes.add("section");

        ButtonElement toggle = new ButtonElement()..text = "Show";
        DivElement wrapper = new DivElement();
        wrapper.style.display = "none";
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


        for(GameEntity c in  allEntities) {
            drawOneEntity(c, wrapper);
        }
    }

    void drawOneEntity(GameEntity entity, Element wrapper) {
        IndividualCarapaceSection tmp = new IndividualCarapaceSection(entity, wrapper);
        tmp.draw();
    }

}


abstract class IndividualEntitySection {

    GameEntity entity;
    TableElement container;
    TableCellElement name;
    ItemSection itemSection;
    ImportAISection importAiSection;

    IndividualEntitySection(GameEntity this.entity, Element parentContainer) {
        container = new TableElement();
        parentContainer.append(container);
    }

    void draw() {
        TableRowElement row = new TableRowElement();
        container.append(row);
        container.classes.add("carapaceForm");

        name = new TableCellElement()..setInnerHtml("${entity.name}");
        drawPortrait();
        row.append(name);


        DivElement checkBoxContainer = new DivElement();
        name.append(checkBoxContainer);
        LabelElement labelCheckBox = new LabelElement()..setInnerHtml("Spawn Active?:");
        checkBoxContainer.append(labelCheckBox);
        CheckboxInputElement isActive = new CheckboxInputElement();
        isActive.checked = entity.active;
        checkBoxContainer.append(isActive);

        isActive.onChange.listen((Event e) {
            entity.active = isActive.checked;
        });


        drawSylladexShit(entity);
        drawAIShit();
    }

    void drawSpecibus(TableRowElement row) {
        TableCellElement specibusContainer = new TableCellElement();
        DivElement label = new DivElement()..setInnerHtml("<b>Specibus:<b> ");
        label.style.display = "inline-block";
        SpanElement specibusElement = new SpanElement()..setInnerHtml(entity.specibus.name);
        ButtonElement button = new ButtonElement()..text = "Equip Item?";
        specibusContainer.append(button);

        specibusContainer.append(label);
        specibusContainer.append(specibusElement);
        row.append(specibusContainer);

        button.onClick.listen((Event e ) {
            try {
                entity.specibus = Specibus.fromItem(itemSection.selectedItem);
                specibusElement.setInnerHtml(entity.specibus.baseName);
            }catch(e) {
                window.alert("Failed to make ${itemSection.selectedItem} the specibus. Because $e");
                entity.session.logger.error(e);
            }
        });
    }

    void drawSylladex(TableRowElement row) {
        TableCellElement sylladexContainer = new TableCellElement();
        ButtonElement button = new ButtonElement()..text = "Captchalog Item?";
        ButtonElement removeButton = new ButtonElement()..text = "Remove Item From Sylladex?";
        button.style.verticalAlign = "top";
        SelectElement select = new SelectElement();
        select.style.width = "188px"; //don't go off screen plz
        sylladexContainer.append(button);
        sylladexContainer.append(select);
        select.size = 6;
        for(Item item in  entity.sylladex) {
            OptionElement option = new OptionElement();
            option.text = item.baseName;
            option.value = "${entity.sylladex.inventory.indexOf(item)}";
            select.append(option);
        }
        sylladexContainer.append(removeButton);
        removeButton.onClick.listen((Event e) {
            OptionElement o = select.options[select.selectedIndex];
            print("trying to remove item named ${o.text}");
            Item item = entity.sylladex.inventory[int.parse(o.value)];
            entity.sylladex.remove(item);
            o.remove();
        });

        row.append(sylladexContainer);
        button.onClick.listen((Event e ) {
            try {
                Item item = itemSection.selectedItem.copy();
                entity.sylladex.add(item);
                OptionElement option = new OptionElement();
                option.text = item.baseName;
                option.value = "${entity.sylladex.inventory.indexOf(item)}";
                select.append(option);
            }catch(e) {
                window.alert("Failed to add ${itemSection.selectedItem} to sylladex. Because $e");
                entity.session.logger.error(e);
            }
        });

    }

    void drawPortrait();

    void drawAIShit() {
        DivElement div = new DivElement();
        container.append(div);
        importAiSection = new ImportAISection(entity, entity.session, div);
    }

    void drawSylladexShit(GameEntity carapace) {
        TableRowElement row = new TableRowElement();
        container.append(row);
        TableCellElement td = new TableCellElement();
        row.append(td);
        itemSection = new ItemSection(carapace, entity.session, td);
        itemSection.draw();
        TableElement itemsTable = new TableElement();
        td.append(itemsTable);
        TableRowElement itemRow0 = new TableRowElement();
        TableRowElement itemRow1 = new TableRowElement();
        TableRowElement itemRow2 = new TableRowElement();
        TableRowElement itemRow3 = new TableRowElement();
        row.append(itemRow0);
        row.append(itemRow1);
        row.append(itemRow2);
        row.append(itemRow3);


        itemSection.drawSelectedItem(itemRow1);
        drawSpecibus(itemRow2);
        drawSylladex(itemRow3);
        drawLoadBox(itemRow0);
    }

    void drawLoadBox(Element wrapper) {
        DivElement box = new DivElement();
        LabelElement labelElement = new LabelElement();
        labelElement.setInnerHtml("DataString");
        TextAreaElement dataBox = new TextAreaElement();
        ButtonElement loadButton = new ButtonElement()..text = "Load";
        dataBox.value = entity.toDataString();
        loadButton.onClick.listen((Event e) {
            try {
                entity.copyFromDataString(dataBox.value);
                draw(); //blow away old shit and redraw self
            }catch(e){
                window.alert("This data string doesn't work, for some reason.$e");
                entity.session.logger.error(e);
            }
        });

        box.append(labelElement);
        box.append(dataBox);
        box.append(loadButton);
        wrapper.append(box);
    }


}

class IndividualCarapaceSection extends IndividualEntitySection{
    Carapace carapace;
  IndividualCarapaceSection(GameEntity entity, Element parentContainer) : super(entity, parentContainer) {
      carapace = entity as Carapace;
  }

  @override
  void drawPortrait() {
      DivElement img = new DivElement();
      ImageElement portrait = new ImageElement(src: "images/BigBadCards/${entity.initials.toLowerCase()}.png");
      img.append(portrait);
      if(carapace.type == Carapace.DERSE) {
          portrait.classes.add("derse");
      }else {
          portrait.classes.add("prospit");
      }
      portrait.height = 150;
      name.append(img);
  }
}

