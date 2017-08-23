import "FAQSection.dart";
import "../SBURBSim.dart";

///the faq that gets printed ontosb screen, complete with quirk
class GeneratedFAQ {
    ///will be printed first, no quirk.
    String asciiHeader;
    Player author;
    ///what symbold do you spam for the header
    String symbol = "*";
    //which symbols are used for headers is consisten in a generated faq but not between them
    List<String> _possibleSymbols = <String>["*","@","#","!","~",".","=","-","%","\$"];
    int amount = 10;
    Random rand;
    bool rendered = false;

    ///what are the parts of this FAQ, loaded from different source files
    List<FAQSection> sections = new List<FAQSection>();

    GeneratedFAQ(this.author, this.asciiHeader, this.sections, this.rand) {
        symbol = rand.pickFrom(_possibleSymbols);
    }

    //TODO better be courier new, bro
    String makeHtml() {
        print("I'm making html for a generated faq with ${sections.length} sections");
        Quirk q = author.quirk;
        String ret =  "<br><br>TODO: make the faqs be here with fixed position. There are ${sections.length} sections to this faq.<Br><Br><center>By ${author.chatHandle}</center>";
        for(FAQSection s in sections) {
            ret = "$ret <br><Br>${symbol*amount}${q.translate(s.header)}${symbol*amount}<br><br>${q.translate(s.body)}<br><Br>";
        }
        return "<div class = 'FAQ'>$ret</div>";
    }
}