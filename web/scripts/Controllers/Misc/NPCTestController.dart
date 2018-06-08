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
        subcontainer.append(list);
        for(SerializableScene s in (g as BigBad).startMechanisms) {
            printOneScene(s,list, "Activation Scene ");
        }
    }else if (g is Carapace) {
        g.addSerializableScenes();
    }

    UListElement list = new UListElement();
    subcontainer.append(list);
    for(Scene s in g.scenes) {
        if(s is SerializableScene) printOneScene(s,list,"");
    }
}

void printOneScene(SerializableScene s, Element container, String header) {
    LIElement me = new LIElement()..text = "$header ${s.name}: ${s.flavorText}";
    me.classes.add("aiScene");
    container.append(me);

    ButtonElement toggle = new ButtonElement()..text = "Show Details";
    toggle.style.display = "block";
    toggle.classes.add("aiButton");
    DivElement details = new DivElement();
    details.style.display = "none";

    toggle.onClick.listen((Event e) {
        if(details.style.display == "block") {
            details.style.display = "none";
            toggle.text == "Show Details";
        }else {
            details.style.display = "block";
            toggle.text == "Hide Details";
        }
    });

    me.append(toggle);
    me.append(details);

    if(s.triggerConditionsLiving.isNotEmpty) {
        UListElement livingTargets = new UListElement()
            ..text = "Entity Target Conditions";
        details.append(livingTargets);
        for (TargetCondition t in s.triggerConditionsLiving) {
            printOneTargetCondition(t, livingTargets);
        }
    }

    if(s.triggerConditionsLand.isNotEmpty) {
        UListElement landTargets = new UListElement()
            ..text = "Land Target Conditions";
        details.append(landTargets);
        for (TargetCondition t in s.triggerConditionsLand) {
            printOneTargetCondition(t, landTargets);
        }
    }

    if(s.effectsForLiving.isNotEmpty) {
        UListElement livingEffects = new UListElement()
            ..text = "Effect on Entitites";
        details.append(livingEffects);
        for (EffectEntity t in s.effectsForLiving) {
            printOneEffect(t, livingEffects);
        }
    }

    if(s.effectsForLands.isNotEmpty) {
        UListElement landEffects = new UListElement()
            ..text = "Effect on Lands";
        details.append(landEffects);
        for (ActionEffect t in s.effectsForLands) {
            printOneEffect(t, landEffects);
        }
    }

}

void printOneTargetCondition(TargetCondition t, Element container) {
    LIElement me = new LIElement()..setInnerHtml("#${t.desc.replaceAll("<br>","")}, Word: ${t.importantWord}, Number: ${t.importantInt}");
    container.append(me);
}

void printOneEffect(ActionEffect t, Element container) {
    LIElement me = new LIElement()..text = "#${t.name}, Word: ${t.importantWord}, Number: ${t.importantInt}";
    container.append(me);
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