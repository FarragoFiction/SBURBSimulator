//import "../quirk.dart";

//i expect class and aspect to creat their own FAQFiles, and GetWasted to handle murder mode and grim dark and (trickster??? and bike faqs!???)
///handles knowing what file it should load, loading it on request, and parsing and distributing the subsections of the file.
class FAQFile {
    ///how do you get to the folders with the FAQs in the,
    String filePath = "../GameFaqs/";
    ///what is the name of the FAQ file you reference.
    String fileName;
    //TODO be able to load your file path and create sections. this shit is a prime candidate for unit testing, maybe if i get rid of quirk for now.
    FAQFile(this.fileName);
}

///a section of a faq, can belong to a FAQFile or a GeneratedFAQ
class FAQSection {
    ///what is the question or section name? How do I x vs How to X
    String header;
    ///  what is the content of the section?  Answer to question, anywhere from a word to a few paragraphs.
    String body;
}

///the faq that gets printed ontosb screen, complete with quirk
class GeneratedFAQ {
    ///will be printed first, no quirk.
    String asciiHeader;
    ///what quirk to apply to all sections.
   // Quirk quirk;
    ///what are the parts of this FAQ, loaded from different source files
    List<FAQSection> sections = new List<FAQSection>();
}