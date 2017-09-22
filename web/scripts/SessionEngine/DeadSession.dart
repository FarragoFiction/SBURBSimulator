import '../SBURBSim.dart';
import "../Lands/FeatureTypes/QuestChainFeature.dart";
import "../Lands/Quest.dart";
import "../Lands/Reward.dart";
//only one player, player has no sprite, player has DeadLand, and session has 16 (or less) subLands.
class DeadSession extends Session {
    //TODO any denizen fraymotif should be the caliborn quote
    //page #007356
    // A stupid note is produced, It's the one assholes play to make their audience start punching themselves in the crouch repeatidly
    Map<Theme, double> themes = new Map<Theme, double>();
    Map<Theme, double> chosenThemesForDeadSession =  new Map<Theme, double>();
    int numberLandsRemaining = 16; //can remove some in "the break".
    List<QuestChainFeature> boringBullshit;
    Player metaPlayer;
    @override
    num minTimeTillReckoning = 100;
    @override
    num maxTimeTillReckoning = 300;

    //not to be confused with the land on the player. this would be a pool bar for colors and mayhem
    //lands can only happen once the player's main land has gotten past the first stage.
    Land currentLand;
    DeadSession(int sessionID): super(sessionID) {
        //have a metaplayer BEFORE you make the bullshit quests.
        mutator.metaHandler.initalizePlayers(this);
        metaPlayer = rand.pickFrom(mutator.metaHandler.metaPlayers);
        makeThemes();
        timeTillReckoning = 200; //pretty long compared to a normal session, but not 16 times longer. what will you do?
    }

    //no reward for your boring bullshit. make quest chains so stupidly long too.
    //also, normally quests will be custom per theme, but not for boring bullshit.
    //http://www.mspaintadventures.com/?s=6&p=007682  thanks to nobody for finding this page for me to be inspired by
    //Also, since I KNOW this will be called post initialization, I can reference the meta player directly.
    void makeBoringBullshit() {
        boringBullshit = new List<QuestChainFeature>()
        ..add(new PreDenizenQuestChain("Find Bullshit Keys", <Quest>[
            new Quest("The ${Quest.PLAYER1} discovers a mysterious console with several key holes. That asshole, ${metaPlayer.chatHandle} taunts the ${Quest.PLAYER1} with how they can't progress until they finish this boring, tedious, STUPID quest."),
            new Quest("The ${Quest.PLAYER1} finds another key."),
            new Quest("The ${Quest.PLAYER1} finds another key under a random ass unlabeled stone."),
            new Quest("Oh, look, another random ass unlabeled stone, another key. The ${Quest.PLAYER1} almost didn't feel despair that time! That weird ${metaPlayer.chatHandle} makes sure to be an even bigger asshole than normal to compensate."),
            new Quest("The ${Quest.PLAYER1} finds another key."),
            new Quest("The ${Quest.PLAYER1} finds another key. Wait. No, it turns out it's somehow just a SCULPTURE of a key.  It doesn't fit in the godamned console. "),
            new Quest("Wait.  What? Really!  It's the final bullshit key! Holy fuck!  The ${Quest.PLAYER1} activates the console. There is an ominous rumbling, and several mini planets are unlocked.  ${metaPlayer.chatHandle} enjoys a hearty round of gigglesnort at the fact that the reward is to do MORE pointless bullshit quests.")
        ], new Reward(), QuestChainFeature.defaultOption))
        ..add(new PreDenizenQuestChain("Count Bullshit Bugs", <Quest>[
            new Quest("The ${Quest.PLAYER1} discovers a mysterious console with a keypad. That asshole, ${metaPlayer.chatHandle} taunts the ${Quest.PLAYER1} with how they can't progress until they finish this boring, tedious, STUPID quest."),
            new Quest("The ${Quest.PLAYER1} finds another bug."),
            new Quest("Holy fuck, just...hold still you asshole bugs! How are you supposed to count these things?"),
            new Quest("The ${Quest.PLAYER1} knocks over the jar containing the counted bugs. OH MY FUCKING GOD they have to start back over."),
            new Quest("The ${Quest.PLAYER1} finds another bug."),
            new Quest("The ${Quest.PLAYER1} finds yet another bug."),
            new Quest("The ${Quest.PLAYER1} finds another bug. Wait. No. It was just a rock. God damn it."),
            new Quest("Wait.  What? Really!  It's the final bug! Holy fuck!  The ${Quest.PLAYER1} activates the console. There is an ominous rumbling, and several mini planets are unlocked.  ${metaPlayer.chatHandle} enjoys a hearty round of gigglesnort at the fact that the reward is to do MORE pointless bullshit quests.")
        ], new Reward(), QuestChainFeature.defaultOption))
        ..add(new PreDenizenQuestChain("Collect Bullshit Rocks", <Quest>[
            new Quest("The ${Quest.PLAYER1} discovers a mysterious console with a chute to accept rocks. That asshole, ${metaPlayer.chatHandle} taunts the ${Quest.PLAYER1} with how they can't progress until they finish this boring, tedious, STUPID quest."),
            new Quest("The ${Quest.PLAYER1} finds another rock."),
            new Quest("Oh look. A rock. But the multiverses biggest asshole, ${metaPlayer.chatHandle} helpfully lets you know that it is not, in fact, ROCKY enough to count.  Marvelous."),
            new Quest("The ${Quest.PLAYER1} finds another rock."),
            new Quest("The ${Quest.PLAYER1} finds another rock. Thrilling."),
            new Quest("The ${Quest.PLAYER1} finds another rock."),
            new Quest("Wait.  What? Really!  It's the final bullshit rock! Holy fuck!  The ${Quest.PLAYER1} activates the console. There is an ominous rumbling, and several mini planets are unlocked.  ${metaPlayer.chatHandle} enjoys a hearty round of gigglesnort at the fact that the reward is to do MORE pointless bullshit quests.")
        ], new Reward(), QuestChainFeature.defaultOption));
    }

