import "../SBURBSim.dart";
//all static
typedef void SessionSource(Session session, Player player, int index);
/*
    80000008 -insipidTestimony
    730 - SBURBNeta
    20082015 -RL
    404 - cynicalTeuthida
    4037 - ???
    225 - MLH's friends
 */
abstract class NonCanonSessions {

    static Map<int, dynamic> get sessionMap {
        Map<int, dynamic> ret = new Map<int, dynamic>();
        ret[4037] = session4037; //???
        ret[80000008] = session80000008; //insipidTestimony
        ret[730] = session730; //SBURBNeta
        ret[20082015] = session20082015; //RL
        ret[404] = session404; //cynicalTeuthida
        ret[225] = session225; //MLH's friends
        return ret;
    }

    //does nothing if it's not a saved session
    static void callSession(Session session, int id) {
        Map<int, dynamic> sm = sessionMap;
        if (sm.containsKey(id)) {
            sm[id](session);
        }
    }

    //yes, this WILL crash in a regular session, how did you know?
    static void session4037(Session session) {
        session.mutator.metaHandler.initalizePlayers(new Session(13),true);
        session.players = <Player>[session.mutator.metaHandler.feudalUltimatum];
        session.players.length = 1; //no more, no less.
        session.players[0].setStat(Stats.EXPERIENCE, 1300);
    }


    //Session for MLH and his friends.
    static void session225(Session session) {
        int numPlayers = 5;
        makeASessionFromSource(session,session225IndexToPlayer, numPlayers);
        session.players.length = numPlayers; //more, or less
        Player fi = session.players[0]; //chathandles
        Player da = session.players[1];
        Player ej = session.players[2];
        Player nb = session.players[3];
        Player lb = session.players[4]; //F1X TH1S!
        Player hb = session.players[5]; //humanBot
        //Player la = session.players[6]; //LA, joke character 1 hp. {?}
    }

