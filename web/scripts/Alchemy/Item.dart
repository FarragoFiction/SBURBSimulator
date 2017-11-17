import "../SBURBSim.dart";

//I expect aspects and interests to have lists of items inside of them.
class Item {
    String baseName;
    List<ItemTrait> traits = new List<ItemTrait>();
    int numUpgrades = 0;
    int maxUpgrades = 3;

    Iterable<ItemFunctionTrait> get functionalTraits => traits.where((ItemTrait a) => (a is ItemFunctionTrait));
    Iterable<ItemAppearanceTrait> get appearanceTraits => traits.where((ItemTrait a) => (a is ItemAppearanceTrait));

    //TODO when i have compontents, this needs to generate a name based on components.
    String get fullName => "${baseName}";

    Item copy() {
        return new Item(baseName, traits);
    }

    bool canUpgrade() {
        //print("Checking number of upgrades remaining for ${baseName}, numUpgrades is ${numUpgrades} and maxUpgrades is ${maxUpgrades}");
        if(maxUpgrades > 0 && numUpgrades< maxUpgrades) {
            return true;
        }else {
            return false;
        }
    }


    Item(String this.baseName,List<ItemTrait> this.traits) {
        if(this.traits.isEmpty) traits.add(ItemTraitFactory.GENERIC); //every item has at least one trait
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
        List<String> templates = <String>["It's $word1 and it's $word2 and it's $word3. ","It's kind of $word1 but also sorta $word2. It's a $word3.","It's a $word3 but somehow also $word2 and actually maybe also $word1?"];

        return rand.pickFrom(templates);
    }
}

