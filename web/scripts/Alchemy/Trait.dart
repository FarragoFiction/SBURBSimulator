/*
http://mspaintadventures.wikia.com/wiki/Alchemiter

Appropriately for AND combining, an && alchemy result will often demonstrate the functionality of both components
 – e.g. Dave's iShades can be a phone and a rad pair of shades – while an || alchemy result will typically have the
  functionality of only one of the components, but the form of the other – e.g. the Hammerhead Pogo Ride, which is
   just a pogo that happens to be hammer-shaped.
 */

abstract class ItemTrait {
  static int FIRST = 0;
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

  String name = "JR NAME ME PLZ!!!";
  //the more traits i can get rid of , the better.
  int get priority {
    return subTraits.length;
  }

  //will this work?
  @override
  double get rank {
    double ret = 0.0;
    for(ItemTrait it in subTraits) {
      ret += it.rank;
    }

    return ret;
  }

  //naturally sorted by priority
  @override
  int compareTo(CombinedTrait other) {
    return (other.priority - priority).round(); //TODO or is it the otherway around???
  }

  List<ItemTrait> subTraits;
  CombinedTrait(this.name,List<String> descriptions, double rank, int ordering, this.subTraits) : super(descriptions, rank,ordering);

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

  static Iterable<ItemTrait> get functionalTraits => allTraits.where((ItemTrait a) => (a is ItemFunctionTrait));
  static Iterable<ItemTrait> get appearanceTraits => allTraits.where((ItemTrait a) => (a is ItemAppearanceTrait && !(a is ItemObjectTrait)));
  static Iterable<ItemTrait> get objectTraits => allTraits.where((ItemTrait a) => (a is ItemObjectTrait));
  static Iterable<ItemTrait> get combinedTraits => allTraits.where((ItemTrait a) => (a is CombinedTrait));


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
  static ItemAppearanceTrait CORRUPT;
  static ItemAppearanceTrait FUR;
  static ItemAppearanceTrait PLANT;
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
  static ItemFunctionTrait ASPECTAL;
  static ItemFunctionTrait CLASSRELATED;
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
  static CombinedTrait COLOSSUS;
  static CombinedTrait ROTTING;
  static CombinedTrait  DRAUGR;
  static CombinedTrait LIGHTVOID;
  static CombinedTrait DOOMLUCK;
  static CombinedTrait CANDY;
  static CombinedTrait COTTONCANDY;
  static CombinedTrait GUM;
  static CombinedTrait EDIBLEPOISON;
  static CombinedTrait MARROW;
  static CombinedTrait TOOTHY;
  static CombinedTrait FROST;
  static CombinedTrait CRYSTAL;
  static CombinedTrait MARYSUE;
  static CombinedTrait EDGELORD;
  static CombinedTrait DEADPOOL;
  static CombinedTrait RABBITSFOOT;
  static CombinedTrait ARROWHEAD;
  static CombinedTrait ARROW;
  static CombinedTrait KENDO;
  static CombinedTrait IRONICFAKECOOL;
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
  static CombinedTrait DEAD;
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
  static CombinedTrait POPSICKLE;
  static CombinedTrait ICEPICK;
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
  static CombinedTrait ICYHOT;
  static CombinedTrait ICECOLD;
  static CombinedTrait WINTER;
  static CombinedTrait CHRISTMAS;
  static CombinedTrait SANTASAWS;
  static CombinedTrait SANTASAWS2;
  static CombinedTrait SANTACLAWS;
  static CombinedTrait SANDYCLAWS;
  static CombinedTrait SILENTNIGHT;
  static CombinedTrait HALLOWEEN;
  static CombinedTrait MUTANT;
  static CombinedTrait SKATEBOARD;
  static CombinedTrait MICROWAVE;
  static CombinedTrait ORBITAL;
  static CombinedTrait DUMBSMART;
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
  static CombinedTrait GILDED;
  static CombinedTrait CHARGING;
  static CombinedTrait SAFETY1;
  static CombinedTrait SAFETY2;
  static CombinedTrait THUNDER;
  static CombinedTrait SCREECHING;
  static CombinedTrait MIRROR;
  static CombinedTrait CRYSTALBALL;
  static CombinedTrait DISABLING;
  static CombinedTrait FASHIONABLE;
  static CombinedTrait IRONICFUNNYCOOL;
  static CombinedTrait IRONICSHITTYFUNNY;
  static CombinedTrait POSTIRONIC;
  static CombinedTrait MONSTOROUS;
  static CombinedTrait ROOTY;
  static CombinedTrait GOLDEN;
  static CombinedTrait PLATINUM;
  static CombinedTrait HORSESHOE;
  static CombinedTrait FELT;
  static CombinedTrait GRANITE;
  static CombinedTrait MARBLE;
  static CombinedTrait GLITCHED;
  static CombinedTrait DEBUGGING;
  static CombinedTrait SURREAL;
  static CombinedTrait COUNTERFIT;
  static CombinedTrait PLACEBO;
  static CombinedTrait IMITATION;
  static CombinedTrait SIMULCRUM;
  static CombinedTrait METALIC;
  static CombinedTrait BRAINY;
  static CombinedTrait INCENDIARY;
  static CombinedTrait FAE;
  static CombinedTrait PLUTONIUM;
  static CombinedTrait LITHIUM;
  static CombinedTrait MOLTEN;
  static CombinedTrait MAGMA;
  static CombinedTrait MASQUERADE;
  static CombinedTrait RUSTY;
  static CombinedTrait ROMCOM;
  static CombinedTrait ALLURING;
  static CombinedTrait STONESKIN;
  static CombinedTrait PSIONIC;
  static CombinedTrait DWARVEN;
  static CombinedTrait ELEMENTAL;
  static CombinedTrait GOURMET;
  static CombinedTrait STAINEDGLASS;
  static CombinedTrait GAUZE;
  static CombinedTrait LOCKED;
  static CombinedTrait C4;
  static CombinedTrait FONZIE;
  static CombinedTrait ETCHED;
  static CombinedTrait PAPYRUS;
  static CombinedTrait FILM;
  static CombinedTrait SAUCEY;
  static CombinedTrait LOTTERY;
  static CombinedTrait BLINDFOLDED;
  static CombinedTrait POSSESED;
  static CombinedTrait INFERNAL;
  static CombinedTrait GEPETTO;
  static CombinedTrait ABOMINABLE;
  static CombinedTrait ASHEN;
  static CombinedTrait PALE;
  static CombinedTrait PITCH;
  static CombinedTrait LIT;
  static CombinedTrait HYPNOTIZING;
  static CombinedTrait TRANQUILIZING;
  static CombinedTrait CALMRAGE;
  static CombinedTrait GHOSTRIDER;
  static CombinedTrait LOGICAL;
  static CombinedTrait DUELIST;
  static CombinedTrait SILENCED;
  static CombinedTrait DEAUDLY;
  static CombinedTrait SCREAMING;
  static CombinedTrait CACOPHONY;
  static CombinedTrait SUBLIME;
  static CombinedTrait MASTERWORK;
  static CombinedTrait BROODFESTER;
  static CombinedTrait REDACTED;
  static CombinedTrait POPROCKS;
  static CombinedTrait DISGUISED;
  static CombinedTrait HAUNTED;
  static CombinedTrait COGNITOHAZARD;
  static CombinedTrait STATICY;
  static CombinedTrait JADITE;
  static CombinedTrait TICKLING;
  static CombinedTrait COMPOSITE;
  static CombinedTrait HIGHPOWERED;
  static CombinedTrait CONCUSSIVE;
  static CombinedTrait DOWN;
  static CombinedTrait PRICKLY;
  static CombinedTrait DEEPWEB;
  static CombinedTrait JAGGED;
  static CombinedTrait NANOFIBER;
  static CombinedTrait CLANGING;
  static CombinedTrait SILVER;
  static CombinedTrait WITHERED;
  static CombinedTrait SHATTERED;
  static CombinedTrait POTASSIUM;
  static CombinedTrait MINERS;
  static CombinedTrait SIGNING;
  static CombinedTrait MITOCHONDRIAL;
  static CombinedTrait BLACKOUT;
  static CombinedTrait ABSESTOS;
  static CombinedTrait MECURIAL;
  static CombinedTrait BULLETPROOF;
  static CombinedTrait COTTON;
  static CombinedTrait BLINDING;
  static CombinedTrait BRILLIANT;
  static CombinedTrait OFFENSIVE;
  static CombinedTrait POACHED;
  static CombinedTrait TAPESTRY;
  static CombinedTrait ITCHY;
  static CombinedTrait WISHBONE;
  static CombinedTrait RATTLING;
  static CombinedTrait CRANIAL;
  static CombinedTrait HUMERUS;
  static CombinedTrait MASSAGE;
  static CombinedTrait PESTERSOME;
  static CombinedTrait SHOCKWAVE;
  static CombinedTrait ANTIVENOM;
  static CombinedTrait WILLWISP;
  static CombinedTrait FIBERGLASS;
  static CombinedTrait SKULL;
  static CombinedTrait ENCHANTED;
  static CombinedTrait BESERKER;
  static CombinedTrait CLERICAL;
  static CombinedTrait CAUTERIZING;
  static CombinedTrait XRAY;
  static CombinedTrait CLEVER;
  static CombinedTrait FIREPLACE;
  static CombinedTrait CRACKLING;
  static CombinedTrait THUMPING;
  static CombinedTrait SHRIEKING;
  static CombinedTrait SURREALCORRUPTFUNNY;
  static CombinedTrait ALOE;
  static CombinedTrait ROSE;
  static CombinedTrait KNOCKKNOCK;
  static CombinedTrait LIFESTEAL;
  static CombinedTrait TRAGIC;
  static CombinedTrait SLAPSTICK;
  static CombinedTrait GROSSOUT;
  static CombinedTrait FLOWERY;
  static CombinedTrait POISONIVY;
  static CombinedTrait WINGED;
  static CombinedTrait FORBIDDENFRUIT;
  static CombinedTrait LAWFUL;
  static CombinedTrait CHAOTIC;
  static CombinedTrait HYPOTHERMIC;
  static CombinedTrait HYPERTHERMIC;
  static CombinedTrait SHACKLED;
  static CombinedTrait POETIC;
  static CombinedTrait HOLOGRAHPIC;
  static CombinedTrait CASKET;
  static CombinedTrait SPECTRAL;
  static CombinedTrait PHOENIX;
  static CombinedTrait TATTERED;
  static CombinedTrait WOODWIND;
  static CombinedTrait BONEHURTING;
  static CombinedTrait BONEHEALING;
  static CombinedTrait CALCIUM;
  static CombinedTrait FLEECE;
  static CombinedTrait POTTED;
  static CombinedTrait DIEASED;
  static CombinedTrait PORCUPINE;
  static CombinedTrait FANGED;
  static CombinedTrait BASALT;
  static CombinedTrait CANNED;
  static CombinedTrait OBSIDIAN;
  static CombinedTrait FENESTRATED;
  static CombinedTrait PLEXIGLASS;
  static CombinedTrait CERAMICWRAP;
  static CombinedTrait FUNGAL;
  static CombinedTrait THORNY;
  static CombinedTrait BULBED;
  static CombinedTrait GLASSCANNON;
  static CombinedTrait PLANTRUBBER;
  static CombinedTrait CELLULOSE;
  static CombinedTrait HORRORCORE;
  static CombinedTrait NIGHTCORE;
  static CombinedTrait BURDOCK;
  static CombinedTrait CRAZYBUSS;


