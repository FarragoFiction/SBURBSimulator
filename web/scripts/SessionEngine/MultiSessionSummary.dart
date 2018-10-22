import "dart:html";
import "../navbar.dart";

import "../SBURBSim.dart";
//only initial stats.


class MultiSessionSummary {
    List<Player> ghosts = <Player>[]; //what is this type? Player? String? (it's Player -PL)
    List<String> checkedCorpseBoxes = <String>[];
    Map<String, num> num_stats = <String, num>{};
    Map<SBURBClass, num> classes = <SBURBClass, num>{};
    Map<Aspect, num> aspects = <Aspect, num>{};


    MultiSessionSummary() {
        initStats();
    }

    void initStats() {
//can switch order to change order AB displays in
        //if i don't initialize stats here, then AB won't bothe rlisting stats this.are zero.
        setStat("total", 0);
        setStat("totalDeadPlayers", 0);
        setStat("won", 0);
        setStat("crashedFromPlayerActions", 0);
        setStat("cataclysmCrash", 0);

        setStat("ringWraithCrash", 0);

        setStat("timesAllDied", 0);
        setStat("yellowYard", 0);
        setStat("scratchAvailable", 0);
        setStat("blackKingDead", 0);
        setStat("luckyGodTier", 0);
        setStat("choseGodTier", 0);
        setStat("gnosisEnding", 0);
        setStat("loveEnding", 0);
        setStat("mailQuest", 0);
        setStat("hateEnding", 0);
        setStat("monoTheismEnding", 0);
        setStat("timesAllLived", 0);
        setStat("ectoBiologyStarted", 0);
        setStat("denizenBeat", 0);
        setStat("kingTooPowerful", 0);
        setStat("queenRejectRing", 0);
        setStat("murdersHappened", 0);
        setStat("grimDark", 0);
        setStat("hasHearts", 0);
        setStat("bigBadActive", 0);
        setStat("hasDiamonds", 0);

        setStat("hasSpades", 0);
        setStat("hasClubs", 0);
        setStat("hasBreakups", 0);
        setStat("hasDiamonds", 0);
        setStat("hasSpades", 0);
        setStat("hasClubs", 0);
        setStat("hasBreakups", 0);
        setStat("comboSessions", 0);
        setStat("threeTimesSessionCombo", 0);
        setStat("fourTimesSessionCombo", 0);
        setStat("fiveTimesSessionCombo", 0);
        setStat("holyShitMmmmmonsterCombo", 0);
        setStat("numberNoFrog", 0);
        setStat("numberSickFrog", 0);
        setStat("numberFullFrog", 0);
        setStat("numberPurpleFrog", 0);
        setStat("godTier", 0);
        setStat("questBed", 0);
        setStat("sacrificialSlab", 0);
        setStat("justDeath", 0);
        setStat("heroicDeath", 0);
        setStat("rapBattle", 0);
        setStat("sickFires", 0);
        setStat("brokenForge", 0);
        setStat("timeoutReckoning", 0);
        setStat("mailedCrownAbdication", 0);
        setStat("nonKingReckoning", 0);
        setStat("forgesStoked", 0);
        setStat("hasLuckyEvents", 0);
        setStat("hasUnluckyEvents", 0);
        setStat("hasTier1GnosisEvents", 0);
        setStat("hasTier2GnosisEvents", 0);
        setStat("hasTier3GnosisEvents", 0);
        setStat("hasTier4GnosisEvents", 0);
        setStat("hasNoTier4Events",0);
        setStat("hasFreeWillEvents", 0);
        setStat("hasGhostEvents", 0);
        setStat("scratched", 0);
        setStat("rocksFell", 0);
        setStat("opossumVictory", 0);
        setStat("crashedFromSessionBug", 0);
        setStat("averageGrist", 0);
        setStat("averageFrogLevel", 0);

        setStat("planetDestroyed", 0);
        setStat("redMilesActivated", 0);
        setStat("moonDestroyed", 0);
        setStat("crownedCarapace", 0);
    }

    num getNumStat(String statName) {
        num ret = this.num_stats[statName]; //initialization, not error
        if (ret == null) {
            this.num_stats[statName] = 0;
            return 0;
        }
        return ret;
    }

    void addNumStat(String statName, num value) {
        if (this.num_stats[statName] == null) this.num_stats[statName] = 0;
        this.num_stats[statName] += value;
    }

    void setStat(String statName, num value) {
        if (this.num_stats[statName] == null) this.num_stats[statName] = 0;
        this.num_stats[statName] = value;
    }

    void incNumStat(String statName) {
        addNumStat(statName, 1);
    }


    void setClasses() {
        /*List<String> labels = <String>["Knight", "Seer", "Bard", "Maid", "Heir", "Rogue", "Page", "Thief", "Sylph", "Prince", "Witch", "Mage"];
        for (num i = 0; i < labels.length; i++) {
            this.classes[labels[i]] = 0;
        }*/
        Iterable<SBURBClass> labels = SBURBClassManager.all;
        for (SBURBClass clazz in labels) {
            this.classes[clazz] = 0;
        }
    }

