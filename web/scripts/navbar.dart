import "dart:async";
import 'dart:html';
import "Controllers/Misc/SimController.dart";
import "random.dart";
import "SBURBSim.dart";
import 'includes/path_utils.dart';

String simulatedParamsGlobalVar = "";

//just loads the navbar.text into the appropriate div.
void loadNavbar() {
    //globalInit();
    HttpRequest.getString(PathUtils.adjusted("navbar.txt")).then(onNavbarLoaded);
}



void onNavbarLoaded(String data) {
    // PL: oh boy fixing those urls
    int subdirs = PathUtils.getPathDepth();
    data = data.replaceAllMapped(new RegExp("(href|src) ?= ?([\"'])(?!https?:)"), (Match m) => "${m.group(1)} = ${m.group(2)}${"../"*subdirs}");

    querySelector("#navbar").appendHtml(data, treeSanitizer: NodeTreeSanitizer.trusted);
    if (getParameterByName("seerOfVoid", null) == "true") {
        new Future<Null>(() {
            querySelector("#story").appendHtml("<button id = 'voidButton'>Peer into Void, Y/N?</a><div class='void'>Well, NOW you've certainly gone and done it. You can expect to see any Void Player shenanignans now. If there are any.", treeSanitizer: NodeTreeSanitizer.trusted);
            (querySelector("#voidButton") as ButtonElement).onClick.listen((Event e) => toggleVoid());
            window.alert("If you gaze long into an abyss, the abyss also gazes into you.  - Troll Bruce Willis");
            storeCard("N4Igzg9grgTgxgUxALhAVTAgJgAgMoIIwDyAZgGoQCWuIANCAHYCGAtkqgHJG7FQAuOAOpV+ACxwAlPPRD8EAD34oQEAO6MiCFuxg4A5swBeCMDiqN+EHOIQ4AbtVzNGuADYJmMRmdYQYdmBiogCEsgBGzHAA1vow0K6cbBwgACwADKkADsz6COEIcMxQmIVwYgB0WYz6svwwVPp5MADCYi6IKukVAKyyYIiaYAAqEGiMbhAxKgDaALqyAWBQbvxgePzMa7PAADpMyfvI+wBCkgCCAJKcl8NoACIAovt0+-bMblAIR-s9+wC+dBwewO7B+IAA4pxiHhLngXm8Pl9wQBGAELBj1RrNDZbMAAGVMmBgswxcgaTSIuLWEICWyIpLqFJxmzWjwAjlAPoz-kA");
        });
    }
    String sessionID = todayToSession();
    //print('sessionID is $sessionID');
    Random rand = new Random(int.parse(sessionID));
    rand.nextInt();
    if(SimController.shogun || rand.nextDouble()>.99) {
        (querySelector("#today") as AnchorElement).href = "${"../"*subdirs}dead_index.html?seed=$sessionID";

    }else {
        (querySelector("#today") as AnchorElement).href = "${"../"*subdirs}index2.html?seed=$sessionID";
    }
}


String todayToSession() {
    DateTime now = new DateTime.now();
    if(now.month == 4 && now.day == 1) {
        querySelector('body').classes.add("voidbody");
    }
    int year = now.year;
    int month = now.month;
    int day = now.day;
    String y = year.toString();
    String m = month.toString();
    String d = day.toString();
    if (month < 10) m = "0$m";
    if (day < 10) d = "0$d";
    return "$y$m$d";
}

String getParamStringMinusParam(dynamic filtered) {
    Set<String> toFilter = new Set<String>();
    if (filtered is String) {
        toFilter.add(filtered);
    } else if (filtered is Iterable<String>) {
        toFilter.addAll(filtered);
    } else {
        throw "Parameter filter list should be String or Iterable<String>";
    }

    return Uri.base.queryParameters.keys.skipWhile(toFilter.contains).map((String key) => "$key=${Uri.base.queryParameters[key]}").join("&");
}

//http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
//simulatedParamsGlobalVar is the simulated global vars.
String getParameterByName(String name, [String url]) {
    Uri uri = Uri.base;
    String tmp = null;
    if (url != null) {
        uri = Uri.parse(url);
        // //;
        String tmp = (uri.queryParameters[name]); //doesn't need decoded, guess it was auto decoded with the parse?
        if(tmp != null) return tmp;
    } else {
        ////;
        String tmp = (uri.queryParameters[name]);
        if (tmp != null) tmp = Uri.decodeComponent(tmp);
        if(tmp != null) return tmp;
    }
    ////;

    //one last shot with simulatedParamsGlobalVar;//lets me use existing framework to parse simulated params for tourney
    if(tmp == null && simulatedParamsGlobalVar.isNotEmpty) {
        //print ("Debugging tourney: can't find param $name, so going to check $simulatedParamsGlobalVar");
        String params =  window.location.href.substring(window.location.href.indexOf("?") + 1);
        String base = window.location.href.replaceAll("?$params","");
        String tmpurl = "${base}?$simulatedParamsGlobalVar";
        ////;
        uri = Uri.parse(tmpurl);
        String tmp = (uri.queryParameters[name]);
        //if(tmp != null) print ("Debugging tourney: found param $name, it was $tmp!");
        return tmp;
    }

    return tmp;
}

String getRawParameterByName(String name, String url) {
    print("url is $url");
    Uri uri = Uri.base;
    if (url != null) {
        uri = new Uri.file(url); //TODO is there no built in way to parse a string as a URI? need for virtual parameters like ocDataSTrings from selfInsertOC=true
    }
    print("uri is $uri parms are ${uri.queryParameters}");
    return uri.queryParameters[name];
}

void toggleVoid() {
    querySelector('body').classes.add("voidbody"); // for the main page theme this is ouija (can not unsee the dics now).

    List<Element> voidElements = querySelectorAll(".void");
    for (Element v in voidElements) {
        toggle(v);
    }
}

//work around for dart not having this jquery function except for classes apparently
void toggle(Element v) {
    String display = v.style.display;
    if (display == "none" || display.isEmpty) {
        show(v);
    } else {
        hide(v);
    }
}

void show(Element v) {
    if(v == null) {return;}
    v.style.display = (v is SpanElement) ? "inline" : "block";
}

void hide(Element v) {
    if(v == null) {return;}
    v.style.display = "none";
}


void storeCard(String card) {
    if(doNotRender) return; //speed up for AB
    String key = "LIFESIMFOUNDCARDS";
    if(window.localStorage == null) {
        print("saving isn't possible....you don't have local storage");
        return;
    }
    try {
        if (window.localStorage.containsKey(key)) {
            String existing = window.localStorage[key];
            List<String> parts = existing.split(",");
            if (!parts.contains(card)) window.localStorage[key] = "$existing,$card";
        } else {
            window.localStorage[key] = card;
        }
    }catch(e) {
        print("Saving isn't possible....you don't have local storage");
    }
}