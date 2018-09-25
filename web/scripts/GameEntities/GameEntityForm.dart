
import '../SBURBSim.dart';
import 'dart:html';

class GameEntityForm {
    GameEntity owner;
    Element container;

    TextInputElement nameElement;
    TextAreaElement dataBox;
    TextAreaElement specibusBox;

    DivElement fraymotifSection;
    DivElement sylladexSection;

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
        drawSpecibusBox();

        drawExistingSylladexItems();
        drawAddSylladexItems();

        drawExistingFraymotifs();
        drawAddFraymotifs();
    }

    void syncFormToOwner() {
        print("syncing form to scene");
        nameElement.value = owner.name;
        specibusBox.value  = owner.specibus.toDataString();

        for(StatForm form in statForms) {
            form.valueElement.value = "${owner.getStat(form.stat,true).round()}";
        }

        for (Fraymotif s in owner.fraymotifs) {
           drawFraymotifBox(fraymotifSection,s);
        }


        for (Item s in owner.sylladex) {
            drawSylladexBox(sylladexSection,s);
        }

        print("syncing data box to scene");
        syncDataBoxToOwner();
    }

    void syncDataBoxToOwner() {
        print("trying to sync data box, owner is ${owner}");
        dataBox.value = owner.toDataString();
    }

    void drawAddFraymotifs() {
        fraymotifSection.classes.add("filterSection");
        ButtonElement button = new ButtonElement()..text = "Add Fraymotif";
        fraymotifSection.append(button);
        //container.append(fraymotifSection);
        button.onClick.listen((Event e) {
            Fraymotif fraymotif = new Fraymotif("Replace This Please",1);
            owner.fraymotifs.add(fraymotif);
            drawFraymotifBox(fraymotifSection, fraymotif);
        });
    }

    void drawFraymotifBox(Element parent, Fraymotif fraymotif) {
        //has a box and a 'remove' button
        DivElement me = new DivElement();
        parent.append(me);
        AnchorElement a = new AnchorElement(href: "FraymotifCreation.html")..text = "Build Fraymotif"..target="_blank";
        TextAreaElement box = new TextAreaElement()..value = fraymotif.toDataString();
        box.rows = 10;
        box.cols = 30;
        box.style.verticalAlign = "bottom";
        ButtonElement remove = new ButtonElement()..text = "Remove";

        me.append(a);
        me.append(box);
        me.append(remove);

        remove.onClick.listen((Event e) {
            me.remove();
            owner.fraymotifs.remove(fraymotif);
        });

        box.onChange.listen((e) {
            try {

                fraymotif.copyFromDataString(box.value);
                syncDataBoxToOwner();
            }catch(e, trace) {
                window.alert("something went wrong! $e, $trace");
            }
        });

    }

    void drawAddSylladexItems() {
        sylladexSection.classes.add("filterSection");
        ButtonElement button = new ButtonElement()..text = "Add Item To Sylladex";
        sylladexSection.append(button);
        //container.append(fraymotifSection);
        button.onClick.listen((Event e) {
            Item item = new Item("Replace This Please", []);
            owner.sylladex.add(item);
            drawSylladexBox(sylladexSection, item);
        });
    }

    void drawSylladexBox(Element parent, Item item) {
        //has a box and a 'remove' button
        DivElement me = new DivElement();
        parent.append(me);
        AnchorElement a = new AnchorElement(href: "ItemCreation.html")..text = "Build Item"..target="_blank";
        TextAreaElement box = new TextAreaElement()..value = item.toDataString();
        box.rows = 10;
        box.cols = 30;
        box.style.verticalAlign = "bottom";
        ButtonElement remove = new ButtonElement()..text = "Remove";

        me.append(a);
        me.append(box);
        me.append(remove);

        remove.onClick.listen((Event e) {
            me.remove();
            owner.sylladex.remove(item);
        });

        box.onChange.listen((e) {
            try {
                print("trying to sync item $item");
                item.copyFromDataString(box.value);
                print("after sync item is $item");
                syncDataBoxToOwner();
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

    void drawExistingSylladexItems() {
        sylladexSection = new DivElement();
        container.append(sylladexSection);
        for(Item e in owner.sylladex) {
            drawSylladexBox(sylladexSection,e);
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
        ButtonElement button = new ButtonElement()..text = "Manual Sync";
        button.onClick.listen((Event e) {
            syncDataBoxToOwner();
        });
        container.append(button);
    }

    void drawSpecibusBox() {
        print("drawing data box");
        AnchorElement specibusLabel = new AnchorElement(href: "ItemCreation.html")..text = "Build Specibus:"..target="_blank";
        specibusBox = new TextAreaElement();
        specibusBox.value = owner.specibus.toDataString();
        specibusBox.cols = 60;
        specibusBox.rows = 10;
        specibusBox.onChange.listen((e) {
            try {
                owner.specibus.copyFromDataString(specibusBox.value);
                syncDataBoxToOwner();
            }catch(e, trace) {
                window.alert("something went wrong! $e, $trace");
            }
        });
        container.append(specibusLabel);
        container.append(specibusBox);
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
        valueElement = new TextInputElement()..value = "${owner.owner.getStatHolder().getBase(stat).round()}";
        container.append(label);
        container.append(valueElement);

        valueElement.onInput.listen((e) {
           owner.owner.setStat(stat, num.parse(valueElement.value));
            owner.syncDataBoxToOwner();
        });

    }
}