part of SBURBSim;


String simulatedParamsGlobalVar = "";

//just loads the navbar.text into the appropriate div.
void loadNavbar() {
  HttpRequest.getString("navbar.txt").then(onNavbarLoaded);
}

void onNavbarLoaded(String data) {
  querySelector("#navbar").appendHtml(data,treeSanitizer: NodeTreeSanitizer.trusted);
  if(getParameterByName("seerOfVoid",null)  == "true"){
    window.alert("If you gaze long into an abyss, the abyss also gazes into you.  - Troll Bruce Willis");
    querySelector("#story").appendHtml("<button onclick='toggleVoid()'>Peer into Void, Y/N?</a><div class;='void'>Well, NOW you've certainly gone and done it. You can expect to see any Void Player shenanignans now. If there are any.",treeSanitizer: NodeTreeSanitizer.trusted);
  }
}




//http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
//simulatedParamsGlobalVar is the simulated global vars.
String getParameterByName(String name, String url) {
  Uri uri = Uri.base;
  if(url != null) {
    uri = new Uri.file(url); //TODO is there no built in way to parse a string as a URI? need for virtual parameters like ocDataSTrings from selfInsertOC=true
  }
  String tmp = (uri.queryParameters[name]);
  if(tmp != null) tmp = Uri.decodeComponent(tmp);
  return tmp;
}

String getRawParameterByName(String name, String url) {
  Uri uri = Uri.base;
  if(url != null) {
    uri = new Uri.file(url); //TODO is there no built in way to parse a string as a URI? need for virtual parameters like ocDataSTrings from selfInsertOC=true
  }
  return uri.queryParameters[name];
}

void toggleVoid(){
	querySelector('body').style.backgroundColor = "#f8c858";
 	querySelector('body').style.backgroundImage = "url(images/pen15_bg1.png)"; //can not unsee the dics now.
  throw"TODO get void toggling working";
  //querySelectorAll(".void").forEach((Element e) => WHAT SHOULD I DO HEAR for DISPLAY:none);
}
