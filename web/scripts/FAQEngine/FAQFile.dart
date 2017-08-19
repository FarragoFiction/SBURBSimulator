import "../quirk.dart";
/*
        A faq file is a wrapper for a .txt file. Once it loads, it creates subSections which other things can use. (get a random subsection).
        Once a subsection is used, it's no longer available.

        I think classes/aspects should handle having FAQFiles, and the GetWasted scene handles special ones like grim dark and murder mode.

 */



class FAQFile {

}

class FAQSection {

}

class generatedFAQ {
    Quirk quirk;
    List<FAQSection> sections = new List<FAQSection>();
}