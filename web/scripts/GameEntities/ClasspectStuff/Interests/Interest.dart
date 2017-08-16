import "../../../random.dart";
//because "interests" is too easy to misstype to Interest and i am made of typos
class InterestManager {
}

class InterestCategory {
  List<String> handles1 = <String> ["nobody"];
  List<String> handles2 = <String> ["Nobody"];
  List<String> levels = <String> ["Nobody"];
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
}