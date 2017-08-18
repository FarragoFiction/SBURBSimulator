import "SBURBSim.dart";

/*
stat effects from a fraymotif are temporary. wear off after battle.
so, players, player snapshots AND gameEntities will have to have an array of applied fraymotifs.
and their getPower, getHP etc stats must use these.
at start AND end of battle (can't be too careful), wipe applied fraymotifs
*/
class Fraymotif {
    List<Aspect> aspects; //expect to be an array
    String name;
    int tier;
    bool usable = true; //when used in a fight, switches to false. IMPORTANT: fights should turn it back on when over.
    //flavor text acts as a template, with ENEMIES and CASTERS and ALLIES and ENEMY being replaced.
    //you don't call flavor text directly, instead expecting the use of the fraymotif to return something;
    //based on it.
    //make sure ENEMY is the same for all effects, dunkass.
    String desc; //will generate it procedurally if not set, otherwise things like sprites will have it hand made.
    bool used = false; //when start fight, set to false. set to true when used. once per fight
    List<FraymotifEffect> effects = <FraymotifEffect>[]; //each effect is a target, a revive, a statName
    num baseValue;


    Fraymotif(String this.name, int this.tier, {List<Aspect> this.aspects = null, String this.desc = ""}) {
        if (this.aspects == null) {
            this.aspects = <Aspect>[];
        }
        this.baseValue = 50 * this.tier;
        if (this.tier >= 3)
            this.baseValue = 1000 * this.tier - 2; //so a tier 3 is 1000 * 3 -2, or....1000.  But..maybe there is a way to make them even more op???
    }

    @override
    String toString() => this.name;

    void addEffectsForPlayers(List<Player> players) {
        for (num i = 0; i < players.length; i++) {
            FraymotifEffect effect = new FraymotifEffect(null, null, null);
            effect.setEffectForPlayer(players[i]);
            this.effects.add(effect);
        }
    }

    List<Player> getCastersNoOwner(Random rand, List<Player> players) {
        List<Player> casters = [];
        for (num i = 0; i < this.aspects.length; i++) { //skip the first aspect, because that's owner.
            Aspect a = this.aspects[i];
            Player p = rand.pickFrom(findAllAspectPlayers(players, a)); //ANY player that matches my aspect can do this.;
            if (p != null) casters.add(p); //don't add 'undefined' to this array like a dunkass.
        }
        return casters; //eventually do smarter things, like only allow to cast buff hp if heals are needed or anybody is dead.

    }

    dynamic getCasters(GameEntity owner, List<GameEntity> allies) {
        //first check to see if all aspects are included in the allies array.
        List<GameEntity> casters = [owner];
        //List<dynamic> aspects = [];
        List<GameEntity> living = findLivingPlayers(allies); //dead men use no fraymotifs. (for now)
        for (num i = 1; i < this.aspects.length; i++) { //skip the first aspect, because that's owner.
            var a = this.aspects[i];
            var p = owner.rand.pickFrom(findAllAspectPlayers(living, a)); //ANY player that matches my aspect can do this.;
            if (p != null) casters.add(p); //don't add 'undefined' to this array like a dunkass.
        }
        return casters; //eventually do smarter things, like only allow to cast buff hp if heals are needed or anybody is dead.
    }

    dynamic processFlavorText(GameEntity owner, List<GameEntity> casters, List<GameEntity> allies, GameEntity enemy, List<GameEntity> enemies, revives) {
        if (this.desc == null || this.desc.length == 0) {
            this.desc = this.proceduralFlavorText(owner.rand);
        }
        String phrase = "The CASTERS use FRAYMOTIF. "; //shitty example.
        if (casters.length == 1) phrase = "The CASTERS uses FRAYMOTIF. It damages the ENEMY. ";
        phrase += this.desc + revives;
        return this.replaceKeyWords(phrase, owner, casters, allies, enemy, enemies);
    }

    dynamic proceduralFlavorText(Random rand) {
        var base = this.superCondenseEffectsText(rand);
        return base;
    }

    dynamic superCondenseEffectsText(Random rand) {
        var effectTypes = {}; //hash coded by effectType damage0 vs damage1 vs buff0. first element is template
        for (int i = 0; i < 4; i++) {
            effectTypes["damage$i"] = [];
            effectTypes["buff$i"] = [];
        }
        for (num i = 0; i < this.effects.length; i++) {
            FraymotifEffect e = this.effects[i];
            if (e.damageInsteadOfBuff) {
                if (effectTypes["damage" + e.target.toString()].length == 0) effectTypes["damage" + e.target.toString()].add(e.toStringSimple());
                //no repeats
                if (effectTypes["damage" + e.target.toString()].indexOf(e.statName) == -1) effectTypes["damage" + e.target.toString()].add(e.statName);
            } else {
                if (effectTypes["buff" + e.target.toString()].length == 0) effectTypes["buff" + e.target.toString()].add(e.toStringSimple());
                //no repeats
                if (effectTypes["buff" + e.target.toString()].indexOf(e.statName) == -1) effectTypes["buff" + e.target.toString()].add(e.statName);
            }
        }

        //now i have a hash of all effect types and the stats i'm applying to them.
        List<dynamic> retArray = [];
        for (int i = 0; i < 4; i++) {
            List<dynamic> stats = [];

            if (effectTypes["damage$i"].length > 0) {
                stats = effectTypes["damage$i"];
                var template = stats[0];
                stats.remove(template);
                for (num j = 0; j < stats.length; j++) {
                    stats[j] = this.getStatWord(rand, stats[j], i); //i is who the target is, j is the stat.
                }
                retArray.add(template.replaceAll("STAT", turnArrayIntoHumanSentence(stats)));
            }
            if (effectTypes["buff$i"].length > 0) {
                stats = effectTypes["buff$i"];
                String template = stats[0];
                stats.remove(template);
                for (num j = 0; j < stats.length; j++) {
                    stats[j] = this.getStatWord(rand, stats[j], i); //i is who the target is, j is the stat.
                }
                retArray.add(template.replaceAll("STAT", turnArrayIntoHumanSentence(stats)));
            }
        }
        String almostDone = turnArrayIntoHumanSentence(retArray);
        almostDone = almostDone[0].toUpperCase() + almostDone.substring(1) + "."; //sentence it.
        return this.replaceKeyWordsForFlavorTextBase(rand, almostDone);
    }

