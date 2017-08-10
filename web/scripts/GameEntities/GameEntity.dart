import "dart:html";
import "dart:math" as Math;
import "../SBURBSim.dart";

//fully replacing old GameEntity that was also an unholy combo of strife engine
//not abstract, COULD spawn just a generic game entity.
class GameEntity implements Comparable<GameEntity> {
    static int _nextID = 0;

    //TODO figure out how i want tier 2 sprites to work. prototyping with a carapace and then a  player and then god tiering should result in a god tier Player that can use the Royalty's Items.
    Session session;

    //TODO replace 'minLuck' with 'destiny'
    String name = "";
    //TODO the next few stats are for sprites but since ANY living thing can become a sprite...

    String helpPhrase = "provides the requisite amount of gigglesnort hideytalk to be juuuust barely helpful. ";
    num helpfulness = 0;
    bool armless = false;
    bool disaster = false;
    bool lusus = false; //HAVE to be vars or can't inherit through prototyping.
    bool player = false;
    bool illegal = false; //maybe AR won't help players with ILLEGAL sprites?
    //
    String fontColor = "#000000";
    bool ghost = false; //if you are ghost, you are rendered spoopy style
    num grist = 100; //everything has it.
    bool dead = false;
    String causeOfDrain = null; //if it's ever not null they will be sideways
    bool exiled = false;
    List<GhostPact> ghostPacts = <GhostPact>[]; //list of two element array [Ghost, enablingAspect]
    bool corrupted = false; //players are corrupted at level 4. will be easier than always checking grimDark level
    List<Fraymotif> fraymotifs = <Fraymotif>[];
    bool usedFraymotifThisTurn = false;
    List<Buff> buffs = <Buff>[]; //only used in strifes, array of BuffStats (from fraymotifs and eventually weapons)
    Map<String, num> stats = <String, num>{};
    List<Relationship> relationships = <Relationship>[]; //not to be confused with the RELATIONSHIPS stat which is the value of all relationships.
    Map<String, num> permaBuffs = <String, num>{ "MANGRIT": 0}; //is an object so it looks like a player with stats.  for things like manGrit which are permanent buffs to power (because modding power directly is confusing since it's also 'level')
    num renderingType = 0; //0 means default for this sim.
    List<AssociatedStat> associatedStats = <AssociatedStat>[]; //most players will have a 2x, a 1x and a -1x stat.
    String spriteCanvasID = null; //part of new rendering engine.
    num id;
    bool doomed = false; //if you are doomed, no matter what you are, you are likely to die.
    List<Player> doomedTimeClones = <Player>[]; //help fight the final boss(es).
    String causeOfDeath = ""; //fill in every time you die. only matters if you're dead at end
    GameEntity crowned = null; //TODO figure out how this should work. for now, crowns count as Game Entities, but should be an Item eventually (and should be able to have multiple crowns)

    GameEntity(this.name, this.session) {
        id = GameEntity.generateID();
        stats['sanity'] = 0;
        stats['alchemy'] = 0;
        stats['currentHP'] = 0;
        stats['hp'] = 0;
        stats['RELATIONSHIPS'] = 0;
        stats['minLuck'] = 0;
        stats['maxLuck'] = 0;
        stats['freeWill'] = 0;
        stats['mobility'] = 0;
        stats['power'] = 0; //power is generic sign of level.
    }

    //TODO grab out every method that current gameEntity, Player and PlayerSnapshot are required to have.
    //TODO make sure Player's @overide them.

    @override
    String toString() {
        return this.htmlTitle().replaceAll(new RegExp(r"\s", multiLine: true), '').replaceAll(new RegExp(r"'", multiLine: true), ''); //no spces probably trying to use this for a div
    }

