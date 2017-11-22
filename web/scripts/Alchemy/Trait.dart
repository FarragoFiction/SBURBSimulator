/*
http://mspaintadventures.wikia.com/wiki/Alchemiter

Appropriately for AND combining, an && alchemy result will often demonstrate the functionality of both components
 – e.g. Dave's iShades can be a phone and a rad pair of shades – while an || alchemy result will typically have the
  functionality of only one of the components, but the form of the other – e.g. the Hammerhead Pogo Ride, which is
   just a pogo that happens to be hammer-shaped.
 */

abstract class ItemTrait {
  static int DEFAULT = 0;
  static int OPINION = 1;
  static int SIZE = 2;
  static int SHAPE = 3;
  static int CONDITION = 4;
  static int AGE = 5;
  static int COLOR = 6;
  static int PATTERN = 7;
  static int ORIGIN = 8;
  static int MATERIAL = 9;
  static int PURPOSE = 10;

  //what kind of adj am i, what order should i be displayed?
  int ordering;
  List<String> descriptions = new List<String>();
  double rank = 1.0;
  ItemTrait(List<String> this.descriptions, this.rank, this.ordering) {
    ItemTraitFactory.allTraits.add(this);
  }

  @override
  String toString() {
    if(this.descriptions.isNotEmpty) return this.descriptions.first;
    return "NULL TRAIT";
  }

  //not natural though, cuz combined trait is diff
  int compareOrdering(ItemTrait other) {
    return (ordering - other.ordering).round(); //do lower numbers first.
  }


}

//what can this do?
class ItemFunctionTrait extends ItemTrait {
  ItemFunctionTrait(List<String> descriptions, double rank, int ordering) : super(descriptions, rank, ordering);

  //TODO eventually has something to do with combat? piercing v slashing etc.

}

//what kind of object are you? Not in name.
class ItemObjectTrait extends ItemAppearanceTrait {
  ItemObjectTrait(List<String> descriptions, double rank, int ordering) : super(descriptions, rank, ordering);
}

//What does it look like?
//TODO eventually tie to images?
class ItemAppearanceTrait extends ItemTrait {
  ItemAppearanceTrait(List<String> descriptions, double rank, int ordering) : super(descriptions, rank, ordering);
}

class CombinedTrait extends ItemTrait implements Comparable<CombinedTrait> {

  //the more traits i can get rid of , the better.
  int get priority {
    return subTraits.length;
  }

  //naturally sorted by priority
  @override
  int compareTo(CombinedTrait other) {
    return (other.priority - priority).round(); //TODO or is it the otherway around???
  }

  List<ItemTrait> subTraits;
  CombinedTrait(List<String> descriptions, double rank, int ordering, this.subTraits) : super(descriptions, rank,ordering);

