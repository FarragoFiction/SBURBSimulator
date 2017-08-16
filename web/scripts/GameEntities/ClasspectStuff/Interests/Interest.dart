import "../../../random.dart";
import "../../../GameEntities/player.dart";
//because "interests" is too easy to misstype to Interest and i am made of typos
class InterestManager {
}

class InterestCategory {
  List<String> handles1 = <String> ["nobody"];
  List<String> handles2 = <String> ["Nobody"];
  List<String> levels = <String> ["Nobody"];

  //this is what char creator should modify.
  List<String> interestStrings = ["NONE"];

  String negative_descriptor;
  String positive_descriptor;
  String name;
  //p much no vars to set.
  InterestCategory(this.name, this.positive_descriptor, this.negative_descriptor);
}

/*
    Intrests are created programatically, from string list in interest category
 */
class Interest {
  InterestCategory category;
  String name;
  Interest(this.name, this.category);

  Interest.randomFromCategory(Random rand, InterestCategory category){
      String s = rand.pickFrom(category.interestStrings);
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