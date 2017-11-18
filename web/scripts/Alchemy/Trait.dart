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

//What does it look like?
//TODO eventually tie to images?
class ItemAppearanceTrait extends ItemTrait {
  ItemAppearanceTrait(List<String> descriptions, double rank) : super(descriptions, rank);
}

class ItemTraitFactory {
  static Set<ItemTrait> allTraits = new Set<ItemTrait>();
  //these are what shape it has? doubles as both specibus kinds and basic objects.
  static ItemAppearanceTrait GENERIC;
  static ItemAppearanceTrait SWORD;
  static ItemAppearanceTrait HAMMER;
  static ItemAppearanceTrait RIFLE;
  static ItemAppearanceTrait PISTOL;
  static ItemAppearanceTrait BLADE;
  static ItemAppearanceTrait DAGGER;
  static ItemAppearanceTrait SANTA;
  static ItemAppearanceTrait FIST;
  static ItemAppearanceTrait SICKLE;
  static ItemAppearanceTrait CHAINSAW;
  static ItemAppearanceTrait FORK;
  static ItemAppearanceTrait DICE;
  static ItemAppearanceTrait NEEDLE;
  static ItemAppearanceTrait STAFF;
  static ItemAppearanceTrait WHIP;
  static ItemAppearanceTrait BOW;
  static ItemAppearanceTrait CLUB;
  static ItemAppearanceTrait BROOM;
  static ItemAppearanceTrait BOOK;
  static ItemAppearanceTrait ROADSIGN;
  static ItemAppearanceTrait AXE;
  static ItemAppearanceTrait LANCE;
  static ItemAppearanceTrait SHIELD;
  static ItemAppearanceTrait CANE;
  static ItemAppearanceTrait YOYO;
  static ItemAppearanceTrait SLING;
  static ItemAppearanceTrait SHURIKEN;
  static ItemAppearanceTrait MACHINEGUN;
  static ItemAppearanceTrait GRENADE;
  static ItemAppearanceTrait BALL;
  static ItemAppearanceTrait TRIDENT;
  static ItemAppearanceTrait CARD;
  static ItemAppearanceTrait FRYINGPAN;
  static ItemAppearanceTrait PILLOW;
  static ItemAppearanceTrait SHOTGUN;
  static ItemAppearanceTrait CHAIN;
  static ItemAppearanceTrait WRENCH;
  static ItemAppearanceTrait SHOVEL;
  static ItemAppearanceTrait ROLLINGPIN;
  static ItemAppearanceTrait PUPPET;
  static ItemAppearanceTrait RAZOR;
  static ItemAppearanceTrait PEN;
  static ItemAppearanceTrait BUST;
  static ItemAppearanceTrait BOWLING;
  static ItemAppearanceTrait GOLFCLUB;
  static ItemAppearanceTrait KNIFE;
  static ItemAppearanceTrait SCISSOR;
  static ItemAppearanceTrait SAFE;




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

  static void init() {
    initAppearances();
    initFunctions();
  }

  static void initAppearances() {
    //it's sharp, it's pointy and it's a sword
    GENERIC = new ItemAppearanceTrait(<String>["perfectly generic"], 0.1);
    SWORD = new ItemAppearanceTrait(<String>["a sword"], 0.4);
    HAMMER = new ItemAppearanceTrait(<String>["a hammer"], 0.4);
    RIFLE = new ItemAppearanceTrait(<String>["a rifle"], 0.4);
    PISTOL = new ItemAppearanceTrait(<String>["a pistol"], 0.4);
    BLADE = new ItemAppearanceTrait(<String>["a blade"], 0.4);
    DAGGER = new ItemAppearanceTrait(<String>["a dagger"], 0.4);
    SANTA = new ItemAppearanceTrait(<String>["a santa"], 0.4);
    FIST = new ItemAppearanceTrait(<String>["a fist"], 0.4);
    CLAWS = new ItemAppearanceTrait(<String>["claws"], 0.4);
    GRENADE = new ItemAppearanceTrait(<String>["a grenade"], 0.4);
    SAFE = new ItemAppearanceTrait(<String>["a freaking safe"], 0.4);
    BALL = new ItemAppearanceTrait(<String>["a ball"], 0.4);
    TRIDENT = new ItemAppearanceTrait(<String>["a trident"], 0.4);
    CARD = new ItemAppearanceTrait(<String>["a card"], 0.4);
    FRYINGPAN = new ItemAppearanceTrait(<String>["a frying pan"], 0.4);
    PILLOW = new ItemAppearanceTrait(<String>["a pillow"], 0.4);
    MACHINEGUN = new ItemAppearanceTrait(<String>["a machinegun"], 0.4);
    SHURIKEN = new ItemAppearanceTrait(<String>["a shuriken"], 0.4);
    SLING = new ItemAppearanceTrait(<String>["a sling"], 0.4);
    YOYO = new ItemAppearanceTrait(<String>["a yoyo"], 0.4);
    CANE = new ItemAppearanceTrait(<String>["a cane"], 0.4);
    SHIELD = new ItemAppearanceTrait(<String>["a shield"], 0.4);
    LANCE = new ItemAppearanceTrait(<String>["a lance"], 0.4);
    AXE = new ItemAppearanceTrait(<String>["a ax"], 0.4);
    ROADSIGN = new ItemAppearanceTrait(<String>["a sign"], 0.4);
    BOOK = new ItemAppearanceTrait(<String>["a book"], 0.4);
    BROOM = new ItemAppearanceTrait(<String>["a broom"], 0.4);
    CLUB = new ItemAppearanceTrait(<String>["a club"], 0.4);
    BOW = new ItemAppearanceTrait(<String>["a bow"], 0.4);
    WHIP = new ItemAppearanceTrait(<String>["a whip"], 0.4);
    STAFF = new ItemAppearanceTrait(<String>["a staff"], 0.4);
    NEEDLE = new ItemAppearanceTrait(<String>["a needle"], 0.4);
    DICE = new ItemAppearanceTrait(<String>["dice"], 0.4);
    FORK = new ItemAppearanceTrait(<String>["a fork"], 0.4);
    CHAINSAW = new ItemAppearanceTrait(<String>["a chainsaw"], 0.4);
    SICKLE = new ItemAppearanceTrait(<String>["a sickle"], 0.4);
    SHOTGUN = new ItemAppearanceTrait(<String>["a shotgun"], 0.4);
    SICKLE = new ItemAppearanceTrait(<String>["a sickle"], 0.4);
    CHAIN = new ItemAppearanceTrait(<String>["a chain"], 0.4);
    WRENCH = new ItemAppearanceTrait(<String>["a wrench"], 0.4);
    SHOVEL = new ItemAppearanceTrait(<String>["a shovel"], 0.4);
    ROLLINGPIN = new ItemAppearanceTrait(<String>["a rolling pin"], 0.4);
    PUPPET = new ItemAppearanceTrait(<String>["a puppet"], 0.4);
    RAZOR = new ItemAppearanceTrait(<String>["a razor"], 0.4);
    PEN = new ItemAppearanceTrait(<String>["a pen"], 0.4);
    BUST = new ItemAppearanceTrait(<String>["a bust"], 0.4);
    BOWLING = new ItemAppearanceTrait(<String>["a bowling ball"], 0.4);
    GOLFCLUB = new ItemAppearanceTrait(<String>["a golf club"], 0.4);
    KNIFE = new ItemAppearanceTrait(<String>["a knife"], 0.4);
    SCISSOR = new ItemAppearanceTrait(<String>["scissors"], 0.4);


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
