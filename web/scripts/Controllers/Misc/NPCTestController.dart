import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';



Element storyDiv;
main() {
    globalInit();
    storyDiv = querySelector("#story");
    //curSessionGlobalVar = new Session(int.parse(todayToSession()));
    curSessionGlobalVar = new Session(getRandomSeed());
    curSessionGlobalVar.makePlayers();
    curSessionGlobalVar.randomizeEntryOrder();



    Player p = curSessionGlobalVar.players.first;
    p.initialize();
    Consort template = p.land.consortFeature.makeConsort(curSessionGlobalVar);
    print("template is ${template.name}");
    Consort c1 = Consort.npcForPlayer(template, p);
    Consort c2 = Consort.npcForPlayer(template, p);
    Consort c3 = Consort.npcForPlayer(template, p);

    appendHtml(storyDiv, "${p.htmlTitleBasicWithTip()}  has land ${p.land} which has consorts ${p.land.consortFeature} <br><br>and party members ${c1.name},<br><br> ${c2.name}, and<br><br> ${c3.name}.<br><br> They say ${c1.sound}.");


}