    String getStatWord(Random rand, String stat, num target) {
        bool bad = true;
        if (target == 0 || target == 1) bad = false;
        if (!bad) {
            return rand.pickFrom(this.goodStatWords(stat));
        } else {
            return rand.pickFrom(this.badStatWords(stat));
        }
    }

    List<String> goodStatWords(statName) {
        if (statName == "MANGRIT") return ["mangrit", "strength", "power", "might", "fire", "pure energy", "STRENGTH"];
        if (statName == "hp") return ["plants", "health", "vines", "gardens", "stones", "earth", "life", "moss", "fruit", "growth"];
        if (statName == "RELATIONSHIPS") return ["chains", "friendship bracelets", "shipping grids", "connections", "hearts", "pulse", "bindings", "rainbows", "care bare stares", "mirrors"];
        if (statName == "mobility") return ["wind", "speed", "hedgehogs", "whirlwinds", "gales", "hurricanes", "thunder", "storms", "momentum", "feathers"];
        if (statName == "sanity") return ["calmness", "sanity", "ripples", "glass", "fuzz", "water", "stillness", "totally real magic"];
//,"velvet pillows"
        if (statName == "freeWill") return ["electricity", "will", "open doors", "possibility", "quantum physics", "lightning", "sparks", "chaos", "broken gears"];
        if (statName == "maxLuck") return ["dice", "luck", "light", "playing cards", "suns", "absolute bullshit", "card suits", "hope"];
        if (statName == "minLuck") return ["dice", "luck", "light", "playing cards", "suns", "absolute bullshit", "card suits"];
        if (statName == "alchemy") return ["inspiration", "creativeness", "grist", "perfectly generic objects", "hammers", "swords", "weapons", "creativity", "mist", "engines", "metals"];

        return null;
    }

    List<String> badStatWords(statName) {
        if (statName == "MANGRIT") return ["weakness", "powerlessness", "despair", "wretchedness", "misery"];
        if (statName == "hp") return ["fragility", "rotting plants", "disease", "bones", "skulls", "tombstones", "ash", "toxin", "mold", "viruses"];
        if (statName == "RELATIONSHIPS") return ["aggression", "broken chains", "empty friends lists", "sand", "loneliness"];
        if (statName == "mobility") return ["laziness", "locks", "weights", "manacles", "quicksand", "gravitons", "gravity", "ice"];
//"pillows", "sloths",
        if (statName == "sanity") return ["harshwimsies", "clowns", "fractals", "madness", "tentacles", "rain", "screams", "terror", "nightmares", "mIrAcLeS", "rage", "impossible angles", "teeth"];
        if (statName == "freeWill") return ["acceptance", "gullibility", "closed doors", "gears", "clocks", "prophecy", "static", "skian clouds"];
        if (statName == "maxLuck") return ["misfortune", "blank books", "broken mirrors", "hexes", "doom", "8ad 8reaks", "disaster", "black cats"];
        if (statName == "minLuck") return ["misfortune", "blank books", "broken mirrors", "hexes", "doom", "8ad 8reaks", "disaster", "black cats"];
        if (statName == "alchemy") return ["failure", "writer's blocks", "monotony", "broken objects", "object shards", "nails", "splinters"];

        return null;
    }

    String condenseEffectsText() {
        /*
          If two effects both DAMAGE an ENEMY, then I want to generate text where it lists the types of damage.
          “Damages an Enemy based on how WILLFUL, STRONG, CALM, and FAST, the casters are compared to their enemy.”
        */
        //8 main types of effects, damage/buff and 0-4
        var effectTypes = {}; //hash coded by effectType damage0 vs damage1 vs buff0. first element is template
        for (int i = 0; i < 4; i++) {
            effectTypes["damage$i"] = [];
            effectTypes["buff$i"] = [];
        }
        for (num i = 0; i < this.effects.length; i++) {
            var e = this.effects[i];
            if (e.damageInsteadOfBuff) {
                if (effectTypes["damage${e.target}"].length == 0) effectTypes["damage${e.target}"].add(e.toString());
                //no repeats
                if (effectTypes["damage${e.target}"].indexOf(e.statName) == -1) effectTypes["damage${e.target}"].add(e.statName);
            } else {
                if (effectTypes["buff${e.target}"].length == 0) effectTypes["buff${e.target}"].add(e.toString());
                if (effectTypes["buff${e.target}"].indexOf(e.statName) == -1) effectTypes["buff${e.target}"].add(e.statName);
            }
        }
        //now i have a hash of all effect types and the stats i'm applying to them.
        List<dynamic> retArray = [];
        for (int i = 0; i < 4; i++) {
            List<dynamic> stats = [];
            if (effectTypes["damage$i"].length > 0) {
                stats = effectTypes["damage$i"];
                var template = stats[0];
                stats.remove(template);
                retArray.add(template.replaceAll("STAT", turnArrayIntoHumanSentence(stats)));
            }
            if (effectTypes["buff$i"].length > 0) {
                stats = effectTypes["buff$i"];
                var template = stats[0];
                stats.remove(template);
                retArray.add(template.replaceAll("STAT", turnArrayIntoHumanSentence(stats)));
            }
        }
        return turnArrayIntoHumanSentence(retArray);
    }

