//this is in charge of the main page newsposts, and the Author/ABJ newsposts.
//for now, just get main page working. (so no simulator madness)
import 'dart:html';
import 'StoredNewsposts.dart';
part '../navbar.dart';
main() {
  //TODO render navbar, make bg work like KR wanted.
  loadNavbar();
  renderAuthorNews();
  renderArtistNews();
  /*

  window.onload = function() {
			loadNavbar();
			//pass true so that it formats them differently.
			newsposts("Main");
			artNewsposts("Main");
			reFormatForTinyScreens();
			$( window ).scroll( function(){
				var ypos = $( window ).scrollTop(); //pixels the site is scrolled down
				var visible = $( window ).height(); //visible pixels
				const img_height = 1500; //replace with height of your image
				var max_scroll = img_height - visible; //number of pixels of the image not visible at bottom
			//change position of background-image as long as there is something not visible at the bottom
			if ( max_scroll > ypos) {
				 $("body").css("background-position", "center -" + ypos + "px");
				} else {
				$("body").css("background-position", "center -" + max_scroll + "px");
				}
		});
	}
   */
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