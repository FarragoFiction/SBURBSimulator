import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';

Player player;
Element storyDiv;
Element item1Div;
Element item2Div;
Element operatorDiv;
Element resultDiv;

Element item1TraitsDiv;
Element item2TraitsDiv;
Element resultTraitsDiv;

void main() {
    //loadNavbar();
    globalInit();
    init();
}

void init() {
    storyDiv = querySelector("#story");
    item1Div = querySelector("#item1");
    operatorDiv = querySelector("#operator");
    item2Div = querySelector("#item2");
    resultDiv = querySelector("#result");
    player = randomPlayer(new Session(int.parse(todayToSession())));
    populateSylladex();
    makeDropDowns();
    makeStatsDisplay();
}

void populateSylladex() {
    for(int i = 0; i< 50; i++) {
        player.sylladex.add(player.session.rand.pickFrom(Item.allUniqueItems));
    }
}

void makeStatsDisplay() {
    Item item = player.sylladex.first;
    item1TraitsDiv = (renderItemStats(item));
    item1Div.append(item1TraitsDiv);
    item2TraitsDiv = (renderItemStats(item));
    item2Div.append(item2TraitsDiv);
}

void makeDropDowns() {
    SelectElement firstItem = genericDropDown(item1Div, player.sylladex,  "First Item");
    SelectElement operator = genericDropDown(operatorDiv, <String>["And","Or","Xor"],  "Operation");
    SelectElement secondItem = genericDropDown(item2Div, player.sylladex,  "Second Item");
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


Element renderItemStats(Item item) {
    Element ret = new DivElement();
    ret.classes.add("itemStats");
    Element header = new DivElement();
    header.setInnerHtml(item.fullName);
    header.classes.add("itemHeader");

    ret.append(header);
    Element rank = new DivElement();
    rank.setInnerHtml("Rank: ${item.rank}");
    ret.append(rank);

    Element attributes = new DivElement();
    attributes.setInnerHtml("Attributes: ");
    ret.append(attributes);

    for(ItemTrait it in item.traits) {
        Element li = new DivElement();
        li.classes.add("oneTrait");
        li.setInnerHtml(it.descriptions.first);
        ret.append(li);
    }
    return ret;
}

