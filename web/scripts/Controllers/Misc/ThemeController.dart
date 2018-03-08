import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';

main() {
    doNotRender = true;
    loadNavbar();
    window.onError.listen((Event event){
        ErrorEvent e = event as ErrorEvent;
        printCorruptionMessage(e);
        return;
    });

    globalInit();
    Element div = querySelector("#story");
    displayInterestThemes(div);
    displayAspect(div);
    displayClassThemes(div);
}

void displayInterestThemes(Element div) {
    for(InterestCategory ic in InterestManager.allCategories) {
        String header = ic.name;
        String contents = "";
        for(Theme t in ic.themes.keys) {
            contents += "Weight: ${ic.themes[t]}, Contents: ${t.toHTML()}";
        }
        String html = "<div class = 'themeCategory'> <div class = 'themeHeader'>$header</div> <div class = 'themes'>$contents</div> </div>";
        appendHtml(div, html);
    }
}



void displayAspect(Element div) {
    for(Aspect ic in Aspects.all) {
        String header = ic.name;
        String contents = "";
        for(Theme t in ic.themes.keys) {
            contents += "Weight: ${ic.themes[t]}, Contents: ${t.toHTML()}";
        }
        String html = "<div class = 'themeCategory'> <div class = 'themeHeader'>$header</div> <div class = 'themes'>$contents</div> </div>";
        appendHtml(div, html);
    }
}


void displayClassThemes(Element div) {
    for(SBURBClass ic in SBURBClassManager.all) {
        String header = ic.name;
        String contents = "";
        for(Theme t in ic.themes.keys) {
            contents += "Weight: ${ic.themes[t]}, Contents: ${t.toHTML()}";
        }
        String html = "<div class = 'themeCategory'> <div class = 'themeHeader'>$header</div> <div class = 'themes'>$contents</div> </div>";
        appendHtml(div, html);
    }
}