    dynamic replaceKeyWordsForFlavorTextBase(Random rand, String phrase) {
        phrase = phrase.replaceAll("damages", rand.pickFrom(this.getDamageWords()));
        phrase = phrase.replaceAll("debuffs", rand.pickFrom(this.getDebuffWords()));
        phrase = phrase.replaceAll("heals", rand.pickFrom(this.getHealingWords()));
        phrase = phrase.replaceAll("buffs", rand.pickFrom(this.getBuffWords()));
        phrase = phrase.replaceAll("SELF", rand.pickFrom(this.getSelfWords()));
        phrase = phrase.replaceAll("EBLUH", rand.pickFrom(this.getEnemyWords()));
        phrase = phrase.replaceAll("FRIENDSBLUH", rand.pickFrom(this.getAlliesWords()));
        phrase = phrase.replaceAll("ESBLUHS", rand.pickFrom(this.getEnemiesWords()));
        return phrase;
    }

    String replaceKeyWords(String phrase, GameEntity owner, List<GameEntity> casters, List<GameEntity> allies, GameEntity enemy, List<GameEntity> enemies) {
        //ret= ret.replace(new RegExp(this.lettersToReplace[i][0], "g"),replace);
        phrase = phrase.replaceAll("OWNER", owner.htmlTitleHP());
        phrase = phrase.replaceAll("CASTERS", getPlayersTitlesBasic(casters));
        phrase = phrase.replaceAll("ALLIES", getPlayersTitlesBasic(allies));
        phrase = phrase.replaceAll("ENEMY", enemy.htmlTitleHP());
        phrase = phrase.replaceAll("ENEMIES", getPlayersTitlesBasic(enemies));
        phrase = phrase.replaceAll("FRAYMOTIF", this.name);

        return phrase;
    }

    List<String> getSelfWords() {
        return ["aura", "cloak", "shield", "armor", "robe", "orbit", "suit", "aegis"];
    }

    List<String> getAlliesWords() {
        return ["cloud", "mist", "fog", "ward", "wall", "blockade", "matrix"];
    }

    List<String> getEnemyWords() {
        return ["lance", "spike", "laser", "hammer", "shard", "ball", "meteor", "fist", "beautiful pony", "cube", "bolt"];
    }

    List<String> getEnemiesWords() {
        return ["explosion", "blast", "miasma", "matrix", "deluge", "cascade", "wave", "fleet", "illusion"];
    }

    List<String> getDamageWords() {
        return ["painful", "acidic", "sharp", "harmful", "violent", "murderous", "destructive", "explosive"];
    }

    List<String> getDebuffWords() {
        return ["draining", "malicious", "distracting", "degrading", "debuffing", "cursed", "vampiric"];
    }

    List<String> getHealingWords() {
        return ["healing", "restorative", "restful", "rejuvenating", "reinforcing"];
    }

    List<String> getBuffWords() {
        return ["soothing", "supportive", "friendly", "fortifying", "protective", "warding", "defensive", "blessed"];
    }

    bool canCast(owner, allies, enemies) {
        if (!this.usable) return false; //once per fight.
        if (this.aspects.length == 0) return true; //no associated aspect means anyone can cast
        var casters = this.getCasters(owner, allies);
        return (casters.length == this.aspects.length);
    }

    void makeCastersUnavailable(casters) {
        for (num i = 0; i < casters.length; i++) {
            casters[i].usedFraymotifThisTurn = true;
        }
    }

    String useFraymotif(GameEntity owner, List<GameEntity> allies, GameEntity enemy, List<GameEntity> enemies) {
        if (!this.canCast(owner, allies, enemies)) return "";
        var casters = this.getCasters(owner, allies);
        this.makeCastersUnavailable(casters);
        List<Player> living = findLivingPlayers(allies);
        //Hope Rides Alone
        if (owner is Player && owner.aspect == Aspects.HOPE && living.length == 1 && owner.rand.nextDouble() > 0.85) {
            enemies[0].buffs.add(new Buff("currentHP", -9999)); //they REALLY believed in this attack.
            var jakeisms = ["GADZOOKS!", "BOY HOWDY!", "TALLY HO!", "BY GUM"];
            print("Hope Rides Alone in session: ${owner.session.session_id}");
            var scream = owner.aspect.fontTag() + owner.rand.pickFrom(jakeisms) + "</font>";
            return " [HOPE RIDES ALONE] is activated. " + owner.htmlTitle() + " starts screaming. <br><br><span class = 'jake'> " + scream + " </span>  <Br><Br> Holy fucking SHIT, that is WAY MORE DAMAGE then is needed. Jesus christ. Someone nerf that Hope player already!";
        }
        List<GameEntity> dead = findDeadPlayers(allies);
        //print(casters);
        //ALL effects that target a single enemy target the SAME enemy.
        for (num i = 0; i < this.effects.length; i++) {
            //effect knows how to apply itself. pass it baseValue.
            this.effects[i].applyEffect(owner, allies, casters, enemy, enemies, this.baseValue);
        }
        String revives = "";
        if (dead.length > findDeadPlayers(allies).length) {
            revives = " Also, the " + getPlayersTitlesBasic(dead) + " being dead is no longer a thing. ";
        }
        enemy.addStat("currentHP", -1 * owner.getStat("power")); //also, do at LEAST as much as a regular attack, dunkass.
        return this.processFlavorText(owner, casters, allies, enemy, enemies, revives);
    }

}


//no global functions any more. bad pastJR.
class FraymotifCreator {
    //some types of fraymotifs, that are otherwise procedurally generated, should have stupid pun names. they are kept here.
    List<Fraymotif> premadeFraymotifNames = [];


    FraymotifCreator() {}


