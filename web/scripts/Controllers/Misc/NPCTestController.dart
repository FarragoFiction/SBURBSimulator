import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';



Element storyDiv;
main() {
    globalInit();
    storyDiv = querySelector("#story");
    //curSessionGlobalVar = new Session(int.parse(todayToSession()));
    SimController.instance.session = new Session(getRandomSeed());
    SimController.instance.session.makePlayers();
    SimController.instance.session.randomizeEntryOrder();



    Player p = SimController.instance.session.players.first;
    p.initialize();
    Consort template = p.land.consortFeature.makeConsort(SimController.instance.session);

    appendHtml(storyDiv, "Carapaces are: ${SimController.instance.session.derse.associatedEntities} and ${SimController.instance.session.prospit.associatedEntities} ");
    appendHtml(storyDiv, "<br><br>${p.htmlTitleHP()} Before Minion:  ${p.debugStats}");

    List<String> leprechaunsNames = new List<String>();
    for(int i = 0; i<20; i++) {
        GameEntity l = Leprechaun.getLeprechaunForPlayer(p);
        leprechaunsNames.add("${l.name} (${l.highestStat})");
        p.addCompanion(l);
    }
    appendHtml(storyDiv, "<br><Br>Leprechauns are: ${turnArrayIntoHumanSentence(leprechaunsNames)} ");
    appendHtml(storyDiv, "<br><br>${p.htmlTitleHP()} Before Lord:  ${p.debugStats}");
    p.class_name = SBURBClassManager.LORD;
    appendHtml(storyDiv, "<br><br>${p.htmlTitleHP()} After Lord:  ${p.debugStats}");




    for(Player p in SimController.instance.session.players) {
        p.initialize();
        Consort template = p.land.consortFeature.makeConsort(SimController.instance.session);
        //

        appendHtml(storyDiv, "<br><br>${p.htmlTitleHP()} ${p.highestStat} ${p.lowestStat}  has land ${p.land}");
        for(int i = 0; i<3; i++) {
            Consort c = Consort.npcForPlayer(template, p);
            appendHtml(storyDiv, "<br><Br>${c.name} ");
        }
    }

    printPrototypeAbleThings();


}

void printPrototypeAbleThings() {
    DivElement prototypes = new DivElement();
    prototypes.text = "${turnArrayIntoHumanSentence(PotentialSprite.prototyping_objects)}";
    storyDiv.append(prototypes);
}