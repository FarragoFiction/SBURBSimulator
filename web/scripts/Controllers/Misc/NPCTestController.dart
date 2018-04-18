import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';



Element storyDiv;
Session session;
main() {
    globalInit();
    storyDiv = querySelector("#story");
    //curSessionGlobalVar = new Session(int.parse(todayToSession()));
    session = new Session(getRandomSeed());
    session.makePlayers();
    session.randomizeEntryOrder();



    Player p = session.players.first;
    p.initialize();
    Consort template = p.land.consortFeature.makeConsort(session);

    appendHtml(storyDiv, "Carapaces are: ${session.derse.associatedEntities} and ${session.prospit.associatedEntities} ");
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




    for(Player p in session.players) {
        p.initialize();
        Consort template = p.land.consortFeature.makeConsort(session);
        //

        appendHtml(storyDiv, "<br><br>${p.htmlTitleHP()} ${p.highestStat} ${p.lowestStat}  has land ${p.land}");
        for(int i = 0; i<3; i++) {
            Consort c = Consort.npcForPlayer(template, p);
            appendHtml(storyDiv, "<br><Br>${c.name} ");
        }
    }

    printPrototypeAbleThings();

    printAllThings();


}

void printAllThings() {
    //        //logger.info("All Entities is: ${npcHandler.allEntities}");
    DivElement prototypes = new DivElement();
    prototypes.text = "Everything This Session Knows About Besides Prototypable Objects: (${session.npcHandler.allEntities.length} )${turnArrayIntoHumanSentence(session.npcHandler.allEntities)}";
    storyDiv.append(prototypes);
}

void printPrototypeAbleThings() {
    DivElement prototypes = new DivElement();
    prototypes.text = "${turnArrayIntoHumanSentence(PotentialSprite.prototyping_objects)}";
    storyDiv.append(prototypes);
}