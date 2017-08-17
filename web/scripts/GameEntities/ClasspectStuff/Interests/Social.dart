import "../../GameEntity.dart";

import "Interest.dart";

class Social extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("sanity", 2, true)]);
    @override
    List<String> handles1 = <String>["master", "playful", "matchmaking", "kind", "regular", "social", "trusting", "honest", "benign", "precious", "wondering", "sarcastic", "talkative", "petulant"];

    @override
    List<String> handles2 =  <String>["Socialist", "Defender", "Mentor", "Leader", "Veterinarian", "Therapist", "Buddy", "Healer", "Helper", "Mender", "Lender", "Dog", "Bishop", "Rally"];

    @override
    List<String> levels =<String>["FRIEND-TO-ALL", "FRIEND COLLECTOR"];


    Social() :super(11, "Social", "extroverted", "shallow");

}