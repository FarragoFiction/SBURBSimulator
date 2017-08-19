import 'dart:convert';
import "dart:html";
import "dart:math" as Math;
import "dart:typed_data";
import "../SBURBSim.dart";
import "../includes/bytebuilder.dart";

class Player extends GameEntity {
    //TODO trollPlayer subclass of player??? (have subclass of relationship)
    num baby = null;
    num pvpKillCount = 0; //for stats.
    num timesDied = 0;
    GameEntity denizen = null;
    GameEntity denizenMinion = null;
    num maxHornNumber = 73; //don't fuck with this
    num maxHairNumber = 74; //same
    Sprite sprite = null; //gets set to a blank sprite when character is created.
    bool deriveChatHandle = true;
    String flipOutReason = null; //if it's null, i'm not flipping my shit.
    Player flippingOutOverDeadPlayer = null; //don't let this go into url. but, don't flip out if the friend is currently alive, you goof.
    num denizen_index = 0; //denizen quests are in order.
    List<Player> ghostWisdom = <Player>[]; //keeps you from spamming the same ghost over and over for wisdom.
    String land1 = null; //words my land is made of. //TODO eventually folded into planet
    String land2 = null;
    bool trickster = false;
    bool sbahj = false;
    List<dynamic> sickRhymes = <dynamic>[]; //oh hell yes. Hell. FUCKING. Yes! TODO: make this its own type -PL
    bool robot = false;
    num ectoBiologicalSource = null; //might not be created in their own session now.
    SBURBClass class_name; //TODO make class and aspect an object, not a string.  have that object ONLY place things happen based on classpect.  Player asks classpect "How do I increase power"? and aspect has static for colors and what associated stats that player should get.
    Player guardian = null; //no longer the sessions job to keep track.
    num number_confessions = 0;
    num number_times_confessed_to = 0;
    bool baby_stuck = false;
    String influenceSymbol = null; //multiple aspects can influence/mind control.
    Player influencePlayer = null; //who is controlling me? (so i can break free if i have more free will or they die)
    MiniSnapShot stateBackup = null; //if you get influenced by something, here's where your true self is stored until you break free.
    Aspect aspect; //TODO eventually a full object
    String land = null;
    Interest interest1 = null; //TODO maybe interest categories are objects too, know what is inside them and what they do
    Interest interest2 = null;
    String chatHandle = null;
    GameEntity object_to_prototype; //mostly will be potential sprites, but sometimes a player
    //List<Relationship> relationships = [];  //TODO keep a list of player relationships and npc relationships. MAYBE don't wax red for npcs? dunno though.
    String moon; //TODO eventually a shared planet between players.
    bool leveledTheHellUp = false; //triggers level up scene.
    List<String> mylevels = null;
    num level_index = -1; //will be ++ before i query
    bool godTier = false;
    String victimBlood = null; //used for murdermode players.
    num hair = null; //num hair = 16;
    String hairColor = null;
    bool dreamSelf = true;
    bool isTroll = false; //later
    String bloodColor = "#ff0000"; //human red.
    num leftHorn = null;
    num rightHorn = null;
    GameEntity myLusus = null;
    Quirk quirk = null;

    bool godDestiny = false;
    bool canGodTierRevive = true; //even if a god tier perma dies, a life or time player or whatever can brings them back.
    bool isDreamSelf = false; //players can be triggered for various things. higher their triggerLevle, greater chance of going murdermode or GrimDark.
    bool murderMode = false; //kill all players you don't like. odds of a just death skyrockets.
    bool leftMurderMode = false; //have scars, unless left via death.
    num corruptionLevelOther = 0; //every 100 points, sends you to next grimDarkLevel.
    num gnosis = 0; //sburbLore causes you to increase a level of this.
    num grimDark = 0; //  0 = none, 1 = some, 2 = some more 3 = full grim dark with aura and font and everything.
    bool leader = false;
    num landLevel = 0; //at 10, you can challenge denizen.  only space player can go over 100 (breed better universe.)
    bool denizenFaced = false;
    bool denizenDefeated = false;
    bool denizenMinionDefeated = false;

    Player([Session session, SBURBClass this.class_name, Aspect this.aspect, GameEntity this.object_to_prototype, String this.moon, bool this.godDestiny]) : super("", session) {
        this.name = "player_$id"; //this.htmlTitleBasic();
    }


    bool fromThisSession(Session session) {
        return (this.ectoBiologicalSource == null || this.ectoBiologicalSource == session.session_id);
    }

    bool interestedInCategory(InterestCategory c) {
        return (interest1.category == c || interest2.category == c);
    }

    @override
    void setStat(String statName, num value) {
        if (statName == "RELATIONSHIPS") throw "Players modify the actual relationships, not the calculated value.";
        super.setStat(statName, value);
    }

    @override //literally ad value to existing value
    void addStat(String statName, num value) {
        if (statName == "RELATIONSHIPS") throw "Players modify the actual relationships, not the calculated value.";

        super.addStat(statName, value);
    }


    bool isQuadranted() {
        if (!this
            .getHearts()
            .isEmpty) return true;
        if (!this
            .getClubs()
            .isEmpty) return true;
        if (!this
            .getDiamonds()
            .isEmpty) return true;
        if (!this
            .getSpades()
            .isEmpty) return true;
        return false;
    }

