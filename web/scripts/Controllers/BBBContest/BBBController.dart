import '../../SessionEngine/JSONObject.dart';
import '../../navbar.dart';
import 'ContestEntry.dart';
import "dart:html";
import "dart:async";

Element div;
String targetWords =  getParameterByName("target",null);
void main() {
    loadNavbar();
    div = querySelector("#story");
    DivElement credits = new DivElement()..setInnerHtml("Credits for All Big Bads can be found ");
    AnchorElement a = new AnchorElement(href: "http://farragofiction.com/CreditSim/viewBBB")..text = "here.";
    credits.style.fontSize = "24px";
    credits.append(a);
    div.append(credits);
    //todo("have image folder for entrants");
    //makeForm();
    drawContestants();
}

void todo(String todo) {
    LIElement tmp = new LIElement();
    tmp.setInnerHtml("TODO: $todo");
    div.append(tmp);
}

Future<Null> drawContestants() async{
    List<ContestEntry> entries = await ContestEntry.slurpEntries();
    print("target words is $targetWords");
    if(targetWords != null) {
        //i am the best at var names, it is me
        List<String> doop = targetWords.split("_");
        entries = ContestEntry.filterBy(entries, doop);
    }
    int i = 1;
    for(ContestEntry e in entries) {
        print("entry is $e");
        e.draw(div, i);
        i++;
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