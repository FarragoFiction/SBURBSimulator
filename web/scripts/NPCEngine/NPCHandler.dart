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

    List<GameEntity> midnightCrew = new List<GameEntity>();
    List<GameEntity> sunshineTeam = new List<GameEntity>();
    List<GameEntity> randomDersites = new List<GameEntity>();
    List<GameEntity> randomProspitians = new List<GameEntity>();



    NPCHandler(this.session) {
        setupNpcs();
    }

    void setupNpcs() {
        //for now, leave jack where he is and just have a second copy of him here. deal with it.
        //not gonna rip out existing 'shenannigans' system till i have a new one in place
        //TODO eventually the carapaces have a scene attached to them that they either add
        //TODO to the npc or player scene list when activated, or a companions
        //TODO jacks' replacement stabs scene will be able to stab any player OR npc, full on strife
        initMidnightCrew();
        initrandomDersites();
        initrandomProspitians();
        initSunshineTeam();
    }

    void initMidnightCrew() {
        //print ("initializing midnight crew");
        midnightCrew.add(new Carapace("Jack Noir", session, Carapace.DERSE, firstNames: <String>["Spades","Septuple","Seven"], lastNames: <String>["Slick", "Shanks","Shankmaster","Snake"], ringFirstNames: <String>["Sovereign"], ringLastNames: <String>["Slayer"])
        ..specibus = new Specibus("Knife", ItemTraitFactory.KNIFE, [ ItemTraitFactory.JACKLY])
        ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -500, Stats.MAX_LUCK: 10, Stats.SANITY: -100, Stats.HEALTH: 20, Stats.FREE_WILL: -100, Stats.POWER: 30})
        );

        midnightCrew.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Courtyard","Clubs","Curious"], lastNames: <String>["Deuce","Droll","Dabbler"], ringFirstNames: <String>["Crowned","Capering","Chaotic"], ringLastNames: <String>["Destroyer","Demigod"])
            ..specibus = new Specibus("Bomb", ItemTraitFactory.GRENADE, [ ItemTraitFactory.EXPLODEY])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 500, Stats.MAX_LUCK: 500, Stats.SANITY: 100, Stats.HEALTH: 20, Stats.FREE_WILL: 100, Stats.POWER: 15})
        );

        midnightCrew.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Diamonds","Draconian","Dignified"], lastNames: <String>["Droog","Dignitary","Diplomat"], ringFirstNames: <String>["Dashing","Dartabout","Derelict"], ringLastNames: <String>["Destroyer","Demigod"])
            ..specibus = new Specibus("Knife", ItemTraitFactory.KNIFE, [ ItemTraitFactory.EDGED, ItemTraitFactory.CLASSY])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 100, Stats.SANITY: 500, Stats.HEALTH: 20, Stats.FREE_WILL: 0, Stats.POWER: 20})
        );

        midnightCrew.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Hearts","Hegemonic","Horse"], lastNames: <String>["Brute","Boxcar","Bartender"], ringFirstNames: <String>["Hero-killing","Hateful"], ringLastNames: <String>["Beast","Bastard"])
            ..specibus = new Specibus("Fist", ItemTraitFactory.FIST, [ ItemTraitFactory.BLUNT])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 0, Stats.SANITY: 0, Stats.HEALTH: 500, Stats.FREE_WILL: 0, Stats.POWER: 500})
        );

        /*
        midnightCrew.add(new Carapace(null, session, firstNames: <String>[], lastNames: <String>[], ringFirstNames: <String>[], ringLastNames: <String>[])
        ..specibus = new Specibus("Knife", ItemTraitFactory.KNIFE, [ ItemTraitFactory.JACKLY])
        ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -500, Stats.MAX_LUCK: 10, Stats.SANITY: -100, Stats.HEALTH: 20, Stats.FREE_WILL: -100, Stats.POWER: 30})
        );
         */


    }

    void initSunshineTeam() {

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Problem","Paramount","Patriotic"], lastNames: <String>["Sleuth","Secretary","Steward"], ringFirstNames: <String>["Paragon","Promised"], ringLastNames: <String>["Sherrif","Savior"])
            ..specibus = new Specibus("Tommy gun", ItemTraitFactory.MACHINEGUN, [ ItemTraitFactory.SHOOTY])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -100, Stats.MAX_LUCK: 100, Stats.SANITY: -100, Stats.HEALTH: 20, Stats.FREE_WILL: 200, Stats.POWER: 15})
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Persistent","Pickle","Persnickety"], lastNames: <String>["Inspector","Innovator","Investegator"], ringFirstNames: <String>["Patient","Peaceful"], ringLastNames: <String>["Idol"])
            ..specibus = new Specibus("Handgun", ItemTraitFactory.PISTOL, [ ItemTraitFactory.SHOOTY])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -100, Stats.MAX_LUCK: 100, Stats.SANITY: 100, Stats.HEALTH: 1, Stats.FREE_WILL: 500, Stats.POWER: 1})
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Ace","Audacious","Asshole"], lastNames: <String>["Detective","Dwarf","Dick"], ringFirstNames: <String>["Ascended"], ringLastNames: <String>["Demon","Destroyer"])
            ..specibus = new Specibus("Fist", ItemTraitFactory.FIST, [ ItemTraitFactory.BLUNT])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 0, Stats.SANITY: -500, Stats.HEALTH: 100, Stats.FREE_WILL: 100, Stats.POWER: 100})
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Hysterical","Haunting","Honored"], lastNames: <String>["Dame","Dancer","Debutante"], ringFirstNames: <String>["Hazardous"], ringLastNames: <String>["Demoness"])
            ..specibus = new Specibus("Lipstick Chainsaw", ItemTraitFactory.CHAINSAW, [ ItemTraitFactory.EDGED])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 500, Stats.MAX_LUCK: 500, Stats.SANITY: 100, Stats.HEALTH: 20, Stats.FREE_WILL: 100, Stats.POWER: 15})
        );

        sunshineTeam.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Nervous","Naive","Nice"], lastNames: <String>["Broad","Bird","Bartender"], ringFirstNames: <String>["Notorious","Never-ending"], ringLastNames: <String>["Bard","Bloodshed"])
            ..specibus = new Specibus("Flamethrower", ItemTraitFactory.PISTOL, [ ItemTraitFactory.ONFIRE])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: 0, Stats.MAX_LUCK: 0, Stats.SANITY: -500, Stats.HEALTH: 1, Stats.FREE_WILL: 100, Stats.POWER: 1})
        );

    }

    void initrandomDersites() {

        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Authority","Aimless"], lastNames: <String>["Regulator","Renegade"], ringFirstNames: <String>["Ascendant"], ringLastNames: <String>["Rioter"])
            ..specibus = new Specibus("Machine Gun", ItemTraitFactory.MACHINEGUN, [ ItemTraitFactory.SHOOTY])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
        );

        randomDersites.add(new Carapace(null, session,Carapace.DERSE, firstNames: <String>["Wayward","Wizardly","Warweary"], lastNames: <String>["Vagrant","Villain","Vassal","Villager"], ringFirstNames: <String>["Wicked"], ringLastNames: <String>["Villian"])
            ..specibus = new Specibus("Sword", ItemTraitFactory.SWORD, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
        );

    }

    void initrandomProspitians() {

        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Royal","Regal","Rolling"], lastNames: <String>["Baker","Breakmaker"], ringFirstNames: <String>["Rampaging"], ringLastNames: <String>["Butcher"])
            ..specibus = new Specibus("Rolling Pin", ItemTraitFactory.ROLLINGPIN, [ ItemTraitFactory.BLUNT, ItemTraitFactory.WOOD])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
        );

        randomProspitians.add(new Carapace(null, session,Carapace.PROSPIT, firstNames: <String>["Parcel","Perigrine","Postal"], lastNames: <String>["Mistress","Mendicate","Mailer"], ringFirstNames: <String>["Punititve"], ringLastNames: <String>["Marauder"])
            ..specibus = new Specibus("Sword", ItemTraitFactory.SWORD, [ ItemTraitFactory.EDGED, ItemTraitFactory.METAL])
            ..stats.setMap(<Stat, num>{Stats.MIN_LUCK: -10, Stats.MAX_LUCK: 10, Stats.SANITY: 10, Stats.HEALTH: 10, Stats.FREE_WILL: 0, Stats.POWER: 10})
        );

    }

    List<GameEntity> get allNPCS {
        List<GameEntity> ret =  <GameEntity>[jack, king, queen, democraticArmy];
        ret .addAll(midnightCrew);
        ret .addAll(sunshineTeam);
        ret .addAll(randomDersites);
        ret .addAll(randomProspitians);
        return ret;
    }


    void spawnQueen() {
       //print("spawning queen $session");
        //hope field can fuck with the queen.
        if(session.mutator.spawnQueen(session)) return null;
        this.queensRing = new GameEntity("!!!RING!!! OMG YOU SHOULD NEVER SEE THIS!", session);
        Fraymotif f = new Fraymotif("Red Miles", 3);
        f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
        f.desc = " You cannot escape them. ";
        this.queensRing.fraymotifs.add(f);

        this.queen = new Carapace("Black Queen", session,Carapace.DERSE);
        this.queen.specibus = new Specibus("Blade", ItemTraitFactory.BLADE, [ ItemTraitFactory.QUEENLY]);
        this.queen.crowned = this.queensRing;
        queen.stats.setMap(<Stat, num>{Stats.HEALTH: 500, Stats.FREE_WILL: -100, Stats.POWER: 50});
        queen.heal();
    }

    void spawnKing() {
        if(session.mutator.spawnKing(session)) return null;
        this.kingsScepter = new GameEntity("!!!SCEPTER!!! OMG YOU SHOULD NEVER SEE THIS!", session);
        Fraymotif f = new Fraymotif("Reckoning Meteors", 3); //TODO eventually check for this fraymotif (just lik you do troll psionics) to decide if you can start recknoing.;
        f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
        f.desc = " The very meteors from the Reckoning rain down. ";
        this.kingsScepter.fraymotifs.add(f);

        this.king = new Carapace("Black King", session,Carapace.DERSE);
        this.queen.specibus = new Specibus("Scepter", ItemTraitFactory.STICK, [ ItemTraitFactory.KINGLY]);

        this.king.crowned = this.kingsScepter;

        king.grist = 1000;
        king.stats.setMap(<Stat, num>{Stats.HEALTH: 1000, Stats.FREE_WILL: -100, Stats.POWER: 100});
        king.heal();
    }

    void spawnJack() {
        if(session.mutator.spawnJack(session)) return null;
        this.jack = new Carapace("Jack", session,Carapace.DERSE);
        this.jack.specibus = new Specibus("Knife", ItemTraitFactory.KNIFE, [ ItemTraitFactory.JACKLY]);

        //minLuck, maxLuck, hp, mobility, sanity, freeWill, power, abscondable, canAbscond, framotifs
        jack.stats.setMap(<Stat, num>{Stats.MIN_LUCK: -500, Stats.MAX_LUCK: 10, Stats.SANITY: -100, Stats.HEALTH: 20, Stats.FREE_WILL: -100, Stats.POWER: 30});
        Fraymotif f = new Fraymotif("Stab To Meet You", 1);
        f.effects.add(new FraymotifEffect(Stats.POWER, 3, true));
        f.desc = " It's pretty much how he says 'Hello'. ";
        jack.heal();
        this.jack.fraymotifs.add(f);
    }

    void spawnDemocraticArmy() {
        if(session.mutator.spawnDemocraticArmy(session)) return null;
        this.democraticArmy = new Carapace("Democratic Army", session,Carapace.DERSE); //doesn't actually exist till WV does his thing.
        Fraymotif f = new Fraymotif("Democracy Charge", 2);
        f.effects.add(new FraymotifEffect(Stats.POWER, 3, true));
        f.desc = " The people have chosen to Rise Up against their oppressors. ";
        this.democraticArmy.fraymotifs.add(f);
    }



    void destroyBlackRing() {
        this.queensRing = null;
        this.jack.crowned = null;
        this.queen.crowned = null;
    }


}