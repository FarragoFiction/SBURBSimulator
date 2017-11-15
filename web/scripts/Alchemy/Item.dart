import "../SBURBSim.dart";

class Item {
    String baseName;
    List<ItemTrait> traits = new List<ItemTrait>();

    Iterable<ItemFunctionTrait> get functionalTraits => traits.where((ItemTrait a) => (a is ItemFunctionTrait));
    Iterable<ItemAppearanceTrait> get appearanceTraits => traits.where((ItemTrait a) => (a is ItemAppearanceTrait));


    Item(String this.baseName,List<ItemTrait> this.traits);

    //it's sharp, it's pointy and it's a sword.   so can pick the same trait multiple times and just pick different words? Yes.
    String randomDescription(Random rand) {
        ItemTrait first = rand.pickFrom(traits);
        ItemTrait second = rand.pickFrom(traits);
        ItemTrait third = rand.pickFrom(traits);

        String word1 = rand.pickFrom(first.descriptions);
        String word2 = rand.pickFrom(first.descriptions);
        String word3 = rand.pickFrom(first.descriptions);


        //learned this trick in shitty card sim.
        List<String> templates = <String>["It's $word1 and it's $word2 and it's $word3. ","It's kind $word1 but also sorta $word2.","It's part $word1 but somehow also $word2 and actually maybe also $word3?"];

        return rand.pickFrom(templates);
    }
}