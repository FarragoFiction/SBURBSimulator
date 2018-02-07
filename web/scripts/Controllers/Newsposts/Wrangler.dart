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
        container.style.color = color.toStyleString();

        //TODO figure out how i want this to look.

        ImageElement icon = new ImageElement(src: headshot);

        SpanElement textElement = new SpanElement();
        appendHtml(textElement, text); //keeps the html intact

        SpanElement dateElement = new SpanElement();
        dateElement.text = date.toString();

        SpanElement nameElement = new SpanElement();
        dateElement.text = chatHandle;

        container.append(icon);
        container.append(nameElement);
        container.append(dateElement);
        container.append(textElement);

        div.append(container);
    }



}