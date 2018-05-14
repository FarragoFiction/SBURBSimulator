import '../../SBURBSim.dart';
import "dart:html";
import "dart:async";
import "ItemSection.dart";

class SylladexSection {

    void draw(Session session, GameEntity entity, TableRowElement carapaceDiv, ItemSection itemSection) {
        TableCellElement sylladexContainer = new TableCellElement();
        ButtonElement button = new ButtonElement()..text = "Captchalog Item?";
        button.style.verticalAlign = "top";
        SelectElement select = new SelectElement();
        sylladexContainer.append(button);
        sylladexContainer.append(select);
        select.disabled = true;
        select.size = 6;
        for(Item item in  entity.sylladex) {
            OptionElement option = new OptionElement();
            option.text = item.baseName;
            option.value = "${entity.sylladex.inventory.indexOf(item)}";
            select.append(option);
        }

        carapaceDiv.append(sylladexContainer);


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
                session.logger.error(e);
            }
        });
    }

}