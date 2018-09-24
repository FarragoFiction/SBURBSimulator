import "dart:html";
import "../../SessionEngine/SessionSummaryLib.dart";
import '../../SBURBSim.dart';
import "dart:async";
import '../../navbar.dart';

Element div;
CarapaceSummary carapaceSummary = new CarapaceSummary(null);
BigBadSummary bigBadSummary = new BigBadSummary(null);
DivElement status;

Future<Null> main() async {

    status = new DivElement();
    div = querySelector("#stats");
    status.setInnerHtml("Fetching Data from AB");
    div.append(status);
    await globalInit();
    loadNavbar();
    syncCache();
    status.setInnerHtml("Data Fetched");
    displayCards();


}

Future<Null> displayCards() async {

    for(BigBadStats bs in bigBadSummary.data.values) {
        status.setInnerHtml("Displaying ${bs.name}");
        bs.getCard(div);
    }

    for(CarapaceStats cs in carapaceSummary.data.values) {
        status.setInnerHtml("Displaying ${cs.name}");
        cs.getCard(div);
    }

    status.setInnerHtml("Done");

}

void syncCache() {
    DateTime start = new DateTime.now();
    Map<String, SessionSummary> cache =  SessionSummary.loadAllSummaries();
    DateTime end = new DateTime.now();
    print("There are ${cache.values.length} cached summaries. It took ${end.difference(start)} to load them");
    for(SessionSummary s in cache.values) {
        status.setInnerHtml("Fetching Session Summary ${s.session_id}");
        bigBadSummary.add(s.bigBadSummary);
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