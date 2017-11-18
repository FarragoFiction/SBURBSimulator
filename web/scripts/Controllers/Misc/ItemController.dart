import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';

String AND = "AND";
String OR = "OR";
String XOR = "XOR";

Player player;


void main() {
    //loadNavbar();
    globalInit();
    init();
}
void init() {
    player = randomPlayer(new Session(int.parse(todayToSession())));
    player.sylladex = new List <Item>.from(Item.allUniqueItems);
    Element div = querySelector("#story");
    for(int i = 0; i<player.sylladex.length; i++) {
        Item item = player.sylladex[i];
        div.append(renderItemStats(item, i));
    }
}


Element renderItemStats(Item item, int number) {
    Element ret = new DivElement();
    ret.classes.add("itemStats");
    Element header = new DivElement();
    header.setInnerHtml("$number: ${item.fullName}");
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

