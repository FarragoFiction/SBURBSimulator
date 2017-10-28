import '../SBURBSim.dart';
import "../Lands/FeatureTypes/QuestChainFeature.dart";
import "../Lands/Quest.dart";
import "../Lands/Reward.dart";
import "DeadSessionSummary.dart";
import "../Lands/FeatureTypes/EnemyFeature.dart";
//only one player, player has no sprite, player has DeadLand, and session has 16 (or less) subLands.
class DeadSession extends Session {
    @override
    bool canReckoning = true; // dead sessions can ALWAYS run out of time.

    //TODO any denizen fraymotif should be the caliborn quote
    //page #007356
    // A stupid note is produced, It's the one assholes play to make their audience start punching themselves in the crouch repeatidly
    Map<Theme, double> themes = new Map<Theme, double>();
    Map<Theme, double> chosenThemesForDeadSession =  new Map<Theme, double>();
    int numberLandsRemaining = 16; //can remove some in "the break".
    List<QuestChainFeature> boringBullshit;
    QuestChainFeature victoryLap;
    Player metaPlayer;
    @override
    num minTimeTillReckoning = 350; //just enough time to finish game if you do NOTHING else.
    @override
    num maxTimeTillReckoning = 500;

    //much harder to kill
    @override
    num sessionHealth = 13000 * Stats.POWER.coefficient; //grimDark players work to lower it. at 0, it crashes.  maybe have it do other things at other levels, or effect other things.


    ///number between 0 and 1 to pass DeadQuests
    ///0.9 isn't the same thing as saying 9/10 sessions win. it's saying EVERY sports quest has a 1/10 chance of failing
    /// and there's usually at least ten of them.
    ///
    /// PL: a 1% win chance should be more like 0.63 because it's the tenth root of 0.01... pow(desired chance, 1/number of quests)
    double oddsOfSuccess = 0.8;

    //harsh, but once you fail that's it. no more quests.
    bool failed = false;

    //not to be confused with the land on the player. this would be a pool bar for colors and mayhem
    //lands can only happen once the player's main land has gotten past the first stage.
    Land currentLand;
    DeadSession(int sessionID): super(sessionID) {
        mutator.sessionHealth = 13000 * Stats.POWER.coefficient;
        sessionHealth = mutator.sessionHealth;
        //have a metaplayer BEFORE you make the bullshit quests.
        mutator.metaHandler.initalizePlayers(this);
        metaPlayer = rand.pickFrom(mutator.metaHandler.metaPlayers);
        metaPlayer.setStat(Stats.EXPERIENCE, 1300);
        makeThemes();
        timeTillReckoning = minTimeTillReckoning; //pretty long compared to a normal session, but not 16 times longer. what will you do?
    }

    @override
    SessionSummary generateSummary() {
        return DeadSessionSummary.makeSummaryForSession(this);
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

        victoryLap = new PostDenizenQuestChain("Take your Victory Lap", <Quest>[
            new Quest("The ${Quest.PLAYER1} just needs to find ${Quest.DENIZEN}. How much bullshit will this shitty game manage to make this into? "),
            new DenizenFightQuest("Huh. You kind of thought it was going to be a federal fucking issue, but it turns out ${Quest.DENIZEN} was in the giant dungeon with their face on it. Who knew?", "Welp. This is it. A completed dead session. How the fuck did this happen?", "Oh wow. How the fuck did the ${Quest.PLAYER1} manage to get owned so hard after coming so far?")
        ], new ImmortalityReward(),  QuestChainFeature.defaultOption);
    }

