/*
http://mspaintadventures.wikia.com/wiki/Alchemiter

Appropriately for AND combining, an && alchemy result will often demonstrate the functionality of both components
 – e.g. Dave's iShades can be a phone and a rad pair of shades – while an || alchemy result will typically have the
  functionality of only one of the components, but the form of the other – e.g. the Hammerhead Pogo Ride, which is
   just a pogo that happens to be hammer-shaped.
 */

abstract class ItemTrait {
  List<String> descriptions = new List<String>();
  double rank = 1.0;
  ItemTrait(List<String> this.descriptions, this.rank) {
    ItemTraitFactory.allTraits.add(this);
  }


}

//what can this do?
class ItemFunctionTrait extends ItemTrait {
  ItemFunctionTrait(List<String> descriptions, double rank) : super(descriptions, rank);
  //TODO eventually has something to do with combat? piercing v slashing etc.

}

//what kind of object are you? Not in name.
class ItemObjectTrait extends ItemAppearanceTrait {
  ItemObjectTrait(List<String> descriptions, double rank) : super(descriptions, rank);
}

//What does it look like?
//TODO eventually tie to images?
class ItemAppearanceTrait extends ItemTrait {
  ItemAppearanceTrait(List<String> descriptions, double rank) : super(descriptions, rank);
}

class CombinedTrait extends ItemTrait implements Comparable<CombinedTrait> {

  //if i can get rid of a word entirely, then it needs to happen.
  //otherwise, the more traits i can get rid of , the better.
  int get priority {
    if(descriptions.isEmpty) return 1300;
    return subTraits.length;
  }

  //naturally sorted by priority
  @override
  int compareTo(CombinedTrait other) {
    return (other.priority - priority).round(); //TODO or is it the otherway around???
  }

  List<ItemTrait> subTraits;
  CombinedTrait(List<String> descriptions, double rank, this.subTraits) : super(descriptions, rank);

  bool traitsMatchMe(Set<ItemTrait> traits) {
    //following https://github.com/dart-lang/sdk/issues/2217
    //or would it be the other way around? need to make sure i test that all traits must be in subtraits, but not opposite
    return traits.every(subTraits.contains);
  }

  static Set<ItemTrait> lookForCombinedTraits(Set<ItemTrait> traits) {
    Set<ItemTrait> copiedTraits = new Set<ItemTrait>.from(traits);
    Set<ItemTrait> ret = new Set<ItemTrait>();
    List<CombinedTrait> foundCombinedTraits = new List<CombinedTrait>();
    for(CombinedTrait ct in ItemTraitFactory.combinedTraits) {
      if(ct.traitsMatchMe(copiedTraits)) foundCombinedTraits.add(ct);
    }

    foundCombinedTraits.sort(); //now they are sorted by priority.
    for(CombinedTrait ct in foundCombinedTraits) {
      if(ct.traitsMatchMe(copiedTraits)) {
        ret.add(ct);
        for(ItemTrait t in ct.subTraits) {
          copiedTraits.remove(t);
        }
      }
    }
    //anything i couldn't turn into a combo gets passed through.
    if(copiedTraits.isNotEmpty) ret.addAll(copiedTraits);
    return ret;
    /*
    TODO:

      Go through all combined traits. see if the traits list matches them. if so, add to list.

      Then, sort found combined traits by priority.

      for each combined trait, if you can find it's subtraits in the copied list
        then add it to the foundCombinedTraits and remove it's subtraits from the list.

        return foundCombinedTraits and any remaining copiedTraits.



     */

  }
}

class ItemTraitFactory {
  static Set<ItemTrait> allTraits = new Set<ItemTrait>();

  static Iterable<ItemFunctionTrait> get functionalTraits => allTraits.where((ItemTrait a) => (a is ItemFunctionTrait));
  static Iterable<ItemFunctionTrait> get appearanceTraits => allTraits.where((ItemTrait a) => (a is ItemAppearanceTrait && !(a is ItemObjectTrait)));
  static Iterable<ItemFunctionTrait> get objectTraits => allTraits.where((ItemTrait a) => (a is ItemObjectTrait));
  static Iterable<CombinedTrait> get combinedTraits => allTraits.where((ItemTrait a) => (a is CombinedTrait));