    List<Relationship> getClubs() {
        List<Relationship> ret = <Relationship>[];
        for (num i = 0; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];
            if (r.saved_type == r.clubs) {
                ret.add(r);
            }
        }
        return ret;
    }

    @override
    List<Relationship> getHearts() {
        List<Relationship> ret = <Relationship>[];
        for (num i = 0; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];
            if (r.saved_type == r.heart) {
                ret.add(r);
            }
        }
        return ret;
    }

    num getOverallStrength() {
        num ret = 0;
        ret += this.getStat("power");
        ret += this.getStat("alchemy");
        ret += this.getStat("freeWill").abs();
        ret += this.getStat("mobility").abs();
        ret += this.getStat("hp").abs();
        ret += (this.getStat("maxLuck") + this.getStat("minLuck")).abs();
        ret += this.getStat("sanity").abs();
        return ret;
    }

    void generateDenizen() {
        List<String> possibilities = this.aspect.denizenNames;
        num strength = this.getOverallStrength();
        num expectedMaxStrength = 150; //if i change how stats work, i need to update this value
        num strengthPerTier = (expectedMaxStrength) / possibilities.length;
        //print("Strength at start is, " + strength);//but what if you don't want STRANGTH!???
        int denizenIndex = (strength / strengthPerTier).round() - 1; //want lowest value to be off the denizen array.

        String denizenName = "";
        num denizenStrength = (denizenIndex / (possibilities.length)) + 1; //between 1 and 2;
        //print("Strength for denizen calculated from index of: " + denizenIndex + " out of " + possibilities.length);
        if (denizenIndex == 0) {
            denizenName = this.weakDenizenNames();
            denizenStrength = 0.1; //fraymotifs about standing and looking at your pittifully
            print("strength demands a weak denizen ${this.session.session_id}");
        } else if (denizenIndex >= possibilities.length) {
            denizenName = this.strongDenizenNames(); //<-- doesn't have to be literally him. points for various mispellings of his name.
            denizenStrength = 5;
            print("Strength demands strong denizen. ${this.session.session_id}");
        } else {
            denizenName = possibilities[denizenIndex];
        }

        this.makeDenizenWithStrength(denizenName, denizenStrength); //if you pick the middle enizen it will be at strength of "1", if you pick last denizen, it will be at 2 or more.

    }

    void makeDenizenWithStrength(String name, num strength) {
        //print("Strength for denizen " + name + " is: " + strength);
        //based off existing denizen code.  care about which aspect i am.
        //also make minion here.
        GameEntity denizen = new Denizen("Denizen $name", this.session);
        GameEntity denizenMinion = new DenizenMinion("$name Minion", this.session);
        Map<String, num> tmpStatHolder = <String, num>{};
        tmpStatHolder["minLuck"] = -10;
        tmpStatHolder["maxLuck"] = 10;
        tmpStatHolder["hp"] = 10 * strength;
        tmpStatHolder["mobility"] = 10;
        tmpStatHolder["sanity"] = 10;
        tmpStatHolder["alchemy"] = 10;
        tmpStatHolder["freeWill"] = 10;
        tmpStatHolder["power"] = 5 * strength;
        tmpStatHolder["grist"] = 1000;
        tmpStatHolder["sburbLore"] = 0; //needed so associated stats don't crash
        tmpStatHolder["RELATIONSHIPS"] = 10; //not REAL relationships, but real enough for our purposes.
        for (num i = 0; i < this.associatedStats.length; i++) {
            //alert("I have associated stats: " + i);
            AssociatedStat stat = this.associatedStats[i];
            if (stat.name == "MANGRIT") {
                tmpStatHolder["power" ] = tmpStatHolder["power"] * stat.multiplier * strength;
            } else {
                tmpStatHolder[stat.name] += tmpStatHolder[stat.name] * stat.multiplier * strength;
            }
        }

        //denizenMinion.setStats(tmpStatHolder.minLuck,tmpStatHolder.maxLuck,tmpStatHolder.hp,tmpStatHolder.mobility,tmpStatHoldergetStat("sanity"),tmpStatHolder.freeWill,tmpStatHolder.getStat("power"),true, false, [],1000);

        denizenMinion.setStatsHash(tmpStatHolder);
        tmpStatHolder["power"] = 10 * strength;
        for (String key in tmpStatHolder.keys) {
            tmpStatHolder[key] = tmpStatHolder[key] * 2; // same direction as minion stats, but bigger.
        }
        //denizen.setStats(tmpStatHolder.minLuck,tmpStatHolder.maxLuck,tmpStatHolder.hp,tmpStatHolder.mobility,tmpStatHoldergetStat("sanity"),tmpStatHolder.freeWill,tmpStatHolder.getStat("power"),true, false, [],1000000);
        denizen.setStatsHash(tmpStatHolder);
        this.denizen = denizen;
        this.denizenMinion = denizenMinion;
        this.session.fraymotifCreator.createFraymotifForPlayerDenizen(this, name);
    }

    String strongDenizenNames() {
        //print("What if you don't want stranth? ${this.session.session_id}");
        List<String> ret = <String>['Yaldabaoth', 'Javascript', '<span class = "void">Nobrop, the </span>Null', '<span class = "void">Paraxalan, The </span>Ever-Searching', "<span class = 'void'>Algebron, The </span>Dilletant", '<span class = "void">Doomod, The </span>Wanderer', 'Jörmungandr', 'Apollyon', 'Siseneg', 'Borunam', '<span class = "void">Jadeacher the,</span>Researcher', 'Karmiution', '<span class = "void">Authorot, the</span> Robot', '<span class = "void">Abbiejean, the </span>Scout', '<span class = "void">Aspiratcher, The</span> Librarian', '<span class = "void">Recurscker, The</span>Hollow One', 'Insurorracle', '<span class = "void">Maniomnia, the </span>Dreamwaker', 'Kazerad', 'Shiva', 'Goliath'];
        return this.session.rand.pickFrom(ret);
    }

    String weakDenizenNames() {
        List<String> ret = <String>['Eriotur', 'Abraxas', 'Succra', 'Watojo', 'Bluhubit', 'Swefrat', 'Helaja', 'Fischapris'];
        return this.session.rand.pickFrom(ret);
    }

    @override
    void flipOut(String reason) {
        //print("flip out method called for: " + reason);
        this.flippingOutOverDeadPlayer = null;
        this.flipOutReason = reason;
    }

    @override
    void changeGrimDark(num val) {
        //this.grimDark += val;
        num tmp = this.grimDark + val;
        bool render = false;

        if (this.grimDark <= 3 && tmp > 3) { //newly GrimDark
            print("grim dark 3 or more in session: ${this.session.session_id}");
            render = true;
        } else if (this.grimDark > 3 && tmp <= 3) { //newly recovered.
            render = true;
        }
        this.grimDark += val;
        if (render) {
            this.renderSelf();
        }
    }

    void makeMurderMode() {
        this.murderMode = true;
        this.increasePower();
        this.renderSelf(); //new scars. //can't do scars just on top of sprite 'cause hair might cover.'
    }

    void unmakeMurderMode() {
        this.murderMode = false;
        this.leftMurderMode = true;
        this.renderSelf();
    }

    void addDoomedTimeClone(Player timeClone) {
        doomedTimeClones.add(timeClone);
        addStat("sanity", -10);
        flipOut("their own doomed time clones");
    }


    @override
    void makeDead(String causeOfDeath) {
        this.dead = true;
        this.timesDied ++;
        this.buffs.clear();
        this.causeOfDeath = sanitizeString(causeOfDeath);
        if (this.getStat("currentHP") > 0) this.setStat("currentHP", -1); //just in case anything weird is going on. dead is dead.  (for example, you could have been debuffed of hp).
        if (!this.godTier) { //god tiers only make ghosts in GodTierRevivial
            Player g = Player.makeRenderingSnapshot(this);
            g.fraymotifs = new List<Fraymotif>.from(this.fraymotifs); //copy not reference
            this.session.afterLife.addGhost(g);
        }

        this.renderSelf();
        this.triggerOtherPlayersWithMyDeath();
    }

    void triggerOtherPlayersWithMyDeath() {
        //go through my relationships. if i am the only dead person, trigger everybody (death still has impact)
        //trigger (possibly ontop of base trigger) friends, and quadrant mates. really fuck up my moirel(s) if i have any
        //if triggered, also give a flip out reason.
        List<Player> dead = findDeadPlayers(this.session.players);
        for (num i = 0; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];

            if (r.saved_type == r.goodBig) {
                r.target.addStat("sanity", -10);
                if (r.target.flipOutReason == null) {
                    r.target.flipOutReason = " their dead crush, the ${this.htmlTitleBasic()}"; //don't override existing flip out reasons. not for something as generic as a dead crush.
                    r.target.flippingOutOverDeadPlayer = this;
                }
            } else if (r.value > 0) {
                r.target.addStat("sanity", -10);
                if (r.target.flipOutReason == null) {
                    r.target.flippingOutOverDeadPlayer = this;
                    r.target.flipOutReason = " their dead friend, the ${this.htmlTitleBasic()}"; //don't override existing flip out reasons. not for something as generic as a dead friend.
                }
            } else if (r.saved_type == r.spades) {
                r.target.addStat("sanity", -100);
                r.target.flipOutReason = " their dead Kismesis, the ${this.htmlTitleBasic()}";
                r.target.flippingOutOverDeadPlayer = this;
            } else if (r.saved_type == r.heart) {
                r.target.addStat("sanity", -100);
                r.target.flipOutReason = " their dead Matesprit, the ${this.htmlTitleBasic()}";
                r.target.flippingOutOverDeadPlayer = this;
            } else if (r.saved_type == r.diamond) {
                r.target.addStat("sanity", -1000);
                r.target.damageAllRelationships();
                r.target.damageAllRelationships();
                r.target.damageAllRelationships();
                r.target.flipOutReason = " their dead Moirail, the ${this.htmlTitleBasic()}, fuck, that can't be good...";
                r.target.flippingOutOverDeadPlayer = this;
            }

            //whether or not i care about them, there's also the novelty factor.
            if (dead.length == 1) { //if only I am dead, death still has it's impact and even my enemies care.
                r.target.addStat("sanity", -10);
                if (r.target.flipOutReason == null) {
                    r.target.flipOutReason = " the dead player, the ${this.htmlTitleBasic()}"; //don't override existing flip out reasons. not for something as generic as a dead player.
                    r.target.flippingOutOverDeadPlayer = this;
                }
            }
            //print(r.target.title() + " has flipOutReason of: " + r.target.flipOutReason + " and knows about dead player: " + r.target.flippingOutOverDeadPlayer);
        }
    }

    Player getPactWithGhost(Player ghost) {
        for (num i = 0; i < this.ghostPacts.length; i++) {
            Player g = this.ghostPacts[i].ghost;
            if (g == ghost) return g;
        }
        return null;
    }

    List<Relationship> getSpades() {
        List<Relationship> ret = <Relationship>[];
        for (num i = 0; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];
            if (r.saved_type == r.spades) {
                ret.add(r);
            }
        }
        return ret;
    }

    List<Relationship> getCrushes() {
        List<Relationship> ret = <Relationship>[];
        for (num i = 0; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];
            if (r.saved_type == r.goodBig) {
                ret.add(r);
            }
        }
        return ret;
    }

    List<Relationship> getBlackCrushes() {
        List<Relationship> ret = <Relationship>[];
        for (num i = 0; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];
            if (r.saved_type == r.badBig) {
                ret.add(r);
            }
        }
        return ret;
    }

    @override
    List<Relationship> getDiamonds() {
        List<Relationship> ret = <Relationship>[];
        for (num i = 0; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];
            if (r.saved_type == r.diamond) {
                ret.add(r);
            }
        }
        return ret;
    }

    String chatHandleShort() {
        RegExp exp = new RegExp(r"""\b(\w)|[A-Z]""", multiLine: true);
        return joinMatches(exp.allMatches(chatHandle)).toUpperCase();
    }

    String chatHandleShortCheckDup(String otherHandle) {
        RegExp exp = new RegExp(r"""\b(\w)|[A-Z]""", multiLine: true);
        String tmp = joinMatches(exp.allMatches(chatHandle)).toUpperCase();
        if (tmp == otherHandle) {
            tmp = "${tmp}2";
        }
        return tmp;
    }

    void makeGodTier() {
        this.addStat("hp", 500); //they are GODS.
        this.addStat("currentHP", 500); //they are GODS.
        this.addStat("power", 500); //they are GODS.
        this.increasePower();
        this.godTier = true;
        this.session.godTier = true;
        this.dreamSelf = false;
        this.canGodTierRevive = true;
        this.leftMurderMode = false; //no scars, unlike other revival methods
        this.isDreamSelf = false;
        this.makeAlive();
    }

    @override
    void makeAlive() {
        if (this.dead == false) return; //don't do all this.
        if (this.stateBackup != null) this.stateBackup.restoreState(this);
        this.influencePlayer = null;
        this.influenceSymbol = null;
        this.dead = false;
        this.murderMode = false;
        this.setStat("currentHP", Math.max(this.getStat("hp"), 1)); //if for some reason your hp is negative, don't do that.
        //print("HP after being brought back from the dead: " + this.currentHP);
        this.grimDark = 0;
        this.addStat("sanity", -101); //dying is pretty triggering.
        this.flipOutReason = "they just freaking died";
        //this.leftMurderMode = false; //no scars
        this.victimBlood = null; //clean face
        this.renderSelf();
    }

    @override
    bool renderable() {
        return true;
    }

    @override
    String title() {
        String ret = "";

        if (this.doomed) {
            ret = "${ret}Doomed ";
        }

        if (this.trickster) {
            ret = "${ret}Trickster ";
        }

        if (this.murderMode) {
            ret = "${ret}Murder Mode ";
        }

        if (this.grimDark > 3) {
            ret = "${ret}Severely Grim Dark ";
        } else if (this.grimDark > 1) {
            ret = "${ret}Mildly Grim Dark ";
        } else if (this.grimDark > 2) {
            ret = "${ret}Grim Dark ";
        }

        if (this.godTier) {
            ret = "${ret}God Tier ";
        } else if (this.isDreamSelf) {
            ret = "${ret}Dream ";
        }
        if (this.robot) {
            ret = "${ret}Robo";
        }
        ret = "$ret${this.class_name} of ${this.aspect}";
        if (this.dead) {
            ret = "$ret's Corpse";
        } else if (this.ghost) {
            ret = "$ret's Ghost";
        }
        ret = "$ret (${this.chatHandle})";
        return ret;
    }

    @override
    String htmlTitleBasic() {
        return "${this.aspect.fontTag()}${this.titleBasic()}</font>";
    }

    //@override
    String titleBasic() {
        String ret = "";

        ret = "$ret${this.class_name} of ${this.aspect}";
        return ret;
    }


    String getNextLevel() {
        this.level_index ++;
        String ret = this.level_index >= this.mylevels.length ? "[Off the top of the Echeladder]" : this.mylevels[this.level_index];
        return ret;
    }

    String getRandomQuest() {
        if (this.landLevel >= 9 && this.denizen_index < 3 && this.denizenDefeated == false) { //three quests before denizen
            //print("denizen quest");
            return this.aspect.getDenizenQuest(this); //denizen quests are aspect only, no class.
        } else if ((this.landLevel < 9 || this.denizen_index >= 3) && this.denizenDefeated == false) { //can do more land quests if denizen kicked your ass. need to grind.
            if (this.session.rand.nextDouble() < this.aspect.aspectQuestChance) { //back to having space players be locked to frogs.
                return this.aspect.getRandomQuest(rand, denizenDefeated);
            } else {
                return this.class_name.getQuest(rand, false);
            }
        } else if (this.denizenDefeated) {
            //print("post denizen quests " +this.session.session_id);
            //return "restoring their land from the ravages of " + this.session.getDenizenForPlayer(this).name;
            if (this.session.rand.nextDouble() < this.aspect.aspectQuestChance) { //back to having space players be locked to frogs.
                return this.aspect.getRandomQuest(rand, denizenDefeated);
            } else {
                return this.class_name.getQuest(rand, true);
            }
        }
        return null;
    }

    String canMindControl() {
        for (num i = 0; i < this.fraymotifs.length; i++) {
            if (this.fraymotifs[i].name == "Mind Control") return this.fraymotifs[i].name;
        }
        return null;
    }

    String canGhostCommune() {
        for (num i = 0; i < this.fraymotifs.length; i++) {
            if (this.fraymotifs[i].name == "Ghost Communing") return this.fraymotifs[i].name;
        }
        return null;
    }

    List<Fraymotif> psionicList() {
        List<Fraymotif> psionics = <Fraymotif>[];
        //telekenisis, mind control, mind reading, ghost communing, animal communing, laser blasts, vision xfold.
            {
            Fraymotif f = new Fraymotif("Telekinisis", 1);
            f.effects.add(new FraymotifEffect("power", 2, true));
            f.desc = " Large objects begin pelting the ENEMY. ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Pyrokinisis", 1);
            f.effects.add(new FraymotifEffect("power", 2, true));
            f.desc = " Who knew shaving cream was so flammable? ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Aquakinesis", 1);
            f.effects.add(new FraymotifEffect("power", 2, true));
            f.desc = " A deluge begins damaging the ENEMY. ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Mind Control", 1);
            f.effects.add(new FraymotifEffect("freeWill", 3, true));
            f.effects.add(new FraymotifEffect("freeWill", 3, false));
            f.desc = " All enemies start damaging themselves. It's kind of embarassing how easy this is.  ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Optic Blast", 1);
            f.effects.add(new FraymotifEffect("power", 2, true));
            f.desc = " Appropriately colored eye beams pierce the ENEMY. ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Ghost Communing", 1);
            f.effects.add(new FraymotifEffect("sanity", 3, true));
            f.effects.add(new FraymotifEffect("sanity", 3, false));
            f.desc = " The souls of the dead start hassling all enemies. ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Animal Communing", 1);
            f.effects.add(new FraymotifEffect("sanity", 3, true));
            f.effects.add(new FraymotifEffect("sanity", 3, false));
            f.desc = " Local animal equivalents start hassling all enemies. ";
            psionics.add(f);
        }

        return psionics;
    }

    void applyPossiblePsionics() {
        // print("Checking to see how many fraymotifs I have: " + this.fraymotifs.length + " and if I am a troll: " + this.isTroll);
        if (!this.fraymotifs.isEmpty || !this.isTroll) return; //if i already have fraymotifs, then they were probably predefined.
        //highest land dwellers can have chucklevoodoos. Other than that, lower on hemospectrum = greater odds of having psionics.;
        //make sure psionic list is kept in global var, so that char creator eventually can access? Wait, no, just wrtap it in a function here. don't polute global name space.
        //trolls can clearly have more than one set of psionics. so. odds of psionics is inverse with hemospectrum position. didn't i do this math before? where?
        //oh! low blood vocabulary!!! that'd be in quirks, i think.
        //print("My blood color is: " + this.bloodColor);
        num odds = 10 - bloodColors.indexOf(this.bloodColor); //want gamzee and above to have NO powers (will give highbloods chucklevoodoos separate)
        List<Fraymotif> powers = this.psionicList();
        for (num i = 0; i < powers.length; i++) {
            if (this.session.rand.nextDouble() * 40 < odds) { //even burgundy bloods have only a 25% shot of each power.
                this.fraymotifs.add(powers[i]);
            }
        }
        //special psionics for high bloods and lime bloods.  highblood: #631db4  lime: #658200
        if (this.bloodColor == "#631db4") {
            Fraymotif f = new Fraymotif("Chucklevoodoos", 1);
            f.effects.add(new FraymotifEffect("sanity", 3, false));
            f.effects.add(new FraymotifEffect("sanity", 3, true));
            f.desc = " Oh god oh no no no no no no no no. The enemies are no longer doing okay, psychologically speaking. ";
            this.fraymotifs.add(f);
        } else if (this.bloodColor == "#658200") {
            Fraymotif f = new Fraymotif("Limeade Refreshment", 1);
            f.effects.add(new FraymotifEffect("sanity", 1, false));
            f.effects.add(new FraymotifEffect("sanity", 1, true));
            f.desc = " All allies just settle their shit for a little while. Cool it. ";
            this.fraymotifs.add(f);
        } else if (this.bloodColor == "#ffc3df") {
            Fraymotif f = new Fraymotif("'<font color='pink'>${this.chatHandle} and the Power of Looove~~~~~<3<3<3</font>'", 1);
            f.effects.add(new FraymotifEffect("RELATIONSHIPS", 3, false));
            f.effects.add(new FraymotifEffect("RELATIONSHIPS", 3, true));
            f.desc = " You are pretty sure this is not a real type of Troll Psionic.  It heals everybody in a bullshit parade of sparkles, and heart effects despite your disbelief. Everybody is also SUPER MEGA ULTRA IN LOVE with each other now, but ESPECIALLY in love with ${this.htmlTitleHP()}. ";
            this.fraymotifs.add(f);
        }
    }

    bool isVoidAvailable() {
        Player light = findAspectPlayer(findLivingPlayers(this.session.players), Aspects.LIGHT);
        if (light != null && light.godTier) return false;
        return true;
    }

    num getPVPModifier(String role) {
        if (role == "Attacker") return this.getAttackerModifier();
        if (role == "Defender") return this.getDefenderModifier();
        if (role == "Murderer") return this.getMurderousModifier();
        return null;
    }

    num getAttackerModifier() {
        return this.class_name.getAttackerModifier();
    }

    num getDefenderModifier() {
        return this.class_name.getDefenderModifier();
    }

    num getMurderousModifier() {
        return this.class_name.getMurderousModifier();
    }

    String getDenizen() {
        return this.denizen.name; //<--convineint that it wasn't hard to upgrade.
    }

    bool didDenizenKillYou() {
        if (this.causeOfDeath.contains(this.denizen.name)) {
            return true; //also return true for minions. this is intentional.;
        }
        return false;
    }

    bool justDeath() {
        bool ret = false;

        //impossible to have a just death from a denizen or denizen minion. unless you are corrupt.
        if (this.didDenizenKillYou() && !(this.grimDark <= 2)) {
            return false;
        } else if (this.grimDark > 2) {
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!just death for a corrupt player from their denizen or denizen minion in session: ${this.session.session_id.toString()}");
            return true; //always just if the denizen puts down a corrupt player.
        }


        //if much less friends than enemies.
        if (this
            .getFriends()
            .length < this
            .getEnemies()
            .length) {
            if (this.session.rand.nextDouble() > .9) { //just deaths are rarer without things like triggers.
                ret = true;
            }
            //way more likely to be a just death if you're being an asshole.


            if ((this.murderMode || this.grimDark > 2)) {
                double r = rand.nextDouble();
                //print("rand is: " + rand);
                if (r > .2) {
                    //print(" just death for: " + this.title() + "rand is: " + rand)
                    ret = true;
                }
            }
        } else { //you are a good person. just corrupt.
            //way more likely to be a just death if you're being an asshole.
            if ((this.murderMode || this.grimDark > 2) && rand.nextDouble() > .5) {
                ret = true;
            }
        }
        //print(ret);
        //return true; //for testing
        return ret;
    }

    bool heroicDeath() {
        bool ret = false;

        //it's not heroic derping to death against a minion or whatever, or in a solo fight.
        if (this.didDenizenKillYou() || this.causeOfDeath == "from a Bad Break.") {
            return false;
        }

        //if far more enemies than friends.
        if (this
            .getFriends()
            .length > this
            .getEnemies()
            .length) {
            if (this.session.rand.nextDouble() > .6) {
                ret = true;
            }
            //extra likely if you just killed the king/queen, you hero you.
            if ((this.session.king.getStat("currentHP") <= 0 || this.session.king.dead == true) && this.session.rand.nextDouble() > .2) {
                ret = true;
            }
        } else { //unlikely hero
            if (this.session.rand.nextDouble() > .8) {
                ret = true;
            }
            //extra likely if you just killed the king/queen, you hero you.
            if (this.session.king.getStat("currentHP") <= 0 || this.session.king.dead == true && rand.nextDouble() > .4) {
                ret = true;
            }
        }

        if (ret) {
            //print("heroic death");
        }
        return ret;
    }

    bool hasInteractionEffect() {
        return this.class_name.hasInteractionEffect();
    }

    //IMPORTANT, THE WHOLE POINT OF INTERACTION IS YOU CAN STEAL FROM ENEMIES *OR* ALLIES
    //SO TAKE IN A GAMEENTITY HERE.
    void associatedStatsInteractionEffect(GameEntity target) {
        if (this.hasInteractionEffect()) { //don't even bother if you don't have an interaction effect.
            for (num i = 0; i < this.associatedStats.length; i++) {
                this.processStatInteractionEffect(target, this.associatedStats[i]);
            }
        }
    }

    void processStatInteractionEffect(GameEntity target, AssociatedStat stat) {
        class_name.processStatInteractionEffect(this, target, stat);
    }

    @override
    void interactionEffect(GameEntity target) {
        this.associatedStatsInteractionEffect(target);

        //no longer do this seperate. if close enough to modify with powers, close enough to be...closer.
        Relationship r1 = this.getRelationshipWith(target);
        if (r1 != null) {
            r1.moreOfSame();
        }
    }


    List<Player> performEctobiology(Session session) {
        session.ectoBiologyStarted = true;
        List<Player> playersMade = findPlayersWithoutEctobiologicalSource(session.players);
        setEctobiologicalSource(playersMade, session.session_id);
        return playersMade;
    }

    bool isActive() {
        return class_name.isActive();
    }


    @override
    Player clone() {
        Player clone = new Player();
        super.copyStatsTo(clone);
        //clone stats.
        clone.baby = baby;
        clone.pvpKillCount = pvpKillCount; //for stats.
        clone.timesDied = timesDied;
        if (denizen != null) clone.denizen = denizen.clone();
        if (denizen != null) clone.denizenMinion = denizenMinion.clone();
        clone.sprite = sprite.clone(); //gets set to a blank sprite when character is created.
        clone.deriveChatHandle = deriveChatHandle;
        clone.flipOutReason = flipOutReason; //if it's null, i'm not flipping my shit.
        clone.flippingOutOverDeadPlayer = flippingOutOverDeadPlayer; //don't let this go into url. but, don't flip out if the friend is currently alive, you goof.
        clone.denizen_index = denizen_index; //denizen quests are in order.
        clone.causeOfDrain = causeOfDrain; //just ghost things
        clone.ghostWisdom = ghostWisdom; //keeps you from spamming the same ghost over and over for wisdom.
        clone.land1 = land1;
        clone.land2 = land2;
        clone.trickster = trickster;
        clone.sbahj = sbahj;
        clone.sickRhymes = sickRhymes; //oh hell yes. Hell. FUCKING. Yes!
        clone.robot = robot;
        clone.ectoBiologicalSource = ectoBiologicalSource; //might not be created in their own session now.
        clone.class_name = class_name;
        clone.number_confessions = number_confessions;
        clone.number_times_confessed_to = number_times_confessed_to;
        clone.baby_stuck = baby_stuck;
        clone.influenceSymbol = influenceSymbol; //multiple aspects can influence/mind control.
        clone.influencePlayer = influencePlayer; //TODO  probably don't have to clone this. who is controlling me? (so i can break free if i have more free will or they die)
        clone.stateBackup = stateBackup; //if you get influenced by something, here's where your true self is stored until you break free.
        clone.aspect = aspect;
        clone.land = land;
        clone.interest1 = interest1;
        clone.interest2 = interest2;
        clone.chatHandle = chatHandle;
        clone.object_to_prototype = object_to_prototype;
        clone.moon = moon;
        clone.leveledTheHellUp = leveledTheHellUp; //triggers level up scene.
        clone.mylevels = mylevels;
        clone.level_index = level_index; //will be ++ before i query
        clone.godTier = godTier;
        clone.victimBlood = victimBlood; //used for murdermode players.
        clone.hair = hair;
        clone.hairColor = hairColor;
        clone.dreamSelf = dreamSelf;
        clone.isTroll = isTroll; //later
        clone.bloodColor = bloodColor;
        clone.leftHorn = leftHorn;
        clone.rightHorn = rightHorn;
        clone.myLusus = myLusus;
        clone.quirk = quirk; //probably don't have to clone this???
        clone.godDestiny = godDestiny;
        clone.canGodTierRevive = canGodTierRevive; //even if a god tier perma dies, a life or time player or whatever can brings them back.
        clone.isDreamSelf = isDreamSelf; //players can be triggered for various things. higher their triggerLevle, greater chance of going murdermode or GrimDark.
        clone.murderMode = murderMode; //kill all players you don't like. odds of a just death skyrockets.
        clone.leftMurderMode = leftMurderMode; //have scars, unless left via death.
        clone.corruptionLevelOther = corruptionLevelOther; //every 100 points, sends you to next grimDarkLevel.
        clone.gnosis = gnosis;
        clone.grimDark = grimDark; //  0 = none, 1 = some, 2 = some more 3 = full grim dark with aura and font and everything.
        clone.leader = leader;
        clone.landLevel = landLevel; //at 10, you can challenge denizen.  only space player can go over 100 (breed better universe.)
        clone.denizenFaced = denizenFaced;
        clone.denizenDefeated = denizenDefeated;
        clone.denizenMinionDefeated = denizenMinionDefeated;
        //do not clone guardian, thing that calls you will do that
        return clone;
    }


    void makeGuardian() {
        //print("guardian for " + player.titleBasic());
        Player player = this;
        List<SBURBClass> possibilities = session.available_classes_guardians;
        if (possibilities.isEmpty) possibilities = new List<SBURBClass>.from(SBURBClassManager.canon);
        //print("class names available for guardians is: " + possibilities);
        Player guardian = randomPlayerWithClaspect(this.session, this.session.rand.pickFrom(possibilities), this.aspect);
        removeFromArray(guardian.class_name, session.available_classes_guardians);
        guardian.isTroll = player.isTroll;
        guardian.quirk.favoriteNumber = player.quirk.favoriteNumber;
        if (guardian.isTroll) {
            guardian.quirk = randomTrollSim(this.session.rand, guardian); //not same quirk as guardian;
        } else {
            guardian.quirk = randomHumanSim(this.session.rand, guardian);
        }

        guardian.bloodColor = player.bloodColor;
        guardian.myLusus = player.myLusus;
        if (guardian.isTroll == true) { //trolls always use lusus.
            guardian.object_to_prototype = player.object_to_prototype;
        }
        guardian.hairColor = player.hairColor;

        //print("Guardian className: " + guardian.class_name + " Player was: " + this.class_name);
        guardian.leftHorn = player.leftHorn;
        guardian.rightHorn = player.rightHorn;
        guardian.level_index = 5; //scratched kids start more leveled up
        guardian.setStat("power", 50);
        guardian.leader = player.leader;
        if (this.session.rand.nextDouble() > 0.5) { //have SOMETHING in common with your ectorelative.
            guardian.interest1 = player.interest1;
        } else {
            guardian.interest2 = player.interest2;
        }
        guardian.initializeDerivedStuff(); //redo levels and land based on real aspect
        //this.guardians.add(guardian); //sessions don't keep track of this anymore
        player.guardian = guardian;
        guardian.guardian = this; //goes both ways.
    }

    void associatedStatsIncreasePower(num powerBoost) {
        //modifyAssociatedStat
        for (num i = 0; i < this.associatedStats.length; i++) {
            this.processStatPowerIncrease(powerBoost, this.associatedStats[i]);
        }
    }

    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        return this.class_name.modPowerBoostByClass(powerBoost, stat);
    }

    void processStatPowerIncrease(num powerBoost, AssociatedStat stat) {
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if (this.isActive()) { //modify me
            this.modifyAssociatedStat(powerBoost, stat);
        } else { //modify others.
            powerBoost = 1 * powerBoost; //to make up for passives being too nerfed. 1 for you
            this.modifyAssociatedStat(powerBoost * 0.5, stat); //half for me
            for (num i = 0; i < this.session.players.length; i++) {
                this.session.players[i].modifyAssociatedStat(powerBoost / this.session.players.length, stat);
            }
        }
    }

    @override
    void increasePower([num magnitude = 1, num cap = 5.1]) {
        magnitude = Math.min(magnitude, cap); //unless otherwise specified, don't let thieves and rogues go TOO crazy.
        //print("$this incpower pre boost magnitude is $magnitude on a power of ${getStat('power')}");
        if (this.session.rand.nextDouble() > .9) {
            this.leveledTheHellUp = true; //that multiple of ten thing is bullshit.
        }
        num powerBoost = magnitude * this.class_name.powerBoostMultiplier * this.aspect.powerBoostMultiplier; // this applies the page 5x mult

        if (this.godTier) {
            powerBoost = powerBoost * 10; //god tiers are ridiculously strong.
        }

        if (this.denizenDefeated) {
            powerBoost = powerBoost * 2; //permanent doubling of stats forever.
        }

        this.addStat("power", Math.max(1, powerBoost)); //no negatives

        this.associatedStatsIncreasePower(powerBoost);
        //gain a bit of hp, otherwise denizen will never let players fight them if their hp isn't high enough.
        if (this.godTier || this.session.rand.nextDouble() > .85) {
            this.addStat("hp", 5);
            this.addStat("currentHP", 5);
        }
        //TODO figure out what the actual fuck this line was supposed to be doing. set power to ITSELF???
        //IT IS THE REASON WHY 40+5 = 65 and i do not even know why. stats are still too high though.
        // if (this.getStat("power") > 0) this.setStat("power", this.getStat("power").round());

        // print("$this incpower post boost magnitude is $powerBoost on a power of ${getStat('power')}");
    }

    String shortLand() {
        if (land == null) throw "Should Never Ask for the Abbreviation for a Null Land";
        RegExp exp = new RegExp(r"""\b(\w)""", multiLine: true);
        return joinMatches(exp.allMatches(land)).toUpperCase();
    }

    @override
    String htmlTitle() {
        return "${this.aspect.fontTag()}${this.title()}</font>";
    }

    @override
    String htmlTitleHP() {
        return "${this.aspect.fontTag()}${this.title()} (${(this.getStat("currentHP")).round()}hp, ${(this.getStat("power")).round()} power)</font>";
    }

    void generateBlandRelationships(List<Player> friends) {
        for (num i = 0; i < friends.length; i++) {
            if (friends[i] != this) { //No, Karkat, you can't be your own Kismesis.
                //one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
                //that it needs to be a thing.
                Relationship r = Relationship.randomBlandRelationship(this, friends[i]);
                if (this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d") {
                    r.value = -20; //biological imperitive to fight for throne.
                    this.addStat("sanity", -100);
                    friends[i].addStat("sanity", -100);
                }
                this.relationships.add(r);
            }
        }
    }

    void generateRelationships(List<Player> friends) {
        //	print(this.title() + " generating a relationship with: " + friends.length);
        for (num i = 0; i < friends.length; i++) {
            if (friends[i] != this) { //No, Karkat, you can't be your own Kismesis.
                //one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
                //that it needs to be a thing.
                Relationship r = Relationship.randomRelationship(this, friends[i]);
                if (this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d") {
                    r.value = -20; //biological imperitive to fight for throne.
                    this.addStat("sanity", -10);
                    friends[i].addStat("sanity", -10);
                }
                this.relationships.add(r);
            } else {
                //print(this.title() + "Not generating a relationship with: " + friends[i].title());
            }
        }
    }

    void checkBloodBoost(List<Player> players) {
        if (this.aspect == Aspects.BLOOD) { // TODO: ASPECTS - migrate to per-aspect boost?
            for (num i = 0; i < players.length; i++) {
                players[i].boostAllRelationships();
            }
        }
    }

    void nullAllRelationships() {
        for (num i = 0; i < this.relationships.length; i++) {
            this.relationships[i].value = 0;
            this.relationships[i].saved_type = this.relationships[i].neutral;
        }
    }

    void boostAllRelationships() {
        for (num i = 0; i < this.relationships.length; i++) {
            this.relationships[i].increase();
        }
    }

    @override
    void boostAllRelationshipsBy(num boost) {
        for (num i = 0; i < this.relationships.length; i++) {
            this.relationships[i].value += boost;
        }
    }

    void damageAllRelationships() {
        for (num i = 0; i < this.relationships.length; i++) {
            this.relationships[i].decrease();
        }
    }

    @override
    void boostAllRelationshipsWithMeBy(num boost) {
        for (num i = 0; i < this.relationships.length; i++) {
            Player player = this.relationships[i].target;
            Relationship r = this.getRelationshipWith(player);
            if (r != null) {
                r.value += boost;
            }
        }
    }

    void boostAllRelationshipsWithMe() {
        for (num i = 0; i < this.relationships.length; i++) {
            Player player = this.relationships[i].target;
            Relationship r = this.getRelationshipWith(player);
            if (r != null) {
                r.increase();
            }
        }
    }

    @override
    num rollForLuck([String stat]) {
        if (stat == null || stat == "") {
            return this.session.rand.nextIntRange(this.getStat("minLuck"), this.getStat("maxLuck"));
        } else {
            //don't care if it's min or max, just compare it to zero.
            return this.session.rand.nextIntRange(0, this.getStat(stat));
        }
    }

    void damageAllRelationshipsWithMe() {
        for (num i = 0; i < curSessionGlobalVar.players.length; i++) {
            Relationship r = this.getRelationshipWith(curSessionGlobalVar.players[i]);
            if (r != null) {
                r.decrease();
            }
        }
    }

    num getAverageRelationshipValue() {
        if (this.relationships.isEmpty) return 0;
        num ret = 0;
        for (num i = 0; i < this.relationships.length; i++) {
            ret += this.relationships[i].value;
        }
        return ret / this.relationships.length;
    }

    Player hasDiamond() {
        for (num i = 0; i < this.relationships.length; i++) {
            if (this.relationships[i].saved_type == this.relationships[i].diamond && !this.relationships[i].target.dead) {
                return this.relationships[i].target;
            }
        }
        return null;
    }

    Player hasDeadDiamond() {
        for (num i = 0; i < this.relationships.length; i++) {
            if (this.relationships[i].saved_type == this.relationships[i].diamond && this.relationships[i].target.dead) {
                return this.relationships[i].target;
            }
        }
        return null;
    }

    Player hasDeadHeart() {
        for (num i = 0; i < this.relationships.length; i++) {
            if (this.relationships[i].saved_type == this.relationships[i].heart && this.relationships[i].target.dead) {
                return this.relationships[i].target;
            }
        }
        return null;
    }

    @override
    Relationship getRelationshipWith(GameEntity player) {
        for (num i = 0; i < this.relationships.length; i++) {
            if (this.relationships[i].target == player) {
                return this.relationships[i];
            }
        }
        return null;
    }

    Player getWhoLikesMeBestFromList(List<Player> potentialFriends) {
        Relationship bestRelationshipSoFar = this.relationships[0];
        Player friend = bestRelationshipSoFar.target;
        for (num i = 0; i < potentialFriends.length; i++) {
            Player p = potentialFriends[i];
            if (p != this) {
                Relationship r = p.getRelationshipWith(this);
                if (r != null && r.value > bestRelationshipSoFar.value) {
                    bestRelationshipSoFar = r;
                    friend = p;
                }
            }
        }
        //can't be my best friend if they're an enemy
        if (bestRelationshipSoFar.value > 0 && potentialFriends.contains(friend)) {
            return friend;
        }
        return null;
    }

    Player getWhoLikesMeLeastFromList(List<Player>potentialFriends) {
        Relationship worstRelationshipSoFar = this.relationships[0];
        Player enemy = worstRelationshipSoFar.target;
        for (num i = 0; i < potentialFriends.length; i++) {
            Player p = potentialFriends[i];
            if (p != this) {
                Relationship r = p.getRelationshipWith(this);
                if (r != null && r.value < worstRelationshipSoFar.value) {
                    worstRelationshipSoFar = r;
                    enemy = p;
                }
            }
        }
        //can't be my worst enemy if they're a friend.
        if (worstRelationshipSoFar.value < 0 && potentialFriends.contains(enemy)) {
            return enemy;
        }
        return null;
    }

    bool hasRelationshipDrama() {
        for (num i = 0; i < this.relationships.length; i++) {
            this.relationships[i].type(); //check to see if there is a relationship change.
            if (this.relationships[i].drama) {
                return true;
            }
        }
        return false;
    }

    List<Relationship> getRelationshipDrama() {
        List<Relationship> ret = <Relationship>[];
        for (num i = 0; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];
            if (r.drama) {
                ret.add(r);
            }
        }
        return ret;
    }

    String getChatFontColor() {
        if (this.isTroll) {
            return this.bloodColor;
        } else {
            return this.aspect.palette.text.toStyleString();
        }
    }

    @override
    List<Player> getFriendsFromList(List<GameEntity> potentialFriends) {
        List<Player> ret = <Player>[];
        for (num i = 0; i < potentialFriends.length; i++) {
            GameEntity p = potentialFriends[i];
            if (p != this && p is Player) { //TODO sorry bro, npcs will be allies or some shit
                Relationship r = this.getRelationshipWith(potentialFriends[i]);
                if (r != null && r.value > 0) {
                    ret.add(p);
                }
            }
        }
        return ret;
    }

    List<Player> getEnemiesFromList(List<GameEntity> potentialEnemies) {
        List<Player> ret = <Player>[];
        for (num i = 0; i < potentialEnemies.length; i++) {
            GameEntity p = potentialEnemies[i];
            if (p != this && p is Player) { //sorry bro, GameEntities will be "bad guys" or some shit
                Relationship r = this.getRelationshipWith(potentialEnemies[i]);
                if (r.value < 0) {
                    ret.add(p);
                }
            }
        }
        return ret;
    }

    num getLowestRelationshipValue() {
        Relationship worstRelationshipSoFar = this.relationships[0];
        for (num i = 1; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];
            if (r.value < worstRelationshipSoFar.value) {
                worstRelationshipSoFar = r;
            }
        }
        return worstRelationshipSoFar.value;
    }

    // both identical to GameEntity -PL
    /*@override
	double getTotalBuffForStat(String statName){
	    double ret = 0.0;
	    for(num i = 0; i<this.buffs.length; i++){
	        Buff b = this.buffs[i];
	        if(b.name == statName) ret += b.value;
	    }
	    return ret;
	}
	String humanWordForBuffNamed(statName){
        if(statName == "MANGRIT") return "powerful";
        if(statName == "hp") return "sturdy";
        if(statName == "RELATIONSHIPS") return "friendly";
        if(statName == "mobility") return "fast";
        if(statName == "sanity") return "calm";
        if(statName == "freeWill") return "willful";
        if(statName == "maxLuck") return "lucky";
        if(statName == "minLuck") return "lucky";
        if(statName == "alchemy") return "creative";
        return "???";
	}*/
    @override
    String describeBuffs() {
        List<String> ret = <String>[];
        Iterable<String> allStats = this.allStats();
        for (String stat in allStats) {
            double b = this.getTotalBuffForStat(stat);
            //only say nothing if equal to zero
            if (b > 0) ret.add("more ${this.humanWordForBuffNamed(stat)}");
            if (b < 0) ret.add("less ${this.humanWordForBuffNamed(stat)}");
        }
        if (ret.isEmpty) return "";
        return "<br/><br/>${this.htmlTitleHP()} is feeling ${turnArrayIntoHumanSentence(ret)} than normal. ";
    }


    @override //players have ACTUAL relationships, not a placeholder stat, so do different shit
    num getStat(String statName) {
        num ret = 0;
        if (statName == "RELATIONSHIPS") { //relationships, why you so cray cray???
            for (num i = 0; i < this.relationships.length; i++) {
                ret += this.relationships[i].value;
            }
            return ret.round();
        } else {
            return super.getStat(statName);
        }
    }


    num getHighestRelationshipValue() {
        Relationship bestRelationshipSoFar = this.relationships[0];
        for (num i = 1; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];
            if (r.value > bestRelationshipSoFar.value) {
                bestRelationshipSoFar = r;
            }
        }
        return bestRelationshipSoFar.value;
    }

    GameEntity getBestFriend() {
        Relationship bestRelationshipSoFar = this.relationships[0];
        for (num i = 1; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];
            if (r.value > bestRelationshipSoFar.value) {
                bestRelationshipSoFar = r;
            }
        }
        return bestRelationshipSoFar.target;
    }

    GameEntity getBestFriendFromList(List<GameEntity>potentialFriends, [String debugMessage = null]) {
        Relationship bestRelationshipSoFar = this.relationships[0];
        for (num i = 0; i < potentialFriends.length; i++) {
            GameEntity p = potentialFriends[i];
            if (p != this) {
                Relationship r = this.getRelationshipWith(p);
                if (r == null) {
                    //print("Couldn't find relationships between " + this.chatHandle + " and " + p.chatHandle);
                    //print(debugMessage);
                    //print(potentialFriends);
                    //print(this);
                }
                if (r.value > bestRelationshipSoFar.value) {
                    bestRelationshipSoFar = r;
                }
            }
        }
        //can't be my best friend if they're an enemy
        //I SHOULD NOT HAVE A RELATIONSHIP WITH MYSELF. but if i do, don't return it.;
        if (bestRelationshipSoFar.value > 0 && bestRelationshipSoFar.target != this) {
            return bestRelationshipSoFar.target;
        }
        return null;
    }

    GameEntity getWorstEnemyFromList(List<GameEntity> potentialFriends) {
        Relationship worstRelationshipSoFar = this.relationships[0];
        for (num i = 0; i < potentialFriends.length; i++) {
            GameEntity p = potentialFriends[i];
            if (p != this) {
                Relationship r = this.getRelationshipWith(potentialFriends[i]);
                if (r.value < worstRelationshipSoFar.value) {
                    worstRelationshipSoFar = r;
                }
            }
        }
        //can't be my worst enemy if they're a friend.
        //I SHOULD NOT HAVE A RELATIONSHIP WITH MYSELF. but if i do, don't return it.;
        if (worstRelationshipSoFar.value < 0 && worstRelationshipSoFar.target != this) {
            return worstRelationshipSoFar.target;
        }
        return null;
    }

    void decideTroll() {
        if (this.session.getSessionType() == "Human") {
            this.hairColor = session.rand.pickFrom(human_hair_colors);
            return;
        }

        if (this.session.getSessionType() == "Troll" || (this.session.getSessionType() == "Mixed" && rand.nextDouble() > 0.5)) {
            this.isTroll = true;
            this.hairColor = "#000000";
            this.decideHemoCaste();
            this.decideLusus();
            this.object_to_prototype = this.myLusus;
        } else {
            this.hairColor = session.rand.pickFrom(human_hair_colors);
        }
    }

    void decideHemoCaste() {
        if (this.aspect != Aspects.BLOOD) { //sorry karkat
            this.bloodColor = session.rand.pickFrom(bloodColors);
        }
        this.applyPossiblePsionics();
    }

    void decideLusus() {
        if (this.bloodColor == "#610061" || this.bloodColor == "#99004d" || this.bloodColor == "#631db4") {
            this.myLusus = session.rand.pickFrom(sea_lusus_objects);
        } else {
            this.myLusus = session.rand.pickFrom(lusus_objects);
        }
    }

    List<GameEntity> getFriends() {
        List<GameEntity> ret = <GameEntity>[];
        for (num i = 0; i < this.relationships.length; i++) {
            if (this.relationships[i].value > 0) {
                ret.add(this.relationships[i].target);
            }
        }
        return ret;
    }

    List<GameEntity> getEnemies() {
        List<GameEntity> ret = <GameEntity>[];
        for (num i = 0; i < this.relationships.length; i++) {
            if (this.relationships[i].value < 0) {
                ret.add(this.relationships[i].target);
            }
        }
        return ret;
    }

    bool highInit() {
        return this.class_name.highHinit();
    }

    void initializeLuck() {
        this.setStat("minLuck", this.session.rand.nextIntRange(-10, 0)); //middle of the road.
        this.setStat("maxLuck", this.session.rand.nextIntRange(1, 10)); //max needs to be more than min.
        if (this.trickster && !this.aspect.ultimateDeadpan) {
            this.setStat("minLuck", 11111111111);
            this.setStat("maxLuck", 11111111111);
        }
    }


    void initializeFreeWill() {
        this.setStat("freeWill", this.session.rand.nextIntRange(-10, 10));
        if (this.trickster && !this.aspect.ultimateDeadpan) {
            this.setStat("freeWill", 11111111111);
        }
    }

    void initializeHP() {
        this.setStat("hp", this.session.rand.nextIntRange(40, 60));
        this.setStat("currentHP", this.getStat("hp"));
        if (this.trickster && !this.aspect.ultimateDeadpan) {
            this.setStat("currentHP", 11111111111);
            this.setStat("hp", 11111111111);
        }

        if (this.isTroll && this.bloodColor != "#ff0000") {
            this.addStat("currentHP", bloodColorToBoost(this.bloodColor));
            this.addStat("hp", bloodColorToBoost(this.bloodColor));
        }
    }

    void initSpriteCanvas() {
        //print("Initializing derived stuff.");
        this.spriteCanvasID = "spriteCanvas${this.id}";
        String canvasHTML = "<br/><canvas style='display:none' id='${this.spriteCanvasID}' width='400' height='300'></canvas>";
        appendHtml(querySelector("#playerSprites"), canvasHTML);
        //print("append? -> $canvasHTML");
    }

    void renderSelf() {
        if (this.spriteCanvasID == null) this.initSpriteCanvas();
        CanvasElement canvasDiv = querySelector("#${this.spriteCanvasID}");

        //var ctx = canvasDiv.context2D;
        this.clearSelf();
        //var pSpriteBuffer = this.session.sceneRenderingEngine.getBufferCanvas(querySelector("#sprite_template"));
        CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawSpriteFromScratch(pSpriteBuffer, this);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer, 0, 0);
        //this.session.sceneRenderingEngine.drawSpriteFromScratch(pSpriteBuffer, this);
        //this.session.sceneRenderingEngine.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,0,0);
    }

    void clearSelf() {
        CanvasElement canvasDiv = querySelector("#${this.spriteCanvasID}");
        CanvasRenderingContext2D ctx = canvasDiv.context2D;
        ctx.clearRect(0, 0, canvasDiv.width, canvasDiv.height);
    }

    void initializeMobility() {
        this.setStat("mobility", this.session.rand.nextIntRange(-10, 10));
        if (this.trickster && !this.aspect.ultimateDeadpan) {
            this.setStat("mobility", 11111111111);
        }
    }

    void initializeSanity() {
        this.setStat("sanity", this.session.rand.nextIntRange(-10, 10));
    }

    void initializeRelationships() {
        if (this.trickster && !this.aspect.deadpan) {
            for (num k = 0; k < this.relationships.length; k++) {
                Relationship r = this.relationships[k];
                r.value = 11111111111; //EVERYTHIGN IS BETTER!!!!!!!!!!!
                r.saved_type = r.goodBig;
            }
        }

        if (this.isTroll && this.bloodColor == "#99004d") {
            for (num i = 0; i < this.relationships.length; i++) {
                //needs to be part of this in ADDITION to initialization because what about custom players now.
                Relationship r = this.relationships[i];
                if (this.isTroll && this.bloodColor == "#99004d" && r.target.isTroll && r.target.bloodColor == "#99004d") {
                    r.value = -20; //biological imperitive to fight for throne.
                    this.addStat("sanity", -10);
                    r.target.addStat("sanity", -10);
                }
            }
        }
        if (this.robot || this.grimDark > 1) { //you can technically start grimDark
            for (num k = 0; k < this.relationships.length; k++) {
                Relationship r = this.relationships[k];
                r.value = 0; //robots are tin cans with no feelings
                r.saved_type = r.neutral;
                r.old_type = r.neutral;
            }
        }
    }

    Fraymotif getNewFraymotif(GameEntity helper) {
        Fraymotif f;
        if (this.godTier) {
            f = this.session.fraymotifCreator.makeFraymotifForPlayerWithFriends(this, helper, 3);
        } else if (this.denizenDefeated) {
            f = this.session.fraymotifCreator.makeFraymotifForPlayerWithFriends(this, helper, 2);
        } else {
            f = this.session.fraymotifCreator.makeFraymotifForPlayerWithFriends(this, helper, 1);
        }
        this.fraymotifs.add(f);
        return f;
    }

    void initializePower() {
        this.setStat("power", 0);
        if (this.trickster && !this.aspect.ultimateDeadpan) {
            this.setStat("power", 11111111111);
        }

        if (this.robot) {
            this.addStat("power", 100); //robots are superior
        }

        if (this.isTroll && this.bloodColor != "#ff0000") {
            this.addStat("power", bloodColorToBoost(this.bloodColor));
        }
    }

    String toDataStrings(bool includeChatHandle) {
        String ch = "";
        if (includeChatHandle) ch = sanitizeString(this.chatHandle);
        String cod = this.causeOfDrain;
        if (cod == null) cod = "";
        String ret = "${sanitizeString(cod)},${sanitizeString(this.causeOfDeath)},${sanitizeString(this.interest1.name)},${sanitizeString(this.interest2.name)},${sanitizeString(ch)}";
        return ret;
    }

    String toOCDataString() {
        //for now, only extentsion sequence is for classpect. so....
        String tmpx = this.toDataBytesX(new ByteBuilder());
        if (tmpx == null) tmpx = ""; //DART is putting null here instead of a blank string, like an asshole.
        String x = "&x=$tmpx"; //ALWAYS have it. worst case scenario is 1 bit.

        return "b=${this.toDataBytes()}&s=${this.toDataStrings(true)}$x";
    }

    //take in a builder so when you do a group of players then can use same builder and no padding.
    String toDataBytesX(ByteBuilder builder) {
        Map<String, dynamic> j = this.toJSON();
        if (j["class_name"] <= 15 && j["aspect"] <= 15) { //if NEITHER have need of extension, just return size zero;
            builder.appendExpGolomb(0); //for length
            return BASE64URL.encode(builder.toBuffer().asUint8List());
        }
        builder.appendExpGolomb(2); //for length
        builder.appendByte(j["class_name"]);
        builder.appendByte(j["aspect"]);
        //String data = UTF8.decode(builder.toBuffer().asUint8List());
        return BASE64URL.encode(builder.toBuffer().asUint8List());
        //return Uri.encodeComponent(data).replaceAll(new RegExp(r"""#""", multiLine:true), '%23').replaceAll(new RegExp(r"""&""", multiLine:true), '%26');
    }

    void readInExtensionsString(ByteReader reader) {
        print("reading in extension string");
        //just inverse of encoding process.
        int numFeatures = reader.readExpGolomb(); //assume features are in set order. and that if a given feature is variable it is ALWAYS variable.
        print("num features is: $numFeatures");
        if (numFeatures > 0) {
            int cid = reader.readByte();
            print("Class Name ID : $cid");
            this.class_name = intToClassName(cid);
        }
        if (numFeatures > 1) this.aspect = Aspects.get(reader.readByte());
        //as i add more things, add more lines. ALWAYS in same order, but not all features all the time.
    }

    String toDataBytes() {
        Map<String, dynamic> json = this.toJSON(); //<-- gets me data in pre-compressed format.
        //var buffer = new ByteBuffer(11);
        StringBuffer ret = new StringBuffer(); //gonna return as a string of chars.;
        Uint8List uint8View = new Uint8List(11);
        uint8View[0] = json["hairColor"] >> 16; //hair color is 12 bits. chop off 4 on right side, they will be in buffer[1];
        uint8View[1] = json["hairColor"] >> 8;
        uint8View[2] = json["hairColor"] >> 0;
        uint8View[3] = (json["class_name"] << 4) + json["aspect"]; //when I do fanon classes + aspect, use this same scheme, but have binary for "is fanon", so I know 1 isn't page, but waste (or whatever);
        uint8View[4] = (json["victimBlood"] << 4) + json["bloodColor"];
        uint8View[5] = (json["interest1Category"] << 4) + json["interest2Category"];
        uint8View[6] = (json["grimDark"] << 5) + (json["isTroll"] << 4) + (json["isDreamSelf"] << 3) + (json["godTier"] << 2) + (json["murderMode"] << 1) + (json["leftMurderMode"]); //shit load of single bit variables.;
        uint8View[7] = (json["robot"] << 7) + (json["moon"] << 6) + (json["dead"] << 5) + (json["godDestiny"] << 4) + (json["favoriteNumber"]);
        uint8View[8] = json["leftHorn"];
        uint8View[9] = json["rightHorn"];
        uint8View[10] = json["hair"];
        //print(uint8View);
        for (num i = 0; i < uint8View.length; i++) {
            ret.writeCharCode(uint8View[i]); // += String.fromCharCode(uint8View[i]);
        }
        return Uri.encodeComponent(ret.toString()).replaceAll("#", '%23').replaceAll("&", '%26');
    }

    Map<String, dynamic> toJSON() {
        num moon = 0;
        String cod = this.causeOfDrain;
        if (cod == null) cod = "";
        if (this.moon == "Prospit") moon = 1;
        Map<String, dynamic> json = <String, dynamic>{"aspect": this.aspect.id, "class_name": classNameToInt(this.class_name), "favoriteNumber": this.quirk.favoriteNumber, "hair": this.hair, "hairColor": hexColorToInt(this.hairColor), "isTroll": this.isTroll ? 1 : 0, "bloodColor": bloodColorToInt(this.bloodColor), "leftHorn": this.leftHorn, "rightHorn": this.rightHorn, "interest1Category": this.interest1.category.id, "interest2Category": this.interest2.category.id, "interest1": this.interest1.name, "interest2": this.interest2.name, "robot": this.robot ? 1 : 0, "moon": moon, "causeOfDrain": cod, "victimBlood": bloodColorToInt(this.victimBlood), "godTier": this.godTier ? 1 : 0, "isDreamSelf": this.isDreamSelf ? 1 : 0, "murderMode": this.murderMode ? 1 : 0, "leftMurderMode": this.leftMurderMode ? 1 : 0, "grimDark": this.grimDark, "causeOfDeath": this.causeOfDeath, "dead": this.dead ? 1 : 0, "godDestiny": this.godDestiny ? 1 : 0};
        return json;
    }

    @override
    String toString() {
        return ("${this.class_name}${this.aspect}").replaceAll(new RegExp(r"'", multiLine: true), ''); //no spaces.
    }

    void copyFromPlayer(Player replayPlayer) {
        //print("copying from player who has a favorite number of: " + replayPlayer.quirk.favoriteNumber);
        //print("Overriding player from a replay Player. ");
        //print(replayPlayer);
        this.aspect = replayPlayer.aspect;
        this.class_name = replayPlayer.class_name;
        this.hair = replayPlayer.hair;
        this.hairColor = replayPlayer.hairColor;
        this.isTroll = replayPlayer.isTroll;
        this.bloodColor = replayPlayer.bloodColor;
        this.leftHorn = replayPlayer.leftHorn;
        this.rightHorn = replayPlayer.rightHorn;
        this.interest1 = replayPlayer.interest1;
        this.interest2 = replayPlayer.interest2;

        this.causeOfDrain = replayPlayer.causeOfDrain;
        this.causeOfDeath = replayPlayer.causeOfDeath;
        if (replayPlayer.chatHandle != "") {
            this.chatHandle = replayPlayer.chatHandle;
            this.deriveChatHandle = false;
        }
        this.isDreamSelf = replayPlayer.isDreamSelf;
        this.godTier = replayPlayer.godTier;
        this.godDestiny = replayPlayer.godDestiny;
        this.murderMode = replayPlayer.murderMode;
        this.leftMurderMode = replayPlayer.leftMurderMode;
        this.grimDark = replayPlayer.grimDark;
        this.moon = replayPlayer.moon;
        this.dead = replayPlayer.dead;
        this.victimBlood = replayPlayer.victimBlood;
        this.robot = replayPlayer.robot;
        this.fraymotifs.clear(); //whoever you were before, you don't have those psionics anymore
        this.applyPossiblePsionics(); //now you have new psionics
        //print("after applying psionics I have this many fraymotifs: " + this.fraymotifs.length);
        this.quirk.favoriteNumber = replayPlayer.quirk.favoriteNumber; //will get overridden, has to be after initialization, too, but if i don't do it here, char creartor will look wrong.
        this.makeGuardian();
        this.guardian.applyPossiblePsionics(); //now you have new psionics
    }

    void initialize() {
        this.initializeStats();
        this.initializeSprite();
        this.initializeDerivedStuff(); //TODO handle troll derived stuff. like quirk.
    }

    void initializeDerivedStuff() {
        List<String> tmp = getRandomLandFromPlayer(this);
        this.land1 = tmp[0];
        this.land2 = tmp[1];
        this.land = "Land of ${tmp[0]} and ${tmp[1]}";
        if (this.deriveChatHandle) this.chatHandle = getRandomChatHandle(this.session.rand, this.class_name, this.aspect, this.interest1, this.interest2);
        this.mylevels = getLevelArray(this); //make them ahead of time for echeladder graphic

        if (this.isTroll) {
            if (this.quirk == null) this.quirk = randomTrollSim(this.session.rand, this); //if i already have a quirk it was defined already. don't override it.;
            this.addStat("sanity", -10); //trolls are slightly less stable

        } else {
            if (this.quirk == null) this.quirk = randomHumanSim(this.session.rand, this);
        }
    }

    void initializeSprite() {
        this.sprite = new Sprite("sprite", session); //unprototyped.
        //minLuck, maxLuck, hp, mobility, triggerLevel, freeWill, power, abscondable, canAbscond, framotifs, grist
        this.sprite.setStatsHash(<String, num>{"hp": 10, "currentHP": 10}); //same as denizen minion, but empty power
        this.sprite.doomed = true;
    }

    static List<String> playerStats = <String>["power", "hp", "RELATIONSHIPS", "mobility", "sanity", "freeWill", "maxLuck", "minLuck", "alchemy"];
    @override
    Iterable<String> allStats() {
        return playerStats;
    }

    List<AssociatedStat> getOnlyAspectAssociatedStats() {
        List<AssociatedStat> ret = <AssociatedStat>[];
        for (num i = 0; i < this.associatedStats.length; i++) {
            if (this.associatedStats[i].isFromAspect) ret.add(this.associatedStats[i]);
        }
        return ret;
    }

    List<AssociatedStat> getOnlyPositiveAspectAssociatedStats() {
        List<AssociatedStat> ret = <AssociatedStat>[];
        for (num i = 0; i < this.associatedStats.length; i++) {
            if (this.associatedStats[i].isFromAspect && this.associatedStats[i].multiplier > 0) ret.add(this.associatedStats[i]);
        }
        return ret;
    }

    List<AssociatedStat> getOnlyNegativeAspectAssociatedStats() {
        List<AssociatedStat> ret = <AssociatedStat>[];
        for (num i = 0; i < this.associatedStats.length; i++) {
            if (this.associatedStats[i].isFromAspect && this.associatedStats[i].multiplier < 0) ret.add(this.associatedStats[i]);
        }
        return ret;
    }

    String voidDescription() {
        for (num i = 0; i < this.associatedStats.length; i++) {
            AssociatedStat stat = this.associatedStats[i];
            if (stat.multiplier >= 3) return "SO ${this.getEmphaticDescriptionForStatNamed(stat.name)}";
        }
        return "SO BLAND";
    }

    String getEmphaticDescriptionForStatNamed(String statName) {
        if (this.highInit()) {
            if (statName == "MANGRIT") return "STRONG";
            if (statName == "hp") return "STURDY";
            if (statName == "RELATIONSHIPS") return "FRIENDLY";
            if (statName == "mobility") return "FAST";
            if (statName == "sanity") return "CALM";
            if (statName == "freeWill") return "WILLFUL";
            if (statName == "maxLuck") return "LUCKY";
            if (statName == "minLuck") return "LUCKY";
            if (statName == "alchemy") return "CREATIVE";
        } else {
            if (statName == "MANGRIT") return "WEAK";
            if (statName == "hp") return "FRAGILE";
            if (statName == "RELATIONSHIPS") return "AGGRESSIVE";
            if (statName == "mobility") return "SLOW";
            if (statName == "sanity") return "CRAZY";
            if (statName == "freeWill") return "GULLIBLE";
            if (statName == "maxLuck") return "UNLUCKY";
            if (statName == "minLuck") return "UNLUCKY";
            if (statName == "alchemy") return "BORING";
        }
        return "CONFUSING";
    }


    void initializeAssociatedStats() {
        for (num i = 0; i < this.associatedStats.length; i++) {
            if (this.highInit()) {
                this.modifyAssociatedStat(10, this.associatedStats[i]);
            } else {
                this.modifyAssociatedStat(-10, this.associatedStats[i]);
            }
        }
    }

    @override
    void modifyAssociatedStat(num modValue, AssociatedStat stat) {
        if (stat == null) return;
        //modValue * stat.multiplier.
        if (stat.name == "RELATIONSHIPS") {
            for (num i = 0; i < this.relationships.length; i++) {
                this.relationships[i].value += (modValue / this.relationships.length) * stat.multiplier; //stop having relationship values on the scale of 100000
            }
        } else if (stat.name == "MANGRIT") {
            this.permaBuffs["MANGRIT"] += modValue * stat.multiplier;
        } else {
            this.stats[stat.name] += modValue * stat.multiplier;
        }
    }

    //oh my fuck, how was this ever allowed in javascript, it was trying to add stats to the LIST OF STATS.
    void initializeInterestStats() {
        //getInterestAssociatedStats
        List<AssociatedStat> interest1Stats = this.interest1.category.stats;
        List<AssociatedStat> interest2Stats = this.interest2.category.stats;
        for (AssociatedStat stat in interest1Stats) {
            this.modifyAssociatedStat(10, stat);
        }

        for (AssociatedStat stat in interest2Stats) {
            this.modifyAssociatedStat(10, stat);
        }
    }

    void initializeStats() {
        if (this.trickster && this.aspect.ultimateDeadpan) this.trickster == false; //doom players break rules
        this.associatedStats = <AssociatedStat>[]; //this might be called multiple times, wipe yourself out.
        this.aspect.initAssociatedStats(this);
        this.class_name.initAssociatedStats(this);
        this.setStat("sburbLore",0); //all start ignorant.
        this.initializeLuck();
        this.initializeFreeWill();
        this.initializeHP();
        this.initializeMobility();
        this.initializeRelationships();
        this.initializePower();
        this.initializeSanity();

        this.initializeAssociatedStats();
        this.initializeInterestStats(); //takes the place of old random intial stats.
        //reroll goddestiny and sprite as well. luck might have changed.
        num luck = this.rollForLuck();
        if (this.class_name == SBURBClassManager.WITCH || luck < -9) {
            this.object_to_prototype = this.session.rand.pickFrom(disastor_objects);
            //print("disastor");
        } else if (luck > 25) {
            this.object_to_prototype = this.session.rand.pickFrom(fortune_objects);
            //print("fortune");
        }
        if (luck > 5) {
            this.godDestiny = true;
        }
        this.setStat("currentHP", getStat("hp")); //could have been altered by associated stats

        if (this.class_name == SBURBClassManager.WASTE) {
            Fraymotif f = new Fraymotif("Rocks Fall, Everyone Dies", 1); //what better fraymotif for an Author to start with. Too bad it sucks.  If ONLY there were some way to hax0r SBURB???;
            f.effects.add(new FraymotifEffect("power", 3, true));
            f.desc = "Disappointingly sized meteors rain down from above.  Man, for such a cool name, this fraymotif kind of sucks. ";
            this.fraymotifs.add(f);
        } else if (this.class_name == SBURBClassManager.NULL) {
            {
                Fraymotif f = new Fraymotif("What class???", 1);
                f.effects.add(new FraymotifEffect("power", 1, true));
                f.desc = " I am certain there is not a class here and it is laughable to imply otherwise. ";
                this.fraymotifs.add(f);
            }

            {
                Fraymotif f = new Fraymotif("Nulzilla", 2);
                f.effects.add(new FraymotifEffect("power", 1, true));
                f.desc = " If you get this reference, you may reward yourself 15 Good Taste In Media Points (tm).  ";
                this.fraymotifs.add(f);
            }
        }
    }

    //TODO make all this shit down here static or put in other places.


    /******************************************************************
     *
     * No Premature Optimization. V1 will have a rendering
     * Snapshot just be a deep copy of the player.
     *
     * If testing shows that having it be this big heavy class is a problem
     * I can make a tiny version with only what I need.
     *
     * DO NOT FALL INTO THE TRAP OF USING THIS NEW TINY ONE FOR DOOMED TIME PLAYERS.
     *
     * THEY NEED MORE METHODS THAN YOU THINK THEY DO.
     *
     * Find out how you are SUPPOSED to make deep copies of objects in
     * langugages where objects aren't just shitty hashes.
     *
     *****************************************************************/

    //TODO how do you NORMALLY make deep copies of things when all objects aren't secretly hashes?
    //get rid of thigns doomed time players were using. they are just players. just like this is just a player
    //until ll8r when i bother to make it a mini class of just stats.
    static Player makeRenderingSnapshot(Player player) {
        Player ret = new Player();
        ret.robot = player.robot;
        ret.godDestiny = player.godDestiny;
        ret.spriteCanvasID = player.spriteCanvasID;
        ret.doomed = player.doomed;
        ret.ghost = player.ghost;
        ret.causeOfDrain = player.causeOfDrain;
        ret.session = player.session;
        ret.id = player.id;
        ret.trickster = player.trickster;
        ret.baby_stuck = player.baby_stuck;
        ret.sbahj = player.sbahj;
        ret.influenceSymbol = player.influenceSymbol;
        ret.grimDark = player.grimDark;
        ret.victimBlood = player.victimBlood;
        ret.murderMode = player.murderMode;
        ret.leftMurderMode = player.leftMurderMode; //scars
        ret.dead = player.dead;
        ret.isTroll = player.isTroll;
        ret.godTier = player.godTier;
        ret.class_name = player.class_name;
        ret.aspect = player.aspect;
        ret.isDreamSelf = player.isDreamSelf;
        ret.hair = player.hair;
        ret.bloodColor = player.bloodColor;
        ret.hairColor = player.hairColor;
        ret.moon = player.moon;
        ret.chatHandle = player.chatHandle;
        ret.leftHorn = player.leftHorn;
        ret.rightHorn = player.rightHorn;
        ret.quirk = player.quirk;
        ret.baby = player.baby;
        ret.causeOfDeath = player.causeOfDeath;

        ret.interest1 = player.interest1;
        ret.interest2 = player.interest2;
        ret.setStatsHash(player.stats);
        return ret;
    }


    //TODO has specific 'doomed time clone' stuff in it, like randomizing state
    static Player makeDoomedSnapshot(Player doomedPlayer) {
        Player timeClone = Player.makeRenderingSnapshot(doomedPlayer);
        timeClone.dead = false;
        timeClone.setStat("currentHP", doomedPlayer.getStat("hp")); //heal
        timeClone.doomed = true;
        //from a different timeline, things went differently.
        double r = doomedPlayer.rand.nextDouble();
        timeClone.setStat("power", doomedPlayer.session.rand.nextDouble() * 80 + 10);
        if (r > 0.9) {
            timeClone.robot = true;
            timeClone.hairColor = getRandomGreyColor();
        } else if (r > .8) {
            timeClone.godTier = !timeClone.godTier;
            if (timeClone.godTier) {
                timeClone.setStat("power", 200); //act like a god, damn it.
            }
        } else if (r > .6) {
            timeClone.isDreamSelf = !timeClone.isDreamSelf;
        } else if (r > .4) {
            timeClone.grimDark = doomedPlayer.session.rand.nextIntRange(0, 4);
            timeClone.addStat("power", 50 * timeClone.grimDark);
        } else if (r > .2) {
            timeClone.murderMode = !timeClone.murderMode;
        }

        if (timeClone.grimDark > 3) {
            Fraymotif f = new Fraymotif(Zalgo.generate("The Broodfester Tongues"), 3);
            f.effects.add(new FraymotifEffect("power", 3, true));
            f.effects.add(new FraymotifEffect("power", 0, false));
            f.desc = " They are stubborn throes. ";
            timeClone.fraymotifs.add(f);
        }

        if (timeClone.godTier) {
            Fraymotif f = curSessionGlobalVar.fraymotifCreator.makeFraymotif(doomedPlayer.rand, <Player>[doomedPlayer], 3); //first god tier fraymotif
            timeClone.fraymotifs.add(f);
        }

        if (timeClone.getStat("power") > 50) {
            Fraymotif f = curSessionGlobalVar.fraymotifCreator.makeFraymotif(doomedPlayer.rand, <Player>[doomedPlayer], 2); //probably beat denizen at least
            timeClone.fraymotifs.add(f);
        }

        Fraymotif f = curSessionGlobalVar.fraymotifCreator.makeFraymotif(doomedPlayer.rand, <Player>[doomedPlayer], 1); //at least did first quest
        timeClone.fraymotifs.add(f);

        return timeClone;
    }

}