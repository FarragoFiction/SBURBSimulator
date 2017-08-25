import "SBURBClass.dart";

class Guide extends SBURBClass {
    List<String> handles = <String>["guiding", "gracious", "great", "gratuitous", "greeting", "gloved", "gone"];


    Guide() : super("Guide", 16, false);

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive() {
        return false;
    }

}