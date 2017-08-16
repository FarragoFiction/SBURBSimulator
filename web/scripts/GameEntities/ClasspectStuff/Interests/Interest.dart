import "../../../random.dart";
import "../../../GameEntities/player.dart";
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

  static Map<String, InterestCategory> _categories = <String, InterestCategory>{};

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
  }

  static Interest getRandomInterest(Random rand) {
    return new Interest.randomFromCategory(rand, rand.pickFrom(_categories.values));
  }
}

class InterestCategory {
  List<String> handles1 = <String> ["nobody"];
  List<String> handles2 = <String> ["Nobody"];
  List<String> levels = <String> ["Nobody"];

  //this is what char creator should modify.
  List<String> _interestStrings = ["NONE"];

  String negative_descriptor;
  String positive_descriptor;
  String name;
  //p much no vars to set.
  InterestCategory(this.name, this.positive_descriptor, this.negative_descriptor);
  //clunky name to remind me that modding this does nothing
  List<String> get copyOfInterestStrings => new List<String>.from(_interestStrings);

  //interests are auto sanitized.
  void addInterest(String i) {
    _interestStrings.add(i.replaceAll(new RegExp(r"""<(?:.|\n)*?>""", multiLine: true), ''));
  }
}

/*
    Intrests are created programatically, from string list in interest category
 */
class Interest {
  InterestCategory category;
  String name;
  Interest(this.name, this.category);

  Interest.randomFromCategory(Random rand, InterestCategory category){
      String s = rand.pickFrom(category.copyOfInterestStrings);
      this.category = category;
      this.name = s;
  }


  static String getSharedCategoryWordForPlayers(Player p1, Player p2, bool positive) {
    InterestCategory chosen;
    //don't care that interest2 overrides interest 1 if they are both shared.
    if(p2.interestedInCategory(p1.interest1.category)) chosen = p1.interest1.category;
    if(p2.interestedInCategory(p1.interest2.category)) chosen = p1.interest2.category;
    if(chosen != null) {
        if(positive) {
          return chosen.positive_descriptor;
        }else {
          return chosen.negative_descriptor;
        }
    }else {
      if(positive) {
        return "nice";
      }else {
        return "annoying";
      }
    }
  }

  static getUnsharedCategoryWordForPlayers(Player p1, Player p2, bool positive) {
    InterestCategory chosen;
    //don't care that interest2 overrides interest 1 if they are both unshared.
    if(!p2.interestedInCategory(p1.interest1.category)) chosen = p1.interest1.category;
    if(!p2.interestedInCategory(p1.interest2.category)) chosen = p1.interest2.category;
    if(chosen != null) {
      if(positive) {
        return chosen.positive_descriptor;
      }else {
        return chosen.negative_descriptor;
      }
    }else {
      if(positive) {
        return "nice";
      }else {
        return "annoying";
      }
    }
  }

}