    void createFraymotifForPlayerDenizen(Player player, String name) {
        //var denizen = player.denizen;
        Fraymotif f = new Fraymotif("$name's ${this.getDenizenFraymotifNameFromAspect(player.aspect)}", 2); //CAN I have an aspectless fraymotif?
        f.desc = this.getDenizenFraymotifDescriptionForAspect(player.aspect);

        //statName, target, damageInsteadOfBuff, flavorText
        var plus = player.associatedStats; //buff self and heal. used to be only positive, but that gave witches/sylphs/princes/bards the shaft;
        for (num i = 0; i < plus.length; i++) {
            f.effects.add(new FraymotifEffect(plus[i].name, 0, true));
            f.effects.add(new FraymotifEffect(plus[i].name, 0, false));
        }
        var minus = player.associatedStats; //debuff enemy, and damage. used to be only negative, but that gave witches/sylphs/princes/bards the shaft;
        for (num i = 0; i < minus.length; i++) {
            f.effects.add(new FraymotifEffect(minus[i].name, 2, true));
            f.effects.add(new FraymotifEffect(minus[i].name, 2, false));
        }
        player.denizen.fraymotifs.add(f);
    }

    dynamic getDenizenFraymotifNameFromAspect(Aspect aspect) {
        return aspect.denizenSongTitle;
    }

    dynamic getDenizenFraymotifDescriptionForAspect(Aspect aspect) {
        return aspect.denizenSongDesc;
    }

    List<Fraymotif> getUsableFraymotifs(GameEntity owner, List<GameEntity> allies, List<GameEntity> enemies) {
        List<Fraymotif> fraymotifs = owner.fraymotifs;
        List<dynamic> ret = [];
        for (num i = 0; i < fraymotifs.length; i++) {
            if (fraymotifs[i].canCast(owner, allies, enemies)) ret.add(fraymotifs[i]);
        }
        //print("Found: " + ret.length + " usable fraymotifs for " + owner);
        return ret;
    }


    String getRandomNameForAspect(Random rand, Aspect aspect) {
        String ret = rand.pickFrom(aspect.fraymotifNames);
        if (ret == null || ret.isEmpty) ret = "Null";
        return aspect.fontTag() + ret + "</font>";
    }

    String getRandomMusicWord(Random rand, Aspect aspect) {
        //takes in an aspect for color
        List<String> names = ["Fortississimo", "Leitmotif", "Liberetto", "Sarabande", "Serenade", "Anthem", "Crescendo", "Vivace", "Encore", "Vivante", "Allegretto", "Fugue", "Choir", "Nobilmente", "Hymn", "Eroico", "Chant", "Mysterioso", "Diminuendo", "Perdendo", "Staccato", "Allegro", "Caloroso", "Nocturne"];
        names.addAll(["Cadenza", "Cadence", "Waltz", "Concerto", "Finale", "Requiem", "Coda", "Dirge", "Battaglia", "Leggiadro", "Capriccio", "Presto", "Largo", "Accelerando", "Polytempo", "Overture", "Reprise", "Orchestra"]);

        var ret = rand.pickFrom(names);
        if (rand.nextDouble() > 0.5) {
            return "<span style='color:${aspect.palette.text.toStyleString()}'>${ret.toLowerCase()}</span>"; //tacked onto existin word
        } else {
            return " $ret"; //extra word
        }
    }

    String tryToGetPreMadeName(Random rand, List<Player> players) {
        if (players == null || players.isEmpty) return null;
        if (rand.nextDouble() > 0.5) return null; //just use the procedural name.

        if (this.premadeFraymotifNames.isEmpty) this.initializePremadeNames();
        for (num i = 0; i < this.premadeFraymotifNames.length; i++) {
            Fraymotif f = this.premadeFraymotifNames[i];
            List<GameEntity> casters = f.getCastersNoOwner(players[0].session.rand, players);
            if (casters.length == f.aspects.length) return f.name;
        }
        return null;
    }

