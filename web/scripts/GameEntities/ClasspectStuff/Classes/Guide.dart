import "SBURBClass.dart";

class Guide extends SBURBClass {
    List<String> handles = <String>["guiding", "gracious", "great", "gratuitous", "greeting", "gloved", "gone"];
//i am thinking guides will give other players their own aspects (and not the guides) while scouts will gain whoever they are with's aspect.
    @override
    bool isProtective = true;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = true;
    Guide() : super("Guide", 16, false);

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
    }

}