    void makeThemes() {
        makeBoringBullshit();
        addTheme(new Theme(<String>["Billiards","Pool","Stickball", "Colors", "Snooker", "Cues"])
            ..addFeature(FeatureFactory.CHLORINESMELL, Feature.LOW)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(victoryLap, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(rand.pickFrom(boringBullshit), Feature.WAY_HIGH)
            ..addFeature(new DenizenQuestChain("Sink the Balls", [
                new Quest("The ${Quest.PLAYER1} listens as the rules of pool are explained to them. In insufferable detail.  Multiple times. By every single fucking ${Quest.CONSORT} they meet, not just the asshole ${metaPlayer.chatHandle}.  It's almost enough to make them wish the damn things would just stick to ${Quest.CONSORTSOUND}ing. Yes, I GET it you asshole, explode the planets into the center black hole in order. Geez. "),
                new FailableQuest("With an echoing crash, the first planet tumbles into the black hole. ", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} is really getting the hang of this stickball thing.", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Another planet enters the corner pocket.", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Oh shit, that one almost didn't make it into the hole.  ${metaPlayer.chatHandle} is probablly yucking it up somewhere.", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("You start to wonder if these things are actually supposed to be challenging?", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Isn't actual billiards harder than this?", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Another planet enters yet another pocket. Seriously, in real pool you'd be bouncing off other balls and walls and shit.", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Another planet enters yet another pocket. But you guess in real pool you ALSO get more than once chance to get each ball in.", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Another planet careens into yet another pocket.", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Another planet enters yet another pocket. How has this game managed to make EXPLOSIONS boring?", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Another planet enters yet another pocket.", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Another planet enters yet another pocket.", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Another planet enters the shitty black hole. Wow. This is really getting repetitve.", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Like, you can barely make your eyes focus enough to read these things.", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("Can you imagine having to LIVE through all these shitt planets being destroyed?", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} sinks the 8 ball! They are officially declared the pool champion! Congratulations! Now, all they need to do is make their way to the final Boss.  The ${Quest.PLAYER1} barely even cares what sorts of annoying things are in the way, they are so close they can TASTE victory.", "The ${Quest.PLAYER1} fails to pocket the planet. A perfect game is no longer possible.", oddsOfSuccess)
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)
            ,  Theme.SUPERHIGH);

        addTheme(new Theme(<String>["Bowling","Pins","Heavy Balls", "Gutters"])
            ..addFeature(FeatureFactory.FEETSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(rand.pickFrom(boringBullshit), Feature.WAY_HIGH)
            ..addFeature(victoryLap, Feature.WAY_HIGH)
            ..addFeature(new DenizenQuestChain("Knock Over the Pins", [
                new Quest("The ${Quest.PLAYER1} learns that they have to use each planet as a shitty bowling ball to get a pefect bowling game. Okay. Wow  " ),
                new FailableQuest("With an echoing crash, the first planet knocks over all the pins. ", "The ${Quest.PLAYER1} gets a gutter ball. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} gets another strike!", "The ${Quest.PLAYER1} gets a gutter ball. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} almost misses a pin, but a secondary explosion going off on the planet tips it over. ", "The ${Quest.PLAYER1} gets a gutter ball. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} gets another strike! This is going surprisingly well, actually.  Maybe planets just inherently make good bowling balls? ", "The ${Quest.PLAYER1} gets a gutter ball. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} gets another strike! Wait, don't planets have like, gravity and shit? Maybe they are so good at knocking over pins because of that? ", "The ${Quest.PLAYER1} gets a gutter ball. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} gets another strike! You try to look closely to see if some sort of planetary gravitational pull is making it easier to knock over pins.", "The ${Quest.PLAYER1} gets a gutter ball. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} gets another strike! Maybe the pins are just REALLY close together compared to 'regulation' bowling. ", "The ${Quest.PLAYER1} gets a gutter ball. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} gets another strike! ", "The ${Quest.PLAYER1} gets a gutter ball. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} gets another strike! Maybe the game is just straight up rigged then? This is BORING but it's not hard at all.", "The ${Quest.PLAYER1} gets a gutter ball. A perfect game is no longer possible.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} gets the final strike!!! They are officially declared the bowling champion! Congratulations! Now, all they need to do is make their way to the final Boss.  The ${Quest.PLAYER1} barely even cares what sorts of annoying things are in the way, they are so close they can TASTE victory.", "The ${Quest.PLAYER1} gets a gutter ball. A perfect game is no longer possible.", oddsOfSuccess)
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)
            ,  Theme.SUPERHIGH);

        addTheme(new Theme(<String>["Minesweeper", "Minefields"])
            ..addFeature(FeatureFactory.ROBOTCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.BEEPINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.LOW)
            ..addFeature(rand.pickFrom(boringBullshit), Feature.WAY_HIGH)
            ..addFeature(victoryLap, Feature.WAY_HIGH)
            ..addFeature(new DenizenQuestChain("Find the Mines", [
                new Quest("The ${Quest.PLAYER1} listens with dismay as it is explained to them that each planet has a hidden mine which must be detected based on clues scattered around the planet. The ${Quest.PLAYER1} must clearly mark the mine on the planet before moving on, and this mark will serve as the clue for where the mine is on the next planet.  Needless to say, if the ${Quest.PLAYER1} screws up at any point without realizing it, it will make all OTHER planets wrong too.  Hooray."),
                new FailableQuest("The ${Quest.PLAYER1} finds their first mine! Probably. Here's hoping they didn't screw up here and leave the entire rest of the game unwinnable! ", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} is about to place their flag down where they think the mine is when ${metaPlayer.chatHandle} starts pestering them. Gah, now they lost their place! Wait....Okay. There you go. Mine secured.", "The ${Quest.PLAYER1} is careless and explodes a planet too early.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} finds another mine. ", "The ${Quest.PLAYER1} is careless and explodes a planet too early.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} thinks they have another mine found. All they have to do is figure out if there's 3 empty spots here and 4 on the other planet...then....YES. They place their flag.", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} yanks a ${Quest.CONSORTSOUND}ing ${Quest.CONSORT} out of the way before they walk right onto this planet's mine like an asshole.", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess),
                new FailableQuest("You begin to wonder how many different ways there are to say 'The ${Quest.PLAYER1} finds another mine.'", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} locates another mine.", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} discovers a buried explosive device.", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} ascertains the location of an additional incendiary device.", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess),
                new FailableQuest("You smack the Thesaurus out of JR's hand. The ${Quest.PLAYER1} finds another mine.", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess),
                new FailableQuest("You fondly regard longifcation, which is to say, the beautiful dream of SBURBSim 'too many words' mode. If only it were not too good and pure for this world, then EVERYthing on this page would fear the wrath of JR's thesaurus. In conclusion: The ${Quest.PLAYER1} finds another mine. ", "The ${Quest.PLAYER1} is careless and explodes a planet too early.", oddsOfSuccess),
                new FailableQuest("${metaPlayer.chatHandle} breaks the ${Quest.PLAYER1} concentration just to ask them about windows98. Another mine is found, regardless. ", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} finds another mine. This would be boring if dealing with mines wasn't so nerve wracking.", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} finds another mine.", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} finds the final mine! Holy shit! They are the winner, it is them!  They press the big red button that has taunted them this entire time, and each planet blows up in turn.  There is a nerveracking moment when the third planet's explosion is delayed, but in the end it pull through. The ${Quest.PLAYER1} is finally done with this shitty section of the game!!!", "The ${Quest.PLAYER1} is careless and explodes the planet too early.", oddsOfSuccess)
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)
            , Theme.SUPERHIGH);

        addTheme(new Theme(<String>["Solitaire", "Cards"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.SALAMANDERCONSORT, Feature.HIGH)
            ..addFeature(rand.pickFrom(boringBullshit), Feature.WAY_HIGH)
            ..addFeature(victoryLap, Feature.WAY_HIGH)
            ..addFeature(new HardDenizenFeature("temp"), Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Remove the Cards", [
                new FailableQuest("The ${Quest.PLAYER1} manages to pay attention to the giggle snort long enough to discover that each planet 'card' needs to be removed 'from play', but can only be removed after solving all sort of magical, incredibly bullshit challenges on each land.", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes their first card from play. They...aren't exactly sure how a big round ball counts as a playing card, but they aren't invested enough in this conceit to really debate it.", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes another card from play. It is actually really annoying trying to play a vaguely Solitare game when the planets aren't actually cards. What would this planet even be? An ace?", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes another card. They have just gotten used to planets = cards at this point.", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes another card and imagines that they are playing a sane game. 52 card pickup, anyone?", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} figures out how to contact ${metaPlayer.chatHandle} just to ask them if this latest planet is a ten of spades, or if it's more a 8 of clubs. It feels good to irritate THAT asshole, instead of the other way around. ", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} wonders how poorly whoever designed this game understood Solitaire. You don't chuck cards into blackholes, you dunkass.", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes another card.", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes another planet. They are briefly rebelling by refusing to cooperate with this whole 'cards' theme.", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes another planet. So there.", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes another card. They are kind of feeling bad about rebelling. If nothing else it is making the ${Quest.CONSORT}s  ${Quest.CONSORTSOUND} way more than usual. They agree to stop. ", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes another card. This actually barely requires any concentration. The ${Quest.PLAYER1} can see why this is normally a 'so bored you are going to pass out' kind of game. ", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes another card.", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes another planet, or is it a card? You briefly curse object duality before remember that that's probably not a thing in this game. ", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} finds another pumpkin. You mean planet.  By which you mean card. And by find, you mean remove. You don't even care anymore. ", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("The ${Quest.PLAYER1} removes another card.", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess),
                new FailableQuest("Holy shit!!! That's the last of the shitty not-cards-but-actually-planets! The ${Quest.PLAYER1} can finally move on!", "The ${Quest.PLAYER1} is careless and makes an important planet impossible to remove.", oddsOfSuccess)
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
        int numPlayers = this.rand.nextIntRange(2, 12); //rand.nextIntRange(2,12);
        double special = rand.nextDouble();
        players[0] = (randomPlayer(this));

        //random chance of Lord/Muse for natural two player sessions, even if they become dead
        if(numPlayers <= 2) {
            print("less than 2 players");
            if(special > .6) {
                players[0].class_name = SBURBClassManager.LORD;
            }else if(special < .3) {
                players[0].class_name = SBURBClassManager.MUSE;
            }
        }

        players[0].deriveLand = false;
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
        players[0].land = new Land.fromWeightedThemes(chosenThemesForDeadSession, this, players[0].aspect,players[0].class_name);
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

    //unlike regular sessions there is no way to fail this.
    @override
    Session initializeCombinedSession() {
        this.aliensClonedOnArrival = <Player>[]; //PROBABLY want to do this.
        List<Player> living = findLivingPlayers(this.players);
        living.add((curSessionGlobalVar as DeadSession).metaPlayer);
        //nobody is the leader anymore.
        Session newSession = new Session(this.rand.nextInt()); //Math.seed);  //this is a real session that could have gone on without these new players.
        newSession
            ..currentSceneNum = this.currentSceneNum
            ..afterLife = this.afterLife //afterlife carries over.
            ..stats.dreamBubbleAfterlife = this.stats.dreamBubbleAfterlife //this, too
            ..reinit()
            ..makePlayers()
            ..randomizeEntryOrder()
            ..makeGuardians();

        addAliensToSession(newSession, this.players); //used to only bring players, but that broke shipping. shipping is clearly paramount to Skaia, because everything fucking crashes if shipping is compromised.

        this.stats.hadCombinedSession = true;
        newSession.parentSession = this;
        Scene.createScenesForSession(newSession);
        return newSession;
    }

}