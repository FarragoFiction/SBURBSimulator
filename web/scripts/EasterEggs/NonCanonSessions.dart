import "../SBURBSim.dart";
//all static
typedef void SessionSource(Player player, int index);

abstract class NonCanonSessions {


    //from patron insipidTestimony: thanks for your support!!!
    static void session80000008() {
        int numPlayers = 4;
        makeASessionFromSource(session80000008IndexToPlayer, numPlayers);
    }

    //from patron RL: thanks for your support!!!
    static void session20082015() {
        int numPlayers = 6;
        makeASessionFromSource(session20082015IndexToPlayer, numPlayers);
        //TODO relationships
    }

    //tell me how to turn player num into a player and how many players there are and i'll do the heavy lifting of setting up the session
    static void makeASessionFromSource(SessionSource playerFunction, int numPlayers) {
        //add the correct amount of extra players
        for(int i = 0; i<numPlayers; i++){
            Player player;
            Player guardian;
            if(i< curSessionGlobalVar.players.length){
                player = curSessionGlobalVar.players[i];
                //print("using existing player");
            }else{
                //print("making new player");
                player = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
                guardian = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
                guardian.quirk = randomHumanSim(curSessionGlobalVar.rand, guardian);
                player.quirk = randomHumanSim(curSessionGlobalVar.rand, player);
                player.guardian = guardian;
                guardian.guardian = player;
                curSessionGlobalVar.players.add(player);
            }
        }

        //overright players
        for(int i = 0; i<numPlayers; i++){
            Player player = curSessionGlobalVar.players[i];
            Player guardian = player.guardian;
            player.relationships = [];
            List<Player> guardians = getGuardiansForPlayers(curSessionGlobalVar.players);
            guardian.generateBlandRelationships(guardians);
            player.generateBlandRelationships(curSessionGlobalVar.players);
            playerFunction(player, i);
            playerFunction(guardian, i);//just call regular with a different index
            player.mylevels = getLevelArray(player);
            guardian.mylevels = getLevelArray(guardian);
        }
        curSessionGlobalVar.players.length = numPlayers; //no more, no less.
    }


    //SBURB NETA, a DELTA spawn.  Ran from 7/31 to 10/31 (barring an epilogue final boss fight)
   static void session730(){
        int numPlayers = 9;
        makeASessionFromSource(session730IndexToPlayer, numPlayers);

        //shipping is srs business.
        //SBURB NETA is such a scandalous fuck pile

        Player ci = curSessionGlobalVar.players[0];
        Player im = curSessionGlobalVar.players[3];
        Player ds = curSessionGlobalVar.players[1];
        Player cw = curSessionGlobalVar.players[2];
        Player aa = curSessionGlobalVar.players[7];
        Player jr = curSessionGlobalVar.players[5];
        Player ca = curSessionGlobalVar.players[6];
        Player va = curSessionGlobalVar.players[4];
        Player sr = curSessionGlobalVar.players[8];


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

        curSessionGlobalVar.players.length = numPlayers; //no more, no less.
    }



    static void session730IndexToPlayer(Player player, int index){
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

            player.moon = curSessionGlobalVar.derse;
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

            player.moon = curSessionGlobalVar.derse;
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

            player.moon = curSessionGlobalVar.derse;
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

            player.moon = curSessionGlobalVar.derse;
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

            player.moon = curSessionGlobalVar.prospit;
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

            player.moon = curSessionGlobalVar.prospit;
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

            player.moon = curSessionGlobalVar.prospit;

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

            player.moon = curSessionGlobalVar.prospit;
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

            player.moon = curSessionGlobalVar.prospit;
        }

    }



    //could make this a mapping, but whatever, i like it like this
    static void session80000008IndexToPlayer(Player player, int index){
        Session s = curSessionGlobalVar;
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

            player.moon = curSessionGlobalVar.derse;
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

            player.moon = curSessionGlobalVar.prospit;
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

            player.moon = curSessionGlobalVar.prospit;
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

            player.moon = curSessionGlobalVar.derse;
        }

    }


    //could make this a mapping, but whatever, i like it like this
    static void session20082015IndexToPlayer(Player player, int index){
        Session s = curSessionGlobalVar;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        if(index == 0){
            player.copyFromOCDataString("b=%C2%80%00%C3%BF%C3%A6%C3%BE9%00%05%1F%1F%16&s=,,Dungeon Mastering,Video Games,gorristerChampion");
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Vader", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Cold and Pendulums";
            player.land.denizenFeature = new DenizenFeature('Hephaestus');
        }else if(index == 1){
            player.copyFromOCDataString("b=%C2%80%00%C3%BF%C3%A6%C3%BE9%00%05%1F%1F%16&s=,,Dungeon Mastering,Video Games,gorristerChampion");
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Vader", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Cold and Pendulums";
            player.land.denizenFeature = new DenizenFeature('Hephaestus');
        }else if(index == 2){
            player.copyFromOCDataString("b=%C2%80%00%C3%BF%C3%A6%C3%BE9%00%05%1F%1F%16&s=,,Dungeon Mastering,Video Games,gorristerChampion");
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Vader", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Cold and Pendulums";
            player.land.denizenFeature = new DenizenFeature('Hephaestus');
        }else if(index == 3){
            player.copyFromOCDataString("b=%C2%80%00%C3%BF%C3%A6%C3%BE9%00%05%1F%1F%16&s=,,Dungeon Mastering,Video Games,gorristerChampion");
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Vader", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Cold and Pendulums";
            player.land.denizenFeature = new DenizenFeature('Hephaestus');
        }else if(index == 4) {
            player.copyFromOCDataString("b=%C2%80%00%C3%BF%C3%A6%C3%BE9%00%05%1F%1F%16&s=,,Dungeon Mastering,Video Games,gorristerChampion");
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Vader", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Cold and Pendulums";
            player.land.denizenFeature = new DenizenFeature('Hephaestus');
        }else if(index == 5){
            player.copyFromOCDataString("b=%C2%80%00%C3%BF%C3%A6%C3%BE9%00%05%1F%1F%16&s=,,Dungeon Mastering,Video Games,gorristerChampion");
            player.deriveSprite = false;
            player.object_to_prototype = new PotentialSprite("Vader", s);
            player.sprite.addPrototyping(player.object_to_prototype);
            player.quirk.capitalization = Quirk.NORMALCAPS;
            player.quirk.punctuation = Quirk.PERFPUNC;
            player.quirk.lettersToReplace = [];
            player.quirk.lettersToReplaceIgnoreCase = [];
            player.quirk.prefix = "";
            player.quirk.suffix = "";
            player.land = player.spawnLand();
            player.land.name = "Land of Cold and Pendulums";
            player.land.denizenFeature = new DenizenFeature('Hephaestus');
        }

    }


}


