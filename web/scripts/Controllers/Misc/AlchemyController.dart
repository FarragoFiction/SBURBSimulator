import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';

String AND = "AND";
String OR = "OR";
String XOR = "XOR";



Map<CombinedTrait, Achievement> achievements = <CombinedTrait, Achievement>{};
Shop abShop;
Shop abjShop;

Element storeDiv;
Element buyDiv;
Element sellDiv;
Element achivementDiv;
Element alchemyDiv;

List<Element> tabs = <Element>[storeDiv, alchemyDiv];


Element quipDiv;
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
    quipDiv = querySelector("#quip");
    buyDiv = querySelector("#buyshit");
    storeDiv = querySelector("#storeDiv");

    sellDiv = querySelector("#sellshit");
    achivementDiv = querySelector("#achievements");
    alchemyDiv = querySelector("#alchemy");

    abShop = new Shop(player, buyDiv, sellDiv,quipDiv,Item.allUniqueItems);
    List<Item> abjItems = new List.from(Item.uniqueItemsWithTrait(ItemTraitFactory.ONFIRE));
    abjItems.addAll(Item.uniqueItemsWithTrait(ItemTraitFactory.ROMANTIC));
    //TODO
    //abjShop = new Shop(player, querySelector("#abjshit"),querySelector("#quip"),abjItems);

    Achievement.announcmentDiv = querySelector("#announcement");

    ButtonElement storeButton = new ButtonElement();
    storeButton.setInnerHtml("Store");
    storeButton.onClick.listen((e) => changeTabs(storeDiv));

    ButtonElement alchemyButton = new ButtonElement();
    alchemyButton.setInnerHtml("Alchemy");
    alchemyButton.onClick.listen((e) => changeTabs(alchemyDiv));


    changeTabs(alchemyDiv);

    querySelector("#tabs").append(storeButton);
    querySelector("#tabs").append(alchemyButton);


    Achievement.gristDiv = querySelector("#grist");
    Achievement.addGrist(13);
    Achievement.syncGristDiv();
    achievements = Achievement.makeAchievements(achievements, achivementDiv);
}

void changeTabs(Element selectedDiv) {
    if(selectedDiv == storeDiv) {
        abShop.renderPlayerSylladex(); //refresh each time you view.
    }else if(selectedDiv == alchemyDiv){
        makeDropDowns(); //my syladdex probably changed. update.
    }
    for(Element tab in tabs) {
        if(selectedDiv == tab) {
            tab.style.display = "inline-block";

        }else {
            tab.style.display = "none";
        }
    }
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
            Achievement a = achievements[it];
            if(a != null) {
                String doop = (achievements[it].toggle());
                if (doop != null) ret.add(doop);
            }
        }
    }
    Achievement.syncGristDiv();
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
    timesUpgraded.setInnerHtml("Times Alchemized: ${item.numUpgrades} out of ${item.maxUpgrades}");
    ret.append(timesUpgraded);

    Element attributes = new DivElement();
    attributes.setInnerHtml("Attributes: ");
    ret.append(attributes);
    for(ItemTrait it in item.traits) {
        Element li = new DivElement();
        li.classes.add("oneTrait");
        li.setInnerHtml("${it.descriptions.first}(${it.rank})");
        ret.append(li);
    }
    return ret;
}

//knows how to render self. knows how to toggle from not found to found. knows how to award grist
//knows if found yet or nah
class Achievement {
    static int _grist = 0;
    static String WONCLASS = "passedAchievement";
    static String NOTYETCLASS = "missingAchievement";
    static Element announcmentDiv;
    static Element gristDiv;

    static get grist => _grist; //but can't set it



    CombinedTrait trait;
    Element div;

    Achievement(this.trait, Element container) {
        makeElement(container);
    }

    static int addGrist(int amount) {
        _grist += amount;
        syncGristDiv();
    }

    static void syncGristDiv() {
        gristDiv.setInnerHtml("Grist: ${grist}");
    }

    String toggle() {
        if(div.classes.contains(NOTYETCLASS)) {
            div.classes.remove(NOTYETCLASS);
            div.classes.add(WONCLASS);
            int amount = ((trait.rank.abs() + 1) * 100).round(); //no you can't lose money for getting an achievement.
            Achievement._grist += amount;
            return "${trait.name}(+${amount} grist)";
        }
        print("Achivement ${trait.name} already found.");
        return null;
    }

    void makeElement(Element container) {
        div = new DivElement();

        div.classes.add(NOTYETCLASS);

        div.setInnerHtml("${trait.name}");
        container.append(div);
    }

    static Map<CombinedTrait, Achievement> makeAchievements(Map<CombinedTrait, Achievement> input, Element container) {
        List<CombinedTrait> traits = new List<CombinedTrait>.from(ItemTraitFactory.combinedTraits);
        for(CombinedTrait t in traits) {
            if(t.descriptions.isNotEmpty) {

                input[t] = new Achievement(t, container);
            }
        }
        return input;
    }

}