    void initializePremadeNames() {
        this.premadeFraymotifNames = [];

        this.premadeFraymotifNames.add(new Fraymotif("Blinded By The Light", 1, aspects: <Aspect>[Aspects.LIGHT, Aspects.MIND]));
        this.premadeFraymotifNames.add(new Fraymotif("Total Eclipse of the Heart", 1, aspects: <Aspect>[Aspects.LIGHT, Aspects.HEART]));
        this.premadeFraymotifNames.add(new Fraymotif("Stop, Hammertime", 1, aspects: <Aspect>[Aspects.BREATH, Aspects.TIME]));
        this.premadeFraymotifNames.add(new Fraymotif("Wings of Freedom", 1, aspects: <Aspect>[Aspects.BREATH, Aspects.HOPE]));
        this.premadeFraymotifNames.add(new Fraymotif("Happy Ending", 1, aspects: <Aspect>[Aspects.DOOM, Aspects.HOPE]));
        this.premadeFraymotifNames.add(new Fraymotif("Adagio Redshift", 1, aspects: <Aspect>[Aspects.SPACE, Aspects.TIME]));
        this.premadeFraymotifNames.add(new Fraymotif("Time Heals All Wounds", 1, aspects: <Aspect>[Aspects.LIFE, Aspects.TIME]));
        this.premadeFraymotifNames.add(new Fraymotif("Madrigal Melancholia", 1, aspects: <Aspect>[Aspects.HEART, Aspects.DOOM]));
        this.premadeFraymotifNames.add(new Fraymotif("Canon in HS Major", 1, aspects: <Aspect>[Aspects.SPACE, Aspects.TIME, Aspects.BREATH, Aspects.LIGHT]));
        // this.premadeFraymotifNames.add(new Fraymotif("Canon in HS Minor", 1, aspects:<Aspect>[Aspects.LIFE, Aspects.VOID, Aspects.HEART, Aspects.HOPE]));
        this.premadeFraymotifNames.add(new Fraymotif("Another One Bites The Dust", 1, aspects: <Aspect>[Aspects.DOOM, Aspects.TIME]));
        this.premadeFraymotifNames.add(new Fraymotif("Maybe Someday", 1, aspects: <Aspect>[Aspects.HOPE, Aspects.TIME]));
        this.premadeFraymotifNames.add(new Fraymotif("Mind Over Matter", 1, aspects: <Aspect>[Aspects.MIND, Aspects.SPACE]));
        this.premadeFraymotifNames.add(new Fraymotif("Extraterrestrial Ensemble", 1, aspects: <Aspect>[Aspects.SPACE, Aspects.LIFE]));
        this.premadeFraymotifNames.add(new Fraymotif("Lifetime Special", 1, aspects: <Aspect>[Aspects.LIFE, Aspects.TIME]));
        this.premadeFraymotifNames.add(new Fraymotif("Air on a Cosmic String", 1, aspects: <Aspect>[Aspects.SPACE, Aspects.BREATH]));
        this.premadeFraymotifNames.add(new Fraymotif("Rhapsody in Blue", 1, aspects: <Aspect>[Aspects.BREATH, Aspects.VOID]));
        this.premadeFraymotifNames.add(new Fraymotif("Brainstorm", 1, aspects: <Aspect>[Aspects.MIND, Aspects.BREATH]));
        this.premadeFraymotifNames.add(new Fraymotif("Spaced Out", 1, aspects: <Aspect>[Aspects.SPACE, Aspects.VOID]));
        this.premadeFraymotifNames.add(new Fraymotif("Look On The Bright Side", 1, aspects: <Aspect>[Aspects.HOPE, Aspects.LIGHT]));
        this.premadeFraymotifNames.add(new Fraymotif("Lights Out", 1, aspects: <Aspect>[Aspects.LIGHT, Aspects.VOID]));
        this.premadeFraymotifNames.add(new Fraymotif("Lost Hope", 1, aspects: <Aspect>[Aspects.HOPE, Aspects.VOID]));
        this.premadeFraymotifNames.add(new Fraymotif("Grandiose Illuminations", 1, aspects: <Aspect>[Aspects.LIGHT, Aspects.HOPE]));
        this.premadeFraymotifNames.add(new Fraymotif("Lost Hope", 1, aspects: <Aspect>[Aspects.HOPE, Aspects.VOID]));
        this.premadeFraymotifNames.add(new Fraymotif("Flipping the Light Fantastic", 1, aspects: <Aspect>[Aspects.VOID, Aspects.LIGHT, Aspects.HEART]));
        this.premadeFraymotifNames.add(new Fraymotif("Hotel California", 1, aspects: <Aspect>[Aspects.HEART, Aspects.VOID]));
        this.premadeFraymotifNames.add(new Fraymotif("Feel Good", 1, aspects: <Aspect>[Aspects.HOPE, Aspects.HEART]));
        this.premadeFraymotifNames.add(new Fraymotif("Heart's Not In It", 1, aspects: <Aspect>[Aspects.HEART, Aspects.VOID, Aspects.SPACE]));
        this.premadeFraymotifNames.add(new Fraymotif("Freedom of Thought", 1, aspects: <Aspect>[Aspects.MIND, Aspects.BREATH]));
        this.premadeFraymotifNames.add(new Fraymotif("Brick in The Wall", 1, aspects: <Aspect>[Aspects.DOOM, Aspects.RAGE]));
        this.premadeFraymotifNames.add(new Fraymotif("Ancestral Awakening", 1, aspects: <Aspect>[Aspects.BLOOD, Aspects.DOOM, Aspects.LIFE]));
        this.premadeFraymotifNames.add(new Fraymotif("You're Gonna Have a Bad Time", 1, aspects: <Aspect>[Aspects.DOOM, Aspects.TIME]));
        this.premadeFraymotifNames.add(new Fraymotif("I Hope You Die", 1, aspects: <Aspect>[Aspects.DOOM, Aspects.HOPE]));
        this.premadeFraymotifNames.add(new Fraymotif("Free Rage Chicken", 1, aspects: <Aspect>[Aspects.RAGE, Aspects.BREATH]));
        this.premadeFraymotifNames.add(new Fraymotif("Gears of War", 1, aspects: <Aspect>[Aspects.TIME, Aspects.RAGE]));
        this.premadeFraymotifNames.add(new Fraymotif("You Suck", 1, aspects: <Aspect>[Aspects.BREATH, Aspects.VOID]));
        this.premadeFraymotifNames.add(new Fraymotif("Apollo's Chariot", 1, aspects: <Aspect>[Aspects.LIGHT, Aspects.BREATH]));
        this.premadeFraymotifNames.add(new Fraymotif("Planck Fandango", 1, aspects: <Aspect>[Aspects.SPACE, Aspects.HOPE]));
        this.premadeFraymotifNames.add(new Fraymotif("Emancipation Proclamation", 1, aspects: <Aspect>[Aspects.BREATH, Aspects.LIFE]));
        this.premadeFraymotifNames.add(new Fraymotif("Glass Half Empty", 1, aspects: <Aspect>[Aspects.SPACE, Aspects.VOID]));
        this.premadeFraymotifNames.add(new Fraymotif("It's Raining Zen (Hallelujah)", 1, aspects: <Aspect>[Aspects.BLOOD, Aspects.HOPE, Aspects.MIND]));
        this.premadeFraymotifNames.add(new Fraymotif("She Blinded Me With Science", 1, aspects: <Aspect>[Aspects.LIGHT, Aspects.SPACE]));
        this.premadeFraymotifNames.add(new Fraymotif("Never Gonna Let You Down", 1, aspects: <Aspect>[Aspects.TIME, Aspects.LIFE, Aspects.BLOOD]));
        this.premadeFraymotifNames.add(new Fraymotif("Bad Breath", 1, aspects: <Aspect>[Aspects.DOOM, Aspects.BREATH]));
        this.premadeFraymotifNames.add(new Fraymotif("Opposites Attract", 1, aspects: <Aspect>[Aspects.RAGE, Aspects.BLOOD]));
        this.premadeFraymotifNames.add(new Fraymotif("Life and Death and Love and Birth", 1, aspects: <Aspect>[Aspects.LIFE, Aspects.DOOM, Aspects.HEART, Aspects.SPACE]));
        this.premadeFraymotifNames.add(new Fraymotif("Freedom is Slavery", 1, aspects: <Aspect>[Aspects.BREATH, Aspects.DOOM]));
        this.premadeFraymotifNames.add(new Fraymotif("Alternate Universe", 1, aspects: <Aspect>[Aspects.BREATH, Aspects.TIME, Aspects.SPACE]));
        this.premadeFraymotifNames.add(new Fraymotif("Tangle Buddies", 1, aspects: <Aspect>[Aspects.VOID, Aspects.LIFE]));
        this.premadeFraymotifNames.add(new Fraymotif("Let's Pierce the Heavens", 1, aspects: <Aspect>[Aspects.BREATH, Aspects.HOPE]));
        this.premadeFraymotifNames.add(new Fraymotif("Volatile Times", 1, aspects: <Aspect>[Aspects.VOID, Aspects.TIME]));
        this.premadeFraymotifNames.add(new Fraymotif("Mom's Spaghettification", 1, aspects: <Aspect>[Aspects.SPACE, Aspects.VOID]));
        this.premadeFraymotifNames.add(new Fraymotif("Kill the Light", 1, aspects: <Aspect>[Aspects.RAGE, Aspects.DOOM, Aspects.LIGHT]));
        this.premadeFraymotifNames.add(new Fraymotif("Deadly Laser", 1, aspects: <Aspect>[Aspects.DOOM, Aspects.LIGHT]));
        this.premadeFraymotifNames.add(new Fraymotif("Just...Fuck That Guy", 1, aspects: <Aspect>[Aspects.BLOOD, Aspects.MIND, Aspects.BREATH, Aspects.LIGHT, Aspects.SPACE, Aspects.VOID, Aspects.TIME, Aspects.HEART, Aspects.HOPE, Aspects.LIFE, Aspects.DOOM]));

        ///lol, no gamzee
        //vI would do anything for love, but I won't do that///
        this.premadeFraymotifNames.add(new Fraymotif("I would do anything for love, but I won't do that", 1, aspects: <Aspect>[Aspects.BLOOD, Aspects.MIND, Aspects.BREATH, Aspects.LIGHT, Aspects.SPACE, Aspects.VOID, Aspects.TIME, Aspects.RAGE, Aspects.HOPE, Aspects.LIFE, Aspects.DOOM])); //
        this.premadeFraymotifNames.add(new Fraymotif("Homestuck Anthem", 1, aspects: <Aspect>[Aspects.BLOOD, Aspects.MIND, Aspects.BREATH, Aspects.LIGHT, Aspects.SPACE, Aspects.VOID, Aspects.TIME, Aspects.RAGE, Aspects.HOPE, Aspects.LIFE, Aspects.DOOM, Aspects.RAGE]));

        ///l
        this.premadeFraymotifNames.add(new Fraymotif("Grim Fandango", 1, aspects: <Aspect>[Aspects.LIFE, Aspects.DOOM]));
        this.premadeFraymotifNames.add(new Fraymotif("Timeline Evisceration", 1, aspects: <Aspect>[Aspects.MIND, Aspects.TIME, Aspects.DOOM]));
        this.premadeFraymotifNames.add(new Fraymotif("Shipping Grades", 1, aspects: <Aspect>[Aspects.HEART, Aspects.BLOOD]));
        this.premadeFraymotifNames.add(new Fraymotif("In Space, No One Can Hear You Scream", 1, aspects: <Aspect>[Aspects.VOID, Aspects.SPACE, Aspects.RAGE]));
        this.premadeFraymotifNames.add(new Fraymotif("Hope For The Future", 1, aspects: <Aspect>[Aspects.HOPE, Aspects.TIME]));
    }

