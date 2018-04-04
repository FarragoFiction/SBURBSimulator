import "dart:html";
import "../../SessionEngine/SessionSummaryLib.dart";
import '../../SBURBSim.dart';
import "dart:async";
import '../../navbar.dart';


DivElement div;
Map<String, SessionSummary> cache;
void main() {
    globalInit();
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
    //TODO reset session shit between this.
    DivElement container = new DivElement();
    container.setInnerHtml("<b>Session:</b> ${summary.session_id}");
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
    div.append(container);
}

void addMVPRow(TableElement table, SessionSummary s1, SessionSummary s2) {
    TableRowElement tr = new TableRowElement();
    table.append(tr);
    TableCellElement td1 = new TableCellElement();
    td1.text = "MVP:";
    td1.style.border = "1px solid black";

    TableCellElement td2 = new TableCellElement();
    td2.text = "${s1.mvp}";
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
