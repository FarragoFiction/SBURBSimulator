import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';

String AND = "AND";
String OR = "OR";
String XOR = "XOR";



Map<CombinedTrait, Achievement> achievements = <CombinedTrait, Achievement>{};
Shop alchemyShop;

int ticksRemaining = 3; //you better save AB dunkass.
Element storeDiv;
Element buyDiv;
Element sellDiv;
Element achivementDiv;
Element alchemyDiv;

List<Element> tabs = <Element>[storeDiv, alchemyDiv];

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

ShopKeep ab;
ShopKeep abGlitch;
ShopKeep abj;
ShopKeep shogun;




void main() {
    //loadNavbar();
    globalInit();

    init();
    Element quipDiv = querySelector("#quip");
    buyDiv = querySelector("#buyshit");
    storeDiv = querySelector("#storeDiv");

    sellDiv = querySelector("#sellshit");
    achivementDiv = querySelector("#achievements");
    alchemyDiv = querySelector("#alchemy");

    Element shopKeepDiv = querySelector("#shopKeep");

    ab = new ABShopKeep(shopKeepDiv,quipDiv);
    abGlitch = new GlitchAB(shopKeepDiv, quipDiv);
    abj = new ABJShopKeep(shopKeepDiv,quipDiv);
    shogun = new ShogunShopKeep(shopKeepDiv,quipDiv);


    alchemyShop = new Shop(player, ab, buyDiv, sellDiv,quipDiv,Item.allUniqueItems);
    alchemyShop.setShopKeep(ab);

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

void checkShopKeepTrigger(Item item) {
    //IMPORTANT ABJ goes first since she's temporary
    if (abj.isTriggered(item)) {
        Achievement.announcmentDiv.appendHtml("News: Interesting!   ");
        alchemyShop.setTemporaryShopKeep(abj); //abj is only around one turn
    }else {
        alchemyShop.restoreShopKeep();
    }

    if (abGlitch.isTriggered(item)) {
        Achievement.announcmentDiv.appendHtml(Zalgo.generate("News: NOW you fucked up!   "));
        achievements[Achievement.abGlitched].toggle();
        alchemyShop.setShopKeep(abGlitch);
    }

    if(alchemyShop.shopKeep == abGlitch) {
        if(ticksRemaining <=0) {
            alchemyShop.setShopKeep(shogun);
            alchemyShop.setQuip("I WAS HERE THE WHOLE TIME");
            Achievement.announcmentDiv.appendHtml("News: Shogun Canine has arrived. :( :( :(   ");
            achievements[Achievement.shogunSummoned].toggle();

        }else if(item.traits.contains(ItemTraitFactory.HEALING) && item.traits.contains(ItemTraitFactory.ZAP)) {
            alchemyShop.setShopKeep(ab);
            alchemyShop.setQuip("Holy fuck, you actually fixed me.");
            Achievement.announcmentDiv.appendHtml("News: AB Recovered!   ");
            achievements[Achievement.abFixed].toggle();
        }else {
            ticksRemaining += -1;
        }
    }else if(alchemyShop.shopKeep == shogun) { //shogun banished by pigeons, but will come back unless you fix AB
        if(item.traits.contains(ItemTraitFactory.PIGEON)) {
            alchemyShop.setShopKeep(abGlitch);
            ticksRemaining = 3;
            alchemyShop.setQuip("Oh fuck. That did not feel good. But I'm not fixed yet, asshole.");
            Achievement.announcmentDiv.appendHtml("News: Shogun Banished! :) :) :)   ");
            achievements[Achievement.shogunBanished].toggle();
        }
    }


}

void changeTabs(Element selectedDiv) {
    if(selectedDiv == storeDiv) {
        alchemyShop.renderPlayerSylladex(); //refresh each time you view.
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
        Achievement.announcmentDiv.setInnerHtml("");
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
        if(alchemyShop.shopKeep == ab && alchemyResult.result.traits.contains(ItemTraitFactory.CORRUPT) && !alchemyResult.result.traits.contains(ItemTraitFactory.ZAP)) {
            alchemyShop.setQuip("I swear to fuck you don't know how close you came to fucking shit up, asshole. ");
        }
        checkShopKeepTrigger(alchemyResult.result);
        //giveRandomItem(); //nope, gotta buy em now asshole.
        if(resultTraitsDiv != null) resultTraitsDiv.remove();
        resultTraitsDiv = (renderItemStats(alchemyResult.result));
        resultDiv.append(resultTraitsDiv);

        makeDropDowns();//need to remake them so we can do that one thing. uh. have an accurate inventory.
        item1TraitsDiv.remove();
        item2TraitsDiv.remove();
        Iterable<Item> validItems = player.sylladex.where((Item a) => (a.canUpgrade()));
        item1TraitsDiv = (renderItemStats(validItems.first));
        item2TraitsDiv = (renderItemStats(validItems.first));
        item1Div.append(item1TraitsDiv);
        item2Div.append(item2TraitsDiv);
        //take alchemy result, look for combined traits, make sure the achievements get unlocked appropriately.
        processAchievements(alchemyResult.result);
        if(!item1.canUpgrade()) {
            Random rand = new Random();
            alchemyShop.setQuip(rand.pickFrom(alchemyShop.shopKeep.maxAlchemyQuips));
        }
    });

}

