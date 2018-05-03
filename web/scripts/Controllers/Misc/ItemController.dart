import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';
import "dart:async";

String AND = "AND";
String OR = "OR";
String XOR = "XOR";

Player player;


void main() {
    //loadNavbar();
    init();
}
Future<Null> init() async {
    await globalInit();
    player = randomPlayer(new Session(int.parse(todayToSession())));
    player.sylladex = new Sylladex(player,new List <Item>.from(Item.allUniqueItems));
    renderTraitsTable(querySelector("#traitTable"));


    Element div = querySelector("#story");
    //listLevels(div);

    //debugConsorts(div);
    renderTraits( div);

    int i = 0;
    for(Item item in player.sylladex) {
        div.append(renderItemStats(item, i));
        i++;
    }
}

void listLevels(Element e) {
    String ret = "";
    for(InterestCategory c in InterestManager.allCategories) {
        for(String s in c.levels) {
            ret += '"${s}",';
        }
    }

    for(Aspect c in Aspects.all) {
        for(String s in c.levels) {
            ret += '"${s}",';
        }
    }

    for(SBURBClass c in SBURBClassManager.all) {
        for(String s in c.levels) {
            ret += '"${s}",';
        }
    }
    appendHtml(e,ret);

}

void debugConsorts(Element e) {
    String ret = "<h1>Consorts</h1>";
    for(ConsortFeature c in ConsortFeature.allConsorts) {
        ret += "${c.name} who ${c.sound}<br>";
    }
    e.appendHtml(ret);
}

void renderTraitsTable(Element div) {
    TableElement table  = new TableElement();
    table.style.border = "1px solid black";
    table.style.backgroundColor = "white";

    Element stats = new DivElement();
    div.append(stats);
    int numberCells = 0;
    int numberFilledCells = 0;

    TableRowElement tr1 = new TableRowElement();
    table.append(tr1);
    List<ItemTrait> traits = new List.from(ItemTraitFactory.functionalTraits);
    traits.addAll(ItemTraitFactory.appearanceTraits);
    newCell(tr1, "");
    //header
    for(ItemTrait it in traits) {
        newCell(tr1, it.descriptions.first);
    }


    //fire + ice == ice + fire, don't repeat.
    List<ItemTraitPair> seenTraits = new List<ItemTraitPair>();
    //contents
    for(ItemTrait firstTrait in traits) {
        TableRowElement tr = new TableRowElement();
        table.append(tr);
        newCell(tr, firstTrait.descriptions.first);
        for(ItemTrait secondTrait in traits) {
            if(firstTrait == secondTrait) {
                newCell(tr, "x", ReferenceColours.GREYSKIN);
            }else {
                Set<ItemTrait> combos = CombinedTrait.lookForCombinedTraits(new Set<ItemTrait>.from(<ItemTrait>[firstTrait, secondTrait]));
                ItemTraitPair pair = new ItemTraitPair(firstTrait, secondTrait);
                if(seenTraits.contains(pair)) {
                    if (combos.first is CombinedTrait) {
                        CombinedTrait combo = combos.first as CombinedTrait;
                        newCell(tr, combo.name, ReferenceColours.BLACK);
                    } else {
                        newCell(tr, "???", ReferenceColours.BLACK);
                    }
                }else{
                    seenTraits.add(pair);
                    numberCells ++;
                    if (combos.first is CombinedTrait) {
                        CombinedTrait combo = combos.first as CombinedTrait;
                        newCell(tr, combo.name, ReferenceColours.LIME);
                        numberFilledCells ++;
                    } else {
                        newCell(tr, "???");
                    }
                }
            }
        }
    }
    stats.setInnerHtml("${numberCells} possible 2 trait combos. ${numberFilledCells} already done. ${((numberFilledCells/numberCells)*100).round()}% completion");
    div.append(table);
}

void newCell(TableRowElement tr, String contents, [Colour bgColor]) {
    if(bgColor == null) bgColor = ReferenceColours.WHITE;
    TableCellElement td = new TableCellElement();
    td.setInnerHtml(contents);
    td.style.border = "1px solid black";
    td.style.backgroundColor = bgColor.toStyleString();
    tr.append(td);
}

void renderTraits(Element div) {
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


class ItemTraitPair {
    ItemTrait first;
    ItemTrait second;

    ItemTraitPair(this.first, this.second);
    @override
    int get hashCode {
        return first.hashCode + second.hashCode;
    }

    //don't care about ordering.
    @override
    bool operator ==(o) => o is ItemTraitPair && ((o.first == first && o.second == second) ||  o.first == second && o.second == first);
}
