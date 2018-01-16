import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';



Element storyDiv;
main() {
    globalInit();
    storyDiv = querySelector("#story");
    curSessionGlobalVar = new Session(int.parse(todayToSession()));
    curSessionGlobalVar.makePlayers();
    curSessionGlobalVar.randomizeEntryOrder();



    Player p = curSessionGlobalVar.players.first;
    p.initialize();
    Consort template = p.land.consortFeature.makeConsort(curSessionGlobalVar);
    print("template is ${template.name}");
    Consort c1 = Consort.npcForPlayer(template, p);
    Consort c2 = Consort.npcForPlayer(template, p);
    Consort c3 = Consort.npcForPlayer(template, p);

    storyDiv.appendHtml("${p.htmlTitleBasicWithTip()} has land ${p.land} which has consorts ${p.land.consortFeature} and party members ${c1.name}, ${c2.name}, and ${c3.name}. They say ${c1.sound}.");


}