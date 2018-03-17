import "dart:html";
import "../../SessionEngine/SessionSummaryLib.dart";
import '../../SBURBSim.dart';
import "dart:async";

Element div;
CarapaceSummary carapaceSummary = new CarapaceSummary(null);

void main() {
    globalInit();
    div = querySelector("#stats");
    todo("if no cache, instruct Observer to go check AB");
    todo("figure out why session list tool bar is cut off. is it because bottom?");
    todo("click a card to cycle through diff pages. aw's descriptions, etc.");
    syncCache();
    displayCards();


}

Future<Null> displayCards() async {
    for(CarapaceStats cs in carapaceSummary.data.values) {
        cs.getCard(div);
    }
}

void syncCache() {
    print("trying to sync cache");
    Map<String, SessionSummary> cache =  SessionSummary.loadAllSummaries();
    print("cache is ${cache.values.length} big");
    for(SessionSummary s in cache.values) {
        print("have a session $s with a carapace summary ${s.carapaceSummary}");
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