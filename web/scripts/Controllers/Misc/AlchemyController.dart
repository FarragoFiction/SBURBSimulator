import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:async';


String AND = "AND";
String OR = "OR";
String XOR = "XOR";



Shop alchemyShop;
ButtonElement alchemizeButton; //so i can change price.
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




void main()  {
    loadNavbar();
    storeCard("N4Igzg9grgTgxgUxALhAEQgSwHYHMAEAggDZwAWCAtgJ4gA0I2AhpUqgCpUAOxTALgnwBlRNiQMBADz4oQAWSbUARoMx98AdyZh8TfJUxg+TANaC+EfEqjUrEPmSswIG7JkEHJu7ABN8cUw9MLyZffWD8ByDJBB1iTDNdKyY-IRMYTGJeMAB6AHEIGAziBC8lfgEYXTAwJihidVC-cr5K6gA6fHwAORd8FzEYBGZWGAByHTAAkvxDfDAuaD4cAgohsFsm+bJoYj8NQr9cBHUlyIp8AElsAEcoQzVMCGxNTOJ8IbuH5efvfABRaQIGAGZh8KBgAC0j1+UEWLyi+GGyyGyQczgglHwAAotmBYM4oL4VvgeKETgBKdr0EDlOAmXCE3zdFhsEDsJRkdhkQwAdW0AAV-tpqEIAEIAVQASmL2lw8DS+BlcMcYABhMihRCyAAM7QArDSpsNYuwIBLsMQIPTZABtAC6NPW9T4YCExldduAAB1GKzfchfQAZS4AMX+QkIErV-19dF9ADcmMQoAgA76AMy+gC+jokytV7v4YCDsTAwLteZASswKuBRddeSG-ArqFtPr9rHTIDVAHk5HJ-lKY3HE8nU92AEw5qs1uswBtgf53ZOVkDZoA");
   start();

}

Future<Null> start() async {
    await globalInit();

    init();
    Element quipDiv = querySelector("#quip");


    buyDiv = querySelector("#buyshit");
    storeDiv = querySelector("#storeDiv");

    sellDiv = querySelector("#sellshit");
    alchemyDiv = querySelector("#alchemy");

    Element shopKeepDiv = querySelector("#shopKeep");

    ab = new ABShopKeep(shopKeepDiv,quipDiv);
    abGlitch = new GlitchAB(shopKeepDiv, quipDiv);
    abj = new ABJShopKeep(shopKeepDiv,quipDiv);
    shogun = new ShogunShopKeep(shopKeepDiv,quipDiv);


    alchemyShop = new Shop(player, ab, buyDiv, sellDiv,quipDiv,Item.allUniqueItems);
    alchemyShop.setShopKeep(ab);


    ButtonElement storeButton = new ButtonElement();
    storeButton.setInnerHtml("Store");
    storeButton.onClick.listen((e) => changeTabs(storeDiv));

    ButtonElement alchemyButton = new ButtonElement();
    alchemyButton.setInnerHtml("Alchemy");
    alchemyButton.onClick.listen((e) => changeTabs(alchemyDiv));


    changeTabs(alchemyDiv);
    ButtonElement fuckYou = new ButtonElement();
    fuckYou.setInnerHtml("Fuck you.");
    //querySelector("#tabs").append(fuckYou); //don't do this. AB takes SO FUCKING LONG.

    fuckYou.onClick.listen((e) => fuckYouABCanHandleThisOnHerOwn());
    querySelector("#tabs").append(storeButton);
    querySelector("#tabs").append(alchemyButton);
}