    dynamic getFraymotifName(Random rand, List<Player> players, int tier) {
        String name = this.tryToGetPreMadeName(rand, players);
        if (name != null) {
            //print("Using a premade procedural fraymotif name: " + name + " " + players[0].session.session_id);
            return name; //premade is good enough here. let the called function handle randomness.
        } else {
            name = "";
        }
        int indexOfMusic = players.length - 1; //used to be random now always at end.
        if (players.length == 1) {
            indexOfMusic = rand.nextIntRange(0, tier - 1);
            for (int i = 0; i < tier; i++) {
                String musicWord = "";
                if (i == indexOfMusic) musicWord = this.getRandomMusicWord(rand, players[0].aspect);
                name += this.getRandomNameForAspect(rand, players[0].aspect) + musicWord + " ";
            }
        } else {
            for (num i = 0; i < players.length; i++) {
                String musicWord = "";
                if (i == indexOfMusic) musicWord = this.getRandomMusicWord(rand, players[i].aspect);
                name += this.getRandomNameForAspect(rand, players[i].aspect) + musicWord + " ";
            }
        }
        //print("player length: "+ players.length + " tier: " + tier + " Name: " + name);
        return name;
    }

    dynamic makeFraymotifForPlayerWithFriends(Player player, Player helper, int tier) {
        //if helper, helper is guaranteed to be part of fraymotif.
        var players_involved = [player];
        if (helper != null) players_involved.add(helper);
        for (num i = 0; i < player.session.players.length; i++) {
            var rand = player.rand.nextDouble();
            var p = player.session.players[i];
            num needed = 0.8;
            if (p.aspect == Aspects.LIGHT || p.aspect == Aspects.BLOOD) needed = 0.6; //light players have to be in the spot light, and blood players just wanna help.
            if (rand > needed && players_involved.indexOf(p) == -1) {
                players_involved.add(p); //MATH% chance of adding each additional player
            }
        }
        //print("Made: " + players_involved .length + " player fraymotif in session: " + player.session);
        return this.makeFraymotif(player.rand, players_involved, tier);
    }

