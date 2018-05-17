import '../../SessionEngine/JSONObject.dart';
import '../../includes/path_utils.dart';
import "dart:async";
import 'dart:html';

class ContestEntry {

    String bbName;
    String entrantName;
    String imagesCSV;
    String jrComment;
    String text;
    String shogunComment;

    ContestEntry(String line) {
        JSONObject json = new JSONObject.fromJSONString(line);
        bbName = json["bbName"];
        entrantName = json["entrantName"];
        imagesCSV = json["imagesCSV"];
        jrComment = json["jrComment"];
        text = json["text"];
        shogunComment = json["shogunComment"];
    }

    static Future<List<ContestEntry>> slurpEntries() async{
        return await HttpRequest.getString(PathUtils.adjusted("BigBadLists/contestEntrants.txt")).then((String data) {
            List<ContestEntry> ret = new List<ContestEntry>();
            List<String> parts = data.split("\n");
            for(String line in parts) {
                //print("adding entry from $line");
                if(line.isNotEmpty) ret.add(new ContestEntry(line));
            }
            //print("returning entries $ret");
            return ret;
        });
    }

    void draw(Element parentContainer) {
        DivElement container = new DivElement();
        container.classes.add("contestEntry");

        DivElement nameElement = new DivElement()..text = "$bbName (by ${entrantName})";
        nameElement.classes.add("nameHeader");
        container.append(nameElement);

        DivElement bodyElement = new DivElement()..setInnerHtml(text);
        bodyElement.classes.add("bodyElement");
        container.append(bodyElement);

        DivElement jrNotes = new DivElement()..setInnerHtml("JR: $jrComment");
        jrNotes.classes.add("jrNotes");
        container.append(jrNotes);

        parentContainer.append(container);
    }

}