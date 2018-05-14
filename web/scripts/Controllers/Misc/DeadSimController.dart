import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';

class DeadSimController extends SimController {
  DeadSimController() : super();





  @override
  void easterEggCallBack(Session session) {
    DeadSession ds = (session as DeadSession);
    //initializePlayers(session.players, session); //will take care of overriding players if need be.
    //has to happen here cuz initializePlayers can wipe out relationships.
    ds.players[0].deriveLand = false;
    //ds.players[0].relationships.add(new Relationship(ds.players[0], -999, ds.metaPlayer)); //if you need to talk to anyone, talk to metaplayer.
    //ds.metaPlayer.relationships.add(new Relationship(ds.metaPlayer, -999, ds.players[0])); //if you need to talk to anyone, talk to metaplayer.

    session.checkSGRUB();
    if (doNotRender == true) {
      session.intro();
    } else {
      load(session, session.players, getGuardiansForPlayers(session.players), "");
    }
  }

  @override
  void shareableURL() {
    String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
    if (params == window.location.href) params = "";
    String str = '<div class = "links"><a href = "dead_index.html?seed=$initial_seed&$params">Shareable URL </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp <a href = "character_creator.html?seed$initial_seed&$params" target="_blank">Replay Session  </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp<a href = "dead_index.html">Random Session URL </a> </div>';
    setHtml(querySelector("#seedText"), str);
    SimController.instance.storyElement.appendHtml("Session: $initial_seed", treeSanitizer: NodeTreeSanitizer.trusted);
  }


}


class StoryController extends SimController {
    StoryController() : super();
}