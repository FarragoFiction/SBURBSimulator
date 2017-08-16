
//because "interests" is too easy to misstype to Interest and i am made of typos
class InterestManager {
}

class InterestCategory {
  List<String> handles1 = <String> ["nobody"];
  List<String> handles2 = <String> ["Nobody"];
  List<String> levels = <String> ["Nobody"];
  String negative_descriptor;
  String positive_descriptor;
  String name;
  //p much no vars to set.
  InterestCategory(this.name, this.positive_descriptor, this.negative_descriptor);
}

class Interest {
  InterestCategory category;
  String name;
  Interest(this.name, this.category);
}