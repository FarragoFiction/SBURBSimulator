import "SBURBClass.dart";

class Scout extends SBURBClass {
    Scout() : super("Scout", 13, false);
    //i am thinking guides will give other players their own aspects (and not the guides) while scouts will gain whoever they are with's aspect.
    @override
    List<String> levels = ["BOSTON SCREAMPIE", "COOKIE OFFERER", "FIRE FRIEND"];
    @override
    List<String> quests = ["exploring areas no Consort has dared to trespass in", "getting lost in ridiculously convoluted mazes", "playing map-creating mini games"];
    @override
    List<String> postDenizenQuests = ["finding Consorts that still need help even after the Denizen has been defeated", "scouting out areas that have opened up following the Denizen's defeat", "looking for rare treasures that are no longer being guarded by the Denizen"];
    @override
    List<String> handles = ["surly", "sour", "sweet", "stylish", "soaring", "serene", "salacious"];

    @override
    bool isProtective = true;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = true;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    @override
    bool highHinit() {
        return false;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }


}