  static void init() {
    initAppearances();
    initFunctions();
    initObjects();
    initCombined();//IMPORTANT has to be last cuz references others.
  }

  static void initCombined() {
    FORGED = new CombinedTrait("Forged",<String>["forged", "sharpened", "honed", "filed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[METAL, EDGED, POINTY]);
    DULLEDGED = new CombinedTrait("",<String>[], 0.0, ItemTrait.MATERIAL,<ItemTrait>[BLUNT, EDGED]);
    FOSSILIZED = new CombinedTrait("Fossilized",<String>["fossilized"], 0.0, ItemTrait.CONDITION,<ItemTrait>[BONE, STONE]);
    ADAMANTIUM = new CombinedTrait("Adamantium",<String>["adamantium"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE, METAL]);
    SOFTHARD = new CombinedTrait("",<String>[], 0.0, ItemTrait.MATERIAL,<ItemTrait>[COMFORTABLE, UNCOMFORTABLE]);
    TATAMI = new CombinedTrait("Tatami",<String>["tatami"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[CLOTH, WOOD]);
    MESH = new CombinedTrait("Mesh",<String>["mesh", "chain link"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH, METAL]);
    FOIL = new CombinedTrait("Foil",<String>["foil"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PAPER, METAL]);
    BEANBAG = new CombinedTrait("Beanbag",<String>["beanbag"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH, STONE]);
    PLEATHER = new CombinedTrait("Faux Fur",<String>["pleather", "faux fur"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FUR, PLASTIC]);
    PLYWOOD = new CombinedTrait("Plywood",<String>["plywood"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD, PAPER]);
    COLOSSUS = new CombinedTrait("Colossus",<String>["colossus"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL, FLESH]);
    ROTTING = new CombinedTrait("Rotting",<String>["rotting", "zombie"], 0.0,ItemTrait.CONDITION, <ItemTrait>[UGLY, FLESH]);
    DRAUGR = new CombinedTrait("Draugr",<String>["draugr", "white walker"], 0.0,ItemTrait.CONDITION, <ItemTrait>[UGLY, FLESH, COLD]);

    LIGHTVOID = new CombinedTrait("Ultraviolet",<String>["Ultraviolet"], 0.0,ItemTrait.COLOR, <ItemTrait>[GLOWING, OBSCURING]);
    ULTRAVIOLENCE = new CombinedTrait("Ultraviolence",<String>["Ultraviolence"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[GLOWING, OBSCURING, EDGED]);
    DOOMLUCK = new CombinedTrait("",<String>[], 0.0, ItemTrait.PURPOSE,<ItemTrait>[DOOMED, LUCKY]);
    CANDY = new CombinedTrait("Candy",<String>["candy"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EDIBLE, GLASS]);
    COTTONCANDY = new CombinedTrait("Cotton Candy",<String>["cotton candy"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EDIBLE, CLOTH]);
    GUM = new CombinedTrait("Gum",<String>["gummy"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[EDIBLE, RUBBER]);
    MARROW = new CombinedTrait("Marrow",<String>["marrow"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[EDIBLE, BONE]);
    TOOTHY = new CombinedTrait("Toothy",<String>["toothy"], 0.0,ItemTrait.SHAPE, <ItemTrait>[BONE, CERAMIC]);
    FROST = new CombinedTrait("Frost",<String>["Frost"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE, GLASS, FLESH]); //refrance
    EDIBLEPOISON = new CombinedTrait("Arsenic",<String>["arsenic", "antifreeze"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDIBLE, POISON]);
    CRYSTAL = new CombinedTrait("Crystal",<String>["crystal", "diamond", "quartz"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE, GLASS]);
    MARYSUE = new CombinedTrait("Mary Sue",<String>["mary sue", "sakura katana chan", "shitty oc"], 0.0, ItemTrait.OPINION, <ItemTrait>[PRETTY, ROMANTIC, FUNNY, SMART, CLASSY, LUCKY, MAGICAL]);
    EDGELORD = new CombinedTrait("Edge Lord",<String>["edge lord", "coldsteel the hedgehog"], 0.0,ItemTrait.OPINION, <ItemTrait>[SCARY, OBSCURING, EDGED, LEGENDARY, DOOMED, SMART, CLASSY, COOLK1D]);
    DEADPOOL = new CombinedTrait("Deadpool",<String>["deadpool"], 0.0,ItemTrait.SHAPE, <ItemTrait>[UGLY, HEALING, COOLK1D, FUNNY]);
    SPOOPY = new CombinedTrait("Spoopy",<String>["spoopy", "skellington's", "creppy"], 0.0,ItemTrait.OPINION, <ItemTrait>[SCARY, COOLK1D]);
    WOLVERINE = new CombinedTrait("Wolverine",<String>["wolverine"], 0.0,ItemTrait.SHAPE, <ItemTrait>[BONE, EDGED, POINTY]);
    RABBITSFOOT = new CombinedTrait("Rabbit's Foot",<String>["rabbit's foot"], 0.0,ItemTrait.SHAPE, <ItemTrait>[LUCKY, FUR]);
    ARROWHEAD = new CombinedTrait("Tipped",<String>["tipped", "reinforced", "arrowhead"], 0.0,ItemTrait.CONDITION, <ItemTrait>[POINTY, WOOD]);
    ARROW = new CombinedTrait("Arrow",<String>["arrow", "flechette", "bolt"], 0.0, ItemTrait.SHAPE,<ItemTrait>[POINTY, SHOOTY,WOOD]);
    KENDO = new CombinedTrait("Bokken",<String>["training sword", "bokken"], 0.0,ItemTrait.SHAPE, <ItemTrait>[WOOD, EDGED]);
    IRONICFAKECOOL = new CombinedTrait("Irony Type1",<String>["ironic"], 0.0,ItemTrait.OPINION, <ItemTrait>[FAKE, COOLK1D]);
    NET = new CombinedTrait("Netted",<String>["netted", "webbed"], 0.0,ItemTrait.SHAPE, <ItemTrait>[RESTRAINING, CLOTH]);
    BARBWIRE = new CombinedTrait("Barbed Wire",<String>["barbed wire"], 0.0, ItemTrait.SHAPE,<ItemTrait>[POINTY, RESTRAINING, METAL, CLOTH]);
    MORNINGSTAR = new CombinedTrait("Morning Star",<String>["morning star"], 0.0,ItemTrait.SHAPE, <ItemTrait>[POINTY, BLUNT]);
    DECADENT = new CombinedTrait("Decadent",<String>["decadent"], 0.0, ItemTrait.OPINION,<ItemTrait>[COMFORTABLE, VALUABLE]);
    SBAHJ = new CombinedTrait("SBAHJ",<String>["SBAHJ"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[SHITTY, COOLK1D]);
    BAYONET = new CombinedTrait("Bayonet",<String>["bayonet"], 0.0,ItemTrait.SHAPE, <ItemTrait>[POINTY, SHOOTY]);
    SNOOPSNOW = new CombinedTrait("Snoop",<String>["Snoop Dog's Snow Cone Machete"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[COLD, COOLK1D, EDGED]);
    LIGHTSABER = new CombinedTrait("Light Saber",<String>["light saber"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[GLOWING, ONFIRE, EDGED]);
    FAKEYFAKE = new CombinedTrait("Fakey Fake",<String>["fake as shit", "fakey fake", "bullshit"], 0.0, ItemTrait.OPINION,<ItemTrait>[MAGICAL, FAKE]);
    REALTHING = new CombinedTrait("Real As Shit",<String>["real as shit", "suprisingly real"], 0.0,ItemTrait.OPINION, <ItemTrait>[MAGICAL, REAL]);
    SKELETAL = new CombinedTrait("Skeletal",<String>["skeletal"], 0.0, ItemTrait.SHAPE,<ItemTrait>[SCARY, DOOMED, BONE]);
    GREENSUN = new CombinedTrait("Green Sun",<String>["green sun"], 0.0, ItemTrait.PATTERN,<ItemTrait>[ONFIRE, NUCLEAR, GLOWING]);
    MIDNIGHT = new CombinedTrait("Midnight",<String>["midnight", "3 In The Morning"], 0.0,ItemTrait.COLOR, <ItemTrait>[OBSCURING, CLASSY]);
    RADIENT = new CombinedTrait("Radiant",<String>["radiant", "dazzling"], 0.0,ItemTrait.OPINION, <ItemTrait>[MAGICAL, GLOWING]);
    EDGEY = new CombinedTrait("Edgy",<String>["edgy"], 0.0,ItemTrait.OPINION, <ItemTrait>[EDGED, OBSCURING,COOLK1D]);
    ABOMB = new CombinedTrait("Warhead",<String>["A-Bomb", "Warhead", "Chernobyl"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[NUCLEAR, EXPLODEY]);
    LIVING = new CombinedTrait("Living",<String>["living"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE, FLESH, SENTIENT]);
    DEAD = new CombinedTrait("Dead",<String>["dead","corpse","deceased"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE, FLESH]);
    TASER = new CombinedTrait("Taser",<String>["taser"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ZAP, RESTRAINING]);
    NOCTURNE = new CombinedTrait("Nocturn",<String>["nocturn"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[OBSCURING, MUSICAL]);
    DIRGE = new CombinedTrait("Dirge",<String>["dirge"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[DOOMED, MUSICAL]);
    SNOBBBISH = new CombinedTrait("Snobbish",<String>["snobbish"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLASSY, VALUABLE]);
    FLAT = new CombinedTrait("Flat(Music)",<String>["flat"], 0.0,ItemTrait.OPINION, <ItemTrait>[BLUNT, MUSICAL]);
    SHARPNOTE = new CombinedTrait("Sharp(Music)",<String>["sharp"], 0.0, ItemTrait.OPINION,<ItemTrait>[EDGED, MUSICAL]);
    SHARPCLOTHES = new CombinedTrait("Sharp(Clothes)",<String>["sharp"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLASSY, MUSICAL]);
    BACHS = new CombinedTrait("Bach's",<String>["Bach's"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[SMART, MUSICAL]);
    MOZARTS = new CombinedTrait("Mozart's",<String>["Mozart's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL, MUSICAL]);
    EINSTEINS = new CombinedTrait("Einstein's",<String>["Einstein's","Oppenheimer"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[SMART, NUCLEAR]);
    FEYNMANS = new CombinedTrait("Feynman's",<String>["Feynman's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SMART, FUNNY]);
    ZIPTIE = new CombinedTrait("Ziptie",<String>["Ziptie"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[PLASTIC, RESTRAINING]);
    SMARTPHONE = new CombinedTrait("Mobile",<String>["cellular","mobile","handheld","computerized"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[METAL, SMART]);
    SASSACRE = new CombinedTrait("Sassacre",<String>["Sassacre"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[HEAVY, FUNNY]);
    SLEDGE = new CombinedTrait("Sledge",<String>["Sledge"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BLUNT, HEAVY]);
    LEGAL = new CombinedTrait("Legal",<String>["Legal"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RESTRAINING, PAPER]);
    CLOWN = new CombinedTrait("Clown",<String>["Clown"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[FUNNY, LOUD]);
    PASSIONATE = new CombinedTrait("Passionate",<String>["passionate"], 0.0,ItemTrait.OPINION, <ItemTrait>[ONFIRE, ROMANTIC]);
    PINATA = new CombinedTrait("Pinata",<String>["pinata"], 0.0, ItemTrait.SHAPE,<ItemTrait>[PAPER, EDIBLE]);
    ANVIL = new CombinedTrait("Anvil",<String>["anvil"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BLUNT, HEAVY, METAL]);
    FLASHBANG = new CombinedTrait("Flashbang",<String>["flashbang"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[GLOWING, EXPLODEY]);
    SMOKEBOMB = new CombinedTrait("Smokebomb",<String>["smokebomb"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING, EXPLODEY]);
    NINJA = new CombinedTrait("Ninja",<String>["ninja"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING, EDGED]);
    TECHNO = new CombinedTrait("Techno",<String>["techno"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ZAP, MUSICAL]);
    ROCKNROLL = new CombinedTrait("Rock And/Or Roll",<String>["rock and roll"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[STONE, MUSICAL]);
    PISTOLSHRIMP = new CombinedTrait("Pistol Shrimp",<String>["pistol shrimp", "horrifying"], 0.0,ItemTrait.SHAPE, <ItemTrait>[SENTIENT, FLESH, SHOOTY]);
    JUGGALO = new CombinedTrait("Juggalo",<String>["juggalo"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FUNNY, MUSICAL, LOUD, SCARY]);
    SHOCKSAUCE = new CombinedTrait("Shock Sauce",<String>["shocksauce"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D, ZAP]);
    WEAKSAUCE = new CombinedTrait("Weak Sauce",<String>["weaksauce"], 0.0,ItemTrait.OPINION, <ItemTrait>[BLUNT,COOLK1D, SHITTY]);
    SPICY = new CombinedTrait("Spicy",<String>["spicy", "picante"], 0.0,ItemTrait.OPINION, <ItemTrait>[ONFIRE, EDIBLE]);
    ICECREAM = new CombinedTrait("Popsicle",<String>["ice cream", "popsicle"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[COLD, EDIBLE]);
    POPSICKLE = new CombinedTrait("Popsickle",<String>["popsickle"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[COLD, EDIBLE,EDGED]);
    ICEPICK = new CombinedTrait("Icepick",<String>["icepick"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[COLD, POINTY]);

    SCHEZWAN = new CombinedTrait("Schezwan",<String>["schezwan"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D, EDIBLE]);
    VAPORWAVE = new CombinedTrait("Vaporwave",<String>["vaporwave"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING, MUSICAL, COOLK1D, ZAP]);
    MALLET = new CombinedTrait("Mallet",<String>["mallet"], 0.0,ItemTrait.SHAPE, <ItemTrait>[WOOD, BLUNT]);
    FIDGET = new CombinedTrait("Fidget",<String>["fidget"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLASTIC, COOLK1D]);
    GOLDFOIL = new CombinedTrait("Gold Foil",<String>["gold foil"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL, PAPER, VALUABLE]);
    CAVIAR = new CombinedTrait("Caviar",<String>["caviar"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[EDIBLE, VALUABLE]);
    RADNUCLEAR = new CombinedTrait("RADioactive",<String>["RADioactive"], 0.0,ItemTrait.OPINION, <ItemTrait>[NUCLEAR, COOLK1D]);
    GLAM = new CombinedTrait("Glam",<String>["glam"], 0.0,ItemTrait.OPINION, <ItemTrait>[STONE, MUSICAL, PRETTY]);
    HAIRMETAL = new CombinedTrait("Hair Metal",<String>["hair metal"], 0.0,ItemTrait.OPINION, <ItemTrait>[METAL, MUSICAL, PRETTY]);
    ELVEN = new CombinedTrait("Elven",<String>["elven", "fae", "sylvan"], 0.0,ItemTrait.OPINION, <ItemTrait>[MAGICAL, PRETTY]);
    SHINY = new CombinedTrait("Shiny",<String>["shiny"], 0.0,ItemTrait.OPINION, <ItemTrait>[METAL, PRETTY]);
    BESPOKE = new CombinedTrait("Bespoke",<String>["bespoke", "well-tailored", "glamorous","haute couture"], 0.0,ItemTrait.OPINION, <ItemTrait>[VALUABLE, PRETTY, CLASSY]);
    OPERATIC = new CombinedTrait("Operatic",<String>["operatic"], 0.0,ItemTrait.OPINION, <ItemTrait>[VALUABLE, MUSICAL, CLASSY]);
    ICE = new CombinedTrait("Diamond",<String>["ice", "diamond"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[VALUABLE, COLD]);
    ICYHOT = new CombinedTrait("Icy Hot",<String>["icy hot","cold fire", "wet", "damp","moist","watery"], 0.0,ItemTrait.OPINION, <ItemTrait>[ONFIRE, COLD]);

    ICECOLD = new CombinedTrait("Cold As Fuck",<String>["ice cold", "cold as fuck"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D, COLD]);
    WINTER = new CombinedTrait("Winter's",<String>["winter's", "season's"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[CALMING, COLD]);
    CHRISTMAS = new CombinedTrait("Christmas",<String>["santa's", "christmas", "xmas"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL, COLD]);
    SANTASAWS = new CombinedTrait("Santa Saws",<String>["Santa Saws"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL, COLD,EDGED]);
    SANTASAWS2 = new CombinedTrait("Santa Sleighs",<String>["Santa Sleighs"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SANTA, EDGED]);
    SANTACLAWS = new CombinedTrait("Santa Claws",<String>["Santa Claws"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SANTA, CLAWS]);
    SANDYCLAWS = new CombinedTrait("Sandy Claws",<String>["Sandy Claws"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SANTA, CLAWS,STONE]);
    SILENTNIGHT = new CombinedTrait("Silent Night",<String>["Silent Night"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SANTA, OBSCURING]);
    HALLOWEEN = new CombinedTrait("Ghost's",<String>["ghost's", "Bloody Mary", "Halloween"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SCARY, GHOSTLY]);
    MUTANT = new CombinedTrait("Mutant",<String>["ghoul", "mutant"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[FLESH, NUCLEAR, UGLY]);
    SKATEBOARD = new CombinedTrait("Skateboard",<String>["skate", "skateboard"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[COOLK1D, METAL]);
    MICROWAVE = new CombinedTrait("Microwave",<String>["microwave"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[NUCLEAR, ZAP, EDIBLE]);
    ORBITAL = new CombinedTrait("Orbital",<String>["orbital"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[NUCLEAR, ZAP, EDIBLE,SHOOTY]);
    DUMBSMART = new CombinedTrait("",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BLUNT, SMART]);
    URANIUM = new CombinedTrait("Uranium",<String>["uranium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[NUCLEAR, STONE]);
    MOUSEPAD = new CombinedTrait("Mousepad",<String>["mousepad", "jar opener"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER, RUBBER]);
    FLINT1 = new CombinedTrait("Sharpened Flint",<String>["flint"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EDGED, STONE]);
    FLINT2 = new CombinedTrait("Pointed Flint",<String>["flint"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[POINTY, STONE]);
    PICNIC = new CombinedTrait("Picnic",<String>["picnic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLASTIC, POINTY]);
    XTREME = new CombinedTrait("Xtreme Xplosion",<String>["xtreme xplosion"], 0.0, ItemTrait.OPINION,<ItemTrait>[COOLK1D, EXPLODEY]);
    LAWN = new CombinedTrait("Lawn",<String>["lawn"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[PLASTIC, COMFORTABLE]);
    UPHOLSTERED = new CombinedTrait("Upholstered",<String>["upholstered"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[CLOTH, COMFORTABLE]);
    LEATHER = new CombinedTrait("Leather",<String>["leather"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FLESH, COMFORTABLE]);
    SHAG = new CombinedTrait("Shag",<String>["shag"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[FUR, COMFORTABLE]);
    LOYAL = new CombinedTrait("Loyal",<String>["loyal"], 0.0, ItemTrait.OPINION,<ItemTrait>[BLUNT, ROMANTIC]);
    PORCELAIN = new CombinedTrait("Porcelain",<String>["porcelain"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PRETTY, CERAMIC]);
    PORKHOLLOW = new CombinedTrait("Pork Hollow",<String>["pork hollow", "piggy bank"], 0.0, ItemTrait.SHAPE,<ItemTrait>[VALUABLE, CERAMIC]);
    KATANA = new CombinedTrait("Katana",<String>["n1nj4","katana"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[COOLK1D, EDGED]);
    CHOCOLATES = new CombinedTrait("Chocolate",<String>["chocolate"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[ROMANTIC, EDIBLE]);
    FOILCHOCOLATES = new CombinedTrait("Wrapped Chocolate",<String>["wrapped chocolate"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[ROMANTIC, EDIBLE,PAPER,METAL]);
    SCRATCHNSNIFF = new CombinedTrait("Scratch-n-sniff",<String>["scratch-n-sniff"], 0.0, ItemTrait.MATERIAL, <ItemTrait>[COOLK1D, PAPER]);
    MYTHRIL = new CombinedTrait("Mythril",<String>["mythril","orichalcum"],0.0, ItemTrait.MATERIAL, <ItemTrait>[MAGICAL, METAL]);
    TITANIUM = new CombinedTrait("Titanium",<String>["titanium","steel"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[BLUNT, METAL]);
    LEAD = new CombinedTrait("Lead",<String>["lead"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[HEAVY, METAL]);
    ONION = new CombinedTrait("Satire",<String>["satire","parody","onion"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FAKE, FUNNY]);
    COMEDYGOLD = new CombinedTrait("Comedy Gold",<String>["comedy gold"], 0.0, ItemTrait.OPINION, <ItemTrait>[VALUABLE, FUNNY]);
    DRY = new CombinedTrait("Dry",<String>["dry", "sensible chuckle"], 0.0, ItemTrait.OPINION,<ItemTrait>[CLASSY, FUNNY]);
    POLITE = new CombinedTrait("Polite",<String>["polite"], 0.0,ItemTrait.OPINION, <ItemTrait>[COMFORTABLE, FAKE]);
    STRADIVARIUS = new CombinedTrait("Stradivarius",<String>["stradivarius"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[CLASSY, VALUABLE, WOOD, MUSICAL]);
    SCIENTISTIC = new CombinedTrait("Scientistic",<String>["scientistic"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,FAKE]); //<3 you fallout
    AI = new CombinedTrait("AI",<String>["AI"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ZAP, SENTIENT]);
    ROBOTIC2 = new CombinedTrait("Robotic",<String>["robotic"], 0.0, ItemTrait.CONDITION,<ItemTrait>[METAL, ZAP, SENTIENT]);
    SHRAPNEL = new CombinedTrait("Shrapnel",<String>["shrapnel"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD, EXPLODEY]);
    VOCALOID = new CombinedTrait("Vocaloid",<String>["vocaloid"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SENTIENT,ZAP, MUSICAL]);
    HYUNAE = new CombinedTrait("*Hyun-ae",<String>["*Hyun-ae"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[SENTIENT,ZAP, ROMANTIC]); //is it a reference?
    BUCKSHOT = new CombinedTrait("Buckshot",<String>["buckshot"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD, SHOOTY]);
    CANON = new CombinedTrait("Cannon",<String>["cannon"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEAVY, SHOOTY]);//bitches love canons
    STATIONARY = new CombinedTrait("Stationary",<String>["stationary"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CLASSY, PAPER]);
    PAPERBOOK = new CombinedTrait("",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BOOK, PAPER]); //we can fucking assume this dunkass
    METALGUN = new CombinedTrait("",<String>[], 0.0, ItemTrait.PURPOSE,<ItemTrait>[METAL, SHOOTY]); //we can fucking assume this dunkass
    PAPERCUT = new CombinedTrait("Papercut",<String>["papercut"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDGED, PAPER]);
    SQUEAKY = new CombinedTrait("Squeaky",<String>["squeaky"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BLUNT, RUBBER]);
    KAZOO = new CombinedTrait("Kazoo",<String>["kazoo"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FAKE, MUSICAL]);
    BANDAID = new CombinedTrait("Bandaid",<String>["bandaid"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[HEALING, PAPER]);
    GUSHERS = new CombinedTrait("Gushers",<String>["gushers"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[HEALING, EDIBLE]);
    MEDIC = new CombinedTrait("Medic",<String>["medic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING, SHOOTY]);
    SICKNASTY = new CombinedTrait("Sick Nasty",<String>["sick nasty","ill"], 0.0,ItemTrait.CONDITION, <ItemTrait>[COOLK1D, POISON]);
    GILDED = new CombinedTrait("Gilded",<String>["gilded","gold leaf"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL, WOOD]);
    CHARGING = new CombinedTrait("Charging",<String>["charging","power cord"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLASTIC, ZAP]);
    SAFETY1 = new CombinedTrait("Rubber Safety",<String>["safety"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RUBBER, EDGED]);
    SAFETY2 = new CombinedTrait("Plastic Safety",<String>["safety"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLASTIC, EDGED]);
    THUNDER = new CombinedTrait("Thunderous",<String>["thunderous","thor's"], 0.0,ItemTrait.OPINION, <ItemTrait>[LOUD, ZAP]);
    SCREECHING = new CombinedTrait("Screeching",<String>["screeching","dial up"], 0.0,ItemTrait.OPINION, <ItemTrait>[LOUD, ZAP,SMART]);
    MIRROR = new CombinedTrait("Mirrored",<String>["mirrored","reflective"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[GLASS, METAL]);
    CRYSTALBALL = new CombinedTrait("Far Seeing",<String>["far seeing","sighted"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[GLASS, STONE, MAGICAL]);
    DISABLING = new CombinedTrait("Nonlethal",<String>["disabling","non lethal"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RUBBER, SHOOTY]);
    FASHIONABLE = new CombinedTrait("Fashionable",<String>["fasionable"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PRETTY, CLASSY]);
    IRONICFUNNYCOOL = new CombinedTrait("Ironic Type 2",<String>["ironic"], 0.0,ItemTrait.OPINION, <ItemTrait>[FUNNY, COOLK1D]);
    IRONICSHITTYFUNNY = new CombinedTrait("Ironic Type 3",<String>["ironic"], 0.0,ItemTrait.OPINION, <ItemTrait>[SHITTY, FUNNY]);
    POSTIRONIC = new CombinedTrait("Post Ironic",<String>["post-ironic"], 0.0,ItemTrait.OPINION, <ItemTrait>[FAKE, COOLK1D,CLASSY]);
    MONSTOROUS = new CombinedTrait("Monstrous",<String>["monstrous"], 0.0,ItemTrait.OPINION, <ItemTrait>[UGLY,LOUD, SCARY]);
    ROOTY = new CombinedTrait("Rooty Tooty Point and Shooty",<String>["rooty tooty point and shooty"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SHOOTY, COOLK1D,CLASSY]);
    GOLDEN = new CombinedTrait("Golden",<String>["golden"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,VALUABLE]);
    PLATINUM = new CombinedTrait("Platinum",<String>["platinum"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLOWING,METAL]);
    HORSESHOE = new CombinedTrait("Horseshoe",<String>["horseshoe"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LUCKY,METAL]);
    FELT = new CombinedTrait("Felt",<String>["felt"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CLOTH,FUR]);
    MARBLE = new CombinedTrait("Marble",<String>["marble"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,CLASSY]);
    GRANITE = new CombinedTrait("Marble",<String>["marble"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,HEAVY]);
    GLITCHED = new CombinedTrait("Glitched",<String>["glitched"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CORRUPT,ZAP]);
    DEBUGGING = new CombinedTrait("Debugging",<String>["debugging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,ZAP]);

    METALIC = new CombinedTrait("Metalic",<String>["Iron Maiden","Metalic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[METAL,LOUD, MUSICAL]);
    SIMULCRUM = new CombinedTrait("Simulacrum",<String>["Simulacrum"], 0.0,ItemTrait.OPINION, <ItemTrait>[SENTIENT,FAKE]);
    IMITATION = new CombinedTrait("Imitation",<String>["Imitation"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDIBLE,FAKE]);
    PLACEBO = new CombinedTrait("Placebo",<String>["Placebo"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,FAKE]);
    COUNTERFIT = new CombinedTrait("Counterfeit",<String>["counterfeit"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[VALUABLE,FAKE]);
    SURREAL = new CombinedTrait("Surreal1",<String>["Surreal"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D,UNCOMFORTABLE,FUNNY]);
    BRAINY = new CombinedTrait("Brainy",<String>["Brainy"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,FLESH]);
    INCENDIARY = new CombinedTrait("Incendiary",<String>["Incendiary"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ONFIRE,EXPLODEY]);
    C4 = new CombinedTrait("C-4",<String>["C-4"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EXPLODEY,PLASTIC]);
    FAE = new CombinedTrait("Fae",<String>["fae"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MAGICAL,GLOWING, CORRUPT]);
    PLUTONIUM = new CombinedTrait("Plutonium",<String>["Plutonium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,NUCLEAR]);
    LITHIUM = new CombinedTrait("Lithium",<String>["Lithium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,ZAP]);
    MOLTEN = new CombinedTrait("Molten",<String>["Molten"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,ONFIRE]);
    MAGMA = new CombinedTrait("Magma",<String>["Magma","Lava","Sulphuric"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,ONFIRE]);
    RUSTY = new CombinedTrait("Rusty",<String>["Rusty"], 0.0,ItemTrait.CONDITION, <ItemTrait>[METAL,SHITTY]);
    FONZIE = new CombinedTrait("Fonzie",<String>["Fonzie"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDGED,COOLK1D, CLASSY]);
    ROMCOM = new CombinedTrait("Romcom",<String>["Romcom"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,FUNNY]);
    ALLURING = new CombinedTrait("Alluring",<String>["Alluring"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PRETTY,GLOWING]);
    MASQUERADE = new CombinedTrait("Masquerade",<String>["Masquerade"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PRETTY,OBSCURING]);
    STONESKIN = new CombinedTrait("Stoneskin",<String>["Stoneskin","Petrified"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[STONE,FLESH]);
    PSIONIC = new CombinedTrait("Psionic",<String>["Psionic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MAGICAL,SMART]);
    DWARVEN = new CombinedTrait("Dwarven",<String>["Dwarven"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MAGICAL,STONE]);
    ELEMENTAL = new CombinedTrait("Elemental",<String>["Elemental"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[MAGICAL,SENTIENT]);
    GOURMET = new CombinedTrait("Gourmet",<String>["Gourmet"], 0.0,ItemTrait.OPINION, <ItemTrait>[EDIBLE,CLASSY]);
    STAINEDGLASS = new CombinedTrait("Stained Glass",<String>["Stained Glass"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLASS,PRETTY, VALUABLE]);
    GAUZE = new CombinedTrait("Gauze",<String>["Gauze"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,CLOTH]);
    LOCKED = new CombinedTrait("Locked",<String>["Locked"], 0.0,ItemTrait.CONDITION, <ItemTrait>[RESTRAINING,ENRAGING]);
    ETCHED = new CombinedTrait("Etched",<String>["Etched"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[STONE,PAPER]);
    PAPYRUS = new CombinedTrait("Papyrus",<String>["Papyrus"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PAPER,PLANT]);
    FILM = new CombinedTrait("Film",<String>["film"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER,PLASTIC]);
    SAUCEY = new CombinedTrait("Saucey",<String>["Saucey"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CORRUPT,ENRAGING,UGLY]);
    LOTTERY = new CombinedTrait("Lottery",<String>["Lottery"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER,LUCKY]);
    BLINDFOLDED = new CombinedTrait("Blindfolded",<String>["Blindfolded"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING,CLOTH]);
    POSSESED = new CombinedTrait("Possessed",<String>["Possessed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[GHOSTLY,FLESH]);
    INFERNAL = new CombinedTrait("Infernal",<String>["debugging"], 0.0,ItemTrait.OPINION, <ItemTrait>[GHOSTLY,ONFIRE]);
    GEPETTO = new CombinedTrait("Geppetto",<String>["Geppetto's","Pinocchio"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD,REAL,PUPPET,SENTIENT]);
    ABOMINABLE = new CombinedTrait("Abominable",<String>["Abominable"], 0.0,ItemTrait.OPINION, <ItemTrait>[FLESH,CORRUPT]);
    ASHEN = new CombinedTrait("Ashen",<String>["Ashen"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,DOOMED]);
    PALE = new CombinedTrait("Pale",<String>["Pale"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,CALMING]);
    PITCH = new CombinedTrait("Pitch",<String>["debugging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,ENRAGING]);
    LIT = new CombinedTrait("Lit",<String>["debugging"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D,ONFIRE]);
    HYPNOTIZING = new CombinedTrait("Hypnotizing",<String>["Hypnotizing"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MAGICAL,CALMING]);
    TRANQUILIZING = new CombinedTrait("Tranquilizing",<String>["Tranquilizing"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CALMING,RESTRAINING]);
    CALMRAGE = new CombinedTrait("",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CALMING,ENRAGING]);
    GHOSTRIDER = new CombinedTrait("Ghost Rider",<String>["Ghost Rider's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[CHAIN,ONFIRE,GHOSTLY]);
    LOGICAL = new CombinedTrait("Logical",<String>["Logical"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,COLD]);
    DUELIST = new CombinedTrait("Duelist's",<String>["Duelist's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SHOOTY,CLASSY]);
    SILENCED = new CombinedTrait("Silenced",<String>["Silenced"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SHOOTY,OBSCURING]);
    DEAUDLY = new CombinedTrait("Deudly",<String>["Deudly"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SHOOTY,SHITTY]);
    SCREAMING = new CombinedTrait("Screaming",<String>["Screaming"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LOUD,SCARY]);
    CACOPHONY = new CombinedTrait("Cacophonous",<String>["Cacophonous"], 0.0,ItemTrait.OPINION, <ItemTrait>[UGLY,MUSICAL]);
    SUBLIME = new CombinedTrait("Sublime",<String>["Sublime"], 0.0,ItemTrait.OPINION, <ItemTrait>[UGLY,PRETTY]);
    MASTERWORK = new CombinedTrait("Masterwork",<String>["Masterwork"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[REAL,VALUABLE]);//YOU CAN'T GO WRONG
    BROODFESTER = new CombinedTrait("BroodFester",<String>["BroodFester"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SENTIENT,SCARY, CORRUPT,MAGICAL]);
    REDACTED = new CombinedTrait("[REDACTED]",<String>["[REDACTED]"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CORRUPT,OBSCURING]);
    POPROCKS = new CombinedTrait("Pop Rocks",<String>["Pop Rocks"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDIBLE,EXPLODEY]);
    DISGUISED = new CombinedTrait("Disguised",<String>["Disguised"], 0.0,ItemTrait.CONDITION, <ItemTrait>[OBSCURING,FAKE]);
    HAUNTED = new CombinedTrait("Haunted",<String>["Haunted"], 0.0,ItemTrait.CONDITION, <ItemTrait>[UNCOMFORTABLE,GHOSTLY]);
    COGNITOHAZARD = new CombinedTrait("Cognitohazardous",<String>["Cognitohazardous"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CORRUPT,SMART]);
    STATICY = new CombinedTrait("Staticy",<String>["Staticy"], 0.0,ItemTrait.CONDITION, <ItemTrait>[UNCOMFORTABLE,ZAP]);
    JADITE = new CombinedTrait("Jadite",<String>["Jadite"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[GLASS,NUCLEAR]);
    TICKLING = new CombinedTrait("Tickling",<String>["Tickling"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FUNNY,UNCOMFORTABLE]);
    COMPOSITE = new CombinedTrait("Composite",<String>["Composite"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[METAL,CERAMIC]);
    HIGHPOWERED = new CombinedTrait("High-Powered",<String>["High-Powered"], 0.0,ItemTrait.CONDITION, <ItemTrait>[EXPLODEY,SHOOTY]);
    CONCUSSIVE = new CombinedTrait("Concussive",<String>["Concussive"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EXPLODEY,BLUNT]);
    DOWN = new CombinedTrait("Down",<String>["Down"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[COMFORTABLE,FEATHER]);
    PRICKLY = new CombinedTrait("Prickly",<String>["Prickly"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[UNCOMFORTABLE,POINTY]);
    DEEPWEB = new CombinedTrait("Deep-Web",<String>["Deep-Web","Dark-Net"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[UNCOMFORTABLE,OBSCURING,ZAP]);
    JAGGED = new CombinedTrait("Jagged",<String>["Jagged","Sawtooth"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[POINTY,EDGED]);
    NANOFIBER = new CombinedTrait("Nanofiber",<String>["Nanofiber"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,SMART]);
    CLANGING = new CombinedTrait("Clanging",<String>["Clanging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[METAL,LOUD]);
    SILVER = new CombinedTrait("Silver",<String>["Silver"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,CLASSY]);
    WITHERED = new CombinedTrait("Withered",<String>["Withered"], 0.0,ItemTrait.CONDITION, <ItemTrait>[DOOMED,PLANT]);
    SHATTERED = new CombinedTrait("Shattered",<String>["Shattered"], 0.0,ItemTrait.CONDITION, <ItemTrait>[GLASS,SHITTY]);
    MINERS = new CombinedTrait("Miner's",<String>["Miner's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[STONE,METAL]);
    SIGNING = new CombinedTrait("Singing",<String>["Singing"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,SENTIENT]);
    MITOCHONDRIAL = new CombinedTrait("Mitochondrial",<String>["Mitochondrial"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FLESH,ZAP]);
    BLACKOUT = new CombinedTrait("Blackout",<String>["Blackout","EMP"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING,ZAP]);
    ABSESTOS = new CombinedTrait("Asbestos",<String>["Asbestos"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,POISON]);
    MECURIAL = new CombinedTrait("Mercurial",<String>["Mercurial"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[POISON,METAL]);
    BULLETPROOF = new CombinedTrait("Bulletproof",<String>["Bulletproof"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,BLUNT]);
    COTTON = new CombinedTrait("Cotton",<String>["Cotton"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,CLOTH]);
    BLINDING = new CombinedTrait("Blinding",<String>["Blinding","Flashbang","Solar Flare"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ENRAGING,GLOWING]);
    BRILLIANT = new CombinedTrait("Brilliant",<String>["Brilliant"], 0.0,ItemTrait.OPINION, <ItemTrait>[GLOWING,SMART]);
    OFFENSIVE = new CombinedTrait("Offensive",<String>["Offensive"], 0.0,ItemTrait.OPINION, <ItemTrait>[ENRAGING,SMART]);
    POACHED = new CombinedTrait("Poached",<String>["Poached"], 0.0,ItemTrait.CONDITION, <ItemTrait>[FLESH,VALUABLE]);
    TAPESTRY = new CombinedTrait("Tapestry",<String>["Tapestry"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,PRETTY]);
    ITCHY = new CombinedTrait("Itchy",<String>["Itchy"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLOTH,UNCOMFORTABLE]);
    WISHBONE = new CombinedTrait("Wishbone",<String>["Wishbone"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[LUCKY,BONE]);
    RATTLING = new CombinedTrait("Rattling",<String>["Rattling"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LOUD,BONE]);
    CRANIAL = new CombinedTrait("Cranial",<String>["Cranial"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[SMART,BONE]);
    HUMERUS = new CombinedTrait("Humerus",<String>["Humerus"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FUNNY,BONE]);
    MASSAGE = new CombinedTrait("Massage",<String>["Massage"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,COMFORTABLE]);
    PESTERSOME = new CombinedTrait("Pestersome",<String>["Pestersome","Irksome"], 0.0,ItemTrait.OPINION, <ItemTrait>[LOUD,ENRAGING]);
    SHOCKWAVE = new CombinedTrait("Shockwave",<String>["Shockwave"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LOUD,EXPLODEY]);
    ANTIVENOM = new CombinedTrait("Antivenom",<String>["Antivenom"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[POISON,HEALING]);
    WILLWISP = new CombinedTrait("Will O Wisp",<String>["Will O Wisp","Demonic"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[ONFIRE,MAGICAL]);
    FIBERGLASS = new CombinedTrait("Fiberglass",<String>["Fiberglass"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,GLASS]);
    SKULL = new CombinedTrait("Skull",<String>["Skull"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[BONE,SCARY]);
    ENCHANTED = new CombinedTrait("Enchanted",<String>["Enchanted"], 0.0,ItemTrait.CONDITION, <ItemTrait>[MAGICAL,LUCKY]);
    BESERKER = new CombinedTrait("Berserker's",<String>["Berserker's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL,ENRAGING]);
    CLERICAL = new CombinedTrait("Clerical",<String>["Clerical"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL,HEALING]);
    CAUTERIZING = new CombinedTrait("Cauterizing",<String>["Cauterizing"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,ONFIRE]);
    XRAY = new CombinedTrait("X-Ray",<String>["X-Ray"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[NUCLEAR,GLOWING]);
    CLEVER = new CombinedTrait("Clever",<String>["Clever"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,LUCKY]);
    FIREPLACE = new CombinedTrait("Fireplace",<String>["Fireplace"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[COMFORTABLE,ONFIRE]);
    CRACKLING = new CombinedTrait("Crackling",<String>["Crackling"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LOUD,ONFIRE]);
    THUMPING = new CombinedTrait("Thumping",<String>["Thumping"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LOUD,HEAVY]);
    SHRIEKING = new CombinedTrait("Shrieking",<String>["Shrieking","Banshee"], 0.0,ItemTrait.CONDITION, <ItemTrait>[GHOSTLY,LOUD]);
    SURREALCORRUPTFUNNY = new CombinedTrait("Surreal2",<String>["Surreal"], 0.0,ItemTrait.OPINION, <ItemTrait>[FUNNY,CORRUPT]);
    ALOE = new CombinedTrait("Aloe",<String>["Aloe","Willowbark"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,PLANT]);
    ROSE = new CombinedTrait("Rose",<String>["Rose"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,PLANT]);
    KNOCKKNOCK = new CombinedTrait("Knock Knock",<String>["Knock Knock"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FUNNY,BLUNT]);
    LIFESTEAL = new CombinedTrait("Lifesteal",<String>["Lifesteal"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MAGICAL,POISON]);
    TRAGIC = new CombinedTrait("Tragic",<String>["Tragic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PRETTY,DOOMED]);
    SLAPSTICK = new CombinedTrait("Slapstick",<String>["Slapstick"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDGED,FUNNY]);
    GROSSOUT = new CombinedTrait("Gross Out",<String>["Gross Out"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[UGLY,FUNNY]);
    FLOWERY = new CombinedTrait("Flowery",<String>["Flowery"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PRETTY,PLANT]);
    POISONIVY = new CombinedTrait("Poison Ivy",<String>["Poison Ivy"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[POISON,PLANT]);
    WINGED = new CombinedTrait("Winged",<String>["Winged","Pegasus","Angelic"], 0.0,ItemTrait.CONDITION, <ItemTrait>[MAGICAL,FEATHER]);
    FORBIDDENFRUIT = new CombinedTrait("Forbidden Fruit",<String>["Forbidden Fruit"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLANT,EDIBLE, DOOMED]);
    LAWFUL = new CombinedTrait("Lawful",<String>["Lawful"], 0.0,ItemTrait.OPINION, <ItemTrait>[RESTRAINING,SENTIENT]);
    CHAOTIC = new CombinedTrait("Chaotic",<String>["Chaotic"], 0.0,ItemTrait.OPINION, <ItemTrait>[ENRAGING,SENTIENT]);
    HYPOTHERMIC = new CombinedTrait("Hypothermic",<String>["Hypothermic"], 0.0,ItemTrait.CONDITION, <ItemTrait>[DOOMED,COLD]);
    HYPERTHERMIC = new CombinedTrait("Hyperthermic",<String>["Hyperthermic"], 0.0,ItemTrait.CONDITION, <ItemTrait>[DOOMED,ONFIRE]);
    SHACKLED = new CombinedTrait("Shackled",<String>["Shackled"], 0.0,ItemTrait.CONDITION, <ItemTrait>[RESTRAINING,HEAVY]);
    POETIC = new CombinedTrait("Poetic",<String>["Poetic"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,ROMANTIC]);
    HOLOGRAHPIC = new CombinedTrait("Holographic",<String>["Holographic"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLOWING,SMART,GLASS,ZAP]);
    CASKET = new CombinedTrait("Casket",<String>["Casket","Coffin"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,DOOMED]);
    SPECTRAL = new CombinedTrait("Spectral",<String>["Spectral"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GHOSTLY,MAGICAL]);
    PHOENIX = new CombinedTrait("Phoenix",<String>["Phoenix"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[ONFIRE,FEATHER]);
    TATTERED = new CombinedTrait("Tattered",<String>["Tattered"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CLOTH,DOOMED]);
    WOODWIND = new CombinedTrait("Woodwind",<String>["Woodwind","Reed"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,WOOD]);
    BONEHURTING = new CombinedTrait("Bone Hurting",<String>["Bone Hurting"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[UNCOMFORTABLE,BONE]);
    BONEHEALING = new CombinedTrait("Bone Healing:",<String>["Bone Healing:"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,BONE]);
    CALCIUM = new CombinedTrait("Calcium",<String>["Calcium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[BONE,HEALING,EDIBLE]);
    FLEECE = new CombinedTrait("Fleece",<String>["Fleece"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,ONFIRE]);
    POTTED = new CombinedTrait("Potted",<String>["Potted"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CERAMIC,PLANT]);
    CANNED = new CombinedTrait("Canned",<String>["Canned","Tinned","Potassium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,EDIBLE]);
    DIEASED = new CombinedTrait("Diseased",<String>["Diseased"], 0.0,ItemTrait.CONDITION, <ItemTrait>[DOOMED,FLESH]);
    PORCUPINE = new CombinedTrait("Porcupine",<String>["Porcupine"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[POINTY,FUR]);
    FANGED = new CombinedTrait("Fanged",<String>["Fanged"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE,POINTY]);
    BASALT = new CombinedTrait("Basalt",<String>["Basalt"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,OBSCURING]);
    OBSIDIAN = new CombinedTrait("Obsidian",<String>["Obsidian"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLASS,OBSCURING]);
    FENESTRATED = new CombinedTrait("Fenestrated",<String>["Fenestrated"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLASS,WOOD]);
    PLEXIGLASS = new CombinedTrait("Plexiglass",<String>["Plexiglass"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLASS,PLASTIC]);
    CERAMICWRAP = new CombinedTrait("Ceramic Wrap",<String>["Ceramic Wrap"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CERAMIC,PAPER]);
    FUNGAL = new CombinedTrait("Fungal",<String>["Fungal"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,UGLY]);
    THORNY = new CombinedTrait("Thorny",<String>["Thorny"], 0.0,ItemTrait.CONDITION, <ItemTrait>[PLANT,POINTY]);
    BULBED = new CombinedTrait("Bulbed",<String>["Bulbed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[PLANT,BLUNT]);
    GLASSCANNON = new CombinedTrait("Glass Cannon",<String>["Glass Cannon"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[GLASS,SHOOTY]);
    PLANTRUBBER = new CombinedTrait("Caoutchouc",<String>["Caoutchouc"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLANT,RUBBER]);
    CELLULOSE = new CombinedTrait("Cellulose",<String>["Cellulose"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,PLASTIC]);
    HORRORCORE = new CombinedTrait("Horrorcore",<String>["Horrorcore"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,SCARY]);
    NIGHTCORE = new CombinedTrait("Nightcore",<String>["Nightcore"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CORRUPT,MUSICAL]);
    CRAZYBUSS = new CombinedTrait("Crazy Bus",<String>["Crazy Bus"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CORRUPT,ZAP,MUSICAL]);
    BURDOCK = new CombinedTrait("Burdock",<String>["Burdock"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,FUR]);
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
    BONE = new ItemAppearanceTrait(<String>["bone"], 0.2,ItemTrait.MATERIAL);
    WOOD = new ItemAppearanceTrait(<String>["wood"], -0.3,ItemTrait.MATERIAL);
    PLASTIC = new ItemAppearanceTrait(<String>["plastic"], -0.3,ItemTrait.MATERIAL);
    RUBBER = new ItemAppearanceTrait(<String>["rubber"], -0.3,ItemTrait.MATERIAL);
    PAPER = new ItemAppearanceTrait(<String>["paper"], -0.3,ItemTrait.MATERIAL);
    CLOTH = new ItemAppearanceTrait(<String>["cloth", "fabric"], -0.3,ItemTrait.MATERIAL);
    GLASS = new ItemAppearanceTrait(<String>["glass"], -0.3,ItemTrait.MATERIAL);
    GHOSTLY = new ItemAppearanceTrait(<String>["ghostly","ectoplasm"], -0.3,ItemTrait.MATERIAL);
    FLESH = new ItemAppearanceTrait(<String>["flesh", "meat","muscle"], -0.1,ItemTrait.MATERIAL);
    CORRUPT = new ItemAppearanceTrait(<String>["horrorterror", "tentacled","grimdark"], 3.1,ItemTrait.CONDITION);

    FUR = new ItemAppearanceTrait(<String>["fur", "fluff","fuzzy"], -0.1,ItemTrait.MATERIAL);
    PLANT = new ItemAppearanceTrait(<String>["plant", "leaf","vine"], -0.1,ItemTrait.MATERIAL);

    FEATHER = new ItemAppearanceTrait(<String>["feathery"], -0.1,ItemTrait.MATERIAL);

    UGLY = new ItemAppearanceTrait(<String>["gross", "ugly","unpleasant"], 0.1,ItemTrait.OPINION);
    SHITTY = new ItemAppearanceTrait(<String>["shitty", "poorly made","conksuck", "piece-of-shit"], -13.0,ItemTrait.OPINION);
    STONE = new ItemAppearanceTrait(<String>["stone", "rock", "concrete"], 0.3,ItemTrait.MATERIAL);
    LEGENDARY = new ItemAppearanceTrait(<String>["legendary"], 13.0,ItemTrait.FIRST);
  }

  static void initFunctions() {
    EDGED = new ItemFunctionTrait(["edged", "sharp", "honed", "keen", "bladed"], 0.3,ItemTrait.OPINION);
    GLOWING = new ItemFunctionTrait(["glowing", "bright", "illuminated"], 0.1,ItemTrait.PATTERN);
    OBSCURING = new ItemFunctionTrait(["obscuring", "dark", "shadowy"], 0.1,ItemTrait.PATTERN);
    CALMING = new ItemFunctionTrait(["calming", "pale", "placating","shooshing"], 0.1,ItemTrait.OPINION);
    NUCLEAR = new ItemFunctionTrait(["nuclear", "radioactive", "irradiated"], 1.0,ItemTrait.CONDITION);
    SCARY = new ItemFunctionTrait(["scary", "horrifying", "terrifying","spooky"], 0.2,ItemTrait.OPINION);
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
    SENTIENT = new ItemFunctionTrait(["sentient", "aware", "conscious", "awake","talking"], 0.1,ItemTrait.CONDITION);
    ROMANTIC = new ItemFunctionTrait(["romantic","amorous","tender","affectionate","lovey-dovey"], 0.1,ItemTrait.OPINION);
    FUNNY = new ItemFunctionTrait(["funny", "hilarious", "comedy"], 0.1,ItemTrait.OPINION);
    ENRAGING = new ItemFunctionTrait(["annoying", "enraging", "dickish", "asshole"], 0.1,ItemTrait.OPINION);
    MAGICAL = new ItemFunctionTrait(["magical", "mystical", "magickal", "wizardy"], 0.6,ItemTrait.OPINION);
    ASPECTAL = new ItemFunctionTrait(["aspecty", "imbued", "focused", "energized","awakened","infused"], 1.3,ItemTrait.FIRST);
    CLASSRELATED = new ItemFunctionTrait(["class-related", "appropriate", "themed"], 1.3,ItemTrait.FIRST);

    PRETTY = new ItemFunctionTrait(["pretty", "aesthetic", "beautiful"], 0.1,ItemTrait.OPINION);
    HEALING = new ItemFunctionTrait(["healing", "regenerating", "recovery", "life"], 0.3,ItemTrait.PURPOSE);
    UNCOMFORTABLE = new ItemFunctionTrait(["uncomfortable", "hard","unpleasant"], 0.1,ItemTrait.OPINION);

    COMFORTABLE = new ItemFunctionTrait(["comfortable", "comforting", "soft", "cozy", "snug", "pleasant","plush"], -0.1,ItemTrait.OPINION);
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
