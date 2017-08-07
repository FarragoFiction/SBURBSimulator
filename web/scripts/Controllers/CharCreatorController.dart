import '../SBURBSim.dart';
import '../navbar.dart';
import 'dart:html';
import 'dart:async';



void main()
{
  loadNavbar();
  window.onError.listen((Event event){
    ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
    return;
  });
}

/*
  doesn't do sim stuff, it's overrides are errors, but need it to do a few other things. whatever.
 */
class CharCreatorController extends SimController {
  CharCreatorController() : super();

}