    void integrateClasses(List<MiniPlayer> miniPlayers) {
        for (num i = 0; i < miniPlayers.length; i++) {
            if (this.classes[miniPlayers[i].sburbclass] != null) this.classes[miniPlayers[i].sburbclass] ++;
        }
    }

    void integrateAspects(List<MiniPlayer> miniPlayers) {
        for (num i = 0; i < miniPlayers.length; i++) {
            if (this.aspects[miniPlayers[i].aspect] != null) this.aspects[miniPlayers[i].aspect] ++;
        }
    }

    void setAspects() {
        /*List<String> labels = <String>["Blood", "Mind", "Rage", "Time", "Void", "Heart", "Breath", "Light", "Space", "Hope", "Life", "Doom"];
        for (num i = 0; i < labels.length; i++) {
            this.aspects[labels[i]] = 0;
        }*/
        Iterable<Aspect> labels = Aspects.all;
        for (Aspect aspect in labels) {
            this.aspects[aspect] = 0;
        }
    }

    void filterCorpseParty() {
        List<Player> filteredGhosts = <Player>[];
        this.checkedCorpseBoxes = <String>[]; //reset
        bool classFiltered = !querySelectorAll("input[type=checkbox][name=CorpsefilterClass]:checked").isEmpty;
        bool aspectFiltered = !querySelectorAll("input[type=checkbox][name=CorpsefilterAspect]:checked").isEmpty;
        for (num i = 0; i < this.ghosts.length; i++) {
            Player ghost = this.ghosts[i];
            //add self to filtered ghost if my class OR my aspect is checked. How to tell?  .is(":checked");
            if (classFiltered && !aspectFiltered) {
                if ((querySelector("#corpseclass_${ghost.class_name}") as CheckboxInputElement).checked) {
                    filteredGhosts.add(ghost);
                }
            } else if (aspectFiltered && !classFiltered) {
                if ((querySelector("#corpseaspect_${ghost.aspect}") as CheckboxInputElement).checked) {
                    filteredGhosts.add(ghost);
                }
            } else if (aspectFiltered && classFiltered) {
                if ((querySelector("#corpseclass_${ghost.class_name}") as CheckboxInputElement).checked && (querySelector("#corpseaspect_${ghost.aspect}") as CheckboxInputElement).checked) {
                    filteredGhosts.add(ghost);
                }
            } else {
                //nothing filtered.
                filteredGhosts.add(ghost);
            }
        } //end for loop

        //List<String> labels = <String>["Knight", "Seer", "Bard", "Maid", "Heir", "Rogue", "Page", "Thief", "Sylph", "Prince", "Witch", "Mage", "Blood", "Mind", "Rage", "Time", "Void", "Heart", "Breath", "Light", "Space", "Hope", "Life", "Doom"];
        bool noneChecked = true;
        /*for (num i = 0; i < labels.length; i++) {
            String l = labels[i];
            if ((querySelector("#$l") as CheckboxInputElement).checked) {
                this.checkedCorpseBoxes.add(l);
                noneChecked = false;
            }
        }*/

        Iterable<SBURBClass> clabels = SBURBClassManager.all;
        Iterable<Aspect> alabels = Aspects.all;

        for (SBURBClass clazz in clabels) {
            if ((querySelector("#corpseclass_$clazz") as CheckboxInputElement).checked) {
                this.checkedCorpseBoxes.add("corpseclass_$clazz");
                noneChecked = false;
            }
        }

        for (Aspect aspect in alabels) {
            if ((querySelector("#corpseaspect_$aspect") as CheckboxInputElement).checked) {
                this.checkedCorpseBoxes.add("corpseaspect_$aspect");
                noneChecked = false;
            }
        }

        if (noneChecked) filteredGhosts = this.ghosts;
        //none means 'all' basically
        setHtml(querySelector("#multiSessionSummaryCorpseParty"), this.generateCorpsePartyInnerHTML(filteredGhosts));
        this.wireUpCorpsePartyCheckBoxes();
    }


