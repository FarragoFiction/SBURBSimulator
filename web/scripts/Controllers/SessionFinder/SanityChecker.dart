import "dart:html";
import "../../SessionEngine/SessionSummaryLib.dart";
import '../../SBURBSim.dart';
import "dart:async";
import '../../navbar.dart';


DivElement div;
SanityChecker sanityChecker;
Map<String, SessionSummary> cache;
void main() {
    globalInit();
    loadNavbar();
    div = querySelector("#story");
    listTodos();
    sanityChecker = new SanityChecker();
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
    sanityChecker.initial_seed = summary.session_id;
    DivElement container = new DivElement();
    div.append(container);
    //every thing past this can be async.
    drawOneSummaryAsync(summary, container);
}

Future<Null> drawOneSummaryAsync(SessionSummary summary, Element container) async {
    //TODO simulate the session BE SANE ABOUT THIS, no callbacks, instead do awaits.

    container.setInnerHtml("<b>Session:</b> <a href = 'index2.html?seed=${summary.session_id}'>${summary.session_id}</a>");
    TableElement table = new TableElement();
    table.style.border = "2px solid black";
    TableRowElement tr = new TableRowElement();
    table.append(tr);
    TableCellElement td1 = new TableCellElement();
    TableCellElement td2 = new TableCellElement();
    td2.text = "Cached";
    td2.style.border = "1px solid black";

    TableCellElement td3 = new TableCellElement();
    td3.text = "Simulated";
    td3.style.border = "1px solid black";

    tr.append(td1);
    tr.append(td2);
    tr.append(td3);
    addMVPRow(table, summary, summary);
    container.append(table);
}


void addMVPRow(TableElement table, SessionSummary s1, SessionSummary s2) {
    //TODO make this more extendable, pass in text to display for s1 and s2 and be able to auto color border if they don't match
    TableRowElement tr = new TableRowElement();
    table.append(tr);
    TableCellElement td1 = new TableCellElement();
    td1.text = "MVP:";
    td1.style.border = "1px solid black";

    TableCellElement td2 = new TableCellElement();
    td2.setInnerHtml("${s1.mvpName}:${s1.mvpGrist}");
    td2.style.border = "1px solid black";

    TableCellElement td3 = new TableCellElement();
    td3.text = "TODO";
    td3.style.border = "1px solid black";

    tr.append(td1);
    tr.append(td2);
    tr.append(td3);
}

void todo(String text) {
    print("todo: $text");
    DivElement container = new DivElement();
    container.setInnerHtml("<b>TODO:</b> $text");
    div.append(container);
}


class SanityChecker extends AuthorBot {
    //works exactly like Sim unless otherwise specified.

  @override
  void summarizeSession(Session session) {
    // TODO: implement summarizeSession
  }

  @override
  void summarizeSessionNoFollowup(Session session) {
    // TODO: implement summarizeSessionNoFollowup
  }
}