  //these are what shape it has? doubles as both specibus kinds and basic objects.
  static ItemObjectTrait GENERIC;
  static ItemObjectTrait SWORD;
  static ItemObjectTrait HAMMER;
  static ItemObjectTrait RIFLE;
  static ItemObjectTrait PISTOL;
  static ItemObjectTrait BLADE;
  static ItemObjectTrait DAGGER;
  static ItemObjectTrait SANTA;
  static ItemObjectTrait FIST;
  static ItemObjectTrait SICKLE;
  static ItemObjectTrait CHAINSAW;
  static ItemObjectTrait FORK;
  static ItemObjectTrait DICE;
  static ItemObjectTrait NEEDLE;
  static ItemObjectTrait STAFF;
  static ItemObjectTrait WHIP;
  static ItemObjectTrait BOW;
  static ItemObjectTrait CLUB;
  static ItemObjectTrait BROOM;
  static ItemObjectTrait BOOK;
  static ItemObjectTrait ROADSIGN;
  static ItemObjectTrait AXE;
  static ItemObjectTrait LANCE;
  static ItemObjectTrait SHIELD;
  static ItemObjectTrait CANE;
  static ItemObjectTrait YOYO;
  static ItemObjectTrait SLING;
  static ItemObjectTrait SHURIKEN;
  static ItemObjectTrait MACHINEGUN;
  static ItemObjectTrait GRENADE;
  static ItemObjectTrait BALL;
  static ItemObjectTrait TRIDENT;
  static ItemObjectTrait CARD;
  static ItemObjectTrait FRYINGPAN;
  static ItemObjectTrait PILLOW;
  static ItemObjectTrait SHOTGUN;
  static ItemObjectTrait CHAIN;
  static ItemObjectTrait WRENCH;
  static ItemObjectTrait SHOVEL;
  static ItemObjectTrait ROLLINGPIN;
  static ItemObjectTrait PUPPET;
  static ItemObjectTrait RAZOR;
  static ItemObjectTrait PEN;
  static ItemObjectTrait BUST;
  static ItemObjectTrait BOWLING;
  static ItemObjectTrait GOLFCLUB;
  static ItemObjectTrait KNIFE;
  static ItemObjectTrait SCISSOR;
  static ItemObjectTrait SAFE;




  //these would be "color" i guess? material it's made of?
  static ItemAppearanceTrait METAL;
  static ItemAppearanceTrait CLAWS;
  static ItemAppearanceTrait CERAMIC;
  static ItemAppearanceTrait BONE;
  static ItemAppearanceTrait WOOD;
  static ItemAppearanceTrait PLASTIC;
  static ItemAppearanceTrait RUBBER;
  static ItemAppearanceTrait PAPER;
  static ItemAppearanceTrait CLOTH;
  static ItemAppearanceTrait STONE;
  static ItemAppearanceTrait GLASS;
  static ItemAppearanceTrait LEGENDARY;

  static ItemFunctionTrait EDGED;
  static ItemFunctionTrait POINTY;
  static ItemFunctionTrait BLUNT;
  static ItemFunctionTrait HEAVY;
  static ItemFunctionTrait SHOOTY;
  static ItemFunctionTrait ONFIRE;
  static ItemFunctionTrait LUCKY;
  static ItemFunctionTrait DOOMED;
  static ItemFunctionTrait EXPLODEY;
  static ItemFunctionTrait COLD;
  static ItemFunctionTrait ZAP;
  static ItemFunctionTrait POISON;
  static ItemFunctionTrait MUSICAL;
  static ItemFunctionTrait VALUABLE;
  static ItemFunctionTrait ENRAGING;
  static ItemFunctionTrait RESTRAINING;
  static ItemFunctionTrait PRETTY;
  static ItemFunctionTrait COMFORTABLE;
  static ItemFunctionTrait SMART;
  static ItemFunctionTrait ROMANTIC;
  static ItemFunctionTrait FUNNY;
  static ItemFunctionTrait EDIBLE;
  static ItemFunctionTrait COOLK1D;
  static ItemFunctionTrait MAGICAL;
  static ItemFunctionTrait CLASSY;

  static CombinedTrait FORGED;
  static CombinedTrait DULLEDGED;
  static CombinedTrait DULLPOINTED;

  static void init() {
    initAppearances();
    initFunctions();
    initObjects();
    initCombined();//IMPORTANT has to be last cuz references others.
  }

  static void initCombined() {
    FORGED = new CombinedTrait(<String>["forged"], 0.0, <ItemTrait>[METAL, EDGED]);
    DULLEDGED = new CombinedTrait(<String>[], 0.0, <ItemTrait>[BLUNT, EDGED]);
    DULLPOINTED = new CombinedTrait(<String>[], 0.0, <ItemTrait>[BLUNT, POINTY]);
  }