    void wireUpCorpsePartyCheckBoxes() {
        //i know what the labels are, they are just the classes and aspects.
        /*MultiSessionSummary this.= this;
        List<String> labels = <String>["Knight", "Seer", "Bard", "Maid", "Heir", "Rogue", "Page", "Thief", "Sylph", "Prince", "Witch", "Mage", "Blood", "Mind", "Rage", "Time", "Void", "Heart", "Breath", "Light", "Space", "Hope", "Life", "Doom"];
        for (num i = 0; i < labels.length; i++) {
            String l = labels[i];
            querySelector("#$l").onChange.listen((Event e) {
                this.filterCorpseParty(this.;
            });
        }*/

        Iterable<SBURBClass> clabels = SBURBClassManager.all;
        Iterable<Aspect> alabels = Aspects.all;

        for (SBURBClass clazz in clabels) {
            querySelector("#corpseclass_$clazz").onChange.listen((Event e) {
                this.filterCorpseParty();
            });
        }

        for (Aspect aspect in alabels) {
            querySelector("#corpseaspect_$aspect").onChange.listen((Event e) {
                this.filterCorpseParty();
            });
        }

        for (num i = 0; i < this.checkedCorpseBoxes.length; i++) {
            String l = this.checkedCorpseBoxes[i];
            (querySelector("#$l") as CheckboxInputElement).checked = true;
        }
    }

    String generateHTMLForClassPropertyCorpseParty(SBURBClass label, num value, num total) {
        //		//<input disabled='true' type='checkbox' name='filter' value='"+propertyName +"' id='" + propertyName + "' onchange='filterSessionSummaries()'>"
        String input = "<input type='checkbox' name='CorpsefilterClass' value='$label' id='corpseclass_$label'>";
        int average = 0;
        if (total != 0) average = (100 * value / total).round();
        String html = "<Br>$input$label: $value($average%)";
        return html;
    }

    String generateHTMLForAspectPropertyCorpseParty(Aspect label, num value, num total) {
        //		//<input disabled='true' type='checkbox' name='filter' value='"+propertyName +"' id='" + propertyName + "' onchange='filterSessionSummaries()'>"
        String input = "<input type='checkbox' name='CorpsefilterAspect' value='$label' id='corpseaspect_$label'>";
        num average = 0;
        if (total != 0) average = (100 * value / total).round(); //stop dividing by zero, dunkass.
        String html = "<Br>$input$label: $value($average%)";
        return html;
    }

    String generateCorpsePartyHTML(List<Player> filteredGhosts) {
        String html = "<div class = 'multiSessionSummary'>Corpse Party: (filtering here will ONLY modify the corpse party, not the other boxes) <button id = 'corpseButton'>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryCorpseParty'>";
        html = "$html${this.generateCorpsePartyInnerHTML(filteredGhosts)}";
        html = "$html</div></div>";
        return html;
    }

    String generateCorpsePartyInnerHTML(List<Player> filteredGhosts) {
        //first task. convert ghost array to map. or hash. or whatever javascript calls it. key is what I want to display on the left.
        //value is how many times I see something this.evaluates to this.key.
        // about players killing each other.  look for "died being put down like a rabid dog" and ignore the rest.  or  "fighting against the crazy X" to differentiate it from STRIFE.
        //okay, everything else should be fine. this'll probably still be pretty big, but can figure out how i wanna compress it later. might make all minion/denizen fights compress down to "first goddamn boss fight" and "denizen fight" respectively, but not for v1. want to see if certain
        //aspect have  a rougher go of it.
        Map<SBURBClass, int> corpsePartyClasses = <SBURBClass, int>{};//"Knight": 0, "Seer": 0, "Bard": 0, "Maid": 0, "Heir": 0, "Rogue": 0, "Page": 0, "Thief": 0, "Sylph": 0, "Prince": 0, "Witch": 0, "Mage": 0};

        for (SBURBClass c in SBURBClassManager.all) {
            corpsePartyClasses[c] = 0;
        }

        Map<Aspect, int> corpsePartyAspects = <Aspect, int>{};//"Blood": 0, "Mind": 0, "Rage": 0, "Time": 0, "Void": 0, "Heart": 0, "Breath": 0, "Light": 0, "Space": 0, "Hope": 0, "Life": 0, "Doom": 0};

        for (Aspect a in Aspects.all) {
            corpsePartyAspects[a] = 0;
        }

        Map<String, int> corpseParty = <String, int>{}; //now to refresh my memory on how javascript hashmaps work;
        String html = "<br><b>  Number of Ghosts: </b>: ${filteredGhosts.length}";
        for (int i = 0; i < filteredGhosts.length; i++) {
            Player ghost = filteredGhosts[i];
            if (ghost.causeOfDeath.startsWith("fighting against the crazy")) {
                if (corpseParty["fighting against a MurderMode player"] == null) corpseParty["fighting against a MurderMode player"] = 0; //otherwise NaN;
                corpseParty["fighting against a MurderMode player"] ++;
            } else if (ghost.causeOfDeath.startsWith("being put down like a rabid dog")) {
                if (corpseParty["being put down like a rabid dog"] == null) corpseParty["being put down like a rabid dog"] = 0; //otherwise NaN;
                corpseParty["being put down like a rabid dog"] ++;
            } else if (ghost.causeOfDeath.contains("Minion")) {
                if (corpseParty["fighting a Denizen Minion"] == null) corpseParty["fighting a Denizen Minion"] = 0; //otherwise NaN;
                corpseParty["fighting a Denizen Minion"] ++;
            } else { //just use as is
                if (corpseParty[ghost.causeOfDeath] == null) corpseParty[ghost.causeOfDeath] = 0; //otherwise NaN;
                corpseParty[ghost.causeOfDeath] ++;
            }

            if (corpsePartyClasses[ghost.class_name] == null) corpsePartyClasses[ghost.class_name] = 0; //otherwise NaN;
            if (corpsePartyAspects[ghost.aspect] == null) corpsePartyAspects[ghost.aspect] = 0; //otherwise NaN;
            corpsePartyAspects[ghost.aspect] ++;
            corpsePartyClasses[ghost.class_name] ++;
        }

        for (SBURBClass corpseType in corpsePartyClasses.keys) {
            html = "$html${this.generateHTMLForClassPropertyCorpseParty(corpseType, corpsePartyClasses[corpseType], filteredGhosts.length)}";
        }

        for (Aspect corpseType in corpsePartyAspects.keys) {
            html = "$html${this.generateHTMLForAspectPropertyCorpseParty(corpseType, corpsePartyAspects[corpseType], filteredGhosts.length)}";
        }

        for (String corpseType in corpseParty.keys) {
            html = "$html<Br>$corpseType: ${corpseParty[corpseType]}(${(100 * corpseParty[corpseType] / filteredGhosts.length).round()}%)"; //todo maybe print out percentages here. we know how many ghosts there are.;
        }
        return html;
    }

