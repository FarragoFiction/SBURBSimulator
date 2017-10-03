import 'dart:html';

import '../../scripts/SBURBSim.dart';

void main() {
    //print("test");
    Stats.init();
    Aspects.init();
    SBURBClassManager.init();
    InterestManager.init();

    Element aspectdiv = querySelector("#aspects");

    List<Aspect> aspects = Aspects.all.toList()..sort((Aspect a, Aspect b) => a.name.compareTo(b.name));

    for (Aspect aspect in aspects) {
        aspectdiv.append(getAspectInfo(aspect));
    }

    Element classdiv = querySelector("#classes");

    List<SBURBClass> classes = SBURBClassManager.all.toList()..sort((SBURBClass a, SBURBClass b) => a.name.compareTo(b.name));

    for (SBURBClass clazz in classes) {
        classdiv.append(getClassInfo(clazz));
    }

    Element interestdiv = querySelector("#interests");

    List<InterestCategory> interests = InterestManager.allCategories.toList()..sort((InterestCategory a, InterestCategory b) => a.name.compareTo(b.name));

    for (InterestCategory interest in interests) {
        interestdiv.append(getInterestInfo(interest));
    }
}

Element getAspectInfo(Aspect aspect) {
    DivElement element = new DivElement()
        ..className="box";

    element.append(new DivElement()
        ..className = "title"
        ..style.backgroundColor = aspect.palette.shirt_light.toStyleString()
        ..append(new DivElement()
            ..className = "aspectIcon"
            ..append(new ImageElement()
                ..src="../../images/${aspect.name}.png"
            )
        )
        ..append(new HeadingElement.h1()
            ..className="title"
            ..style.color = aspect.palette.aspect_light.toStyleString()
            ..text = aspect.name
        )
    );
    element.append(new HeadingElement.h3()
        ..append(new SpanElement()
            ..className = aspect.isCanon ? "canon" : "fanon"
            ..text = "${aspect.isCanon ? "Canon" : "Fanon"}"
        )
        ..appendText(", id: ${aspect.id}")
    );

    element.append(aspectDetails(aspect));
    element.append(drawStats(aspect.stats));

    element.append(toggleList("Levels", aspect.levels));

    element.append(toggleBox("Denizen", new DivElement()..className="section"
        ..append(toggleList("Names", aspect.denizenNames))
        //..append(toggleList("Quests", aspect.denizenQuests))
        ..append(toggleBox("Song", new DivElement()..className = "section"
                ..append(new ParagraphElement()..className="toggleTitle"..text = aspect.denizenSongTitle)
                ..append(new ParagraphElement()..text = aspect.denizenSongDesc)
            )
        )
    ));


    element.append(toggleBox("Quests", new DivElement()..className="section"
        //..append(namedValue("Aspect Quest Chance", aspect.aspectQuestChance))
        //..append(toggleList("Pre-Denizen", aspect.preDenizenQuests))
        //..append(toggleList("Post-Denizen", aspect.postDenizenQuests))
    ));

    element.append(toggleList("ChumHandles", aspect.handles));
    element.append(toggleList("Land Names", aspect.landNames));
    element.append(toggleList("Fraymotif Names", aspect.fraymotifNames));

    element.append(toggleBox("Palette", aspect.palette.createPreviewElement(aspect.name)));



    return element;
}

Element aspectDetails(Aspect aspect) {
    Element div = new DivElement()..className="section";

    div.append(new HeadingElement.h4()..text="Properties");

    if (aspect.deadpan) { div.append(new ParagraphElement()..text="Deadpan"..title="Mentally unaffected by trickster mode"); }
    if (aspect.ultimateDeadpan) { div.append(new ParagraphElement()..text="Ultimate Deadpan"..title="Physically unaffected by trickster mode"); }

    div.append( new ParagraphElement()..text = "Power boost mult: ${aspect.powerBoostMultiplier}");

    return div;
}

Element drawStats(Iterable<AssociatedStat> stats) {
    Element div = new DivElement()..className="section";

    div.append(new HeadingElement.h4()..text="Stats");

    Element table = new TableElement();
    div.append(table);

    for (AssociatedStat stat in stats) {
        div.append(prettyStat(stat));
    }

    return div;
}