    void addPrototyping(GameEntity object) {
        this.name = "${object.name}${this.name}"; //sprite becomes puppetsprite.
        this.fraymotifs.addAll(object.fraymotifs);
        if (object.fraymotifs.isEmpty) {
            Fraymotif f = new Fraymotif(<String>[], "${object.name}Sprite Beam!", 1);
            f.effects.add(new FraymotifEffect("power", 2, true)); //do damage
            f.effects.add(new FraymotifEffect("hp", 1, true)); //heal
            f.flavorText = " An appropriately themed beam of light damages enemies and heals allies. ";
            this.fraymotifs.add(f);
        }
        this.corrupted = object.corrupted;
        if (this is Sprite && object is PotentialSprite) {
            Sprite s = this;
            PotentialSprite ps = object;
            s.helpfulness = ps.helpfulness; //completely overridden.
            s.helpPhrase = ps.helpPhrase;
            s.grist += ps.grist;
            s.lusus = ps.lusus;
            s.illegal = ps.illegal;
            s.player = ps.player;
        }
        for (String key in object.stats.keys) {
            addStat(key, object.stats[key]); //add your stats to my stas.
        }
    }


    //handles cloning generic stuff important because it's how a PLayer becomes a GameEntity (such as a PLayerSprite)
    GameEntity clone () {
        GameEntity clonege = new GameEntity(name, session);
        copyStatsTo(clonege);
        return clonege;
    }

    void copyStatsTo(GameEntity clonege) {
        clonege.setStatsHash(stats);
        clonege.fontColor = fontColor;
        clonege.ghost = ghost; //if you are ghost, you are rendered spoopy style
        clonege.grist = grist; //everything has it.
        clonege.dead = dead;
        clonege.ghostPacts = ghostPacts; //list of two element array [Ghost, enablingAspect]
        clonege.corrupted = corrupted; //players are corrupted at level 4. will be easier than always checking grimDark level
        clonege.fraymotifs = fraymotifs; //TODO should these be cloned, too?
        clonege.usedFraymotifThisTurn = usedFraymotifThisTurn;
        clonege.buffs = buffs; //only used in strifes, array of BuffStats (from fraymotifs and eventually weapons)
        clonege.relationships = Relationship.cloneRelationshipsStopgap(relationships);
        clonege.permaBuffs = permaBuffs; //is an object so it looks like a player with stats.  for things like manGrit which are permanent buffs to power (because modding power directly gets OP as shit because power controls future power)
        clonege.renderingType = renderingType; //0 means default for this sim.
        clonege.associatedStats = associatedStats; //most players will have a 2x, a 1x and a -1x stat.
        clonege.spriteCanvasID = spriteCanvasID; //part of new rendering engine.
        clonege.doomed = doomed; //if you are doomed, no matter what you are, you are likely to die.
        clonege.doomedTimeClones = doomedTimeClones; //TODO should these be cloned? help fight the final boss(es).
        clonege.causeOfDeath = causeOfDeath; //fill in every time you die. only matters if you're dead at end
        clonege.crowned = crowned; //TODO figure out how this should work. for now, crowns count as Game Entities, but should be an Item eventually
    }

    //as each type of entity gets renderable, override this.
    bool renderable() {
        return false;
    }

    //naturally sorted by mobility
    @override
    int compareTo(GameEntity other) {
        return other.getStat("mobility") - getStat("mobility"); //TODO or is it the otherway around???
    }

    String checkDiedInAStrife(List<Team> enemyTeams) {
        if (getStat("currentHP") <= 0) {
            //TODO check for jack, king
            GameEntity jack = Team.findJackInTeams(enemyTeams);
            GameEntity king = Team.findKingInTeams(enemyTeams);
            String causeOfDeath = "fighting in a strife against ${Team.getTeamsNames(enemyTeams)}";
            if (jack != null) {
                causeOfDeath = "after being shown too many stabs from Jack";
            } else if (king != null) {
                causeOfDeath = "fighting the Black King";
            }
            makeDead(causeOfDeath);
            return "${htmlTitleHP()} has died. ";
        }
        return "";
    }

    void resetFraymotifs() {
        for (num i = 0; i < this.fraymotifs.length; i++) {
            this.fraymotifs[i].usable = true;
        }
    }

