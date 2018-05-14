import '../../SBURBSim.dart';
import "dart:html";
import "dart:async";
import "ItemSection.dart";



class SpecibusSection {

    void draw(Session session, GameEntity entity, TableRowElement carapaceDiv, ItemSection itemSection) {
        TableCellElement specibusContainer = new TableCellElement();
        DivElement label = new DivElement()..setInnerHtml("<b>Specibus:<b> ");
        label.style.display = "inline-block";
        SpanElement specibusElement = new SpanElement()..setInnerHtml(entity.specibus.name);
        ButtonElement button = new ButtonElement()..text = "Equip Item?";
        specibusContainer.append(button);

        specibusContainer.append(label);
        specibusContainer.append(specibusElement);
        carapaceDiv.append(specibusContainer);

        button.onClick.listen((Event e ) {
            try {
                entity.specibus = itemSection.selectedItem.copy();
                specibusElement.setInnerHtml(entity.specibus.baseName);
            }catch(e) {
                window.alert("Failed to make ${itemSection.selectedItem} the specibus. Because $e");
                session.logger.error(e);

            }
        });
    }

}