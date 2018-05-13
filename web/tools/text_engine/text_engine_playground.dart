
import "dart:async";
import "dart:html";

import '../../scripts/SBURBSim.dart';
import '../../scripts/formats/Formats.dart';

Set<String> loadedLists = new Set<String>();
bool dirty = true;
TextEngine text = null;

NumberInputElement seedInput;
CheckboxInputElement useSeedInput;
NumberInputElement countInput;
TextInputElement listInput;

DivElement loadedListsElement;
DivElement textElement;

Logger LOGGER = new Logger("TextPlayground");//, true);

Future<Null> main() async {
    loadNavbar();
    Loader.init();
    await Loader.loadManifest();

    querySelector("#loader").append(FileFormat.loadButton(Formats.wordList, loadList, caption:"Load Word List"));
    querySelector("#generate").onClick.listen(generate);
    querySelector("#reset").onClick.listen(resetAll);

    seedInput = querySelector("#seed");
    useSeedInput = querySelector("#useseed");
    countInput = querySelector("#count");
    listInput = querySelector("#list");

    loadedListsElement = querySelector("#loadedlists");
    textElement = querySelector("#text");

    seedInput.onChange.listen(updateSeed);
    useSeedInput.onChange.listen(updateSeed);
}

String listPath(String file) => "${TextEngine.WORDLIST_PATH}$file.words";

void loadList(WordListFile file, String filename) {
    List<String> parts = filename.split(".");
    filename = parts.getRange(0, parts.length-1).join(".");

    loadedLists.add(filename);
    Loader.assignResource(file, listPath(filename));
    dirty = true;
    updateListDisplay();
}

void updateListDisplay() {
    loadedListsElement.setInnerHtml("");
    for (String list in loadedLists) {
        loadedListsElement.append(new DivElement()..text="$list.words");
    }
}

void updateSeed([Event e]) {
    text.setSeed(useSeedInput.checked ? seedInput.valueAsNumber : null);
}

void resetAll([Event e]) {
    for (String name in loadedLists) {
        Loader.purgeResource(listPath(name));
    }
    loadedLists.clear();
    dirty = true;
    updateListDisplay();
}

Future<Null> setup() async {
    if (!dirty) { return; }

    dirty = false;

    text = new TextEngine();

    for (String list in loadedLists) {
        try {
            await text.loadList(list);
        } catch (e) {
            LOGGER.warn("Unable to load wordlist '$list'");
        }
    }
    LOGGER.debug("Setup completed");
}

Future<Null> generate([Event e]) async {
    await setup();

    textElement.setInnerHtml("");

    text.setSeed(useSeedInput.checked ? seedInput.valueAsNumber : null);

    String initial = listInput.value;
    if (initial.isEmpty) {
        LOGGER.warn("Initial list name cannot be length 0");
        return;
    }

    for (int i=0; i<countInput.valueAsNumber; i++) {
        String phrase = text.phrase(initial);

        textElement.append(new DivElement()..text=phrase);
    }
}