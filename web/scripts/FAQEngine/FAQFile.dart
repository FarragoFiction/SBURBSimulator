import "../SBURBSim.dart";
import "FAQSection.dart";
import 'package:xml/xml.dart' as Xml;
import 'dart:html'; //<--needed for loading the file this is fucking bullshit. means i can't unit test this part. oh well, unit test parsing first.

import "GeneratedFAQ.dart";



///handles knowing what file it should load, loading it on request, and parsing and distributing the subsections of the file.
///i expect class and aspect to creat their own FAQFiles, and GetWasted to handle murder mode and grim dark and (trickster??? and bike faqs!???)
class FAQFile {
    ///how do you get to the folders with the FAQs in the,
    String filePath = "../GameFaqs/";
    ///what is the name of the FAQ file you reference.
    String fileName;
    dynamic callback;

    List<FAQSection> sections = new List<FAQSection>();

    FAQFile(this.fileName);

    ///passed a callback since it might have to load
    FAQSection getRandomSection(Random rand) {
        if(sections.isEmpty) {
            loadWithCallBack(getRandomSection(rand));
        }else {
            rand.pickFrom(sections);
        }
    }



    /// it will load it's file from the server, parse it into sections,  then call the callback when it's done.
    /// which is basically used for letting whoever called it know it's done.
    /// REMINDER TO FUTUREJR: loading is async. Never forget this.
    void loadWithCallBack(callBack) {
        callback = callBack;
        HttpRequest.getString("$filePath$fileName").then(afterLoaded);

    }

    void afterLoaded(String data) {
        parseRawTextIntoSections(data);
        callback();
    }

    ///take the raw text that was loaded from the file and turn it into your sections and shit
    /// looking for <section></section>, <header </header> and <body></body>
    void parseRawTextIntoSections(String text) {
        //first, i need to turn the string into a list of substrings that are a single section
        List<Xml.XmlNode> sectionStrings = FAQSection.mainTextToSubStrings(text);
        print("after parsing main text, sectionStrings are $sectionStrings");
        //then, I need to call a new function on that substring to turn it into a section.
        for(Xml.XmlNode tmp in sectionStrings) {
            print("after parsing main text, trying to parse  $tmp");
            sections.add(new FAQSection.fromXMLDoc(tmp));
        }
    }

}

