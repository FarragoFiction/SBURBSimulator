import "FAQSection.dart";
import "../SBURBSim.dart";

///the faq that gets printed ontosb screen, complete with quirk
class GeneratedFAQ {
    ///will be printed first, no quirk.
    String asciiHeader;
    Player author;

    ///what are the parts of this FAQ, loaded from different source files
    List<FAQSection> sections = new List<FAQSection>();

    GeneratedFAQ(this.author, this.asciiHeader, this.sections);

    //TODO better be courier new, bro
    String makeHtml() {
        print("I'm making html for a generated faq with ${sections.length} sections");
        String ret =  "<br><br>TODO: make the faqs be here with fixed position. There are ${sections.length} sections to this faq.<Br><Br>By ${author.chatHandle}";
        for(FAQSection s in sections) {
            ret = "$ret <br><Br>${s.header}<br><br>${s.body}<br><Br>";
        }
        return "<div class = 'FAQ'>$ret</div>";
    }
}