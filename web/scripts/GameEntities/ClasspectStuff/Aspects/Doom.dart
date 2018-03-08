import 'dart:math' as Math;

import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Doom extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.00;
    @override
    double fraymotifWeight = 0.5;
    @override
    double companionWeight = 0.5;


    @override
    double difficulty = 1.0;

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#003300"
        ..aspect_light = '#0F0F0F'
        ..aspect_dark = '#010101'
        ..shoe_light = '#E8C15E'
        ..shoe_dark = '#C7A140'
        ..cloak_light = '#1E211E'
        ..cloak_mid = '#141614'
        ..cloak_dark = '#0B0D0B'
        ..shirt_light = '#204020'
        ..shirt_dark = '#11200F'
        ..pants_light = '#192C16'
        ..pants_dark = '#121F10';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Fire", "Death", "Prophecy", "Blight", "Rules", "Prophets", "Poison", "Funerals", "Graveyards", "Ash", "Disaster", "Fate", "Destiny", "Bones"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["APOCALYPSE HOW", "REVELATION RUMBLER", "PESSIMISM PILGRIM"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Dancer", "Dean", "Decorator", "Deliverer", "Director", "Delegate", "Destined"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Dark", "Broken", "Meteoric", "Diseased", "Fate", "Doomed", "Inevitable", "Doom", "End", "Final", "Dead", "Ruin", "Rot", "Coffin", "Apocalypse", "Morendo", "Smorzando", "~Ath", "Armistyx", "Grave", "Corpse", "Ashen", "Reaper", "Diseased", "Armageddon", "Cursed"]);


    @override
    String denizenSongTitle = "Dirge"; //a song for the dead;

    @override
    String denizenSongDesc = " A slow dirge begins to play. It is the one Death plays to keep in practice. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["doom","rules", "fate", "judgement", "fog", "gas"];

    @override
    List<String> physicalMcguffins = ["doom","bone", "skull", "mural", "gravestone", "tome", "tomb"];

    @override
    bool deadpan = true; // Ain't havin' none 'o' that trickster shit
    @override
    bool ultimateDeadpan = true; // now what did I *just* say?!
    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Doom', 'Hades', 'Achlys', 'Cassandra', 'Osiris', 'Ananke', 'Thanatos', 'Moros', 'Iapetus', 'Themis', 'Aisa', 'Oizys', 'Styx', 'Keres', 'Maat', 'Castor and Pollux', 'Anubis', 'Azrael', 'Ankou', 'Kapre', 'Moros', 'Atropos', 'Oizys', 'Korne', 'Odin']);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.ALCHEMY, 2.0, true),
        new AssociatedStat(Stats.FREE_WILL, 1.0, true),
        new AssociatedStat(Stats.MIN_LUCK, -1.0, true),
        new AssociatedStat(Stats.HEALTH, -1.0, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.01, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Doom(int id) :super(id, "Doom", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.doom(s, p);
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("~ATH - A Handbook for the Imminently Deceased ",<ItemTrait>[ItemTraitFactory.BOOK,ItemTraitFactory.ZAP, ItemTraitFactory.PAPER, ItemTraitFactory.DOOMED, ItemTraitFactory.ASPECTAL, ItemTraitFactory.LEGENDARY],shogunDesc: "A Huge Ass Black Book on Coding or Something",abDesc:"Don't use this to end two universes, asshole."))
            ..add(new Item("Egg Timer",<ItemTrait>[ItemTraitFactory.PLASTIC,ItemTraitFactory.CALMING, ItemTraitFactory.ASPECTAL, ItemTraitFactory.DOOMED],shogunDesc: "Egg That Counts Down to Your Death"))
            ..add(new Item("Skull Timer",<ItemTrait>[ItemTraitFactory.BONE,ItemTraitFactory.CALMING, ItemTraitFactory.ASPECTAL, ItemTraitFactory.DOOMED],shogunDesc: "Skull That Counts Down to Your Dinner Being Ready",abDesc:"Everyone is mortal. Besides robots."))
            ..add(new Item("Poison Flask",<ItemTrait>[ItemTraitFactory.GLASS, ItemTraitFactory.ASPECTAL, ItemTraitFactory.POISON],shogunDesc: "Glass of Bone Hurting Juice"))
            ..add(new Item("Ice Gorgon Head",<ItemTrait>[ItemTraitFactory.GLASS, ItemTraitFactory.ASPECTAL, ItemTraitFactory.COLD,ItemTraitFactory.DOOMED,ItemTraitFactory.RESTRAINING,ItemTraitFactory.UGLY,ItemTraitFactory.SCARY],shogunDesc: "Oddly Attractive Decapitated Head"))
            ..add(new Item("Obituary",<ItemTrait>[ ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.SCARY, ItemTraitFactory.DOOMED, ItemTraitFactory.PAPER, ItemTraitFactory.ASPECTAL],shogunDesc: "Omae Wa Mou Shindeiru in Paper Form",abDesc:"I wonder whose it is? Yours?"));
    }


    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Death", "Endings","Mortality", "Graveyards", "Bones", "Funerals","Skulls", "Skeletons","Cemeteries", "Graves", "Tombstones"])
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Empty the Graves", [
                new Quest(" The ${Quest.PLAYER1} learns of a Omni-Lich that has been emptying the graves of the ${Quest.CONSORT}s, who are understandably upset at this disrespect to everything their culture holds dear."),
                new Quest("The ${Quest.PLAYER1} hunts down the Omni-Lich, only to discover that it cannot be killed without the use of a mystic ${Quest.PHYSICALMCGUFFIN}. The player begins to search for this totally USEFUL and IMPORTANT item. "),
                new Quest("The ${Quest.PLAYER1} finds the ${Quest.PHYSICALMCGUFFIN}, and slays the Omni-Lich, scattering its bones to the winds, which, according to ${Quest.CONSORT} traditions, should summon its master. Uh. Eventually."),
                new DenizenFightQuest("FINALLY, the bones of Omni-Lich has summoned it's master, ${Quest.DENIZEN}.","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} has won! The ${Quest.CONSORT}s are free to bury their dead in peace once again.","The grave robbing of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Disaster", "Fire", "Ash", "Armageddon", "Apocalypse", "Radiation", "Blight", "Gas", "Poison", "Chlorine", "Wastelands"])
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SCREAMSSOUND, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CHLORINESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)

            ..addFeature(new DenizenQuestChain("Become the Warlord", [
                new Quest("The ${Quest.PLAYER1} has found a group of Violent ${Quest.CONSORT}s whose society has long since crumbled. They live in roving bands, willing to kill and maim to gain access to '${Quest.MCGUFFIN}', the fuel their post apocalyptic society runs on. "),
                new Quest("The ${Quest.PLAYER1} has survived a small assault team of Violent ${Quest.CONSORT}s, and is declared their new leader. They beg and grovel and ${Quest.CONSORTSOUND} and ask that the ${Quest.PLAYER1} help them take back their ${Quest.MCGUFFIN} from a rival gang. "),
                new Quest("The ${Quest.PLAYER1} is now the warlord of nearly all of the Violent ${Quest.CONSORT}s. There is clearly not enough ${Quest.MCGUFFIN} for everyone, though. It turns out that the ${Quest.DENIZEN} has been hoarding it all to cause scarcity to breed violence and anarchy. What a huge bitch. This cannot stand. "),
                new DenizenFightQuest("There isn't enough room in this wasteland for the both of them. It's time to take out the ${Quest.DENIZEN}.","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} distributes the hoard of ${Quest.MCGUFFIN} to the Violent ${Quest.CONSORT}s and keeps the hoard of grist for themself. ","The ${Quest.MCGUFFIN} shortage continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.playerIsDestructiveClass), Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Make This Stupid Planet Habitable", [
                new Quest("The ${Quest.PLAYER1} is sick of their stupid uninhabitable planet, and so starts to make sections of it habitable through judicious use of alchemy and ${Quest.PHYSICALMCGUFFIN}s alike. "),
                new Quest("${Quest.CONSORT}s begin to flock to the safe areas that The ${Quest.PLAYER1} constructed, and begin to make tiny villages within the safety of its zones. Precious  ${Quest.PHYSICALMCGUFFIN}s are found in some nearby mines. "),
                new Quest("The ${Quest.PLAYER1} has straight up established a new consort government in the safe zones. This is so deliriously biznasty it threatens the very existence of anything un-nasty in all possible timelines. Alas, while ${Quest.DENIZEN} remains alive, the safe zone will be temporary at best. "),
                new DenizenFightQuest("${Quest.DENIZEN} is attacking the safe zones. The ${Quest.PLAYER1} has worked too hard for it all to be lost now. There can be no mercy. ","The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} is finally free to continue improving the land. ","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Prophecy","Prophets","Fate", "Destiny","Rules","Sound","Judgement","Carvings", "Murals", "Etchings"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISPERSOUND, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.LOW)

            ..addFeature(new DenizenQuestChain("Learn the Prophecy", [
                new Quest("The ${Quest.PLAYER1} finds a small dungeon bearing the image of ${Quest.DENIZEN}. At the bottom, they find a switch inside a small hole they can just barely fit their arm inside. When they reach in and flip the switch, they feel something attach to their arm with a loud click. The ${Quest.PLAYER1} pulls out their arm to find attached is some super complicated machinery complete with a timer counting down. That can’t be good."),
                new Quest("The device continues to count down. After consulting with local ${Quest.CONSORT}s, the ${Quest.PLAYER1} navigates another dungeon in hopes of finding a clue to removing the ominous device from their arm without causing it to go off. Past complicated puzzles involving doomsday dates and scales, they find a small scroll on a pedestal. Written on the scroll is a prophecy that the ${Quest.PLAYER1} will permanently die in an explosion from attempting remove a device on their arm. Well, that’s just great."),
                new Quest("The timer doesn’t stop from counting lower. The ${Quest.PLAYER1} makes up their mind and decides they’re not going to sit and wait until the timer goes off. They’re going to remove the stupid thing, prophecy or not! They quickly pry it off their arm and throw it away as far as possible. There’s no explosion; the device just breaks. Did the ${Quest.PLAYER1} use their powers to stop it from exploding and break the prophecy, or was this all just a shitty test from ${Quest.DENIZEN}? Either way, the ${Quest.PLAYER1} isn’t very pleased with the ${Quest.DENIZEN}."),
                new DenizenFightQuest("The ${Quest.PLAYER1} tracks down the location of the ${Quest.DENIZEN} ‘s lair. It’s payback time!", "The ${Quest.DENIZEN} has been thoroughly beaten. Serves them right for playing such a mean trick on the ${Quest.PLAYER1}.","The ${Quest.PLAYER1} couldn’t get their revenge. ${Quest.DENIZEN} has a hearty laugh at their expense.")
            ], new DenizenReward(), QuestChainFeature.playerIsDestructiveClass), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Learn the Prophecy", [
                new Quest("The ${Quest.PLAYER1} learns from one of their ${Quest.CONSORT}s that there is an ancient prophecy of a ${Quest.MCGUFFIN} plague that is due to kill them all any day now."),
                new Quest("The ${Quest.PLAYER1} gets deep into the nitty gritty of the apocalypse prophecy. They learn that the plague is not technically going to hit the consorts- it's going to hit the bearers of the MAGIC ${Quest.PHYSICALMCGUFFIN}, which currently happens to be the ${Quest.CONSORT}s. "),
                new Quest("The ${Quest.PLAYER1} goes on a daring series of stupid missions to deliver the MAGIC ${Quest.PHYSICALMCGUFFIN} into an underling camp, thereby redirecting the incoming ${Quest.MCGUFFIN} plague into devastating the underlings instead of the ${Quest.CONSORT}s. The underling army is all but decimated, and ${Quest.DENIZEN}s lair is all but undefended. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} is finally ready to face the ${Quest.DENIZEN}.", "The ${Quest.DENIZEN} lies slain by the ${Quest.PLAYER1}'s ${Quest.WEAPON}. The ${Quest.PLAYER1} has won! ","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(NPCHandler.DP), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme


    }
}