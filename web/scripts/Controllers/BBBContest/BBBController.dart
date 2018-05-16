import '../../SessionEngine/JSONObject.dart';
import '../../navbar.dart';
import "dart:html";
import "dart:async";

Element div;
void main() {
    loadNavbar();
    div = querySelector("#story");
    todo("make form to generate json datastring for entrant (easier than csv), BBName, Entrant Name, images csv, text, jrComment, shogunComment  ");
    todo("make sample file for showing three contest entry");
    todo("have image folder for entrants");
    todo("slurp file");
    todo("display contest entries");
    todo("allow filtering (use PL's image browser code thingy)");
    makeForm();
}

void todo(String todo) {
    LIElement tmp = new LIElement();
    tmp.setInnerHtml("TODO: $todo");
    div.append(tmp);
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
    TextInputElement jrComment = new TextInputElement();
    jrComment.id = "jrComment";
    TextInputElement shogunComment = new TextInputElement();
    shogunComment.id = "shogunComment";
    ButtonElement buttonElement = new ButtonElement()..text = "Submit";

    List<InputElement> inputs = <InputElement>[bbName, entrantName, imagesCSV, text, jrComment, shogunComment];

    for(InputElement e in inputs) {
        form.append(e);
        e.value = e.id;
    }

    form.append(buttonElement);

    buttonElement.onClick.listen((Event e) {
        JSONObject json = new JSONObject();
        for(InputElement e in inputs) {
            json[e.id] = e.value;
        }
        DivElement output = new DivElement()..setInnerHtml(json.toString());
        form.append(output);
    });








}