import "../SBURBSim.dart";

class Specibus extends Item {
    //what is the bareminimum of this kind (usually has same name as kind, like sword).
    ItemTrait requiredTrait;

    Iterable<ItemTrait> get nonrequiredTraits => traits.where((ItemTrait a) => (a != requiredTrait));

    //don't be repetitive for specibus, where they are very limited in what they can say
    ItemTrait getTraitBesides(ItemTrait it) {
        List<ItemTrait> reversed = nonrequiredTraits.toList();
        //pick most recent trait first.
        for(ItemTrait i in reversed.reversed) {
            if(it != i) {
                return i;
            }
        }
        return it;
    }

    Specibus(String baseName, ItemTrait this.requiredTrait, List<ItemTrait> traits) : super(baseName, traits) {
        this.traits.add(requiredTrait);
  }



    //TODO  have a list of components that make this up. (keep track of and vs or?)
    //TODO your specibus can be 2x or 1/2 x kind. unlucky event where it breaks so 1/2 kind

    String get name => "${baseName}kind";

    //it's sharp, it's pointy and it's a sword. word 3 is always the requiredTrait.
    @override
    String randomDescription(Random rand) {
        ItemTrait first = rand.pickFrom(nonrequiredTraits);
        ItemTrait second = rand.pickFrom(nonrequiredTraits);
        if(first == second && nonrequiredTraits.length > 1) {
            second = getTraitBesides(first);
        }
        ItemTrait third = requiredTrait;

        String word1 = rand.pickFrom(first.descriptions);
        String word2 = rand.pickFrom(second.descriptions);
        String word3 = rand.pickFrom(third.descriptions);

        return "It's $word1 and it's $word2 and it's $word3.";
    }


}

class SpecibusFactory {
    static List<Specibus> _specibi = new List<Specibus>();

    static void init() {
        _specibi.clear();
        _specibi.add(new Specibus("Hammer",ItemTraitFactory.HAMMER,[ItemTraitFactory.BLUNT, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Rifle",ItemTraitFactory.RIFLE,[ ItemTraitFactory.SHOOTY, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Pistol",ItemTraitFactory.PISTOL,[ItemTraitFactory.SHOOTY, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Blade",ItemTraitFactory.BLADE,[ ItemTraitFactory.SHARP, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Dagger",ItemTraitFactory.DAGGER,[ ItemTraitFactory.SHARP, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Fancysanta",ItemTraitFactory.SANTA,[ ItemTraitFactory.BLUNT, ItemTraitFactory.CERAMIC]));
        _specibi.add(new Specibus("Fist",ItemTraitFactory.FIST,[ ItemTraitFactory.BLUNT, ItemTraitFactory.METAL]));
    }

    static Specibus getRandomSpecibus(Random rand) {
        return rand.pickFrom(_specibi);
    }
}