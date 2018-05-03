import "dart:html";
import "../../SessionEngine/SessionSummaryLib.dart";
import '../../SBURBSim.dart';
import "dart:async";
import '../../navbar.dart';

Element div;
CarapaceSummary carapaceSummary = new CarapaceSummary(null);
BigBadSummary bigBadSummary = new BigBadSummary(null);

Future<Null> main() async {
    await globalInit();
    loadNavbar();

    div = querySelector("#stats");
    syncCache();
    displayCards();


}

Future<Null> displayCards() async {
    for(CarapaceStats cs in carapaceSummary.data.values) {
        cs.getCard(div);
    }

    for(BigBadStats bs in bigBadSummary.data.values) {
        bs.getCard(div);
    }
}

void syncCache() {
    Map<String, SessionSummary> cache =  SessionSummary.loadAllSummaries();
    print("There are ${cache.values.length} cached summaries.");
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