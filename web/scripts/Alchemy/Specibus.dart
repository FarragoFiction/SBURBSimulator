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

    Specibus(String baseName, ItemTrait this.requiredTrait, List<ItemTrait> traits, [abjDesc]) : super(baseName, traits, abjDesc) {
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
        if(CLAWS == null) CLAWS = new Specibus("Claws", ItemTraitFactory.CLAWS, [ ItemTraitFactory.POINTY,ItemTraitFactory.EDGED, ItemTraitFactory.BONE], "It's claws, dunkass. Monsters and shit have them. And fucking cat trolls.");

        _specibi.clear();
        _specibi.add(new Specibus("Sword", ItemTraitFactory.SWORD, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL, ItemTraitFactory.POINTY], "Can you get more generic than a goddamned sword?"));

        _specibi.add(new Specibus("Hammer", ItemTraitFactory.HAMMER, [ItemTraitFactory.BLUNT, ItemTraitFactory.METAL],"Did you just loot your toolbox or some shit?"));
        _specibi.add(new Specibus("Rifle", ItemTraitFactory.RIFLE, [ ItemTraitFactory.SHOOTY, ItemTraitFactory.METAL],"How the fuck did you get your hands on this?"));
        _specibi.add(new Specibus("Pistol", ItemTraitFactory.PISTOL, [ItemTraitFactory.SHOOTY, ItemTraitFactory.METAL],"Why are guns so underpowered in games like this?"));
        _specibi.add(new Specibus("Shotgun", ItemTraitFactory.SHOTGUN, [ItemTraitFactory.SHOOTY, ItemTraitFactory.METAL], "There is a 98.23423434% chance that  this. Is my boomstick."));
        _specibi.add(new Specibus("Blade", ItemTraitFactory.BLADE, [ ItemTraitFactory.POINTY,ItemTraitFactory.EDGED, ItemTraitFactory.METAL], "So. It's not a sword. And it's not a dagger. How descriptive."));
        _specibi.add(new Specibus("Dagger", ItemTraitFactory.DAGGER, [ ItemTraitFactory.POINTY, ItemTraitFactory.EDGED, ItemTraitFactory.METAL],"For those who can't handle a sword. Or wanna be more stealthy."));
        _specibi.add(new Specibus("Fancysanta", ItemTraitFactory.SANTA, [ ItemTraitFactory.BLUNT, ItemTraitFactory.CERAMIC],"No. Fuck you. I refuse to believe that this is a weapon."));
        _specibi.add(new Specibus("Sickle", ItemTraitFactory.SICKLE, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL],"Do you think it was a pun on sickle cell anemia?"));
        _specibi.add(new Specibus("Chainsaw", ItemTraitFactory.CHAINSAW, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL], "Why are fleshbags so scared of slightly deader flesh bags?"));
        _specibi.add(new Specibus("Fork", ItemTraitFactory.FORK, [ ItemTraitFactory.POINTY, ItemTraitFactory.METAL], "It's a fork. Useful for eating, if that's your thing."));
        _specibi.add(new Specibus("Pigeon", ItemTraitFactory.PIGEON, [ ItemTraitFactory.FEATHER], "Shit. Better get JR. They'll want to see this."));
        _specibi.add(new Specibus("Bowling Ball", ItemTraitFactory.BALL, [ ItemTraitFactory.HEAVY, ItemTraitFactory.STONE, ItemTraitFactory.BLUNT], "Now we're talking. That is some grade A creative use of your storage room right there. "));
        _specibi.add(new Specibus("Dice", ItemTraitFactory.DICE, [ ItemTraitFactory.PLASTIC, ItemTraitFactory.LUCKY],"Wow, I found something dumber than the santa figurines. Luck isn't even a real thing."));
        _specibi.add(new Specibus("Needle", ItemTraitFactory.NEEDLE, [ ItemTraitFactory.METAL, ItemTraitFactory.POINTY], "I guess....you could grow this bigger? Or make it magical or something. If magic weren't a fake thing."));
        _specibi.add(new Specibus("Staff", ItemTraitFactory.STAFF, [ ItemTraitFactory.WOOD, ItemTraitFactory.BLUNT], "Very magey. 7/10."));
        _specibi.add(new Specibus("Whip", ItemTraitFactory.WHIP, [ ItemTraitFactory.RESTRAINING, ItemTraitFactory.CLOTH], "Probably p hard to use."));
        _specibi.add(new Specibus("Bow", ItemTraitFactory.BOW, [ItemTraitFactory.SHOOTY, ItemTraitFactory.STONE, ItemTraitFactory.CLOTH, ItemTraitFactory.POINTY],"Your inferior meat body cannot use this to its maximum potential."));
        _specibi.add(new Specibus("Club", ItemTraitFactory.CLUB, [ ItemTraitFactory.WOOD, ItemTraitFactory.BLUNT],"Easy to use even for weak fleshy muscles."));
        _specibi.add(new Specibus("Broom", ItemTraitFactory.CLUB, [ ItemTraitFactory.WOOD, ItemTraitFactory.CLUB], "God damn Wastes, use normal specibi. "));
        _specibi.add(new Specibus("Book", ItemTraitFactory.BOOK, [ ItemTraitFactory.PAPER, ItemTraitFactory.BLUNT],"You better fucking hope this is either heavy or magic as fuck."));
        _specibi.add(new Specibus("Road Sign", ItemTraitFactory.ROADSIGN, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT],"Okay. There's a story here, I just know it."));
        _specibi.add(new Specibus("Axe", ItemTraitFactory.AXE, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL, ItemTraitFactory.BLUNT],"Legit."));
        _specibi.add(new Specibus("Lance", ItemTraitFactory.LANCE, [ ItemTraitFactory.WOOD, ItemTraitFactory.POINTY],"Good for chest stabs."));
        _specibi.add(new Specibus("Shield", ItemTraitFactory.SHIELD, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT],"I think that if you're using this as a weapon you're even more confused than MOST fleshbags."));
        _specibi.add(new Specibus("Cane", ItemTraitFactory.CANE, [ ItemTraitFactory.WOOD, ItemTraitFactory.BLUNT],"Good for turning disabilities to strengths."));
        _specibi.add(new Specibus("Yo-Yo", ItemTraitFactory.YOYO, [ ItemTraitFactory.PLASTIC, ItemTraitFactory.BLUNT],"It's a yo-yo. Figure it out."));
        _specibi.add(new Specibus("Sling", ItemTraitFactory.SLING, [ ItemTraitFactory.WOOD, ItemTraitFactory.SHOOTY],"What are you gonna use for amo?"));
        _specibi.add(new Specibus("Shuriken", ItemTraitFactory.SHURIKEN, [ ItemTraitFactory.METAL, ItemTraitFactory.EDGED],"So edgey."));
        _specibi.add(new Specibus("Machine Gun", ItemTraitFactory.MACHINEGUN, [ ItemTraitFactory.METAL, ItemTraitFactory.SHOOTY],"No. SERIOUSLY, where the fuck are all you getting these things."));
        _specibi.add(new Specibus("Grenade", ItemTraitFactory.GRENADE, [ ItemTraitFactory.METAL, ItemTraitFactory.EXPLODEY],"Jegus fuck WHY do you HAVE this?"));
        _specibi.add(new Specibus("Ball", ItemTraitFactory.BALL, [ ItemTraitFactory.RUBBER, ItemTraitFactory.BLUNT],"...I refuse to believe you have done a single point of damage with this unupgraded. "));
        _specibi.add(new Specibus("3dent", ItemTraitFactory.TRIDENT, [ ItemTraitFactory.METAL, ItemTraitFactory.POINTY], "Fuck you, just call it a trident."));
        _specibi.add(new Specibus("Card", ItemTraitFactory.CARD, [ ItemTraitFactory.PAPER, ItemTraitFactory.EDGED], "An X-Men fan, I see."));
        _specibi.add(new Specibus("Frying Pan", ItemTraitFactory.FRYINGPAN, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT],"Go with what you know, I guess."));
        _specibi.add(new Specibus("Pillow", ItemTraitFactory.PILLOW, [ ItemTraitFactory.COMFORTABLE, ItemTraitFactory.CLOTH],"So. Do you have to wait for the enemy to fall asleep?"));
        _specibi.add(new Specibus("Chain", ItemTraitFactory.CHAIN, [ ItemTraitFactory.METAL, ItemTraitFactory.RESTRAINING],"This could be metal as fuck."));
        _specibi.add(new Specibus("Wrench", ItemTraitFactory.WRENCH, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT],"Hell yes, engineers!"));
        _specibi.add(new Specibus("Shovel", ItemTraitFactory.SHOVEL, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT],"Dual purpose."));
        _specibi.add(new Specibus("Rolling Pin", ItemTraitFactory.ROLLINGPIN, [ ItemTraitFactory.WOOD, ItemTraitFactory.BLUNT],"There is a 99.9999234% chance cartoons lied to you about this being a weapon."));
        _specibi.add(new Specibus("Puppet", ItemTraitFactory.PUPPET, [ ItemTraitFactory.WOOD, ItemTraitFactory.DOOMED],"Fuck you for picking this."));
        _specibi.add(new Specibus("Razor", ItemTraitFactory.RAZOR, [ ItemTraitFactory.METAL, ItemTraitFactory.EDGED],"So fucking edgey."));
        _specibi.add(new Specibus("Pen", ItemTraitFactory.PEN, [ ItemTraitFactory.METAL, ItemTraitFactory.SMART],"Look. When they say the pen is mightier than the sword, they don't mean in a straight fight."));
        _specibi.add(new Specibus("Bust", ItemTraitFactory.BUST, [ ItemTraitFactory.STONE, ItemTraitFactory.HEAVY],"The meme is strong with this one."));
        _specibi.add(new Specibus("Golf Club", ItemTraitFactory.GOLFCLUB, [ ItemTraitFactory.WOOD, ItemTraitFactory.BLUNT],"Seems legit."));
        _specibi.add(new Specibus("Knife", ItemTraitFactory.KNIFE, [ ItemTraitFactory.METAL, ItemTraitFactory.EDGED],"Don't listen to ABJ, this is NOT a useful weapon."));
        _specibi.add(new Specibus("Scissors", ItemTraitFactory.SCISSOR, [ ItemTraitFactory.METAL, ItemTraitFactory.EDGED],"Either you are a psycho or these are some VERY big fucking scissors."));
        _specibi.add(new Specibus("Safe", ItemTraitFactory.SAFE, [ ItemTraitFactory.METAL, ItemTraitFactory.HEAVY],"Treat it well or it will never reach Vaulthalla."));
        _specibi.add(new Specibus("Stick", ItemTraitFactory.STICK, [ ItemTraitFactory.WOOD, ItemTraitFactory.BLUNT],"Bitches love sticks"));

    }

    static Specibus getRandomSpecibus(Random rand) {
        return rand.pickFrom(_specibi).copy();
    }
}