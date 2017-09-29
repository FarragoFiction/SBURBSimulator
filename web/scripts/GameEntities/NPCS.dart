import "../SBURBSim.dart";

//most of these are just so I can say "is this a type of npc" and not any real functionality
//might be the wrong way to do this. can refactor later. they will have more functionality as time goes on, tho.

class NPC extends GameEntity {
    NPC(String name, Session session) : super(name, session);

}

//carapaces are the only things that can be crowned and have it give anything but fraymotifs.
class Carapace extends NPC {
    Carapace(String name, Session session) : super(name, session);

    @override
    StatHolder createHolder() => new CarapaceStatHolder(this);
}

//srites are definitely going to behave differntly soon
class Sprite extends NPC {

    //TODO make sure when prototyped all your specific shit gets added.
    Sprite(String name, Session session) : super(name, session);

    @override
    Sprite clone() {
        Sprite clone = new Sprite(name, session);
        copyStatsTo(clone);
        return clone;
    }
}

class Underling extends NPC {
    Underling(String name, Session session) : super(name, session);
}

//naknaknaknaknaknak my comments are talking to me!
class Consort extends NPC {
    /// what are these consorts called?
    String name;
    ///what sound do these consorts make?
    String sound;
    Consort(String name, Session session) : super(name, session);
    Consort.withSound(String name, Session session,  this.sound): super(name, session);
}

//denizens are spawned with innate knowledge of a personal fraymotif.
//TODO eventually put this logic here instead of in player, and have mechanism for
//creating a denizen live here in a static method.
class Denizen extends NPC {
    Denizen(String name, Session session) : super(name, session);

    @override
    Denizen clone() {
        Denizen clone = new Denizen(name, session);
        copyStatsTo(clone);
        return clone;
    }

}

//unlike a regular denizen, will fucking kill your ass.
class HardDenizen extends Denizen {
    HardDenizen(String name, Session session) : super(name, session);

    @override
    HardDenizen clone() {
        HardDenizen clone = new HardDenizen(name, session);
        copyStatsTo(clone);
        return clone;
    }

}

class DenizenMinion extends NPC {
    DenizenMinion(String name, Session session)
        : super(name, session);


    @override
    DenizenMinion clone() {
        DenizenMinion clone = new DenizenMinion(name, session);
        copyStatsTo(clone);
        return clone;
    }
}

class PotentialSprite extends NPC {
    @override
    String helpPhrase = "provides the requisite amount of gigglesnort hideytalk to be juuuust barely helpful. ";
    @override
    num helpfulness = 0;
    @override
    bool armless = false;
    @override
    bool disaster = false;
    @override
    bool lusus = false; //HAVE to be vars or can't inherit through prototyping.
    @override
    bool player = false;
    @override
    bool illegal = false; //maybe AR won't help players with ILLEGAL sprites?
    PotentialSprite(String name, Session session) : super(name, session);

    static List<GameEntity> disastor_objects;
    static List<GameEntity> fortune_objects;
    static List<GameEntity> lusus_objects;
    static List<GameEntity> sea_lusus_objects;
    static List<GameEntity> prototyping_objects;
    static Session defaultSession; //needed so we don't do infinite loop since a session tries to initialize sprites which try to maek a blank session.

    static initializeAShitTonOfPotentialSprites(Session s) {
        if(PotentialSprite.prototyping_objects != null) return; //dont' reinit.
        defaultSession = s;

        print("initializing potential sprites");
        initializeAShitTonOfGenericSprites();
        initializeAShitTonOfFortuneSprites();
        initializeAShitTonOfDisastorSprites();
        initializeAShotTonOfLususSprites();
       // print("prototyping objects is ${PotentialSprite.prototyping_objects}");
        prototyping_objects.addAll(PotentialSprite.disastor_objects);
        prototyping_objects.addAll(PotentialSprite.fortune_objects);
        prototyping_objects.addAll(PotentialSprite.lusus_objects);
        prototyping_objects.addAll(PotentialSprite.sea_lusus_objects);
        //yes, a human absolutely could prototype some troll's lusus. that is a thing that is true.
    }

