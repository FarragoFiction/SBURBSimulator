//this is in charge of the main page newsposts, and the Author/ABJ newsposts.
//for now, just get main page working. (so no simulator madness)
import 'dart:html';
import '../../navbar.dart';
import 'StoredNewsposts.dart';

void main() {
  loadNavbar();
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
  //reFormatForTinyScreens(); //TODO was this doing anything. definitely didn't work right on mobile
}



void renderArtistNews() {
  List<Newspost> artistNews = Newspost.makeArtistNewsposts();
  for(Newspost n in artistNews) {
    String str = "<div id = '${n.date}human'><hr> ";
    str += "<b>${n.date}:</b> ";
    str += n.post+ "</div>";
    querySelector("#artist_newsposts").appendHtml(str,treeSanitizer: NodeTreeSanitizer.trusted);
  }
}