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

    static void init() {
        print("initializing interests");
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
            rand, rand.pickFrom(_categories.values));
    }

    static Iterable<InterestCategory> get allCategories => _categories.values;

    static InterestCategory getCategoryFromString(String s) {
        for (InterestCategory c in _categories.values) {
            if (c.name == s) return c;
        }
        return null;
    }
}

class InterestCategory {
    List<String> handles1 = <String>["nobody"];
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(
        <AssociatedStat>[]);
    List<String> handles2 = <String>["Nobody"];
    List<String> levels = <String>["Nobody"];
    int id;

    //this is what char creator should modify. making it private meant that children apparently couldn't override it. i guess i want protected, but does dart even have that?
    List<String> interestStrings = ["NONE"];

    String negative_descriptor;
    String positive_descriptor;
    String name;

    //p much no vars to set.
    InterestCategory(this.id, this.name, this.positive_descriptor,
        this.negative_descriptor) {
        InterestManager.register(this);
    }

    //clunky name to remind me that modding this does nothing
    List<String> get copyOfInterestStrings =>
        new List<String>.from(interestStrings);

    //interests are auto sanitized.
    void addInterest(String i) {
        //print("maybe adding interest $i");
        if (interestStrings.contains(i)) return;
        //print("def adding interest $i");
        interestStrings.add(
            i.replaceAll(new RegExp(r"""<(?:.|\n)*?>""", multiLine: true), ''));
    }

    void removeInterest(String i) {
        removeFromArray(i, interestStrings);
    }

    bool playerLikes(Player p) {
        return p.interest1.category == this || p.interest2.category == this;
    }
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