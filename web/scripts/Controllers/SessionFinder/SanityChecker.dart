import "dart:html";
import '../SessionFinder/AuthorBot.dart';
import "../../SessionEngine/SessionSummaryLib.dart";
import '../../navbar.dart';


DivElement div;
Map<String, SessionSummary> cache;
void main() {
    loadNavbar();
    div = querySelector("#story");
    listTodos();
    drawCache();
}

void listTodos() {
    todo("load all the sessions AB has cached for ShogunBot. shuffle them, print them out.");
    todo("for each session, simulate it, print out if it differs from cache or 'SANITY CONFIRMED'.");
}

void drawCache() {
    cache =  SessionSummary.loadAllSummaries();
    todo("there are ${cache.values.length} cached summaries");
    for(SessionSummary s in cache.values) {
        drawOneSummary(s);
    }
}

void drawOneSummary(SessionSummary summary) {
    DivElement container = new DivElement();
    container.setInnerHtml("<b>TODO:</b> $summary");
    div.append(container);
}

void todo(String text) {
    print("todo: $text");
    DivElement container = new DivElement();
    container.setInnerHtml("<b>TODO:</b> $text");
    div.append(container);
}
