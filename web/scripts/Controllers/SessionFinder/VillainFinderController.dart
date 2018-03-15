import "dart:html";
import "../../SessionEngine/SessionSummaryLib.dart";

Element div;

void main() {
    div = querySelector("#stats");
    todo("print out the cache from AB.");
    testCache();
    todo("if no cache, instruct Observer to go check AB");
    todo("have session summary have a list of CarapaceData, keyed by initials. CarapaceData is just stuff ShogunBot cares about.");
    todo("print out a card for each carapace, initially just listing names");
    todo("have each card list their stats (default to zero for now)");
    todo("actually use this data for the card stats");
    todo("in card stats, list sessions this carapace was crowned in. have warning that easter eggs or gnosis may invalidate things.");

}

void testCache() {

    Map<String, SessionSummary> cache =  SessionSummary.loadAllSummaries();
    if(cache.isEmpty) todo("Why is there no cache???");
    for(SessionSummary s in cache.values) {
        todo(s.generateHTML());
    }
}

void todo(String text) {
    DivElement tmp = new DivElement();
    //tmp.text = "TODO: $text";
    tmp.setInnerHtml("TODO: $text");
    div.append(tmp);
}