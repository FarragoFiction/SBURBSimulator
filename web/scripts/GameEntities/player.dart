import '../PlayerSpriteHandler.dart';
import 'dart:async';
import 'dart:convert';
import "dart:html";
import "dart:math" as Math;
import "dart:typed_data";
import "../SBURBSim.dart";
import "../includes/bytebuilder.dart";
import "../navbar.dart";
import '../includes/lz-string.dart';



class Player extends GameEntity{
    //TODO trollPlayer subclass of player??? (have subclass of relationship)
    num baby = null;
    CanvasElement firstStatsCanvas;
    bool canSkaia = false; //unlocked by finishing quests or by quest bed god tiering.

    //set when you set moon, so you know what your dream self looks like even if you don't have a moon.
    Palette dreamPalette;

    //if 0, not yet woken up.
    double moonChance = 0.0;
    num pvpKillCount = 0; //for stats.
    num timesDied = 0;
   static num maxHornNumber = 73; //don't fuck with this
    static num maxHairNumber = 74; //same
    Sprite sprite = null; //gets set to a blank sprite when character is created.
    bool deriveChatHandle = true;
    bool deriveSprite = true;
    bool deriveSpecibus = true;
    bool deriveLand = true;
    String flipOutReason = null; //if it's null, i'm not flipping my shit.
    Player flippingOutOverDeadPlayer = null; //don't let this go into url. but, don't flip out if the friend is currently alive, you goof.
    num denizen_index = 0; //denizen quests are in order.
    List<Player> ghostWisdom = <Player>[]; //keeps you from spamming the same ghost over and over for wisdom.
    bool trickster = false;
    bool sbahj = false;
    List<dynamic> sickRhymes = <dynamic>[]; //oh hell yes. Hell. FUCKING. Yes! TODO: make this its own type -PL
    bool robot = false;
    num ectoBiologicalSource = null; //might not be created in their own session now.
    SBURBClass class_name;
    Player _guardian = null; //no longer the sessions job to keep track.
    num number_confessions = 0;
    num number_times_confessed_to = 0;
    bool baby_stuck = false;
    String influenceSymbol = null; //multiple aspects can influence/mind control.
    Player influencePlayer = null; //who is controlling me? (so i can break free if i have more free will or they die)
    MiniSnapShot stateBackup = null; //if you get influenced by something, here's where your true self is stored until you break free.
    Aspect aspect;
    Land land;
    //want to be able to see when it's set
    Moon _moon;
    Interest interest1 = null;
    Interest interest2 = null;
    String chatHandle = null;
    GameEntity object_to_prototype; //mostly will be potential sprites, but sometimes a player
    //List<Relationship> relationships = [];  //TODO keep a list of player relationships and npc relationships. MAYBE don't wax red for npcs? dunno though.
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
    double landLevel = 0.0; //at 10, you can challenge denizen.  only space player can go over 100 (breed better universe.)
    bool denizenFaced = false;
    bool _denizenDefeated = false;
    bool denizenMinionDefeated = false;

    Moon get moon => _moon;

    String get moonName {
        if(_moon == null) {
            session.logger.info("AB: a player without a moon did something that needed a moon. probably kissing someone. whatever.");
            return "[ERROR: MOON NOT FOUND]";
        }else {
            return _moon.name;
        }
    }

    void set moon(Moon m) {
        if(m != null) ;
        _moon = m;
        if(m!=null) {
            dreamPalette = _moon.palette;
            syncToSessionMoon();
        }
    }

    //no longer allowed to set it.
    bool get denizenDefeated => _denizenDefeated;

    @override
    List<String> get bureaucraticBullshit {
        return class_name.bureaucraticBullshit;
    }

    @override
    void processCardFor() {
      class_name.processCard();
      aspect.processCard();
    }


    void set denizenDefeatedExplicitlySet(bool x) {
        _denizenDefeated = x;
    }

    @override
    String get name => "${title()}($chatHandle)";


    Player([Session session, SBURBClass this.class_name, Aspect this.aspect, GameEntity this.object_to_prototype, Moon m, bool this.godDestiny]) : super("", session) {
        //;
        moon = m; //set explicitly so triggers syncing.
        //testing something
    }

    @override
    StatHolder createHolder() => new PlayerStatHolder(this);

    bool fromThisSession(Session session) {
        return (this.ectoBiologicalSource == null || this.ectoBiologicalSource == session.session_id);
    }

    bool interestedInCategory(InterestCategory c) {
        return (interest1.category == c || interest2.category == c);
    }

