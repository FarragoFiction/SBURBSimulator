import "../quirk.dart";

//i expect class and aspect to creat their own FAQFiles, and GetWasted to handle murder mode and grim dark and (trickster??? and bike faqs!???)
///handles knowing what file it should load, loading it on request, and parsing and distributing the subsections of the file.
class FAQFile {
    String filePath;
    //TODO be able to load your file path and create sections. this shit is a prime candidate for unit testing, maybe if i get rid of quirk for now.
}

///a section of a faq, can belong to a FAQFile or a GeneratedFAQ
class FAQSection {
    String header;
    String body;
}

///the faq that gets printed ontosb screen, complete with quirk
class GeneratedFAQ {
    String asciiHeader; //print this first, and no quirk.
    Quirk quirk;
    List<FAQSection> sections = new List<FAQSection>();
}