    dynamic findFraymotifNamed(fraymotifs, name) {
        for (num i = 0; i < fraymotifs.length; i++) {
            if (fraymotifs[i].name == name) return fraymotifs[i];
        }
        return null;
    }

    dynamic makeFraymotif(Random rand, List<Player> players, int tier) {
        //asumming first player in that array is the owner of the framotif later on.
        if (players.length == 1 && players[0].class_name == SBURBClassManager.WASTE && tier == 3) {
            //check to see if we are upgrading rocks fall.
            Fraymotif f = this.findFraymotifNamed(players[0].fraymotifs, "Rocks Fall, Everyone Dies");
            if (f != null && f.tier < 10) {
                f.tier = 99;
                f.baseValue = 9999;
                f.name += " (True Form)";
                f.desc = "Incredibly huge meteors rain down from above. What the hell??? Didn't this used to suck?  Hax! I call hax!";
                return f;
            }
        }

        String name = this.getFraymotifName(rand, players, tier);
        List<dynamic> aspects = [];
        for (num i = 0; i < players.length; i++) {
            aspects.add(players[i].aspect); //allow fraymotifs tht are things like time/time. doomed time clones need love.
        }
        name += " (Tier $tier)";
        Fraymotif f = new Fraymotif(name, tier, aspects: aspects);
        f.addEffectsForPlayers(players);
        return f;
    }

}


//effects are frozen at creation, basically.  if this fraymotif is created by a Bard of Breath in a session with a Prince of Time,
//who then dies, and then a combo session results in an Heir of Time being able to use it with the Bard of Breath, then it'll still have the prince effect.
class FraymotifEffect {
    String statName; //hp heals current hp AND revives the player.
    num target; //self, allies or enemy or enemies, 0, 1, 2, 3
    bool damageInsteadOfBuff; // statName can either be applied towards damaging someone or buffing someone.  (damaging self or allies is "healing", buffing enemies is applied in the negative direction.)
    num s = 0; //convineience methods cause i don't think js has enums but am too lazy to confirm.
    num a = 1;
    num e = 2;
    num e2 = 3;

    String flavorText = ""; // ? is this even used


    FraymotifEffect(this.statName, this.target, this.damageInsteadOfBuff, [this.flavorText = ""]) {}


    void setEffectForPlayer(Player player) {
        Random rand = player.rand;
        var effect = new FraymotifEffect("", this.e, true); //default to just damaging the enemy.
        if (player.class_name == SBURBClassManager.KNIGHT) effect = rand.pickFrom(this.knightEffects());
        if (player.class_name == SBURBClassManager.SEER) effect = rand.pickFrom(this.seerEffects());
        if (player.class_name == SBURBClassManager.BARD) effect = rand.pickFrom(this.bardEffects());
        if (player.class_name == SBURBClassManager.HEIR) effect = rand.pickFrom(this.heirEffects());
        if (player.class_name == SBURBClassManager.MAID) effect = rand.pickFrom(this.maidEffects());
        if (player.class_name == SBURBClassManager.ROGUE) effect = rand.pickFrom(this.rogueEffects());
        if (player.class_name == SBURBClassManager.PAGE) effect = rand.pickFrom(this.pageEffects());
        if (player.class_name == SBURBClassManager.THIEF) effect = rand.pickFrom(this.thiefEffects());
        if (player.class_name == SBURBClassManager.SYLPH) effect = rand.pickFrom(this.sylphEffects());
        if (player.class_name == SBURBClassManager.PRINCE) effect = rand.pickFrom(this.princeEffects());
        if (player.class_name == SBURBClassManager.WITCH) effect = rand.pickFrom(this.witchEffects());
        if (player.class_name == SBURBClassManager.MAGE) effect = rand.pickFrom(this.mageEffects());
        this.target = effect.target;
        this.damageInsteadOfBuff = effect.damageInsteadOfBuff;
        if (!player.associatedStats.isEmpty) { //null plyaers have no associated stats
            this.statName = rand.pickFrom(player.associatedStatsFromAspect).name;
        } else {
            this.statName = "MANGRIT";
        }
    }

    dynamic knightEffects() {
        return [new FraymotifEffect("", this.s, true), new FraymotifEffect("", this.e, true), new FraymotifEffect("", this.e2, true), new FraymotifEffect("", this.s, false), new FraymotifEffect("", this.e, false)];
    }

    dynamic seerEffects() {
        return [new FraymotifEffect("", this.a, true), new FraymotifEffect("", this.s, false), new FraymotifEffect("", this.e, false), new FraymotifEffect("", this.e2, false), new FraymotifEffect("", this.a, false)];
    }

    dynamic bardEffects() {
        List<FraymotifEffect> ret = [new FraymotifEffect("", this.s, false), new FraymotifEffect("", this.e, false), new FraymotifEffect("", this.e2, false), new FraymotifEffect("", this.a, false)];
        ret.addAll([new FraymotifEffect("", this.s, true), new FraymotifEffect("", this.e, true), new FraymotifEffect("", this.e2, true), new FraymotifEffect("", this.a, true)]);
        return ret;
    }

    dynamic heirEffects() {
        return [new FraymotifEffect("", this.s, true), new FraymotifEffect("", this.e2, true), new FraymotifEffect("", this.s, false)];
    }

    dynamic maidEffects() {
        return [new FraymotifEffect("", this.e2, true), new FraymotifEffect("", this.e, false), new FraymotifEffect("", this.a, false)];
    }

