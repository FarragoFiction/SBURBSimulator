import "dart:html";
import "../../SessionEngine/SessionSummaryLib.dart";
import '../../SBURBSim.dart';
import "dart:async";
import '../../navbar.dart';


DivElement div;
SanityChecker sanityChecker;
Map<String, SessionSummary> cache;
bool insanity = false;
Future<Null> main() async {
    doNotRender = true;
    await globalInit();
    loadNavbar();
    div = querySelector("#story");
    listTodos();
    sanityChecker = new SanityChecker();
    window.onError.listen((Event event){
        ErrorEvent e = event as ErrorEvent;
        //String msg, String url, lineNo, columnNo, error
        SimController.instance.currentSessionForErrors.logger.info("AB found a crash in current session");
        printCorruptionMessage(SimController.instance.currentSessionForErrors,e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
        return;
    });
    drawCache();
}

void listTodos() {
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
    checkEasterEgg(session);
    await session.startSession();
    SessionSummary simSummary = session.generateSummary();
    addMVPRow(table, summary, simSummary);
    addLineageRow(table, summary, simSummary);

    addFrogStatusRow(table, summary, simSummary);
    addNumStatsRows(table, summary, simSummary);
    addBoolStatsRows(table, summary, simSummary);
    container.append(table);
    if(insanity) {
        window.alert("insanity found, colored red, search for INSANITY.");
    }
}


void addMVPRow(TableElement table, SessionSummary s1, SessionSummary s2) {
    addComparisonRow(table, "MVP", "${s1.mvpName}:${s1.mvpGrist}", "${s2.mvpName}:${s2.mvpGrist}");
}

void addLineageRow(TableElement table, SessionSummary s1, SessionSummary s2) {
    addComparisonRow(table, "Session Lineage", "${s1.lineageString}", "${s2.lineageString}");
}

void addBoolStatsRows(TableElement table, SessionSummary s1, SessionSummary s2) {
    for(String b in s2.bool_stats.keys) {
        addComparisonRow(table, b, "${s1.bool_stats[b]}", "${s2.bool_stats[b]}");
    }
}

void addNumStatsRows(TableElement table, SessionSummary s1, SessionSummary s2) {
    for(String b in s2.num_stats.keys) {
        addComparisonRow(table, b, "${s1.num_stats[b]}", "${s2.num_stats[b]}");
    }
}


void addFrogStatusRow(TableElement table, SessionSummary s1, SessionSummary s2) {
    addComparisonRow(table, "Frog Status", "${s1.frogStatus}", "${s2.frogStatus}");
}
void addComparisonRow(TableElement table, String valueName, String value1, String value2) {
//TODO make this more extendable, pass in text to display for s1 and s2 and be able to auto color border if they don't match
    Colour color = ReferenceColours.WHITE;
    if(value1 != value2) {
        insanity = true;
        valueName = "$valueName(INSANITY)";
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
    td3.style.backgroundColor = color.toStyleString();


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
  void summarizeSession(Session session, Duration duration) {
    // TODO: implement summarizeSession
  }

  @override
  void summarizeSessionNoFollowup(Session session) {
    // TODO: implement summarizeSessionNoFollowup
  }

}
