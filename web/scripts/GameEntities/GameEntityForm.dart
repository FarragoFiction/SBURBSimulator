
import '../SBURBSim.dart';
import 'dart:html';

class GameEntityForm {
    GameEntity owner;
    Element container;

    TextInputElement nameElement;
    TextAreaElement dataBox;
    DivElement fraymotifSection;

    List<StatForm> statForms = new List<StatForm>();

    GameEntityForm(GameEntity this.owner, Element parentContainer) {
        container = new DivElement();
        container.classes.add("SceneDiv");

        parentContainer.append(container);

    }

    void drawForm() {
        print("drawing new entity form");
        drawDataBox();
        drawName();
        drawStats();
        drawExistingFraymotifs();
        drawAddFraymotifs();
    }

    void syncFormToOwner() {
        print("syncing form to scene");
        nameElement.value = owner.name;

        for(StatForm form in statForms) {
            form.valueElement.value = "${owner.getStat(form.stat, true).round()}";
        }

        for (Fraymotif s in owner.fraymotifs) {
           drawFraymotifBox(fraymotifSection,s);
        }

        print("syncing data box to scene");
        syncDataBoxToOwner();
    }

    void syncDataBoxToOwner() {
        print("trying to sync data box, owner is ${owner}");
        dataBox.value = owner.toDataString();
    }

    void drawAddFraymotifs() {
        DivElement tmp = new DivElement();
        tmp.classes.add("filterSection");
        ButtonElement button = new ButtonElement()..text = "Add Fraymotif";
        tmp.append(button);
        container.append(tmp);
        button.onClick.listen((Event e) {
            Fraymotif fraymotif = new Fraymotif("Replace This Please",1);
            owner.fraymotifs.add(fraymotif);
            drawFraymotifBox(tmp, fraymotif);
        });
    }

    void drawFraymotifBox(Element parent, Fraymotif fraymotif) {
        //has a box and a 'remove' button
        parent.append(fraymotifSection);
        AnchorElement a = new AnchorElement(href: "FraymotifCreation.html")..text = "Build Fraymotif"..target="_blank";
        TextAreaElement box = new TextAreaElement()..value = fraymotif.toDataString();
        box.rows = 10;
        box.cols = 30;
        box.style.verticalAlign = "bottom";
        ButtonElement remove = new ButtonElement()..text = "Remove";

        fraymotifSection.append(a);
        fraymotifSection.append(box);
        fraymotifSection.append(remove);

        remove.onClick.listen((Event e) {
            fraymotifSection.remove();
            owner.fraymotifs.remove(fraymotif);
        });

        box.onChange.listen((e) {
            try {

                fraymotif.copyFromDataString(dataBox.value);
                syncFormToOwner();
            }catch(e, trace) {
                window.alert("something went wrong! $e, $trace");
            }
        });

    }

    void drawExistingFraymotifs() {
        fraymotifSection = new DivElement();
        container.append(fraymotifSection);
        for(Fraymotif e in owner.fraymotifs) {
            drawFraymotifBox(fraymotifSection,e);
        }
    }

    void drawStats() {
        Iterable<Stat> as = Stats.summarise;
        for(Stat s in as) {
            drawOneStat(s);
        }
    }

    void drawOneStat(Stat stat) {
        DivElement statHolder = new DivElement();
        container.append(statHolder);
        StatForm form = new StatForm(this, stat, statHolder);
        form.drawForm();
        statForms.add(form);
    }

    void drawDataBox() {
        print("drawing data box");
        dataBox = new TextAreaElement();
        dataBox.value = owner.toDataString();
        dataBox.cols = 60;
        dataBox.rows = 10;
        dataBox.onChange.listen((e) {
            print("syncing template to data box");
            try {

                owner.copyFromDataString(dataBox.value);

                print("loaded scene");
                syncFormToOwner();
                print("synced form to scene");
            }catch(e, trace) {
                window.alert("something went wrong! $e, $trace");
            }
        });
        container.append(dataBox);
    }

    void drawName() {
        DivElement subContainer = new DivElement();
        LabelElement nameLabel = new LabelElement();
        nameLabel.text = "Name:";
        nameElement = new TextInputElement();
        nameElement.value = owner.name;
        subContainer.append(nameLabel);
        subContainer.append(nameElement);
        container.append(subContainer);

        nameElement.onInput.listen((e) {
            owner.name = nameElement.value;
            syncDataBoxToOwner();
        });
    }
}


class StatForm {
    GameEntityForm owner;
    Stat stat;
    Element container;

    TextInputElement valueElement;


    StatForm(GameEntityForm this.owner, Stat this.stat, Element parentContainer) {
        container = new DivElement();
        //container.classes.add("SceneDiv");

        parentContainer.append(container);

    }


    void drawForm() {
        print("drawing new stat form");
        DivElement label = new DivElement()..text = stat.name;
        label.style.width = "200px";
        label.style.display = "inline-block";
        valueElement = new TextInputElement()..value = "${owner.owner.getStat(stat,true).round()}";
        container.append(label);
        container.append(valueElement);

        valueElement.onInput.listen((e) {
           owner.owner.setStat(stat, num.parse(valueElement.value));
            owner.syncDataBoxToOwner();
        });

    }
}