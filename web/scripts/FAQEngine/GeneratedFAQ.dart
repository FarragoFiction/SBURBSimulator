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
        return "<span class = 'FAQ'>TODO: make the faqs be here with fixed position.</span>";
    }
}