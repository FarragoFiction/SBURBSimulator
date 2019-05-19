import 'Item.dart';
import 'dart:html';

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

  ItemTraitForm form;

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

  void renderForm(Element container, Item item) {
    print ("render form for trait $this");
    form = new ItemTraitForm(this, item, container);
    form.drawForm();
  }

}

class ItemTraitForm
{
  Element container;
  Item owner;
  ItemTrait trait;
  ItemTraitForm(ItemTrait this.trait, Item this.owner, Element parentContainer) {
    container = new DivElement();
    container.classes.add("SceneDiv");

    parentContainer.append(container);
  }

  void drawForm() {
    //draw my name (and list of sub names)
    //draw the remove button
    DivElement name = new DivElement()..text = "Trait: ${trait.toString()} (${trait.descriptions})";
    DivElement rank = new DivElement()..text = "Rank: ${trait.rank}";

    ButtonElement delete = new ButtonElement();
    delete.text = "Remove Trait";
    delete.onClick.listen((e) {
      //don't bother knowing where i am, just remove from all
      owner.traits.remove(trait);
      container.remove();
      owner.form.syncDataBoxToOwner();
    });
    container.append(name);
    container.append(rank);

    container.append(delete);
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
  static Iterable<ItemTrait> get pureTraits => allTraits.where((ItemTrait a) => !(a is CombinedTrait));

  static ItemTrait itemTraitNamed(String name) {
    for(ItemTrait itemTrait in allTraits) {
      if(itemTrait.descriptions.contains(name)) return itemTrait;
    }
    return null;
  }


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
  static ItemAppearanceTrait DUTTON;
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
  static ItemAppearanceTrait UNBEATABLE;


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
  static CombinedTrait CUEBALL;
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
  static CombinedTrait QUEENLY;
  static CombinedTrait KINGLY;
  static CombinedTrait JACKLY;
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
    TASER = new CombinedTrait("Taser",<String>["taser"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ZAP, RESTRAINING,SHOOTY]);
    NOCTURNE = new CombinedTrait("Nocturn",<String>["nocturn"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[OBSCURING, MUSICAL]);
    DIRGE = new CombinedTrait("Dirge",<String>["dirge"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[DOOMED, MUSICAL]);
    SNOBBBISH = new CombinedTrait("Snobbish",<String>["Snobbish","Noble"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLASSY, VALUABLE]);
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
    FASHIONABLE = new CombinedTrait("Fashionable",<String>["fashionable"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PRETTY, CLASSY]);
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
    ELEMENTAL = new CombinedTrait("Elemental",<String>["Elemental","Animated"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[MAGICAL,SENTIENT]);
    GOURMET = new CombinedTrait("Gourmet",<String>["Gourmet"], 0.0,ItemTrait.OPINION, <ItemTrait>[EDIBLE,CLASSY]);
    STAINEDGLASS = new CombinedTrait("Stained Glass",<String>["Stained Glass"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLASS,PRETTY, VALUABLE]);
    GAUZE = new CombinedTrait("Gauze",<String>["Gauze"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,CLOTH]);
    LOCKED = new CombinedTrait("Locked",<String>["Locked"], 0.0,ItemTrait.CONDITION, <ItemTrait>[RESTRAINING,ENRAGING]);
    ETCHED = new CombinedTrait("Etched",<String>["Etched"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[STONE,PAPER]);
    PAPYRUS = new CombinedTrait("Papyrus",<String>["Papyrus"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PAPER,PLANT]);
    FILM = new CombinedTrait("Film",<String>["film"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER,PLASTIC]);
    SAUCEY = new CombinedTrait("Saucey",<String>["Saucey"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CORRUPT,ENRAGING,EDIBLE]);
    LOTTERY = new CombinedTrait("Lottery",<String>["Lottery"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER,LUCKY]);
    BLINDFOLDED = new CombinedTrait("Blindfolded",<String>["Blindfolded"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING,CLOTH]);
    POSSESED = new CombinedTrait("Possessed",<String>["Possessed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[GHOSTLY,FLESH]);
    INFERNAL = new CombinedTrait("Infernal",<String>["Infernal"], 0.0,ItemTrait.OPINION, <ItemTrait>[GHOSTLY,ONFIRE]);
    GEPETTO = new CombinedTrait("Geppetto",<String>["Geppetto's","Pinocchio"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD,REAL,PUPPET,SENTIENT]);
    ABOMINABLE = new CombinedTrait("Abominable",<String>["Abominable"], 0.0,ItemTrait.OPINION, <ItemTrait>[FLESH,CORRUPT]);
    ASHEN = new CombinedTrait("Ashen",<String>["Ashen"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,DOOMED]);
    PALE = new CombinedTrait("Pale",<String>["Pale"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,CALMING]);
    PITCH = new CombinedTrait("Pitch",<String>["Pitch"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,ENRAGING]);
    LIT = new CombinedTrait("Lit",<String>["Lit"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D,ONFIRE]);
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
    SHRIEKING = new CombinedTrait("Banshee",<String>["Shrieking","Banshee"], 0.0,ItemTrait.CONDITION, <ItemTrait>[GHOSTLY,LOUD]);
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
    //fuck the world, no more named combined traits.
    new CombinedTrait("Necrotic",<String>["Necrotic"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE,GHOSTLY]);
    new CombinedTrait("Stem",<String>["Stem"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[BONE,PLANT]);
    new CombinedTrait("DryBone",<String>["DryBone"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE,DOOMED]);
    new CombinedTrait("XyloBone",<String>["XyloBone"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BONE,MUSICAL]);
    new CombinedTrait("Ribcage",<String>["Ribcage"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[BONE,RESTRAINING]);
    new CombinedTrait("BoneZone",<String>["BoneZone"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BONE,COOLK1D]);
    new CombinedTrait("Creaky",<String>["Creaky"], 0.0,ItemTrait.OPINION, <ItemTrait>[WOOD,LOUD]);
    new CombinedTrait("Maple",<String>["Maple"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,EDIBLE]);
    new CombinedTrait("Mahagony",<String>["Mahagony"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,PRETTY]);
    new CombinedTrait("Fenced",<String>["Fenced"], 0.0,ItemTrait.CONDITION, <ItemTrait>[WOOD,RESTRAINING]);
    new CombinedTrait("Bocote",<String>["Bocote"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,VALUABLE]);
    new CombinedTrait("Incense",<String>["Incense"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,CALMING]);
    new CombinedTrait("Ebony",<String>["Ebony"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD,OBSCURING]);
    new CombinedTrait("Birch",<String>["Birch"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,GLOWING]);
    new CombinedTrait("Knock-on-Wood",<String>["Knock-on-Wood"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD,LUCKY]);
    new CombinedTrait("Firewood",<String>["Firewood"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD,ONFIRE]);
    new CombinedTrait("BlackForest",<String>["BlackForest"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[WOOD,SCARY]);
    new CombinedTrait("Tree",<String>["Tree"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,PLANT]);
    new CombinedTrait("Ebonwood",<String>["Ebonwood"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,CORRUPT]);
    new CombinedTrait("Bark",<String>["Bark"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,FLESH]);
    new CombinedTrait("Caveman's",<String>["Caveman's","Cavewoman's"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD,STONE]);
    new CombinedTrait("3D Printed",<String>["3D Printed"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLASTIC,SMART]);
    new CombinedTrait("Thesis",<String>["Thesis"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER,SMART]);
    new CombinedTrait("Graphene",<String>["Graphene"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PAPER,ZAP]);
    new CombinedTrait("Prophecy",<String>["Prophecy"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER,DOOMED]);
    new CombinedTrait("Bedsheet",<String>["Bedsheet"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CLOTH,GHOSTLY]); //lol at tg for this
    new CombinedTrait("Gemstone",<String>["Gemstone", "Ruby"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,ROMANTIC]);
    new CombinedTrait("Pet Rock",<String>["Pet Rock"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[STONE,SENTIENT]);
    new CombinedTrait("Sand",<String>["Sand"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,COMFORTABLE]);
    new CombinedTrait("Geode",<String>["Geode"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,PRETTY]);
    new CombinedTrait("Silicon",<String>["Silicon"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,ZAP]);
    new CombinedTrait("Cryolite",<String>["Cryolite","Iceburg"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,COLD]);
    new CombinedTrait("Meteor",<String>["Meteor"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,EXPLODEY]);
    new CombinedTrait("Carbon",<String>["Carbon"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,PLANT]);
    new CombinedTrait("Mossy",<String>["Mossy"], 0.0,ItemTrait.CONDITION, <ItemTrait>[STONE,FUR]);
    new CombinedTrait("Lensed",<String>["Lensed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SMART,GLASS]);
    new CombinedTrait("Hide",<String>["Hide"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CLOTH,FLESH]);
    new CombinedTrait("FeatherBoa",<String>["FeatherBoa"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CLOTH,FEATHER]);
    new CombinedTrait("Tacky",<String>["Tacky"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLOTH,UGLY]);
    new CombinedTrait("Whip",<String>["Whip"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CLOTH,EDGED]);
    new CombinedTrait("Costumed",<String>["Costumed"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CLOTH,SCARY]);
    new CombinedTrait("Punk",<String>["Punk"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLOTH,POINTY]);
    new CombinedTrait("Weighted",<String>["Weighted"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CLOTH,HEAVY]); //goku knows
    new CombinedTrait("Favorite",<String>["Favorite"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLOTH,LUCKY]); //favorite shit etc
    new CombinedTrait("Novelty",<String>["Novelty"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLOTH,GLOWING]);
    new CombinedTrait("Security",<String>["Security"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,CALMING]);//like a security blanket
    new CombinedTrait("IcePack",<String>["IcePack"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,COLD]);
    new CombinedTrait("MotionCapture",<String>["MotionCapture"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CLOTH,ZAP]);
    new CombinedTrait("Silica",<String>["Silica"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,POISON]); //do not eat
    new CombinedTrait("Harp",<String>["Harp"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,MUSICAL]); //so many strings, it's practically a blanket
    new CombinedTrait("Silk",<String>["Silk"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,VALUABLE]);
    new CombinedTrait("RedFlag",<String>["RedFlag"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,ENRAGING]);
    new CombinedTrait("MagicCarpet1",<String>["MagicCarpet"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,SENTIENT]); //aladin
    new CombinedTrait("Satin",<String>["Satin","Tablecloth"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,ROMANTIC]);
    new CombinedTrait("MagicCarpet2",<String>["MagicCarpet"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,MAGICAL]);
    new CombinedTrait("Tweed",<String>["Tweed"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,CLASSY]);
    new CombinedTrait("Jean",<String>["Jean"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,COOLK1D]);
    new CombinedTrait("Tesla",<String>["Tesla"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SMART,ZAP]);
    new CombinedTrait("Ashwood",<String>["Ashwood"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[MAGICAL,WOOD]);
    new CombinedTrait("Peashooter",<String>["Peashooter"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,SHOOTY]);
    new CombinedTrait("Lacquer",<String>["Lacquer"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLASTIC,WOOD]);
    new CombinedTrait("Classpecty",<String>["Classpecty"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLASSRELATED,ASPECTAL]);
    new CombinedTrait("Smartass",<String>["Smartass"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,UNCOMFORTABLE]);
    new CombinedTrait("Miraculous",<String>["Miraculous","Magnets","Miracle"], 0.0,ItemTrait.OPINION, <ItemTrait>[REAL,FAKE,MAGICAL]);
    new CombinedTrait("Pigeon",<String>["Pigeon"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CORRUPT,FEATHER]);
    new CombinedTrait("Grimoire",<String>["Grimoire"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CORRUPT,PAPER]);
    new CombinedTrait("Oglogoth's",<String>["Oglogoth's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[CORRUPT,POINTY]);
    new CombinedTrait("Echidna's",<String>["Echidna's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LEGENDARY,POINTY]);
    new CombinedTrait("Superior",<String>["Superior"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SMART,CLASSY]);
    new CombinedTrait("Lego",<String>["Lego"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[LEGENDARY,PLASTIC,CALMING,BLUNT]);
    new CombinedTrait("Yardstick",<String>["Yardstick"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,STICK,WOOD, PAPER]);
    QUEENLY = new CombinedTrait("Queenly",<String>["Queenly"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[OBSCURING,MAGICAL,REAL, UNCOMFORTABLE, SCARY]);
    KINGLY = new CombinedTrait("Kingly",<String>["Kingly"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SCARY,BLUNT,HEAVY, MAGICAL,REAL]);
    JACKLY = new CombinedTrait("Jack",<String>["Jack"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[POINTY,EDGED,METAL, OBSCURING]);
    new CombinedTrait("Codpiece",<String>["Codpiece","Codtier"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,FAKE,WOOD, CLASSRELATED, CLOTH]);
    new CombinedTrait("Graceful",<String>["Graceful"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,BOOK,PAPER,METAL, SMART, CLASSRELATED]);
    new CombinedTrait("Guide",<String>["Guide","Tourist"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,BOOK,PAPER,SMART, CLASSRELATED,COLD]);
    new CombinedTrait("Testament",<String>["Will","Testament"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,DOOMED,PAPER,SMART,RESTRAINING]);
    new CombinedTrait("Excalibur",<String>["Excalibur's","Excalibur"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LEGENDARY,GLOWING,METAL,POINTY,EDGED,SWORD]);
    new CombinedTrait("Influential",<String>["Influential"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LEGENDARY,PAPER,ENRAGING,BOOK]);
    new CombinedTrait("Alternative",<String>["Alternative"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LEGENDARY,MAGICAL,CLOTH, OBSCURING]);
    new CombinedTrait("Valkyrie",<String>["Valkyrie"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LEGENDARY,UNCOMFORTABLE,BONE,METAL,SHIELD, PRETTY]);
    new CombinedTrait("Ongoing",<String>["Ongoing"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LEGENDARY,STONE,CLASSY,BUST, BLUNT]);
    new CombinedTrait("Short",<String>["Short"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LEGENDARY,CLOTH,VALUABLE, PRETTY, CLASSY]);
    new CombinedTrait("Crown",<String>["Crown"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,METAL,VALUABLE, PRETTY, CLASSY]);
    new CombinedTrait("Gristtorrent",<String>["Gristtorrent"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,PLASTIC,ZAP, OBSCURING, SMART]);
    new CombinedTrait("Robe",<String>["Robe"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,CLOTH,SMART, MAGICAL, COMFORTABLE]);
    new CombinedTrait("Beret",<String>["Beret"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,CLOTH,SMART, PRETTY, CLASSY]);
    new CombinedTrait("Blank",<String>["Blank"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LEGENDARY,PAPER,SMART, BOOK, SMART, OBSCURING]);
    CUEBALL = new CombinedTrait("Cueball",<String>["Cueball"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[LEGENDARY,PRETTY,CERAMIC, BLUNT, BALL, SENTIENT]);
    new CombinedTrait("Meddler's",<String>["Meddler's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LEGENDARY,BOOK,PAPER, ENRAGING, HEALING]);
    new CombinedTrait("Scroll",<String>["Scroll"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL,PAPER]);
    new CombinedTrait("Tome",<String>["Tome"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER,SMART,BOOK]);
    new CombinedTrait("Lockpick",<String>["Lockpick"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,METAL,OBSCURING,POINTY]);
    new CombinedTrait("Warped",<String>["Warped"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LEGENDARY,METAL,GLASS,OBSCURING]);
    new CombinedTrait("Stairs",<String>["Stairs"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,FAKE,WOOD,COOLK1D, CALMING, HEALING]);
    new CombinedTrait("Rocket",<String>["Rocket"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,ONFIRE,METAL,LOUD]);
    new CombinedTrait("~ATH",<String>["~ATH"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,ZAP,PAPER,BOOK,DOOMED]);
    new CombinedTrait("Puppeted",<String>["Puppeted"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LEGENDARY,WOOD,SENTIENT,SCARY]);
    new CombinedTrait("Angelic",<String>["Angelic"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LEGENDARY,REAL,FEATHER,GLOWING, MUSICAL,MAGICAL]);
    new CombinedTrait("Vitae",<String>["Vitae"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[LEGENDARY,HEALING,GLASS,MAGICAL]);
    new CombinedTrait("Fluorite",<String>["Fluorite"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[LEGENDARY,GLOWING,LUCKY,STONE,GLASS]);
    new CombinedTrait("Janus",<String>["Janus"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LEGENDARY,UNCOMFORTABLE,STONE,CLASSY, ZAP]);
    new CombinedTrait("Bacchus",<String>["Bacchus"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LEGENDARY,EDIBLE,ENRAGING,CLASSY]);
    new CombinedTrait("TurnTable",<String>["TurnTable"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LEGENDARY,METAL,MUSICAL,COOLK1D]);
    new CombinedTrait("???",<String>["[???]","[Unknown]"], 0.0,ItemTrait.OPINION, <ItemTrait>[LEGENDARY,GLASS,NUCLEAR,GLOWING,OBSCURING]);
    new CombinedTrait("Demonite",<String>["Demonite"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,CORRUPT]);
    new CombinedTrait("Stymphalian",<String>["Stymphalian"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[METAL,FEATHER]);
    new CombinedTrait("Junky",<String>["Junky"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,UGLY]);
    new CombinedTrait("Cold Iron",<String>["Cold Welded","Cold Iron"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,COLD]);
    new CombinedTrait("Bolted",<String>["Bolted"], 0.0,ItemTrait.CONDITION, <ItemTrait>[METAL,RESTRAINING]);
    new CombinedTrait("Armored",<String>["Armored"], 0.0,ItemTrait.CONDITION, <ItemTrait>[METAL,SENTIENT]);
    new CombinedTrait("Heartsteel",<String>["Heartsteel","Rose Gold"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,ROMANTIC]);
    new CombinedTrait("Brick",<String>["Brick"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CERAMIC,STONE]);
    new CombinedTrait("Clay",<String>["Clay"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CERAMIC,RUBBER]);
    new CombinedTrait("Mugly",<String>["Mugly"], 0.0,ItemTrait.OPINION, <ItemTrait>[CERAMIC,UGLY]);
    new CombinedTrait("Plate",<String>["Plate"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CERAMIC,BLUNT]);
    new CombinedTrait("Terracotta",<String>["Terracotta"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CERAMIC,ONFIRE]);
    new CombinedTrait("Semiconductive",<String>["Semiconductive"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CERAMIC,ZAP]);
    new CombinedTrait("Vinyl",<String>["Vinyl"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CERAMIC,MUSICAL]);
    new CombinedTrait("Artisan",<String>["Artisan"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CERAMIC,SMART]);
    new CombinedTrait("Tiled",<String>["Tiled"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CERAMIC,CLASSY]);
    new CombinedTrait("Hand-Sculpted",<String>["Hand-Sculpted"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CERAMIC,REAL]);
    new CombinedTrait("Handicraft",<String>["Handicraft"], 0.0,ItemTrait.OPINION, <ItemTrait>[SHITTY,PAPER]);
    new CombinedTrait("Torn",<String>["Torn"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SHITTY,CLOTH]);
    new CombinedTrait("Grotesque",<String>["Grotesque"], 0.0,ItemTrait.OPINION, <ItemTrait>[SHITTY,UGLY]);
    new CombinedTrait("Flickering",<String>["Flickering"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SHITTY,GLOWING]);
    new CombinedTrait("Thinly Veiled",<String>["Thinly Veiled","Translucent"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[SHITTY,OBSCURING]);
    new CombinedTrait("Fragile",<String>["Fragile"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SHITTY,VALUABLE]);
    new CombinedTrait("Troll's",<String>["Troll's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SHITTY,ENRAGING]);
    new CombinedTrait("Sappy",<String>["Sappy"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[SHITTY,ROMANTIC]);
    new CombinedTrait("Bootleg",<String>["Bootleg"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[SHITTY,FAKE]);
    new CombinedTrait("Distorted",<String>["Distorted"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[SHITTY,LOUD]);
    new CombinedTrait("Ent's",<String>["Ent's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[WOOD,SENTIENT]);
    new CombinedTrait("WeepingWillow",<String>["WeepingWillow"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,GHOSTLY]);
    new CombinedTrait("Latex",<String>["Latex"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,RUBBER]);
    new CombinedTrait("Turf",<String>["Turf"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLASTIC,UNCOMFORTABLE]);
    new CombinedTrait("Stress Relieving",<String>["Stress Relieving"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RUBBER,CALMING]);
    new CombinedTrait("R-Rated",<String>["R-Rated"], 0.0,ItemTrait.CONDITION, <ItemTrait>[RUBBER,ROMANTIC]); //let's be honest, most romantic shit is gonna fall under this category. rip
    new CombinedTrait("Racing",<String>["Racing"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RUBBER,ONFIRE]);
    new CombinedTrait("Cross Stitch",<String>["Cross Stitch"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER,CLOTH]);
    new CombinedTrait("LoveLetter",<String>["LoveLetter"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER,ROMANTIC]);
    new CombinedTrait("EbonStone",<String>["EbonStone"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,CORRUPT]);
    new CombinedTrait("Rock Candy",<String>["Rock Candy"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,EDIBLE]);
    new CombinedTrait("Smashing",<String>["Smashing"], 0.0,ItemTrait.OPINION, <ItemTrait>[STONE,LOUD]);
    new CombinedTrait("Anomalous",<String>["Anomalous"], 0.0,ItemTrait.OPINION, <ItemTrait>[GHOSTLY,CORRUPT]);
    new CombinedTrait("Onmoraki",<String>["Onmoraki"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GHOSTLY,FEATHER]);
    new CombinedTrait("Ghastly",<String>["Ghastly"], 0.0,ItemTrait.OPINION, <ItemTrait>[GHOSTLY,UGLY]);
    new CombinedTrait("Shade",<String>["Shade","Shadow"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GHOSTLY,OBSCURING]);
    new CombinedTrait("Choral",<String>["Choral"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GHOSTLY,MUSICAL]);
    new CombinedTrait("Eerie",<String>["Eerie"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GHOSTLY,PRETTY]);
    new CombinedTrait("Spiritual",<String>["Spiritual"], 0.0,ItemTrait.OPINION, <ItemTrait>[GHOSTLY,REAL]);
    new CombinedTrait("Heart",<String>["Heart"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FLESH,ROMANTIC]);
    new CombinedTrait("Primordial",<String>["Primordial"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FLESH,SENTIENT]);
    new CombinedTrait("Eyeball",<String>["Eyeball"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FLESH,GLOWING]);
    new CombinedTrait("Vulture",<String>["Vulture"], 0.0,ItemTrait.CONDITION, <ItemTrait>[FLESH,FEATHER]);
    new CombinedTrait("BlackMagic",<String>["DarkSpell","BlackMagic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CORRUPT,MAGICAL]);
    new CombinedTrait("Doppelganger",<String>["Doppelganger"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CORRUPT,FAKE]);
    new CombinedTrait("Incomprehensible",<String>["Incomprehensible"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CORRUPT,LOUD]);
    new CombinedTrait("Destructive",<String>["Destructive"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CORRUPT,SENTIENT]);
    new CombinedTrait("Growling",<String>["Growling"], 0.0,ItemTrait.CONDITION, <ItemTrait>[FUR,LOUD]);
    new CombinedTrait("Coconut",<String>["Coconut"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FUR,EDIBLE]);
    new CombinedTrait("Beastmaster's",<String>["Beastmaster's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[FUR,RESTRAINING]);
    new CombinedTrait("Fluffy",<String>["Fluffy"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FUR,FEATHER]);
    new CombinedTrait("Fern",<String>["Feather Grass","Fern"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,FEATHER]);
    new CombinedTrait("Four Leafed",<String>["Four Leafed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[PLANT,LUCKY]);
    new CombinedTrait("Shrubbery",<String>["Shrubbery"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,OBSCURING]);
    new CombinedTrait("Ecballium",<String>["Shameplant","Ecballium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,EXPLODEY]);
    new CombinedTrait("Truffle",<String>["Truffle"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,VALUABLE]);
    new CombinedTrait("Vine",<String>["Vine"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,RESTRAINING]);
    new CombinedTrait("CorpseBlossom",<String>["Carion","CorpseBlossom"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,UNCOMFORTABLE]);
    new CombinedTrait("Fruity",<String>["Fruity"], 0.0,ItemTrait.CONDITION, <ItemTrait>[PLANT,EDIBLE]);
    new CombinedTrait("Squawking",<String>["Squawking"], 0.0,ItemTrait.CONDITION, <ItemTrait>[FEATHER,LOUD]);
    new CombinedTrait("Poultry",<String>["Poultry","Chicken","Turkey"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FEATHER,EDIBLE]);
    new CombinedTrait("Dove",<String>["Dove"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FEATHER,ROMANTIC]);
    new CombinedTrait("Peacock",<String>["Peacock"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FEATHER,PRETTY]);
    new CombinedTrait("Stork",<String>["Stork"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FEATHER,HEALING]);
    new CombinedTrait("Zhenniao",<String>["Zhenniao"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FEATHER,POISON]);
    new CombinedTrait("Dodo",<String>["Dodo","Passenger Pigeon"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FEATHER,DOOMED]);
    new CombinedTrait("Raven",<String>["Raven"], 0.0,ItemTrait.COLOR, <ItemTrait>[FEATHER,SCARY]);
    new CombinedTrait("Frilled",<String>["Frilled"], 0.0,ItemTrait.CONDITION, <ItemTrait>[FEATHER,UGLY]);
    new CombinedTrait("Horrifying",<String>["Horrifying"], 0.0,ItemTrait.OPINION, <ItemTrait>[UGLY,SCARY]);
    new CombinedTrait("Burning Edge",<String>["Burning Edge"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDGED,ONFIRE]);
    new CombinedTrait("Scapel",<String>["Scapel"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDGED,HEALING]);
    new CombinedTrait("Menacing",<String>["Menacing"], 0.0,ItemTrait.OPINION, <ItemTrait>[SCARY,POINTY]);
    new CombinedTrait("Syringe",<String>["Syringe"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,POINTY]);
    new CombinedTrait("Bitter",<String>["Bitter","Sour"], 0.0,ItemTrait.OPINION, <ItemTrait>[EDIBLE,UNCOMFORTABLE]);
    new CombinedTrait("Pineapple",<String>["Pineapple"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EDIBLE,POINTY]);
    new CombinedTrait("Crunchy",<String>["Crunchy"], 0.0,ItemTrait.OPINION, <ItemTrait>[EDIBLE,BLUNT]);
    new CombinedTrait("Bass",<String>["Bass"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEAVY,MUSICAL]);
    new CombinedTrait("Rigid",<String>["Rigid"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEAVY,UNCOMFORTABLE]);
    new CombinedTrait("Prop",<String>["Prop"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SHOOTY,FAKE]);
    new CombinedTrait("Magic Missle",<String>["Magic Missle"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SHOOTY,MAGICAL]);
    new CombinedTrait("Gangster's",<String>["Gangster's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SHOOTY,COOLK1D]);
    new CombinedTrait("Cupid's",<String>["Cupid's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SHOOTY,ROMANTIC]);
    new CombinedTrait("Turreted",<String>["Turreted"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SHOOTY,SENTIENT]);
    new CombinedTrait("AutoTarget",<String>["AutoAiming","AutoTarget", "TargetAssist","AimBot"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SHOOTY,SMART]);
    new CombinedTrait("Guerilla's",<String>["Guerilla's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SHOOTY,ENRAGING]);
    new CombinedTrait("Rail",<String>["Rail","ChargeDart"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SHOOTY,ZAP]);
    new CombinedTrait("Tau",<String>["Tau"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SHOOTY,NUCLEAR]);
    new CombinedTrait("Pew",<String>["Pew","Laser"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SHOOTY,GLOWING]);
    new CombinedTrait("Thermal",<String>["Thermal"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SHOOTY,ONFIRE]);
    new CombinedTrait("Plasma",<String>["Plasma","Incandescent"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLOWING,ONFIRE]);
    new CombinedTrait("Shredding",<String>["Shredding"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[MUSICAL,ONFIRE]);
    new CombinedTrait("Leprechaun",<String>["Leprechaun"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[LUCKY,SENTIENT]);
    new CombinedTrait("Charmed",<String>["Charmed"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[LUCKY,VALUABLE]);
    new CombinedTrait("Leprechaun",<String>["Leprechaun"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LUCKY,SENTIENT]);
    new CombinedTrait("Prospitian",<String>["Prospitian"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[GLOWING,COMFORTABLE]);
    new CombinedTrait("Vigilant",<String>["Vigilant"], 0.0,ItemTrait.CONDITION, <ItemTrait>[GLOWING,SENTIENT]);
    new CombinedTrait("Stand-Up",<String>["Stand-Up"], 0.0,ItemTrait.OPINION, <ItemTrait>[GLOWING,FUNNY]);
    new CombinedTrait("Bedazzled",<String>["Bedazzled"], 0.0,ItemTrait.CONDITION, <ItemTrait>[GLOWING,COOLK1D]);
    new CombinedTrait("Thief's",<String>["Thief's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[OBSCURING,MAGICAL]);
    new CombinedTrait("InvisibilityCloak",<String>["InvisibilityCloak"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING,MAGICAL, CLOTH]);
    new CombinedTrait("Comedy Night",<String>["Comedy Night","Dry Humor"], 0.0,ItemTrait.CONDITION, <ItemTrait>[OBSCURING,FUNNY]);
    new CombinedTrait("Stealthy",<String>["Stealthy"], 0.0,ItemTrait.OPINION, <ItemTrait>[OBSCURING,SENTIENT]);
    new CombinedTrait("Subterfuge",<String>["Subterfuge"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING,SMART]);
    new CombinedTrait("Dersite",<String>["Dersite"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[OBSCURING,UNCOMFORTABLE]);
    new CombinedTrait("Ambient",<String>["Ambient","Muzak","Elevator"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[CALMING,MUSICAL]);
    new CombinedTrait("Anesthesia",<String>["Anesthesia"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CALMING,HEALING]);
    new CombinedTrait("Supportive",<String>["Supportive"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CALMING,SENTIENT]);
    new CombinedTrait("Nuka",<String>["Nuka"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,NUCLEAR]);
    new CombinedTrait("Contaminated",<String>["Contaminated"], 0.0,ItemTrait.CONDITION, <ItemTrait>[POISON,NUCLEAR]);
    new CombinedTrait("Unstable",<String>["Unstable"], 0.0,ItemTrait.CONDITION, <ItemTrait>[DOOMED,NUCLEAR]);
    new CombinedTrait("Timebomb",<String>["Timebomb"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[DOOMED,EXPLODEY]);
    new CombinedTrait("Short Circuiting",<String>["Short Circuiting"], 0.0,ItemTrait.CONDITION, <ItemTrait>[ZAP,DOOMED]);
    new CombinedTrait("Relic",<String>["Artifact","Relic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[DOOMED,VALUABLE]);
    new CombinedTrait("Existentialist",<String>["Existentialist"], 0.0,ItemTrait.CONDITION, <ItemTrait>[DOOMED,UNCOMFORTABLE]);
    new CombinedTrait("Apocalyptic",<String>["Apocalyptic"], 0.0,ItemTrait.OPINION, <ItemTrait>[DOOMED,REAL]);
    new CombinedTrait("Dud",<String>["Dud"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EXPLODEY,FAKE]);
    new CombinedTrait("Guided",<String>["Heat Seeking","Guided"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EXPLODEY,SMART]);
    new CombinedTrait("Bobomb",<String>["Bobomb"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EXPLODEY,SENTIENT]);
    new CombinedTrait("Dread",<String>["Dread"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[DOOMED,RESTRAINING]);
    new CombinedTrait("Knockback",<String>["Knockback"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EXPLODEY,RESTRAINING]);
    new CombinedTrait("Paralysis",<String>["Paralysis"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ZAP,RESTRAINING]);
    new CombinedTrait("Carnage",<String>["Carnage"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EXPLODEY,ENRAGING]);
    new CombinedTrait("Blast Beat",<String>["Blast Beat"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EXPLODEY,MUSICAL]);
    new CombinedTrait("Corrosive",<String>["Corrosive"], 0.0,ItemTrait.CONDITION, <ItemTrait>[EXPLODEY,POISON]);
    new CombinedTrait("Ice Bomb",<String>["Flash Freeze","Ice Bomb"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EXPLODEY,COLD]);
    new CombinedTrait("Cryogenic",<String>["Cryogenic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[COLD,HEALING]);
    new CombinedTrait("Spellcasting",<String>["Spellcasting","Thundaga"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MAGICAL,ZAP]);
    new CombinedTrait("Tingling",<String>["Tingling"], 0.0,ItemTrait.CONDITION, <ItemTrait>[ZAP,COMFORTABLE]);
    new CombinedTrait("Rage Plague",<String>["Rage Plague","Beserk"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ENRAGING,POISON]);
    new CombinedTrait("Nerve Gas",<String>["Nerve Gas"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[POISON,RESTRAINING]);
    new CombinedTrait("Carbon Monoxide",<String>["Carbon Monoxide"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[POISON,UNCOMFORTABLE]);
    new CombinedTrait("Neurotoxin",<String>["Neurotoxin"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[POISON,SMART]);
    new CombinedTrait("Virulent",<String>["Virulent"], 0.0,ItemTrait.CONDITION, <ItemTrait>[POISON,SENTIENT]);
    new CombinedTrait("Toxic",<String>["Toxic"], 0.0,ItemTrait.CONDITION, <ItemTrait>[POISON,ROMANTIC]);
    new CombinedTrait("Laughing Gas",<String>["Laughing Gas","Nitrous","N20"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[POISON,FUNNY]);
    new CombinedTrait("Amplified",<String>["Amplified","Amped"], 0.0,ItemTrait.CONDITION, <ItemTrait>[MUSICAL,LOUD]);
    new CombinedTrait("Rap",<String>["Rap"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,COOLK1D]);
    new CombinedTrait("Saxaphone",<String>["Saxaphone","Saxobeat"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,ROMANTIC]);
    new CombinedTrait("Offbeat",<String>["Offbeat","Syncopated"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,UNCOMFORTABLE]);
    new CombinedTrait("Piper's",<String>["Piper's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MUSICAL,RESTRAINING]);
    new CombinedTrait("Melodic",<String>["Melodic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,PRETTY]);
    new CombinedTrait("Smooth",<String>["Smooth"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,COMFORTABLE]);
    new CombinedTrait("Thrash",<String>["Thrash"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,ENRAGING]);
    new CombinedTrait("Chant",<String>["Chant","Chanting"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,HEALING]);
    new CombinedTrait("Chewy",<String>["Chewy"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ENRAGING,EDIBLE]);
    new CombinedTrait("Phony",<String>["Phony"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ENRAGING,FAKE]);
    new CombinedTrait("Doctor's",<String>["Doctor's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SMART,HEALING]);
    new CombinedTrait("Straitjacketed",<String>["Straitjacketed"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RESTRAINING,HEALING]);
    new CombinedTrait("Strapped",<String>["Strapped"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RESTRAINING,UNCOMFORTABLE]);
    new CombinedTrait("Bondage",<String>["Bondage"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RESTRAINING,ROMANTIC]);
    new CombinedTrait("Sealed",<String>["Sealed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[RESTRAINING,MAGICAL]);
    new CombinedTrait("Attractive",<String>["Attractive"], 0.0,ItemTrait.OPINION, <ItemTrait>[PRETTY,ROMANTIC]);
    new CombinedTrait("Relaxed",<String>["Relaxed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[COMFORTABLE,SENTIENT]);
    new CombinedTrait("Loveseat",<String>["Loveseat"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[COMFORTABLE,ROMANTIC]);
    new CombinedTrait("Comfort Food",<String>["Doughy","Comfort Food"], 0.0,ItemTrait.OPINION, <ItemTrait>[EDIBLE,COMFORTABLE]);
    new CombinedTrait("Yandere",<String>["Yandere"], 0.0,ItemTrait.OPINION, <ItemTrait>[ROMANTIC,SCARY]);
    new CombinedTrait("Tsundere",<String>["Tsundere"], 0.0,ItemTrait.OPINION, <ItemTrait>[ROMANTIC,UNCOMFORTABLE]);
    new CombinedTrait("Disturbed",<String>["Disturbed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SENTIENT,UNCOMFORTABLE]);
    new CombinedTrait("Sapient",<String>["Sapient"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SMART,SENTIENT]);
    new CombinedTrait("Hydroponic",<String>["Lab Grown","Hydroponic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SMART,EDIBLE]);
    new CombinedTrait("Free Range",<String>["Free Range"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SENTIENT,EDIBLE]);
    new CombinedTrait("Gentlemanly",<String>["Gentleman's","Lady's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[ROMANTIC,CLASSY]);
    new CombinedTrait("Sapient",<String>["Sapient"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SMART,SENTIENT]);
    new CombinedTrait("Sentimental",<String>["Sentimental","Anniversary"], 0.0,ItemTrait.CONDITION, <ItemTrait>[ROMANTIC,REAL]);
    new CombinedTrait("Doki-Doki",<String>["Doki-Doki"], 0.0,ItemTrait.CONDITION, <ItemTrait>[ROMANTIC,LOUD]);
    new CombinedTrait("Doki-Doki Literature Club",<String>["Doki-Doki Literature Club"], 0.0,ItemTrait.CONDITION, <ItemTrait>[ROMANTIC,LOUD,BOOK,CLUB]);
    new CombinedTrait("Banana",<String>["Banana"], 0.0,ItemTrait.CONDITION, <ItemTrait>[EDIBLE,FUNNY]);
    new CombinedTrait("Mana",<String>["Mana"], 0.0,ItemTrait.CONDITION, <ItemTrait>[EDIBLE,MAGICAL]);
    new CombinedTrait("Homemade",<String>["Homemade"], 0.0,ItemTrait.CONDITION, <ItemTrait>[EDIBLE,REAL]);
    new CombinedTrait("Steampunk",<String>["Steampunk"], 0.0,ItemTrait.CONDITION, <ItemTrait>[MAGICAL,CLASSY]);
    new CombinedTrait("I Can't Stop Laughing",<String>["Thor's Banana"], 0.0,ItemTrait.CONDITION, <ItemTrait>[EDIBLE,FUNNY, ZAP, LOUD]);

    //new slurp
    new CombinedTrait("Soulsteel",<String>["Soulsteel"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,GHOSTLY]);
    new CombinedTrait("Ritual",<String>["Ritual","Tribal"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BONE,ONFIRE]);
    new CombinedTrait("Inflamable",<String>["Inflamable"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SHITTY,ONFIRE]);
    new CombinedTrait("Crafting",<String>["Crafting"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD,SMART]);
    new CombinedTrait("Polluting",<String>["Polluting"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLASTIC,ONFIRE]);
    new CombinedTrait("Insulated",<String>["Insulated"], 0.0,ItemTrait.CONDITION, <ItemTrait>[RUBBER,ZAP]);
    new CombinedTrait("Ash",<String>["Ash"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PAPER,ONFIRE]);
    new CombinedTrait("Delicate",<String>["Delicate"], 0.0,ItemTrait.CONDITION, <ItemTrait>[PAPER,GLASS]);
    new CombinedTrait("Glass Blower's",<String>["Glass Blower's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[GLASS,ONFIRE]);
    new CombinedTrait("Sunburnt",<String>["Sunburnt"], 0.0,ItemTrait.CONDITION, <ItemTrait>[FLESH,ONFIRE]);
    new CombinedTrait("Pyrebitten",<String>["Pyrebitten"], 0.0,ItemTrait.CONDITION, <ItemTrait>[ONFIRE,CORRUPT]);
    new CombinedTrait("Mink",<String>["Mink"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[ROMANTIC,FUR]);
    new CombinedTrait("Wildfire",<String>["Wildfire"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[PLANT,ONFIRE]);
    new CombinedTrait("Scarred",<String>["Scarred"], 0.0,ItemTrait.CONDITION, <ItemTrait>[HEALING,UGLY]);
    new CombinedTrait("Hyper Realistic",<String>["Hyper Realistic"], 0.0,ItemTrait.OPINION, <ItemTrait>[REAL,SCARY]);
    new CombinedTrait("Hestia's",<String>["Hestia's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[LUCKY,ONFIRE]);
    new CombinedTrait("Smoking",<String>["Smoking"], 0.0,ItemTrait.CONDITION, <ItemTrait>[OBSCURING,ONFIRE]);
    new CombinedTrait("Radiator",<String>["Heating", "Radiator","Furnace"], 0.0,ItemTrait.CONDITION, <ItemTrait>[ONFIRE,ZAP]);
    new CombinedTrait("Fuming",<String>["Fuming"], 0.0,ItemTrait.CONDITION, <ItemTrait>[ONFIRE,POISON]);
    new CombinedTrait("Firework",<String>["Firework", "Sparkler"], 0.0,ItemTrait.CONDITION, <ItemTrait>[ONFIRE,PRETTY]);
    new CombinedTrait("Panicky",<String>["Panicky"], 0.0,ItemTrait.CONDITION, <ItemTrait>[DOOMED,SENTIENT]);
    new CombinedTrait("Ornamental",<String>["Ornamental"], 0.0,ItemTrait.CONDITION, <ItemTrait>[VALUABLE,PRETTY]);
    new CombinedTrait("Dear",<String>["Dear", "Precious"], 0.0,ItemTrait.CONDITION, <ItemTrait>[VALUABLE,ROMANTIC]);
    new CombinedTrait("Swaggy",<String>["Swaggy","Swag"], 0.0,ItemTrait.CONDITION, <ItemTrait>[VALUABLE,COOLK1D]);
    new CombinedTrait("Uncanny",<String>["Uncanny"], 0.0,ItemTrait.CONDITION, <ItemTrait>[UNCOMFORTABLE,REAL]);
    new CombinedTrait("Talkative",<String>["Talkative","Blabbering"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LOUD,SENTIENT]);
    new CombinedTrait("Waifu",<String>["Waifu","Catfish"], 0.0,ItemTrait.CONDITION, <ItemTrait>[ROMANTIC,FAKE]);
    new CombinedTrait("Charming",<String>["Charming"], 0.0,ItemTrait.CONDITION, <ItemTrait>[MAGICAL,ROMANTIC]);
    new CombinedTrait("God Tier",<String>["God Tier"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CLASSRELATED,ASPECTAL, REAL]);
    new CombinedTrait("Cod Tier",<String>["Cod Tier"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CLASSRELATED,ASPECTAL, REAL, FAKE, CLOTH]);
    new CombinedTrait("Dog Tier",<String>["Dog Tier"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CLASSRELATED,ASPECTAL, REAL,FUR]);

    //another slurp
    new CombinedTrait("Cracked",<String>["Cracked"], 0.0,ItemTrait.CONDITION, <ItemTrait>[STONE,SHITTY]);
    new CombinedTrait("Ruffled",<String>["Ruffled"], 0.0,ItemTrait.CONDITION, <ItemTrait>[FEATHER,SHITTY]);
    new CombinedTrait("Mandrake",<String>["Mandrake"], 0.0,ItemTrait.CONDITION, <ItemTrait>[PLANT,SCARY]);
    new CombinedTrait("Beanstalk",<String>["Beanstalk"], 0.0,ItemTrait.CONDITION, <ItemTrait>[MAGICAL,PLANT]);
    new CombinedTrait("Unnerving",<String>["Unnerving"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SCARY,UNCOMFORTABLE]);
    new CombinedTrait("Chipped",<String>["Chipped"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CERAMIC,SHITTY]);


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
    DUTTON = new ItemAppearanceTrait(<String>["dutton"], 0.6,ItemTrait.ORIGIN);
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
    //like the rabbit.
    UNBEATABLE = new ItemAppearanceTrait(<String>["Unbeatable"], 40.37,ItemTrait.FIRST);

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

  static SelectElement drawSelectTraits(Element div, Item owner, Element triggersSection) {
    triggersSection.setInnerHtml("<h3>Item Traits:   First is 'core' if specibus </h3><br>");
    Iterable<ItemTrait> traits;

    traits = ItemTraitFactory.pureTraits;

    SelectElement select = new SelectElement();
    for(ItemTrait sample in traits) {
      OptionElement o = new OptionElement();
      o.value = sample.toString();
      o.text = sample.toString();
      select.append(o);
    }

    ButtonElement button = new ButtonElement();
    button.text = "Add Item Trait";
    button.onClick.listen((e) {
      String type = select.options[select.selectedIndex].value;
      for(ItemTrait tc in traits) {
        if(tc.toString() == type) {
          ItemTrait newTrait = ItemTraitFactory.itemTraitNamed(type);
          owner.traits.add(newTrait);
          newTrait.renderForm(triggersSection, owner);
          owner.form.syncDataBoxToOwner();
        }
      }
    });

    triggersSection.append(select);
    triggersSection.append(button);

    return select;
  }


}