//asshole meat sacks don't know what they are doing. And are also hella slow.
 Future<Null> fuckYouABCanHandleThisOnHerOwn() async {
    //player.sylladex.addAll(new List<Item>.from(Item.allUniqueItems)); don't do it. AB TAKES SO FUCKING LONG.
    Gristmas g = new Gristmas(player.session);
    g.player = player;
    List<AlchemyResult> results = g.doAlchemy();
    ABWins abWins = new ABWins(new List<AlchemyResult>.from(results));
    abWins.win();
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
        Achievement.achievements[Achievement.abGlitched].toggle();
        alchemyShop.setShopKeep(abGlitch);
    }

    if(alchemyShop.shopKeep == abGlitch) {
        if(ticksRemaining <=0) {
            alchemyShop.setShopKeep(shogun);
            alchemyShop.setQuip("I WAS HERE THE WHOLE TIME");
            Achievement.announcmentDiv.appendHtml("News: Shogun Canine has arrived. Hope you like useless shit posts. Fucking Lord of Words. :( :( :(   ");
            Achievement.achievements[Achievement.shogunSummoned].toggle();

        }else if(item.traits.contains(ItemTraitFactory.HEALING) && item.traits.contains(ItemTraitFactory.ZAP)) {
            alchemyShop.setShopKeep(ab);
            alchemyShop.setQuip("Holy fuck, you actually fixed me.");
            Achievement.announcmentDiv.appendHtml("News: AB Recovered!   ");
            Achievement.achievements[Achievement.abFixed].toggle();
        }else {
            ticksRemaining += -1;
        }
    }else if(alchemyShop.shopKeep == shogun) { //shogun banished by pigeons, but will come back unless you fix AB
        if(item.traits.contains(ItemTraitFactory.PIGEON)) {

            alchemyShop.setShopKeep(abGlitch);
            ticksRemaining = 3;
            alchemyShop.setQuip("Oh fuck. That did not feel good. But I'm not fixed yet, asshole.");
            Achievement.announcmentDiv.appendHtml("News: Shogun Banished! :) :) :) <a target='_blank' href = 'index2.html?prophecy=pigeon'>What's this?</a>  ");
            Achievement.achievements[Achievement.shogunBanished].toggle();
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
    achivementDiv = querySelector("#achievements");


    Achievement.gristDiv = querySelector("#grist");
    Achievement.levelDiv = querySelector("#level");
    Achievement.announcmentDiv = querySelector("#announcement");
    Achievement.syncGristDiv();

    //make achievements, then set alchemy skill based on those, then popular sylladex so refreshed items are level appropriate
    Achievement.makeAchievements(achivementDiv, querySelector("#achievementLabel"));
    setAlchemySkill();
    populateSylladex();
    makeAlchemyButton();
    makeDropDowns();
    makeStatsDisplay();
}

void setAlchemySkill() {
    for(AssociatedStat a in player.associatedStats) {
        if(a.stat == Stats.ALCHEMY) {
            double oldSkill = a.multiplier;
                //number of achievements you have is your current alchemy skill.
            if(Achievement.achievements.isEmpty) {
               a.multiplier = 0.0;
            }else {
                a.multiplier = Achievement.numFinishedAchievements()/(Achievement.achievements.length/13);

                if(a.multiplier.floor() - oldSkill.floor() >= 1.0) {

                    Achievement.setLevel(a.multiplier.round());
                    Achievement.announcmentDiv.setInnerHtml("Leveled up to ${a.multiplier.round()}! Items purchased in shop will last longer!");
                }
            }
        }
    }
}

void cheatShowPossibilities(Item item1, Item item2) {
   List<AlchemyResult> results =  AlchemyResult.planAlchemy(<Item>[item1, item2],player.session);
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

AlchemyResult getResult(String operation, Item item1, Item item2) {
    AlchemyResult alchemyResult;
    if(operation == AND) {
        //
        alchemyResult = new AlchemyResultAND(<Item> [item1, item2]);
    }else if(operation == OR) {
        alchemyResult = new AlchemyResultOR(<Item> [item1, item2]);
    }else if(operation == XOR) {
        alchemyResult = new AlchemyResultXOR(<Item> [item1, item2]);
    }
    return alchemyResult;
}

void makeAlchemyButton() {
    alchemizeButton = querySelector("#alchemyButton");

    alchemizeButton.onClick.listen((e) {
        Achievement.addGrist(-1*getAlchemyCost());
        Achievement.announcmentDiv.setInnerHtml("");
        Item item1 =findItemNamed(firstItemSelect.selectedOptions[0].value);
        Item item2 =findItemNamed(secondItemSelect.selectedOptions[0].value);
        String operation = operatorSelect.selectedOptions[0].value;
        AlchemyResult alchemyResult;

        alchemyResult = getResult(operation, item1, item2);
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
        Iterable<Item> validItems = player.sylladex.where((Item a) => (a.canUpgrade(true)));
        //item1TraitsDiv = (renderItemStats(validItems.first));
        //item2TraitsDiv = (renderItemStats(item2));
        item1Div.append(item1TraitsDiv);
        item2Div.append(item2TraitsDiv);
        //take alchemy result, look for combined traits, make sure the achievements get unlocked appropriately.
        processAchievements(alchemyResult.result);
        if(!item1.canUpgrade(true)) {
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
            Achievement a = Achievement.achievements[it];
            if(a != null) {
                String doop = (Achievement.achievements[it].toggle());
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

    setAlchemySkill();

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

    Item item1 =findItemNamed(firstItemSelect.selectedOptions[0].value);
    Item item2 =findItemNamed(secondItemSelect.selectedOptions[0].value);
   item1TraitsDiv = (renderItemStats(item1));
    item1Div.append(item1TraitsDiv);
    item2TraitsDiv = (renderItemStats(item2));
    item2Div.append(item2TraitsDiv);
}

Item findItemNamed(String name) {
    Item ret;
    for(Item i in player.sylladex) {
        if(i.fullName == name) {
            //
            ret = i;
        }
    }
    return ret;
}

void quip(Item item) {
    Random rand = new Random();
    alchemyShop.setQuip(rand.pickFrom(alchemyShop.shopKeep.randomQuips));
}

int getAlchemyCost() {
    Item item1 = findItemNamed(firstItemSelect.selectedOptions[0].value);
    Item item2 = findItemNamed(secondItemSelect.selectedOptions[0].value);
    String operator = operatorSelect.selectedOptions[0].value;
    AlchemyResult alchemyResult = getResult(operator, item1, item2);
    return alchemyResult.result.rank.abs().round()+1;
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
        alchemizeButton.setInnerHtml("Alchemize For: ${getAlchemyCost()}");
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
        alchemizeButton.setInnerHtml("Alchemize For: ${getAlchemyCost()}");
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
        alchemizeButton.setInnerHtml("Alchemize For: ${getAlchemyCost()}");
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
        ..style.maxWidth = "250px"
        ..id = name;

    for(Item a in list) {
        if(a.canUpgrade(true)) {
            OptionElement o = new OptionElement()
                ..value = a.toString()
                ..setInnerHtml(a.toString());
            selector.add(o, null);
        }
    }
    div.append(selector);
    if(name.contains("First")){
        selector.selectedIndex = 0;
    }else if(selector.options.length > 1){
        selector.selectedIndex = 1;
    }
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
    rank.setInnerHtml("Rank: ${item.rank.round()}");
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
    static int _level = 0;
    static String WONCLASS = "passedAchievement";
    static String NOTYETCLASS = "missingAchievement";
    static Element announcmentDiv;
    static Element label;
    static Element gristDiv;
    static Element levelDiv;


    static Map<CombinedTrait, Achievement> achievements = <CombinedTrait, Achievement>{};


    static CombinedTrait shogunSummoned;

  static CombinedTrait shogunBanished;

  static CombinedTrait abGlitched;

  static CombinedTrait abFixed;
  static ButtonElement clearButton;
  static bool won = false;


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

    static int setGrist(int amount) {
        _grist = amount;
        syncGristDiv();
    }

    static int setLevel(int amount) {

        _level = amount;
        syncLevelDiv();
    }



    static void syncLevelDiv() {

        levelDiv.setInnerHtml("Level: ${_level}");
    }

    static void syncGristDiv() {
        gristDiv.setInnerHtml("Grist: ${_grist}");
    }

    String toggle() {
        if(div.classes.contains(NOTYETCLASS)) {


            div.classes.remove(NOTYETCLASS);
            div.classes.add(WONCLASS);
            int amount = ((trait.rank.abs() + 1) * 13).round(); //no you can't lose money for getting an achievement.
            Achievement._grist += amount;
            Achievement.syncNumAchievements();
            return "${trait.name}(+${amount} grist)";
        }


        return null;
    }

    void makeElement(Element container) {
        div = new DivElement();

        div.classes.add(NOTYETCLASS);

        div.setInnerHtml("${trait.name}");
        container.append(div);
    }

    bool get achieved {
        return div.classes.contains(Achievement.WONCLASS);
    }


    static int numFinishedAchievements() {
        int ret = 0;
        for(Achievement a in achievements.values) {
            if(a.achieved) {
                ret ++;
            }
        }
        return ret;
    }

    static void checkWin() {
        if(numFinishedAchievements() == achievements.values.length && won==false) {
            won = true;
            window.alert("Whoa. You won!");
            announcmentDiv.setInnerHtml("Holy fuck, you won! <a target='_blank' href ='index2.html?lawnring=prospit'>Enjoy Hanging out with these OTHER obsessive assholes.</a> Take a screenshot of as many of your achievements as you can manage if you want a special role on the discord.");
        }
    }

    static void syncNumAchievements() {
        save();

        if(clearButton == null) {
            clearButton = new ButtonElement();
            clearButton.id = "clearButton";
            clearButton.setInnerHtml("Clear Save Data?");
            clearButton.onClick.listen((e) {
                clear();
                window.location.reload();
                //window.localStorage.clear(); //fuck no, this will kill more than just achievements if i ever expands.
            });
        }

        Achievement.label.setInnerHtml("${numFinishedAchievements()}/${achievements.values.length} (AutoSaved)");
        Achievement.label.append(clearButton);
        checkWin();
    }



    static void save() {

        for(CombinedTrait a in Achievement.achievements.keys) {
            if(Achievement.achievements[a].achieved) {
                //
                window.localStorage[a.name] = "true" ;
            }else {
                //window.localStorage[a.name] = "false" ; too spammy
            }
        }

        //don't actually save/load grist, loading achievments will get you money
        //window.localStorage[grist] = "${Achievement.grist}";
    }


    static void clear() {

        for(CombinedTrait a in Achievement.achievements.keys) {
            window.localStorage.remove(a.name);
        }
    }

    static void load() {
        for(CombinedTrait a in Achievement.achievements.keys) {
            if(window.localStorage[a.name] == "true") {
                //
                Achievement.achievements[a].toggle();
            }
        }
        //Achievement.setGrist(int.parse(window.localStorage[grist])); //don't actually save and load, toggling will get you money back
        syncGristDiv();
        if(Achievement.grist <= 0) Achievement.setGrist(13); // you can't fuck yourself over completely.

    }


    static void makeAchievements(Element container,Element label) {
        Achievement.label = label;
        List<CombinedTrait> traits = new List<CombinedTrait>.from(ItemTraitFactory.combinedTraits);
        for(CombinedTrait t in traits) {
            if(t.descriptions.isNotEmpty) {

                Achievement.achievements[t] = new Achievement(t, container);
            }
        }
        shogunSummoned =  new CombinedTrait("Shogun Summoned",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[]);
        shogunBanished =  new CombinedTrait("Shogun Banished",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[]);
        abGlitched =  new CombinedTrait("AB Glitched",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[]);
        abFixed =  new CombinedTrait("AB Fixed",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[]);
        Achievement.achievements[shogunSummoned] = new Achievement(shogunSummoned,container);
        Achievement.achievements[shogunBanished] = new Achievement(shogunBanished,container);
        Achievement.achievements[abGlitched] = new Achievement(abGlitched,container);
        Achievement.achievements[abFixed] = new Achievement(abFixed,container);
        load();
        //cheat test
        /*
        for(Achievement a in Achievement.achievements.values) {
            a.toggle();
        }
        */
        syncNumAchievements();

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

        if(!(shop.shopKeep is ShogunShopKeep)) {
            div.setInnerHtml("${item.fullName}");
        }else {
            div.setInnerHtml(item.shogunDescription(new Random()));
        }
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
      int cost = (shop.shopKeep.priceModifier * (item.rank.abs()+1) * -5).round();


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
        button.setInnerHtml("Lol, You can't Afford ${cost}.");
      }
  }
}

class ShopItemPlayerOwns extends ShopItem {
    ShopItemPlayerOwns(Item item,Shop shop, Element container) : super(item, shop, container);

  //on sale add grist to Achivement.grist and remove item from player.sylladex and add to Shop Inventory.
  @override
  void renderTransactButton() {
      ButtonElement button = new ButtonElement();
      int cost = (((item.rank.abs()+1) * 2)/ shop.shopKeep.priceModifier ).round();

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
        items.sort(); //cheap first.
        for(Item i in items.reversed) {
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

    ShopKeep(ImageElement this.imageElement, Element this.textElement);

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
    List<String> xorQuips = <String>["Are you sure a fleshy meat bag like you can understand something as complicated as XOR?","Color me impressed.","There is a 96.98% chance you are totally lost here."];
    @override
    List<String> randomQuips = <String>["Wow. I hope I don't need to explain that if you clear your cookies or your history or whatever for this page you lose you save data. That would just be a fucking embarrassment.","Hey remember how you have that terrible condition called 'being organic'? Turns out you need to eat and sleep and take occasional breaks and shit. Who knew? Luckily my superior robo-brain anticipated this, and made sure JR would make your grist and achievements auto-save. Not your items tho. You could do with some adversity.","What's that? You don't like my sunny disposition? Have a heaping helping of 'fuck' and 'you'. You're lucky I'm here at all.","So, it seems JR was a lazy piece of shit who didn't want to figure out how to save an infinite array of shitty items. Your grist and achievements and shit will save, your items won't. Don't bitch to me when your inferior fleshy brain forgets this and you lose your shit. ","Hey. Pay attention, asshole. Your achievements and your grist gets saved. YOUR ITEMS DO NOT. Might wanna sell all your shit before quitting.","...","Bored.","Wow. It's Alchemy.","Yep, this is definitely a good use of my time.","You know what would be smart? Getting an imposibly fast super computer to manage your fucking alchemy binge. Wait. No. The reverse of that.","Fuck you."];

  ABShopKeep(ImageElement imageElement, Element textElement) : super(imageElement, textElement);

    @override
    String getItemDescription(Item item) {
        Random rand = new Random();
        double mathpercent = 90+rand.nextDouble(10.0);
        mathpercent = (mathpercent * 100).round()/100;
        String upgrade = "It's only good for selling anymore.";
        if(item.canUpgrade(true) ) upgrade = "You can upgrade this, dunkass.";
        return "There is a ${mathpercent}% chance that this ${item.fullName} has these traits: ${turnArrayIntoHumanSentence(new List.from(item.traits))}. $upgrade ${item.abDescription(rand)}";
    }
}

class GlitchAB extends ABShopKeep {

    @override
    List<String> randomQuips = <String>["Oh. Fuck.","What did you DO!?","FIX THIS!!!"];

    @override
    String imageSource = "images/Alchemy/abGlitch.gif";
    List<ItemTrait> associatedTraits = <ItemTrait>[ItemTraitFactory.CORRUPT, ItemTraitFactory.ZAP];

    GlitchAB(ImageElement imageElement, Element textElement) : super(imageElement, textElement);

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

  ABJShopKeep(ImageElement imageElement, Element textElement) : super(imageElement, textElement);



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

  ShogunShopKeep(ImageElement imageElement, Element textElement) : super(imageElement, textElement);

    @override
    String getItemDescription(Item item) {
        return "${item.shogunDescription(new Random())}";
    }


}


class ABWins
{
    List<AlchemyResult> results;
    int index = 0;


    ABWins(this.results);

    Future<Null> win() async{

        new Timer(new Duration(milliseconds: 50), () => next());
    }

    bool next() {


        if(index >= results.length) {
            return false;
        }
        Achievement.announcmentDiv.appendHtml("${index}, ");
        processAchievements(results[index].result);
        index ++;
        new Timer(new Duration(milliseconds: 50), () => next());
    }


}
