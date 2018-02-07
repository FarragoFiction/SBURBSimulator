/*
Wranglers have a headshot, text color and chatHandle.

 They know how to post a line to the screen using that information.
 */
import 'dart:html';
import '../../includes/colour.dart';
import "../../SBURBSim.dart";



class Wrangler {
    String headshot;
    Colour color;
    String chatHandle;

    Wrangler(String this.chatHandle, String this.headshot, Colour this.color) {
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
        nameElement.href = "bio.html?$chatHandle";
        container.classes.add("MemoNewspostName");


        headerContainer.append(dateElement);
        headerContainer.append(nameElement);
        container.append(headerContainer);
        container.append(icon);

        container.append(textElement);

        div.append(container);
    }



}