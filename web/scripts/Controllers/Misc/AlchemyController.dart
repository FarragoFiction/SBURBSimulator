import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';

String AND = "AND";
String OR = "OR";
String XOR = "XOR";

//TODO make map of combinedTrait to achievements
 Map<CombinedTrait, Achievement> achievements = <CombinedTrait, Achievement>{};


Player player;
Element storyDiv;
Element item1Div;
Element item2Div;
Element operatorDiv;
Element resultDiv;

Element item1TraitsDiv;
Element item2TraitsDiv;
Element resultTraitsDiv;

Element item1SelSpot;
Element item2SelSpot;
Element operatorSelSpot;

SelectElement firstItemSelect;
SelectElement secondItemSelect;
SelectElement operatorSelect;


void main() {
    //loadNavbar();
    globalInit();
    init();
    achievements = Achievement.makeAchievements(achievements, querySelector("#achievements"),querySelector("#announcement"));
}



void init() {
    storyDiv = querySelector("#story");
    item1Div = querySelector("#item1");
    operatorDiv = querySelector("#operator");
    item2Div = querySelector("#item2");
    resultDiv = querySelector("#result");
    item1SelSpot = querySelector("#item1Sel");
    operatorSelSpot = querySelector("#opSel");
    item2SelSpot = querySelector("#item2Sel");
    player = randomPlayer(new Session(int.parse(todayToSession())));
    populateSylladex();
    makeAlchemyButton();
    makeDropDowns();
    makeStatsDisplay();
}

void cheatShowPossibilities(Item item1, Item item2) {
   List<AlchemyResult> results =  AlchemyResult.planAlchemy(<Item>[item1, item2]);
   results.sort();
   resultDiv.setInnerHtml("");
   for(AlchemyResult result in results) {
       String type = "AND";
       if(result is AlchemyResultXOR) type = "XOR";
       if(result is AlchemyResultOR) type = "OR";
       resultDiv.appendHtml("<br><br>Type: $type <br>");
       resultDiv.append(renderItemStats(result.result));
   }
}

void makeAlchemyButton() {
    ButtonElement button = querySelector("#alchemyButton");
    button.onClick.listen((e) {
        Item item1 =findItemNamed(firstItemSelect.selectedOptions[0].value);
        Item item2 =findItemNamed(secondItemSelect.selectedOptions[0].value);
        String operation = operatorSelect.selectedOptions[0].value;
        AlchemyResult alchemyResult;

        if(operation == AND) {
           // print("going to combine ${item1.fullName} with ${item1.traits.length} traits and ${item2.fullName} with ${item2.traits.length} traits");
            alchemyResult = new AlchemyResultAND(<Item> [item1, item2]);
        }else if(operation == OR) {
            alchemyResult = new AlchemyResultOR(<Item> [item1, item2]);
        }else if(operation == XOR) {
            alchemyResult = new AlchemyResultXOR(<Item> [item1, item2]);
        }
        alchemyResult.apply(player);
        //giveRandomItem(); //nope, gotta buy em now asshole.
        if(resultTraitsDiv != null) resultTraitsDiv.remove();
        resultTraitsDiv = (renderItemStats(alchemyResult.result));
        resultDiv.append(resultTraitsDiv);

        makeDropDowns();//need to remake them so we can do that one thing. uh. have an accurate inventory.
        item1TraitsDiv.remove();
        item2TraitsDiv.remove();
        item1TraitsDiv = (renderItemStats(player.sylladex.first));
        item2TraitsDiv = (renderItemStats(player.sylladex.first));
        item1Div.append(item1TraitsDiv);
        item2Div.append(item2TraitsDiv);
        //take alchemy result, look for combined traits, make sure the achievements get unlocked appropriately.
        processAchievements(alchemyResult.result);
    });

}

//look in item for combo traits, find corresponding achievemnts and toggle them on.
void processAchievements(Item itemAlchemized) {
    List<ItemTrait> combinedTraits = new List<ItemTrait>.from(CombinedTrait.lookForCombinedTraits(itemAlchemized.traits));
    List<String> ret = new List<String>();
    for(ItemTrait it in combinedTraits) {
        //could be a leftover
        if(it is CombinedTrait) {
            String doop = (achievements[it].toggle());
            if(doop != null) ret.add(doop);
        }
    }
    if(ret.length > 1) {
        Achievement.announcmentDiv.setInnerHtml("Achievements Unlocked: ${turnArrayIntoHumanSentence(ret)}");
    }else if (ret.length == 1) {
        Achievement.announcmentDiv.setInnerHtml("Achievement Unlocked: ${turnArrayIntoHumanSentence(ret)}");
    }else {
        Achievement.announcmentDiv.setInnerHtml("");

    }

}

