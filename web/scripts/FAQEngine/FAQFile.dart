import "../SBURBSim.dart";
import "FAQSection.dart";
import 'package:xml/xml.dart' as Xml;
import 'dart:html'; //<--needed for loading the file this is fucking bullshit. means i can't unit test this part. oh well, unit test parsing first.

import "GeneratedFAQ.dart";



///handles knowing what file it should load, loading it on request, and parsing and distributing the subsections of the file.
///i expect class and aspect to creat their own FAQFiles, and GetWasted to handle murder mode and grim dark and (trickster??? and bike faqs!???)
class FAQFile {
    ///how do you get to the folders with the FAQs in the,
    String filePath = "GameFaqs/";
    ///what header is associated with content from this file?
    String ascii;
    Random rand;
    ///what is the name of the FAQ file you reference.
    String fileName;
    //when i am done loading, what do i call?
    dynamic externalCallback;
    //need to take in an element because whatever calls me probably wants to write to page but can't without callback
    Element externalDiv;
    ///last thing i need for callback. GetWasted is in charge of making sure I dont' get called a second time while i'm still loading myself.
    Player externalPlayer;
    ///no matter what, only try once.
    bool loadedOnce = false;

    List<FAQSection> sections = new List<FAQSection>();

    FAQFile(this.fileName,this.ascii);

    void getRandomSectionAsync(Random r, callBack, Element div, Player player) {
       rand = r;
       externalDiv = div;
       externalCallback = callBack;
       externalPlayer = player;
       _getRandomSectionInternal();
    }
    ///passed a callback since it might have to load
    void _getRandomSectionInternal() {
       // print("getting random section");
        if(sections.isEmpty && !loadedOnce) {
            print("can't find any sections for $fileName, gonna load");
            load();
            loadedOnce = true;
        }else {
            //print("there are ${sections.length} sections");
            //TODO remove picked section, wait, no don't do it here, cuz what generic file to never remove.
            externalCallback(rand.pickFrom(sections),externalDiv, externalPlayer, rand);
        }
    }



    /// it will load it's file from the server, parse it into sections,  then call the callback when it's done.
    /// which is basically used for letting whoever called it know it's done.
    /// REMINDER TO FUTUREJR: loading is async. Never forget this.
    void load() {
        HttpRequest.getString("$filePath$fileName").then(afterLoaded);

    }

    void afterLoaded(String data) {
       // print("loading finished");
        parseRawTextIntoSections(data);
        _getRandomSectionInternal();
    }

    ///take the raw text that was loaded from the file and turn it into your sections and shit
    /// looking for <section></section>, <header </header> and <body></body>
    void parseRawTextIntoSections(String text) {
        //first, i need to turn the string into a list of substrings that are a single section
        List<Xml.XmlNode> sectionStrings = FAQSection.mainTextToSubStrings(text);
       // print("after parsing main text, sectionStrings are $sectionStrings");
        //then, I need to call a new function on that substring to turn it into a section.
        for(Xml.XmlNode tmp in sectionStrings) {
            //print("after parsing main text, trying to parse  $tmp");
            sections.add(new FAQSection.fromXMLDoc(tmp, ascii));
        }
    }

}

