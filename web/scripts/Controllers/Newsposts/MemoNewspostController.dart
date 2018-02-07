//this is in charge of the main page newsposts, and the Author/ABJ newsposts.
//for now, just get main page working. (so no simulator madness)
import 'dart:html';
import '../../navbar.dart';
import 'dart:async';
import "../../random.dart";
import "ChangeLogMemo.dart";
import "Wrangler.dart";
import 'dart:async';


ChangeLogMemo memo =  ChangeLogMemo.instance;

void main() {
  loadNavbar();
  createNews();
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
Future<Null> createNews() async{
  await ChangeLogMemo.jadedResearcher.slurpNewsposts();
  await ChangeLogMemo.karmicRetribution.slurpNewsposts();

  print("Ready to handle ${memo.newsposts.length} posts");
    renderNews();

}

void renderNews() {
  Element div = querySelector("#newspostsMain");
  memo.render(div);
}