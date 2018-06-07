import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';
import "dart:async";


Element storyDiv;
Session session;
main() {
    start();

}

Future<Null> start() async {
    await globalInit();
    storyDiv = querySelector("#story");
    //curSessionGlobalVar = new Session(int.parse(todayToSession()));
    session = new Session(getRandomSeed());
    session.makePlayers();
    session.randomizeEntryOrder();



    Player p = session.players.first;
    p.initialize();
    Consort template = p.land.consortFeature.makeConsort(session);

    printBigBads();
    printCarapaces();

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

void printCarapaces(){
    DivElement cc = new DivElement();
    cc.text = "Carapaces:";
    storyDiv.append(cc);
    for(GameEntity g in session.derse.associatedEntities) {
        printOneGameEntityWithAI(g,cc);
    }

    for(GameEntity g in session.prospit.associatedEntities) {
        printOneGameEntityWithAI(g,cc);
    }

}

void printBigBads() {
    DivElement bb = new DivElement();
    bb.text = "Big Bads: ";
    for(GameEntity g in session.bigBads) {
        printOneGameEntityWithAI(g,bb);
    }


    storyDiv.append(bb);
    print("done printing big bads");
}

void printOneGameEntityWithAI(GameEntity g, Element container) {
    DivElement subcontainer = new DivElement();
    subcontainer.classes.add("aiElement");
    subcontainer.setInnerHtml("<h3>${g.htmlTitle()}</h3>");
    container.append(subcontainer);

    if(g is BigBad) {
        UListElement list = new UListElement();
        for(SerializableScene s in (g as BigBad).startMechanisms) {
            printOneScene(s,list);
        }
    }else if (g is Carapace) {
        g.addSerializableScenes();
    }

    UListElement list = new UListElement();
    subcontainer.append(list);
    for(Scene s in g.scenes) {
        if(s is SerializableScene) printOneScene(s,list);
    }
}

void printOneScene(SerializableScene s, Element container) {
    LIElement me = new LIElement()..text = "${s.name}: ${s.flavorText}";
    container.append(me);
    UListElement livingTargets = new UListElement()..text = "Entity Target Conditions";
    me.append(livingTargets);
    for(TargetCondition t in s.triggerConditionsLiving) {
        printOneTargetCondition(t,livingTargets);
    }
}

void printOneTargetCondition(TargetCondition t, Element container) {
    LIElement me = new LIElement()..text = "#${t.name}, Word: ${t.importantWord}, Number: ${t.importantInt}";
    container.append(me);
}

void printOneEffect() {

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