    //any subclass can choose to do things differently. for now, this is default.
    //so yes, npcs can have ghost attacks.
    //this won't be called if I CAN'T take a turn because i participated in fraymotif
    void takeTurn(Element div, Team mySide, List<Team> enemyTeams) {
        if (usedFraymotifThisTurn) return; //already did an attack.
        if (mySide.absconded.contains(this)) return;
        //if still dead, return, can't do anything.
        if (dead) {
            reviveViaGhostPact(div);
            //whether it works or not, return. you can't revive AND do other stuff.
            return;
        }
        appendHtml(div, describeBuffs());
        if (checkAbscond(div, mySide, enemyTeams)) return; //nice abscond, bro

        //pick a team to target.  if cant find target, return
        Team targetTeam = pickATeamToTarget(enemyTeams);
        if (targetTeam == null) return; //nobody to fight.
        //pick a member of the team to extra target. ig player and light, even if corpse
        GameEntity target = pickATarget(targetTeam.getLivingMinusAbsconded());
        if (target == null) return; //nobody to attack.
        //try to use fraymotif
        if (!useFraymotif(div, mySide, target, targetTeam)) {
            aggrieve(div, target);
        }
        //last thing you do is die.
        mySide.checkForAPulse(div, enemyTeams);
        List<Team> allTeams = new List<Team>.from(enemyTeams);
        allTeams.add(mySide);
        for (Team team in enemyTeams) {
            team.checkForAPulse(div, team.getOtherTeams(allTeams));
        }
    }

    bool useFraymotif(Element div, Team mySide, GameEntity target, Team targetTeam) {
        List<GameEntity> living_enemies = targetTeam.getLivingMinusAbsconded();
        List<GameEntity> living_allies = mySide.getLivingMinusAbsconded();
        if (this.session.rand.nextDouble() > 0.5) return false; //don't use them all at once, dunkass.
        List<Fraymotif> usableFraymotifs = this.session.fraymotifCreator.getUsableFraymotifs(this, living_allies, living_enemies);
        if (crowned != null) { //ring/scepter has fraymotifs, too.  (maybe shouldn't let humans get thefraymotifs but what the fuck ever. roxyc could do voidy shit.)
            usableFraymotifs.addAll(this.session.fraymotifCreator.getUsableFraymotifs(crowned, living_allies, living_enemies));
        }
        if (usableFraymotifs.isEmpty) return false;
        num mine = getStat("sanity");
        num theirs = getAverageSanity(living_enemies);
        if (mine + 200 < theirs && this.session.rand.nextDouble() < 0.5) {
            print("Too insane to use fraymotifs: ${htmlTitleHP()} against ${target.htmlTitleHP()} Mine: $mine Theirs: $theirs in session: ${this.session.session_id}");
            appendHtml(div, " The ${htmlTitleHP()} wants to use a Fraymotif, but they are too crazy to focus. ");
            return false;
        }
        mine = getStat("freeWill");
        theirs = getAverageFreeWill(living_enemies);
        if (mine + 200 < theirs && this.session.rand.nextDouble() < 0.5) {
            print("Too controlled to use fraymotifs: ${htmlTitleHP()} against ${target.htmlTitleHP()} Mine: $mine Theirs: $theirs in session: ${this.session.session_id}");
            appendHtml(div, " The ${htmlTitleHP()} wants to use a Fraymotif, but Fate dictates otherwise. ");
            return false;
        }

        Fraymotif chosen = usableFraymotifs[0];
        for (num i = 0; i < usableFraymotifs.length; i++) {
            Fraymotif f = usableFraymotifs[i];
            if (f.tier > chosen.tier) {
                chosen = f; //more stronger is more better (refance)
            } else if (f.tier == chosen.tier && f.aspects.length > chosen.aspects.length) {
                chosen = f; //all else equal, prefer the one with more members.
            }
        }
        appendHtml(div, "<Br><br>${chosen.useFraymotif(this, living_allies, target, living_enemies)}<br><Br>");
        chosen.usable = false;
        return true;
    }