    bool isRomanceProperty(String propertyName) {
        return propertyName == "hasDiamonds" || propertyName == "hasSpades" || propertyName == "hasClubs" || propertyName == "hasHearts" || propertyName == "hasBreakups";
    }

    bool isDramaticProperty(String propertyName) {
        if (propertyName == "exiledJack" || propertyName == "plannedToExileJack" || propertyName == "exiledQueen" || propertyName == "jackGotWeapon" || propertyName == "jackScheme") return true;
        if (propertyName == "kingTooPowerful" || propertyName == "queenRejectRing" || propertyName == "murdersHappened" || propertyName == "grimDark" || propertyName == "denizenFought") return true;
        if (propertyName == "denizenBeat" || propertyName == "godTier" || propertyName == "questBed" || propertyName == "sacrificialSlab" || propertyName == "heroicDeath") return true;
        if (propertyName == "justDeath" || propertyName == "rapBattle" || propertyName == "sickFires" || propertyName == "hasLuckyEvents" || propertyName == "hasUnluckyEvents") return true;
        if (propertyName == "hasNoTier4Events" ||propertyName == "hasTier1GnosisEvents" || propertyName == "hasTier2GnosisEvents" || propertyName == "hasTier3GnosisEvents" || propertyName == "hasTier4GnosisEvents" || propertyName == "hasFreeWillEvents" || propertyName == "hasGhostEvents" || propertyName == "jackRampage" || propertyName == "democracyStarted") return true;
        if (propertyName == "redMilesActivated" ||propertyName == "moonDestroyed" || propertyName == "planetDestroyed" || propertyName == "crownedCarapace" || propertyName == "mailQuest" ) return true;
        if(propertyName == "mailedCrownAbdication") return true;
        return false;
    }

    bool isEndingProperty(String propertyName) {
        if (propertyName == "yellowYard" || propertyName == "timesAllLived" || propertyName == "timesAllDied" || propertyName == "scratchAvailable" || propertyName == "won") return true;
        if (propertyName == "ringWraithCrash" ||propertyName == "cataclysmCrash" || propertyName == "crashedFromPlayerActions" || propertyName == "ectoBiologyStarted" || propertyName == "comboSessions" || propertyName == "threeTimesSessionCombo") return true;
        if (propertyName == "fourTimesSessionCombo" || propertyName == "fiveTimesSessionCombo" || propertyName == "holyShitMmmmmonsterCombo" || propertyName == "numberFullFrog") return true;
        if (propertyName == "numberPurpleFrog" || propertyName == "numberFullFrog" || propertyName == "numberSickFrog" || propertyName == "numberNoFrog" || propertyName == "rocksFell" || propertyName == "opossumVictory") return true;
        if (propertyName == "blackKingDead" || propertyName == "gnosisEnding" || propertyName == "loveEnding" || propertyName == "hateEnding" || propertyName == "monoTheismEnding" || propertyName == "mayorEnding" || propertyName == "waywardVagabondEnding") return true;
        if(propertyName == "brokenForge" || propertyName == "forgesStoked" || propertyName == "timeoutReckoning" || propertyName == "nonKingReckoning") return true;
        return false;
    }

    bool isAverageProperty(String propertyName) {
        return propertyName == "averageAlchemySkill"||propertyName == "averageFrogLevel" || propertyName == "averageGrist" || propertyName == "sizeOfAfterLife" || propertyName == "averageAfterLifeSize" || propertyName == "averageSanity" || propertyName == "averageRelationshipValue" || propertyName == "averageHP" || propertyName == "averageFreeWill" || propertyName == "averageMobility" || propertyName == "averagePower" || propertyName == "averageMaxLuck" || propertyName == "averageMinLuck";
    }

