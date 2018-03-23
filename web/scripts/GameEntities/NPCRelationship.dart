import "../SBURBSim.dart";

class NPCRelationship extends Relationship {
    String neutral = "Ambivalent";
    String goodMild = "Friends";
    String goodBig = "Great Friends";
    String badMild = "Rivals";
    String badBig = "Great Rivals";
    String heart = "Best Friends";
    String diamond = "BFFs";
    String clubs = "Helpers";
    String spades = "Best Rivals";

  NPCRelationship(GameEntity source, [int value, GameEntity target]) : super(source, value, target) {
    //;
  }

    String nounDescription() {
        return "friend";
    }

}