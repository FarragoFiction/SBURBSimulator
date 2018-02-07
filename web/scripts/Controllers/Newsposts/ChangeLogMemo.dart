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
    static Wrangler karmicRetribution = new Wrangler("karmicRetribution", "images/Credits/Smith_of_Dreams_Icon.png", new Colour.fromStyleString("#9630BF"));

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
        newsposts.sort();
        for(MemoNewspost m in newsposts) {
            m.render(div);
        }
    }
}


class MemoNewspost implements Comparable<MemoNewspost> {
    Wrangler poster;
    String text;
    DateTime date;
    MemoNewspost(this.poster, this.date, this.text) {
        //automatically add to the uber memo
        ChangeLogMemo.instance.newsposts.add(this);
    }

    MemoNewspost.from(String t, this.poster){
        //2018-02-02: I can fucking believe it's fucking Ground Hogs Day because I have spent the day murdering the fuck out of bugs that should be long fucking dead. Combo sessions once again work, and MAYBE players will stop spawning dead or near dead?<br><br>Also Shogun finally fucking works right. Also, YES I know you're fucking out of character but that is just going to hafta be a thing till the Big Bad update.
        print("Parsing line: $t");
        List<String> parts = t.split(":");
        print(parts);
        if(parts.length <2) return;
        date = DateTime.parse(parts[0].trim());
        parts.remove(parts[0]);
        text = "${parts.join('')}";
        ChangeLogMemo.instance.newsposts.add(this);
    }

    void render(Element div) {
        poster.renderLine(div, date, text);
    }

  @override
  int compareTo(MemoNewspost other) {
      Duration difference = other.date.difference(date);
      //will it be positive or negative?
      return difference.inSeconds;
  }
}