    bool isPropertyToIgnore(String propertyName) {
        if (propertyName == "totalLivingPlayers" || propertyName == "survivalRate" || propertyName == "ghosts" || propertyName == "generateCorpsePartyHTML" || propertyName == "generateHTML") return true;
        if (propertyName == "generateCorpsePartyInnerHTML" || propertyName == "isRomanceProperty" || propertyName == "isDramaticProperty" || propertyName == "isEndingProperty" || propertyName == "isAverageProperty" || propertyName == "isPropertyToIgnore") return true;
        if (propertyName == "wireUpCorpsePartyCheckBoxes" || propertyName == "isFilterableProperty" || propertyName == "generateClassFilterHTML" || propertyName == "generateAspectFilterHTML" || propertyName == "generateHTMLForProperty" || propertyName == "generateRomanceHTML") return true;
        if (propertyName == "filterCorpseParty" || propertyName == "generateHTMLForClassPropertyCorpseParty" || propertyName == "generateHTMLForAspectPropertyCorpseParty" || propertyName == "generateDramaHTML" || propertyName == "generateMiscHTML" || propertyName == "generateAverageHTML" || propertyName == "generateHTMLOld" || propertyName == "generateEndingHTML") return true;
        if (propertyName == "setAspects" || propertyName == "setClasses" || propertyName == "integrateAspects" || propertyName == "integrateClasses" || propertyName == "classes" || propertyName == "aspects") return true;
        if (propertyName == "wireUpClassCheckBoxes" || propertyName == "checkedCorpseBoxes" || propertyName == "wireUpAspectCheckBoxes" || propertyName == "filterClaspects") return true;
//

        return false;
    }

    bool isFilterableProperty(String propertyName) {

        return !(propertyName == "averageAlchemySkill" ||propertyName == "averageFrogLevel" || propertyName == "averageGrist" || propertyName == "sizeOfAfterLife" || propertyName == "averageNumScenes" || propertyName == "averageAfterLifeSize" || propertyName == "averageSanity" || propertyName == "averageRelationshipValue" || propertyName == "averageHP" || propertyName == "averageFreeWill" || propertyName == "averageMobility" || propertyName == "averagePower" || propertyName == "averageMaxLuck" || propertyName == "averageMinLuck");
    }

    String generateHTML() {
        StringBuffer html = new StringBuffer()
            ..write("<div class = 'multiSessionSummary' id = 'multiSessionSummary'>");
        String header = "<h2>Stats for All Displayed Sessions: </h2>(When done finding, can filter)";
        html.write("$header");

        List<String> romanceProperties = <String>[];
        List<String> dramaProperties = <String>[];
        List<String> endingProperties = <String>[];
        List<String> averageProperties = <String>[];
        List<String> miscProperties = <String>[]; //catchall if i missed something.

        for (String propertyName in this.num_stats.keys) {
            if (propertyName == "total") { //it's like a header.
                html.write("<Br><b> ");
                html.write("$propertyName</b>: ${this.num_stats[propertyName]}");
                int avg = 0;
                if (this.num_stats["total"] != 0) avg = (100 * (this.num_stats[propertyName] / this.num_stats["total"])).round();
                html.write(" ($avg%)");
            } else if (propertyName == "totalDeadPlayers") {
                html.write("<Br><b>totalDeadPlayers: </b> ${this.num_stats['totalDeadPlayers']} (${this.num_stats['survivalRate']}% survival rate)"); //don't want to EVER ignore this.
            } else if (propertyName == "crashedFromSessionBug") {
                html.write(this.generateHTMLForProperty(propertyName)); //don't ignore bugs, either.;
            } else if (propertyName == "hasNoTier4Events") {
                html.write(this.generateHTMLForProperty(propertyName)); //don't ignore bugs, either.;
            } else if (this.isRomanceProperty(propertyName)) {
                romanceProperties.add(propertyName);
            } else if (this.isDramaticProperty(propertyName)) {
                dramaProperties.add(propertyName);
            } else if (this.isEndingProperty(propertyName)) {
                endingProperties.add(propertyName);
            } else if (this.isAverageProperty(propertyName)) {
                averageProperties.add(propertyName);
            } else if (!this.isPropertyToIgnore(propertyName)) {
                miscProperties.add(propertyName);
            }
        }
        html
            ..write("</div><br>")
            ..write(this.generateRomanceHTML(romanceProperties))
            ..write(this.generateDramaHTML(dramaProperties))
            ..write(this.generateMiscHTML(miscProperties))
            ..write(this.generateEndingHTML(endingProperties))
            ..write(this.generateClassFilterHTML())
            ..write(this.generateAspectFilterHTML())
            ..write(this.generateAverageHTML(averageProperties))
            ..write(this.generateCorpsePartyHTML(this.ghosts))
        //MSS and SS will need list of classes and aspects. just strings. nothing beefier.
        //these will have to be filtered in a special way. just render and display stats for now, though. no filtering.


            ..write("</div><Br>");
        return html.toString();
    }

