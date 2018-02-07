/*
    A changeLog Memo has a list of Newsposts sorted by date.

    it knows how to draw itself (by calling each newspost in order of date).

 */
import "Wrangler.dart";
import 'dart:html';
import '../../includes/colour.dart';



class ChangeLogMemo {
    static Wrangler jadedResearcher = new Wrangler("jadedResearcher", "images/Credits/jadedResearcher_icon.png", new Colour.fromStyleString("#3da35a"));
    static Wrangler authorBot = new Wrangler("authorBot", "images/Credits/AB_icon.png", new Colour.fromStyleString("#ff0000"));
    static Wrangler authorBotJunior = new Wrangler("authorBotJunior", "images/Credits/abj_icon.png", new Colour.fromStyleString("#ffa500"));

    static ChangeLogMemo _instance;

    List<MemoNewspost> newsposts = new List<MemoNewspost>();

    static ChangeLogMemo get instance {
        if( _instance == null) _instance = new ChangeLogMemo();
        return _instance;
    }

    ChangeLogMemo() {
    }

    void render(Element div) {
        //TODO sort by date;
        for(MemoNewspost m in newsposts) {
            m.render(div);
        }
    }
}


class MemoNewspost {
    Wrangler poster;
    String text;
    DateTime date;
    MemoNewspost(this.poster, this.date, this.text) {
        //automatically add to the uber memo
        ChangeLogMemo.instance.newsposts.add(this);
    }

    void render(Element div) {
        poster.renderLine(div, date, text);
    }

}