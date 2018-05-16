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

    static Future<List<ContestEntry>> slurpNewsposts() async{
        List<ContestEntry> ret = new List<ContestEntry>();
        await HttpRequest.getString(PathUtils.adjusted("BigBadLists/contestEntrants.txt")).then((String data) {
            List<String> parts = data.split("\n");
            for(String line in parts) {
                ret.add(new ContestEntry(line));
            }
            return ret;
        });
    }

}