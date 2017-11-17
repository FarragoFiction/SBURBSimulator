import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';

Player player;
Element storyDiv;

/*
     TODO:
     * 3 drop downs, all items, alchemy function, all items again.
     * stats for 2 items (list of traits plus rank of total item)
     * button to do alchemy
        * displays new item stats
        * new item added to list of all items.
    * Grist hoard. Alchemy has grist cost (how?)
    * Achievements (think little inferno).
 */

void main() {
    loadNavbar();
    globalInit();
    init();
}

void init() {
    storyDiv = querySelector("#story");
    player = randomPlayer(new Session(13));
    populateSylladex();
    makeDropDowns();
}

void populateSylladex() {
    for(int i = 0; i< 50; i++) {
        player.sylladex.add(player.session.rand.pickFrom(Item.allUniqueItems));
    }
}

void makeDropDowns() {
    SelectElement firstItem = genericDropDown(storyDiv, player.sylladex,  "First Item");
    SelectElement operator = genericDropDown(storyDiv, <String>["And","Or","Xor"],  "Operation");
    SelectElement secondItem = genericDropDown(storyDiv, player.sylladex,  "Second Item");
}

SelectElement genericDropDown<T> (Element div, List<T> list, String name)
{
    SelectElement selector = new SelectElement()
        ..name = name
        ..id = name;

    for(Object a in list) {
        OptionElement o = new OptionElement()
            ..value = a.toString()
            ..setInnerHtml(a.toString());
        selector.add(o,null);
    }
    div.append(selector);
    return selector;
}


