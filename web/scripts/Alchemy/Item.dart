import "../GameEntities/player.dart";
import "Item.dart";
import "../random_tables.dart";
import "Trait.dart";
import "../random.dart";
import 'dart:collection';

//I expect aspects and interests to have lists of items inside of them.
class Item {
    //whenever i make a new item, it gets added here. but not if i make a copy. needed for alchemy mini game.
    static List<Item> allUniqueItems = new List<Item>();
    String abjDesc;
    String shogunDesc;

    static Iterable<Item> uniqueItemsWithTrait(ItemTrait trait) {
        return Item.allUniqueItems.where((Item a) => (a.traits.contains(trait)));
    }

    String baseName;
    //a set is like a list but each thing in it happens exactly one or zero times
    Set<ItemTrait>  traits = new Set<ItemTrait>();




    //dynamic based on current traits.
    List<String> get descriptors {
        List<String> ret = new List<String>();
        //not based on the session's random, but not going to change each time, either.
        //does mean might have a Flaming Sword turn into a Glowing Fiery Sword but whatevs
        Random rand = new Random(traits.length);
        if(numUpgrades == 0) return ret;
        //TODO if this is slow, then cache result and only reget if dirty flag is set..
        List<ItemTrait> combinedTraits = new List<ItemTrait>.from(CombinedTrait.lookForCombinedTraits(traits));
        combinedTraits.sort((ItemTrait a,ItemTrait b){
          //  print("Sorting a is ${a.ordering} and b is ${b.ordering}");
            return a.ordering - b.ordering.round();
        });
        for(ItemTrait t in combinedTraits) {
            if(t is ItemObjectTrait || t.descriptions.isEmpty) {
                //skip
            }else {
                ret.add(" ${ capitilizeEachWord(rand.pickFrom(t.descriptions))}");
            }
        }
        return ret;
    }




    int numUpgrades = 0;
    int maxUpgrades = 3;

    double get rank {
        double ret = 0.0;
        for(ItemTrait it in traits) {
            ret += it.rank;
        }

        return ret;
    }

    Iterable<ItemTrait> get functionalTraits => traits.where((ItemTrait a) => (a is ItemFunctionTrait));
    Iterable<ItemTrait> get appearanceTraits => traits.where((ItemTrait a) => (a is ItemAppearanceTrait));
    Iterable<ItemTrait> get combinedTraits => traits.where((ItemTrait a) => (a is CombinedTrait));


    String get fullName {
        String ret = "";
        for(String d in descriptors) {
            ret += "$d ";
        }
        return "$ret${baseName}";
    }



    String toString() {
        return fullName;
    }

    Item copy() {
        Item ret =  new Item(baseName, new List<ItemTrait>.from(traits), abjDesc: this.abjDesc, shogunDesc:this.shogunDesc);
        ret.numUpgrades = numUpgrades;
        ret.maxUpgrades = maxUpgrades;
        return ret;
    }

    bool canUpgrade() {
        //print("Checking number of upgrades remaining for ${baseName}, numUpgrades is ${numUpgrades} and maxUpgrades is ${maxUpgrades}");
        if(maxUpgrades > 0 && numUpgrades< maxUpgrades) {
            return true;
        }else {
            return false;
        }
    }

    //most items won't have an abj desc, but some will
    Item(String this.baseName,List<ItemTrait> traitsList, {this.abjDesc: null, this.shogunDesc: null}) {
        traits = new Set.from(traitsList);
        if(this.traits.isEmpty)traits.add(ItemTraitFactory.GENERIC); //every item has at least one trait
        Set<CombinedTrait> ct = new Set.from(combinedTraits);
        //if i have any combined traits in me, just use the sub traits.
        for(CombinedTrait it in ct) {
            traits.addAll(it.subTraits);
            traits.remove(it);
        }

        Item.allUniqueItems.add(this);
    }

    String abjDescription(Random rand) {
        if(abjDesc != null) {
            return shogunDesc; //for testing
            //return abjDesc;
        }else {
            return randomDescription(rand);
        }
    }

    String shogunDescription(Random rand) {
        if(shogunDesc != null) {
            return shogunDesc;
        }else {
            return "Useless.";
        }
    }

    //it's sharp, it's pointy and it's a sword.   so can pick the same trait multiple times and just pick different words? Yes.
    String randomDescription(Random rand) {
        if(traits.isEmpty) traits.add(ItemTraitFactory.GENERIC); //don't stay empty
        ItemTrait first = rand.pickFrom(traits);
        ItemTrait second = rand.pickFrom(traits);
        ItemTrait third = rand.pickFrom(traits);

        String word1 = rand.pickFrom(first.descriptions);
        String word2 = rand.pickFrom(second.descriptions);
        String word3 = rand.pickFrom(third.descriptions); //for specibus is required trait.

        return randomDescriptionWithWords(rand, word1, word2, word3);
    }

    String randomDescriptionWithWords(Random rand, String word1, String word2, String word3) {
        //learned this trick in shitty card sim.
        List<String> templates = <String>["It's $word1 and it's $word2 and it's $word3. ","It's kind of $word1 but also sorta $word2. It's  $word3.","It's a $word3 but somehow also $word2 and actually maybe also $word1?"];

        return rand.pickFrom(templates);
    }
}

//wrapper for inventory SO THAT I STOP ADDING ITEMS DIRECTLY TO IT INSTEAD OF COPIES.
//and i guess eventually can implement syladdex shenanigans
//probably could have extended list, too, but that seems more compliced. 40+ methods i have to write?
class Sylladex extends Object with IterableMixin<Item> {
    List<Item> inventory;

    Sylladex([this.inventory = null]) {
        if(this.inventory == null) inventory = new List<Item>();
    }

    int get length => inventory.length;

    void add(Item item) {
        Item i = item;
        if(Item.allUniqueItems.contains(item)) i = item.copy();
        inventory.add(i);
    }

    void addAll(List<Item> items) {
        for(Item i in items) {
            add(i);
        }
    }

    Item get first => inventory.first;

    void remove(Item item) {
        inventory.remove(item);
    }

    void clear() {
        inventory.clear();
    }

  @override
  Iterator<Item> get iterator => inventory.iterator;
}