    void makeThemes() {
        makeBoringBullshit();
        addTheme(new Theme(<String>["Billiards","Pool","Stickball", "Colors", "Snooker", "Cues"])
            ..addFeature(FeatureFactory.CHLORINESMELL, Feature.LOW)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(rand.pickFrom(boringBullshit), Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.YALDABAOTHDENIZEN, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Sink the Balls", [
                new Quest("The ${Quest.PLAYER1} listens as the rules of pool are explained to them. In insufferable detail.  Multiple times. By every single fucking ${Quest.CONSORT} they meet, not just the asshole ${metaPlayer.chatHandle}.  It's almost enough to make them wish the damn things would just stick to ${Quest.CONSORTSOUND}ing. Yes, I GET it you asshole, explode the planets into the center black hole in order. Geez. "),
                new Quest("With an echoing crash, the first planet tumbles into the black hole. "),
                new Quest("The ${Quest.PLAYER1} is really getting the hang of this stickball thing."),
                new Quest("Another planet enters the corner pocket."),
                new Quest("Oh shit, that one almost didn't make it into the hole.  ${metaPlayer.chatHandle} is probablly yucking it up somewhere."),
                new Quest("You start to wonder if these things are actually supposed to be challenging?"),
                new Quest("Isn't actual billiards harder than this?"),
                new Quest("Another planet enters yet another pocket. Seriously, in real pool you'd be bouncing off other balls and walls and shit."),
                new Quest("Another planet enters yet another pocket. But you guess in real pool you ALSO get more than once chance to get each ball in."),
                new Quest("Another planet careens into yet another pocket."),
                new Quest("Another planet enters yet another pocket. How has this game managed to make EXPLOSIONS boring?"),
                new Quest("Another planet enters yet another pocket."),
                new Quest("Another planet enters yet another pocket."),
                new Quest("Another planet enters the shitty black hole. Wow. This is really getting repetitve."),
                new Quest("Like, you can barely make your eyes focus enough to read these things."),
                new Quest("Can you imagine having to LIVE through all these shitt planets being destroyed?"),
                new Quest("The ${Quest.PLAYER1} sinks the 8 ball! They are officially declared the pool champion! Congratulations! Now, all they need to do is make their way to the final Boss.  The ${Quest.PLAYER1} barely even cares what sorts of annoying things are in the way, they are so close they can TASTE victory.")
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)
            ,  Theme.SUPERHIGH);

        addTheme(new Theme(<String>["Bowling","Pins","Heavy Balls", "Gutters"])
            ..addFeature(FeatureFactory.FEETSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(rand.pickFrom(boringBullshit), Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.YALDABAOTHDENIZEN, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Knock Over the Pins", [
                new Quest("The ${Quest.PLAYER1} that they have to use each planet as a shitty bowling ball to get a pefect bowling game. Okay. Wow  "),
                new Quest("With an echoing crash, the first planet knocks over all the pins. "),
                new Quest("The ${Quest.PLAYER1} gets another strike!"),
                new Quest("The ${Quest.PLAYER1} almost misses a pin, but a secondary explosion going off on the planet tips it over. "),
                new Quest("The ${Quest.PLAYER1} gets another strike! This is going surprisingly well, actually.  Maybe planets just inherently make good bowling balls? "),
                new Quest("The ${Quest.PLAYER1} gets another strike! Wait, don't planets have like, gravity and shit? Maybe they are so good at knocking over pins because of that? "),
                new Quest("The ${Quest.PLAYER1} gets another strike! You try to look closely to see if some sort of planetary gravitational pull is making it easier to knock over pins."),
                new Quest("The ${Quest.PLAYER1} gets another strike! Maybe the pins are just REALLY close together compared to 'regulation' bowling. "),
                new Quest("The ${Quest.PLAYER1} gets another strike! "),
                new Quest("The ${Quest.PLAYER1} gets another strike! Maybe the game is just straight up rigged then? This is BORING but it's not hard at all."),
                new Quest("The ${Quest.PLAYER1} gets the final strike!!! They are officially declared the bowling champion! Congratulations! Now, all they need to do is make their way to the final Boss.  The ${Quest.PLAYER1} barely even cares what sorts of annoying things are in the way, they are so close they can TASTE victory.")
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)
            ,  Theme.SUPERHIGH);

        addTheme(new Theme(<String>["Minesweeper", "Minefields"])
            ..addFeature(FeatureFactory.ROBOTCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.BEEPINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.LOW)
            ..addFeature(rand.pickFrom(boringBullshit), Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.YALDABAOTHDENIZEN, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Find the Mines", [
                new Quest("The ${Quest.PLAYER1} listens with dismay as it is explained to them that each planet has a hidden mine which must be detected based on clues scattered around the planet. The ${Quest.PLAYER1} must clearly mark the mine on the planet before moving on, and this mark will serve as the clue for where the mine is on the next planet.  Needless to say, if the ${Quest.PLAYER1} screws up at any point without realizing it, it will make all OTHER planets wrong too.  Hooray."),
                new Quest("The ${Quest.PLAYER1} finds their first mine! Probably. Here's hoping they didn't screw up here and leave the entire rest of the game unwinnable! "),
                new Quest("The ${Quest.PLAYER1} is about to place their flag down where they think the mine is when ${metaPlayer.chatHandle} starts pestering them. Gah, now they lost their place! Wait....Okay. There you go. Mine secured."),
                new Quest("The ${Quest.PLAYER1} finds another mine. "),
                new Quest("The ${Quest.PLAYER1} thinks they have another mine found. All they have to do is figure out if there's 3 empty spots here and 4 on the other planet...then....YES. They place their flag."),
                new Quest("The ${Quest.PLAYER1} yanks a ${Quest.CONSORTSOUND}ing ${Quest.CONSORT} out of the way before they walk right onto this planet's mine like an asshole."),
                new Quest("You begin to wonder how many different ways there are to say 'The ${Quest.PLAYER1} finds another mine.'"),
                new Quest("The ${Quest.PLAYER1} locates another mine."),
                new Quest("The ${Quest.PLAYER1} discovers a buried explosive device."),
                new Quest("The ${Quest.PLAYER1} ascertains the location of an additional incendiary device."),
                new Quest("You smack the Thesaurus out of JR's hand. The ${Quest.PLAYER1} finds another mine."),
                new Quest("You fondly regard longifcation, which is to say, the beautiful dream of SBURBSim 'too many words' mode. If only it were not too good and pure for this world, then EVERYthing on this page would fear the wrath of JR's thesaurus. In conclusion: The ${Quest.PLAYER1} finds another mine. "),
                new Quest("${metaPlayer.chatHandle} breaks the ${Quest.PLAYER1} concentration just to ask them about windows98. Another mine is found, regardless. "),
                new Quest("The ${Quest.PLAYER1} finds another mine. This would be boring if dealing with mines wasn't so nerve wracking."),
                new Quest("The ${Quest.PLAYER1} finds another mine."),
                new Quest("The ${Quest.PLAYER1} finds the final mine! Holy shit! They are the winner, it is them!  They press the big red button that has taunted them this entire time, and each planet blows up in turn.  There is a nerveracking moment when the third planet's explosion is delayed, but in the end it pull through. The ${Quest.PLAYER1} is finally done with this shitty section of the game!!!")
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)
            , Theme.SUPERHIGH);

        addTheme(new Theme(<String>["Solitaire", "Cards"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.SALAMANDERCONSORT, Feature.HIGH)
            ..addFeature(rand.pickFrom(boringBullshit), Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.YALDABAOTHDENIZEN, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Remove the Cards", [
                new Quest("The ${Quest.PLAYER1} manages to pay attention to the giggle snort long enough to discover that each planet 'card' needs to be removed 'from play', but can only be removed after solving all sort of magical, incredibly bullshit challenges on each land."),
                new Quest("The ${Quest.PLAYER1} removes their first card from play. They...aren't exactly sure how a big round ball counts as a playing card, but they aren't invested enough in this conceit to really debate it."),
                new Quest("The ${Quest.PLAYER1} removes another card from play. It is actually really annoying trying to play a vaguely Solitare game when the planets aren't actually cards. What would this planet even be? An ace?"),
                new Quest("The ${Quest.PLAYER1} removes another card. They have just gotten used to planets = cards at this point."),
                new Quest("The ${Quest.PLAYER1} removes another card and imagines that they are playing a sane game. 52 card pickup, anyone?"),
                new Quest("The ${Quest.PLAYER1} figures out how to contact ${metaPlayer.chatHandle} just to ask them if this latest planet is a ten of spades, or if it's more a 8 of clubs. It feels good to irritate THAT asshole, instead of the other way around. "),
                new Quest("The ${Quest.PLAYER1} wonders how poorly whoever designed this game understood Solitaire. You don't chuck cards into blackholes, you dunkass."),
                new Quest("The ${Quest.PLAYER1} removes another card."),
                new Quest("The ${Quest.PLAYER1} removes another planet. They are briefly rebelling by refusing to cooperate with this whole 'cards' theme."),
                new Quest("The ${Quest.PLAYER1} removes another planet. So there."),
                new Quest("The ${Quest.PLAYER1} removes another card. They are kind of feeling bad about rebelling. If nothing else it is making the ${Quest.CONSORT}s  ${Quest.CONSORTSOUND} way more than usual. They agree to stop. "),
                new Quest("The ${Quest.PLAYER1} removes another card. This actually barely requires any concentration. The ${Quest.PLAYER1} can see why this is normally a 'so bored you are going to pass out' kind of game. "),
                new Quest("The ${Quest.PLAYER1} removes another card."),
                new Quest("The ${Quest.PLAYER1} removes another planet, or is it a card? You briefly curse object duality before remember that that's probably not a thing in this game. "),
                new Quest("The ${Quest.PLAYER1} finds another pumpkin. You mean planet.  By which you mean card. And by find, you mean remove. You don't even care anymore. "),
                new Quest("The ${Quest.PLAYER1} removes another card."),
                new Quest("Holy shit!!! That's the last of the shitty not-cards-but-actually-planets! The ${Quest.PLAYER1} can finally move on!")
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)
            , Theme.SUPERHIGH); // end theme
    }

    //dead themes are just regular themes, but about sports and games and shit.
    void addTheme(Theme t, double weight) {
        themes[t] = weight;
    }



    @override
    void makePlayers() {
        this.players = new List<Player>(1); //it's a list so everything still works, but limited to one player.
        resetAvailableClasspects();

        players[0] = (randomPlayer(this));
        players[0].deriveLand = false;
        players[0].relationships.add(new Relationship(players[0], -999, metaPlayer)); //if you need to talk to anyone, talk to metaplayer.
        metaPlayer.relationships.add(new Relationship(metaPlayer, -999, players[0])); //if you need to talk to anyone, talk to metaplayer.
        metaPlayer.renderSelf();
    }

    void makeDeadLand() {
        Player player = players[0];
        chosenThemesForDeadSession = new Map<Theme, double>();
        Theme deadTheme = rand.pickFrom(themes.keys);

        Theme interest1Theme = rand.pickFrom(player.interest1.category.themes.keys);
        interest1Theme.source = Theme.INTERESTSOURCE;
        Theme interest2Theme = rand.pickFrom(player.interest2.category.themes.keys);
        interest2Theme.source = Theme.INTERESTSOURCE;
        chosenThemesForDeadSession[interest1Theme] = player.interest1.category.themes[interest1Theme];
        chosenThemesForDeadSession[interest2Theme] = player.interest2.category.themes[interest2Theme];
        chosenThemesForDeadSession[deadTheme] = themes[deadTheme];
        print("making a dead land. with themes: ${chosenThemesForDeadSession}");
        players[0].landFuture = new Land.fromWeightedThemes(chosenThemesForDeadSession, this);
    }

    @override
    void makeGuardians() {
        players[0].makeGuardian();
    }

    @override
    String convertPlayerNumberToWords() {
        return "ONE";
    }

    @override
    void randomizeEntryOrder() {
        //does nothing.
    }

}