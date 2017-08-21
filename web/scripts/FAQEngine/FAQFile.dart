//import "../quirk.dart";
import "FAQSection.dart";
import "GeneratedFAQ.dart";
//import 'dart:html'; //<--needed for loading the file this is fucking bullshit. means i can't unit test this part. oh well, unit test parsing first.



///handles knowing what file it should load, loading it on request, and parsing and distributing the subsections of the file.
///i expect class and aspect to creat their own FAQFiles, and GetWasted to handle murder mode and grim dark and (trickster??? and bike faqs!???)
class FAQFile {
    ///how do you get to the folders with the FAQs in the,
    String filePath = "../GameFaqs/";
    ///what is the name of the FAQ file you reference.
    String fileName;

    List<FAQSection> sections = new List<FAQSection>();

    FAQFile(this.fileName);

    /// it will load it's file from the server, parse it into sections,  then call the callback when it's done.
    /// which is basically used for letting whoever called it know it's done.
    /// REMINDER TO FUTUREJR: loading is async. Never forget this.
    void loadWithCallBack(callBack) {
        /*  TODO uncomment this out when i'm done unit testing and uncomment out import for dart html
        HttpRequest.getString("navbar.txt").then(HttpRequest resp) {
            parseRawTextIntoSections(resp.responseText);
            callBack();

        });
        */
    }

    ///take the raw text that was loaded from the file and turn it into your sections and shit
    /// looking for <section></section>, <header </header> and <body></body>
    void parseRawTextIntoSections(String text) {
        //first, i need to turn the string into a list of substrings that are a single section
        List<String> sectionStrings = FAQSection.mainTextToSubStrings(text);
        print("after parsing main text, sectionStrings are $sectionStrings");
        //then, I need to call a new function on that substring to turn it into a section.
        for(String tmp in sectionStrings) {
            print("after parsing main text, trying to parse  $tmp");
            if (!tmp.isEmpty) sections.add(new FAQSection.fromString(tmp));  //because of my bad laziness, can have blanks.
        }
    }

}

