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
    player.sylladex = new Sylladex(new List <Item>.from(Item.allUniqueItems));
    Element div = querySelector("#story");
    renderTraits(div);
    int i = 0;
    for(Item item in player.sylladex) {
        div.append(renderItemStats(item, i));
        i++;
    }
}

Element renderTraits(Element div) {
    Element ret = new DivElement();
    String text = "<b>ObjectTraits: (${ItemTraitFactory.objectTraits.length} total) </b>";
    for(ItemTrait t in ItemTraitFactory.objectTraits) {
        text += " ${t.descriptions.first} (${Item.uniqueItemsWithTrait(t).length}),";
    }

    text += "<br><Br><b>FunctionalTraits: (${ItemTraitFactory.functionalTraits.length} total) </b>";
    for(ItemTrait t in ItemTraitFactory.functionalTraits) {
        text += " ${t.descriptions.first}(${Item.uniqueItemsWithTrait(t).length}),";
    }


    text += "<br><Br><b>AppearanceTraits: (${ItemTraitFactory.appearanceTraits.length} total) </b>";
    for(ItemTrait t in ItemTraitFactory.appearanceTraits) {
        text += " ${t.descriptions.first}(${Item.uniqueItemsWithTrait(t).length}),";
    }


    text += "<br><Br><b>CombinedTraits: (${ItemTraitFactory.combinedTraits.length} total) </b>";
    for(CombinedTrait t in ItemTraitFactory.combinedTraits) {
        if(t.descriptions.isNotEmpty)text += " ${t.descriptions.first}(${turnArrayIntoHumanSentence(t.subTraits)}),";
        if(t.descriptions.isEmpty)text += " CanceledOut(${turnArrayIntoHumanSentence(t.subTraits)}),";

    }
    ret.appendHtml(text);
    div.append(ret);
}


Element renderItemStats(Item item, int number) {
    Element ret = new DivElement();
    ret.classes.add("itemStats");
    Element header = new DivElement();
    String kind = "";
    if(item is Specibus) kind = "kind";
    header.setInnerHtml("$number: ${item.fullName}$kind");
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

