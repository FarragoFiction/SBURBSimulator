
//everything inside of this must be true
/*
    Needs to be created via a form in BigBadBuilder but how?
 */
import "../../SBURBSim.dart";
import 'dart:html';
class TriggerCondition {
    static String BIGBADNAME = BigBad.BIGBADNAME;
    //could just be a carapace or a player I don't care
    GameEntity bigBad;
    //definitely replace this.
    String flavorText = "$BIGBADNAME suddenly appears for probably no reason.";

    //TODO how to actually set up the triggers? sub classes?

}