  static void initObjects() {
    //it's sharp, it's pointy and it's a sword
    GENERIC = new ItemObjectTrait(<String>["perfectly generic"], 0.1);
    SWORD = new ItemObjectTrait(<String>["a sword"], 0.4);
    HAMMER = new ItemObjectTrait(<String>["a hammer"], 0.4);
    RIFLE = new ItemObjectTrait(<String>["a rifle"], 0.4);
    PISTOL = new ItemObjectTrait(<String>["a pistol"], 0.4);
    BLADE = new ItemObjectTrait(<String>["a blade"], 0.4);
    DAGGER = new ItemObjectTrait(<String>["a dagger"], 0.4);
    SANTA = new ItemObjectTrait(<String>["a santa"], 0.4);
    FIST = new ItemObjectTrait(<String>["a fist"], 0.4);
    CLAWS = new ItemObjectTrait(<String>["claws"], 0.4);
    GRENADE = new ItemObjectTrait(<String>["a grenade"], 0.4);
    SAFE = new ItemObjectTrait(<String>["a freaking safe"], 0.4);
    BALL = new ItemObjectTrait(<String>["a ball"], 0.4);
    TRIDENT = new ItemObjectTrait(<String>["a trident"], 0.4);
    CARD = new ItemObjectTrait(<String>["a card"], 0.4);
    FRYINGPAN = new ItemObjectTrait(<String>["a frying pan"], 0.4);
    PILLOW = new ItemObjectTrait(<String>["a pillow"], 0.4);
    MACHINEGUN = new ItemObjectTrait(<String>["a machinegun"], 0.4);
    SHURIKEN = new ItemObjectTrait(<String>["a shuriken"], 0.4);
    SLING = new ItemObjectTrait(<String>["a sling"], 0.4);
    YOYO = new ItemObjectTrait(<String>["a yoyo"], 0.4);
    CANE = new ItemObjectTrait(<String>["a cane"], 0.4);
    SHIELD = new ItemObjectTrait(<String>["a shield"], 0.4);
    LANCE = new ItemObjectTrait(<String>["a lance"], 0.4);
    AXE = new ItemObjectTrait(<String>["a ax"], 0.4);
    ROADSIGN = new ItemObjectTrait(<String>["a sign"], 0.4);
    BOOK = new ItemObjectTrait(<String>["a book"], 0.4);
    BROOM = new ItemObjectTrait(<String>["a broom"], 0.4);
    CLUB = new ItemObjectTrait(<String>["a club"], 0.4);
    BOW = new ItemObjectTrait(<String>["a bow"], 0.4);
    WHIP = new ItemObjectTrait(<String>["a whip"], 0.4);
    STAFF = new ItemObjectTrait(<String>["a staff"], 0.4);
    NEEDLE = new ItemObjectTrait(<String>["a needle"], 0.4);
    DICE = new ItemObjectTrait(<String>["dice"], 0.4);
    FORK = new ItemObjectTrait(<String>["a fork"], 0.4);
    CHAINSAW = new ItemObjectTrait(<String>["a chainsaw"], 0.4);
    SICKLE = new ItemObjectTrait(<String>["a sickle"], 0.4);
    SHOTGUN = new ItemObjectTrait(<String>["a shotgun"], 0.4);
    SICKLE = new ItemObjectTrait(<String>["a sickle"], 0.4);
    CHAIN = new ItemObjectTrait(<String>["a chain"], 0.4);
    WRENCH = new ItemObjectTrait(<String>["a wrench"], 0.4);
    SHOVEL = new ItemObjectTrait(<String>["a shovel"], 0.4);
    ROLLINGPIN = new ItemObjectTrait(<String>["a rolling pin"], 0.4);
    PUPPET = new ItemObjectTrait(<String>["a puppet"], 0.4);
    RAZOR = new ItemObjectTrait(<String>["a razor"], 0.4);
    PEN = new ItemObjectTrait(<String>["a pen"], 0.4);
    BUST = new ItemObjectTrait(<String>["a bust"], 0.4);
    BOWLING = new ItemObjectTrait(<String>["a bowling ball"], 0.4);
    GOLFCLUB = new ItemObjectTrait(<String>["a golf club"], 0.4);
    KNIFE = new ItemObjectTrait(<String>["a knife"], 0.4);
    SCISSOR = new ItemObjectTrait(<String>["scissors"], 0.4);
  }

