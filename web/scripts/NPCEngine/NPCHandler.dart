import "../SBURBSim.dart";

//handles spawning and maintaining various npcs.
class NPCHandler
{
    Session session;
    GameEntity king = null;
    GameEntity queen = null;
    GameEntity jack = null;
    GameEntity queensRing = null; //eventually have white and black ones.
    GameEntity kingsScepter = null;
    GameEntity democraticArmy = null;

    NPCHandler(this.session);

    List<GameEntity> get allNPCS {
        return <GameEntity>[jack, king, queen, democraticArmy];
    }


    void spawnQueen() {
        //hope field can fuck with the queen.
        if(session.mutator.spawnQueen(session)) return null;
        this.queensRing = new GameEntity("!!!RING!!! OMG YOU SHOULD NEVER SEE THIS!", session);
        Fraymotif f = new Fraymotif("Red Miles", 3);
        f.effects.add(new FraymotifEffect("power", 2, true));
        f.desc = " You cannot escape them. ";
        this.queensRing.fraymotifs.add(f);

        this.queen = new Carapace("Black Queen", session);
        this.queen.crowned = this.queensRing;
        queen.setStatsHash(<String, num>{Stats.HEALTH: 500, "freeWill": -100, "power": 50});
    }

    void spawnKing() {
        if(session.mutator.spawnKing(session)) return null;
        this.kingsScepter = new GameEntity("!!!SCEPTER!!! OMG YOU SHOULD NEVER SEE THIS!", session);
        Fraymotif f = new Fraymotif("Reckoning Meteors", 3); //TODO eventually check for this fraymotif (just lik you do troll psionics) to decide if you can start recknoing.;
        f.effects.add(new FraymotifEffect("power", 2, true));
        f.desc = " The very meteors from the Reckoning rain down. ";
        this.kingsScepter.fraymotifs.add(f);

        this.king = new Carapace("Black King", session);
        this.king.crowned = this.kingsScepter;

        king.grist = 1000;
        king.setStatsHash(<String, num>{Stats.HEALTH: 1000, "freeWill": -100, "power": 100});
    }

    void spawnJack() {
        if(session.mutator.spawnJack(session)) return null;
        this.jack = new Carapace("Jack", session);
        //minLuck, maxLuck, hp, mobility, sanity, freeWill, power, abscondable, canAbscond, framotifs
        jack.setStatsHash(<String, num>{"minLuck": -500, "maxLuck": 10, "sanity": -100, Stats.HEALTH: 20, "freeWill": -100, "power": 30});
        Fraymotif f = new Fraymotif("Stab To Meet You", 1);
        f.effects.add(new FraymotifEffect("power", 3, true));
        f.desc = " It's pretty much how he says 'Hello'. ";
        this.jack.fraymotifs.add(f);
    }

    void spawnDemocraticArmy() {
        if(session.mutator.spawnDemocraticArmy(session)) return null;
        this.democraticArmy = new Carapace("Democratic Army", session); //doesn't actually exist till WV does his thing.
        Fraymotif f = new Fraymotif("Democracy Charge", 2);
        f.effects.add(new FraymotifEffect("power", 3, true));
        f.desc = " The people have chosen to Rise Up against their oppressors. ";
        this.democraticArmy.fraymotifs.add(f);
    }



    void destroyBlackRing() {
        this.queensRing = null;
        this.jack.crowned = null;
        this.queen.crowned = null;
    }

}