    dynamic rogueEffects() {
        return [new FraymotifEffect("", this.e, true), new FraymotifEffect("", this.a, false), new FraymotifEffect("", this.e, false)];
    }

    dynamic pageEffects() {
        return [new FraymotifEffect("", this.a, true), new FraymotifEffect("", this.a, false)];
    }

    dynamic thiefEffects() {
        return [new FraymotifEffect("", this.e, true), new FraymotifEffect("", this.s, false), new FraymotifEffect("", this.e, false)];
    }

    dynamic sylphEffects() {
        return [new FraymotifEffect("", this.a, true), new FraymotifEffect("", this.s, false), new FraymotifEffect("", this.a, false)];
    }

    dynamic princeEffects() {
        return [new FraymotifEffect("", this.e, true), new FraymotifEffect("", this.e2, true), new FraymotifEffect("", this.e2, false)];
    }

    dynamic witchEffects() {
        return [new FraymotifEffect("", this.e, true), new FraymotifEffect("", this.s, true), new FraymotifEffect("", this.e2, false)];
    }

    dynamic mageEffects() {
        return [new FraymotifEffect("", this.a, true), new FraymotifEffect("", this.s, true), new FraymotifEffect("", this.e2, false), new FraymotifEffect("", this.e, false)];
    }

    void applyEffect(owner, allies, casters, enemy, enemies, baseValue) {
        var strifeValue = this.processEffectValue(casters, enemies);
        var effectValue = baseValue;
        if (strifeValue < baseValue) effectValue = baseValue;
        if (strifeValue > baseValue && strifeValue < (2 * baseValue)) effectValue = 2 * baseValue;
        if (strifeValue > (2 * baseValue)) effectValue = 3 * baseValue;

        //now, i need to USE this effect value.  is it doing "damage" or "buffing"?
        if (this.target == this.e || this.target == this.e2) effectValue = effectValue * -1; //do negative things to the enemy.
        var targetArr = this.chooseTargetArr(owner, allies, casters, enemy, enemies);
        //print(["target chosen: ", targetArr]);
        if (this.damageInsteadOfBuff) {
            //print("applying damage: " + targetArr.length);
            this.applyDamage(targetArr, effectValue);
        } else {
            //print("applying buff");
            this.applyBuff(targetArr, effectValue);
        }
    }

    dynamic chooseTargetArr(owner, allies, casters, enemy, enemies) {
        //print(["potential targets: ",owner, allies, casters, enemies]);
        if (this.target == this.s) return [owner];
        if (this.target == this.a) return allies;
        if (this.target == this.e) return [enemy]; //all effects target same enemy.
        if (this.target == this.e2) return enemies;
        return null;
    }

    void applyDamage(targetArr, effectValue) {
        var e = effectValue / targetArr.length; //more potent when a single target.
        //print(["applying damage", effectValue, targetArr.length, e]);
        for (num i = 0; i < targetArr.length; i++) {
            var t = targetArr[i];
            t.makeAlive();
            t.buffs.add(new Buff("currentHP", e)); //don't mod directly anymore
        }
    }

    void applyBuff(targetArr, effectValue) {
        var e = effectValue / targetArr.length; //more potent when a single target.
        for (num i = 0; i < targetArr.length; i++) {
            var t = targetArr[i];
            if (this.statName != "RELATIONSHIPS") {
                //t[this.statName] += e;
                t.buffs.add(new Buff(this.statName, e)); //don't mod directly anymore
            } else {
                for (num j = 0; j < t.relationships.length; j++) {
                    //t.relationships[j].value += e;
                    t.buffs.add(new Buff(this.statName, e));
                }
            }
        }
    }

    dynamic processEffectValue(casters, enemies) {
        num ret = 0;
        for (num i = 0; i < casters.length; i++) {
            var tmp = casters[i];
            ret += tmp.getStat(this.statName);
        }

        for (num i = 0; i < enemies.length; i++) {
            var tmp = enemies[i];
            ret += tmp.getStat(this.statName);
        }
        return ret;
    }

    dynamic toStringSimple() {
        String ret = "";
        if (this.damageInsteadOfBuff && this.target < 2) {
            ret += "a heals";
        } else if (this.damageInsteadOfBuff && this.target >= 2) {
            ret += "a damages";
        } else if (!this.damageInsteadOfBuff && this.target < 2) {
            ret += "a buffs";
        } else if (!this.damageInsteadOfBuff && this.target >= 2) {
            ret += "a debuffs";
        }

        if (this.target == 0) {
            ret += " SELF";
        } else if (this.target == 1) {
            ret += " FRIENDSBLUH";
        } else if (this.target == 2) {
            ret += " EBLUH";
        } else if (this.target == 3) {
            ret += " ESBLUHS";
        }

        ret += " of STAT ";

        if (this.target == 0) {
            ret += " envelopes the OWNER";
        } else if (this.target == 1) {
            ret += " surrounds the allies";
        } else if (this.target == 2) {
            ret += " pierces the ENEMY";
        } else if (this.target == 3) {
            ret += " surrounds all enemies";
        }
        return ret;
    }

    @override
    String toString() {
        String ret = "";
        if (this.damageInsteadOfBuff && this.target < 2) {
            ret += " heals";
        } else if (this.damageInsteadOfBuff && this.target >= 2) {
            ret += " damages";
        } else if (!this.damageInsteadOfBuff && this.target < 2) {
            ret += " buffs";
        } else if (!this.damageInsteadOfBuff && this.target >= 2) {
            ret += " debuffs";
        }

        if (this.target == 0) {
            ret += " self";
        } else if (this.target == 1) {
            ret += " allies";
        } else if (this.target == 2) {
            ret += " an enemy";
        } else if (this.target == 3) {
            ret += " all enemies";
        }
        String stat = "STAT";
        ret += " based on how " + stat + " the casters are compared to their enemy";
        return ret;
    }

}
