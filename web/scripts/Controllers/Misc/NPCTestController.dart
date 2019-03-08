import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';
import "dart:async";


Element storyDiv;
Session session;
main() {
    start();

}

void testJuiceAndSauce() {
    doNotRender = true;
    List<String> items = <String>["Juice", "Sauce"];
    Random rand = new Random();
    for(Player p in session.players) {
        String item = "Apple ${rand.pickFrom(items)}";
        p.sylladex.add(new Item(item,<ItemTrait>[ItemTraitFactory.EDIBLE, ItemTraitFactory.CANDY],shogunDesc: "Culinary Perfection",abDesc:"Gross."));
        p.makeGodTier();
        print("${p.title()} went god tier with $item");
    }
}

Future<Null> start() async {
    await globalInit();
    storyDiv = querySelector("#story");
    //curSessionGlobalVar = new Session(int.parse(todayToSession()));
    session = new Session(getRandomSeed());
    session.makePlayers();
    print("session has ${session.aspectsIncluded()} aspects and doens't have ${session.aspectsLeftOut()} aspects");
    session.randomizeEntryOrder();
    testJuiceAndSauce();





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
    for(GameEntity g in session.bigBadsReadOnly) {
        printOneGameEntityWithAI(g,bb);
    }


    storyDiv.append(bb);
    print("done printing big bads");
}

void printOneGameEntityWithAI(GameEntity g, Element container) {
    DivElement subcontainer = new DivElement();
    subcontainer.classes.add("aiElement");
    subcontainer.setInnerHtml("<h2>${g.htmlTitle()}</h2>");
    container.append(subcontainer);

    DivElement desc = new DivElement()..text = "${g.description}";
    subcontainer.append(desc);

    if(g is BigBad) {
        DivElement canStrife = new DivElement()..text = "Can be Strifed: ${g.canStrife}";
        DivElement immortal = new DivElement()..text = "Unconditionally Immortal: ${g.unconditionallyImmortal}";
        DivElement prologue = new DivElement()..text = "If Active At Start (Prologue): ${g.prologueText}"..classes.add("textSection");
        DivElement regfrog = new DivElement()..text = "Regular Ending: ${g.regularFrogText}"..classes.add("textSection");
        DivElement pinkFrog = new DivElement()..text = "Pink Ending: ${g.pinkFrogText}"..classes.add("textSection");
        DivElement purpfrog = new DivElement()..text = "Purple Ending: ${g.purpleFrogText}"..classes.add("textSection");

        subcontainer.append(canStrife);
        subcontainer.append(immortal);
        subcontainer.append(prologue);
        subcontainer.append(regfrog);
        subcontainer.append(pinkFrog);
        subcontainer.append(purpfrog);


        UListElement list = new UListElement()..setInnerHtml("<h3>Activation Scenes</h3>");;
        subcontainer.append(list);
        for(SerializableScene s in (g as BigBad).startMechanisms) {
            printOneScene(s,list);
        }
    }else if (g is Carapace) {
        g.addSerializableScenes();
        g.scenes.insertAll(0,g.scenesToAdd);
        carapaceExtras(g, subcontainer);
    }

    UListElement list = new UListElement()..setInnerHtml("<h3>Action Scenes</h3>");
    subcontainer.append(list);
    for(Scene s in g.scenes) {
        if(s is SerializableScene) printOneScene(s,list);
    }

    if(g.playerReactions != null && g.playerReactions.isNotEmpty) {
        UListElement list = new UListElement()..setInnerHtml("<h3>Player Response Scenes: (every player gets this scene when they show up)</h3>");
        subcontainer.append(list);
        for(SerializableScene s in (g as BigBad).playerReactions) {
            printOneScene(s,list);
        }
    }
}

void carapaceExtras(Carapace c, Element container) {
    UListElement uListElement = new UListElement()..setInnerHtml("<h3>Random Distractions</h3>");
    container.append(uListElement);
    for(String s in c.distractions) {
        LIElement liElement = new LIElement()..text = s;
        uListElement.append(liElement);
    }
    UListElement uListElement2 = new UListElement()..setInnerHtml("<h3>Reasons to Visit Jack Noir</h3>");
    container.append(uListElement2);
    for(String s in c.bureaucraticBullshit) {
        LIElement liElement = new LIElement()..text = s;
        uListElement2.append(liElement);
    }
}

void printOneScene(SerializableScene s, Element container) {
    LIElement me = new LIElement()..text = "${s.name}: ${s.flavorText}";
    me.classes.add("aiScene");
    container.append(me);

    ButtonElement toggle = new ButtonElement()..text = "Show Details";
    toggle.style.display = "block";
    toggle.classes.add("aiButton");
    DivElement details = new DivElement();
    details.style.display = "none";

    DivElement numTargets = new DivElement()..setInnerHtml("One Target: ${s.targetOne}");
    details.append(numTargets);

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
            ..setInnerHtml("<h3>Living Targeting Conditions</h3>");
        details.append(livingTargets);
        for (TargetCondition t in s.triggerConditionsLiving) {
            printOneTargetCondition(t, livingTargets);
        }
    }

    if(s.triggerConditionsLand.isNotEmpty) {
        UListElement landTargets = new UListElement()
            ..setInnerHtml("<h3>Land Target Conditions</h3>");
        details.append(landTargets);
        for (TargetCondition t in s.triggerConditionsLand) {
            printOneTargetCondition(t, landTargets);
        }
    }

    if(s.effectsForLiving.isNotEmpty) {
        UListElement livingEffects = new UListElement()
            ..setInnerHtml("<h3>Effect on Entitites</h3>");
        details.append(livingEffects);
        for (EffectEntity t in s.effectsForLiving) {
            printOneEffect(t, livingEffects);
        }
    }

    if(s.effectsForLands.isNotEmpty) {
        UListElement landEffects = new UListElement()
            ..setInnerHtml("<h3>Effect on Lands</h3>");
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