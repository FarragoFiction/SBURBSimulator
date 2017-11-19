import "Item.dart";
import "Trait.dart";
import "../random.dart";


class Specibus extends Item {
    //what is the bareminimum of this kind (usually has same name as kind, like sword).
    ItemTrait requiredTrait;

    //rank is simple placeholder that means "how much do attacks get multiplied by"
    //expect each component to add like, .1 to the rank or some shit.
    //TODO make sure a valid component for a variety of memes, like jr body pillow.


    Iterable<ItemTrait> get nonrequiredTraits => traits.where((ItemTrait a) => (a != requiredTrait));

    Specibus copy() {
        return new Specibus(baseName, requiredTrait, nonrequiredTraits.toList());
    }

    //don't be repetitive for specibus, where they are very limited in what they can say
    ItemTrait getTraitBesides(ItemTrait it) {
        List<ItemTrait> reversed = nonrequiredTraits.toList();
        //pick most recent trait first.
        for (ItemTrait i in reversed.reversed) {
            if (it != i) {
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
        if (first == second && nonrequiredTraits.length > 1) {
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
    static Specibus CLAWS;

    static void init() {
        if(CLAWS == null) CLAWS = new Specibus("Claws", ItemTraitFactory.CLAWS, [ ItemTraitFactory.POINTY,ItemTraitFactory.EDGED, ItemTraitFactory.BONE]);

        _specibi.clear();
        _specibi.add(new Specibus("Sword", ItemTraitFactory.SWORD, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL, ItemTraitFactory.POINTY]));

        _specibi.add(new Specibus("Hammer", ItemTraitFactory.HAMMER, [ItemTraitFactory.BLUNT, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Rifle", ItemTraitFactory.RIFLE, [ ItemTraitFactory.SHOOTY, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Pistol", ItemTraitFactory.PISTOL, [ItemTraitFactory.SHOOTY, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Blade", ItemTraitFactory.BLADE, [ ItemTraitFactory.POINTY,ItemTraitFactory.EDGED, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Dagger", ItemTraitFactory.DAGGER, [ ItemTraitFactory.POINTY, ItemTraitFactory.EDGED, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Fancysanta", ItemTraitFactory.SANTA, [ ItemTraitFactory.BLUNT, ItemTraitFactory.CERAMIC]));
        _specibi.add(new Specibus("Sickle", ItemTraitFactory.SICKLE, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Chainsaw", ItemTraitFactory.CHAINSAW, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Fork", ItemTraitFactory.FORK, [ ItemTraitFactory.POINTY, ItemTraitFactory.METAL]));
        _specibi.add(new Specibus("Dice", ItemTraitFactory.DICE, [ ItemTraitFactory.PLASTIC, ItemTraitFactory.LUCKY]));
        _specibi.add(new Specibus("Needle", ItemTraitFactory.NEEDLE, [ ItemTraitFactory.METAL, ItemTraitFactory.POINTY]));
        _specibi.add(new Specibus("Staff", ItemTraitFactory.STAFF, [ ItemTraitFactory.WOOD, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Whip", ItemTraitFactory.WHIP, [ ItemTraitFactory.RESTRAINING, ItemTraitFactory.CLOTH]));
        _specibi.add(new Specibus("Bow", ItemTraitFactory.BOW, [ItemTraitFactory.SHOOTY, ItemTraitFactory.STONE, ItemTraitFactory.CLOTH, ItemTraitFactory.POINTY]));
        _specibi.add(new Specibus("Club", ItemTraitFactory.CLUB, [ ItemTraitFactory.WOOD, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Broom", ItemTraitFactory.CLUB, [ ItemTraitFactory.WOOD, ItemTraitFactory.CLUB]));
        _specibi.add(new Specibus("Book", ItemTraitFactory.BOOK, [ ItemTraitFactory.PAPER, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Road Sign", ItemTraitFactory.ROADSIGN, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Axe", ItemTraitFactory.AXE, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Lance", ItemTraitFactory.LANCE, [ ItemTraitFactory.WOOD, ItemTraitFactory.POINTY]));
        _specibi.add(new Specibus("Shield", ItemTraitFactory.SHIELD, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Cane", ItemTraitFactory.CANE, [ ItemTraitFactory.WOOD, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Yo-Yo", ItemTraitFactory.YOYO, [ ItemTraitFactory.PLASTIC, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Sling", ItemTraitFactory.SLING, [ ItemTraitFactory.WOOD, ItemTraitFactory.SHOOTY]));
        _specibi.add(new Specibus("Shuriken", ItemTraitFactory.SHURIKEN, [ ItemTraitFactory.METAL, ItemTraitFactory.EDGED]));
        _specibi.add(new Specibus("Machine Gun", ItemTraitFactory.MACHINEGUN, [ ItemTraitFactory.METAL, ItemTraitFactory.SHOOTY]));
        _specibi.add(new Specibus("Grenade", ItemTraitFactory.GRENADE, [ ItemTraitFactory.METAL, ItemTraitFactory.EXPLODEY]));
        _specibi.add(new Specibus("Ball", ItemTraitFactory.BALL, [ ItemTraitFactory.RUBBER, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("3dent", ItemTraitFactory.TRIDENT, [ ItemTraitFactory.METAL, ItemTraitFactory.POINTY]));
        _specibi.add(new Specibus("Card", ItemTraitFactory.CARD, [ ItemTraitFactory.PAPER, ItemTraitFactory.EDGED]));
        _specibi.add(new Specibus("Frying Pan", ItemTraitFactory.FRYINGPAN, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Pillow", ItemTraitFactory.PILLOW, [ ItemTraitFactory.COMFORTABLE, ItemTraitFactory.CLOTH]));
        _specibi.add(new Specibus("Chain", ItemTraitFactory.CHAIN, [ ItemTraitFactory.METAL, ItemTraitFactory.RESTRAINING]));
        _specibi.add(new Specibus("Wrench", ItemTraitFactory.WRENCH, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Shovel", ItemTraitFactory.SHOVEL, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Rolling Pin", ItemTraitFactory.ROLLINGPIN, [ ItemTraitFactory.WOOD, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Puppet", ItemTraitFactory.PUPPET, [ ItemTraitFactory.WOOD, ItemTraitFactory.DOOMED]));
        _specibi.add(new Specibus("Razor", ItemTraitFactory.RAZOR, [ ItemTraitFactory.METAL, ItemTraitFactory.EDGED]));
        _specibi.add(new Specibus("Pen", ItemTraitFactory.PEN, [ ItemTraitFactory.METAL, ItemTraitFactory.SMART]));
        _specibi.add(new Specibus("Bust", ItemTraitFactory.BUST, [ ItemTraitFactory.STONE, ItemTraitFactory.HEAVY]));
        _specibi.add(new Specibus("Golf Club", ItemTraitFactory.GOLFCLUB, [ ItemTraitFactory.WOOD, ItemTraitFactory.BLUNT]));
        _specibi.add(new Specibus("Knife", ItemTraitFactory.KNIFE, [ ItemTraitFactory.METAL, ItemTraitFactory.EDGED]));
        _specibi.add(new Specibus("Scissors", ItemTraitFactory.SCISSOR, [ ItemTraitFactory.METAL, ItemTraitFactory.EDGED]));
        _specibi.add(new Specibus("Safe", ItemTraitFactory.SAFE, [ ItemTraitFactory.METAL, ItemTraitFactory.HEAVY]));

    }

    static Specibus getRandomSpecibus(Random rand) {
        return rand.pickFrom(_specibi).copy();
    }
}