    static initializeAShitTonOfGenericSprites() {
    //regular
        PotentialSprite.prototyping_objects = <GameEntity>[
            new PotentialSprite(Zalgo.generate("Buggy As Fuck Retro Game"), null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..corrupted = true //no stats, just corrupted. maybe a fraymotif later.
                ..helpPhrase =
                    "provides painful, painful sound file malfunctions, why is this even a thing? ",

            new PotentialSprite("Robot", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 100, Stats.HEALTH: 100, Stats.CURRENT_HEALTH: 100, Stats.FREE_WILL: 100})
                ..helpfulness = 1
                ..helpPhrase =
                    "is <b>more</b> useful than another player. How could a mere human measure up to the awesome logical capabilities of a machine? "
            ,

            new PotentialSprite("Golfer", null)
                ..helpfulness = 1
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MIN_LUCK: 20, Stats.MAX_LUCK: 20})
                ..helpPhrase =
                    "provides surprisingly helpful advice, even if they do insist on calling all enemies ‘bogeys’. ",

            new PotentialSprite("Dutton", null)
                ..helpfulness = 1
                ..helpPhrase = "provides transcendent wisdom. "
                ..stats.setMap(<Stat,num>{Stats.POWER: 10, Stats.HEALTH: 10, Stats.CURRENT_HEALTH: 10, Stats.FREE_WILL: 50, Stats.MOBILITY: 50, Stats.MIN_LUCK: 50, Stats.MAX_LUCK: 50})
                ..fraymotifs.add(new Fraymotif("Duttobliteration", 2)
                    ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 2, true))
                    ..desc =
                        " The ENEMY is obliterated. Probably. A watermark of Charles Dutton appears, stage right. "),

            new PotentialSprite("Game Bro", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "provides rad as fuck tips and tricks for beating SBURB and getting mad snacks, yo. 5 out of 5 hats. ",

//in joke, lol, google always reports that sessions are crashed. google is a horror terror (see tumblr)
            new PotentialSprite(Zalgo.generate("Google"), null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..corrupted = true
                ..helpPhrase =
                    "sure knows a lot about everything, but why does it only seem to return results about crashing SBURB?",

            new PotentialSprite("Game Grl", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "provides rad as fuck tips and tricks for beating SBURB and getting mad snacks, yo, but, like, while also being a GIRL? *record scratch*  5 out of 5 lady hats. ",

            new PotentialSprite("Paperclip", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "says: 'It looks like you're trying to play a cosmic game where you breed frogs to create a universe. Would you like me to'-No. 'Would you like me to'-No! 'It looks like you're'-shut up!!! This is not helpful.",

            new PotentialSprite("WebComicCreator", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "refuses to explain anything about SBURB to you, prefering to let you speculate wildly while cackling to himself."
                ..fraymotifs.add(new Fraymotif("Kill ALL The Characters", 2)
                    ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 3, true))
                    ..desc =
                        " All enemies are obliterated. Probably. A watermark of Andrew Hussie appears, stage right. "),

            new PotentialSprite("KidRock", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "does absolutly nothing but sing repetitive, late 90's rock to you."
                ..fraymotifs.add(new Fraymotif("BANG DA DANG DIGGY DIGGY", 2)
                    ..effects.add(
                        new FraymotifEffect(Stats.POWER, 3, true)) //buffs party and hurts enemies
                    ..effects.add(new FraymotifEffect(Stats.POWER, 1, false))
                    ..desc =
                        " OWNER plays a 90s hit classic, and you can't help but tap your feet. Somehow, this doesn't feel like the true version of this attack."),

            new PotentialSprite("Sleuth", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.RELATIONSHIPS: 100})
                ..helpfulness = -1
                ..helpPhrase =
                    "suggests the player just input a password to skip all their land's weird puzzle shit. This is not actually a thing you can do."
                ..fraymotifs.add(new Fraymotif("Sepulchritude", 2)
                    ..effects.add(new FraymotifEffect(Stats.RELATIONSHIPS, 1, true))
                    ..desc =
                        " The OWNER decides not to bring that noise just yet. They just heal the party instead. ")
                ..fraymotifs.add(new Fraymotif("Sepulchritude", 2)
                    ..effects.add(new FraymotifEffect(Stats.RELATIONSHIPS, 1, true))
                    ..desc =
                        " THE OWNER just don't have the offensive gravitas for that attack. They just heal the party instead. ")
                ..fraymotifs.add(new Fraymotif("Sepulchritude", 2)
                    ..effects.add(new FraymotifEffect(Stats.RELATIONSHIPS, 3, true))
                    ..desc =
                        " The OWNER finally fucking unleashes their Ultimate Attack. The resplendent light of divine PULCHRITUDE consumes all enemies. ")
                ..fraymotifs.add(new Fraymotif("Sepulchritude", 2)
                    ..effects.add(new FraymotifEffect(Stats.RELATIONSHIPS, 1, true))
                    ..desc =
                        " No, not yet! The OWNER refuses to use Sepulchritude. They just heal the party instead. "),

            new PotentialSprite("Nic Cage", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "demonstrates that when it comes to solving bullshit riddles to get National *cough* I mean SBURBian treasure, he is simply the best there is. ",

            new PotentialSprite("Praying Mantis", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MAX_LUCK: 20})
            ,

            new PotentialSprite("Shitty Comic Character", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MOBILITY: 50})
                ..helpfulness = -1
                ..helpPhrase =
                    " is the STAR. It is them. You don't think they have ever once attempted to even talk about the game. How HIGH did you have to BE to prototype this glitchy piece of shit? "
                ..fraymotifs.add(new Fraymotif("FUCK IM FALLING DOWN ALL THESE STAIRS", 3)
                    ..effects
                        .add(new FraymotifEffect(Stats.MOBILITY, 1, false)) //buff to mobility bro
                    ..desc = " It keeps hapening. ")
                ..fraymotifs
                    .add(new Fraymotif("FUCK IM FALLING DOWN ALL THESE STAIRS", 3)
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 1, false))
                    ..desc = " I warned you about stairs bro!!! ")
                ..fraymotifs
                    .add(new Fraymotif("FUCK IM FALLING DOWN ALL THESE STAIRS", 3)
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 1, false))
                    ..desc = " I told you dog! "),

            new PotentialSprite("Doctor", null) //healing fraymotif
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "is pretty much as useful as another player. No cagey riddles, just straight answers on how to finish the quests. ",

            new PotentialSprite("Gerbil", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

            new PotentialSprite("Chinchilla", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

            new PotentialSprite("Rabbit", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MAX_LUCK: 100})
                ..helpPhrase =
                    "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

            new PotentialSprite("Tissue", null)
                ..helpfulness = -1
                ..helpPhrase = "is useless in every possible way. ",

            new PotentialSprite("Librarian", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "Is pretty much as useful as another player. No cagey riddles, just straight answers on where the book on how to finish the quest is, and could you please keep it down? ",

            new PotentialSprite("Pit Bull", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 50}),

            new PotentialSprite("Butler", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.SANITY: 50}) //he will serve you like a man on butler island
                ..helpfulness = 1
                ..helpPhrase =
                    "is serving their player like a dude on butlersprite island. "
            ,

            new PotentialSprite("Sloth", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MOBILITY: -50})
                ..helpPhrase = "provides. Slow. But. Useful. Advice.",

            new PotentialSprite("Cowboy", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "provides useful advice, even if they do insist on calling literally everyone 'pardner.' ",

            new PotentialSprite("Pomeranian", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 1}) //pomeranians aren't actually very good at fights.  (trust me, i know)
                ..helpfulness = -1
                ..helpPhrase =
                    "unhelpfully insists that every rock is probably a boss fight (it isn’t). ",

            new PotentialSprite("Chihuahua", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 1}) //i'm extrapolating here, but I imagine Chihuahua's aren't very good at fights, either.
                ..helpfulness = -1
                ..helpPhrase =
                    "unhelpfully insists that every rock is probably a boss fight (it isn’t). ",

            new PotentialSprite("Pony", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.SANITY: -1000})
                ..helpfulness = -1
            //ponyPals taught me that ponys are just flipping their shit, like, 100% of the time.
                ..helpPhrase =
                    "is constantly flipping their fucking shit instead of being useful in any way shape or form, as ponies are known for. ",

            new PotentialSprite("Horse", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.SANITY: -100})
                ..helpfulness = -1
            //probably flip out less than ponys???
                ..helpPhrase =
                    "is constantly flipping their fucking shit instead of being useful in any way shape or form, as horses are known for. ",

            new PotentialSprite("Internet Troll", null) //needs to have a fraymotif called "u mad, bro" and "butt hurt"
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.SANITY: 1000})
                ..helpfulness = -1
                ..helpPhrase = "actively does its best to hinder their efforts. ",

            new PotentialSprite("Mosquito", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "is a complete dick, buzzing and fussing and biting. What's its deal? ",

            new PotentialSprite("Fly", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "is a complete dick, buzzing and fussing and biting. What's its deal? ",

            new PotentialSprite(Zalgo.generate("GitHub"), null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..corrupted = true
                ..helpPhrase =
                    "Githubsprite tells all about the latest changes to sburbs code. ",

            new PotentialSprite("Cow", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30}), //cows kill more people a year than sharks.

            new PotentialSprite("Bird", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MOBILITY: 50})
                ..helpPhrase =
                    "provides sort of helpful advice when not grabbing random objects to make nests. ",

            new PotentialSprite("Bug", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpPhrase =
                    "provides the requisite amount of buzzybuz zuzytalk to be juuuust barely helpful. ",

            new PotentialSprite("Llama", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Penguin", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Husky", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
                ..helpPhrase =
                    "alternates between loud, insistent barks and long, eloquent monologues on the deeper meaning behind each and every fragment of the game. ",

            new PotentialSprite("Cat", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MIN_LUCK: -20, Stats.MAX_LUCK: 20})
                ..helpPhrase =
                    "Is kind of helpful? Maybe? You can't tell if it loves their player or hates them. ",

            new PotentialSprite("Dog", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
                ..helpPhrase =
                    "alternates between loud, insistent barks and long, eloquent monologues on the deeper meaning behind each and every fragment of the game. ",

            new PotentialSprite("Pigeon", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 0.5, Stats.FREE_WILL: -40}) //pigeons are not famous for their combat prowess. I bet even a pomeranian could beat one up.
            ,

            new PotentialSprite("Octopus", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.MOBILITY: 80})
            , //so many legs! more legs is more faster!!!

            new PotentialSprite("Fish", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..armless = true,

            new PotentialSprite("Kitten", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpPhrase =
                    "is kind of helpful? Maybe? You can't tell if it loves their player or hates them. ",

            new PotentialSprite("Worm", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..armless = true,

            new PotentialSprite("Bear", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 50}),

            new PotentialSprite("Goat", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Rat", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Raccoon", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "demonstrates that SBURB basically hides quest items in the same places humans would throw away their garbage. ",

            new PotentialSprite("Crow", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.FREE_WILL: 50}) //have you ever tried to convince a crow not to do something? not gonna happen.
                ..helpPhrase =
                    "provides sort of helpful advice when not grabbing random objects to make nests. ",

            new PotentialSprite("Chicken", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.FREE_WILL: -50}), //mike the headless chicken has convinced me that chickens don't really need brains. god that takes me back.

            new PotentialSprite("Duck", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Sparrow", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20}),

            new PotentialSprite("Fancy Santa", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase = "goes hohohohohohohohoho. ",

            new PotentialSprite("Politician", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = -1
                ..helpPhrase =
                    "offers a blueprint for an ECONONY that works for everyone. That would've been more useful before the earth was destroyed.... ",

            new PotentialSprite("Tiger", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
                ..helpPhrase =
                    "Provides just enough pants-shitingly terrifying growly-roar meow talk to be useful. ",

            new PotentialSprite("Sugar Glider", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpPhrase =
                    "remains physically adorable and mentally idiotic. Gigglysnort hideytalk ahoy. ",

            new PotentialSprite("Rapper", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..helpfulness = 1
                ..helpPhrase =
                    "provides surprisingly helpful advice, even if it does insist on some frankly antiquated slang and rhymes. I mean, civilization is dead, there isn’t exactly a police left to fuck. ",

            new PotentialSprite("Kangaroo", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MOBILITY: 30}),

            new PotentialSprite("Stoner", null)
            //blaze it
                ..stats.setMap(<Stat,num>{Stats.POWER: 42.0, Stats.MIN_LUCK: -42.0, Stats.MAX_LUCK: 42.0})
                ..helpfulness = 1
                ..helpPhrase =
                    "is pretty much as useful as another player, assuming that player was higher then a fucking kite. ",
        ];


    }

    static initializeAShitTonOfFortuneSprites() {
//fortune
        PotentialSprite.fortune_objects = <GameEntity>[
            new PotentialSprite("Frog", null)
                ..illegal = true
                ..stats.setMap(<Stat,num>{Stats.MOBILITY: 100, Stats.POWER: 10})
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Lizard", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..illegal = true
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Salamander", null)
                ..illegal = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 20})
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Iguana", null)
                ..illegal = true
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Crocodile", null)
                ..illegal = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Turtle", null)
                ..illegal = true
                ..stats.setMap(<Stat,num>{Stats.MOBILITY: -100, Stats.POWER: 20})
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Alligator", null)
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.MOBILITY: 100, Stats.POWER: 50})
                ..illegal = true
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Snake", null) //poison fraymotif
                ..armless = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.MOBILITY: 100, Stats.POWER: 10})
                ..illegal = true
                ..helpPhrase =
                    "providessss the requisssssite amount of gigglessssssnort hideytalk to be jusssssst barely helpful. AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Axolotl", null) //apparently real ones are good at regeneration?
                ..stats.setMap(<Stat,num>{Stats.POWER: 20, Stats.HEALTH: 50, Stats.CURRENT_HEALTH: 50})
                ..illegal = true
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
            new PotentialSprite("Newt", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 20})
                ..illegal = true
                ..helpPhrase =
                    "provides the requisite amount of gigglesnort  hideytalk to be fairly useful, AND the underlings seem to go after it first! Bonus! ",
        ];



    }

    static initializeAShitTonOfDisastorSprites() {
        PotentialSprite.disastor_objects = <GameEntity>[
            new PotentialSprite(
                "First Guardian", null) //also a custom fraymotif.
                ..disaster = true
                ..stats.setMap(<Stat,num>{
                    Stats.HEALTH: 1000,
                    Stats.CURRENT_HEALTH: 1000,
                    Stats.MOBILITY: 500,
                    Stats.POWER: 250
                })
                ..helpPhrase =
                    "is fairly helpful with the teleporting and all, but when it speaks- Wow. No. That is not ok. "
                ..fraymotifs.add(new Fraymotif("Atomic Teleport Spam", 3)
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 0, false))
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 2, true))
                    ..desc =
                        " The OWNER shimers with radioactive stars, and then teleports behind the ENEMY, sneak-attacking them. "),
            new PotentialSprite(Zalgo.generate("Horror Terror"), null) //vast glub
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.FREE_WILL: 250, Stats.POWER: 150})
                ..disaster = true
                ..corrupted = true
                ..helpPhrase =
                    "... Oh god. What is going on. Why does just listening to it make your ears bleed!? "
                ..fraymotifs.add(new Fraymotif("Vast Glub", 3)
                    ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 3, true))
                    ..desc =
                        " A galaxy spanning glub damages everyone. The only hope of survival is to spread the damage across so many enemies that everyone only takes a manageable amount. "),
            new PotentialSprite(
                Zalgo.generate("Speaker of the Furthest Ring"), null) //vast glub
                ..disaster = true
                ..corrupted = true
                ..stats.setMap(<Stat,num>{
                    Stats.HEALTH: 1000,
                    Stats.CURRENT_HEALTH: 1000,
                    Stats.FREE_WILL: 250,
                    Stats.POWER: 250
                })
                ..helpPhrase =
                    "whispers madness humankind was not meant to know. Its words are painful, hateful, yet… tempting. It speaks of flames and void, screams and gods. "
                ..fraymotifs.add(new Fraymotif("Vast Glub", 3)
                    ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 3, true))
                    ..desc =
                        " A galaxy spanning glub damages everyone. The only hope of survival is to spread the damage across so many enemies that everyone only takes a manageable amount. "),
            new PotentialSprite(
                "Clown", null) //custom fraymotif: can' keep down the clown (heal).
                ..disaster = true
                ..stats.setMap(<Stat,num>{
                    Stats.HEALTH: 1000,
                    Stats.CURRENT_HEALTH: 1000,
                    Stats.MIN_LUCK: -250,
                    Stats.MAX_LUCK: 250,
                    Stats.POWER: 100
                })
                ..helpfulness = -1
                ..helpPhrase = "goes hehehehehehehehehehehehehehehehehehehehehehehehehehe. "
                ..fraymotifs.add(new Fraymotif("Can't Keep Down The Clown", 3)
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 0, false))
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 0, true))
                    ..desc =
                        " You are pretty sure it is impossible for Clowns to die. "),
            new PotentialSprite("Puppet", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{
                    Stats.HEALTH: 500,
                    Stats.CURRENT_HEALTH: 500,
                    Stats.FREE_WILL: 250,
                    Stats.MOBILITY: 250,
                    Stats.MIN_LUCK: -250,
                    Stats.MAX_LUCK: 250,
                    Stats.SANITY: 250,
                    Stats.POWER: 100
                })
                ..helpPhrase =
                    "is the most unhelpful piece of shit in the world. Oh my god, just once. Please, just shut up. "
                ..helpfulness = -1
                ..fraymotifs.add(new Fraymotif("Hee Hee Hee Hoo!", 3)
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 3, false))
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 3, true))
                    ..desc = " Oh god! Shut up! Just once! Please shut up! "),
            new PotentialSprite("Xenomorph", null) //custom fraymotif: acid blood
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.MOBILITY: 250, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("Spawning", 3)
                    ..effects.add(new FraymotifEffect(Stats.ALCHEMY, 3, true))
                    ..desc =
                        " Oh god. Where are all those baby monsters coming from. They are everywhere! Fuck! How are they so good at biting??? "),
            new PotentialSprite(
                "Deadpool", null) //TODO: eventually dead pool gives you one gnosis rank
                ..disaster = true
                ..stats.setMap(<Stat,num>{
                    Stats.HEALTH: 500,
                    Stats.CURRENT_HEALTH: 500,
                    Stats.MOBILITY: 250,
                    Stats.MIN_LUCK: -250,
                    Stats.MAX_LUCK: 250,
                    Stats.POWER: 100
                })
                ..helpfulness = 1
                ..helpPhrase =
                    "demonstrates that when it comes to providing fourth wall breaking advice to getting through quests and killing baddies, he is pretty much the best there is. "
                ..fraymotifs.add(new Fraymotif("Degenerate Regeneration", 3)
                    ..effects.add(new FraymotifEffect(Stats.HEALTH, 0, true))
                    ..desc =
                        " Hey there, Observer! Want to see a neat trick? POW! Grew my own head back. Pretty cool, huh? (Now if only JR would let me spam this or make it be castable even while dead, THEN we'd be cooking with petrol) "),
            new PotentialSprite(
                "Dragon", null) //custom fraymotif: mighty breath.
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 100})
                ..helpPhrase = "breathes fire and offers condescending, yet useful advice. "
                ..fraymotifs.add(new Fraymotif("Mighty Fire Breath", 3)
                    ..effects.add(new FraymotifEffect(Stats.POWER, 3, true))
                    ..desc =
                        " With a mighty breath, OWNER spits all the fires, sick and otherwise."),
            new PotentialSprite("Teacher", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 100})
                ..helpfulness = -1
                ..helpPhrase =
                    "dials the sprites natural tendency towards witholding information to have you 'figure it out yourself' up to eleven. "
                ..fraymotifs.add(new Fraymotif("Lecture", 3)
                    ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 3, false))
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 3, false))
                    ..desc =
                        " OWNER begins a 3 part lecture on why you should probably just give up. It is hypnotic in it's ceaselessness."),
            new PotentialSprite("Fiduspawn", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("Spawning", 3)
                    ..effects.add(new FraymotifEffect(Stats.ALCHEMY, 3, true))
                    ..desc =
                        " Oh god. Where are all those baby monsters coming from. They are everywhere! Fuck! How are they so good at biting??? "),
            new PotentialSprite("Doll", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 100})
                ..helpfulness = -1
                ..helpPhrase =
                    "stares creepily. It never moves when you're watching it. It's basically the worst, and that's all there is to say on that topic. "
                ..fraymotifs.add(new Fraymotif("Disconcerting Ogle", 3)
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 3, false))
                    ..effects.add(new FraymotifEffect(Stats.SANITY, 0, true))
                    ..desc =
                        " OWNER is staring at ENEMY. It makes you uncomfortable, the way they are just standing there. And watching.  "),
            new PotentialSprite("Zombie", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("Rise From The Grave", 3)
                    ..effects.add(new FraymotifEffect(Stats.HEALTH, 0, true))
                    ..desc =
                        " You thought the OWNER was pretty hurt, but instead they are just getting going. "),
            new PotentialSprite("Demon", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.FREE_WILL: 250, Stats.POWER: 250})
                ..fraymotifs.add(new Fraymotif("Claw Claw MotherFuckers", 3)
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..desc = " The OWNER slashes at the ENEMY twice. "),
            new PotentialSprite("Monster", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.SANITY: -250, Stats.MAX_LUCK: 250, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("Claw Claw MotherFuckers", 3)
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..desc = " The OWNER slashes at the ENEMY twice. "),
            new PotentialSprite("Vampire", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.MOBILITY: 250, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("I Vant to Drink Your Blood", 3)
                    ..effects.add(new FraymotifEffect(Stats.HEALTH, 2, true))
                    ..effects.add(new FraymotifEffect(Stats.HEALTH, 0, true)) //damage you, heal self.
                    ..desc = " The OWNER drains HP from the ENEMY. "),
            new PotentialSprite("Pumpkin", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.MOBILITY: 5000, Stats.MIN_LUCK: -250, Stats.MAX_LUCK: 5000, Stats.POWER: 100})
                ..helpPhrase =
                    "was kind of helpful, and then kind of didn’t exist. Please don’t think too hard about it, the simulation is barely handling a pumpkin sprite as is. "
                ..fraymotifs.add(new Fraymotif("What Pumpkin???", 3)
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 2, false))
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 3, true))
                    ..desc =
                        " Everyone tries to hit the OWNER until suddenly they have never been there at all, causing attacks to miss so catastrophically they backfire. "),
            new PotentialSprite("Werewolf", null)
                ..disaster = true
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.CURRENT_HEALTH: 500, Stats.SANITY: -250, Stats.POWER: 100})
                ..fraymotifs.add(new Fraymotif("Grim Bark Slash Attack", 3)
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..effects.add(new FraymotifEffect(Stats.POWER, 2, true))
                    ..desc =
                        " The OWNER slashes at the ENEMY twice. While being a werewolf. "),
            new PotentialSprite("Monkey", null) //just, fuck monkeys in general.
                ..disaster = true
                ..helpfulness = -1
                ..stats.setMap(<Stat,num>{Stats.HEALTH: 5, Stats.CURRENT_HEALTH: 5, Stats.MOBILITY: 5000, Stats.MIN_LUCK: -5000, Stats.MAX_LUCK: -5000, Stats.POWER: 100})
                ..helpPhrase = "actively inteferes with quests. Just. Fuck monkeys. "
                ..fraymotifs.add(new Fraymotif("Monkey Business", 3)
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 0, false))
                    ..effects.add(new FraymotifEffect(Stats.MOBILITY, 2, true))
                    ..desc =
                        " The OWNER uses their monkey like fastness to attack the ENEMY just way too fucking many times. "),
        ];


    }

    static initializeAShotTonOfLususSprites() {
//////////////////////lusii are a little stronger in general
        PotentialSprite.lusus_objects = <GameEntity>[
            new PotentialSprite("Hoofbeast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30}),
            new PotentialSprite("Meow Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MIN_LUCK: 20, Stats.MAX_LUCK: 20})
                ..helpPhrase =
                    "is kind of helpful? Maybe? You can't tell if it loves their player or hates them. ",
            new PotentialSprite("Bark Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 40})

                ..helpPhrase =
                    "alternates between loud, insistent barks and long, eloquent monologues on the deeper meaning behind each and every fragment of the game. ",
            new PotentialSprite("Nut Creature", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MOBILITY: 30})
            ,
            new PotentialSprite("Gobblefiend", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50}) //turkeys are honestly terrifying.

                ..helpfulness = -1
                ..helpPhrase =
                    "is the most unhelpful piece of shit in the world. Oh my god, just once. Please, just shut up. ",
            new PotentialSprite("Bicyclops", null) //laser fraymotif?
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Centaur", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50, Stats.SANITY: 50}) //lusii in the butler genus simply are unflappable.
            ,
            new PotentialSprite("Fairy Bull", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 1}) //kinda useless. like a small dog or something.
            ,
            new PotentialSprite("Slither Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})

                ..armless = true,
            new PotentialSprite("Wiggle Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Honkbird", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Dig Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Cholerbear", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
            ,
            new PotentialSprite("Antler Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MOBILITY: 30})
            ,
            new PotentialSprite("Ram Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Crab", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Spider", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Thief Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("March Bug", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Nibble Vermin", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Woolbeast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Hop Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MAX_LUCK: 30})
            ,
            new PotentialSprite("Stink Creature", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Speed Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MOBILITY: 50})
            ,
            new PotentialSprite("Jump Creature", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Fight Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
            ,
            new PotentialSprite("Claw Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
            ,
            new PotentialSprite("Tooth Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
            ,
            new PotentialSprite("Armor Beast", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.CURRENT_HEALTH: 100, Stats.HEALTH: 100})
                ..lusus = true
            ,
            new PotentialSprite("Trap Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})

        ];

////////////////////////sea lusii

        PotentialSprite.sea_lusus_objects = <PotentialSprite>[
            new PotentialSprite("Zap Beast", null) //zap fraymotif
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
            ,
            new PotentialSprite("Sea Slither Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})

                ..armless = true,
            new PotentialSprite("Electric Beast", null) //zap fraymotif
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 50})
                ..armless = true,
            new PotentialSprite("Whale", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.CURRENT_HEALTH: 50, Stats.HEALTH: 50})
                ..lusus = true
                ..armless = true,
            new PotentialSprite("Sky Horse", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MOBILITY: 20})
            ,
            new PotentialSprite("Sea Meow Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MIN_LUCK: 20, Stats.MAX_LUCK: 20})
            ,
            new PotentialSprite("Sea Hoofbeast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Cuttlefish", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Swim Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Sea Goat", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.MIN_LUCK: -30, Stats.MAX_LUCK: 30})

            ,
            new PotentialSprite("Light Beast", null)
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Dive Beast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Honkbird", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Sea Bear", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30})
            ,
            new PotentialSprite("Sea Armorbeast", null)
                ..lusus = true
                ..stats.setMap(<Stat,num>{Stats.POWER: 30, Stats.CURRENT_HEALTH: 50, Stats.HEALTH: 50})

        ];

    }
}



