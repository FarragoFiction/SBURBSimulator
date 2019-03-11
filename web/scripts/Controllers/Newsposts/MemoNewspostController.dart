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

Future<Null> main() async {
  await loadNavbar();
  print("navbar loaded, i'm expeting this div to exist plz ${querySelector("#newspostsMain")}");
  doShit();
  //new Timer(new Duration(milliseconds: 10), doShit); //its a tear off since it takes no params (auto takes what caller has)

}

void doShit() {
  print("10ms awaited, i'm expeting this div to exist plz ${querySelector("#newspostsMain")}");

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

Future<Null> createNews() async{
  window.console.log("going to slurp news");

  await renderHeadshots();
  //await ChangeLogMemo.authorBot.slurpNewsposts();

  for(Wrangler w in Wrangler.all) {
    await w.slurpNewsposts();
  }





  ;
  renderNews();

}

Future<Null> renderHeadshots() async {
  Element div = querySelector("#newspostsMain");
  window.console.log("the div is ${div} for rendering headshots");

  DivElement container = new DivElement();
  container.classes.add("HeadshotContainer");

  for(Wrangler w in Wrangler.all) {
    w.renderHeadshot(container);
  }
  div.append(container);
}

void renderNews() {
  Element div = querySelector("#newspostsMain");
  window.console.log("the div is ${div} for rendering news");

  memo.render(div);
}