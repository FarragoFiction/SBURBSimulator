import "../../../SBURBSim.dart";

import "Academic.dart";
import "Athletic.dart";
import "Comedy.dart";
import "Culture.dart";
import "Domestic.dart";
import "Fantasy.dart";
import "Justice.dart";
import "Music.dart";
import "PopCulture.dart";
import "Romantic.dart";
import "Social.dart";
import "Technology.dart";
import "Terrible.dart";
import "Writing.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

//because "interests" is too easy to misstype to Interest and i am made of typos
class InterestManager {

    static Map<int, InterestCategory> _categories = <int, InterestCategory>{};

    static InterestCategory MUSIC;
    static InterestCategory ACADEMIC;
    static InterestCategory ATHLETIC;
    static InterestCategory COMEDY;
    static InterestCategory CULTURE;
    static InterestCategory DOMESTIC;
    static InterestCategory FANTASY;
    static InterestCategory JUSTICE;
    static InterestCategory POPCULTURE;
    static InterestCategory ROMANTIC;
    static InterestCategory SOCIAL;
    static InterestCategory TECHNOLOGY;
    static InterestCategory TERRIBLE;
    static InterestCategory WRITING;
    static InterestCategory NULL;

    static void init() {
        //print("initializing interests");
        MUSIC = new Music();
        ACADEMIC = new Academic();
        ATHLETIC = new Athletic();
        COMEDY = new Comedy();
        CULTURE = new Culture();
        DOMESTIC = new Domestic();
        FANTASY = new Fantasy();
        JUSTICE = new Justice();
        POPCULTURE = new PopCulture();
        ROMANTIC = new Romantic();
        SOCIAL = new Social();
        TERRIBLE = new Terrible();
        WRITING = new Writing();
        TECHNOLOGY = new Technology();
        NULL = new InterestCategory(-13, "Null", "","",true); //shouldn't ever happen.
    }

    static void register(InterestCategory ic) {
        if (_categories.containsKey(ic.id)) {
            throw "Duplicate aspect id for $ic: ${ic
                .id} is already registered for ${_categories[ic.id]}.";
        }
        _categories[ic.id] = ic;
    }

    static InterestCategory get(int id) {
        if (_categories.isEmpty) init();
        if (_categories.containsKey(id)) {
            return _categories[id];
        }
        throw "ERROR: could not find interest category $id  and null is not supported. I have ${_categories
            .length} categories";
    }

    static InterestCategory getByName(String name) {
        if (_categories.isEmpty) init();
        for (InterestCategory ic in _categories.values) {
            if (ic.name == name) {
                return ic;
            }
        }
        throw "ERROR: could not find interest category $name and null is not supported. I have ${_categories
            .length} categories";
    }

    static Interest getRandomInterest(Random rand) {
        return new Interest.randomFromCategory(
            rand, rand.pickFrom(allCategories)); //need to have internal filtering
    }

    static Iterable<InterestCategory> get allCategories => _categories.values.where((InterestCategory c) => !c.isInternal);

    static InterestCategory getCategoryFromString(String s) {
        for (InterestCategory c in _categories.values) {
            if (c.name == s) return c;
        }
        return null;
    }
}

