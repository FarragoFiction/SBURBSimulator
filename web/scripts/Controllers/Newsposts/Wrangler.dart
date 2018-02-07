/*
Wranglers have a headshot, text color and chatHandle.

 They know how to post a line to the screen using that information.
 */
import 'dart:html';
import '../../includes/colour.dart';
import "../../SBURBSim.dart";
import "ChangeLogMemo.dart";
import 'dart:async';
import '../../includes/path_utils.dart';




class Wrangler {
    String headshot;
    Colour color;
    String chatHandle;
    List<MemoNewspost> posts = new List<MemoNewspost>();

    Wrangler(String this.chatHandle, String this.headshot, Colour this.color) {
    }

    Future<Null> slurpNewsposts() async{
        await HttpRequest.getString(PathUtils.adjusted("WranglerNewsposts/${chatHandle}.txt")).then((String data) {
            List<String> parts = data.split("\n");
            print("Parts is ${parts.length} long.");
            for(String line in parts) {
                posts.add(new MemoNewspost.from(line, this));
            }
            print("should be returning ");
        });
    }

    void renderLine(Element div, DateTime date, String text) {
        Element container = new DivElement();
        container.classes.add("MemoNewspost");



        Element headerContainer = new DivElement();


        //TODO figure out how i want this to look.

        ImageElement icon = new ImageElement(src: headshot);
        icon.classes.add("MemoNewspostIcon");

        SpanElement textElement = new SpanElement();
        appendHtml(textElement, text); //keeps the html intact
        textElement.classes.add("MemoNewspostText");
        textElement.style.color = color.toStyleString();



        SpanElement dateElement = new SpanElement();
        //https://stackoverflow.com/questions/16126579/how-do-i-format-a-date-with-dart
        String dateSlug ="${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";

        dateElement.text = "$dateSlug: ";
        container.classes.add("MemoDate");


        AnchorElement nameElement = new AnchorElement();
        nameElement.text = "$chatHandle posted: ";
        nameElement.href = "bio.html?staff=$chatHandle";
        container.classes.add("MemoNewspostName");


        headerContainer.append(dateElement);
        headerContainer.append(nameElement);
        container.append(headerContainer);
        container.append(icon);

        container.append(textElement);

        div.append(container);
    }



}