    bool checkAbscond(Element div, Team mySide, List<Team> enemies) {
        if (!mySide.canAbscond) return false; //can't abscond, bro
        if (doomed) return false; //accept your fate.
        List<GameEntity> whoINeedToProtect = mySide.getLivingMinusAbsconded();
        num reasonsToLeave = 0;
        num reasonsToStay = 2; //generally prefer to win fights.
        reasonsToStay += getFriendsFromList(whoINeedToProtect).length;
        List<Relationship> hearts = getHearts();
        List<Relationship> diamonds = getDiamonds();
        for (Relationship heart in hearts) {
            if (whoINeedToProtect.contains(heart.target)) reasonsToStay += 1;
        }

        for (Relationship diamond in diamonds) {
            if (whoINeedToProtect.contains(diamond.target)) reasonsToStay += 1;
        }
        reasonsToStay += getStat("power") / Team.getTeamsStatTotal(enemies, "currentHP"); //i can take you.
        reasonsToLeave += Team.getTeamsStatTotal(enemies, "power") / getStat("currentHP"); //you can take me.
        if (reasonsToLeave > reasonsToStay * 2) {
            addStat("sanity", -10);
            flipOut("how terrifying ${Team.getTeamsNames(enemies)} were");
            if (getStat("mobility") > Team.getTeamsStatAverage(enemies, "mobility")) {
                //console.log(" player actually absconds: they had " + player.hp + " and enemy had " + enemy.getStat("power") + this.session.session_id)
                appendHtml(div, "<br><img src = 'images/sceneIcons/abscond_icon.png'> The ${htmlTitleHP()} absconds right the fuck out of this fight.");
                mySide.absconded.add(this);
                mySide.remainingPlayersHateYou(div, this);
                return true;
            } else {
                appendHtml(div, " The ${htmlTitleHP()} tries to absconds right the fuck out of this fight, but the ${Team.getTeamsNames(enemies)} blocks them. Can't abscond, bro. ");
                return false;
            }
        } else if (reasonsToLeave > reasonsToStay) {
            if (getStat("mobility") > Team.getTeamsStatAverage(enemies, "mobility")) {
                //console.log(" player actually absconds: " + this.session.session_id)
                appendHtml(div, "<br><img src = 'images/sceneIcons/abscond_icon.png'>  Shit. The ${htmlTitleHP()} doesn't know what to do. They don't want to die... They abscond. ");
                mySide.absconded.add(this);
                mySide.remainingPlayersHateYou(div, this);
                return true;
            } else {
                appendHtml(div, " Shit. The ${htmlTitleHP()} doesn't know what to do. They don't want to die... Before they can decide whether or not to abscond ${Team.getTeamsNames(enemies)} blocks their escape route. Can't abscond, bro. ");
                return false;
            }
        }
        return false;
    }