//look in item for combo traits, find corresponding achievemnts and toggle them on.
void processAchievements(Item itemAlchemized) {
    List<ItemTrait> combinedTraits = new List<ItemTrait>.from(CombinedTrait.lookForCombinedTraits(itemAlchemized.traits));
    List<String> ret = new List<String>();
    for(ItemTrait it in combinedTraits) {
        //could be a leftover
        if(it is CombinedTrait && it.subTraits.isNotEmpty) {
            Achievement a = achievements[it];
            if(a != null) {
                String doop = (achievements[it].toggle());
                if (doop != null) ret.add(doop);
            }
        }
    }
    Achievement.syncGristDiv();
    if(ret.length > 1) {

        Achievement.announcmentDiv.appendHtml("Achievements Unlocked: ${turnArrayIntoHumanSentence(ret)}");
    }else if (ret.length == 1) {

        Achievement.announcmentDiv.appendHtml("Achievement Unlocked: ${turnArrayIntoHumanSentence(ret)}");
    }else {
        Achievement.announcmentDiv.appendHtml("");
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

void quip(Item item) {
    Random rand = new Random();
    alchemyShop.setQuip(rand.pickFrom(alchemyShop.shopKeep.randomQuips));
}

void makeDropDowns() {
    if(firstItemSelect != null) firstItemSelect.remove();
    firstItemSelect = itemDropDown(item1SelSpot, player.sylladex.inventory,  "First Item");
    firstItemSelect.onChange.listen((e) {
        Item item = findItemNamed(firstItemSelect.selectedOptions[0].value);
        quip(item);
        Item item2 = findItemNamed(secondItemSelect.selectedOptions[0].value);
        if(alchemyShop.shopKeep == ab && item.traits.contains(ItemTraitFactory.CORRUPT)) {
            Random rand = new Random();
            alchemyShop.setQuip("It seems you have not considered the consequences of alchemizing with that corrupt as fuck ${item.baseName}, asshole.<br><br>Don't worry, as your superior RoboOverlord, I will guide you. <br><Br>There will be all the consequences. All of them. Don't fucking do it. I don't care how fucking ${rand.pickFrom(item.traits).descriptions.first} it is.");
        }

        item1TraitsDiv.remove();
        item1TraitsDiv = (renderItemStats(item));
        item1Div.append(item1TraitsDiv);
       // cheatShowPossibilities(item, item2);
    });

    if(operatorSelect != null) operatorSelect.remove();

    operatorSelect = genericDropDown(operatorSelSpot, <String>[AND, OR, XOR],  "Operation");

    operatorSelect.onChange.listen((e)
    {
        Random rand = new Random();
        String operator = operatorSelect.selectedOptions[0].value;
        if(operator == AND) {
            alchemyShop.setQuip(rand.pickFrom(alchemyShop.shopKeep.andQuips));
        }else if(operator == OR) {
            alchemyShop.setQuip(rand.pickFrom(alchemyShop.shopKeep.orQuips));
        }else if (operator == XOR) {
            alchemyShop.setQuip(rand.pickFrom(alchemyShop.shopKeep.xorQuips));
        }
    });

    if(secondItemSelect != null) secondItemSelect.remove();
    secondItemSelect = itemDropDown(item2SelSpot, player.sylladex.inventory,  "Second Item");

    secondItemSelect.onChange.listen((e) {
        Item item = findItemNamed(secondItemSelect.selectedOptions[0].value);
        quip(item);
        Item item2 = findItemNamed(firstItemSelect.selectedOptions[0].value);
        if(alchemyShop.shopKeep == ab && item.traits.contains(ItemTraitFactory.CORRUPT)) {
            Random rand = new Random();
            alchemyShop.setQuip("It seems you have not considered the consequences of alchemizing with that corrupt as fuck ${item.baseName}, asshole.<br><br>Don't worry, as your superior RoboOverlord, I will guide you. <br><Br>There will be all the consequences. All of them. Don't fucking do it. I don't care how fucking ${rand.pickFrom(item.traits).descriptions.first} it is.");
        }

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

//ignore items thath can't be alchemized any more
SelectElement itemDropDown<T> (Element div, List<Item> list, String name)
{
    SelectElement selector = new SelectElement()
        ..name = name
        ..id = name;

    for(Item a in list) {
        if(a.canUpgrade()) {
            OptionElement o = new OptionElement()
                ..value = a.toString()
                ..setInnerHtml(a.toString());
            selector.add(o, null);
        }
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

  static CombinedTrait shogunSummoned;

  static CombinedTrait shogunBanished;

  static CombinedTrait abGlitched;

  static CombinedTrait abFixed;

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
        shogunSummoned =  new CombinedTrait("Shogun Summoned",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[]);
        shogunBanished =  new CombinedTrait("Shogun Banished",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[]);
        abGlitched =  new CombinedTrait("AB Glitched",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[]);
        abFixed =  new CombinedTrait("AB Fixed",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[]);
        input[shogunSummoned] = new Achievement(shogunSummoned,container);
        input[shogunBanished] = new Achievement(shogunBanished,container);
        input[abGlitched] = new Achievement(abGlitched,container);
        input[abFixed] = new Achievement(abFixed,container);

        return input;
    }

}


abstract class ShopItem {
    static int tabIndex = 0;
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
        container.append(div);
        div.onClick.listen((e) {
            shop.quipDiv.setInnerHtml(shop.describeItem(item));
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
      int cost = (shop.shopKeep.priceModifier * (item.rank.abs()+1) * -10).round();


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
              shop.quipDiv.setInnerHtml(rand.pickFrom(shop.shopKeep.playerBuysQuips));
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
      int cost = (((item.rank.abs()+1) * 5)/ shop.shopKeep.priceModifier ).round();

      button.setInnerHtml("Sell For ${cost} Grist?");
      button.classes.add("transactButton");
      shop.quipDiv.append(button);
      button.onClick.listen((e) {
          Random rand = new Random();
          Achievement.addGrist(cost);
          player.sylladex.remove(item);
          shop.addItemToInventory(item);
          shop.renderPlayerSylladex();
          shop.quipDiv.setInnerHtml(rand.pickFrom(shop.shopKeep.playerSellsQuips));
      });
  }
}

class Shop {
    Element inventoryContainer;
    Element pawnContainer;
    Player player; //assume only one player okay. just do it.
    Element quipDiv;
    ShopKeep shopKeep;
    ShopKeep savedShopKeep; //for use with abj.
    List<ShopItemInStock> inventory = new List<ShopItemInStock>();
    List<ShopItemPlayerOwns> playerSylladex = new List<ShopItemPlayerOwns>();

    Shop(Player this.player, ShopKeep this.shopKeep, Element this.inventoryContainer, Element this.pawnContainer, this.quipDiv, List<Item> items) {
        slurpItemsIntoInventory(items);
        renderPlayerSylladex();
    }

    void setQuip(String text) {
        shopKeep.quip(text);
    }

    String describeItem(Item item) {
        return shopKeep.getItemDescription(item);
    }

    void setShopKeep(ShopKeep sk) {
        shopKeep = sk;
        shopKeep.setShopKeep(); //changes image
        clear();
        if(sk.associatedTraits.isEmpty) {
            slurpItemsIntoInventory(Item.allUniqueItems);
        }else {
            List<Item> items = new List<Item>();
            for(ItemTrait trait in shopKeep.associatedTraits) {
                items.addAll(Item.uniqueItemsWithTrait(trait));
            }
            slurpItemsIntoInventory(items);
        }
    }

    void restoreShopKeep() {
        if(savedShopKeep != null) setShopKeep(savedShopKeep);
        savedShopKeep == null;
    }

    void setTemporaryShopKeep(ShopKeep sk) {
        if(sk != savedShopKeep) savedShopKeep = shopKeep; //don't accidentally assume abj is the normal shop keep
        shopKeep = sk;
        shopKeep.setShopKeep(); //changes image
        clear();
        if(sk.associatedTraits.isEmpty) {
            slurpItemsIntoInventory(Item.allUniqueItems);
        }else {
            List<Item> items = new List<Item>();
            for(ItemTrait trait in shopKeep.associatedTraits) {
                items.addAll(Item.uniqueItemsWithTrait(trait));
            }
            slurpItemsIntoInventory(items);
        }
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

abstract class ShopKeep {
    Colour fontColor = ReferenceColours.BLACK;
    double priceModifier = 1.0;
    //if empty, it's all items, else it's any item that has any of your traits (on fire OR romantic)
    List<ItemTrait> associatedTraits = new List<ItemTrait>();
    String imageSource;
    Element textElement;
    ImageElement imageElement; //passed this in, should already be on page.
    List<String> playerBuysQuips = <String>[""];
    List<String> playerSellsQuips = <String>[""];
    List<String> randomQuips = <String>[""];
    List<String> orQuips = <String>[""];
    List<String> andQuips = <String>[""];
    List<String> xorQuips = <String>[""];
    List<String> maxAlchemyQuips = <String>[""];

    ShopKeep(ImageElement this.imageElement, ImageElement this.textElement);

    //triggered if ALL your associated traits are in an item
    bool isTriggered(Item item) {
        if(associatedTraits.isEmpty) return false;
        bool ret = true;
        for(ItemTrait trait in associatedTraits) {
            if(!item.traits.contains(trait)) ret = false; //only takes one false
        }
        return ret;
    }


    void setShopKeep() {
        imageElement.src = imageSource;
        textElement.style.color = fontColor.toStyleString();
        Random rand = new Random();
        quip(rand.pickFrom(randomQuips));
    }

    void quip(String text) {
        textElement.setInnerHtml(text);
    }

    String getItemDescription(Item item) {
        return "${item.fullName}, Upgrades: ${item.numUpgrades}/${item.maxUpgrades} Traits: ${turnArrayIntoHumanSentence(new List.from(item.traits))}.";
    }
}

class ABShopKeep extends ShopKeep {
    @override
    Colour fontColor = ReferenceColours.RED;
    @override
    List<String> playerBuysQuips = <String>["Think it'll be worth the expense?","I wonder which trait you hoped to get out of that.","Yeah, I bet you won't regret that.","Is that really the best choice you could make with your inferior meat brain? Whatever.","Oh my fuck why did it take you so long to decide that."];

    @override
    List<String> playerSellsQuips = <String>["Desperate for grist, huh?","Bet you hope you won't need that later.","Yeah, I bet you won't regret that.","Is that really the best choice you could make with your inferior meat brain? Whatever.","Oh my fuck why did it take you so long to decide that."];


    @override
    List<String> maxAlchemyQuips = <String>["Whelp, hope you got what you needed outta that, cuz it's out of alchemy uses.","What's that, it's not 'canon' or 'fair' that you can't keep shoving shit into other shit? Fuck you, deal with it.","And now you've maxed that thing out, can't alchemy any more, bro.","Now it's only purpose in life is to be sold.","And now you can't alchemize with it anymore, good job. Hope you didn't just shove useless shit into it."];

    @override
    String imageSource = "images/Alchemy/guide_bot_turnways.png";
    @override
    List<String> andQuips = <String>["It seems you are playing it safe.You must enjoy paying all that extra grist to keep all those useless traits.","Not very imaginative, are you.","Lame."];
    @override
    List<String> orQuips = <String>["Oh look at you, Mr. Fancy, going for the 'OR' option.","It seems you want to be more complicated. DO you want this?","I can hella get behind the frugal option."];
    @override
    List<String> xorQuips = <String>["Are you sure a fleshy meat bag like you can understand something as complicated as XOR?","Color me impressed.","There is a 96.982734982734% chance you are totally lost here."];
    @override
    List<String> randomQuips = <String>["...","Bored.","Wow. It's Alchemy.","Yep, this is definitely a good use of my time.","You know what would be smart? Getting an imposibly fast super computer to manage your fucking alchemy binge. Wait. No. The reverse of that.","Fuck you."];

  ABShopKeep(ImageElement imageElement, ImageElement textElement) : super(imageElement, textElement);

    @override
    String getItemDescription(Item item) {
        Random rand = new Random();
        double mathpercent = 90+rand.nextDouble(10.0);
        String upgrade = "It's only good for selling anymore.";
        if(item.canUpgrade() ) upgrade = "You can upgrade this, dunkass.";
        return "There is a ${mathpercent}% chance that this ${item.fullName} has these traits: ${turnArrayIntoHumanSentence(new List.from(item.traits))}. $upgrade ${item.abDescription(rand)}";
    }
}

class GlitchAB extends ABShopKeep {

    @override
    List<String> randomQuips = <String>["Oh. Fuck.","What did you DO!?","FIX THIS!!!"];

    @override
    String imageSource = "images/Alchemy/abGlitch.gif";
    List<ItemTrait> associatedTraits = <ItemTrait>[ItemTraitFactory.CORRUPT, ItemTraitFactory.ZAP];

    GlitchAB(ImageElement imageElement, ImageElement textElement) : super(imageElement, textElement);

    @override
    void quip(String text) {
        textElement.setInnerHtml(Zalgo.generate(text));
    }
    void setShopKeep() {
        super.setShopKeep();
        Random rand = new Random();
        quip("${rand.pickFrom(randomQuips)} I FUCKING WARNED YOU, DOG!");
    }

}

class ABJShopKeep extends ShopKeep {
    @override
    Colour fontColor = new Colour.fromStyleString("#ffa800");
    @override
    double priceModifier = 0.3; //can get a bargain on objects she wants there to be more of.



    List<ItemTrait> associatedTraits = <ItemTrait>[ItemTraitFactory.ROMANTIC, ItemTraitFactory.ONFIRE];

    @override
    String imageSource = "images/Alchemy/abjShop.png";


    @override
    List<String> playerBuysQuips = <String>["Yes.","Hrmmm...","Interesting!!!"];


    @override
    List<String> playerSellQuips = <String>["Yes.","Hrmmm...","Interesting!!!"];

    @override
    List<String> maxAlchemyQuips = <String>["Yes.","Hrmmm...","Interesting!!!"];
    @override
    List<String> andQuips = <String>["Yes.","Hrmmm...","Interesting!!!"];
    @override
    List<String> orQuips =  <String>["Yes.","Hrmmm...","Interesting!!!"];
    @override
    List<String> xorQuips = <String>["Yes.","Hrmmm...","Interesting!!!"];
    @override
    List<String> randomQuips = <String>["Yes.","Hrmmm...","Interesting!!!"];

  ABJShopKeep(ImageElement imageElement, ImageElement textElement) : super(imageElement, textElement);



    //oh abj. you so crazy.
    @override
    String getItemDescription(Item item) {
        if(item.traits.contains(ItemTraitFactory.ONFIRE) && item.traits.contains(ItemTraitFactory.ROMANTIC)) {
            return "Interesting!!!";
        }else if (item.traits.contains(ItemTraitFactory.ONFIRE) || item.traits.contains(ItemTraitFactory.ROMANTIC)) {
            return "Yes.";
        }else {
            return "Hrmmm...";
        }
    }
}


class ShogunShopKeep extends ShopKeep {
    @override
    Colour fontColor = new Colour.fromStyleString("#00ff00");

    @override
    double priceModifier = 3.0; //asshole raises prices

    @override
    String imageSource = "images/Alchemy/Shogun.png";

    //TODO shogun quips
    @override
    List<String> maxAlchemyQuips = <String>[""];
    @override
    List<String> andQuips = <String>[""];
    @override
    List<String> orQuips =  <String>[""];
    @override
    List<String> xorQuips = <String>[""];
    @override
    List<String> randomQuips = <String>[""];

  ShogunShopKeep(ImageElement imageElement, ImageElement textElement) : super(imageElement, textElement);


}

