import '../../SessionEngine/JSONObject.dart';
import '../../navbar.dart';
import 'ContestEntry.dart';
import "dart:html";
import "dart:async";

Element div;
void main() {
    loadNavbar();
    div = querySelector("#story");

    todo("add JR comments");
    todo("have image folder for entrants");
    todo("allow filtering (use PL's image browser code thingy)");
    makeForm();
    drawContestants();
}

void todo(String todo) {
    LIElement tmp = new LIElement();
    tmp.setInnerHtml("TODO: $todo");
    div.append(tmp);
}

Future<Null> drawContestants() async{
    List<ContestEntry> entries = await ContestEntry.slurpEntries();
    print("entries is $entries");
    for(ContestEntry e in entries) {
        print("entry is $e");
        e.draw(div);
    }
}

void makeForm() {
    DivElement form = new DivElement();
    form.text = "For JR Use Only";
    div.append(form);

    TextInputElement bbName = new TextInputElement();
    bbName.id = "bbName";
    TextInputElement entrantName = new TextInputElement();
    entrantName.id = "entrantName";
    TextInputElement imagesCSV = new TextInputElement();
    imagesCSV.id = "imagesCSV";
    TextAreaElement text = new TextAreaElement();
    text.id = "text";
    TextAreaElement jrComment = new TextAreaElement();
    jrComment.id = "jrComment";
    TextAreaElement shogunComment = new TextAreaElement();
    shogunComment.id = "shogunComment";
    ButtonElement buttonElement = new ButtonElement()..text = "Submit";

    List<Element> inputs = <Element>[bbName, entrantName, imagesCSV, text, jrComment, shogunComment];

    for(Element e in inputs) {
        if(e is InputElement) {
            form.append(e);
            e.value = e.id;
        }else if (e is TextAreaElement) {
            form.append(e);
            e.value = e.id;
        }
    }

    form.append(buttonElement);

    buttonElement.onClick.listen((Event e) {
        JSONObject json = new JSONObject();
        for(InputElement e in inputs) {
            json[e.id] = e.value;
        }
        TextAreaElement output = new TextAreaElement()..value =(json.toString());

        form.append(output);
    });








}