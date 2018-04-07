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
    todo("definitely compare crash stats between cache and simulated");
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
    /*

    TODO:  What I want is the ability to get a session, and then simulate until it's done, then get it's summary.

    I believe that AuthorBot knows a session is done based on some bullshit complicated code in teh
    aftermath tick shit.

    TODO: Investigate if I can take everything in a SimController that does the ticks and put it in sessions instead
    that way i could have session.start and have it return its summary.

    It would mean making the session code more complex, but it would stop it from being spread around so much.

    First Step: How many methods are in SimController?
                Looks like ~17 and the Scratch method in the Sim Library. This is doable.
    Second Step: How many would need to be in session instead for my idea?
        tick
        introTick
        reckoning
        doComboSession
        callNextIntro
        processCombinedSession
        intro
        reckoningTick
        startSession
        easterEggCallBack
        restartSessionScratch
        restartSession
        easterEggCallBackRestart
        easterEggCallBack
        scratchConfirm
        scratch
        renderScratchButton
    Third Step: Investigate which methods are overridden via controller inheritance.
        any dead sessions overwriting can be handled easily with dead sessions getting the correspondingmethods
        but what about any other overrides?
            AB overrides scartch stuff (deoesn't render button, and restarting is diff). recoverFromCorruption,too
    Fourth Step: Move those methods into session, rely on "this" instead of curSessionGlobalVar
    Fifth Step: Can I make instanced or static things (like the session mutator) NOT be instanced,
                and instead passed to scratched or combo sessions. What instanced or static things store data?


     */

  @override
  void summarizeSession(Session session) {
    // TODO: implement summarizeSession
  }

  @override
  void summarizeSessionNoFollowup(Session session) {
    // TODO: implement summarizeSessionNoFollowup
  }

}
