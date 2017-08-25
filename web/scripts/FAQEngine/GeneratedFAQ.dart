import "FAQSection.dart";
import "../SBURBSim.dart";

///the faq that gets printed ontosb screen, complete with quirk
class GeneratedFAQ {
    ///will be printed first, no quirk.
    String asciiHeader;
    Player author;
    Player reader;
    ///what symbold do you spam for the header
    String symbol = "*";
    //which symbols are used for headers is consisten in a generated faq but not between them
    List<String> _possibleSymbols = <String>["*","@","#","!","~",".","=","-","%","\$"];
    Random rand;
    bool rendered = false;
    int sectionsRequested = 0; //TODO<--keep track of which section goes in which slot of the array, or order will be slightly random
    int sectionsWanted = 10;
    ///what are the parts of this FAQ, loaded from different source files
    List<FAQSection> sections = new List<FAQSection>();

    GeneratedFAQ(this.author,this.sections, this.rand) {
        symbol = rand.pickFrom(_possibleSymbols);
    }

    //get first piece of ascii art associated with any section. make sure sections without art are empty, no default values anymore
    static String pickASCIIHeaderFromSections(Random r, List<FAQSection> sections) {
       // return r.pickFrom(sections).associatedAscii;
        String ret = "";
        for(FAQSection s in sections) {
            //prefer more complicated ascii
            if(s.associatedAscii.length > ret.length) ret = s.associatedAscii;
        }
        if(ret.isEmpty) ret = "<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<br><3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<br><3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3";
        return ret;
    }

    //TODO better be courier new, bro
    String makeHtml(String id) {
        int amount = 10;
       // print("I'm making html for a generated faq with ${sections.length} sections");
        Quirk q = author.quirk;
        asciiHeader = GeneratedFAQ.pickASCIIHeaderFromSections(rand, sections);
        if(asciiHeader == Aspects.TIME.faqFile.ascii) print("Displaying time ascii art in session ${author.session.session_id}");

        String ret =  "<button class='red_x'id = 'close$id'>X</button><br><br><div class = 'ascii'>$asciiHeader</div><Br><Br><center>By ${author.chatHandle}</center>";
        for(FAQSection s in sections) {
            String header ="${symbol*amount}${q.translate(s.header)}";
            header.replaceAll("\n", ""); //no new lines in header plz
            ret = "$ret <br><Br>$header${symbol*amount}<br><br>${q.translate(s.body)}<br><Br>";
        }
        return "<div class = 'FAQ'>$ret</div>";
    }
}