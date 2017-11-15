/*
http://mspaintadventures.wikia.com/wiki/Alchemiter

Appropriately for AND combining, an && alchemy result will often demonstrate the functionality of both components
 – e.g. Dave's iShades can be a phone and a rad pair of shades – while an || alchemy result will typically have the
  functionality of only one of the components, but the form of the other – e.g. the Hammerhead Pogo Ride, which is
   just a pogo that happens to be hammer-shaped.
 */

abstract class ItemTrait {
    List<String> descriptions = new List<String>();
    String name;
    ItemTrait(String this.name, List<String> this.descriptions);

}

//what can this do?
class ItemFunctionTrait extends ItemTrait {
  ItemFunctionTrait(String name, List<String> decriptions) : super(name, decriptions);
    //TODO eventually has something to do with combat? piercing v slashing etc.
}

//What does it look like?
//TODO eventually tie to images?
class ItemAppearanceTrait extends ItemTrait {
  ItemAppearanceTrait(String name, List<String> decriptions) : super(name, decriptions);

}

class ItemTraitFactory {
    static ItemAppearanceTrait SWORDAPPEARANCE;
    static ItemAppearanceTrait HAMMERAPPEARANCE;
    static ItemAppearanceTrait RIFLEAPPEARANCE;
    static ItemAppearanceTrait PISTOLAPPEARANCE;
    static ItemAppearanceTrait BLADEAPPEARANCE;
    static ItemAppearanceTrait DAGGERAPPEARANCE;
    static ItemAppearanceTrait SANTAAPPEARANCE;
    static ItemAppearanceTrait FISTAPPEARANCE;

    static ItemFunctionTrait SHARP;
    static ItemFunctionTrait BLUNT;
    static ItemFunctionTrait SHOOTY;


    static void init() {
        initAppearances();
        initFunctions();
    }

    static void initAppearances() {
        //it's sharp, it's pointy and it's a sword
        SWORDAPPEARANCE = new ItemAppearanceTrait("sword",["a sword."]);
        HAMMERAPPEARANCE = new ItemAppearanceTrait("sword",["a hammer."]);
        RIFLEAPPEARANCE = new ItemAppearanceTrait("sword",["a rifle."]);
        PISTOLAPPEARANCE = new ItemAppearanceTrait("sword",["a pistol."]);
        BLADEAPPEARANCE = new ItemAppearanceTrait("sword",["a blade."]);
        DAGGERAPPEARANCE = new ItemAppearanceTrait("sword",["a dagger."]);
        SANTAAPPEARANCE = new ItemAppearanceTrait("sword",["a santa."]);
        FISTAPPEARANCE = new ItemAppearanceTrait("sword",["a fist."]);
    }

    static void initFunctions() {
        SHARP = new ItemFunctionTrait("sharp",["edged","sharp","pointy","honed","keen","sharpened"]);
        BLUNT = new ItemFunctionTrait("blunt",["blunt","bludgeoning","heavy","dull","heavy enough to kill a cat"]);
        SHOOTY = new ItemFunctionTrait("shooty",["shooty","ranged","projectile","piercing","loaded","full of ammo"]);

    }
}