abstract class ShopItem {
    static int tabIndex = 0;
    //TODO middle and late
    List<String> initialQuips = <String>["Yeah, I bet you won't regret that.","Is that really the best choice you could make with your inferior meat brain? Whatever.","Oh my fuck why did it take you so long to decide that."];
    Item item;
    Element div;
    Shop shop;
    String className = "myItems";
    ShopItem(Item this.item, this.shop, Element container) {
        makeElement(container);
    }

    void makeElement(Element container) {
        div = new DivElement();
        div.tabIndex = ShopItem.tabIndex;
        ShopItem.tabIndex ++;
        div.classes.add(className);

        div.setInnerHtml("${item.fullName}");
        //TODO mouse over for traits
        container.append(div);
        div.onClick.listen((e) {
            Random rand = new Random();
            double mathpercent = 90+rand.nextDouble(10.0);
            shop.quipDiv.setInnerHtml("There is a ${mathpercent}% chance that this ${item.fullName} has these traits: ${turnArrayIntoHumanSentence(new List.from(item.traits))}. ${item.randomDescription(rand)}");
            renderTransactButton();
        });
    }

    void renderTransactButton();
}

//on sale, remove grist from Achivement.grist and add item to player.sylladex.
class ShopItemInStock extends ShopItem {
    @override
    String className = "yourItems";

    ShopItemInStock(Item item, Shop shop, Element container) : super(item, shop, container);

  @override
  void renderTransactButton() {
      ButtonElement button = new ButtonElement();
      int cost = ((item.rank.abs()+1) * -10).round();


      button.setInnerHtml("Buy For ${cost} Grist?");

      button.classes.add("transactButton");
      shop.quipDiv.append(button);
      if(cost.abs() <= Achievement.grist) {
          button.onClick.listen((e) {
              Random rand = new Random();
              Achievement.addGrist(cost);
              player.sylladex.add(item);
              //shop.removeItemFromInventory(this); no once it's in inventory it lives there.
              shop.renderPlayerSylladex();
              shop.quipDiv.setInnerHtml(rand.pickFrom(initialQuips));
          });
      }else {
        button.disabled = true;
        button.setInnerHtml("Lol, You can't Afford this.");
      }
  }
}

class ShopItemPlayerOwns extends ShopItem {
    ShopItemPlayerOwns(Item item,Shop shop, Element container) : super(item, shop, container);

  //on sale add grist to Achivement.grist and remove item from player.sylladex and add to Shop Inventory.
  @override
  void renderTransactButton() {
      ButtonElement button = new ButtonElement();
      int cost = ((item.rank.abs()+1) * 5).round();

      button.setInnerHtml("Sell For ${cost} Grist?");
      button.classes.add("transactButton");
      shop.quipDiv.append(button);
      button.onClick.listen((e) {
          Random rand = new Random();
          Achievement.addGrist(cost);
          player.sylladex.remove(item);
          shop.addItemToInventory(item);
          shop.renderPlayerSylladex();
          shop.quipDiv.setInnerHtml(rand.pickFrom(initialQuips));
      });
  }
}

class Shop {
    Element inventoryContainer;
    Element pawnContainer;
    Player player; //assume only one player okay. just do it.
    Element quipDiv;
    List<ShopItemInStock> inventory = new List<ShopItemInStock>();
    List<ShopItemPlayerOwns> playerSylladex = new List<ShopItemPlayerOwns>();

    Shop(Player this.player, Element this.inventoryContainer, Element this.pawnContainer, this.quipDiv, List<Item> items) {
        slurpItemsIntoInventory(items);
        renderPlayerSylladex();
    }

    //gets it off screen and removes from self
    void clear() {
        for(ShopItem i in inventory) {
            i.div.remove();
        }
        inventory.clear();
    }

    void clearSylladex() {
        for(ShopItem i in playerSylladex) {
            i.div.remove();
        }
        playerSylladex.clear();
    }

    void slurpItemsIntoInventory(List<Item> items, [bool clearOld=false]) {
        if(clearOld) {
            clear();
        }
        for(Item i in items) {
            addItemToInventory(i);
        }
    }

    void renderPlayerSylladex() {
        clearSylladex();
        for(Item i in player.sylladex) {
            addItemToShopSylladex(i);
        }
    }

    void addItemToInventory(Item item) {
        inventory.add(new ShopItemInStock(item, this, inventoryContainer));
    }

    void removeItemFromInventory(ShopItem item) {
        item.div.remove();
        inventory.remove(item);
    }

    void addItemToShopSylladex(Item item) {
        playerSylladex.add(new ShopItemPlayerOwns(item, this, pawnContainer));
    }


}