void populateSylladex() {
    player.sylladex.addAll(player.interest1.category.items);
    player.sylladex.addAll(player.interest2.category.items);
    player.sylladex.addAll(player.aspect.items);
    player.sylladex.addAll(player.class_name.items);
    player.sylladex.add(player.specibus);
}

void giveRandomItem() {
    player.sylladex.add(player.session.rand.pickFrom(Item.allUniqueItems));
}

void makeStatsDisplay() {
    Item item = player.sylladex.first;
    item1TraitsDiv = (renderItemStats(item));
    item1Div.append(item1TraitsDiv);
    item2TraitsDiv = (renderItemStats(item));
    item2Div.append(item2TraitsDiv);
}

Item findItemNamed(String name) {
    Item ret;
    for(Item i in player.sylladex) {
        if(i.fullName == name) {
            //print("found possible match ${i} with ${i.traits.length} traits");
            ret = i;
        }
    }
    return ret;
}

void makeDropDowns() {
    if(firstItemSelect != null) firstItemSelect.remove();
    firstItemSelect = genericDropDown(item1SelSpot, player.sylladex,  "First Item");
    firstItemSelect.onChange.listen((e) {
        Item item = findItemNamed(firstItemSelect.selectedOptions[0].value);
        Item item2 = findItemNamed(secondItemSelect.selectedOptions[0].value);

        item1TraitsDiv.remove();
        item1TraitsDiv = (renderItemStats(item));
        item1Div.append(item1TraitsDiv);
       // cheatShowPossibilities(item, item2);
    });

    if(operatorSelect != null) operatorSelect.remove();

    operatorSelect = genericDropDown(operatorSelSpot, <String>[AND, OR, XOR],  "Operation");

    if(secondItemSelect != null) secondItemSelect.remove();
    secondItemSelect = genericDropDown(item2SelSpot, player.sylladex,  "Second Item");

    secondItemSelect.onChange.listen((e) {
        Item item = findItemNamed(secondItemSelect.selectedOptions[0].value);
        Item item2 = findItemNamed(firstItemSelect.selectedOptions[0].value);

        item2TraitsDiv.remove();
        item2TraitsDiv = (renderItemStats(item));
        item2Div.append(item2TraitsDiv);
        //cheatShowPossibilities(item2, item);
    });
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

    Element timesUpgraded = new DivElement();
    timesUpgraded.setInnerHtml("Times Alchemized: ${item.numUpgrades}");
    ret.append(timesUpgraded);

    Element attributes = new DivElement();
    attributes.setInnerHtml("Attributes: ");
    ret.append(attributes);
    String collate = "";
    for(ItemTrait it in item.traits) {
        Element li = new DivElement();
        li.classes.add("oneTrait");
        collate += ",${it.descriptions.first}";
        li.setInnerHtml("${it.descriptions.first}(${it.rank})");
        ret.append(li);
    }
    ret.appendHtml(collate);
    return ret;
}

//knows how to render self. knows how to toggle from not found to found. knows how to award grist
//knows if found yet or nah
class Achievement {

    static String WONCLASS = "passedAchievement";
    static String NOTYETCLASS = "missingAchievement";
    static Element announcmentDiv;


    CombinedTrait trait;
    Element div;

    Achievement(this.trait, this.div);

    String toggle() {
        if(div.classes.contains(NOTYETCLASS)) {
            div.classes.remove(NOTYETCLASS);
            div.classes.add(WONCLASS);
            //TODO also give money
            return trait.name;
        }
        print("Achivement ${trait.name} already found.");
        return null;
    }

    static Map<CombinedTrait, Achievement> makeAchievements(Map<CombinedTrait, Achievement> input, Element container, Element annDiv) {
        List<CombinedTrait> traits = new List<CombinedTrait>.from(ItemTraitFactory.combinedTraits);
        Achievement.announcmentDiv = annDiv;
        for(CombinedTrait t in traits) {
            if(t.descriptions.isNotEmpty) {
                Element div = new DivElement();

                div.classes.add(NOTYETCLASS);

                div.setInnerHtml(t.name);
                container.append(div);
                input[t] = new Achievement(t, div);
            }
        }
        return input;
    }

}