    //stop having references to fake as fuck moons yo.
    //make sure you refere to private moon so you don't get in infinite loop
    void syncToSessionMoon() {
        //;
        if(moon == null || session == null || session.prospit == null || session.derse == null) return;
        //;
        if (moon.name == session.prospit.name) {
            ;
            _moon = session.prospit;
        } else if (moon.name == session.derse.name) {
            ;
            _moon = session.derse;
        }
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

    double get trashMobGrist => 10.0;

    ///not the only way to get grist, but you get a small base amount just for doing that shit
    void increaseLandLevel([double points = 1.0]) {
        landLevel += points; //TESTING what right value is to balance with FrogRewards
       increaseGrist();
    }

    void increaseGrist([double points = -1.0]) {
        if(points < 0) points = trashMobGrist;
        grist += points;
    }

    void copyFromOCDataString(String ocDataString) {
        String bs = "${window.location}?" + ocDataString; //need "?" so i can parse as url
        if(window.location.toString().contains("?")) bs = "${window.location}&" + ocDataString;
        String b = (getParameterByName("b", bs)); //this is pre-decoded, if you try to decode again breaks mages of heart which are "%"
        String s = getParameterByName("s", bs);
        String x = (getParameterByName("x", bs));
        List<Player> players = dataBytesAndStringsToPlayers(session,b, s, x); //technically an array of one players.;
        this.copyFromPlayer(players[0]);
    }

    @override
    List<Relationship> getQuadrants() {
        List<Relationship> ret = new List<Relationship>();
        ret.addAll(getHearts());
        ret.addAll(getSpades());
        ret.addAll(getDiamonds());
        ret.addAll(getClubs());
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

    @override
    List<Fraymotif> get fraymotifsForDisplay {
        List<Fraymotif> ret = new List.from(fraymotifs);
        //;
        for(Item item in sylladex) {
            //;

            if(item is MagicalItem && aspect.isThisMe(Aspects.SAUCE)) {
                MagicalItem m = item as MagicalItem;
                //only sauce players can use the ring
                ret.addAll(m.fraymotifs);
            }else if(Item is MagicalItem) {
                //MagicalItem m = item as MagicalItem;
                //if(!(m is Ring) && !(m is Scepter) ) ret.addAll(m.fraymotifs);
            }
        }
        return ret;
    }

    @override
    void flipOut(String reason) {
        ////print("flip out method called for: " + reason);
        this.flippingOutOverDeadPlayer = null;
        this.flipOutReason = reason;
    }

    @override
    void changeGrimDark(num val) {
        //this.grimDark += val;
        num tmp = this.grimDark + val;
        bool render = false;

        if (this.grimDark <= 3 && tmp > 3) { //newly GrimDark
            //;
            render = true;
        } else if (this.grimDark > 3 && tmp <= 3) { //newly recovered.
            render = true;
        }
        this.grimDark += val;
        if (render) {
            this.renderSelf("changeGrimDark");
        }
        //jr of 10/22/2018 says that this might help keep things from acting weird
        //this.grimDark = Math.min(4,this.grimDark); //don't be higher than 4
        //this.grimDark = Math.max(0,this.grimDark); //don't be lower than 0.
    }

    void makeMurderMode() {
        this.murderMode = true;
        this.increasePower();
        this.renderSelf("makeMurderMode"); //new scars. //can't do scars just on top of sprite 'cause hair might cover.'
    }

    void unmakeMurderMode() {
        if(session.mutator.rageField) return; //you don't LEAVE murdermode until you are mothering fuck DONE you heretic
        this.murderMode = false;
        this.leftMurderMode = true;
        this.renderSelf("unmakeMurderMode");
    }

    void addDoomedTimeClone(Player timeClone) {
        doomedTimeClones.add(timeClone);
        addStat(Stats.SANITY, -10);
        flipOut("their own doomed time clones");
    }


    @override
    String makeDead(String causeOfDeath, GameEntity killer, [bool allowLooting = true]) {
        //session.logger.info("DEBUGGING MAKE DEAD making ${title()} dead $causeOfDeath");
        String looting = "";
        myKiller = killer;
        //can loot corpses even in life gnosis, or how else will things happen?
        if(killer != null && allowLooting) {
            if(sylladex.inventory.isNotEmpty) {
                looting = "$killer takes ${turnArrayIntoHumanSentence(sylladex.inventory)} as a trophy";
            }else {
                looting = "There was nothing to loot.";
            }
            killer.lootCorpse(this);
        }

        if(session.mutator.lifeField) return " Death has no meaning. "; //does fucking nothing.

        if(killer != null) {
            if(this is Player) {
                killer.playerKillCount ++;
            }else {
                killer.npcKillCount ++;
            }
        }
        String ret = "${htmlTitle()} is dead. ";
        bool alreadyDead = this.dead;

        this.dead = true;
        this.timesDied ++;
        this.stats.onDeath();
        this.causeOfDeath = sanitizeString(causeOfDeath);
        if (this.getStat(Stats.CURRENT_HEALTH) > 0) this.setStat(Stats.CURRENT_HEALTH, -1); //just in case anything weird is going on. dead is dead.  (for example, you could have been debuffed of hp).
        if (!this.godTier) { //god tiers only make ghosts in GodTierRevivial
            Player g = Player.makeRenderingSnapshot(this,false);
            g.fraymotifs = new List<Fraymotif>.from(this.fraymotifs); //copy not reference
            this.session.afterLife.addGhost(g);
        }
        //was in make alive, but realized that this makes doom ghosts way stronger if it's here. powered by DEATH, but being revived.
        if(prophecy == ProphecyState.ACTIVE){ //powered by their own doom.
            prophecy = ProphecyState.FULLFILLED;
            ret += " The prophecy is fullfilled. ";
        }
        if(!alreadyDead) {
            if(canvas == null) initSpriteCanvas();
            if(!Drawing.checkSimMode()) canvas.context2D.save(); //need to restore living state latr
            this.renderSelf("makeDead");
            this.triggerOtherPlayersWithMyDeath();
            canvas.context2D.restore(); //only stay rotated long enough to render.
        }

        String bb = "";
        //no you can't be a villain for dying randomly or killing yourself
        if(killer != null && !villain && killer != this) bb = killer.makeBigBad();

        return "$ret $looting $bb";
    }

    void triggerOtherPlayersWithMyDeath() {
        //go through my relationships. if i am the only dead person, trigger everybody (death still has impact)
        //trigger (possibly ontop of base trigger) friends, and quadrant mates. really fuck up my moirel(s) if i have any
        //if triggered, also give a flip out reason.
        List<Player> dead = findDeadPlayers(this.session.players);
        for (num i = 0; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];

            if (r.saved_type == r.goodBig) {
                r.target.addStat(Stats.SANITY, -10);
                if ((r.target  as Player).flipOutReason == null) {
                    (r.target  as Player).flipOutReason = " their dead crush, the ${this.htmlTitleBasic()}"; //don't override existing flip out reasons. not for something as generic as a dead crush.
                    (r.target  as Player).flippingOutOverDeadPlayer = this;
                }
            } else if (r.value > 0) {
                r.target.addStat(Stats.SANITY, -10);
                if ((r.target  as Player).flipOutReason == null) {
                    (r.target  as Player).flippingOutOverDeadPlayer = this;
                    (r.target  as Player).flipOutReason = " their dead friend, the ${this.htmlTitleBasic()}"; //don't override existing flip out reasons. not for something as generic as a dead friend.
                }
            } else if (r.saved_type == r.spades) {
                (r.target  as Player).addStat(Stats.SANITY, -100);
                (r.target  as Player).flipOutReason = " their dead Kismesis, the ${this.htmlTitleBasic()}";
                (r.target  as Player).flippingOutOverDeadPlayer = this;
            } else if (r.saved_type == r.heart) {
                (r.target  as Player).addStat(Stats.SANITY, -100);
                (r.target  as Player).flipOutReason = " their dead Matesprit, the ${this.htmlTitleBasic()}";
                (r.target  as Player).flippingOutOverDeadPlayer = this;
            } else if (r.saved_type == r.diamond) {
                (r.target  as Player).addStat(Stats.SANITY, -1000);
                (r.target  as Player).damageAllRelationships();
                (r.target  as Player).damageAllRelationships();
                (r.target  as Player).damageAllRelationships();
                (r.target  as Player).flipOutReason = " their dead Moirail, the ${this.htmlTitleBasic()}, fuck, that can't be good...";
                (r.target  as Player).flippingOutOverDeadPlayer = this;
            }

            //whether or not i care about them, there's also the novelty factor.
            if (dead.length == 1) { //if only I am dead, death still has it's impact and even my enemies care.
                r.target.addStat(Stats.SANITY, -10);
                if ((r.target  as Player).flipOutReason == null) {
                    (r.target  as Player).flipOutReason = " the dead player, the ${this.htmlTitleBasic()}"; //don't override existing flip out reasons. not for something as generic as a dead player.
                    (r.target  as Player).flippingOutOverDeadPlayer = this;
                }
            }
            ////print(r.target.title() + " has flipOutReason of: " + r.target.flipOutReason + " and knows about dead player: " + r.target.flippingOutOverDeadPlayer);
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

    void setDenizenDefeated() {
        _denizenDefeated = true;
        addBuff(new BuffDenizenBeaten());  //current and future doubling of power.
        leveledTheHellUp = true;
        session.stats.denizenBeat = true;
    }

    void makeGodTier() {
        //this.addStat(Stats.HEALTH, 500); //they are GODS.
        //this.addStat(Stats.CURRENT_HEALTH, 500); //they are GODS.
        //this.addStat(Stats.POWER, 500); //they are GODS.
        this.addBuff(new BuffGodTier()); // +100 base power and health, 2.5 stat multiplier
        this.increasePower();
        //was on a quest bed.
        if(!isDreamSelf && dreamSelf) canSkaia = true;

        //i know for a fact this is rare enough that i'll forget i added it.
        if(dreamSelf && aspect != Aspects.TIME && aspect != Aspects.SPACE &&  sylladex.containsWord("Sauce")) {
            aspect = Aspects.SAUCE;
            session.logger.info("AB: Bluh. One of Shogun's Sauce Glitches just triggered. Better tell JR.");
            fraymotifs.add(new Fraymotif("Seinfeld Remix", 13)
                ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 2, true))
                ..desc = " What the fuck? What even is this? Is it a riddle? I thought JR said it wasn't important... ");
        }

        if(dreamSelf && aspect != Aspects.TIME && aspect != Aspects.SPACE &&  sylladex.containsWord("Juice")) {
            aspect = Aspects.JUICE;
            session.logger.info("AB: Bluh. One of Shogun's Juice Glitches just triggered. Better tell JR.");
            fraymotifs.add(new Fraymotif("Seinfeld Remix", 13)
                ..effects.add(new FraymotifEffect(Stats.FREE_WILL, 2, true))
                ..desc = " What the fuck? What even is this? Is it a riddle? I thought JR said it wasn't important... ");
        }

        this.godTier = true;
        this.session.stats.godTier = true;
        this.dreamSelf = false;
        this.canGodTierRevive = true;
        this.leftMurderMode = false; //no scars, unlike other revival methods
        this.isDreamSelf = false;
        this.makeAlive();
        renderSelf("goGodTier");
    }

    @override
    void makeAlive() {
        if (this.dead == false) return; //don't do all this.
        if (this.stateBackup != null) this.stateBackup.restoreState(this);
        this.influencePlayer = null;
        this.influenceSymbol = null;
        this.dead = false;
        this.murderMode = false;
        this.setStat(Stats.CURRENT_HEALTH, Math.max(this.getStat(Stats.HEALTH), 1)); //if for some reason your hp is negative, don't do that.
        ////print("HP after being brought back from the dead: " + this.currentHP);
        this.grimDark = 0;
        this.addStat(Stats.SANITY, -101); //dying is pretty triggering.
        this.flipOutReason = "they just freaking died";
        //this.leftMurderMode = false; //no scars
        this.victimBlood = null; //clean face
        if(canvas == null) initSpriteCanvas();
        this.renderSelf("makeAlive");
    }

    Player get guardian {
        if(_guardian == null) {
            makeGuardian();
        }
        return _guardian;
    }

    void set guardian(Player g) {
        _guardian = g;
    }

    @override
    bool renderable() {
        return true;
    }

    @override
    String title() {
        String ret = "$extraTitle ";

        if (this.villain) ret = "${ret}Villainous ";


        if(this.crowned != null) {
            ret = "${ret}Crowned ";
        }

        if(this.leader) {
            //ret = "${ret}Leader ";
        }

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

        if (this.gnosis == 4) {
            ret = "${ret}Wasted ";
        }
        //refrance to shogun's april fools artwork
        if(aspect == Aspects.SAUCE) {
            ret = "$ret${this.class_name.sauceTitle} of ${this.aspect}";
        }else {
            ret = "$ret${this.class_name} of ${this.aspect}";
        }
        if (this.dead) {
            ret = "$ret's Corpse";
        } else if (this.ghost) {
            ret = "$ret's Ghost";
        }else if(this.brainGhost) {
            ret = "$ret's Brain Ghost";

        }

        return ret;
    }

    @override
    String htmlTitleBasicWithTip() {
        return "${getToolTip()}${this.aspect.fontTag()}${this.titleBasic()}</font></span>";
    }

    String htmlTitleBasic() {
        return "${this.aspect.fontTag()}${this.titleBasic()}</font> (<font color = '${getChatFontColor()}'>${chatHandle}</font>)";
    }

    String htmlTitleBasicNoTip() {
        return "${this.aspect.fontTag()}${this.titleBasic()}</font> (<font color = '${getChatFontColor()}'>${chatHandle}</font>)";
    }

    //@override
    String titleBasic() {
        String ret = "";

        ret = "$ret${this.class_name} of ${this.aspect}";
        return ret;
    }

    //what gets displayed when you hover over any htmlTitle (even HP)
    String getToolTip() {
        if (Drawing.checkSimMode() == true) {
            return "<span>";
        }
        String ret = "<span class = 'tooltip'><span class='tooltiptext'><table>";
        ret += "<tr><td class = 'toolTipSection'>$chatHandle<hr>";
        ret += "Class: ${class_name.name}<Br>";
        ret += "Aspect: ${aspect.name}<Br>";
        String landString = "DESTROYED.";
        if(land != null) landString = land.name;
        ret += "Land: ${landString}<Br>";
        String denizen = "NONE";
        if(land != null) denizen = land.denizenFeature.name;

        ret += "Denizen: $denizen<Br>";

        ret += "LandLevel: $landLevel<Br>";
        ret += "Gnosis: $gnosis<Br>";
        if(sprite != null) ret += "Sprite: ${sprite.name}";
        if(sprite != null && sprite.dead) ret += " (dead)";
        ret += "<br><Br>Prophecy Status: ${prophecy}";
        ret += "<br><br>Flipping out over: ${flipOutReason}";

        ret += "</td>";
        Iterable<Stat> as = Stats.summarise;
        ret += "<td class = 'toolTipSection'>Stats<hr>";
        for (Stat stat in as) {
            int baseValue = getStat(stat,true).round();
            int derivedValue = getStat(stat).round();
            ret += "$stat: ${baseValue} (+ ${derivedValue-baseValue})<br>";
        }
        ret += "Grist: $grist)<br>";


        ret += "</td>";
        ret += "<td class = 'toolTipSection'>Companions<hr>";
        for(GameEntity g in companionsCopy) {
            String species  = "";
            if(g is Leprechaun) species = "(Leprechaun)";
            if(g is Consort) species = "(Consort)";
            if(g is Carapace && (g as Carapace).type == Carapace.DERSE) species = "(Dersite)";
            if(g is Carapace && (g as Carapace).type == Carapace.PROSPIT) species = "(Prospitian)";

            ret += "${g.title()} $species<br>";
        }

        ret += "</td><td class = 'toolTipSection' rowspan='2'>Sylladex<hr>";
        ret += "Specibus: ${specibus.fullNameWithUpgrade}, Rank: ${specibus.rank}<br><br>";

        for(Item item in sylladex) {
            ret += "${item.fullNameWithUpgrade}<br>";
        }

        ret += "</td><td class = 'toolTipSection' rowspan='2'>AI<hr>";

        for (Scene s in scenes) {
            if(s is SerializableScene) {
                ret += "${s}<br>";
            }else {
                ret += "???<br>";
            }
        }


        ret += "</td><td class = 'toolTipSection' rowspan='2'>Buffs<hr>";



        for (Buff b in buffs) {
            ret += "$b<br>";
        }

        for (AssociatedStat s in associatedStats) {
            ret += "$s<br>";
        }

        ret += "</td></tr><tr><td class = 'toolTipSection'>Fraymotifs<hr>";
        for(Fraymotif f in fraymotifs) {
            ret += "${f.name}<br>";
        }
        if(aspect is AspectWithSubAspects) {
            AspectWithSubAspects sa = aspect as AspectWithSubAspects;
            for(Aspect a in sa.subAspects) {
                ret += "Aspectal ${a.name}<br>";
            }
        }

        ret += "</td><td class = 'toolTipSection'>Relationships<hr>";
        for(Relationship r in relationships) {
            ret += "$r<br>";
        }
        ret += "</td></tr></table></span>";
        return ret;
    }


    String getNextLevel() {
        this.level_index ++;
        String ret = this.level_index >= this.mylevels.length ? "[Off the top of the Echeladder]" : this.mylevels[this.level_index];
        return ret;
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
            Fraymotif f = new Fraymotif("Telekinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
            f.desc = " Large objects begin pelting the ENEMY. ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Pyrokinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
            f.desc = " Who knew shaving cream was so flammable? ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Aquakinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
            f.desc = " A deluge begins damaging the ENEMY. ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Electrokinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
            f.desc = " An electric pulse begins damaging the ENEMY. ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Terakinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
            f.desc = " The very ground begins damaging the ENEMY. ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Vitaekinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
            f.desc = " The ENEMY's own body is turned against them as they begin punching their own face. ";
            psionics.add(f);
        }
        {
            Fraymotif f = new Fraymotif("Fungikinesis", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
            f.desc = " A confusing array of mushrooms begins damaging the ENEMY. ";
            psionics.add(f);
        }


        {
            Fraymotif f = new Fraymotif("Mind Control", 1);
            f.effects.add(new FraymotifEffect(Stats.FREE_WILL, 3, true));
            f.effects.add(new FraymotifEffect(Stats.FREE_WILL, 3, false));
            f.desc = " All enemies start damaging themselves. It's kind of embarassing how easy this is.  ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Optic Blast", 1);
            f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
            f.desc = " Appropriately colored eye beams pierce the ENEMY. ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Ghost Communing", 1);
            f.effects.add(new FraymotifEffect(Stats.SANITY, 3, true));
            f.effects.add(new FraymotifEffect(Stats.SANITY, 3, false));
            f.desc = " The souls of the dead start hassling all enemies. ";
            psionics.add(f);
        }

        {
            Fraymotif f = new Fraymotif("Animal Communing", 1);
            f.effects.add(new FraymotifEffect(Stats.SANITY, 3, true));
            f.effects.add(new FraymotifEffect(Stats.SANITY, 3, false));
            f.desc = " Local animal equivalents start hassling all enemies. ";
            psionics.add(f);
        }

        return psionics;
    }