class InterestCategory {
    bool isInternal = false;
    List<String> handles1 = <String>["nobody"];
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[]);
    List<String> handles2 = <String>["Nobody"];
    List<String> levels = <String>["Nobody"];
    int id;
    //based on strength.
    Map<Theme, double> themes = new Map<Theme, double>();

    //this is what char creator should modify. making it private meant that children apparently couldn't override it. i guess i want protected, but does dart even have that?
    List<String> interestStrings = ["NONE"];

    String negative_descriptor;
    String positive_descriptor;
    String name;

    //p much no vars to set.
    InterestCategory(this.id, this.name, this.positive_descriptor, this.negative_descriptor, [this.isInternal = false]) {
        initializeThemes();
        InterestManager.register(this);
    }

    void addTheme(Theme t, double weight) {
        themes[t] = weight;
    }


    //clunky name to remind me that modding this does nothing
    List<String> get copyOfInterestStrings =>
        new List<String>.from(interestStrings);

    //interests are auto sanitized.
    void addInterest(String i) {
        ////print("maybe adding interest $i");
        if (interestStrings.contains(i)) return;
        ////print("def adding interest $i");
        interestStrings.add(
            i.replaceAll(new RegExp(r"""<(?:.|\n)*?>""", multiLine: true), ''));
    }

    void removeInterest(String i) {
        removeFromArray(i, interestStrings);
    }

    bool playerLikes(Player p) {
        return p.interest1.category == this || p.interest2.category == this;
    }

    void initializeThemes() {
        addTheme(new Theme(<String>["Decay","Rot","Death"])
            ..addFeature(FeatureFactory.ROTSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CROCODILECONSORT, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Revive the Consorts", [
                new Quest("The ${Quest.PLAYER1} learns that all of the local ${Quest.CONSORT}s are dead. This is....really depressing, actually. "),
                new Quest("The ${Quest.PLAYER1} has found a series of intriguing block puzzles and symbols. What could it all mean? "),
                new Quest("With a satisfying CLICK, the ${Quest.PLAYER1} has solved the final block puzzle.  A wave of energy overtakes the land. There is an immediate chorus of ${Quest.CONSORTSOUND}ing.  The ${Quest.CONSORT}s are alive again!  "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
        addTheme(new Theme(<String>["Factories", "Manufacture", "Assembly Lines"])
            ..addFeature(FeatureFactory.ROBOTCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.IGUANACONSORT, Feature.LOW)
            ..addFeature(FeatureFactory.OILSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Produce the Goods", [
                new Quest("The ${Quest.PLAYER1} learns that all of the local ${Quest.CONSORT}s have a severe shortage of gears and cogs. It is up to the ${Quest.PLAYER1} to get the assembly lines up and running again. "),
                new Quest("The ${Quest.PLAYER1} is running around and fixing all the broken down equipment. This sure is tiring! "),
                new Quest("The ${Quest.PLAYER1} is training the local ${Quest.CONSORT}s to operate the manufacturing equipment. There is ${Quest.CONSORTSOUND}ing and chaos everywhere. "),
                new Quest("The ${Quest.PLAYER1} manages to get the factories working at peak efficiency.  The gear and cog shortage is over! The ${Quest.CONSORT}s name a national holiday after the ${Quest.PLAYER1}. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.LOW);

        addTheme(new Theme(<String>["Peace","Tranquility","Rest"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Relax the Consorts", [
                new Quest("The ${Quest.PLAYER1} learns that all of the local ${Quest.CONSORT}s have been too stressed about an impending famine to relax. They vow to help however they can."),
                new Quest("The ${Quest.PLAYER1} fluffs more pillows than any other Player ever has before them. "),
                new Quest("The ${Quest.PLAYER1} teaches the local ${Quest.CONSORT}s to find their chill. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ..addFeature(new PreDenizenQuestChain("Relax the Consorts According to Prophecy", [
                new Quest("The ${Quest.PLAYER1} learns that all of the local ${Quest.CONSORT}s have been too stressed about an impending famine to relax. They vow to help however they can."),
                new Quest("The ${Quest.PLAYER1} fluffs more pillows than any other Player ever has before them. Huh, what is this ${Quest.CONSORT} ${Quest.CONSORTSOUND}ing about? A prophecy?  "),
                new Quest("The ${Quest.PLAYER1} finds the foretold RELAXING MIX TAPE and plays it for all the local ${Quest.CONSORT}s, who become so chill they do not even ${Quest.CONSORTSOUND} once. ")
            ], new FraymotifReward(), QuestChainFeature.playerIsFateAspect), Feature.LOW)
            , Theme.LOW); // end theme
    }

    @override
    String toString() => this.name;
}

/*
    Intrests are created programatically, from string list in interest category
 */
class Interest {
    InterestCategory category;
    String name;

    Interest(this.name, this.category) {
        //since the interest has the category in it, this is good enough.
        //it's okay if the category doesn't have a list of all interests
        //but for char creator want new interests to be in the drop downs.
        this.category.addInterest(
            this.name); //the method will make sure no duplicates.
    }

    Interest.randomFromCategory(Random rand, InterestCategory category){
        String s = rand.pickFrom(category.copyOfInterestStrings);
        this.category = category;
        this.name = s;
    }


    static String getSharedCategoryWordForPlayers(Player p1, Player p2,
        bool positive) {
        InterestCategory chosen;
        //don't care that interest2 overrides interest 1 if they are both shared.
        if (p2.interestedInCategory(p1.interest1.category))
            chosen = p1.interest1.category;
        if (p2.interestedInCategory(p1.interest2.category))
            chosen = p1.interest2.category;
        if (chosen != null) {
            if (positive) {
                return chosen.positive_descriptor;
            } else {
                return chosen.negative_descriptor;
            }
        } else {
            if (positive) {
                return "nice";
            } else {
                return "annoying";
            }
        }
    }

    static getUnsharedCategoryWordForPlayers(Player p1, Player p2,
        bool positive) {
        InterestCategory chosen;
        //don't care that interest2 overrides interest 1 if they are both unshared.
        if (!p2.interestedInCategory(p1.interest1.category))
            chosen = p1.interest1.category;
        if (!p2.interestedInCategory(p1.interest2.category))
            chosen = p1.interest2.category;
        if (chosen != null) {
            if (positive) {
                return chosen.positive_descriptor;
            } else {
                return chosen.negative_descriptor;
            }
        } else {
            if (positive) {
                return "nice";
            } else {
                return "annoying";
            }
        }
    }

}