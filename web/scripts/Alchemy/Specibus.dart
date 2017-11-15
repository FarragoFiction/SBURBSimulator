import "../SBURBSim.dart";

class Specibus extends Item {
  Specibus(String baseName, List<ItemTrait> traits) : super(baseName, traits);



    //TODO have a list of function traits and appearance traits (are appearance traits just kind?).
    //TODO  have a list of components that make this up. (keep track of and vs or?)
    //TODO your specibus can be 2x or 1/2 x kind. unlucky event where it breaks so 1/2 kind

    String get name => "${baseName}kind";


}

class SpecibusFactory {
    static List<Specibus> _specibi = new List<Specibus>();

    static void init() {
        _specibi.clear();
        _specibi.add(new Specibus("Hammer",[ItemTraitFactory.HAMMERAPPEARANCE, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Rifle",[ItemTraitFactory.RIFLEAPPEARANCE, ItemTraitFactory.SHOOTY]));
        _specibi.add(new Specibus("Pistol",[ItemTraitFactory.PISTOLAPPEARANCE, ItemTraitFactory.SHOOTY]));
        _specibi.add(new Specibus("Blade",[ItemTraitFactory.BLADEAPPEARANCE, ItemTraitFactory.SHARP]));
        _specibi.add(new Specibus("Dagger",[ItemTraitFactory.DAGGERAPPEARANCE, ItemTraitFactory.SHARP]));
        _specibi.add(new Specibus("Fancysanta",[ItemTraitFactory.SANTAAPPEARANCE, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Fist",[ItemTraitFactory.FISTAPPEARANCE, ItemTraitFactory.BLUNT]));
    }

    static Specibus getRandomSpecibus(Random rand) {
        return rand.pickFrom(_specibi);
    }
}