    void applyPossiblePsionics() {
        // //print("Checking to see how many fraymotifs I have: " + this.fraymotifs.length + " and if I am a troll: " + this.isTroll);
        if (!this.fraymotifs.isEmpty || !this.isTroll) return; //if i already have fraymotifs, then they were probably predefined.
        //highest land dwellers can have chucklevoodoos. Other than that, lower on hemospectrum = greater odds of having psionics.;
        //make sure psionic list is kept in global var, so that char creator eventually can access? Wait, no, just wrtap it in a function here. don't polute global name space.
        //trolls can clearly have more than one set of psionics. so. odds of psionics is inverse with hemospectrum position. didn't i do this math before? where?
        //oh! low blood vocabulary!!! that'd be in quirks, i think.
        ////print("My blood color is: " + this.bloodColor);
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
            f.effects.add(new FraymotifEffect(Stats.SANITY, 3, false));
            f.effects.add(new FraymotifEffect(Stats.SANITY, 3, true));
            f.desc = " Oh god oh no no no no no no no no. The enemies are no longer doing okay, psychologically speaking. ";
            this.fraymotifs.add(f);
        } else if (this.bloodColor == "#658200") {
            Fraymotif f = new Fraymotif("Limeade Refreshment", 1);
            f.effects.add(new FraymotifEffect(Stats.SANITY, 1, false));
            f.effects.add(new FraymotifEffect(Stats.SANITY, 1, true));
            f.desc = " All allies just settle their shit for a little while. Cool it. ";
            this.fraymotifs.add(f);
        } else if (this.bloodColor == "#ffc3df") {
            Fraymotif f = new Fraymotif("'<font color='pink'>${this.chatHandle} and the Power of Looove~~~~~<3<3<3</font>'", 1);
            f.effects.add(new FraymotifEffect(Stats.RELATIONSHIPS, 3, false));
            f.effects.add(new FraymotifEffect(Stats.RELATIONSHIPS, 3, true));
            f.desc = " You are pretty sure this is not a real type of Troll Psionic.  It heals everybody in a bullshit parade of sparkles, and heart effects despite your disbelief. Everybody is also SUPER MEGA ULTRA IN LOVE with each other now, but ESPECIALLY in love with ${this.htmlTitleHP()}. ";
            this.fraymotifs.add(f);
        }
    }

    bool isVoidAvailable() {
        Player light = findAspectPlayer(findLiving(this.session.players), Aspects.LIGHT);
        if (light != null && light.godTier) return false;
        return true;
    }

    num getPVPModifier(String role) {
        if (role == "Attacker") return this.getAttackerModifier();
        if (role == "Defender") return this.getDefenderModifier();
        if (role == "Murderer") return this.getMurderousModifier();
        return null;
    }

    bool hasPowers() {
        if(class_name == SBURBClassManager.WASTE || class_name == SBURBClassManager.GRACE) return false;
        if(aspect.isThisMe(Aspects.TIME)) return true;  //they have it in the future after all. and
        if(godTier) return true; //you just do okay.
        if(land == null) return true;//you're a combo player.
        if(land.firstCompleted) { //you are starting to face your denizen
            return true;
        }
        return false;
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
        return this.land.denizenFeature.name; //<--convineint that it wasn't hard to upgrade.
    }

    bool didDenizenKillYou() {
        if (land != null && this.causeOfDeath.contains(this.land.denizenFeature.name)) {
            return true; //also return true for minions. this is intentional.;
        }
        return false;
    }

    bool justDeath() {
        if(session.mutator.rageField) return true; //you earned it, kid. no take backs.
        if(unconditionallyImmortal) return false;
        if(villain) return true;//you earned it too.
        bool ret = false;

        //impossible to have a just death from a denizen or denizen minion. unless you are corrupt.
        if (this.didDenizenKillYou() && (this.grimDark <= 2)) {
            return false;
        } else if (this.grimDark > 2) {
            //;
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
                ////print("rand is: " + rand);
                if (r > .2) {
                    ////print(" just death for: " + this.title() + "rand is: " + rand)
                    ret = true;
                }
            }
        } else { //you are a good person. just corrupt.
            //way more likely to be a just death if you're being an asshole.
            if ((this.murderMode || this.grimDark > 2) && rand.nextDouble() > .5) {
                ret = true;
            }
        }
        ////print(ret);
        //return true; //for testing
        return ret;
    }

    bool heroicDeath() {
        if(unconditionallyImmortal) return false;
        bool ret = false;
        //maybe you derp died, sure. but....probably this was heroic
        if(myKiller != null && myKiller.villain == true && session.rand.nextDouble() > 0.3) {
            return true;
        }

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
            if ((this.session.battlefield.blackKing.getStat(Stats.CURRENT_HEALTH) <= 0 || this.session.battlefield.blackKing.dead == true) && this.session.rand.nextDouble() > .2) {
                ret = true;
            }
        } else { //unlikely hero
            if (this.session.rand.nextDouble() > .8) {
                ret = true;
            }
            //extra likely if you just killed the king/queen, you hero you.
            if (this.session.battlefield.blackKing.getStat(Stats.CURRENT_HEALTH) <= 0 || this.session.battlefield.blackKing.dead == true && rand.nextDouble() > .4) {
                ret = true;
            }
        }

        if (ret) {
            ////;
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
            //this.session.logger.info("$this: interact start");
            for (num i = 0; i < this.associatedStats.length; i++) {
                this.processStatInteractionEffect(target, this.associatedStats[i]);
            }
            //this.session.logger.info("$this: interact end");
        }
    }

    void processStatInteractionEffect(GameEntity target, AssociatedStat stat) {
            class_name.processStatInteractionEffect(this, target, stat);
    }

    @override
    String interactionEffect(GameEntity target) {
        String ret = "";
        this.associatedStatsInteractionEffect(target);

        //no longer do this seperate. if close enough to modify with powers, close enough to be...closer.
        Relationship r1 = this.getRelationshipWith(target);
        if (r1 != null) {
            r1.moreOfSame();
        }

        //doom players with an interaction effect also spread doom. this is bad in short term and good in long
        //SHOULD be only bad against enemies, since they don't have revival mechanisms. right???
        if(hasInteractionEffect() && aspect.isThisMe(Aspects.DOOM) && target.prophecy == ProphecyState.NONE) {
            ret = "There is a prophecy of the ${target.htmlTitle()}'s death.";
            target.prophecy = ProphecyState.ACTIVE;
        }
        //even if there is no effect, still is doing relationship shit.
        ret += class_name.interactionFlavorText(this, target, session.rand);
        return ret;
    }


    List<Player> performEctobiology(Session session) {
        session.stats.ectoBiologyStarted = true;
        List<Player> playersMade = findPlayersWithoutEctobiologicalSource(session.players);
        setEctobiologicalSource(playersMade, session.session_id);
        return playersMade;
    }

    bool isActive([double multiplier = 0.0]) {
        return class_name.isActive(multiplier);
    }


    @override
    Player clone() {
        Player clone = new Player();
        super.copyStatsTo(clone);
        //clone stats.
        clone.baby = baby;
        //don't let that bitch be null
        clone.dreamPalette = dreamPalette;

        clone.pvpKillCount = pvpKillCount; //for stats.
        clone.timesDied = timesDied;

        if(sprite != null) clone.sprite =  sprite.clone(); //gets set to a blank sprite when character is created.
        clone.deriveChatHandle = deriveChatHandle;
        clone.deriveLand = deriveLand;
        ;
        clone.moon = moon;
        clone.flipOutReason = flipOutReason; //if it's null, i'm not flipping my shit.
        clone.flippingOutOverDeadPlayer = flippingOutOverDeadPlayer; //don't let this go into url. but, don't flip out if the friend is currently alive, you goof.
        clone.denizen_index = denizen_index; //denizen quests are in order.
        clone.causeOfDrain = causeOfDrain; //just ghost things
        clone.ghostWisdom = ghostWisdom; //keeps you from spamming the same ghost over and over for wisdom.

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
        clone.denizenDefeatedExplicitlySet = denizenDefeated;
        clone.denizenMinionDefeated = denizenMinionDefeated;
        clone.session = session;
        //do not clone guardian, thing that calls you will do that
        return clone;
    }


    void makeGuardian() {
        ////print("guardian for " + player.titleBasic());
        Player player = this;
        List<SBURBClass> possibilities = session.available_classes_guardians;
        if (possibilities.isEmpty) possibilities = new List<SBURBClass>.from(SBURBClassManager.canon);
        ////print("class names available for guardians is: " + possibilities);
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

        ////print("Guardian className: " + guardian.class_name + " Player was: " + this.class_name);
        guardian.leftHorn = player.leftHorn;
        guardian.rightHorn = player.rightHorn;
        guardian.level_index = 5; //scratched kids start more leveled up
        guardian.setStat(Stats.POWER, 50);
        guardian.leader = player.leader;
        if (this.session.rand.nextDouble() > 0.5) { //have SOMETHING in common with your ectorelative.
            guardian.interest1 = player.interest1;
        } else {
            guardian.interest2 = player.interest2;
        }
        guardian.initializeDerivedStuff(); //redo levels and land based on real aspect
        //this.guardians.add(guardian); //sessions don't keep track of this anymore
        player._guardian = guardian;
        guardian._guardian = this; //goes both ways.
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

    double getPowerForEffects() {
        double p = this.stats[Stats.POWER] / Stats.POWER.coefficient;
        p = smoothCap(p, 200.0, 75.0, 0.5);
        return p;
    }

    void processStatPowerIncrease(num powerBoost, AssociatedStat stat) {
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if (this.isActive(stat.multiplier)) { //modify me
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
        ////;
        if (this.session.rand.nextDouble() > .9) {
            this.leveledTheHellUp = true; //that multiple of ten thing is bullshit.
        }
        num powerBoost = magnitude * this.class_name.powerBoostMultiplier * this.aspect.powerBoostMultiplier; // this applies the page 5x mult

        //this.addStat(Stats.POWER, Math.max(1, powerBoost)); //no negatives
        //wastes need to be nerfed even more
        this.addStat(Stats.EXPERIENCE, Math.max(1, powerBoost));

        this.associatedStatsIncreasePower(powerBoost);
        //gain a bit of hp, otherwise denizen will never let players fight them if their hp isn't high enough.
        /*if (this.godTier || this.session.rand.nextDouble() > .85) {
            this.addStat(Stats.HEALTH, 5);
            this.addStat(Stats.CURRENT_HEALTH, 5);
        }*/
        this.addStat(Stats.EXPERIENCE, this.rand.nextDoubleRange(0.1, 1.0));
        //TODO figure out what the actual fuck this line was supposed to be doing. set power to ITSELF???
        //IT IS THE REASON WHY 40+5 = 65 and i do not even know why. stats are still too high though.
        // if (this.getStat(Stats.POWER) > 0) this.setStat(Stats.POWER, this.getStat(Stats.POWER).round());

        // //;
        this.heal();
    }

    String shortLand() {
        if (land == null) throw "Should Never Ask for the Abbreviation for a Null Land";
        return land.shortName;
    }

    @override
    String htmlTitle() {
        String light = "";
        if(session.mutator.lightField) light = " (Active: ${active}, Available: ${available})";
        return "${this.aspect.fontTag()}${this.title()}</font>$light";
    }

    @override
    String htmlTitleWithTip() {
        return "${getToolTip()}${this.aspect.fontTag()}${this.title()}</font></span>";
    }

    @override
    String htmlTitleHP() {
        return "${getToolTip()}${this.aspect.fontTag()}${this.title()} (${(this.getStat(Stats.CURRENT_HEALTH)).round()}hp, ${(this.getStat(Stats.POWER)).round()} power)</font></span>";
    }

    void generateBlandRelationships(List<Player> friends) {
        for (num i = 0; i < friends.length; i++) {
            if (friends[i] != this) { //No, Karkat, you can't be your own Kismesis.
                //one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
                //that it needs to be a thing.
                Relationship r = Relationship.randomBlandRelationship(this, friends[i]);
                if (this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d") {
                    r.value = -20; //biological imperitive to fight for throne.
                    this.addStat(Stats.SANITY, -100);
                    friends[i].addStat(Stats.SANITY, -100);
                }
                this.relationships.add(r);
            }
        }
    }

    void generateRelationships(List<Player> friends) {
        //	//print(this.title() + " generating a relationship with: " + friends.length);
        for (num i = 0; i < friends.length; i++) {
            if (friends[i] != this) { //No, Karkat, you can't be your own Kismesis.
                //one time in a random sim two heirresses decided to kill each other and this was so amazing and canon compliant
                //that it needs to be a thing.
                Relationship r = Relationship.randomRelationship(this, friends[i]);
                if (this.isTroll && this.bloodColor == "#99004d" && friends[i].isTroll && friends[i].bloodColor == "#99004d") {
                    r.value = -20; //biological imperitive to fight for throne.
                    this.addStat(Stats.SANITY, -10);
                    friends[i].addStat(Stats.SANITY, -10);
                }
                this.relationships.add(r);
            } else {
                ////print(this.title() + "Not generating a relationship with: " + friends[i].title());
            }
        }
    }

    void checkBloodBoost(List<Player> players) {
        if (this.aspect.isThisMe(Aspects.BLOOD)) { // TODO: ASPECTS - migrate to per-aspect boost?
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

    void damageAllRelationshipsWithMe() {
        for (num i = 0; i < session.players.length; i++) {
            Relationship r = this.getRelationshipWith(session.players[i]);
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
        if(session.mutator.lightField && session.mutator.inSpotLight != null) player = session.mutator.inSpotLight; //check for null so i can make previous holder hate new one
        for (Relationship r in relationships) {
            if (r.target.id == player.id) {
                return r;
            }
        }
        //;
        //JR: this might be a VERY bad idea. let's find out together. (1/26/18)
        //you at least have to be a player for now, because of how relationships work.
        //might subclass it out later
        if(player is Player) {
            Relationship newR = new Relationship(this, 0, player);
            player.relationships.add(newR); //nice to meet you
            return newR;
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
        if(session.mutator.lightField) return [session.mutator.inSpotLight];
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
        if(statName == Stats.HEALTH) return "sturdy";
        if(statName == Stats.RELATIONSHIPS) return "friendly";
        if(statName == Stats.MOBILITY) return "fast";
        if(statName == Stats.SANITY) return "calm";
        if(statName == Stats.FREE_WILL) return "willful";
        if(statName == Stats.MAX_LUCK) return "lucky";
        if(statName == Stats.MIN_LUCK) return "lucky";
        if(statName == Stats.ALCHEMY) return "creative";
        return "???";
	}*/
    @override
    String describeBuffs() {
        List<String> ret = <String>[];
        Iterable<Stat> allStats = Stats.all;
        for (Stat stat in allStats) {
            double withbuffs = this.stats.derive(stat); // functionally this.stats[stat]
            double withoutbuffs = this.stats.derive(stat, (Buff b) => !b.combat);
            double diff = withbuffs - withoutbuffs;
            //;
            //only say nothing if equal to zero
            if (diff > 0) ret.add("more ${stat.emphaticPositive}");
            if (diff < 0) ret.add("less ${stat.emphaticPositive}");
        }
        if (ret.isEmpty) return "";
        return "<br/><br/>${this.htmlTitleHP()} is feeling ${turnArrayIntoHumanSentence(ret)} than normal. ";
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
            if (r != null && r.value > bestRelationshipSoFar.value) {
                bestRelationshipSoFar = r;
            }
        }
        return bestRelationshipSoFar.target;
    }

    GameEntity getWorstEnemy() {
        Relationship worstRelationshipSoFar = this.relationships[0];
        for (num i = 1; i < this.relationships.length; i++) {
            Relationship r = this.relationships[i];
            if (r != null && r.value < worstRelationshipSoFar.value) {
                worstRelationshipSoFar = r;
            }
        }
        return worstRelationshipSoFar.target;
    }

    GameEntity getBestFriendFromList(List<GameEntity>potentialFriends, [String debugMessage = null]) {
        Relationship bestRelationshipSoFar = this.relationships[0];
        for (num i = 0; i < potentialFriends.length; i++) {
            GameEntity p = potentialFriends[i];
            if (p != this) {
                Relationship r = this.getRelationshipWith(p);
                if (r == null) {
                    ////print("Couldn't find relationships between " + this.chatHandle + " and " + p.chatHandle);
                    ////print(debugMessage);
                    ////print(potentialFriends);
                    ////print(this);
                }
                if (r != null && r.value > bestRelationshipSoFar.value) {
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
                if (r != null && r.value < worstRelationshipSoFar.value) {
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
      //session.logger.info("Session of type: ${this.session.getSessionType()}");
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
            this.object_to_prototype.session = session;
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
            this.myLusus = session.rand.pickFrom(PotentialSprite.sea_lusus_objects);
            this.myLusus.session = session;
        } else {
            this.myLusus = session.rand.pickFrom(PotentialSprite.lusus_objects);
            this.myLusus.session = session;
        }
    }

    List<Player> getFriends() {
        List<Player> ret = <Player>[];
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
        this.setStat(Stats.MIN_LUCK, this.session.rand.nextIntRange(-10, 0)); //middle of the road.
        this.setStat(Stats.MAX_LUCK, this.session.rand.nextIntRange(1, 10)); //max needs to be more than min.
    }


    void initializeFreeWill() {
        this.setStat(Stats.FREE_WILL, this.session.rand.nextIntRange(-10, 10));
    }

    void initializeHP() {
        this.setStat(Stats.HEALTH, this.session.rand.nextIntRange(40, 60));
        this.setStat(Stats.CURRENT_HEALTH, this.getStat(Stats.HEALTH));

        if (this.isTroll && this.bloodColor != "#ff0000") {
            this.addStat(Stats.CURRENT_HEALTH, bloodColorToBoost(this.bloodColor));
            this.addStat(Stats.HEALTH, bloodColorToBoost(this.bloodColor));
        }
    }

    void initSpriteCanvas() {
        if(canvas != null) return;
       // ;
        canvas = new CanvasElement(width: 400, height: 300);
        renderSelf("initSpriteCanvas");
    }

    void renderSelf(String caller) {
        if(Drawing.checkSimMode()) return;
        if (canvas == null) this.initSpriteCanvas();
        this.clearSelf();
        //TODO someday tackle the headache that would be needed to make all of rendering async
        //await PlayerSpriteHandler.drawSpriteFromScratch(canvas, this);

        Drawing.drawSpriteFromScratch(canvas, this);
    }

    void clearSelf() {
        canvas.context2D.clearRect(0, 0, canvas.width, canvas.height);
    }

    void initializeMobility() {
        this.setStat(Stats.MOBILITY, this.session.rand.nextIntRange(-10, 10));
    }

    void initializeSanity() {
        this.setStat(Stats.SANITY, this.session.rand.nextIntRange(-10, 10));
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
                if (this.isTroll && this.bloodColor == "#99004d" && (r.target  as Player).isTroll && (r.target  as Player).bloodColor == "#99004d") {
                    r.value = -20; //biological imperitive to fight for throne.
                    this.addStat(Stats.SANITY, -10);
                    r.target.addStat(Stats.SANITY, -10);
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
        this.setStat(Stats.POWER, 10);

        if (this.robot) {
            this.addStat(Stats.POWER, 100); //robots are superior
        }

        if (this.isTroll && this.bloodColor != "#ff0000") {
            this.addStat(Stats.POWER, bloodColorToBoost(this.bloodColor));
        }
        //;
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
        Map<String, dynamic> j = this.toJSONBrief();
        if (j["class_name"] <= 15 && j["aspect"] <= 15) { //if NEITHER have need of extension, just return size zero;
            builder.appendExpGolomb(0); //for length
            return base64Url.encode(builder.toBuffer().asUint8List());
        }
        builder.appendExpGolomb(2); //for length
        builder.appendByte(j["class_name"]);
        builder.appendByte(j["aspect"]);
        //String data = utf8.decode(builder.toBuffer().asUint8List());
        return base64Url.encode(builder.toBuffer().asUint8List());
        //return Uri.encodeComponent(data).replaceAll(new RegExp(r"""#""", multiLine:true), '%23').replaceAll(new RegExp(r"""&""", multiLine:true), '%26');
    }

    void readInExtensionsString(ByteReader reader) {
        //;
        //just inverse of encoding process.
        int numFeatures = reader.readExpGolomb(); //assume features are in set order. and that if a given feature is variable it is ALWAYS variable.
        //;
        if (numFeatures > 0) {
            int cid = reader.readByte();
            //;
            this.class_name = intToClassName(cid);
        }
        if (numFeatures > 1) {
            int i = reader.readByte();
            //;

            this.aspect = Aspects.get(i);
            //;
        }


        //as i add more things, add more lines. ALWAYS in same order, but not all features all the time.
    }

    JSONObject toJSON() {
      JSONObject json = super.toJSON();
      json["ocDataString"] = toOCDataString();
      //TODO eventually shove quirk and relationships into here
      return json;
    }

    void copyFromJSON(String jsonString) {
      super.copyFromJSON(jsonString);
      JSONObject json = new JSONObject.fromJSONString(jsonString);
      copyFromOCDataString(json["ocDataString"]);
    }

      String toDataBytes() {
        Map<String, dynamic> json = this.toJSONBrief(); //<-- gets me data in pre-compressed format.
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
        ////print(uint8View);
        for (num i = 0; i < uint8View.length; i++) {
            ret.writeCharCode(uint8View[i]); // += String.fromCharCode(uint8View[i]);
        }
        return Uri.encodeComponent(ret.toString()).replaceAll("#", '%23').replaceAll("&", '%26');
    }

    Map<String, dynamic> toJSONBrief() {
        num moonNum = 0;
        String cod = this.causeOfDrain;
        if (cod == null) cod = "";
        if (this.moon == session.prospit) moonNum = 1;
        Map<String, dynamic> json = <String, dynamic>{"aspect": this.aspect.id, "class_name": classNameToInt(this.class_name), "favoriteNumber": this.quirk.favoriteNumber, "hair": this.hair, "hairColor": hexColorToInt(this.hairColor), "isTroll": this.isTroll ? 1 : 0, "bloodColor": bloodColorToInt(this.bloodColor), "leftHorn": this.leftHorn, "rightHorn": this.rightHorn, "interest1Category": this.interest1.category.id, "interest2Category": this.interest2.category.id, "interest1": this.interest1.name, "interest2": this.interest2.name, "robot": this.robot ? 1 : 0, "moon": moonNum, "causeOfDrain": cod, "victimBlood": bloodColorToInt(this.victimBlood), "godTier": this.godTier ? 1 : 0, "isDreamSelf": this.isDreamSelf ? 1 : 0, "murderMode": this.murderMode ? 1 : 0, "leftMurderMode": this.leftMurderMode ? 1 : 0, "grimDark": this.grimDark, "causeOfDeath": this.causeOfDeath, "dead": this.dead ? 1 : 0, "godDestiny": this.godDestiny ? 1 : 0};
        return json;
    }

    @override
    String toString() {
        return title(); //no spaces.
    }

    void copyFromPlayer(Player replayPlayer) {
        ////print("copying from player who has a favorite number of: " + replayPlayer.quirk.favoriteNumber);
        ////;
        ////print(replayPlayer);
        session.logger.info("copying ${replayPlayer} to ${this}");
        this.aspect = replayPlayer.aspect;
        this.class_name = replayPlayer.class_name;
        this.hair = replayPlayer.hair;
        this.hairColor = replayPlayer.hairColor;
        this.isTroll = replayPlayer.isTroll;
        this.bloodColor = replayPlayer.bloodColor;
        this.leftHorn = replayPlayer.leftHorn;
        this.specibus = replayPlayer.specibus.copy();
        print("specibus is $specibus with traits ${specibus.traits}, required trait is ${specibus.requiredTrait}, the replay player has ${replayPlayer.specibus} with traits ${replayPlayer.specibus.traits} required trait is ${replayPlayer.specibus.requiredTrait}");
        this.rightHorn = replayPlayer.rightHorn;
        this.interest1 = replayPlayer.interest1;
        this.interest2 = replayPlayer.interest2;

        this.causeOfDrain = replayPlayer.causeOfDrain;
        this.causeOfDeath = replayPlayer.causeOfDeath;
        //print("TEST CUSTOM: replay player's chat handle is ${replayPlayer.chatHandle}");
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
        this.quirk.favoriteNumber = replayPlayer.quirk.favoriteNumber; //will get overridden, has to be after initialization, too, but if i don't do it here, char creartor will look wrong.
        this.makeGuardian();
        this.guardian.applyPossiblePsionics(); //now you have new psionics
    }

    static List<Player> processDataString(Session session, String dataString) {
        session.logger.info("TEST DATASTRINGS: going to get players with dataString $dataString, which hopefully wasn't blank.");

        if(session.prospit == null) session.setupMoons("getting replayers");
        session.logger.info("TEST DATASTRINGS: finished setting up moon");


        String params =  window.location.href.substring(window.location.href.indexOf("?") + 1);
        String base = window.location.href.replaceAll("?$params","");
        String bs = "${base}?" +dataString;

        String b = (getParameterByName("b", bs));
        String s = LZString.decompressFromEncodedURIComponent(Uri.encodeFull(getParameterByName("s", bs))); //these are NOT encoded in files, so make sure to encode them
        String x = (getParameterByName("x", bs));

        //;
        if (b == null || s == null) return <Player>[];
        if (b == "null" || s == "null") return <Player>[]; //why was this necesassry????????????????
        session.logger.info("TEST DATASTRINGS: going to get players with b of $b and s  of $s and x of $x");

        List<Player> ret =  dataBytesAndStringsToPlayers(session,b, s, x);
        session.logger.info("TEST DATASTRINGS: got players, just need to process a bit");

        //can't let them keep their null session reference.

        for(Player p in ret) {
            p.session = session;
            p.syncToSessionMoon();
            p.initialize();
        }
        session.logger.info("TEST DATASTRINGS: done processing data strings");
    }

    void initialize() {
        handleSubAspects();
        this.initializeStats();
        this.initializeSprite();
        if(deriveSpecibus) this.specibus = SpecibusFactory.getRandomSpecibus(session.rand);
        this.initializeDerivedStuff();
    }

    void handleSubAspects() {
        if(aspect is AspectWithSubAspects) {
            AspectWithSubAspects subAspectedAspect = aspect as AspectWithSubAspects;
            print ("handling sub aspects for ${title()} with subaspects ${subAspectedAspect.subAspects}");

            if(subAspectedAspect.subAspects == null) {
                (aspect as AspectWithSubAspects).setSubAspectsFromPlayer(this);
            }
        }
    }

    void resetFlags() {
        deriveLand = true;
        scenesToAdd.clear();
        deriveChatHandle = true;
        addedSerializableScenes = false;
    }

    void initializeDerivedStuff() {
        populateInventory();
        populateAi();

        if(deriveLand) land = spawnLand();

        if (this.deriveChatHandle) this.chatHandle = getRandomChatHandle(this.session.rand, this.class_name, this.aspect, this.interest1, this.interest2);
        this.mylevels = getLevelArray(this); //make them ahead of time for echeladder graphic

        if (this.isTroll) {
            if (this.quirk == null) this.quirk = randomTrollSim(this.session.rand, this); //if i already have a quirk it was defined already. don't override it.;
            this.addStat(Stats.SANITY, -10); //trolls are slightly less stable

        } else {
            if (this.quirk == null) this.quirk = randomHumanSim(this.session.rand, this);
        }
        moonChance += session.rand.nextDouble() * -33; //different amount of time pre-game start to get in. (can still wake up before entry)
        if(aspect.isThisMe(Aspects.SPACE)) moonChance += 33.0; //huge chance for space players.
        if(aspect.isThisMe( Aspects.DOOM)) prophecy = ProphecyState.ACTIVE; //sorry doom players
        specibus.modMaxUpgrades(this);
    }

    void populateAi() {
        //as long as i add them before the first scene, they should show up
        //ANYTHING you alerady know should be cleared (hopefully this doesn't fuck over the session creator)
        scenesToAdd.clear();
        serializableSceneStrings.clear();
        for(Scene scene in scenes) {
            if(scene is SerializableScene) {
                scenesToRemove.add(scene);
            }
        }
        handleRemovingScenes();
        print("AIDEBUG: I'm $name and I'm populating my ai. My aspect, ${aspect} has ${aspect.associatedScenes.length} scenes. I already have ${scenesToAdd} added Scenes, and my scenes are $scenes");
        for(String s in aspect.associatedScenes) {
            serializableSceneStrings.add(s);
        }
        for(String s in class_name.associatedScenes) {
            serializableSceneStrings.add(s);
        }
    }

    void populateInventory() {
        sylladex.clear();
        sylladex.add(session.rand.pickFrom(interest1.category.items));
        sylladex.add(session.rand.pickFrom(interest2.category.items));
        //testing something
       // sylladex.add(new Item("Dr Pepper BBQ Sauce",<ItemTrait>[ItemTraitFactory.POISON],shogunDesc: "Culinary Perfection",abDesc:"Gross."));

    }

    //I mark the source of the themes here, where i'm using them, rather than on creation
    //need the source for QuestChains (want first quest to be interest related, second aspect, third class) <-- important
    Land spawnLand([Map<Theme, double> extraThemes]) {
        Map<Theme, double> themes = new Map<Theme, double>();
        if(extraThemes != null) themes = new Map<Theme, double>.from(extraThemes);
        Theme classTheme = session.rand.pickFrom(class_name.themes.keys);
        classTheme.source = Theme.CLASSSOURCE;
        Theme aspectTheme = session.rand.pickFrom(aspect.themes.keys);
        aspectTheme.source = Theme.ASPECTSOURCE;
        Theme interest1Theme = session.rand.pickFrom(interest1.category.themes.keys);
        interest1Theme.source = Theme.INTERESTSOURCE;
        Theme interest2Theme = session.rand.pickFrom(interest2.category.themes.keys);
        interest2Theme.source = Theme.INTERESTSOURCE;

        //the weight is the same weight it had in it's source
        themes[classTheme] = class_name.themes[classTheme];
        themes[aspectTheme] = aspect.themes[aspectTheme];
        themes[interest1Theme] = interest1.category.themes[interest1Theme];
        themes[interest2Theme] = interest2.category.themes[interest2Theme];
        Land l =  new Land.fromWeightedThemes(themes, session, aspect,class_name);
        l.associatedEntities.add(this);
        return l;

    }

    void initializeSprite() {
        if(object_to_prototype == null) {
            object_to_prototype =  session.rand.pickFrom(PotentialSprite.prototyping_objects);
        }
        this.sprite = new Sprite("sprite", session); //unprototyped.
        //minLuck, maxLuck, hp, mobility, triggerLevel, freeWill, power, abscondable, canAbscond, framotifs, grist
        this.sprite.stats.setMap(<Stat, num>{Stats.HEALTH: 10, Stats.CURRENT_HEALTH: 10}); //same as denizen minion, but empty power
        this.sprite.doomed = true;
    }

    bool canHelp() {
        return godTier || isDreamSelf || land == null || land.firstCompleted || (aspect.isThisMe(Aspects.BREATH) && hasPowers()) ;
    }

    bool canGodTierSomeWay() {
        if(isDreamSelf) return hasMoon();
        return hasLand();
    }

    bool hasLand() {
        return land != null && !land.dead;
    }

    bool hasMoon() {
        return moon != null && !moon.dead;
    }

    ///not static because who can help me varies based on who i am (space is knight, for example)
    ///no longer inside a scene because multiple scenes need a consistent result from this
     Player findHelper(List<Player> players) {
        Player helper;
        if(session.mutator.lightField) return session.mutator.inSpotLight;
         //space player can ONLY be helped by knight, and knight prioritizes this
         if(aspect.isThisMe(Aspects.SPACE)){//this shit is so illegal
             helper = findClassPlayer(players, SBURBClassManager.KNIGHT);
             //can help others 100% of the time if foreign player. you can like, fly and shit with your end game items.
             if(helper != null && helper.id != this.id && (helper.canHelp())){ //a knight of space can't help themselves.
                 ////;
                 //;
                 return helper;
             }else{
                helper = null; //clear the helper out or knights of space are gonna be op as fuck. they were storing that if there were no sorted choices.
                 return null;
             }
         }
        //time players often partner up with themselves
        if(aspect.isThisMe(Aspects.TIME) && rand.nextDouble() > .2){
            ////;
            //;

            return this;
        }
        //;
        //players are naturally sorted by mobility
        List<Player> sortedChoices = new List<Player>.from(players)..sort(Stats.MOBILITY.sorter);
        for(Player p in sortedChoices) {
            if(rand.nextDouble() > 0.75 && p.id != this.id) {
                //space players are stuck on their land till they get their frog together.
                if((p.aspect != Aspects.SPACE || p.landLevel > session.goodFrogLevel)  && p.canHelp()) {
                    helper = p;
                    //;
                }
            }else if(((p.class_name == SBURBClassManager.PAGE || p.aspect.isThisMe(Aspects.BLOOD)) && p.id != this.id) && p.canHelp()) { //these are GUARANTEED to have helpers. not part of a big stupid if though in case i want to make it just higher odds l8r
                helper = p;
               // ;
            }
        }
        //;

        //could be null, not 100% chance of helper
        ////;
        return helper;
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
            if (stat.multiplier >= 3) return "SO ${stat.stat.emphaticDescriptor(this).toUpperCase()}";
        }
        return "SO BLAND";
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
        if (stat.stat == Stats.RELATIONSHIPS) {
            for (num i = 0; i < this.relationships.length; i++) {
                this.relationships[i].value += (modValue / this.relationships.length) * stat.multiplier * stat.stat.associatedGrowth; //stop having relationship values on the scale of 100000
            }
        } else {
            //don't lower health below 1. if i can't do it in stats itself for now, do it here.
            if(stat.stat != Stats.HEALTH || (stat.stat == Stats.HEALTH && getStat(Stats.HEALTH) >1)) {
                this.addStat(stat.stat, modValue * stat.multiplier * stat.stat.associatedGrowth);
            }
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
        //initStatHolder();
        if (this.trickster && this.aspect.ultimateDeadpan) this.trickster == false; //doom players break rules
        if(trickster) {
            this.addBuff(new BuffTricksterMode(), name:"trickster", source:this);
            landLevel = 11111111111.0;
            grist = 11111111111;
        }
        this.associatedStats = <AssociatedStat>[]; //this might be called multiple times, wipe yourself out.
        this.aspect.initAssociatedStats(this);
        this.class_name.initAssociatedStats(this);
        this.setStat(Stats.SBURB_LORE,0); //all start ignorant.
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
            if(deriveSprite) this.object_to_prototype = this.session.rand.pickFrom(PotentialSprite.disastor_objects);
            this.object_to_prototype.session = session;
            ////;
        } else if (luck > 25) {
            if(deriveSprite) this.object_to_prototype = this.session.rand.pickFrom(PotentialSprite.fortune_objects);
            this.object_to_prototype.session = session;
            ////;
        }
        if (luck > 5) {
            this.godDestiny = true;
        }
        this.setStat(Stats.CURRENT_HEALTH, getStat(Stats.HEALTH)); //could have been altered by associated stats

        if (this.class_name == SBURBClassManager.WASTE) {
            Fraymotif f = new Fraymotif("Rocks Fall, Everyone Dies", 1); //what better fraymotif for an Author to start with. Too bad it sucks.  If ONLY there were some way to hax0r SBURB???;
            f.effects.add(new FraymotifEffect(Stats.POWER, 3, true));
            f.desc = "Disappointingly sized meteors rain down from above.  Man, for such a cool name, this fraymotif kind of sucks. ";
            this.fraymotifs.add(f);
        } else if (this.class_name == SBURBClassManager.NULL) {
            {
                Fraymotif f = new Fraymotif("What class???", 1);
                f.effects.add(new FraymotifEffect(Stats.POWER, 1, true));
                f.desc = " I am certain there is not a class here and it is laughable to imply otherwise. ";
                this.fraymotifs.add(f);
            }

            {
                Fraymotif f = new Fraymotif("Nulzilla", 2);
                f.effects.add(new FraymotifEffect(Stats.POWER, 1, true));
                f.desc = " If you get this reference, you may reward yourself 15 Good Taste In Media Points (tm).  ";
                this.fraymotifs.add(f);
            }
        }
        //;
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
    static Player makeRenderingSnapshot(Player player, [bool saveCanvas = true]) {
        Player ret = new Player(player.session, player.class_name, player.aspect, player.object_to_prototype, player.moon, player.godDestiny);
        ret.robot = player.robot;
        ret.specibus = player.specibus.copy();
        ret.gnosis = player.gnosis;
        ret.doomed = player.doomed;
        ret.ghost = player.ghost;
        ret.brainGhost = player.brainGhost;
        ret.causeOfDrain = player.causeOfDrain;
        ret.session = player.session;
        ret.id = player.id;
        ret.mylevels = player.mylevels;
        ret.level_index = player.level_index;
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
        ret.isDreamSelf = player.isDreamSelf;
        ret.hair = player.hair;
        ret.bloodColor = player.bloodColor;
        ret.hairColor = player.hairColor;
        ret.chatHandle = player.chatHandle;
        ret.leftHorn = player.leftHorn;
        ret.rightHorn = player.rightHorn;
        ret.quirk = player.quirk;
        ret.baby = player.baby;
        ret.causeOfDeath = player.causeOfDeath;
        ret.session = player.session; //session is non negotiable.
        ret.interest1 = player.interest1;
        ret.interest2 = player.interest2;
        ret.stats = player;
        ret.dreamPalette = player.dreamPalette;
        //;
        if(saveCanvas && player.canvas != null) {
            ret.canvas = player.canvas; //you're just for rendering
        }else if(!saveCanvas) {
           // ;
            ret.canvas = null; //re render yourself. you're a ghost or a doomed time clone or some shit
        }
        return ret;
    }


    //TODO has specific 'doomed time clone' stuff in it, like randomizing state
    static Player makeDoomedSnapshot(Player doomedPlayer) {
        Session session = doomedPlayer.session;
        Player timeClone = Player.makeRenderingSnapshot(doomedPlayer,false);
        timeClone.dead = false;
        timeClone.ectoBiologicalSource = -612; //if they somehow become players, you dn't make babies of them.
        timeClone.prophecy = ProphecyState.ACTIVE;
        timeClone.setStat(Stats.CURRENT_HEALTH, doomedPlayer.getStat(Stats.HEALTH)); //heal
        timeClone.doomed = true;
        //from a different timeline, things went differently.
        double r = doomedPlayer.rand.nextDouble();
        timeClone.setStat(Stats.POWER, doomedPlayer.session.rand.nextDouble() * 80 + 10);
        if (r > 0.9) {
            timeClone.robot = true;
            timeClone.hairColor = getRandomGreyColor();
        } else if (r > .8) {
            timeClone.godTier = !timeClone.godTier;
            if (timeClone.godTier) {
                timeClone.setStat(Stats.POWER, 200); //act like a god, damn it.
            }
        } else if (r > .6) {
            timeClone.isDreamSelf = !timeClone.isDreamSelf;
        } else if (r > .4) {
            timeClone.grimDark = doomedPlayer.session.rand.nextIntRange(0, 4);
            timeClone.addStat(Stats.POWER, 50 * timeClone.grimDark);
        } else if (r > .2) {
            timeClone.murderMode = !timeClone.murderMode;
        }

        if (timeClone.grimDark > 3) {
            Fraymotif f = new Fraymotif(Zalgo.generate("The Broodfester Tongues"), 3);
            f.effects.add(new FraymotifEffect(Stats.POWER, 3, true));
            f.effects.add(new FraymotifEffect(Stats.POWER, 0, false));
            f.desc = " They are stubborn throes. ";
            timeClone.fraymotifs.add(f);
        }

        if (timeClone.godTier) {
            Fraymotif f = session.fraymotifCreator.makeFraymotif(doomedPlayer.rand, <Player>[doomedPlayer], 3); //first god tier fraymotif
            timeClone.fraymotifs.add(f);
        }

        if (timeClone.getStat(Stats.POWER) > 50) {
            Fraymotif f = session.fraymotifCreator.makeFraymotif(doomedPlayer.rand, <Player>[doomedPlayer], 2); //probably beat denizen at least
            timeClone.fraymotifs.add(f);
        }

        Fraymotif f = session.fraymotifCreator.makeFraymotif(doomedPlayer.rand, <Player>[doomedPlayer], 1); //at least did first quest
        timeClone.fraymotifs.add(f);
        timeClone.renderSelf("doomed time clone");

        return timeClone;
    }

}