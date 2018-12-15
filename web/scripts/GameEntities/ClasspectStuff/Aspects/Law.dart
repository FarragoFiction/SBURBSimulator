import 'dart:math' as Math;

import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Law extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.01;
    @override
    double fraymotifWeight = 0.9;
    @override
    double companionWeight = 0.1;


    @override
    double difficulty = 1.0;

    //TODO oh god where did KR put that palette again?
    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#003300"
        ..aspect_light = '#0f0f0f'
        ..aspect_dark = '#0f0f0f'
        ..shoe_light = '#0f0f0f'
        ..shoe_dark = '#0f0f0f'
        ..cloak_light = '#0f0f0f'
        ..cloak_mid = '#0f0f0f'
        ..cloak_dark = '#0f0f0f'
        ..shirt_light = '#0f0f0f'
        ..shirt_dark = '#0f0f0f'
        ..pants_light = '#0f0f0f'
        ..pants_dark = '#0f0f0f';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Law", "Courts", "Trials", "Rules", "Edicts","Control","Cones","Order"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["LEGAL LAD", "SHERRIF SURESHOT", "CONE KOHAI"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Lawyer","Litigator","Lands","Laborer","Lady","Lad","Lamb","Lawman","Luchador","Lover","Legislacerator"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Judge","Law Abiding","Legal","Courting","Trail","Edict","Jury","Baliff","Verdict","Sentence","Jail","Executioner"]);


    @override
    String denizenSongTitle = "Dirge"; //a song for the dead;

    @override
    String denizenSongDesc = " A slow dirge begins to play. It is the one Death's Lawyer plays to keep in practice. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["orders","rules", "edicts", "sentences"];

    @override
    List<String> physicalMcguffins = ["gavel","caution tape", "rule book", "dictionary", "wig", "handbook", "lock"];

    @override
    bool deadpan = true; // Ain't havin' none 'o' that trickster shit
    @override
    bool ultimateDeadpan = true; // now what did I *just* say?!
    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>["Themis","Phoenix","Wright","Jupiter","Dike","Marduk","Fortuna"]);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.FREE_WILL, 2.0, true),
        new AssociatedStat(Stats.SANITY, 1.0, true),
        new AssociatedStat(Stats.MOBILITY, -2.0, true),
        new AssociatedStat(Stats.SBURB_LORE, -0.1, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Law(int id) :super(id, "Law", isCanon: false);

    @override
    String activateCataclysm(Session s, Player p) {
        //TODO have a real gnosis even for law, don't just steal dooms
        return s.mutator.doom(s, p);
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("LAW Gavel",<ItemTrait>[ItemTraitFactory.ASPECTAL,ItemTraitFactory.WOOD, ItemTraitFactory.HAMMER],shogunDesc: "Tiny Whacky Smacky Skull Cracky of Justice",abDesc:"Organics seem to respect this. Use it to your advantage."))
            ..add(new Item("LAW Caution Tape",<ItemTrait>[ItemTraitFactory.ASPECTAL,ItemTraitFactory.PLASTIC, ItemTraitFactory.RESTRAINING],shogunDesc: "Impassible Barrier",abDesc:"For when you want to tell inferior organics to keep out."))
            ..add(new Item("STOP SIGN",<ItemTrait>[ItemTraitFactory.ASPECTAL,ItemTraitFactory.STAFF,ItemTraitFactory.METAL, ItemTraitFactory.RESTRAINING],abDesc:"This isn't a weapon, dunkass."));
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