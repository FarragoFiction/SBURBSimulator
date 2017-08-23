import 'dart:html';
import 'dart:math' as Math;

String simulatedParamsGlobalVar = "";

//just loads the navbar.text into the appropriate div.
void loadNavbar() {
    int subdirs = getSubDirectoryCount();
    HttpRequest.getString("${"../" * subdirs}navbar.txt").then((String data) => onNavbarLoaded(data, subdirs));
}

void onNavbarLoaded(String data, int subdirs) {
    // PL: oh boy fixing those urls
    data = data.replaceAllMapped(new RegExp("(href|src) ?= ?([\"'])(?!https?:)"), (Match m) => "${m.group(1)} = ${m.group(2)}${"../"*subdirs}");
    
    querySelector("#navbar").appendHtml(data, treeSanitizer: NodeTreeSanitizer.trusted);
    if (getParameterByName("seerOfVoid", null) == "true") {
        window.alert("If you gaze long into an abyss, the abyss also gazes into you.  - Troll Bruce Willis");
        querySelector("#story").appendHtml("<button id = 'voidButton'>Peer into Void, Y/N?</a><div class='void'>Well, NOW you've certainly gone and done it. You can expect to see any Void Player shenanignans now. If there are any.", treeSanitizer: NodeTreeSanitizer.trusted);
        (querySelector("#voidButton") as ButtonElement).onClick.listen((Event e) => toggleVoid());
    }
    String sessionID = todayToSession();
    print('sessionID is $sessionID');
    (querySelector("#today") as AnchorElement).href = "index2.html?seed=$sessionID";
}


String todayToSession() {
    DateTime now = new DateTime.now();
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

//http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
//simulatedParamsGlobalVar is the simulated global vars.
String getParameterByName(String name, String url) {
    Uri uri = Uri.base;
    if (url != null) {
        uri = Uri.parse(url);
        // print("uri is $uri");
        String tmp = (uri.queryParameters[name]); //doesn't need decoded, guess it was auto decoded with the parse?
        return tmp;
    } else {
        //print("uri is $uri");
        String tmp = (uri.queryParameters[name]);
        if (tmp != null) tmp = Uri.decodeComponent(tmp);
        return tmp;
    }
}

String getRawParameterByName(String name, String url) {
    Uri uri = Uri.base;
    if (url != null) {
        uri = new Uri.file(url); //TODO is there no built in way to parse a string as a URI? need for virtual parameters like ocDataSTrings from selfInsertOC=true
    }
    return uri.queryParameters[name];
}

void toggleVoid() {
    querySelector('body').style.backgroundColor = "#f8c858";
    querySelector('body').style.backgroundImage = "url(images/pen15_bg1.png)"; //can not unsee the dics now.
    //querySelectorAll(".void").forEach((Element e) => WHAT SHOULD I DO HEAR for DISPLAY:none);
    List<Element> voidElements = querySelectorAll(".void");
    for (Element v in voidElements) {
        toggle(v);
    }
}

//work around for dart not having this jquery function except for classes apparently
void toggle(Element v) {
    String display = v.style.display;
    //print("display is $display");
    if (display == "none" || display.isEmpty) {
        show(v);
    } else {
        hide(v);
    }
}

void show(Element v) {
    //print("showing ${v.id}");
    v.style.display = "block";
}

void hide(Element v) {
    //print("hiding ${v.id}");
    v.style.display = "none";
}

/// PL: WOW THIS IS TOTAL BULLSHIT
int getSubDirectoryCount() {
    Uri here = Uri.base;
    String hereUrl = here.toString();
    List<Element> links = querySelectorAll("link");
    for (Element e in links) {
        if (e is LinkElement && e.rel == "stylesheet") {
            print("is sheet: ${e.href}");
            int shorter = Math.min(hereUrl.length, e.href.length);
            for (int i=0; i<shorter; i++) {
                if (!(hereUrl[i] == e.href[i])) {
                    String local = hereUrl.substring(i);
                    print(local);
                    return local.split("/").length-1;
                }
                continue;
            }
        }
    }
    return 0;
}