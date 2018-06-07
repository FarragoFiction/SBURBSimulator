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

    static List<Wrangler> all = new List<Wrangler>();

    Wrangler(String this.chatHandle, String this.headshot, Colour this.color) {
        all.add(this);
    }

    Future<Null> slurpNewsposts() async{
        await HttpRequest.getString(PathUtils.adjusted("WranglerNewsposts/${chatHandle}.txt")).then((String data) {
            List<String> parts = data.split(new RegExp("\n|\r"));
            //;
            for(String line in parts) {
                posts.add(new MemoNewspost.from(line, this));
            }
           // ;
        });
    }

    Future<Null> renderHeadshot(Element div) async {
        DivElement container = new DivElement();
        container.classes.add("Headshot");

        ImageElement icon = new ImageElement(src: headshot);
        icon.classes.add("MemoNewspostIcon");

        AnchorElement nameElement = new AnchorElement();
        nameElement.text = "$chatHandle";
        nameElement.href = "bio.html?staff=$chatHandle";
        nameElement.target = "_blank";

        nameElement.append(icon);
        container.append(nameElement);
        div.append(container);
        //;
    }

    void renderLine(Element div, DateTime date, String text) {
        Element container = new DivElement();
        container.classes.add("MemoNewspost");

        Element headerContainer = new DivElement();

        ImageElement icon = new ImageElement(src: headshot);
        icon.classes.add("MemoNewspostIcon");
        icon.style.float = "left";

        SpanElement textElement = new SpanElement();
        appendHtml(textElement, text); //keeps the html intact
        textElement.classes.add("MemoNewspostText");
        textElement.style.color = color.toStyleString();



        SpanElement dateElement = new SpanElement();
        //https://stackoverflow.com/questions/16126579/how-do-i-format-a-date-with-dart
        String dateSlug ="${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";

        dateElement.text = "$dateSlug: ";
        dateElement.classes.add("MemoDate");


        AnchorElement nameElement = new AnchorElement();
        nameElement.text = "$chatHandle posted: ";
        nameElement.href = "bio.html?staff=$chatHandle";
        nameElement.target = "_blank";
        nameElement.classes.add("MemoNewspostName");
        nameElement.append(icon);


        headerContainer.append(dateElement);
        headerContainer.append(nameElement);
        container.append(headerContainer);
        //container.append(icon);

        container.append(textElement);

        div.append(container);
    }



}