//this is in charge of the main page newsposts, and the Author/ABJ newsposts.
//for now, just get main page working. (so no simulator madness)
import 'dart:html';
import '../../navbar.dart';
import 'StoredNewsposts.dart';
import 'dart:async';
import "../../random.dart";

void main() {
  loadNavbar();
  renderAuthorNews();
  renderArtistNews();
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
  cycleAuthorPics();
  //reFormatForTinyScreens(); //TODO was this doing anything. definitely didn't work right on mobile
}

void cycleAuthorPics() {
  String root = "images/misc/fanArt/OctoberMas/";
  List<String> possibleAvatars = ["author_wq.png","authorDoom.png","authorCal2.png","authorCal.png","authorHussie.png","authorHussieSpace.png","authorRyan.png","authorTrollsona.png"];
  possibleAvatars.addAll(["robot_author.png", "firerachet.png","pumpkin.png", "trickster_author_transparent.png","AlliumPomoea.png"]);
  (querySelector("#jrAvatar") as ImageElement).src = "$root${new Random().pickFrom(possibleAvatars)}";
  //jrAvatar(querySelector("#avatar")).style.float = "left";
  new Timer(new Duration(milliseconds: 2000), () => cycleAuthorPics()); //sweet sweet async
}




void renderAuthorNews() {
  List<Newspost> authorNews = Newspost.makeAuthorNewsposts();
  for(Newspost n in authorNews) {
    String str = "<div id = '${n.date}human'><hr> ";
    str += "<b>${n.date}:</b> ";
    str += n.post+ "</div>";
    querySelector("#newspostsMain").appendHtml(str,treeSanitizer: NodeTreeSanitizer.trusted);
  }

}

void renderArtistNews() {
  List<Newspost> artistNews = Newspost.makeArtistNewsposts();
  for(Newspost n in artistNews) {
    String str = "<div id = '${n.date}human'><hr> ";
    str += "<b>${n.date}:</b> ";
    str += n.post+ "</div>";
    querySelector("#artist_newspostsMain").appendHtml(str,treeSanitizer: NodeTreeSanitizer.trusted);
  }
}