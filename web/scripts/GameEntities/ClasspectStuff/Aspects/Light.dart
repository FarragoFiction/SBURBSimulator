import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Light extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#ff9933"
        ..aspect_light = '#FEFD49'
        ..aspect_dark = '#FEC910'
        ..shoe_light = '#10E0FF'
        ..shoe_dark = '#00A4BB'
        ..cloak_light = '#FA4900'
        ..cloak_mid = '#E94200'
        ..cloak_dark = '#C33700'
        ..shirt_light = '#FF8800'
        ..shirt_dark = '#D66E04'
        ..pants_light = '#E76700'
        ..pants_dark = '#CA5B00';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Treasure", "Light", "Knowledge", "Radiance", "Gambling", "Casinos", "Fortune", "Sun", "Glow", "Chance"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["SHOWOFF SQUIRT", "JUNGLEGYM SWASHBUCKLER", "SUPERSTITIOUS SCURRYWART"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Laborer", "Launderer", "Layabout", "Legend", "Lawyer", "Lifeguard"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Lucky", "LIGHT", "Knowledge", "Blinding", "Brilliant", "Break", "Blazing", "Glow", "Flare", "Gamble", "Omnifold", "Apollo", "Helios", "Scintillating", "Horseshoe", "Leggiero", "Star", "Kindle", "Gambit", "Blaze"]);


    @override
    String denizenSongTitle = "Opera"; //lol, cuz light players never shut up;

    @override
    String denizenSongDesc = " A beautiful opera begins to be performed. It starts to really pick up around Act 4. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Light', 'Helios', 'Ra', 'Cetus', 'Iris', 'Heimdall', 'Apollo', 'Coeus', 'Hyperion', "Belobog", 'Phoebe', 'Metis', 'Eos', 'Dagr', 'Asura', 'Amaterasu', 'Sol', 'Tyche', 'Odin ', 'Erutuf']);


    @override
    List<String> symbolicMcguffins = ["light","fortune", "knowledge", "illumination", "relevance", "rain", "sun", "rainbows"];

    @override
    List<String> physicalMcguffins = ["light","clover", "horseshoe", "encyclopedia","sun", "dice", "8-ball", "deck of tarot cards"];



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.MAX_LUCK, 2.0, true),
        new AssociatedStat(Stats.FREE_WILL, 1.0, true),
        new AssociatedStat(Stats.SANITY, -1.0, true),
        new AssociatedStat(Stats.HEALTH, -1.0, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.2, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Light(int id) :super(id, "Light", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.light(s, p);
    }

    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Luck","Casinos", "Gambling", "Dice", "Cards", "Fortune", "Chance","Betting"])
            ..addFeature(FeatureFactory.LUCKYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.HIGH) //persona5 has changed the face of casinos for me for all time
            ..addFeature(new DenizenQuestChain("Go Big or Go Home", [
                new Quest("The ${Quest.PLAYER1} finds a sparkling Casino. Inside, amid ${Quest.CONSORTSOUND}ing ${Quest.CONSORT}s is a single door, locked by three runes, each depicting a different form of gambling, Slots, Cards and Coins. Huh. The ${Quest.PLAYER1} approaches the slots and begins to play. Finally, after what must be hours, they get three Light symbols. The Slot rune lights up. One down, two to go."),
                new Quest("The ${Quest.PLAYER1} thinks they finally have the rules of poker down enough to try the next set of gambling challenges. After a nerve wracking series of hands, they bet it all on a risky gamble, only to pull through with a Royal Flush!  The Cards rune lights up."),
                new Quest("It is time for the final gamble. A single coin flip will decide it all. No take backs, no replays.   It lands. TAILS! The Coin rune lights up, and the door is open. The ${Quest.PLAYER1} begins to prepare for whatever may lay within."),
                new DenizenFightQuest("When the ${Quest.PLAYER1} finally enters the Casino Door, the ${Quest.DENIZEN} is already rampaging. They are pissed off as fuck that they have been off screen this entire time, and blame the ${Quest.PLAYER1} for it. It's time to strife! ","The ${Quest.PLAYER1} was lucky enough to pull off a win! The ${Quest.DENIZEN} is too dead too rampage.","Bad break, the ${Quest.DENIZEN} is going to keep throwing a hissy fit.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Glow", "Light", "Rays","Sun", "Shine", "Sparkle", "Sunshine","Stars" ])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.LIZARDCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.IGUANACONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CHAMELEONCONSORT, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("The Candlestick Taker", [
                new Quest("The ${Quest.PLAYER1} walks into a ${Quest.CONSORT} village, and finds all of them standing dejectedly in the village center. Their town has a monthly ceremony celebrating ${Quest.PHYSICALMCGUFFIN}, but ${Quest.DENIZEN} has hoarded all of the planet’s ${Quest.MCGUFFIN} Candles, and everyone knows you can’t have a good ${Quest.PHYSICALMCGUFFIN} ceremony without candles! The ${Quest.PLAYER1} vows to take back some ${Quest.MCGUFFIN} Candles for the poor ${Quest.CONSORT}s. "),
                new Quest("After a long search, the ${Quest.PLAYER1} has found the warehouse where ${Quest.DENIZEN} has stored all the candles. ${Quest.MCGUFFIN} Candles must be very valuable to ${Quest.DENIZEN} for some reason, because the warehouse roof is swarming with minions, waving a lot of bright spotlights in random intervals. The spotlights will need to be dealt with if the ${Quest.PLAYER1} wants to sneak in without alerting a horde of ${Quest.DENIZEN} minions."),
                new Quest("After spending hours attempting to determine the rotation of the guards and the patterns of spotlight waving with no luck, the ${Quest.PLAYER1} realizes they don’t have to avoid the lights if they can turn them off instead. They locate an unguarded electric panel outside and cut the power. The ${Quest.DENIZEN} minions don’t even leave the roof; they just confusedly wave their now useless spotlights, allowing the ${Quest.PLAYER1} to slip inside with ease. Captchaloging as much ${Quest.MCGUFFIN} Candles as they can, the ${Quest.PLAYER1} triumphantly returns to the village among the joyful ${Quest.CONSORTSOUND}ing of the ${Quest.CONSORT}s."),
                new DenizenFightQuest("The ${Quest.PLAYER1} is ready to challenge the ${Quest.DENIZEN} to keep them from restealing the ${Quest.MCGUFFIN} candles. ","Never again shall the ${Quest.CONSORT}s be without ${Quest.MCGUFFIN} Candles!","The ${Quest.MCGUFFIN} candles are once again at risk.")
            ], new DenizenReward(), QuestChainFeature.playerIsSneakyClass), Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Shine the Light", [
                new Quest("The ${Quest.PLAYER1} finds an incongruous dark patch in the otherwise brightly lit land. A quivering ${Quest.CONSORT} explains that the ${Quest.DENIZEN} has forbidden the ${Quest.CONSORT}s from having light, and moved giant disks to block it from them. Now that's just being mean!  The ${Quest.PLAYER1} vows to help.   "),
                new Quest("The ${Quest.PLAYER1} has finally managed to destroy the disk blocking light from the ${Quest.CONSORT} village. There is a chorus of happy ${Quest.CONSORTSOUND}s as they bask in the light. The ${Quest.PLAYER1} feels good about a job well done. "),
                new Quest("Disaster!  The ${Quest.CONSORT} village is once again shrouded in darkness, this time from an even larger disk than before. Judging from the roars, the ${Quest.DENIZEN} is guarding the disk themself.  The ${Quest.PLAYER1} must prepare themself for a tough fight.  "),
                new DenizenFightQuest("The ${Quest.PLAYER1} has managed to reach the disk guarded by the ${Quest.DENIZEN}. The monster denies even so basic a right as light, there can be no quarter. It's time to stife!","The ${Quest.DENIZEN} is defeated, the disk destroyed. Finally, the ${Quest.CONSORT}s can enjoy the light in peace.","Darkness reigns.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);

        addTheme(new Theme(<String>["Knowledge","Information","Books","Encyclopedias","Understanding","Libraries"])
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Shed the Light", [
                new Quest("${Quest.CONSORT}s are falling ill left and right due to a mysterious Plague. It doesn't seem to follow the pattern of a disease, having no communicability. What is going on and how can the ${Quest.PLAYER1} possibly stop it?"),
                new Quest("The ${Quest.PLAYER1} pours over maps and charts. What do the sick ${Quest.CONSORT}s have in common with each other?  Finally, there is a flash of inspiration. ${Quest.CONSORT}s who live or work closer to a particular river that meanders across the planet are the ones becoming ill! The ${Quest.PLAYER1} quickly orders the river quarantined and new cases begin to taper off. Now it remains to see what can be done about those already sick. "),
                new Quest("The ${Quest.PLAYER1} analyzes the water from the contaminated well. Boiling it reveals a thick black sludge.  The collected steam is found to be perfectly safe to drink. The ${Quest.PLAYER1} discovers that the sludge causes a strange vitamin deficiency, and supplies the town with supplements to fix the sickness.  Things are looking brighter, indeed."),
                new DenizenFightQuest("The ${Quest.PLAYER1} traces the contaminated river back to it's source. The ${Quest.DENIZEN} is revealed to be dripping the gross as fuck sludge into the river. When negotiations fail to make it leave the water, the only remaining option is Stife. ","The ${Quest.PLAYER1} is victorious. The ${Quest.DENIZEN}'s body despawns, along with all the sludge in the river. The Plague is finally over!","The darkness of the Plague remains.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme

        //light is a special snowlake and can have 4 themes
        addTheme(new Theme(<String>["Spotlights","Attention","Drama","Stars","Glamor","Holywood"])
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.LUCKYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DISCOSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Be the Star", [
                new Quest("The ${Quest.PLAYER1} is approached by a Fast Talking ${Quest.CONSORT}. Apparently the ${Quest.PLAYER1} has EXACTLY the right look to be the lead in the upcoming production of The Beautiful ${Quest.PHYSICALMCGUFFIN}. The ${Quest.PLAYER1} agrees to perform the titular role."),
                new Quest("The opening night performance of the Beautiful ${Quest.PHYSICALMCGUFFIN} is a huge success! The ${Quest.CONSORTSOUND}ing of the fans is it's own reward!"),
                new Quest("When it comes time for the next performance of the Beautiful ${Quest.PHYSICALMCGUFFIN}, the ${Quest.PLAYER1} is turned away at the door. Apparently the ${Quest.DENIZEN} rampaged and terrorized ${Quest.CONSORT}s until given the lead role. They claim that the ${Quest.PLAYER1} is FAR too drab to be give such an important performance. WHAT. THE. FUCK. The ${Quest.PLAYER1} isn't going to let this stand."),
                new DenizenFightQuest("There is not enough room on the stage for both of them. The ${Quest.PLAYER1} challenges the ${Quest.DENIZEN} to a glamour off, and wins handily. Enraged, the ${Quest.DENIZEN} attacks.","The ${Quest.PLAYER1} can finally get back to their promising acting career in peace.","The actig career of the ${Quest.PLAYER1} is in shambles.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Be the Biggest Star in Paradox Space", [
                new Quest("After the ${Quest.DENIZEN}, the ${Quest.PLAYER1} is disappointed to learn that barely any of the ${Quest.CONSORT}s know who they are. This will not do!"),
                new Quest("Posters, ad campaigns, catchy jingles, and the ${Quest.PLAYER1} still runs into the odd ${Quest.CONSORT} that doesn't recognize them on sight. This is getting ridiculous!"),
                new Quest("The ${Quest.PLAYER1} thinks they finally have an idea.  They focus. Light-y bullshit effects rain down from the sky, and their face is super imposed over the brilliance of Skaia itself. Now EVERYONE on their planet knows who is the most important. It is them.")
            ], new FraymotifReward("What's my name?", "The ${Fraymotif.OWNER} is famous, and everyone in this fight is lucky to have met them."), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)
            , Theme.HIGH); // end theme
    }
}