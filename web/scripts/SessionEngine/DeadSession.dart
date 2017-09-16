import '../SBURBSim.dart';

//only one player, player has no sprite, player has DeadLand, and session has 16 (or less) subLands.
class DeadSession extends Session {
    Map<Theme, double> themes = new Map<Theme, double>();
    DeadSession(int sessionID): super(sessionID) {
        makeThemes();
    }

    void makeThemes() {
        addTheme(new Theme(<String>["Billiards","Pool","Stickball"])
            ..addFeature(FeatureFactory.CHLORINESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ,  Theme.SUPERHIGH);
        addTheme(new Theme(<String>["Minesweeper"])
            ..addFeature(FeatureFactory.ROBOTCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.BEEPINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.LOW)
            , Theme.SUPERHIGH);

        addTheme(new Theme(<String>["Solitaire"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.NOTHINGSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SALAMANDERCONSORT, Feature.HIGH)
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