import 'dart:html';

import '../../scripts/SBURBSim.dart';

void main() {
    print("test");

    Aspects.init();
    SBURBClassManager.init();

    Element div = querySelector("#content");

    List<Aspect> aspects = Aspects.all.toList()..sort((Aspect a, Aspect b) => a.name.compareTo(b.name));

    for (Aspect aspect in aspects) {
        div.append(getAspectInfo(aspect));
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
    element.append(aspectStats(aspect));

    element.append(toggleList("Levels", aspect.levels));

    element.append(toggleBox("Denizen", new DivElement()..className="section"
        ..append(toggleList("Names", aspect.denizenNames))
        ..append(toggleList("Quests", aspect.denizenQuests))
        ..append(toggleBox("Song", new DivElement()..className = "section"
                ..append(new ParagraphElement()..className="toggleTitle"..text = aspect.denizenSongTitle)
                ..append(new ParagraphElement()..text = aspect.denizenSongDesc)
            )
        )
    ));


    element.append(toggleBox("Quests", new DivElement()..className="section"
        ..append(namedValue("Aspect Quest Chance", aspect.aspectQuestChance))
        ..append(toggleList("Pre-Denizen", aspect.preDenizenQuests))
        ..append(toggleList("Post-Denizen", aspect.postDenizenQuests))
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

Element aspectStats(Aspect aspect) {
    Element div = new DivElement()..className="section";

    div.append(new HeadingElement.h4()..text="Stats");

    Element table = new TableElement();
    div.append(table);

    for (AssociatedStat stat in aspect.stats) {
        div.append(prettyStat(stat));
    }

    return div;
}

Element prettyStat(AssociatedStat stat) {
    Element p = new TableRowElement();
    Element name = new TableCellElement();
    if (stat is AssociatedStatInterests) {
        name.text = "Stats from Interests";
    } else if (stat is AssociatedStatRandom) {
        name..text="[Random Stat]"..title="${stat.names}";
    } else {
        name.text = "${stat.name}";
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