    static void session225IndexToPlayer(Session session, Player player, int index){
        Session s = session;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        if(index == 0){
            player.isTroll = false;
            player.hairColor = "#d8cd08";
            player.bloodColor = "#ff0000";
            player.class_name = SBURBClassManager.KNIGHT;
            player.godDestiny = true;
            player.godTier = true;
            player.aspect = Aspects.LIFE; //Placeholder (?) for Juice (or Closet)
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Straw", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.hair  =1;
            player.chatHandle = "forgetfulIdealist";

            player.interest1 = new Interest("Coding", InterestManager.TECHNOLOGY);
            player.interest2 = new Interest("Drawing", InterestManager.CULTURE);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [["teh", "the"]];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of AIs and Regrowth";
            player.land.denizenFeature = new DenizenFeature('Demeter');

            player.moon = session.prospit;
        }else if(index == 1){
            player.isTroll = false;
            player.bloodColor = "#ff0000";
            player.hairColor = "#05bad6";
            player.class_name = SBURBClassManager.SMITH; //Maybe not. IDK
            player.godDestiny = true;
            player.godTier = true;
            player.aspect = Aspects.DOOM; //Placeholder for Rain
            player.hair  =6;
            player.leftHorn = 57;
            player.rightHorn = 57;
            player.chatHandle = "demonicActivist";
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Bad Fanfiction", s); //Jokes Galore
            player.sprite.addPrototyping(player.object_to_prototype);
            player.interest1 = new Interest("Intimidation", InterestManager.TERRIBLE);
            player.interest2 = new Interest("War", InterestManager.TERRIBLE);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Violence and Madness";
            player.land.denizenFeature = new DenizenFeature('Mania');

            player.moon = session.derse;
        }else if(index == 2){
            player.isTroll = false;
            player.bloodColor = "#ff0000";
            player.hairColor = "#ae7616";
            player.class_name = SBURBClassManager.SEER;
            player.godDestiny = true;
            player.godTier = true;
            player.aspect = Aspects.SPACE;
            player.hair  =4;
            player.leftHorn = 64;
            player.rightHorn = 64;
            player.chatHandle = "electricJuggernaut";
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Zebra", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.interest1 = new Interest("Playing Guitar", InterestManager.MUSIC);
            player.interest2 = new Interest("Programming", InterestManager.TECHNOLOGY);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.leftMurderMode = true;
            player.land = player.spawnLand();
            player.land.name = "Land of Stars and Patterns";
            player.land.denizenFeature = new EasyDenizenFeature('Morpheus'); //Sorry, I thought it would be funny

            player.moon = session.prospit;
        }else if(index == 3){
            player.isTroll = false;
            player.bloodColor = "#ff0000";
            player.hairColor = "#010100";
            player.class_name = SBURBClassManager.SYLPH;
            player.godDestiny = true;
            player.godTier = true;
            player.aspect = Aspects.TIME; //Placeholder for Rhyme
            player.hair  =33;
            player.leftHorn = 4;
            player.rightHorn = 6;
            player.chatHandle = "niceBoi";
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("zBox", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.interest1 = new Interest("Gaming", InterestManager.CULTURE);
            player.interest2 = new Interest("Literature", InterestManager.CULTURE);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Patience and Quiet";
            player.land.denizenFeature = new HardDenizenFeature('Chronos');

            player.moon = session.prospit;

        }else if(index == 4) { //No character information
            /*player.isTroll = false;
            player.bloodColor = "#ff0000";
            player.hairColor = "#010100";
            player.class_name = SBURBClassManager.SYLPH;
            player.godDestiny = true;
            player.godTier = true;
            player.aspect = Aspects.TIME; //Placeholder for Rhyme
            player.hair  =33;
            player.leftHorn = 4;
            player.rightHorn = 6;
            player.chatHandle = "niceBoi";
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Nemetona", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.interest1 = new Interest("Gaming", InterestManager.CULTURE);
            player.interest2 = new Interest("Literature", InterestManager.CULTURE);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Patience and Quiet";
            player.land.denizenFeature = new HardDenizenFeature('Chronos');

            player.moon = session.prospit;*/

        }else if(index == 5) {
            player.robot = true;

            player.isTroll = false;
            player.bloodColor = "#0021cb";
            player.hairColor = "#8f8803";
            player.class_name = SBURBClassManager.SCRIBE;
            player.godDestiny = true;
            player.godTier = true;
            player.aspect = Aspects.LIFE; //Placeholder for Juice
            player.hair  =1;
            player.leftHorn = 4;
            player.rightHorn = 6;
            player.chatHandle = "humanBot";
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Sunglasses", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.interest1 = new Interest("Robots", InterestManager.TECHNOLOGY);
            player.interest2 = new Interest("Writing", InterestManager.CULTURE); //Placeholder for something
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Life and Fruit";
            player.land.denizenFeature = new HardDenizenFeature('Persephone');

            player.moon = session.prospit;

        }

    }



    //from patron cynicalTeuthida: thanks for your support!!!
    static void session404(Session session) {
        int numPlayers = 8;
        makeASessionFromSource(session,session404IndexToPlayer, numPlayers);
        session.players.length = numPlayers; //no more, no less.
        Player ap  = session.players[0];
        Player at = session.players[1];
        Player pa = session.players[2];
        Player tt = session.players[3];
        Player pp  = session.players[4];
        Player pm = session.players[5];
        Player aa = session.players[6];
        Player mm = session.players[7];

        /*TT <> PP is a confirmed ship
         AP <3 PM is a confirmed ship
          AT <> PA is a crush
          AA <> MM is a crush
           MM <3 AT is a one-sided crush on MM's side, but AT finds MM abhorrent
            PA <3< PM is a mutual crush
          */
        Relationship.makeDiamonds(tt,pp);
        tt.getRelationshipWith(pp).value = 20;
        pp.getRelationshipWith(tt).value = 20;

        Relationship.makeHeart(ap,pm);
        ap.getRelationshipWith(pm).value = 20;
        pm.getRelationshipWith(ap).value = 20;

        at.getRelationshipWith(pa).value = 20;
        pa.getRelationshipWith(at).value = 20;

        aa.getRelationshipWith(mm).value = 20;
        mm.getRelationshipWith(aa).value = 20;

        mm.getRelationshipWith(at).value = 20;
        at.getRelationshipWith(mm).value = -20;

        pa.getRelationshipWith(pm).value = -20;
        pm.getRelationshipWith(pa).value = -20;
    }



    //from patron insipidTestimony: thanks for your support!!!
    static void session80000008(Session session) {
        int numPlayers = 4;
        makeASessionFromSource(session,session80000008IndexToPlayer, numPlayers);
        Player it  = session.players[0];
        Player vk = session.players[1];
        Player nc = session.players[2];
        Player ca = session.players[3];


        Relationship refactor = new Relationship(it,0); //it would be WAY too much work to make these static.

        it.getRelationshipWith(nc).value = 20;
        it.getRelationshipWith(vk).value = 20;
        it.getRelationshipWith(ca).value = 20;
        ca.getRelationshipWith(nc).value = 20;
        ca.getRelationshipWith(vk).value = 20;


        Relationship.makeDiamonds(it,nc);
        Relationship.makeHeart(it,vk);

        Relationship.makeDiamonds(it,ca);
        Relationship.makeDiamonds(nc,ca);
        Relationship.makeDiamonds(vk,ca);



        session.players.length = numPlayers; //no more, no less.
    }

    //from patron RL: thanks for your support!!!
    static void session20082015(Session session) {
        int numPlayers = 6;
        makeASessionFromSource(session,session20082015IndexToPlayer, numPlayers);

        Player p1  = session.players[0];
        Player p2 = session.players[1];
        Player p3 = session.players[2];
        Player p4 = session.players[3];
        Player p5 = session.players[4];
        Player p6 = session.players[5];

        Relationship refactor = new Relationship(p1,0); //it would be WAY too much work to make these static.

        p1.getRelationshipWith(p3).value = 20;
        p1.getRelationshipWith(p3).saved_type = refactor.goodBig;

        Relationship.makeDiamonds(p2,p1);
        p2.getRelationshipWith(p1).value = 20;
        p1.getRelationshipWith(p2).value = 20;
        p2.getRelationshipWith(p3).value = 20;
        p2.getRelationshipWith(p3).saved_type = refactor.goodBig;

        p3.getRelationshipWith(p4).value = 20;
        p4.getRelationshipWith(p3).value = 20;
        p3.getRelationshipWith(p4).saved_type = refactor.goodBig;
        p4.getRelationshipWith(p3).saved_type = refactor.goodBig;
        p3.getRelationshipWith(p1).value = 1;
        p3.getRelationshipWith(p2).value = 1;
        p3.getRelationshipWith(p1).saved_type = refactor.goodMild;
        p3.getRelationshipWith(p2).saved_type = refactor.goodMild;


        Relationship.makeDiamonds(p5,p6);
        p5.getRelationshipWith(p6).value = 20;
        p6.getRelationshipWith(p5).value = 20;


        session.players.length = numPlayers; //no more, no less.
    }

    //tell me how to turn player num into a player and how many players there are and i'll do the heavy lifting of setting up the session
    static void makeASessionFromSource(Session session, SessionSource playerFunction, int numPlayers) {
        //add the correct amount of extra players
        for(int i = 0; i<numPlayers; i++){
            Player player;
            Player guardian;
            if(i< session.players.length){
                player = session.players[i];
                //;
            }else{
                //;
                player = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
                guardian = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
                guardian.quirk = randomHumanSim(session.rand, guardian);
                player.quirk = randomHumanSim(session.rand, player);
                player.guardian = guardian;
                guardian.guardian = player;
                session.players.add(player);
            }
        }
        session.players.length = numPlayers; //no more, no less.


        //overright players
        for(int i = 0; i<numPlayers; i++){
            Player player = session.players[i];
            Player guardian = player.guardian;
            player.relationships = [];
            List<Player> guardians = getGuardiansForPlayers(session.players);
            guardian.generateBlandRelationships(guardians);
            player.generateBlandRelationships(session.players);
            playerFunction(session,player, i);
            playerFunction(session,guardian, i);//just call regular with a different index
            player.mylevels = getLevelArray(player);
            guardian.mylevels = getLevelArray(guardian);
        }
    }


    //SBURB NETA, a DELTA spawn.  Ran from 7/31 to 10/31 (barring an epilogue final boss fight)
    static void session730(Session session){
        int numPlayers = 9;
        makeASessionFromSource(session, session730IndexToPlayer, numPlayers);

        //shipping is srs business.
        //SBURB NETA is such a scandalous fuck pile

        Player ci = session.players[0];
        Player im = session.players[3];
        Player ds = session.players[1];
        Player cw = session.players[2];
        Player aa = session.players[7];
        Player jr = session.players[5];
        Player ca = session.players[6];
        Player va = session.players[4];
        Player sr = session.players[8];


        Relationship.makeDiamonds(ci,im);
        Relationship.makeDiamonds(cw,jr);

        Relationship.makeDiamonds(cw,aa);
        Relationship.makeDiamonds(jr,aa);


        Relationship.makeHeart(ci,ds);
        Relationship.makeHeart(ci,cw);
        Relationship.makeHeart(im,jr);

        Relationship.makeSpades(im,aa);
        Relationship.makeSpades(cw,ds);

        Relationship.makeClubs(jr,ca,va );

        //important opinions
        //VA has crush on JR and CI, hates IM
        va.getRelationshipWith(jr).value = 20;
        va.getRelationshipWith(ci).value = 20;
        va.getRelationshipWith(im).value = -20;
        //IM hates VA,likes jr and ci
        im.getRelationshipWith(va).value = -20;
        im.getRelationshipWith(jr).value = 20;
        im.getRelationshipWith(ci).value = 20;
        //JR hates ci and va, likes im and cw
        jr.getRelationshipWith(va).value = -20;
        jr.getRelationshipWith(ci).value = -20;
        jr.getRelationshipWith(im).value = 20;
        jr.getRelationshipWith(cw).value = 20;
        //ci doesn't hate anybody.
        for(Relationship r in ci.relationships) {
            if(r.value < 0) r.value = 0;
        }
        //cw likes jr and ci and hates ds and sr
        cw.getRelationshipWith(jr).value = 20;
        cw.getRelationshipWith(ci).value = 20;
        cw.getRelationshipWith(ds).value = -20;
        cw.getRelationshipWith(sr).value = -20;

        //ds likes ci, seems kinda bland about everything else
        cw.getRelationshipWith(ci).value = 20;

        session.players.length = numPlayers; //no more, no less.
    }



    static void session730IndexToPlayer(Session session, Player player, int index){
        player.isTroll = true;
        player.hairColor = "#000000";

        player.deriveChatHandle = false;
        player.deriveLand = false;
        if(index == 0){
            player.bloodColor = "#A10000";
            player.class_name = SBURBClassManager.PAGE;
            player.godDestiny = true;
            player.aspect = Aspects.HEART;
            player.hair  =46;
            player.leftHorn = 11;
            player.rightHorn = 11;
            player.chatHandle = "catharsisIgnited";
            var f = new Fraymotif( "Pyrokinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = " ${Fraymotif.OWNER} is the hottest. It is them. ";
            player.fraymotifs.add(f);

            f = new Fraymotif( "Angst", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = " ${Fraymotif.OWNER} angsts more than anyone ever has before. The angst practically vores them. ";
            player.fraymotifs.add(f);
            player.interest1 = new Interest("Poetry", InterestManager.WRITING);
            player.interest2 = new Interest("being the systematic allfather", InterestManager.DOMESTIC);
            player.quirk.capitalization = 0;
            player.quirk.punctuation = 1;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "[";
            player.quirk.suffix = "]";
            player.land = player.spawnLand();
            player.land.name = "Land of Mines and Smoke";
            player.land.denizenFeature = new DenizenFeature('Terpischore');

            player.moon = session.derse;
        }else if(index == 1){
            player.bloodColor = "#416600";
            player.class_name = SBURBClassManager.SEER;
            player.godDestiny = true;
            player.aspect = Aspects.BREATH;
            player.hair  =11;
            player.leftHorn = 57;
            player.rightHorn = 57;
            player.chatHandle = "digitalSingularity";
            var f = new Fraymotif( "Try (and fail) To Be Meta", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = "SR is NOT happy about how the  ${Fraymotif.OWNER} is trying to be meta. ";
            player.fraymotifs.add(f);
            player.interest1 = new Interest("Coding", InterestManager.TECHNOLOGY);
            player.interest2 = new Interest("Music", InterestManager.MUSIC);
            player.quirk.capitalization = 0;
            player.quirk.punctuation = 1;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = ">{";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Problems and Wind";
            player.land.denizenFeature = new DenizenFeature('Aeolus');

            player.moon = session.derse;
        }else if(index == 2){
            player.bloodColor = "#a25203";
            player.class_name = SBURBClassManager.MAID;
            player.godDestiny = true;
            player.aspect = Aspects.DOOM;
            player.hair  =8;
            player.leftHorn = 64;
            player.rightHorn = 64;
            player.chatHandle = "cyberneticWanderer";
            Fraymotif f = new Fraymotif( "Electrokinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = " ${Fraymotif.OWNER} shocks the fuck out of you. ";
            player.fraymotifs.add(f);

            f = new Fraymotif( "Paranoia", 2);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = " ${Fraymotif.OWNER} throws bombs and spams doom powers and poison and deadly gas and shoots bullets. There is no kill like overkill. ";
            player.fraymotifs.add(f);
            player.interest1 = new Interest("Artificial Intelligence", InterestManager.TECHNOLOGY);
            player.interest2 = new Interest("Surviving the PLOTS", InterestManager.TERRIBLE);
            player.quirk.capitalization = 0;
            player.leftMurderMode=true;
            player.quirk.punctuation = 1;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [["i","1"],["o","0"]];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Poison and Paranoia";
            player.land.denizenFeature = new DenizenFeature('Tartarus');

            player.moon = session.derse;
        }else if(index == 3){
            player.bloodColor = "#008282";
            player.class_name = SBURBClassManager.SYLPH;
            player.godDestiny = true;
            player.aspect = Aspects.RAGE;
            player.hair  =60;
            player.leftHorn = 4;
            player.rightHorn = 6;
            player.chatHandle = "illuminantMycelium";
            Fraymotif f = new Fraymotif( "Fungikinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = " ${Fraymotif.OWNER} really is a FUN guy! ";
            player.fraymotifs.add(f);

            f = new Fraymotif( "Force the Plot", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = " ${Fraymotif.OWNER} insists that things should actually be going this way. They rage until reality agrees with them. ";

            player.fraymotifs.add(f);
            player.interest1 = new Interest("Knowledge", InterestManager.ACADEMIC);
            player.interest2 = new Interest("Revolution", InterestManager.JUSTICE);
            player.quirk.capitalization = 0;
            player.quirk.punctuation = 1;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "=|}";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Walls and Strife";
            player.land.denizenFeature = new DenizenFeature('Bacchus');

            player.moon = session.derse;
        }else if(index == 4){
            player.bloodColor = "#a1a100";
            player.class_name = SBURBClassManager.BARD;
            player.godDestiny = true;
            player.aspect = Aspects.TIME;
            player.hair  =66;
            player.leftHorn = 18;
            player.rightHorn = 18;
            player.chatHandle = "vinylApocalypse";
            Fraymotif f = new Fraymotif( "Telekinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = "Everybody keeps forgetting ${Fraymotif.OWNER} even has this. ";
            player.fraymotifs.add(f);

            f = new Fraymotif( "Piss Everybody Off", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = " ${Fraymotif.OWNER} does a stupid dance. This enrages EVERYBODY. ";
            player.fraymotifs.add(f);
            player.interest1 = new Interest("Music", InterestManager.MUSIC);
            player.interest2 = new Interest("Bees", InterestManager.CULTURE); //why are bees culture. VA. Why?
            player.quirk.capitalization = 0;
            player.quirk.punctuation = 1;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [["s","z"],["c","z"]];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Clocks and Crime";
            player.land.denizenFeature = new DenizenFeature('Chronos');

            player.moon = session.prospit;
        }else if(index == 5){
            player.bloodColor = "#078446";
            player.class_name = SBURBClassManager.WITCH;
            player.godDestiny = true;
            player.aspect = Aspects.MIND;
            player.hair  =13;
            player.leftHorn = 24;
            player.rightHorn = 24;
            player.chatHandle = "jadedResearcher"; //whoa, a jade blooded researcher???  I am the best at trollsonas. it is me.
            Fraymotif f = new Fraymotif( "Terrakinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = " ${Fraymotif.OWNER} spams terra. Fuck the world. ";
            player.fraymotifs.add(f);

            f = new Fraymotif( "Be Unimpressed", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = " ${Fraymotif.OWNER} hates their bullshit land. They hate this bullshit game. But most of all they hate ${Fraymotif.ENEMY}.  ";
            player.fraymotifs.add(f);
            player.interest1 = new Interest("SCIENCE", InterestManager.ACADEMIC);
            player.interest2 = new Interest("Movies", InterestManager.POPCULTURE); //especially the Aliens series
            player.quirk.capitalization = 0;
            player.quirk.punctuation = 1;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [["i","1"],["l","1"],["e","3"],["one","1"]];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Bullshit and More Bullshit"; //formerly known as the land of Ghosts and Absence
            player.land.denizenFeature = new DenizenFeature('Athena'); // <-- only good thing about this bullshit land

            player.moon = session.prospit;
        }else if(index == 6){
            player.bloodColor = "#0021cb";
            player.class_name = SBURBClassManager.HEIR;
            player.godDestiny = true;
            player.aspect = Aspects.HOPE;
            player.hair  =30;
            player.leftHorn = 23;
            player.rightHorn = 23;
            player.chatHandle = "complexAssumption";
            var f = new Fraymotif( "Vanish", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = " ${Fraymotif.OWNER} makes like a void player and vanishes. You're sure they'll be back in time for the final boss, though. Wait, there they are. ";
            player.fraymotifs.add(f);
            player.interest1 = new Interest("Music", InterestManager.MUSIC);
            player.interest2 = new Interest("Slow Things", InterestManager.CULTURE);
            player.quirk.capitalization = 5;
            player.quirk.punctuation = 1;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "|";
            player.quirk.suffix = "|";
            player.land = player.spawnLand();
            player.land.name = "Land of Titanium and Dreams";
            player.land.denizenFeature = new DenizenFeature('Hyperion');//sir not appearing in this film.

            player.moon = session.prospit;

        }else if(index == 7){
            player.bloodColor = "#631db4";
            player.class_name = SBURBClassManager.KNIGHT;
            player.godDestiny = true;
            player.aspect = Aspects.SPACE;
            player.hair  =31;
            player.leftHorn = 48;
            player.rightHorn = 48;
            player.chatHandle = "animalisticallyAstute";
            var f = new Fraymotif( "Oh God. WHY?", 2);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = " Why did ${Fraymotif.OWNER} just do that? The world may never know.  ";
            player.fraymotifs.add(f);
            player.interest1 = new Interest("Cooking", InterestManager.DOMESTIC);
            player.interest2 = new Interest("being the highblood", InterestManager.SOCIAL);
            player.quirk.capitalization = 0;
            player.quirk.punctuation = 1;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = ""; //no quirk
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Drought and Frogs";
            player.land.denizenFeature = new DenizenFeature('Echidna');

            player.moon = session.prospit;
        }else if(index == 8){
            player.bloodColor = "#008282";
            player.class_name = SBURBClassManager.SEER;
            player.godDestiny = true;
            player.isDreamSelf = true;
            player.aspect = Aspects.TIME;
            player.hair  =4;
            player.leftHorn = 2;
            player.rightHorn = 2;
            player.chatHandle = "splinteredRift";
            var f = new Fraymotif( "Narration", 2);
            f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
            f.desc = "${Fraymotif.OWNER} does an admirable job narrating all these shenanigans.  ";
            player.fraymotifs.add(f);
            player.interest1 = new Interest("Beating SBURB", InterestManager.SOCIAL);
            player.interest2 = new Interest("Predestination", InterestManager.TERRIBLE);
            player.quirk.capitalization = 0;
            player.quirk.punctuation = 1;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "```"; //this would look better in discord
            player.quirk.suffix = "```";
            player.land = player.spawnLand();
            player.land.name = "Land of ??? and ???";
            player.land.denizenFeature = new DenizenFeature('???');

            player.moon = session.prospit;
        }

    }



    //could make this a mapping, but whatever, i like it like this
    static void session80000008IndexToPlayer(Session session, Player player, int index){
        Session s = session;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        if(index == 0){
            player.isTroll = false;
            player.hairColor = "#381e0a";
            player.bloodColor = "#ff0000";
            player.class_name = SBURBClassManager.HEIR;
            player.godDestiny = true;
            player.aspect = Aspects.TIME;
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Vader", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.hair  =51;
            player.chatHandle = "insipidTestimony";

            player.interest1 = new Interest("Video Games", InterestManager.POPCULTURE);
            player.interest2 = new Interest("Science Fiction", InterestManager.FANTASY);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [["good","great"],["lol","lel"],["nope","nah"],["asshole","hooker"]];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Cold and Pendulums";
            player.land.denizenFeature = new DenizenFeature('Hephaestus');

            player.moon = session.derse;
        }else if(index == 1){
            player.isTroll = false;
            player.bloodColor = "#ff0000";
            player.hairColor = "#e0be78";
            player.class_name = SBURBClassManager.WITCH;
            player.godDestiny = true;
            player.aspect = Aspects.SPACE;
            player.hair  =34;
            player.leftHorn = 57;
            player.rightHorn = 57;
            player.chatHandle = "ViolinKid";
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Violin", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.interest1 = new Interest("Coding", InterestManager.TECHNOLOGY);
            player.interest2 = new Interest("Music", InterestManager.MUSIC);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of  Harmony and Paranoia";
            player.land.denizenFeature = new DenizenFeature('Echidna');

            player.moon = session.prospit;
        }else if(index == 2){
            player.isTroll = false;
            player.bloodColor = "#ff0000";
            player.hairColor = "#ffffff";
            player.class_name = SBURBClassManager.THIEF;
            player.godDestiny = true;
            player.aspect = Aspects.HOPE;
            player.hair  =73;
            player.leftHorn = 64;
            player.rightHorn = 64;
            player.chatHandle = "nuclearChronosphere";
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Zebra", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.interest1 = new Interest("Knowledge", InterestManager.ACADEMIC);
            player.interest2 = new Interest("Tabletop Roleplaying", InterestManager.SOCIAL);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Stars and Castles";
            player.land.denizenFeature = new EasyDenizenFeature('Abraxas');

            player.moon = session.prospit;
        }else if(index == 3){
            player.isTroll = false;
            player.bloodColor = "#ff0000";
            player.hairColor = "#b55c0d";
            player.class_name = SBURBClassManager.WITCH;
            player.godDestiny = true;
            player.aspect = Aspects.BLOOD;
            player.hair  =23;
            player.leftHorn = 4;
            player.rightHorn = 6;
            player.chatHandle = "collectiveAspirant";
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Nemetona", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.interest1 = new Interest("Swimming", InterestManager.ATHLETIC);
            player.interest2 = new Interest("History", InterestManager.ACADEMIC);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [["good","fantastic"],["lol","hee"],["nope","no thank you"],["asshole","jerk"]];
            player.quirk.prefix = "";
            player.quirk.suffix = "~™";
            player.land = player.spawnLand();
            player.land.name = "Land of Rainbows and Oil";
            player.land.denizenFeature = new HardDenizenFeature('Yaldabaoth');

            player.moon = session.derse;
        }

    }


    //could make this a mapping, but whatever, i like it like this
    static void session20082015IndexToPlayer(Session session,Player player, int index){
        Session s = session;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        if(index == 0){
            player.copyFromOCDataString("b=%C2%80%00%C3%BF%C3%A6%C3%BE9%00%05%1F%1F%16&s=,,Dungeon Mastering,Video Games,gorristerChampion&x=AQ==");
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("David Duchovny", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Paths and Tea";
            player.land.denizenFeature = new DenizenFeature('Odin');
        }else if(index == 1){
            player.copyFromOCDataString("b=%00%C2%80%C3%BF%19%C3%BEc%00%01%08%089&s=,,Social Justice,Writing,grapefruitTwostep&x=AQ==");
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Gillian Anderson", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.land = player.spawnLand();
            player.quirk.suffix = "";
            player.land.denizenFeature = new DenizenFeature('Ares');
        }else if(index == 2){
            player.copyFromOCDataString("b=%00%00%00Q%C3%BE%C3%93%00G''C&s=,,Knowledge,Fan Fiction,pleasantPigeon&x=AQ==");
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();

        }else if(index == 3){
            player.copyFromOCDataString("b=%3F%19%04%20%C3%BE%25%00B%14%14F&s=,,Drawing,Death,vengefulKappa&x=AQ==");
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Scandalous Fanart", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.land = player.spawnLand();
            player.quirk.suffix = "";
            player.land.denizenFeature = new DenizenFeature('Hades');
        }else if(index == 4) {
            player.copyFromOCDataString("b=G2%00%C2%85%C3%BE%0B%00T%0A%0A%40&s=,,Puns,Psychology,machiosAvatar&x=AQ==");
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Earthbound", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.land = player.spawnLand();
            player.quirk.suffix = "";
        }else if(index == 5){
            player.copyFromOCDataString("b=8%22%07J%C3%BEM%00G%13%13%1E&s=,,Unicycling,Phylosophy,unicycleKing&x=AQ==");
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Zardoz", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.land = player.spawnLand();
            player.quirk.suffix = "";
        }

    }



    //could make this a mapping, but whatever, i like it like this
    static void session404IndexToPlayer(Session session,Player player, int index){
        Session s = session;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        if(index == 0){
            //Chrena
            player.copyFromOCDataString("b=%00%00%00%17%C3%B9f%10J%02%02%25&s=,,Mysteries,Detectives,abroachedPervestigator&x=AQ==");
            player.deriveSprite = false;
            player.fraymotifs.clear();
            player.deriveSpecibus = false;
            player.specibus = new Specibus("44.magnum", ItemTraitFactory.SAFE, [ ItemTraitFactory.METAL, ItemTraitFactory.SHOOTY]);
            player.object_to_prototype = new PotentialSprite("Owldad", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [["o","O-"]];
            player.quirk.prefix = "-|";
            player.quirk.suffix = "|-";
            player.moon = session.prospit;
            player.land = player.spawnLand();
            player.land.name = "Land of Caves and Rain";
            player.land.denizenFeature = new DenizenFeature('Synesis');
            player.land.consortFeature = new ConsortFeature('Eagle', 'screech');

        }else if(index == 1){
            //augora
            player.copyFromOCDataString("b=%00%00%00%C2%BA%C3%BE%C2%85%10Z%24%24(&s=,,Knitting,Cults,angelicThroes&x=AQ==");
            player.deriveSprite = false;
            player.fraymotifs.clear();
            player.deriveSpecibus = false;
            player.specibus = new Specibus("Iron", ItemTraitFactory.SAFE, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT]);

            player.object_to_prototype = new PotentialSprite("Sheepmom", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NOCAPS;
            player.quirk.punctuation = Quirk.ENDPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [["a","/\\"],["t","+"]];
            player.quirk.prefix = "";
            player.moon = session.prospit;
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Cherished Hymns and Reason";
            player.land.denizenFeature = new DenizenFeature('Ecclesia');
            player.land.consortFeature = new ConsortFeature('Dove', 'coo');

        }else if(index == 2){
            //karsyn
            player.copyFromOCDataString("b=%00%00%00!%C3%B7%C2%A5%10%05%3B%3B%3C&s=,,Programming,Online Trolling,perspicaciousAlieniloquy&x=AQ==");
            player.deriveSprite = false;
            player.fraymotifs.clear();
            player.deriveSpecibus = false;
            player.specibus = new Specibus("Machete", ItemTraitFactory.BLADE, [ ItemTraitFactory.METAL, ItemTraitFactory.EDGED]);

            player.object_to_prototype = new PotentialSprite("Crowdad", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NOCAPS;
            player.quirk.punctuation = Quirk.NOPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [["o","0"],["i","1"],["l","1"]];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.moon = session.derse;
            player.land = player.spawnLand();
            player.land.name = "Land of Mountains and Robots";
            player.land.denizenFeature = new DenizenFeature('Patrikos');
            player.land.consortFeature = new ConsortFeature('RoboPigeons', 'coo');

        }else if(index == 3){ //lalnah does not have psionics
            player.copyFromOCDataString("b=%00%00%00h%C3%B0(%10%1055.&s=,,Literature,Cooking,transientTechnicality&x=AQ==");
            player.deriveSprite = false;
            player.fraymotifs.clear();
            player.deriveSpecibus = false;
            player.specibus = new Specibus("Shotgun", ItemTraitFactory.SHOTGUN, [ ItemTraitFactory.METAL, ItemTraitFactory.SHOOTY]);
            player.fraymotifs.clear();

            player.grimDark = 2;
            Fraymotif f = new Fraymotif("Horrorterror Whispers", 1);
            f.effects.add(new FraymotifEffect(Stats.FREE_WILL, 2, false));
            f.effects.add(new FraymotifEffect(Stats.FREE_WILL, 2, true));
            f.desc = " Uses dark knowledge as a defense against mind control. ";
            player.fraymotifs.add(f);


            player.object_to_prototype = new PotentialSprite("Batdad", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NOCAPS;
            player.quirk.punctuation = Quirk.NOPUNC;
            player.quirk.lettersToReplace = [["o","O"]];
            player.quirk.lettersToReplaceIgnoreCase = [["v",">"]];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.moon = session.derse;
            player.land = player.spawnLand();
            player.land.name = "Land of Echoes and Haze";
            player.land.denizenFeature = new DenizenFeature('Sige');
            player.land.consortFeature = new ConsortFeature('Raven', 'caw');

        }else if(index == 4) {
            // pyrokinetic, HorrorTerror Whispers
            player.copyFromOCDataString("b=%00%00%009%C3%B2T%10G((%20&s=,,Fighting,Survival,persistentPaletot&x=AQ==");
            player.deriveSprite = false;
            player.deriveSpecibus = false;
            player.fraymotifs.clear();
            player.specibus = new Specibus("Sign", ItemTraitFactory.ROADSIGN, [ ItemTraitFactory.METAL, ItemTraitFactory.BLUNT]);
            player.object_to_prototype = new PotentialSprite("Cricketdad", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;


            Fraymotif f = new Fraymotif("Pyrokinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
            f.desc = " Who knew shaving cream was so flammable? ";
            player.fraymotifs.add(f);

            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [["w","\|\|"],["y","\|"],["e","[["]];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.moon = session.prospit;
            player.land = player.spawnLand();
            player.land.name = "Land of Construction and Fistfights";
            player.land.denizenFeature = new DenizenFeature('Acinetos');
            player.land.consortFeature = new ConsortFeature('Magpie', 'screech');

        }else if(index == 5){
            //ghost communing, Mortae
            player.copyFromOCDataString("b=%00%00%00%03%C3%B3%7D%10%13%11%11%0E&s=,,Undead,Archaeology,palingeneticMortician&x=AQ==");
            player.deriveSprite = false;
            player.deriveSpecibus = false;
            player.fraymotifs.clear();

            Fraymotif f = new Fraymotif( "Ghost Communing", 1);
            f.effects.add(new FraymotifEffect(Stats.SANITY,3,true));
            f.effects.add(new FraymotifEffect(Stats.SANITY,3,false));
            f.desc = " The souls of the dead start hassling all enemies. ";
            player.fraymotifs.add(f);
            player.object_to_prototype = new PotentialSprite("Vulturemom", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.specibus = new Specibus("Urn", ItemTraitFactory.BUST, [ ItemTraitFactory.CERAMIC, ItemTraitFactory.BLUNT]);
            player.quirk.lettersToReplaceIgnoreCase = [["o","-0-"]];
            player.quirk.prefix = "--{{:} ";
            player.quirk.suffix = "";
            player.moon = session.derse;
            player.land = player.spawnLand();
            player.land.name = "Land of Slums and Resonance";
            player.land.denizenFeature = new DenizenFeature('Sermo');
            player.land.consortFeature = new ConsortFeature('Vultures', 'sqwuak');

        }else if(index == 6){
            //Kierdn
            player.copyFromOCDataString("b=%00%00%00%C2%AB%C3%BAU%10%03%13%15%06&s=,,Murder,Status,adoniseAbdicator&x=AQ==");
            player.deriveSprite = false;
            player.deriveSpecibus = false;
            player.fraymotifs.clear();
            player.specibus = new Specibus("Switchblade", ItemTraitFactory.RAZOR, [ ItemTraitFactory.METAL, ItemTraitFactory.EDGED]);

            player.object_to_prototype = new PotentialSprite("Eeldad", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "/2/";
            player.quirk.suffix = "/3/";
            player.land = player.spawnLand();
            player.moon = session.derse;
            player.land.name = "Land of Brass and Despair";
            player.land.denizenFeature = new DenizenFeature('Vita');
            player.land.consortFeature = new ConsortFeature('Kingfishers', 'peck');

        }else if(index == 7){
            player.copyFromOCDataString("b=%00%00%00%C2%90%C3%B6f%10V%3D%3D%04&s=,,Revolution,Equality,malcontentMarionette&x=AQ==");
            player.deriveSprite = false;
            player.fraymotifs.clear();
            player.deriveSpecibus = false;
            player.specibus =  new Specibus("Chain", ItemTraitFactory.CHAIN, [ ItemTraitFactory.METAL, ItemTraitFactory.RESTRAINING]);

            player.moon = session.prospit;
            player.object_to_prototype = new PotentialSprite("Tarantulamom", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.ALLCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [["T","7"],["B","8"],["G","9"],["I","1"]];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Discord and Frogs";
            player.land.denizenFeature = new DenizenFeature('Matrikos');
            player.land.consortFeature = new ConsortFeature('Chicken', 'cluck');

        }

    }


}


