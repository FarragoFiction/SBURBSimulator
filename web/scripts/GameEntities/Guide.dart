import "SBURBClass.dart";

class Guide extends SBURBClass {
    List<String> handles = <String>["guiding", "gracious", "great", "gratuitous", "greeting", "gloved", "gone"];
//i am thinking guides will give other players their own aspects (and not the guides) while scouts will gain whoever they are with's aspect.

    Guide() : super("Guide", 16, true);

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive() {
        return false;
    }

}