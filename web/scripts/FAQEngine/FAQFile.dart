//import "../quirk.dart";
import "FAQSection.dart";
import "GeneratedFAQ.dart";


///handles knowing what file it should load, loading it on request, and parsing and distributing the subsections of the file.
///i expect class and aspect to creat their own FAQFiles, and GetWasted to handle murder mode and grim dark and (trickster??? and bike faqs!???)
class FAQFile {
    ///how do you get to the folders with the FAQs in the,
    String filePath = "../GameFaqs/";
    ///what is the name of the FAQ file you reference.
    String fileName;
    //TODO be able to load your file path and create sections. this shit is a prime candidate for unit testing, maybe if i get rid of quirk for now.
    FAQFile(this.fileName);
}