  static void initAppearances() {
    METAL = new ItemAppearanceTrait(<String>["metal"], 0.3);
    CERAMIC = new ItemAppearanceTrait(<String>["ceramic"], -0.3);
    BONE = new ItemAppearanceTrait(<String>["bone"], 0.1);
    WOOD = new ItemAppearanceTrait(<String>["wood"], -0.3);
    PLASTIC = new ItemAppearanceTrait(<String>["plastic"], -0.3);
    RUBBER = new ItemAppearanceTrait(<String>["rubber"], -0.3);
    PAPER = new ItemAppearanceTrait(<String>["paper"], -0.3);
    CLOTH = new ItemAppearanceTrait(<String>["cloth", "fabric"], -0.3);
    GLASS = new ItemAppearanceTrait(<String>["glass", "crystal"], -0.3);
    STONE = new ItemAppearanceTrait(<String>["stone", "rock", "concrete"], 0.3);
    LEGENDARY = new ItemAppearanceTrait(<String>["legendary"], 13.0);
  }

  static void initFunctions() {
    EDGED = new ItemFunctionTrait(["edged", "sharp", "honed", "keen", "bladed"], 0.3);
    LUCKY = new ItemFunctionTrait(["lucky", "fortunate", "gambler's", "favored", "charmed"], 0.3);
    DOOMED = new ItemFunctionTrait(["doomed", "cursed", "unlucky"], -0.3);
    POINTY = new ItemFunctionTrait(["pointy", "sharp", "sharpened", "barbed", "piked", "sharpened","pronged", "pointed"], 0.3);
    EXPLODEY = new ItemFunctionTrait(["exploding", "explosive", "detonating", "grenade"], 0.6);
    ZAP = new ItemFunctionTrait(["electrical", "zap", "lightning", "shock"], 0.6);
    RESTRAINING = new ItemFunctionTrait(["restraining", "imprisoning", "restricting"], 0.3);
    VALUABLE = new ItemFunctionTrait(["expensive", "valuable", "bling", "money"], 0.1);
    EDIBLE = new ItemFunctionTrait(["edible", "tasty", "delicious", "savory"], 0.1);
    CLASSY = new ItemFunctionTrait(["classy", "distinguished", "tasteful", "cultured"], 0.1);
    COOLK1D = new ItemFunctionTrait(["cool", "wicked","radical", "awesome", "groovy", "tubular","bitching","sick nasty","bodacious"], 0.1);
    SMART = new ItemFunctionTrait(["intelligent", "smart", "useful", "scientific"], 0.1);
    ROMANTIC = new ItemFunctionTrait(["romantic","amorous", "passionate","tender","affectionate","lovey-dovey"], 0.1);
    FUNNY = new ItemFunctionTrait(["funny", "hilarious", "SBAHJ", "comedy gold"], 0.1);
    ENRAGING = new ItemFunctionTrait(["annoying", "enraging", "dickish", "asshole"], 0.1);
    MAGICAL = new ItemFunctionTrait(["magical", "mystical", "magickal", "wizardy"], 0.6);
    PRETTY = new ItemFunctionTrait(["fashionable", "aesthetic", "pretty", "beautiful"], 0.1);
    COMFORTABLE = new ItemFunctionTrait(["comfortable", "comforting", "soft", "cozy", "snug", "pleasant"], -0.1);
    POISON = new ItemFunctionTrait(["poisonous", "venomous", "draining", "poison"], 0.6);
    COLD = new ItemFunctionTrait(["chilly", "chill", "cold", "freezing", "icy", "frozen", "ice"], 0.6);
    HEAVY = new ItemFunctionTrait(["heavy", "weighs a ton", "heavy","heavy enough to kill a cat"], 0.4);
    ONFIRE = new ItemFunctionTrait(["fire", "burning", "blazing", "hot", "heated", "on fire", "combusting", "flaming", "fiery"], 0.6);
    BLUNT = new ItemFunctionTrait(["blunt", "bludgeoning", "dull"], 0.3);
    SHOOTY = new ItemFunctionTrait(["shooty", "ranged", "projectile", "piercing", "loaded", "full of ammo", "long-range"], 0.3);
    MUSICAL = new ItemFunctionTrait(["musical", "melodic", "harmonious", "tuneful", "euphonious", "mellifluous,"], 0.1);
  }
}