    String generateClassFilterHTML() {
        String html = "<div class = 'multiSessionSummary topAligned' id = 'multiSessionSummaryClasses'>Classes:";
        for (SBURBClass propertyName in this.classes.keys) {
            String input = "<input type='checkbox' name='filterClass' value='$propertyName' id='class_$propertyName' >";
            html = "$html<Br>$input$propertyName: ${this.classes[propertyName]} ( ${(100 * this.classes[propertyName] / this.num_stats['total']).round()}%)";
        }
        html = "$html</div>";
        return html;
    }

    String generateAspectFilterHTML() {
        String html = "<div class = 'multiSessionSummary topAligned' id = 'multiSessionSummaryAspects'>Aspects:";
        for (Aspect propertyName in this.aspects.keys) {
            String input = "<input type='checkbox' name='filterAspect' value='$propertyName' id='aspect_$propertyName'>";
            html = "$html<Br>$input$propertyName: ${this.aspects[propertyName]} ( ${(100 * this.aspects[propertyName] / this.num_stats['total']).round()}%)";
        }
        html = "$html</div>";
        return html;
    }

    String generateHTMLForProperty(String propertyName) {
        String html = "";
        if (this.isFilterableProperty(propertyName)) {
            html = "$html<Br><b> <input disabled='true' type='checkbox' name='filter' value='$propertyName' id='$propertyName'>";
            html = "$html$propertyName</b>: ${this.num_stats[propertyName]}";
            int avg = 0;
            if (this.num_stats['total'] != 0) avg = (100 * (this.num_stats[propertyName] / this.num_stats['total'])).round();
            html = "$html ($avg%)";
        } else {
            html = "$html<br><b>$propertyName</b>: ${this.num_stats[propertyName]}";
        }
        return html;
    }

    String generateRomanceHTML(List<String> properties) {
        String html = "<div class = 'bottomAligned multiSessionSummary'>Romance: <button id = 'romanceButton''>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryRomance' >";
        for (int i = 0; i < properties.length; i++) {
            String propertyName = properties[i];
            html = "$html${this.generateHTMLForProperty(propertyName)}";
        }
        html = "$html</div></div>";
        ////print(html);
        return html;
    }

    String generateDramaHTML(List<String> properties) {
        String html = "<div class = 'bottomAligned multiSessionSummary' >Drama: <button id = 'dramaButton'>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryDrama' >";
        for (int i = 0; i < properties.length; i++) {
            String propertyName = properties[i];
            html = "$html${this.generateHTMLForProperty(propertyName)}";
        }
        html = "$html</div></div>";
        return html;
    }

    String generateEndingHTML(List<String> properties) {
        String html = "<div class = 'topligned multiSessionSummary'>Ending: <button id = 'endingButton''>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryEnding' >";
        for (num i = 0; i < properties.length; i++) {
            String propertyName = properties[i];
            html = "$html${this.generateHTMLForProperty(propertyName)}";
        }
        html = "$html</div></div>";
        return html;
    }

    String generateMiscHTML(List<String> properties) {
        String html = "<div class = 'bottomAligned multiSessionSummary' >Misc <button id = 'miscButton'>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryMisc' >";
        for (num i = 0; i < properties.length; i++) {
            String propertyName = properties[i];
            html = "$html${this.generateHTMLForProperty(propertyName)}";
        }
        html = "$html</div></div>";
        return html;
    }

    String generateAverageHTML(List<String> properties) {
        String html = "<div class = 'topAligned multiSessionSummary' >Averages <button id = 'averageButton''>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryAverage' >";
        for (num i = 0; i < properties.length; i++) {
            String propertyName = properties[i];
            html = "$html${this.generateHTMLForProperty(propertyName)}";
        }
        html = "$html</div></div>";
        return html;
    }