    void aggrieve(Element div, GameEntity defense) {
        GameEntity offense = this; //easier for now.
        String ret = "<br><Br> The ${offense.htmlTitleHP()} targets the ${defense.htmlTitleHP()}. ";
        if (defense.dead) ret = "$ret Apparently their corpse sure is distracting? How luuuuuuuucky for the remaining players!";
        appendHtml(div, ret);

        //luck dodge
        //alert("offense roll is: " + offenseRoll + " and defense roll is: " + defenseRoll);
        //print("gonna roll for luck.");
        if (defense.rollForLuck("minLuck") > offense.rollForLuck("minLuck") * 10 + 200) { //adding 10 to try to keep it happening constantly at low levels
            print("Luck counter: ${defense.htmlTitleHP()} ${this.session.session_id}");
            appendHtml(div, "The attack backfires and causes unlucky damage. The ${defense.htmlTitleHP()} sure is lucky!!!!!!!!");
            offense.addStat("currentHP", -1 * offense.getStat("power") / 10); //damaged by your own power.
            //this.processDeaths(div, offense, defense);
            return;
        } else if (defense.rollForLuck("maxLuck") > offense.rollForLuck("maxLuck") * 5 + 100) {
            print("Luck dodge: ${defense.htmlTitleHP()} ${this.session.session_id}");
            appendHtml(div, "The attack misses completely after an unlucky distraction.");
            return;
        }
        //mobility dodge
        int r = this.session.rand.nextIntRange(1, 100); //don't dodge EVERY time. oh god, infinite boss fights. on average, fumble a dodge every 4 turns.;
        if (defense.getStat("mobility") > offense.getStat("mobility") * 10 + 200 && r > 25) {
            print("Mobility counter: ${defense.htmlTitleHP()} ${this.session.session_id}");
            ret = ("The ${offense.htmlTitleHP()} practically appears to be standing still as they clumsily lunge towards the ${defense.htmlTitleHP()}");
            if (defense.getStat("currentHP") > 0) {
                ret = "$ret. They miss so hard the ${defense.htmlTitleHP()} has plenty of time to get a counterattack in.";
                offense.addStat("currentHP", -1 * defense.getStat("power"));
            } else {
                ret = "$ret. They miss pretty damn hard. ";
            }
            appendHtml(div, "$ret ");
            //this.processDeaths(div, offense, defense);

            return;
        } else if (defense.getStat("mobility") > offense.getStat("mobility") * 5 + 100 && r > 25) {
            print("Mobility dodge: ${defense.htmlTitleHP()} ${this.session.session_id}");
            appendHtml(div, " The ${defense.htmlTitleHP()} dodges the attack completely. ");
            return;
        }
        //base damage
        num hit = Math.max(1,offense.getStat("power"));
        num offenseRoll = offense.rollForLuck("");
        num defenseRoll = defense.rollForLuck("");
        //critical/glancing hit odds.
        if (defenseRoll > offenseRoll * 2) { //glancing blow.
            //print("Glancing Hit: " + this.session.session_id);
            hit = hit / 2;
            appendHtml(div, " The attack manages to not hit anything too vital. ");
        } else if (offenseRoll > defenseRoll * 2) {
            //print("Critical hit.");
            ////print("Critical Hit: " + this.session.session_id);
            hit = hit * 2;
            appendHtml(div, " Ouch. That's gonna leave a mark. ");
        } else {
            //print("a hit.");
            appendHtml(div, " A hit! ");
        }


        defense.addStat("currentHP", -1 * hit);
        //this.processDeaths(div, offense, defense);
    }


    //currently only thing ghost pacts are good for post refactor.
    void reviveViaGhostPact(Element div) {
        List<dynamic> undrainedPacts = removeDrainedGhostsFromPacts(ghostPacts);
        if (!undrainedPacts.isEmpty) {
            print("using a pact to autorevive in session ${this.session.session_id}");
            Player source = undrainedPacts[0][0];
            source.causeOfDrain = name;
            String ret = " In the afterlife, the ${htmlTitleBasic()} reminds the ${source.htmlTitleBasic()} of their promise of aid. The ghost agrees to donate their life force to return the ${htmlTitleBasic()} to life ";
            if (this is Player) {
                Player me = this;
                if (me.godTier) ret = "$ret, but not before a lot of grumbling and arguing about how the pact shouldn't even be VALID anymore since the player is fucking GODTIER, they are going to revive fucking ANYWAY. But yeah, MAYBE it'd be judged HEROIC or some shit. Fine, they agree to go into a ghost coma or whatever. ";
            }
            ret = "${ret}It will be a while before the ghost recovers.";
            appendHtml(div, ret);
            Player myGhost = this.session.afterLife.findClosesToRealSelf(this);
            removeFromArray(myGhost, this.session.afterLife.ghosts);
            // CanvasElement canvas = drawReviveDead(div, this, source, undrainedPacts[0][1]);
            makeAlive();
            if (undrainedPacts[0][1] == "Life") {
                addStat("currentHP", 100); //i won't let you die again.
            } else if (undrainedPacts[0][1] == "Doom") {
                addStat("minLuck", 100); //you've fulfilled the prophecy. you are no longer doomed.
                div.appendHtml("The prophecy is fulfilled. ", treeSanitizer: NodeTreeSanitizer.trusted);
            }
        }
    }

    Team pickATeamToTarget(List<Team> team) {
        //TODO later add actual AI to this but for now, should only be one other team.
        return this.session.rand.pickFrom(team);
    }

