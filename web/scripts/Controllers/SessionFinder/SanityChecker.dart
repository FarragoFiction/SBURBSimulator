import "dart:html";
import "../../SessionEngine/SessionSummaryLib.dart";
import '../../SBURBSim.dart';
import "dart:async";
import '../../navbar.dart';


DivElement div;
SanityChecker sanityChecker;
Map<String, SessionSummary> cache;
void main() {
    doNotRender = true;
    globalInit();
    loadNavbar();
    div = querySelector("#story");
    listTodos();
    sanityChecker = new SanityChecker();
    drawCache();
}

void listTodos() {
    todo("params for do sessions in reverse order, or shuffle");
    todo("for each session, simulate it, print out if it differs from cache or 'SANITY CONFIRMED'.");
    todo("definitely compare crash stats between cache and simulated");
    todo("I either need to await drawing summaries, or get rid of cursessionglobal var entirely. llook into latter first");
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

    Session session = new Session(summary.session_id);

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

    await session.startSession();
    SessionSummary simSummary = session.generateSummary();
    addMVPRow(table, summary, simSummary);
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

    @override
    void recoverFromCorruption(Session session) {
        session.simulationComplete("Crashed in Sanity Checker");
    }

  @override
  void summarizeSession(Session session) {
    // TODO: implement summarizeSession
  }

  @override
  void summarizeSessionNoFollowup(Session session) {
    // TODO: implement summarizeSessionNoFollowup
  }

}
