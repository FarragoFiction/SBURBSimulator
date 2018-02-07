//this is in charge of the main page newsposts, and the Author/ABJ newsposts.
//for now, just get main page working. (so no simulator madness)
import 'dart:html';
import '../../navbar.dart';
import 'dart:async';
import "../../random.dart";
import "ChangeLogMemo.dart";
import "Wrangler.dart";

ChangeLogMemo memo =  ChangeLogMemo.instance;

void main() {
  loadNavbar();
  createNews();
  renderNews();
  window.onScroll.listen((Event event){
    num ypos = window.scrollY; //pixels the site is scrolled down
    var visible = window.screen.height; //visible pixels
    const img_height = 1500; //replace with height of your image
    var max_scroll = img_height - visible; //number of pixels of the image not visible at bottom
    //change position of background-image as long as there is something not visible at the bottom
    if ( max_scroll > ypos) {
      querySelector("body").style.backgroundPosition = "center -" + ypos.toString() + "px";
    } else {
      querySelector("body").style.backgroundPosition = "center -" + max_scroll.toString() + "px";
    }
  });


}

//TODO load all newsposts by file.
void createNews() {
  new MemoNewspost(ChangeLogMemo.jadedResearcher, new DateTime.now(), "This is just a test.");
  new MemoNewspost(ChangeLogMemo.authorBot, new DateTime.now(), "There is a 94.23423423% chance this is working as intended.");
  new MemoNewspost(ChangeLogMemo.authorBotJunior, new DateTime.now(), "Hrmmm...");
  new MemoNewspost(ChangeLogMemo.jadedResearcher, new DateTime.now(), "Okay. I think it's time to style.");
}

void renderNews() {
  Element div = querySelector("#newspostsMain");
  memo.render(div);
}