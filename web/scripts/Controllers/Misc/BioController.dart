import '../../navbar.dart';
import 'dart:html';

//bare minimum for a page.
void main() {
  loadNavbar();
  //TODO hide all wranglers but the one passed in the command line. if none past, display error.
  displayBio();
}

void displayBio() {
  String staff = getParameterByName("staff",null);
  processShenanigans(staff);
  Element div = querySelector("#$staff");
  if(div != null) div.classes.remove("void");

  ButtonElement button = querySelector("#layWaste") as ButtonElement;
  button.onClick.listen((e)
  {
    TextAreaElement t =  querySelector("#myHeadCanon") as TextAreaElement;
    DivElement canon =  querySelector("#canon") as DivElement;

    DivElement newFact = new DivElement();
    newFact.text = t.value;
    canon.append(newFact);
  });
}

void processShenanigans(String staff) {
  if(staff == "dilletantMathematician") storeCard("N4Igzg9grgTgxgUxALhAGQQQxgOwJY4DmABJgEbQAuxAIgLIgA0IOmAtkqgMpsQDWCWgkoI4lCDGIAhTJREwAnsTQQA7kxAiAHpRQg1OBDASsOMAORhiYADYIEAB2J4rBeTCgORAE2JklmMQAFniEQQC0DniUcEEIvrF4MA4AdMTSCABmEoIGRibsRsRwmDjE3i4lML4hYAD0cZJwEDhgcHjQYIZgrtSJyVaYhJgEadJQ1HnGpkWYNsaY3kqxpYTxxJRxfrLyeAhWmy7EClgwYwCSB42CgWCixtRgvALlwqLiklMFZuUQ+zjmah8HBqUgUCYAfgAhBoyJg4HxCDBoDhvAA5Qp6Wz2Lx4Dj0FIOIgaSgwUJrGAAYSCpUQegADCkAEwaNomfYAFQgAFUcDYIAi9ABtAC6GmMYCgNkoYC4lFkYGFYuYpPJRjlCowPSMwuAAB0WIUDcgDVIAEoAQXOaPOHO5NAAogbGAaAG5zKAIY0GgAsBoAvsrNGTCBSNTKAOILeRKkkhsPymUOgCOUDmsf9QA");
}




