import "dart:html";
import '../SessionFinder/AuthorBot.dart';
import "../../SessionEngine/SessionSummaryLib.dart";

DivElement div;
Map<String, SessionSummary> cache;
void main() {
    div = querySelector("#story");
    cache =  SessionSummary.loadAllSummaries();
    listTodos();
}

void listTodos() {
    todo("load all the sessions AB has cached for ShogunBot. shuffle them, print them out.");
    todo("for each session, simulate it, print out if it differs from cache or 'SANITY CONFIRMED'.");
}

void drawCache() {

}

void drawOneSummary() {

}

void todo(String text) {
    print("todo: $text");
    DivElement container = new DivElement();
    container.setInnerHtml("<b>TODO:</b> $text");
    div.append(container);
}