  bool traitsMatchMe(Set<ItemTrait> traits) {
    //following https://github.com/dart-lang/sdk/issues/2217
    //return traits.every(subTraits.contains); <-- wrong.
    return subTraits.every(traits.contains); //<-- right

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
  static ItemObjectTrait PIGEON;
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
  static ItemObjectTrait STICK;
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
  static ItemAppearanceTrait SHITTY;
  static ItemAppearanceTrait WOOD;
  static ItemAppearanceTrait PLASTIC;
  static ItemAppearanceTrait RUBBER;
  static ItemAppearanceTrait PAPER;
  static ItemAppearanceTrait CLOTH;
  static ItemAppearanceTrait STONE;
  static ItemAppearanceTrait GLASS;
  static ItemAppearanceTrait GHOSTLY;
  static ItemAppearanceTrait FLESH;
  static ItemAppearanceTrait FUR;
  static ItemAppearanceTrait FEATHER;
  static ItemAppearanceTrait UGLY;
  static ItemAppearanceTrait LEGENDARY;

  static ItemFunctionTrait EDGED;
  static ItemFunctionTrait SCARY;
  static ItemFunctionTrait POINTY;
  static ItemFunctionTrait BLUNT;
  static ItemFunctionTrait HEAVY;
  static ItemFunctionTrait SHOOTY;
  static ItemFunctionTrait ONFIRE;
  static ItemFunctionTrait LUCKY;
  static ItemFunctionTrait GLOWING;
  static ItemFunctionTrait OBSCURING;
  static ItemFunctionTrait CALMING;
  static ItemFunctionTrait NUCLEAR;
  static ItemFunctionTrait DOOMED;
  static ItemFunctionTrait EXPLODEY;
  static ItemFunctionTrait COLD;
  static ItemFunctionTrait ZAP;
  static ItemFunctionTrait POISON;
  static ItemFunctionTrait MUSICAL;
  static ItemFunctionTrait VALUABLE;
  static ItemFunctionTrait ENRAGING;
  static ItemFunctionTrait HEALING;
  static ItemFunctionTrait RESTRAINING;
  static ItemFunctionTrait PRETTY;
  static ItemFunctionTrait COMFORTABLE;
  static ItemFunctionTrait UNCOMFORTABLE;
  static ItemFunctionTrait SMART;
  static ItemFunctionTrait SENTIENT;
  static ItemFunctionTrait ROMANTIC;
  static ItemFunctionTrait FUNNY;
  static ItemFunctionTrait EDIBLE;
  static ItemFunctionTrait COOLK1D;
  static ItemFunctionTrait MAGICAL;
  static ItemFunctionTrait CLASSY;
  static ItemFunctionTrait FAKE;
  static ItemFunctionTrait REAL;
  static ItemFunctionTrait LOUD;

  static CombinedTrait FORGED;
  static CombinedTrait SPOOPY;
  static CombinedTrait WOLVERINE;
  static CombinedTrait DULLEDGED;
  static CombinedTrait DULLPOINTED;
  static CombinedTrait SOFTHARD;
  static CombinedTrait FOSSILIZED;
  static CombinedTrait ADAMANTIUM;
  static CombinedTrait TATAMI;
  static CombinedTrait MESH;
  static CombinedTrait FOIL;
  static CombinedTrait BEANBAG;
  static CombinedTrait PLEATHER;
  static CombinedTrait PLYWOOD;
  static CombinedTrait ROBOTIC;
  static CombinedTrait ROTTING;
  static CombinedTrait LIGHTVOID;
  static CombinedTrait DOOMLUCK;
  static CombinedTrait CANDY;
  static CombinedTrait COTTONCANDY;
  static CombinedTrait GUM;
  static CombinedTrait EDIBLEPOISON;
  static CombinedTrait MARROW;
  static CombinedTrait TOOTHY;
  static CombinedTrait CRYSTAL;
  static CombinedTrait MARYSUE;
  static CombinedTrait EDGELORD;
  static CombinedTrait DEADPOOL;
  static CombinedTrait RABBITSFOOT;
  static CombinedTrait ARROWHEAD;
  static CombinedTrait ARROW;
  static CombinedTrait KENDO;
  static CombinedTrait IRONIC;
  static CombinedTrait NET;
  static CombinedTrait MORNINGSTAR;
  static CombinedTrait BARBWIRE;
  static CombinedTrait DECADENT;
  static CombinedTrait SBAHJ;
  static CombinedTrait BAYONET;
  static CombinedTrait SNOOPSNOW;
  static CombinedTrait LIGHTSABER;
  static CombinedTrait FAKEYFAKE;
  static CombinedTrait REALTHING;
  static CombinedTrait SKELETAL;
  static CombinedTrait GREENSUN;
  static CombinedTrait MIDNIGHT;
  static CombinedTrait RADIENT;
  static CombinedTrait EDGEY;
  static CombinedTrait ABOMB;
  static CombinedTrait ULTRAVIOLENCE;
  static CombinedTrait LIVING;
  static CombinedTrait TASER;
  static CombinedTrait NOCTURNE;
  static CombinedTrait DIRGE;
  static CombinedTrait SNOBBBISH;
  static CombinedTrait FLAT;
  static CombinedTrait SHARPCLOTHES;
  static CombinedTrait SHARPNOTE;
  static CombinedTrait BACHS;
  static CombinedTrait MOZARTS;
  static CombinedTrait EINSTEINS;
  static CombinedTrait FEYNMANS;
  static CombinedTrait ZIPTIE;
  static CombinedTrait SMARTPHONE;
  static CombinedTrait SASSACRE;
  static CombinedTrait SLEDGE;
  static CombinedTrait LEGAL;
  static CombinedTrait CLOWN;
  static CombinedTrait PASSIONATE;
  static CombinedTrait PINATA;
  static CombinedTrait ANVIL;
  static CombinedTrait FLASHBANG;
  static CombinedTrait SMOKEBOMB;
  static CombinedTrait NINJA;
  static CombinedTrait TECHNO;
  static CombinedTrait ROCKNROLL;
  static CombinedTrait PISTOLSHRIMP;
  static CombinedTrait JUGGALO;
  static CombinedTrait SHOCKSAUCE;
  static CombinedTrait WEAKSAUCE;
  static CombinedTrait SPICY;
  static CombinedTrait ICECREAM;
  static CombinedTrait SCHEZWAN;
  static CombinedTrait VAPORWAVE;
  static CombinedTrait MALLET;
  static CombinedTrait FIDGET;
  static CombinedTrait GOLDFOIL;
  static CombinedTrait CAVIAR;
  static CombinedTrait RADNUCLEAR;
  static CombinedTrait GLAM;
  static CombinedTrait HAIRMETAL;
  static CombinedTrait ELVEN;
  static CombinedTrait SHINY;
  static CombinedTrait BESPOKE;
  static CombinedTrait OPERATIC;
  static CombinedTrait ICE;
  static CombinedTrait ICECOLD;
  static CombinedTrait WINTER;
  static CombinedTrait SANTAS;
  static CombinedTrait HALLOWEEN;
  static CombinedTrait MUTANT;
  static CombinedTrait SKATEBOARD;
  static CombinedTrait MICROWAVE;
  static CombinedTrait URANIUM;
  static CombinedTrait MOUSEPAD;
  static CombinedTrait FLINT1;
  static CombinedTrait FLINT2;
  static CombinedTrait PICNIC;
  static CombinedTrait XTREME;
  static CombinedTrait LAWN;
  static CombinedTrait UPHOLSTERED;
  static CombinedTrait LEATHER;
  static CombinedTrait SHAG;
  static CombinedTrait LOYAL;
  static CombinedTrait PORCELAIN;
  static CombinedTrait KATANA;
  static CombinedTrait PORKHOLLOW;
  static CombinedTrait CHOCOLATES;
  static CombinedTrait FOILCHOCOLATES;
  static CombinedTrait SCRATCHNSNIFF;
  static CombinedTrait MYTHRIL;
  static CombinedTrait TITANIUM;
  static CombinedTrait LEAD;
  static CombinedTrait ONION;
  static CombinedTrait COMEDYGOLD;
  static CombinedTrait DRY;
  static CombinedTrait POLITE;
  static CombinedTrait STRADIVARIUS;
  static CombinedTrait SCIENTISTIC;
  static CombinedTrait AI;
  static CombinedTrait ROBOTIC2;
  static CombinedTrait SHRAPNEL;
  static CombinedTrait VOCALOID;
  static CombinedTrait HYUNAE;
  static CombinedTrait BUCKSHOT;
  static CombinedTrait CANON;
  static CombinedTrait STATIONARY;
  static CombinedTrait PAPERBOOK;
  static CombinedTrait METALGUN;
  static CombinedTrait PAPERCUT;
  static CombinedTrait SQUEAKY;
  static CombinedTrait KAZOO;
  static CombinedTrait BANDAID;
  static CombinedTrait GUSHERS;
  static CombinedTrait MEDIC;
  static CombinedTrait SICKNASTY;


  static void init() {
    initAppearances();
    initFunctions();
    initObjects();
    initCombined();//IMPORTANT has to be last cuz references others.
  }

  static void initCombined() {
    FORGED = new CombinedTrait(<String>["forged", "sharpened", "honed", "filed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[METAL, EDGED, POINTY]);
    DULLEDGED = new CombinedTrait(<String>[], 0.0, ItemTrait.MATERIAL,<ItemTrait>[BLUNT, EDGED]);
    FOSSILIZED = new CombinedTrait(<String>["fossilized"], 0.0, ItemTrait.CONDITION,<ItemTrait>[BONE, STONE]);
    ADAMANTIUM = new CombinedTrait(<String>["fossilized"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE, METAL]);
    DULLPOINTED = new CombinedTrait(<String>[], 0.0,ItemTrait.MATERIAL, <ItemTrait>[BLUNT, POINTY]);
    SOFTHARD = new CombinedTrait(<String>[], 0.0, ItemTrait.MATERIAL,<ItemTrait>[COMFORTABLE, UNCOMFORTABLE]);
    TATAMI = new CombinedTrait(<String>["tatami"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[CLOTH, WOOD]);
    MESH = new CombinedTrait(<String>["mesh", "chain link"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH, METAL]);
    FOIL = new CombinedTrait(<String>["foil"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PAPER, METAL]);
    BEANBAG = new CombinedTrait(<String>["beanbag"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH, STONE]);
    PLEATHER = new CombinedTrait(<String>["pleather", "faux fur"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FUR, PLASTIC]);
    PLYWOOD = new CombinedTrait(<String>["plywood"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD, PAPER]);
    ROBOTIC = new CombinedTrait(<String>["robotic"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL, FLESH]);
    ROTTING = new CombinedTrait(<String>["rotting", "zombie"], 0.0,ItemTrait.CONDITION, <ItemTrait>[UGLY, FLESH]);
    LIGHTVOID = new CombinedTrait(<String>["Ultraviolet"], 0.0,ItemTrait.COLOR, <ItemTrait>[GLOWING, OBSCURING]);
    ULTRAVIOLENCE = new CombinedTrait(<String>["Ultraviolence"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[GLOWING, OBSCURING, EDGED]);
    DOOMLUCK = new CombinedTrait(<String>[], 0.0, ItemTrait.PURPOSE,<ItemTrait>[DOOMED, LUCKY]);
    CANDY = new CombinedTrait(<String>["candy"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EDIBLE, GLASS]);
    COTTONCANDY = new CombinedTrait(<String>["cotton candy"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EDIBLE, CLOTH]);
    GUM = new CombinedTrait(<String>["gummy"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[EDIBLE, RUBBER]);
    MARROW = new CombinedTrait(<String>["marrow"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[EDIBLE, BONE]);
    TOOTHY = new CombinedTrait(<String>["toothy"], 0.0,ItemTrait.SHAPE, <ItemTrait>[BONE, CERAMIC]);
    EDIBLEPOISON = new CombinedTrait(<String>["arsenic", "antifreeze"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDIBLE, POISON]);
    CRYSTAL = new CombinedTrait(<String>["crystal", "diamond", "quartz"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE, GLASS]);
    MARYSUE = new CombinedTrait(<String>["mary sue", "sakura katana chan", "shitty oc"], 0.0, ItemTrait.OPINION, <ItemTrait>[PRETTY, ROMANTIC, FUNNY, SMART, CLASSY, LUCKY, MAGICAL]);
    EDGELORD = new CombinedTrait(<String>["edge lord", "coldsteel the hedgehog"], 0.0,ItemTrait.OPINION, <ItemTrait>[SCARY, OBSCURING, EDGED, LEGENDARY, DOOMED, SMART, CLASSY, COOLK1D]);
    DEADPOOL = new CombinedTrait(<String>["deadpool"], 0.0,ItemTrait.SHAPE, <ItemTrait>[UGLY, HEALING, COOLK1D, FUNNY]);
    SPOOPY = new CombinedTrait(<String>["spoopy", "skellington's", "creppy"], 0.0,ItemTrait.OPINION, <ItemTrait>[SCARY, COOLK1D]);
    WOLVERINE = new CombinedTrait(<String>["wolverine"], 0.0,ItemTrait.SHAPE, <ItemTrait>[BONE, EDGED, POINTY]);
    RABBITSFOOT = new CombinedTrait(<String>["rabbit's foot"], 0.0,ItemTrait.SHAPE, <ItemTrait>[LUCKY, FUR]);
    ARROWHEAD = new CombinedTrait(<String>["tipped", "reinforced", "arrowhead"], 0.0,ItemTrait.CONDITION, <ItemTrait>[POINTY, WOOD]);
    ARROW = new CombinedTrait(<String>["arrow", "flechette", "bolt"], 0.0, ItemTrait.SHAPE,<ItemTrait>[POINTY, SHOOTY]);
    KENDO = new CombinedTrait(<String>["training sword", "bokken"], 0.0,ItemTrait.SHAPE, <ItemTrait>[WOOD, EDGED]);
    IRONIC = new CombinedTrait(<String>["ironic"], 0.0,ItemTrait.OPINION, <ItemTrait>[FAKE, COOLK1D]);
    NET = new CombinedTrait(<String>["netted", "webbed"], 0.0,ItemTrait.SHAPE, <ItemTrait>[RESTRAINING, CLOTH]);
    BARBWIRE = new CombinedTrait(<String>["barbed wire"], 0.0, ItemTrait.SHAPE,<ItemTrait>[POINTY, RESTRAINING, METAL, CLOTH]);
    MORNINGSTAR = new CombinedTrait(<String>["morning star"], 0.0,ItemTrait.SHAPE, <ItemTrait>[POINTY, BLUNT]);
    DECADENT = new CombinedTrait(<String>["decadent"], 0.0, ItemTrait.OPINION,<ItemTrait>[COMFORTABLE, VALUABLE]);
    SBAHJ = new CombinedTrait(<String>["SBAHJ"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[SHITTY, COOLK1D]);
    BAYONET = new CombinedTrait(<String>["bayonet"], 0.0,ItemTrait.SHAPE, <ItemTrait>[POINTY, SHOOTY]);
    SNOOPSNOW = new CombinedTrait(<String>["Snoop Dog's Snow Cone Machete"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[COLD, COOLK1D, EDGED]);
    LIGHTSABER = new CombinedTrait(<String>["light saber"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[GLOWING, ONFIRE, EDGED]);
    FAKEYFAKE = new CombinedTrait(<String>["fake as shit", "fakey fake", "bullshit"], 0.0, ItemTrait.OPINION,<ItemTrait>[MAGICAL, FAKE]);
    REALTHING = new CombinedTrait(<String>["real as shit", "suprisingly real"], 0.0,ItemTrait.OPINION, <ItemTrait>[MAGICAL, REAL]);
    SKELETAL = new CombinedTrait(<String>["skeletal"], 0.0, ItemTrait.SHAPE,<ItemTrait>[SCARY, DOOMED, BONE]);
    GREENSUN = new CombinedTrait(<String>["green sun"], 0.0, ItemTrait.PATTERN,<ItemTrait>[ONFIRE, NUCLEAR, GLOWING]);
    MIDNIGHT = new CombinedTrait(<String>["midnight", "3 In The Morning"], 0.0,ItemTrait.COLOR, <ItemTrait>[OBSCURING, CLASSY]);
    RADIENT = new CombinedTrait(<String>["radiant", "dazzling"], 0.0,ItemTrait.OPINION, <ItemTrait>[MAGICAL, GLOWING]);
    EDGEY = new CombinedTrait(<String>["edgy"], 0.0,ItemTrait.OPINION, <ItemTrait>[EDGED, OBSCURING]);
    ABOMB = new CombinedTrait(<String>["A-Bomb", "Warhead", "Chernobyl"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[NUCLEAR, EXPLODEY]);
    LIVING = new CombinedTrait(<String>["living"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE, FLESH, SENTIENT]);
    TASER = new CombinedTrait(<String>["taser"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ZAP, RESTRAINING]);
    NOCTURNE = new CombinedTrait(<String>["nocturn"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[OBSCURING, MUSICAL]);
    DIRGE = new CombinedTrait(<String>["dirge"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[DOOMED, MUSICAL]);
    SNOBBBISH = new CombinedTrait(<String>["snobbish"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLASSY, VALUABLE]);
    FLAT = new CombinedTrait(<String>["flat"], 0.0,ItemTrait.OPINION, <ItemTrait>[BLUNT, MUSICAL]);
    SHARPNOTE = new CombinedTrait(<String>["sharp"], 0.0, ItemTrait.OPINION,<ItemTrait>[EDGED, MUSICAL]);
    SHARPCLOTHES = new CombinedTrait(<String>["sharp"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLASSY, MUSICAL]);
    BACHS = new CombinedTrait(<String>["Bach's"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[SMART, MUSICAL]);
    MOZARTS = new CombinedTrait(<String>["Mozart's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL, MUSICAL]);
    EINSTEINS = new CombinedTrait(<String>["Einstein's"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[SMART, NUCLEAR]);
    FEYNMANS = new CombinedTrait(<String>["Feynman's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SMART, FUNNY]);
    ZIPTIE = new CombinedTrait(<String>["Feynman's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[PLASTIC, RESTRAINING]);
    SMARTPHONE = new CombinedTrait(<String>["cellular","mobile","handheld","computerized"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[METAL, SMART]);
    SASSACRE = new CombinedTrait(<String>["Sassacre"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[HEAVY, FUNNY]);
    SLEDGE = new CombinedTrait(<String>["Sledge"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BLUNT, HEAVY]);
    LEGAL = new CombinedTrait(<String>["Legal"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RESTRAINING, PAPER]);
    CLOWN = new CombinedTrait(<String>["Clown"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[FUNNY, LOUD]);
    PASSIONATE = new CombinedTrait(<String>["passionate"], 0.0,ItemTrait.OPINION, <ItemTrait>[ONFIRE, ROMANTIC]);
    PINATA = new CombinedTrait(<String>["pinata"], 0.0, ItemTrait.SHAPE,<ItemTrait>[PAPER, EDIBLE]);
    ANVIL = new CombinedTrait(<String>["anvil"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BLUNT, HEAVY, METAL]);
    FLASHBANG = new CombinedTrait(<String>["flashbang"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[GLOWING, EXPLODEY]);
    SMOKEBOMB = new CombinedTrait(<String>["smokebomb"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING, EXPLODEY]);
    NINJA = new CombinedTrait(<String>["ninja"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING, EDGED]);
    TECHNO = new CombinedTrait(<String>["techno"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ZAP, MUSICAL]);
    ROCKNROLL = new CombinedTrait(<String>["rock and roll"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[STONE, MUSICAL]);
    PISTOLSHRIMP = new CombinedTrait(<String>["pistol shrimp", "horrifying"], 0.0,ItemTrait.SHAPE, <ItemTrait>[SENTIENT, FLESH, SHOOTY]);
    JUGGALO = new CombinedTrait(<String>["juggalo"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FUNNY, MUSICAL, LOUD]);
    SHOCKSAUCE = new CombinedTrait(<String>["shocksauce"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D, ZAP]);
    WEAKSAUCE = new CombinedTrait(<String>["weaksauce"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D, SHITTY]);
    SPICY = new CombinedTrait(<String>["spicy", "picante"], 0.0,ItemTrait.OPINION, <ItemTrait>[ONFIRE, EDIBLE]);
    ICECREAM = new CombinedTrait(<String>["ice cream", "popsicle"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[COLD, EDIBLE]);
    SCHEZWAN = new CombinedTrait(<String>["schezwan"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D, EDIBLE]);
    VAPORWAVE = new CombinedTrait(<String>["vaporwave"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING, MUSICAL, COOLK1D, ZAP]);
    MALLET = new CombinedTrait(<String>["mallet"], 0.0,ItemTrait.SHAPE, <ItemTrait>[WOOD, BLUNT]);
    FIDGET = new CombinedTrait(<String>["fidget"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLASTIC, COOLK1D]);
    GOLDFOIL = new CombinedTrait(<String>["gold foil"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL, PAPER, VALUABLE]);
    CAVIAR = new CombinedTrait(<String>["caviar"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[EDIBLE, VALUABLE]);
    RADNUCLEAR = new CombinedTrait(<String>["RADioactive"], 0.0,ItemTrait.OPINION, <ItemTrait>[NUCLEAR, COOLK1D]);
    GLAM = new CombinedTrait(<String>["glam"], 0.0,ItemTrait.OPINION, <ItemTrait>[STONE, MUSICAL, PRETTY]);
    HAIRMETAL = new CombinedTrait(<String>["hair metal"], 0.0,ItemTrait.OPINION, <ItemTrait>[METAL, MUSICAL, PRETTY]);
    ELVEN = new CombinedTrait(<String>["elven", "fae", "sylvan"], 0.0,ItemTrait.OPINION, <ItemTrait>[MAGICAL, PRETTY]);
    SHINY = new CombinedTrait(<String>["shiny"], 0.0,ItemTrait.OPINION, <ItemTrait>[METAL, PRETTY]);
    BESPOKE = new CombinedTrait(<String>["bespoke", "well-tailored", "glamorous"], 0.0,ItemTrait.OPINION, <ItemTrait>[VALUABLE, PRETTY, CLASSY]);
    OPERATIC = new CombinedTrait(<String>["operatic"], 0.0,ItemTrait.OPINION, <ItemTrait>[VALUABLE, MUSICAL, CLASSY]);
    ICE = new CombinedTrait(<String>["ice", "diamond"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[VALUABLE, COLD]);
    ICECOLD = new CombinedTrait(<String>["ice cold", "cold as fuck"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D, COLD]);
    WINTER = new CombinedTrait(<String>["winter's", "season's"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[CALMING, COLD]);
    SANTAS = new CombinedTrait(<String>["santa's", "christmas", "xmas"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL, COLD]);
    HALLOWEEN = new CombinedTrait(<String>["ghost's", "Bloody Mary", "Halloween"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL, SCARY]);
    MUTANT = new CombinedTrait(<String>["ghoul", "mutant"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[FLESH, NUCLEAR]);
    SKATEBOARD = new CombinedTrait(<String>["skate", "skateboard"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[COOLK1D, METAL]);
    MICROWAVE = new CombinedTrait(<String>["microwave"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[NUCLEAR, ZAP, EDIBLE]);
    URANIUM = new CombinedTrait(<String>["uranium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[NUCLEAR, STONE]);
    MOUSEPAD = new CombinedTrait(<String>["mousepad", "jar opener"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER, RUBBER]);
    FLINT1 = new CombinedTrait(<String>["flint"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EDGED, STONE]);
    FLINT2 = new CombinedTrait(<String>["flint"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[POINTY, STONE]);
    PICNIC = new CombinedTrait(<String>["picnic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLASTIC, POINTY]);
    XTREME = new CombinedTrait(<String>["xtreme xplosion"], 0.0, ItemTrait.OPINION,<ItemTrait>[COOLK1D, EXPLODEY]);
    LAWN = new CombinedTrait(<String>["lawn"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[PLASTIC, COMFORTABLE]);
    UPHOLSTERED = new CombinedTrait(<String>["upholstered"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[CLOTH, COMFORTABLE]);
    LEATHER = new CombinedTrait(<String>["leather"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FLESH, COMFORTABLE]);
    SHAG = new CombinedTrait(<String>["shag"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[FUR, COMFORTABLE]);
    LOYAL = new CombinedTrait(<String>["loyal"], 0.0, ItemTrait.OPINION,<ItemTrait>[BLUNT, ROMANTIC]);
    PORCELAIN = new CombinedTrait(<String>["porcelain"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PRETTY, CERAMIC]);
    PORKHOLLOW = new CombinedTrait(<String>["pork hollow", "piggy bank"], 0.0, ItemTrait.SHAPE,<ItemTrait>[VALUABLE, CERAMIC]);
    KATANA = new CombinedTrait(<String>["n1nj4","katana"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[COOLK1D, EDGED]);
    CHOCOLATES = new CombinedTrait(<String>["chocolate"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[ROMANTIC, EDIBLE]);
    FOILCHOCOLATES = new CombinedTrait(<String>["wrapped chocolate"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[ROMANTIC, EDIBLE,PAPER,METAL]);
    SCRATCHNSNIFF = new CombinedTrait(<String>["scratch-n-sniff"], 0.0, ItemTrait.MATERIAL, <ItemTrait>[COOLK1D, PAPER]);
    MYTHRIL = new CombinedTrait(<String>["mythril","orichalcum "],0.0, ItemTrait.MATERIAL, <ItemTrait>[MAGICAL, METAL]);
    TITANIUM = new CombinedTrait(<String>["titanium","steel"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[BLUNT, METAL]);
    LEAD = new CombinedTrait(<String>["lead"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[HEAVY, METAL]);
    ONION = new CombinedTrait(<String>["satire","parody","onion"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FAKE, FUNNY]);
    COMEDYGOLD = new CombinedTrait(<String>["comedy gold"], 0.0, ItemTrait.OPINION, <ItemTrait>[VALUABLE, FUNNY]);
    DRY = new CombinedTrait(<String>["dry"], 0.0, ItemTrait.OPINION,<ItemTrait>[CLASSY, FUNNY]);
    POLITE = new CombinedTrait(<String>["polite"], 0.0,ItemTrait.OPINION, <ItemTrait>[COMFORTABLE, FAKE]);
    STRADIVARIUS = new CombinedTrait(<String>["stradivarius"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[CLASSY, VALUABLE, WOOD, MUSICAL]);
    SCIENTISTIC = new CombinedTrait(<String>["scientistic"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,FAKE]); //<3 you fallout
    AI = new CombinedTrait(<String>["AI"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ZAP, SENTIENT]);
    ROBOTIC2 = new CombinedTrait(<String>["robotic"], 0.0, ItemTrait.CONDITION,<ItemTrait>[METAL, ZAP, SENTIENT]);
    SHRAPNEL = new CombinedTrait(<String>["shrapnel"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD, EXPLODEY]);
    VOCALOID = new CombinedTrait(<String>["vocaloid"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SENTIENT,ZAP, MUSICAL]);
    HYUNAE = new CombinedTrait(<String>["*Hyun-ae"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[SENTIENT,ZAP, ROMANTIC]); //is it a reference?
    BUCKSHOT = new CombinedTrait(<String>["buckshot"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD, SHOOTY]);
    CANON = new CombinedTrait(<String>["cannon"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEAVY, SHOOTY]);//bitches love canons
    STATIONARY = new CombinedTrait(<String>["stationary"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CLASSY, PAPER]);
    PAPERBOOK = new CombinedTrait(<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BOOK, PAPER]); //we can fucking assume this dunkass
    METALGUN = new CombinedTrait(<String>[], 0.0, ItemTrait.PURPOSE,<ItemTrait>[METAL, SHOOTY]); //we can fucking assume this dunkass
    PAPERCUT = new CombinedTrait(<String>["papercut"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDGED, PAPER]);
    SQUEAKY = new CombinedTrait(<String>["squeaky"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BLUNT, RUBBER]);
    KAZOO = new CombinedTrait(<String>["kazoo"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FAKE, MUSICAL]);
    BANDAID = new CombinedTrait(<String>["bandaid"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[HEALING, PAPER]);
    GUSHERS = new CombinedTrait(<String>["gushers"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[HEALING, EDIBLE]);
    MEDIC = new CombinedTrait(<String>["medic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING, SHOOTY]);
    SICKNASTY = new CombinedTrait(<String>["sick nasty","ill"], 0.0,ItemTrait.CONDITION, <ItemTrait>[COOLK1D, POISON]);

  }

  static void initObjects() {
    //it's sharp, it's pointy and it's a sword
    GENERIC = new ItemObjectTrait(<String>["perfectly generic"], 0.1,ItemTrait.OPINION);
    SWORD = new ItemObjectTrait(<String>["a sword"], 0.4,ItemTrait.SHAPE);
    HAMMER = new ItemObjectTrait(<String>["a hammer"], 0.4,ItemTrait.SHAPE);
    RIFLE = new ItemObjectTrait(<String>["a rifle"], 0.4,ItemTrait.SHAPE);
    PISTOL = new ItemObjectTrait(<String>["a pistol"], 0.4,ItemTrait.SHAPE);
    BLADE = new ItemObjectTrait(<String>["a blade"], 0.4,ItemTrait.SHAPE);
    DAGGER = new ItemObjectTrait(<String>["a dagger"], 0.4,ItemTrait.SHAPE);
    SANTA = new ItemObjectTrait(<String>["a santa"], 0.4,ItemTrait.SHAPE);
    FIST = new ItemObjectTrait(<String>["a fist"], 0.4,ItemTrait.SHAPE);
    CLAWS = new ItemObjectTrait(<String>["claws"], 0.4,ItemTrait.SHAPE);
    GRENADE = new ItemObjectTrait(<String>["a grenade"], 0.4,ItemTrait.SHAPE);
    SAFE = new ItemObjectTrait(<String>["a freaking safe"], 0.4,ItemTrait.SHAPE);
    BALL = new ItemObjectTrait(<String>["a ball"], 0.4,ItemTrait.SHAPE);
    TRIDENT = new ItemObjectTrait(<String>["a trident"], 0.4,ItemTrait.SHAPE);
    CARD = new ItemObjectTrait(<String>["a card"], 0.4,ItemTrait.SHAPE);
    FRYINGPAN = new ItemObjectTrait(<String>["a frying pan"], 0.4,ItemTrait.SHAPE);
    PILLOW = new ItemObjectTrait(<String>["a pillow"], 0.4,ItemTrait.SHAPE);
    MACHINEGUN = new ItemObjectTrait(<String>["a machinegun"], 0.4,ItemTrait.SHAPE);
    SHURIKEN = new ItemObjectTrait(<String>["a shuriken"], 0.4,ItemTrait.SHAPE);
    SLING = new ItemObjectTrait(<String>["a sling"], 0.4,ItemTrait.SHAPE);
    YOYO = new ItemObjectTrait(<String>["a yoyo"], 0.4,ItemTrait.SHAPE);
    CANE = new ItemObjectTrait(<String>["a cane"], 0.4,ItemTrait.SHAPE);
    SHIELD = new ItemObjectTrait(<String>["a shield"], 0.4,ItemTrait.SHAPE);
    LANCE = new ItemObjectTrait(<String>["a lance"], 0.4,ItemTrait.SHAPE);
    AXE = new ItemObjectTrait(<String>["a ax"], 0.4,ItemTrait.SHAPE);
    ROADSIGN = new ItemObjectTrait(<String>["a sign"], 0.4,ItemTrait.SHAPE);
    BOOK = new ItemObjectTrait(<String>["a book"], 0.4,ItemTrait.SHAPE);
    BROOM = new ItemObjectTrait(<String>["a broom"], 0.4,ItemTrait.SHAPE);
    CLUB = new ItemObjectTrait(<String>["a club"], 0.4,ItemTrait.SHAPE);
    BOW = new ItemObjectTrait(<String>["a bow"], 0.4,ItemTrait.SHAPE);
    WHIP = new ItemObjectTrait(<String>["a whip"], 0.4,ItemTrait.SHAPE);
    STAFF = new ItemObjectTrait(<String>["a staff"], 0.4,ItemTrait.SHAPE);
    NEEDLE = new ItemObjectTrait(<String>["a needle"], 0.4,ItemTrait.SHAPE);
    DICE = new ItemObjectTrait(<String>["dice"], 0.4,ItemTrait.SHAPE);
    FORK = new ItemObjectTrait(<String>["a fork"], 0.4,ItemTrait.SHAPE);
    PIGEON = new ItemObjectTrait(<String>["a pigeon???"], 1.3,ItemTrait.SHAPE);
    CHAINSAW = new ItemObjectTrait(<String>["a chainsaw"], 0.4,ItemTrait.SHAPE);
    SICKLE = new ItemObjectTrait(<String>["a sickle"], 0.4,ItemTrait.SHAPE);
    SHOTGUN = new ItemObjectTrait(<String>["a shotgun"], 0.4,ItemTrait.SHAPE);
    STICK = new ItemObjectTrait(<String>["a stick"], 0.4,ItemTrait.SHAPE);
    CHAIN = new ItemObjectTrait(<String>["a chain"], 0.4,ItemTrait.SHAPE);
    WRENCH = new ItemObjectTrait(<String>["a wrench"], 0.4,ItemTrait.SHAPE);
    SHOVEL = new ItemObjectTrait(<String>["a shovel"], 0.4,ItemTrait.SHAPE);
    ROLLINGPIN = new ItemObjectTrait(<String>["a rolling pin"], 0.4,ItemTrait.SHAPE);
    PUPPET = new ItemObjectTrait(<String>["a puppet"], 0.4,ItemTrait.SHAPE);
    RAZOR = new ItemObjectTrait(<String>["a razor"], 0.4,ItemTrait.SHAPE);
    PEN = new ItemObjectTrait(<String>["a pen"], 0.4,ItemTrait.SHAPE);
    BUST = new ItemObjectTrait(<String>["a bust"], 0.4,ItemTrait.SHAPE);
    BOWLING = new ItemObjectTrait(<String>["a bowling ball"], 0.4,ItemTrait.SHAPE);
    GOLFCLUB = new ItemObjectTrait(<String>["a golf club"], 0.4,ItemTrait.SHAPE);
    KNIFE = new ItemObjectTrait(<String>["a knife"], 0.4,ItemTrait.SHAPE);
    SCISSOR = new ItemObjectTrait(<String>["scissors"], 0.4,ItemTrait.SHAPE);
  }

  static void initAppearances() {
    METAL = new ItemAppearanceTrait(<String>["metal"], 0.3,ItemTrait.MATERIAL);
    CERAMIC = new ItemAppearanceTrait(<String>["ceramic"], -0.3,ItemTrait.MATERIAL);
    BONE = new ItemAppearanceTrait(<String>["bone"], 0.1,ItemTrait.MATERIAL);
    WOOD = new ItemAppearanceTrait(<String>["wood"], -0.3,ItemTrait.MATERIAL);
    PLASTIC = new ItemAppearanceTrait(<String>["plastic"], -0.3,ItemTrait.MATERIAL);
    RUBBER = new ItemAppearanceTrait(<String>["rubber"], -0.3,ItemTrait.MATERIAL);
    PAPER = new ItemAppearanceTrait(<String>["paper"], -0.3,ItemTrait.MATERIAL);
    CLOTH = new ItemAppearanceTrait(<String>["cloth", "fabric"], -0.3,ItemTrait.MATERIAL);
    GLASS = new ItemAppearanceTrait(<String>["glass"], -0.3,ItemTrait.MATERIAL);
    GHOSTLY = new ItemAppearanceTrait(<String>["ghostly","ectoplasm"], -0.3,ItemTrait.MATERIAL);
    FLESH = new ItemAppearanceTrait(<String>["flesh", "meat","muscle"], -0.1,ItemTrait.MATERIAL);
    FUR = new ItemAppearanceTrait(<String>["fur", "fluff","fuzzy"], -0.1,ItemTrait.MATERIAL);
    FEATHER = new ItemAppearanceTrait(<String>["feathery"], -0.1,ItemTrait.MATERIAL);

    UGLY = new ItemAppearanceTrait(<String>["gross", "ugly","unpleasant"], -0.1,ItemTrait.OPINION);
    SHITTY = new ItemAppearanceTrait(<String>["shitty", "poorly made","conksuck"], -13.0,ItemTrait.OPINION);
    STONE = new ItemAppearanceTrait(<String>["stone", "rock", "concrete"], 0.3,ItemTrait.MATERIAL);
    LEGENDARY = new ItemAppearanceTrait(<String>["legendary"], 13.0,ItemTrait.OPINION);
  }

  static void initFunctions() {
    EDGED = new ItemFunctionTrait(["edged", "sharp", "honed", "keen", "bladed"], 0.3,ItemTrait.OPINION);
    GLOWING = new ItemFunctionTrait(["glowing", "bright", "illuminated"], 0.1,ItemTrait.PATTERN);
    OBSCURING = new ItemFunctionTrait(["obscuring", "dark", "shadowy"], 0.1,ItemTrait.PATTERN);
    CALMING = new ItemFunctionTrait(["calming", "pale", "placating","shooshing"], 0.1,ItemTrait.OPINION);
    NUCLEAR = new ItemFunctionTrait(["nuclear", "radioactive", "irradiated"], 1.0,ItemTrait.CONDITION);
    SCARY = new ItemFunctionTrait(["scary", "horrifying", "terrifying","spooky"], 0.1,ItemTrait.OPINION);
    LUCKY = new ItemFunctionTrait(["lucky", "fortunate", "gambler's", "favored", "charmed"], 0.3,ItemTrait.OPINION);
    DOOMED = new ItemFunctionTrait(["doomed", "cursed", "unlucky"], -0.3,ItemTrait.OPINION);
    POINTY = new ItemFunctionTrait(["pointy", "piercing", "sharp", "barbed", "piked", "sharpened","pronged", "pointed"], 0.3,ItemTrait.CONDITION);
    EXPLODEY = new ItemFunctionTrait(["exploding", "explosive", "detonating", "grenade"], 0.6,ItemTrait.PURPOSE);
    ZAP = new ItemFunctionTrait(["electrical", "zap", "lightning", "shock"], 0.6,ItemTrait.PURPOSE);
    RESTRAINING = new ItemFunctionTrait(["restraining", "imprisoning", "restricting"], 0.3,ItemTrait.PURPOSE);
    VALUABLE = new ItemFunctionTrait(["expensive", "valuable", "bling", "money"], 0.1,ItemTrait.OPINION);
    EDIBLE = new ItemFunctionTrait(["edible", "tasty", "delicious", "savory"], 0.1,ItemTrait.OPINION);
    CLASSY = new ItemFunctionTrait(["classy", "distinguished", "tasteful", "cultured"], 0.1,ItemTrait.OPINION);
    COOLK1D = new ItemFunctionTrait(["cool", "wicked","radical", "awesome", "groovy", "tubular","bitching","bodacious"], 0.1,ItemTrait.OPINION);
    SMART = new ItemFunctionTrait(["intelligent", "smart", "useful", "scientific","encyclopedic"], 0.1,ItemTrait.OPINION);
    SENTIENT = new ItemFunctionTrait(["sentient", "aware", "conscious", "awake"], 0.1,ItemTrait.CONDITION);
    ROMANTIC = new ItemFunctionTrait(["romantic","amorous","tender","affectionate","lovey-dovey"], 0.1,ItemTrait.OPINION);
    FUNNY = new ItemFunctionTrait(["funny", "hilarious", "comedy"], 0.1,ItemTrait.OPINION);
    ENRAGING = new ItemFunctionTrait(["annoying", "enraging", "dickish", "asshole"], 0.1,ItemTrait.OPINION);
    MAGICAL = new ItemFunctionTrait(["magical", "mystical", "magickal", "wizardy"], 0.6,ItemTrait.OPINION);
    PRETTY = new ItemFunctionTrait(["pretty", "aesthetic", "fashionable", "beautiful"], 0.1,ItemTrait.OPINION);
    HEALING = new ItemFunctionTrait(["healing", "regenerating", "recovery", "life"], 0.3,ItemTrait.PURPOSE);
    UNCOMFORTABLE = new ItemFunctionTrait(["uncomfortable", "hard","unpleasant"], 0.1,ItemTrait.OPINION);

    COMFORTABLE = new ItemFunctionTrait(["comfortable", "comforting", "soft", "cozy", "snug", "pleasant"], -0.1,ItemTrait.OPINION);
    POISON = new ItemFunctionTrait(["poisonous", "venomous", "draining", "poison"], 0.6,ItemTrait.OPINION);
    COLD = new ItemFunctionTrait(["chilly", "chill", "cold", "freezing", "icy", "frozen", "ice"], 0.6,ItemTrait.OPINION);
    HEAVY = new ItemFunctionTrait(["heavy", "weighs a ton", "heavy","heavy enough to kill a cat"], 0.4,ItemTrait.OPINION);
    ONFIRE = new ItemFunctionTrait(["fire", "burning", "blazing", "hot", "heated", "on fire", "combusting", "flaming", "fiery"], 0.6,ItemTrait.OPINION);
    BLUNT = new ItemFunctionTrait(["blunt", "bludgeoning", "dull"], 0.3,ItemTrait.OPINION);
    SHOOTY = new ItemFunctionTrait(["shooty", "ranged", "projectile", "loaded", "long range"], 0.3,ItemTrait.PURPOSE);
    MUSICAL = new ItemFunctionTrait(["musical", "melodic", "harmonious", "tuneful", "euphonious", "mellifluous,"], 0.1,ItemTrait.OPINION);
    LOUD = new ItemFunctionTrait(["loud", "ear splitting", "noisy", "deafening", "thundering"], 0.3,ItemTrait.OPINION);
    FAKE = new ItemFunctionTrait(["fake", "false", "imitation", "simulated", "replica"], -0.3,ItemTrait.OPINION);
    REAL = new ItemFunctionTrait(["real", "actual", "believable", "geniune", "guaranteed","veritable"], 0.3,ItemTrait.OPINION);

  }
}
