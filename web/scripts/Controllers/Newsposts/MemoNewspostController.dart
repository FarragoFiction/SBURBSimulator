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
  ChangeLogMemo.init();
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
  await renderHeadshots();
  //await ChangeLogMemo.authorBot.slurpNewsposts();
  //keep me and kr at bottom so ppl can react to us
  await ChangeLogMemo.karmicRetribution.slurpNewsposts();
  await ChangeLogMemo.jadedResearcher.slurpNewsposts();
  await ChangeLogMemo.authorBot.slurpNewsposts();
  await ChangeLogMemo.authorBotJunior.slurpNewsposts();





  print("Ready to handle ${memo.newsposts.length} posts");
    renderNews();

}

Future<Null> renderHeadshots() async {
  Element div = querySelector("#newspostsMain");
  DivElement container = new DivElement();
  container.classes.add("HeadshotContainer");

  for(Wrangler w in Wrangler.all) {
    w.renderHeadshot(container);
  }
  div.append(container);
}

void renderNews() {
  Element div = querySelector("#newspostsMain");
  memo.render(div);
}