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
    int numberLandsRemaining = 16; //can remove some in "the break".
    List<QuestChainFeature> boringBullshit;
    //not to be confused with the land on the player. this would be a pool bar for colors and mayhem
    //lands can only happen once the player's main land has gotten past the first stage.
    Land currentLand;
    DeadSession(int sessionID): super(sessionID) {
        makeThemes();
    }

    //no reward for your boring bullshit. make quest chains so stupidly long too.
    //also, normally quests will be custom per theme, but not for boring bullshit.
    //http://www.mspaintadventures.com/?s=6&p=007682  thanks to nobody for finding this page for me to be inspired by
    void makeBoringBullshit() {
        boringBullshit = new List<QuestChainFeature>()
        ..add(new PreDenizenQuestChain("Find Bullshit Keys", <Quest>[
            new Quest("The PLAYER1 finds another key under a random ass unlabeled stone."),
            new Quest("Oh, look, another random ass unlabeled stone, another key. The PLAYER1 almost didn't feel despair that time!"),
            new Quest("test1")
        ], null))
        ..add(new PreDenizenQuestChain("Count Bullshit Bugs", <Quest>[
            new Quest("Holy fuck, just...hold still you asshole bugs! How are you supposed to count these things?"),
            new Quest("The PLAYER1 knocks over the jar containing the counted bugs. OH MY FUCKING GOD they have to start back over."),
            new Quest("test1")
        ], null))
        ..add(new PreDenizenQuestChain("Collect Bullshit Rocks", <Quest>[
            new Quest("test1"),
            new Quest("test1"),
            new Quest("test1")
        ], null));
    }

    void makeThemes() {
        makeBoringBullshit();
        addTheme(new Theme(<String>["Billiards","Pool","Stickball", "Colors"])
            ..addFeature(FeatureFactory.CHLORINESMELL, Feature.LOW)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(rand.pickFrom(boringBullshit), Feature.HIGH)
            ,  Theme.SUPERHIGH);
        addTheme(new Theme(<String>["Minesweeper", "Minefields"])
            ..addFeature(FeatureFactory.ROBOTCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.BEEPINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.LOW)
            ..addFeature(rand.pickFrom(boringBullshit), Feature.HIGH)
            , Theme.SUPERHIGH);

        addTheme(new Theme(<String>["Solitaire", "Cards"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.SALAMANDERCONSORT, Feature.HIGH)
            ..addFeature(rand.pickFrom(boringBullshit), Feature.HIGH)
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
    }

    void makeDeadLand() {
        Player player = players[0];
        Map<Theme, double> themesMap = new Map<Theme, double>();
        Theme deadTheme = rand.pickFrom(themes.keys);

        Theme interest1Theme = rand.pickFrom(player.interest1.category.themes.keys);
        interest1Theme.source = Theme.INTERESTSOURCE;
        Theme interest2Theme = rand.pickFrom(player.interest2.category.themes.keys);
        interest2Theme.source = Theme.INTERESTSOURCE;
        themesMap[interest1Theme] = player.interest1.category.themes[interest1Theme];
        themesMap[interest2Theme] = player.interest2.category.themes[interest2Theme];
        themesMap[deadTheme] = themes[deadTheme];
        //TODO when have quest chains done make sure they can handle not being given class or aspect
        players[0].landFuture = new Land.fromWeightedThemes(themesMap, this);
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