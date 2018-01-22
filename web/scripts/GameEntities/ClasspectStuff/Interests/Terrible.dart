import "../../../SBURBSim.dart";
import "Interest.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Terrible extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.RELATIONSHIPS, -1.0, true), new AssociatedStat(Stats.SANITY, -1.0, true)]);
    @override
    List<String> handles1 = <String>["tyranical", "heretical", "murderous", "persnickety", "mundane", "killer", "rough", "sneering", "hateful", "bastard", "pungent", "wasted", "snooty", "wicked", "perverted", "master", "hellbound"];

    @override
    List<String> handles2 = <String>["Butcher", "Blasphemer", "Barbarian", "Tyrant", "Superior", "Bastard", "Dastard", "Despot", "Bitch", "Horror", "Victim", "Hellhound", "Devil", "Demon", "Shark", "Lupin", "Mindflayer", "Mummy", "Hoarder", "Demigod"];

    @override
    List<String> levels = <String>["ENEMY #1", "JERKWAD JOURNEYER"];

    @override
    List<String> interestStrings = <String>["Arson", "Clowns", "Treasure", "Money", "Violence", "Death", "Animal Fights", "Insults", "Hoarding", "Status", "Classism", "Online Trolling", "Intimidation", "Fighting", "Genocide", "Murder", "War"];


    Terrible() :super(5, "Terrible", "honest", "terrible");
    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Lighter",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.ONFIRE],shogunDesc: "ABJs Birthday Gift",abDesc:"Don't let ABJ know you have this."))
            ..add(new Item("Siberia Poster",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.COLD],shogunDesc: "Poster of the Shoguns Birthplace"))
            ..add(new Item("Nuclear Winter Poster",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.COLD, ItemTraitFactory.NUCLEAR],shogunDesc: "Shoguns Dream as a Poster"))
            ..add(new Item("Doomsday Device",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.DOOMED, ItemTraitFactory.NUCLEAR, ItemTraitFactory.REAL, ItemTraitFactory.CORRUPT],shogunDesc: "Shoguns UNO Reverse Card",abDesc:"Oh god, who would fucking trust YOU with thi?"))
            ..add(new Item("Juggalo Poster",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.JUGGALO],shogunDesc: "False God Poster"))
            ..add(new Item("Fancy Watch",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.VALUABLE, ItemTraitFactory.REAL],shogunDesc: "Shoguns Watch"))
            ..add(new Item("Magnificent Crown",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.VALUABLE, ItemTraitFactory.REAL],shogunDesc: "The Shoguns Crown"))
            ..add(new Item("Bitching Clothes",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.BESPOKE, ItemTraitFactory.REAL],shogunDesc: "Shoguns Godtier Outfit",abDesc:"Just wear roboclothes. Never need another set."))
            ..add(new Item("Ceramic Pork Hollow",<ItemTrait>[ItemTraitFactory.CERAMIC, ItemTraitFactory.VALUABLE],shogunDesc: "Shoguns Old Porkhollow",abDesc:"..."))//that fanfic, man
            ..add(new Item("Shit Ton of Guns",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.PISTOL, ItemTraitFactory.SHOOTY, ItemTraitFactory.REAL],shogunDesc: "Dynamos Armament",abDesc:"You are one high quality sociopath."))
            ..add(new Item("Sniper Rifle",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.RIFLE, ItemTraitFactory.SHOOTY, ItemTraitFactory.REAL],shogunDesc: "Long Range Rooty Tooty Point And Boomy",abDesc:"What. The. Hell."))
            ..add(new Item("AK-47",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.MACHINEGUN, ItemTraitFactory.SHOOTY, ItemTraitFactory.REAL],shogunDesc: "100% Genuine Soviet Kalashnikov",abDesc:"What is it with you and guns."))
            ..add(new Item("IED",<ItemTrait>[ItemTraitFactory.GRENADE, ItemTraitFactory.EDGED,ItemTraitFactory.METAL, ItemTraitFactory.EXPLODEY, ItemTraitFactory.REAL],shogunDesc: "Shitpost Bomb",abDesc:"You are probably going to blow yourself up, asshole."))
            ..add(new Item("Idiots Guide To Being An Asshole",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.ENRAGING, ItemTraitFactory.BOOK],shogunDesc: "Shoguns Guide to Shitposting",abDesc:"Oh god, this is HILARIOUS, it's the PERFECT book for you."))
            ..add(new Item("Bike Horn",<ItemTrait>[ItemTraitFactory.RUBBER,ItemTraitFactory.METAL, ItemTraitFactory.LOUD,ItemTraitFactory.ENRAGING],shogunDesc: "Bike Mounted Pain Box",abDesc:"I hear flesh bags keep gtting scared by these. I don't get it."))
            ..add(new Item("Matches",<ItemTrait>[ItemTraitFactory.WOOD, ItemTraitFactory.ONFIRE],abDesc:"Don't let ABJ get this.",shogunDesc: "ABJs First Arsonist Set"));
    }


    @override
    void initializeThemes() {

        addTheme(new Theme(<String>["Fire","Arson","Blaze", "Burning", "Flames"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.SMOKESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.OVERHEATED, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Start the Fires", [
                new Quest("The ${Quest.PLAYER1} finds a bowl filled with colorful green powder in a dungeon, next to a locked door with green, blue and red gems inset in the middle. After some poking and proding, they do what comes naturally and start a small fire. The bowl blazes green. A green gem lights up on the locked door. Huh. "),
                new Quest("The ${Quest.PLAYER1} has been wandering around, starting random fires, when they finally manage to burn someting that blazes blue. When they go back to check, the dungeon door has both green and blue symbols lit up.  "),
                new Quest(" The ${Quest.PLAYER1} has finally managed to get a bright red fire going. They rush back to the dungeon to see all three symbols lit up. They enter and get a fat stack of boonies for beating the dungeon. ")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Treasure","Gold","Wealth", "Hoards", "Coins", "Money", "Bling"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("All About the Boonies, Baby", [
                new Quest("The ${Quest.PLAYER1} learns that there is an entire planet of suckers, er, you mean ${Quest.CONSORT}s with boonies just burning a hole in their pockets. This needs to be fixed, ASAP."),
                new Quest("The ${Quest.PLAYER1} starts running a con job, you mean, ENTERTAINMENT VENUE, where they show the various gullible, you mean discerning ${Quest.CONSORT}s various wonders from around Paradox Space. Marvel at the two headed ${Quest.PHYSICALMCGUFFIN} underling. Tremble at the fearsome ${Quest.MCGUFFIN} ${Quest.CONSORT}.   "),
                new Quest(" The ${Quest.PLAYER1} finally has enough boonies to get that fraymotif they've had their eye on.  Good thing, too, because the ${Quest.CONSORT}s seem to finally be mostly out of cash. Oh well. ")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Decay","Rot","Death","Mayhem","Gas","Wrath"])
            ..addFeature(FeatureFactory.ROTSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CROCODILECONSORT, Feature.LOW)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Revive the Consorts", [
                new Quest("The ${Quest.PLAYER1} learns that all of the local ${Quest.CONSORT}s are dead. This is....pretty cool, actually. "),
                new Quest("The ${Quest.PLAYER1} has found a series of intriguing block puzzles and symbols. What could it all mean? "),
                new Quest("With a satisfying CLICK, the ${Quest.PLAYER1} has solved the final block puzzle.  A wave of energy overtakes the land. There is an immediate chorus of ${Quest.CONSORTSOUND}ing.  The dead ${Quest.CONSORT}s have risen and want to be part of ${Quest.PLAYER1}'s Necromantic Army.   "),
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Classism","Struggle","Apathy", "Revolution", "Rebellion", "Hate"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.GUNFIRESOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SCREAMSSOUND, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Stop a Rebellion", [
                new Quest("The ${Quest.PLAYER1} finds a crowd of ${Quest.CONSORTSOUND}ing ${Quest.CONSORT}s. They are holding signs with slogans like 'This isn't Fair' and 'Don't be Jerks'. Apparently they have a problem with the upper class ${Quest.CONSORT}s in charge. The ${Quest.PLAYER1} is disgusted by their laziness and vows to stop them."),
                new Quest("The ${Quest.PLAYER1} meets with the upper class ${Quest.CONSORT}s to offer their services to quell the misguided rebellion. They are immediatly made the leader of the Special ${Quest.MCGUFFIN} Forces.  "),
                new Quest("It has been a long struggle, but finally the lazy, peasant ${Quest.CONSORT}s have been defeated. The high class ${Quest.CONSORT}s murmur dignified ${Quest.CONSORTSOUND}s and give the ${Quest.PLAYER1} several medals. "),
            ], new ItemReward(items), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


    }



}