    GameEntity pickATarget(List<GameEntity> targets) {
        if (targets.isEmpty) return null;
        if (targets.length == 1) return targets[0];
        targets.sort(); //as long as I always prefer new targets of equal juciness, will target slowest people preferentially.
        List<num> ratings = new List<num>();
        for (GameEntity t in targets) {
            num r = 0;
            if (t.getStat("currentHP") < getStat("power")) r += 1; //i can kill you in one hit.
            if (t is Player) {
                Player p = t;
                if (p.aspect == "Void") r += -1; //hard to see
                if (p.aspect == "Light") r += 1; //easy to see
            }
            //print("Added rating of $r to $t");
            ratings.add(r);
        }
        GameEntity ret;
        num chosen_rating = 0;
        for (num i = 0; i < targets.length; i++) {
            GameEntity checked = targets[i];
            num checked_rating = ratings[i];
            if (checked_rating >= chosen_rating) {
                //print("found a better target");
                chosen_rating = checked_rating;
                ret = checked; //equal, because want LAST thing in list to be preffered if all things equal since slowest.
            }
        }
        return ret;
    }

    void changeGrimDark(num val) {
        //stubb
    }

    void increasePower() {
        //stub for sprites, and maybe later consorts or carapcians
    }

    double getTotalBuffForStat(String statName) {
        double ret = 0.0;
        for (int i = 0; i < this.buffs.length; i++) {
            Buff b = this.buffs[i];
            if (b.name == statName) ret += b.value;
        }
        return ret;
    }

