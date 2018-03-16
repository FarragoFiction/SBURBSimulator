import "dart:html";
import "../../SessionEngine/SessionSummaryLib.dart";
import '../../SBURBSim.dart';

Element div;
CarapaceSummary carapaceSummary = new CarapaceSummary(null);

void main() {
    globalInit();
    div = querySelector("#stats");
    //testCache();
    syncCache();
    displayCards();
    todo("if no cache, instruct Observer to go check AB");
    todo("figure out why session list tool bar is cut off. is it because bottom?");
    todo("actually use this data for the card stats, need to load all sesssion summaries, then take and collate their carapaceSummaries");

    todo("click a card to cycle through diff pages. aw's descriptions, etc.");
    todo("in card stats, list sessions this carapace was crowned in. have warning that easter eggs or gnosis may invalidate things.");

}

void displayCards() {
    for(CarapaceStats cs in carapaceSummary.data.values) {
        div.append(cs.getCard());
    }
}

void syncCache() {
    Map<String, SessionSummary> cache =  SessionSummary.loadAllSummaries();
    for(SessionSummary s in cache.values) {
        carapaceSummary.add(s.carapaceSummary);
    }

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