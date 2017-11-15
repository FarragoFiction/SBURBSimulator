/*
http://mspaintadventures.wikia.com/wiki/Alchemiter

Appropriately for AND combining, an && alchemy result will often demonstrate the functionality of both components
 – e.g. Dave's iShades can be a phone and a rad pair of shades – while an || alchemy result will typically have the
  functionality of only one of the components, but the form of the other – e.g. the Hammerhead Pogo Ride, which is
   just a pogo that happens to be hammer-shaped.
 */

abstract class ItemTrait {
    List<String> descriptions = new List<String>();
    ItemTrait(List<String> this.descriptions);

}

//what can this do?
class ItemFunctionTrait extends ItemTrait {
  ItemFunctionTrait(List<String> decriptions) : super(decriptions);
    //TODO eventually has something to do with combat? piercing v slashing etc.
}

//What does it look like?
//TODO eventually tie to images?
class ItemAppearanceTrait extends ItemTrait {
  ItemAppearanceTrait(List<String> decriptions) : super(decriptions);

}

class ItemTraitFactory {
    static ItemAppearanceTrait SWORD;
    static ItemAppearanceTrait HAMMER;
    static ItemAppearanceTrait RIFLE;
    static ItemAppearanceTrait PISTOL;
    static ItemAppearanceTrait BLADE;
    static ItemAppearanceTrait DAGGER;
    static ItemAppearanceTrait SANTA;
    static ItemAppearanceTrait FIST;
    static ItemAppearanceTrait METAL;
    static ItemAppearanceTrait CERAMIC;

    static ItemFunctionTrait SHARP;
    static ItemFunctionTrait BLUNT;
    static ItemFunctionTrait SHOOTY;


    static void init() {
        initAppearances();
        initFunctions();
    }

    static void initAppearances() {
        //it's sharp, it's pointy and it's a sword
        SWORD = new ItemAppearanceTrait(<String>["a sword"]);
        HAMMER = new ItemAppearanceTrait(<String>["a hammer"]);
        RIFLE = new ItemAppearanceTrait(<String>["a rifle"]);
        PISTOL = new ItemAppearanceTrait(<String>["a pistol"]);
        BLADE = new ItemAppearanceTrait(<String>["a blade"]);
        DAGGER = new ItemAppearanceTrait(<String>["a dagger"]);
        SANTA = new ItemAppearanceTrait(<String>["a santa"]);
        FIST = new ItemAppearanceTrait(<String>["a fist"]);
        METAL = new ItemAppearanceTrait(<String>["metal"]);
        CERAMIC = new ItemAppearanceTrait(<String>["ceramic"]);
    }

    static void initFunctions() {
        SHARP = new ItemFunctionTrait(["edged","sharp","pointy","honed","keen","sharpened"]);
        BLUNT = new ItemFunctionTrait(["blunt","bludgeoning","heavy","dull","heavy enough to kill a cat"]);
        SHOOTY = new ItemFunctionTrait(["shooty","ranged","projectile","piercing","loaded","full of ammo", "long-range"]);

    }
}