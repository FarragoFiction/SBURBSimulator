import "FAQSection.dart";
import "../SBURBSim.dart";

///the faq that gets printed ontosb screen, complete with quirk
class GeneratedFAQ {
    ///will be printed first, no quirk.
    String asciiHeader;

    ///what are the parts of this FAQ, loaded from different source files
    List<FAQSection> sections = new List<FAQSection>();

    GeneratedFAQ(this.asciiHeader, this.sections);

    String makeHtml(Quirk quirk) {
        String ret =  "<span class = 'FAQ'><br><br>TODO: make the faqs be here with fixed position. There are ${sections.length} sections to this faq.</span>";
        for(FAQSection s in sections) {
            ret = "$ret <br><Br>${s.header}<br><br>${s.body}";
        }
        return ret;
    }
}