    String humanWordForBuffNamed(String statName) {
        if (statName == "MANGRIT") return "powerful";
        if (statName == "hp") return "sturdy";
        if (statName == "currentHP") return "sturdy";
        if (statName == "RELATIONSHIPS") return "friendly";
        if (statName == "mobility") return "fast";
        if (statName == "sanity") return "calm";
        if (statName == "freeWill") return "willful";
        if (statName == "power") return "powerful"; //should never buff this directly, just use MANGRIT
        if (statName == "maxLuck") return "lucky";
        if (statName == "minLuck") return "lucky";
        if (statName == "alchemy") return "creative";
        print("what the hell kind of stat name is: $statName");
        return "glitchy";
    }

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
        return "${this.htmlTitleHP()} is feeling ${turnArrayIntoHumanSentence(ret)} than normal. ";
    }

    void modifyAssociatedStat(num modValue, AssociatedStat stat) {
        //modValue * stat.multiplier.
        print("Modify associated stat $stat on $this by $modValue");
        if (stat.name == "RELATIONSHIPS") {
            for (num i = 0; i < this.relationships.length; i++) {
                this.relationships[i].value += modValue * stat.multiplier;
            }
        } else {
            this.addStat(stat.name, modValue * stat.multiplier); // I hope this isn't doing something totally wonky -PL
        }
    }

    num getStat(String statName) {
        if (statName == "MANGRIT") statName = "power"; //fraymotifs can try to get it directly
        num ret = this.stats[statName];
        if (ret == null) throw "What Kind of Stat is: $statName???";
        for (int i = 0; i < this.buffs.length; i++) {
            Buff b = this.buffs[i];
            if (b.name == statName) ret += b.value;
        }

        if (statName == "power") {
            //print("$this before mangrit, ret is: $ret, mangrit is ${this.permaBuffs["MANGRIT"]} ");
            ret += this.permaBuffs["MANGRIT"]; //needed because if i mod power directly, it effects all future progress in an unbalanced way.;
            ret = Math.max(0, ret); //no negative power, dunkass.
           // print("$this after mangrit, ret is $ret");
        }

        return (ret).round();
    }

    //sets current hp to max hp. mostly called after strifes assuming you'll use healing items
    void heal() {
        setStat("currentHP", getStat("hp"));
    }

    void setStat(String statName, num value) {
        if (this.stats[statName] == null) throw("I have never heard of a stat called: $statName");
        this.stats[statName] = value;
    }

    void addStat(String statName, num value) {
        if(statName == "MANGRIT") {
          this.permaBuffs[statName] += value;
          return;
        }
        //if(statName == "power") print("$this boost power from ${this.stats[statName]} with $value");
        if (this.stats[statName] == null) throw("I have never heard of a stat called: $statName");
        this.stats[statName] += value;
       // if(statName == "power") print("$this boost power to ${this.stats[statName]}");
    }


    void setStatsHash(Map<String, num>hashStats) {
        for (String key in hashStats.keys) {
            this.stats[key] = hashStats[key];
        }
        this.stats["currentHP"] = Math.max(this.stats["hp"], 10); //no negative hp asshole.
    }

    String htmlTitle() {
        String ret = "";
        if (this.crowned != null) ret = "${ret}Crowned ";
        String pname = this.name;
        if (pname == "Yaldabaoth") {
            List<String> misNames = <String>[ 'Yaldobob', 'Yolobroth', 'Yodelbooger', "Yaldabruh", 'Yogertboner', 'Yodelboth'];
            print("Yaldobooger!!! ${this.session.session_id}");
            pname = this.session.rand.pickFrom(misNames);
        }
        if (this.corrupted) pname = Zalgo.generate(this.name); //will i let denizens and royalty get corrupted???
        return "$ret$pname"; //TODO denizens are aspect colored.
    }

    String htmlTitleHP() {
        String ret = "<font color ='$fontColor'>";
        if (this.crowned != null) ret = "${ret}Crowned ";
        String pname = this.name;
        if (this.corrupted) pname = Zalgo.generate(this.name); //will i let denizens and royalty get corrupted???
        return "$ret$pname (${(this.getStat("currentHP")).round()} hp, ${(this.getStat("power")).round()} power)</font>"; //TODO denizens are aspect colored.
    }

    void flipOut(String reason) {}

    String htmlTitleBasic() {
        return this.name;
    }

    void makeAlive() {
        this.dead = false;
    }


    Relationship getRelationshipWith(GameEntity target) {
        //stub for boss fights where an asshole absconds.
        return null;
    }

    void makeDead(String causeOfDeath) {
        this.dead = true;
        this.causeOfDeath = causeOfDeath;
    }

    void interactionEffect(GameEntity ge) {
        //none
    }

    //takes in a stat name we want to use. for example, use only min luck to avoid bad events.
    num rollForLuck([String stat]) {
        if (stat == null || stat == "") {
            return this.session.rand.nextIntRange(this.getStat("minLuck"), this.getStat("maxLuck"));
        } else {
            //don't care if it's min or max, just compare it to zero.
            return this.session.rand.nextIntRange(0, this.getStat(stat));
        }
    }

    void boostAllRelationshipsWithMeBy(num amount) {}
    void boostAllRelationshipsBy(num amount) {}
    List<GameEntity> getFriendsFromList(List<GameEntity> list) {
        return <GameEntity>[];
    }

    List<Relationship> getHearts() {
        return <Relationship>[];
    }

    List<Relationship> getDiamonds() {
        return <Relationship>[];
    }

    Iterable<String> allStats() {
        return this.stats.keys;
    }

    static String getEntitiesNames(List<GameEntity> ges) {
        return ges.join(','); //TODO put an and at the end.
    }

    static int generateID() {
        GameEntity._nextID += 1;
        return GameEntity._nextID;
    }

    Random get rand => this.session.rand;

  String title() {
      return name; //players will override this
  }
}


//need to know if you're from aspect, 'cause only aspect associatedStats will be used for fraymotifs.
//except for heart, which can use ALL associated stats. (cause none will be from aspect.)
class AssociatedStat {
    String name;
    num multiplier;
    bool isFromAspect;


    AssociatedStat(String this.name, num this.multiplier, bool this.isFromAspect) {}

    @override
    String toString() {
        String tmp = "";
        if (this.isFromAspect) tmp = " (from Aspect) ";
        return "[$name x $multiplier$tmp]";
    }
}


//can eventually have a duration, but for now, assumed to be the whole fight. i don't want fights to last long.
class Buff {
    Buff(String this.name, num this.value) {}

    String name;
    num value;
}

