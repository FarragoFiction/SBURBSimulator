import '../SBURBSim.dart';
import 'dart:html';


class CrownedCarapaceHappened extends ImportantEvent {
    int importanceRating = 10;
    String bigBadName;

    CrownedCarapaceHappened(Session session, num mvp_value, Player player) : super(session, mvp_value, player);
    @override
    bool alternateScene(Element div) {
        // TODO: implement alternateScene
    }

    @override
    String humanLabel() {
        return "Stop";
    }
}
