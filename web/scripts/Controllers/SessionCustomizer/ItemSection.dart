import '../../SBURBSim.dart';
import "dart:html";
import "dart:async";


class ItemSection {
    static List<Item> sortedItems;
    Session session;
    Element container;
    Element selectedItemElement;
    GameEntity gameEntity;
    //if you make a new item, it's that, else it's what was selected in form
    //guaranteed to be a copy
    Item selectedItem;
    ItemSection(GameEntity this.gameEntity, Session this.session, Element parentContainer) {
        container = new DivElement();
        container.classes.add("itemSection");
        parentContainer.append(container);
        draw();
    }

    void drawSelectedItem(TableRowElement row) {
        TableCellElement detailsContainer = new TableCellElement();
        selectedItemElement = new DivElement()..setInnerHtml("<b>Selected Item:<b> ${selectedItem}");
        selectedItemElement.classes.add("selectedItem");
        detailsContainer.append(selectedItemElement);
        row.append(detailsContainer);
    }

    void syncSelectedItem() {

        selectedItemElement.setInnerHtml("<b>Selected Item:<b> ${selectedItem}, Rank: ${selectedItem.rank.toStringAsFixed(2)}");
        DivElement traits = new DivElement()..text = "Traits:";
        for(ItemTrait trait in selectedItem.traits) {
            traits.append(new LIElement()..text = "$trait");
        }
        selectedItemElement.append(traits);
    }

    void draw() {
        container.setInnerHtml("Select Items<br>");
        SelectElement select = new SelectElement();
        container.append(select);
        select.size = 13;
        if(ItemSection.sortedItems == null) {
            sortedItems = new List.from(Item.allUniqueItems);
            sortedItems.sort((a, b) => a.baseName.compareTo(b.baseName));
        }
        for(Item item in  sortedItems) {
            OptionElement option = new OptionElement();
            option.text = item.baseName;
            option.value = "${Item.allUniqueItems.indexOf(item)}";
            select.append(option);
        }
        select.options.first.selected = true;

        select.onChange.listen((Event e) {
            selectedItem =Item.allUniqueItems[int.parse(select.options[select.selectedIndex].value)].copy();
            syncSelectedItem();
        });
    }


}