Element getClassInfo(SBURBClass clazz) {
    DivElement element = new DivElement()
        ..className="box";

    element.append(new DivElement()
        ..className = "title"
        ..style.backgroundColor = "#CCCCCC"
        ..append(new DivElement()
            ..className = "classIcon"
            ..append(new ImageElement()
                ..src="../../images/Bodies/god${clazz.id+1}.png"
            )
        )
        ..append(new HeadingElement.h1()
            ..className="title"
            ..style.color = "#FFFFFF"
            ..style.marginLeft = "48px"
            ..style.marginTop = "19px"
            ..style.textShadow = "-1px -1px 0px black, -1px 1px 0px black, 1px 1px 0px black, 1px -1px 0px black, -1px 0px 0px black, 1px 0px 0px black, 0px 1px 0px black, 0px -1px 0px black"
            ..text = clazz.name
        )
    );
    element.append(new HeadingElement.h3()
        ..append(new SpanElement()
            ..className = clazz.isCanon ? "canon" : "fanon"
            ..text = "${clazz.isCanon ? "Canon" : "Fanon"}"
        )
        ..appendText(", id: ${clazz.id}")
    );

    element.append(classDetails(clazz));
    element.append(drawStats(clazz.stats));

    element.append(toggleList("Levels", clazz.levels));

    element.append(toggleBox("Quests", new DivElement()..className="section"
        ..append(toggleList("Pre-Denizen", clazz.quests))
        ..append(toggleList("Post-Denizen", clazz.postDenizenQuests))
    ));

    element.append(toggleList("ChumHandles", clazz.handles));

    element.append(toggleBox("PvP Stats", new DivElement()..className="section"
        ..append( new ParagraphElement()..text = "Attacker multiplier: ${clazz.getAttackerModifier()}")
        ..append( new ParagraphElement()..text = "Defender multiplier: ${clazz.getDefenderModifier()}")
        ..append( new ParagraphElement()..text = "Murderous mlultiplier: ${clazz.getMurderousModifier()}")
    ));

    return element;
}

Element classDetails(SBURBClass clazz) {
    Element div = new DivElement()..className="section";

    div.append(new HeadingElement.h4()..text="Properties");

    if (clazz.isActive()) {
        div.append(new ParagraphElement()..text="Active");
    } else {
        div.append(new ParagraphElement()..text="Passive");
    }
    if (clazz.hasInteractionEffect()) { div.append(new ParagraphElement()..text="Has interaction effect"..title="Affects the stats of friends or enemies."); }
    if (clazz.highHinit()) { div.append(new ParagraphElement()..text="High initial stats"); }

    div.append( new ParagraphElement()..text = "Power boost mult: ${clazz.powerBoostMultiplier}");

    return div;
}

Element prettyStat(AssociatedStat stat) {
    Element p = new TableRowElement();
    Element name = new TableCellElement();
    if (stat is AssociatedStatInterests) {
        name.text = "Stats from Interests";
    } else if (stat is AssociatedStatRandom) {
        name..text="[Random Stat]"..title="${stat.stats}";
    } else {
        name.text = "${stat.stat}";
    }

    p.append(name);
    p.append(new TableCellElement()..className="number"..text= "x ${stat.multiplier.toDouble()}");

    return p;
}

Element toggleBox(String title, Element content) {
    Element outer = new DivElement()..className="toggleOuter";

    Element box = new DivElement()..className = "toggleBox"..style.display = "none";

    Element clickable = new SpanElement()..className = "toggleClickable";
    clickable.append(new SpanElement()..className="toggleTitle"..text=title);

    Element button = new SpanElement()..className="toggleButton"..setInnerHtml("[+]");
    clickable..onClick.listen((MouseEvent e){
        if (box.style.display == "none") {
            box.style.display = "block";
            button.innerHtml = "[-]";
        } else {
            box.style.display = "none";
            button.innerHtml = "[+]";
        }
    });

    clickable.append(button);
    outer.append(clickable);
    box.append(content);
    outer.append(box);

    return outer;
}

Element toggleList<T>(String title, List<T> list) {
    Element listContainer = new DivElement()..className="section";

    for (T item in list) {
        listContainer.append(new ParagraphElement()..className="listItem"..text = item.toString());
    }

    return toggleBox(title, listContainer);
}

Element namedValue(String name, Object value) {
    return new SpanElement()
        ..append(new SpanElement()..className = "toggleTitle"..text = "$name:")
        ..append(new SpanElement()..text = value.toString());
}

Element getInterestInfo(InterestCategory interest) {
    DivElement element = new DivElement()
        ..className="box";

    element.append(new DivElement()
        ..className = "title"
        ..style.backgroundColor = "#CCCCCC"
        ..append(new HeadingElement.h1()
            ..className="title"
            ..style.color = "#FFFFFF"
            ..style.marginLeft = "10px"
            ..style.marginTop = "19px"
            ..style.textShadow = "-1px -1px 0px black, -1px 1px 0px black, 1px 1px 0px black, 1px -1px 0px black, -1px 0px 0px black, 1px 0px 0px black, 0px 1px 0px black, 0px -1px 0px black"
            ..text = interest.name
        )
    );

    element.append(new HeadingElement.h3()
        ..appendText("id: ${interest.id}")
    );

    element.append(drawStats(interest.stats));

    element.append(toggleList("Sub-types", interest.interestStrings));
    element.append(toggleList("Levels", interest.levels));
    element.append(toggleBox("ChumHandles", new DivElement()..className="section"
        ..append(toggleList("First", interest.handles1))
        ..append(toggleList("Second", interest.handles2))
    ));

    return element;
}