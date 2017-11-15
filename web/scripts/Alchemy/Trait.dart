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
    ItemTrait(List<String> this.descriptions, this.rank);

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
    static ItemAppearanceTrait SWORD;
    static ItemAppearanceTrait HAMMER;
    static ItemAppearanceTrait RIFLE;
    static ItemAppearanceTrait PISTOL;
    static ItemAppearanceTrait BLADE;
    static ItemAppearanceTrait DAGGER;
    static ItemAppearanceTrait SANTA;
    static ItemAppearanceTrait FIST;
    static ItemAppearanceTrait METAL;
    static ItemAppearanceTrait CLAWS;
    static ItemAppearanceTrait CERAMIC;
    static ItemAppearanceTrait BONE;

    static ItemFunctionTrait SHARP;
    static ItemFunctionTrait BLUNT;
    static ItemFunctionTrait SHOOTY;


    static void init() {
        initAppearances();
        initFunctions();
    }

    static void initAppearances() {
        //it's sharp, it's pointy and it's a sword
        SWORD = new ItemAppearanceTrait(<String>["a sword"],0.4);
        HAMMER = new ItemAppearanceTrait(<String>["a hammer"],0.4);
        RIFLE = new ItemAppearanceTrait(<String>["a rifle"],0.4);
        PISTOL = new ItemAppearanceTrait(<String>["a pistol"],0.4);
        BLADE = new ItemAppearanceTrait(<String>["a blade"],0.4);
        DAGGER = new ItemAppearanceTrait(<String>["a dagger"],0.4);
        SANTA = new ItemAppearanceTrait(<String>["a santa"],0.4);
        FIST = new ItemAppearanceTrait(<String>["a fist"],0.4);
        CLAWS = new ItemAppearanceTrait(<String>["claws"],0.4);

        METAL = new ItemAppearanceTrait(<String>["metal"],0.3);
        CERAMIC = new ItemAppearanceTrait(<String>["ceramic"],0.3);
        BONE = new ItemAppearanceTrait(<String>["bone"],0.3);
    }

    static void initFunctions() {
        SHARP = new ItemFunctionTrait(["edged","sharp","pointy","honed","keen","sharpened"],0.3);
        BLUNT = new ItemFunctionTrait(["blunt","bludgeoning","heavy","dull","heavy enough to kill a cat"],0.3);
        SHOOTY = new ItemFunctionTrait(["shooty","ranged","projectile","piercing","loaded","full of ammo", "long-range"],0.3);

    }
}