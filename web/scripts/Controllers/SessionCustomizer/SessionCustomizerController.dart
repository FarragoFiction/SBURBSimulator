import "dart:async";
import "dart:html";

Element container;

Future<Null> main() async {
    container = querySelector("#story");
    todo("Have a button to start a session");
    todo("SessionForm is a new file/class");
    todo("before that button is pressed, display a SessionForm");
    todo("SessionForm has a text area input for a BigBad data string. (hide this when it goes out for real)");
    todo("SessionForm has a ItemSection (new class/file)");
    todo("ItemSection lists all Items, and lets you make a new Item with any existing trait");
    todo("ItemSection lets you select an item.");
    todo("SessionForm has a CarapaceSection (new class/file)");
    todo("CarapaceSection lists all carapaces (image next to each)");
    todo("CarapaceSection lets you activate/deactive each carapace");
    todo("CarapaceSection lets you add the selected item to either the carapaces sylladex or their specibus.");
    todo("SessionForm has a PlayerSection (new class/file");
    todo("PlayerSection lists all players (image next to each)");
    todo("PlayerSection has a text area box for putting a dataUrl to alter players.");
    todo("PlayerSection lets you add the selected item to either sylladex or specibus.");
    todo("Each Player has a QuirkSection that lets  you modify quirks.");
    todo("PlayerSection lets you pick the name of their sprite, and the name of the fraymotif that sprite has");
    todo("PlayerSection lets you pick the name of their Land");
    todo("PlayerSection lets you pick the name of their Consorts");
    todo("PlayerSection lets you pick the sound their consorts make");
    todo("PlayerSection lets you pick initial relationships. (drop down of types, drop down of targets)");

}

void todo(String text) {
    LIElement newTodo = new LIElement()..setInnerHtml("<b>TODO:</b> $text");
    container.append(newTodo);
}