    static MultiSessionSummary collateMultipleSessionSummaries(List<SessionSummary> sessionSummaries) {
        MultiSessionSummary mss = new MultiSessionSummary();
        mss.setClasses();
        mss.setAspects();
        if (sessionSummaries.isEmpty) return mss; //nothing to do here.
        for (SessionSummary ss in sessionSummaries) {
            mss.incNumStat("total");
            mss.integrateAspects(ss.miniPlayers);
            mss.integrateClasses(ss.miniPlayers);

            if (ss.getBoolStat("badBreakDeath")) mss.incNumStat("badBreakDeath");
            if (ss.getBoolStat("gnosisEnding")) mss.incNumStat("gnosisEnding");
            if (ss.getBoolStat("loveEnding")) mss.incNumStat("loveEnding");
            if (ss.getBoolStat("hateEnding")) mss.incNumStat("hateEnding");
            if (ss.getBoolStat("monoTheismEnding")) mss.incNumStat("monoTheismEnding");
            if (ss.getBoolStat("choseGodTier")) mss.incNumStat("choseGodTier");
            if (ss.getBoolStat("luckyGodTier")) mss.incNumStat("luckyGodTier");
            if (ss.getBoolStat("blackKingDead")) mss.incNumStat("blackKingDead");
            if (ss.getBoolStat("crashedFromSessionBug")) mss.incNumStat("crashedFromSessionBug");
            if (ss.getBoolStat("cataclysmCrash")) mss.incNumStat("cataclysmCrash");

            if (ss.getBoolStat("ringWraithCrash")) mss.incNumStat("ringWraithCrash");

            if (ss.getBoolStat("opossumVictory")) mss.incNumStat("opossumVictory");
            if (ss.getBoolStat("rocksFell")) mss.incNumStat("rocksFell");
            if (ss.getBoolStat("crashedFromPlayerActions")) mss.incNumStat("crashedFromPlayerActions");
            if (ss.getBoolStat("scratchAvailable")) mss.incNumStat("scratchAvailable");
            if (ss.getBoolStat("yellowYard")) mss.incNumStat("yellowYard");
            if (ss.getNumStat("numLiving") == 0) mss.incNumStat("timesAllDied");
            if (ss.getNumStat("numDead") == 0) mss.incNumStat("timesAllLived");
            if (ss.getBoolStat("ectoBiologyStarted")) mss.incNumStat("ectoBiologyStarted");
            if (ss.getBoolStat("denizenBeat")) mss.incNumStat("denizenBeat");
            if (ss.getBoolStat("kingTooPowerful")) mss.incNumStat("kingTooPowerful");
            if (ss.getBoolStat("queenRejectRing")) mss.incNumStat("queenRejectRing");
            if (ss.getBoolStat("murdersHappened")) mss.incNumStat("murdersHappened");
            if (ss.getBoolStat("grimDark")) mss.incNumStat("grimDark");
            if (ss.getBoolStat("hasDiamonds")) mss.incNumStat("hasDiamonds");
            if (ss.getBoolStat("bigBadActive")) mss.incNumStat("bigBadActive");

            if (ss.getBoolStat("hasSpades")) mss.incNumStat("hasSpades");
            if (ss.getBoolStat("hasClubs")) mss.incNumStat("hasClubs");
            if (ss.getBoolStat("hasBreakups")) mss.incNumStat("hasBreakups");

            if (ss.getBoolStat("redMilesActivated")) mss.incNumStat("redMilesActivated");
            if (ss.getBoolStat("moonDestroyed")) mss.incNumStat("moonDestroyed");
            if (ss.getBoolStat("planetDestroyed")) mss.incNumStat("planetDestroyed");
            if (ss.getBoolStat("crownedCarapace")) mss.incNumStat("crownedCarapace");
            if (ss.getBoolStat("mailQuest")) mss.incNumStat("mailQuest");


            if (ss.getBoolStat("hasHearts")) mss.incNumStat("hasHearts");
            if (ss.childSession != null) mss.incNumStat("comboSessions");
            if (ss.getBoolStat("threeTimesSessionCombo")) mss.incNumStat("threeTimesSessionCombo");
            if (ss.getBoolStat("fourTimesSessionCombo")) mss.incNumStat("fourTimesSessionCombo");
            if (ss.getBoolStat("fiveTimesSessionCombo")) mss.incNumStat("fiveTimesSessionCombo");
            if (ss.getBoolStat("holyShitMmmmmonsterCombo")) mss.incNumStat("holyShitMmmmmonsterCombo");
            if (ss.frogStatus == "No Frog") mss.incNumStat("numberNoFrog");
            if (ss.frogStatus == "Sick Frog") mss.incNumStat("numberSickFrog");
            if (ss.frogStatus == "Full Frog") mss.incNumStat("numberFullFrog");
            if (ss.frogStatus == "Purple Frog") mss.incNumStat("numberPurpleFrog");
            if (ss.getBoolStat("godTier")) mss.incNumStat("godTier");
            if (ss.getBoolStat("questBed")) mss.incNumStat("questBed");
            if (ss.getBoolStat("sacrificialSlab")) mss.incNumStat("sacrificialSlab");
            if (ss.getBoolStat("justDeath")) mss.incNumStat("justDeath");
            if (ss.getBoolStat("heroicDeath")) mss.incNumStat("heroicDeath");
            if (ss.getBoolStat("rapBattle")) mss.incNumStat("rapBattle");
            if (ss.getBoolStat("sickFires")) mss.incNumStat("sickFires");
            if (ss.getBoolStat("forgeStoked")) mss.incNumStat("forgesStoked");
            if (ss.getBoolStat("timeoutReckoning")) mss.incNumStat("timeoutReckoning");
            if (ss.getBoolStat("brokenForge")) mss.incNumStat("brokenForge");
            if (ss.getBoolStat("mailedCrownAbdication")) mss.incNumStat("mailedCrownAbdication");
            if (ss.getBoolStat("nonKingReckoning")) mss.incNumStat("nonKingReckoning");

            if (ss.getBoolStat("hasLuckyEvents")) mss.incNumStat("hasLuckyEvents");
            if (ss.getBoolStat("hasUnluckyEvents")) mss.incNumStat("hasUnluckyEvents");
            if (ss.getBoolStat("hasFreeWillEvents")) mss.incNumStat("hasFreeWillEvents");
            if (ss.getBoolStat("hasGhostEvents")) mss.incNumStat("hasGhostEvents");
            if (ss.getBoolStat("hasTier1GnosisEvents")) mss.incNumStat("hasTier1GnosisEvents");
            if (ss.getBoolStat("hasTier2GnosisEvents")) mss.incNumStat("hasTier2GnosisEvents");
            if (ss.getBoolStat("hasTier3GnosisEvents")) mss.incNumStat("hasTier3GnosisEvents");
            if (ss.getBoolStat("hasTier4GnosisEvents")) mss.incNumStat("hasTier4GnosisEvents");
            if (ss.getBoolStat("hasNoTier4Events")) mss.incNumStat("hasNoTier4Events");
            if (ss.scratched) mss.incNumStat("scratched");

            if (ss.getBoolStat("won")) mss.incNumStat("won");

            mss.addNumStat("sizeOfAfterLife", ss.getNumStat("sizeOfAfterLife"));
            mss.ghosts.addAll(ss.ghosts);
            mss.addNumStat("sizeOfAfterLife", ss.getNumStat("sizeOfAfterLife"));
            mss.addNumStat("averageMinLuck", ss.getNumStat("averageMinLuck"));
            mss.addNumStat("averageGrist", ss.getNumStat("averageGrist"));
            mss.addNumStat("averageFrogLevel", ss.frogLevel);
            mss.addNumStat("averageMaxLuck", ss.getNumStat("averageMaxLuck"));
            mss.addNumStat("averagePower", ss.getNumStat("averagePower"));
            mss.addNumStat("averageMobility", ss.getNumStat("averageMobility"));
            mss.addNumStat("averageFreeWill", ss.getNumStat("averageFreeWill"));
            mss.addNumStat("averageHP", ss.getNumStat("averageHP"));

            mss.addNumStat("averageAlchemySkill", ss.getNumStat("averageAlchemySkill"));
            mss.addNumStat("averageSanity", ss.getNumStat("averageSanity"));
            mss.addNumStat("averageRelationshipValue", ss.getNumStat("averageRelationshipValue"));
            mss.addNumStat("averageNumScenes", ss.getNumStat("num_scenes"));

            mss.addNumStat("totalDeadPlayers", ss.getNumStat("numDead"));
            mss.addNumStat("totalLivingPlayers", ss.getNumStat("numLiving"));
        }
        mss.setStat("averageAfterLifeSize", (mss.getNumStat("sizeOfAfterLife") / sessionSummaries.length).round());
        mss.setStat("averageMinLuck", (mss.getNumStat("averageMinLuck") / sessionSummaries.length).round());
        mss.setStat("averageMaxLuck", (mss.getNumStat("averageMaxLuck") / sessionSummaries.length).round());
        mss.setStat("averagePower", (mss.getNumStat("averagePower") / sessionSummaries.length).round());
        mss.setStat("averageMobility", (mss.getNumStat("averageMobility") / sessionSummaries.length).round());
        mss.setStat("averageFreeWill", (mss.getNumStat("averageFreeWill") / sessionSummaries.length).round());

        mss.setStat("averageAlchemySkill", (mss.getNumStat("averageAlchemySkill") / sessionSummaries.length).round());
        mss.setStat("averageHP", (mss.getNumStat("averageHP") / sessionSummaries.length).round());
        mss.setStat("averageGrist", (mss.getNumStat("averageGrist") / sessionSummaries.length).round());
        mss.setStat("averageFrogLevel", (mss.getNumStat("averageFrogLevel") / sessionSummaries.length).round());
        mss.setStat("averageSanity", (mss.getNumStat("averageSanity") / sessionSummaries.length).round());
        mss.setStat("averageRelationshipValue", (mss.getNumStat("averageRelationshipValue") / sessionSummaries.length).round());
        mss.setStat("averageNumScenes", (mss.getNumStat("averageNumScenes") / sessionSummaries.length).round());
        mss.setStat("survivalRate", (100 * (mss.getNumStat("totalLivingPlayers") / (mss.getNumStat("totalLivingPlayers") + mss.getNumStat("totalDeadPlayers")))).round());
        return mss;
    }

}