import "dart:html";

Element div;

void main() {
    div = querySelector("#stats");
    todo("print out the cache from AB.");
    todo("if no cache, instruct Observer to go check AB");
    todo("print out a card for each carapace, initially just listing names");
    todo("have each card list their stats (default to zero for now)");
    todo("have session summary have a list of CarapaceData, keyed by initials. CarapaceData is just stuff ShogunBot cares about.");
    todo("actually use this data for the card stats");
    todo("in card stats, list sessions this carapace was crowned in. have warning that easter eggs or gnosis may invalidate things.");

}

void todo(String text) {
    DivElement tmp = new DivElement();
    tmp.text = "TODO: $text";
    div.append(tmp);
}