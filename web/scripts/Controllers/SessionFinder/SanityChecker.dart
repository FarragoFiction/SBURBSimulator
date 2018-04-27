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
}

void drawCache() {
    cache =  SessionSummary.loadAllSummaries();
    List<SessionSummary> values = new List.from(cache.values);
    //no reason to do it in the same order that ab did it, i already have that.
    if(getParameterByName("order",null)  == "reversed") {
        values = new List.from(values.reversed);
    }else {
        values = shuffle(values);
    }
    //todo("there are ${cache.values.length} cached summaries");
    for(SessionSummary s in values) {
        drawOneSummary(s);
    }
}

List shuffle(List list) {
    List ret = new List();
    Random rand = new Random();
    while(list.length > 0) {
        dynamic chosen = rand.pickFrom(list);
        ret.add(chosen);
        list.remove(chosen);
    }
    return ret;
}



void drawOneSummary(SessionSummary summary) {
    sanityChecker.initial_seed = summary.session_id;
    DivElement container = new DivElement();
    div.append(container);
    //every thing past this can be async.
    drawOneSummaryAsync(summary, container);
}

Future<Null> drawOneSummaryAsync(SessionSummary summary, Element container) async {
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
    addFrogStatusRow(table, summary, simSummary);
    addNumStatsRow(table, summary, simSummary);
    addBoolStatsRow(table, summary, simSummary);
    container.append(table);
}


void addMVPRow(TableElement table, SessionSummary s1, SessionSummary s2) {
    addComparisonRow(table, "MVP", "${s1.mvpName}:${s1.mvpGrist}", "${s2.mvpName}:${s2.mvpGrist}");
}

void addBoolStatsRow(TableElement table, SessionSummary s1, SessionSummary s2) {
    addComparisonRow(table, "Bool Stats", "${s1.bool_stats}", "${s2.bool_stats}");
}

void addNumStatsRow(TableElement table, SessionSummary s1, SessionSummary s2) {
    addComparisonRow(table, "Num Stats", "${s1.num_stats}", "${s2.num_stats}");
}


void addFrogStatusRow(TableElement table, SessionSummary s1, SessionSummary s2) {
    addComparisonRow(table, "Frog Status", "${s1.frogStatus}", "${s2.frogStatus}");
}
void addComparisonRow(TableElement table, String valueName, String value1, String value2) {
//TODO make this more extendable, pass in text to display for s1 and s2 and be able to auto color border if they don't match
    Colour color = ReferenceColours.WHITE;
    if(value1 != value2) {
        color = ReferenceColours.RED;
    }
    TableRowElement tr = new TableRowElement();
    table.append(tr);
    TableCellElement td1 = new TableCellElement();
    td1.text = "$valueName:";
    td1.style.border = "1px solid black";
    td1.style.backgroundColor = color.toStyleString();

    TableCellElement td2 = new TableCellElement();
    td2.setInnerHtml("$value1");
    td2.style.border = "1px solid black";
    td2.style.backgroundColor = color.toStyleString();


    TableCellElement td3 = new TableCellElement();
    td3.setInnerHtml("${value2}");
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
