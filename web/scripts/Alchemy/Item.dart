import "../SBURBSim.dart";

//I expect aspects and interests to have lists of items inside of them.
class Item {
    String baseName;
    //a set is like a list but each thing in it happens exactly one or zero times
    Set<ItemTrait>  traits = new Set<ItemTrait>();
    //have one for each upgrade.
    List<String> descriptors = new List<String>();




    int numUpgrades = 0;
    int maxUpgrades = 3;

    //TODO: Don't let items repeat the same traits.
    //should i do this via filtering any added trait, or by storing them in a map instead of a list?

    double get rank {
        double ret = 0.0;
        for(ItemTrait it in traits) {
            ret += it.rank;
        }

        return ret;
    }

    Iterable<ItemFunctionTrait> get functionalTraits => traits.where((ItemTrait a) => (a is ItemFunctionTrait));
    Iterable<ItemAppearanceTrait> get appearanceTraits => traits.where((ItemTrait a) => (a is ItemAppearanceTrait));

    String get fullName {
        String ret = "${baseName}";
        for(String d in descriptors) {
            ret = "$d $ret";
        }
        return ret;
    }

    //takes in a list of traits that I am about to get, pick one I don't already have
    //and grab a descriptor from it. make sure to capitalize
    //i want the same alchemy to always result in the same object, so don't use the session random
    //instead a random seeded by the number of traits. so will always be the same no matter WHEN i do this.
    void addDescriptor(Set<ItemTrait> newTraits) {
        if(newTraits.isEmpty) return; //nothing to do here.
        print("trying to add a new trait");
        Random rand = new Random(newTraits.length);
        ItemTrait t = rand.pickFrom(newTraits);
        String chosen =rand.pickFrom(t.descriptions);
        chosen = capitilizeEachWord(chosen);
        descriptors.add(chosen);
    }

    String toString() {
        return fullName;
    }

    Item copy() {
        Item ret =  new Item(baseName, new List<ItemTrait>.from(traits));
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

    Item(String this.baseName,List<ItemTrait> traitsList) {
        traits = new Set.from(traitsList);
        if(this.traits.isEmpty)traits.add(ItemTraitFactory.GENERIC); //every item has at least one trait
    }

    //it's sharp, it's pointy and it's a sword.   so can pick the same trait multiple times and just pick different words? Yes.
    String randomDescription(Random rand) {
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

