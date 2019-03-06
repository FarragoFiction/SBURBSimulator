import "../SBURBSim.dart";
import "FAQSection.dart";
import 'package:xml/xml.dart' as Xml;
import 'dart:html'; //<--needed for loading the file this is fucking bullshit. means i can't unit test this part. oh well, unit test parsing first.

import "GeneratedFAQ.dart";


typedef void LoadingCallback(FAQSection s, Element div, GeneratedFAQ faq);

///handles knowing what file it should load, loading it on request, and parsing and distributing the subsections of the file.
///i expect class and aspect to creat their own FAQFiles, and GetWasted to handle murder mode and grim dark and (trickster??? and bike faqs!???)
class FAQFile {
    ///how do you get to the folders with the FAQs in the,
    String filePath = "GameFaqs/";
    ///what header is associated with content from this file?
    String ascii = "IF YOU SEE THIS SOMETHING IS WRONG";
    ///what is the name of the FAQ file you reference.
    String fileName;

    ///no matter what, only try once.
    bool loadedOnce = false;
    List<CallBackObject> callbacks = new List<CallBackObject>();

    List<FAQSection> sections = new List<FAQSection>();

    FAQFile(this.fileName);

    ///takes in a generated faq because i need to keep track of what sessiosn i have and isntance variables can suck it
    void getRandomSectionAsync(LoadingCallback callBack, Element div, GeneratedFAQ gfaq) {
          ////;
       _getRandomSectionInternal(new CallBackObject(div, callBack, gfaq));
    }


    ///passed a callback since it might have to load
    void _getRandomSectionInternal(CallBackObject callBack) {
       // //;
        if(sections.isEmpty) {
            callbacks.add(callBack);
            if(!loadedOnce && !doNotFetchXml) {
               //;
                loadedOnce = true;
                load(); ///nothing can happen after async
                return;
            }
        }else{ //this only happens if sections
            callBack.call(sections);
        }
    }

    void giveLoadedFileToCallBacks(bool mainThread) {
        ////;
        for(CallBackObject c in callbacks) {
           // //;
            c.call(sections);
        }
        ////;
        callbacks.clear();
    }



    /// it will load it's file from the server, parse it into sections,  then call the callback when it's done.
    /// which is basically used for letting whoever called it know it's done.
    /// REMINDER TO FUTUREJR: loading is async. Never forget this.
    void load() {
       // //;
        HttpRequest.getString("$filePath$fileName").then(afterLoaded);

    }

    void afterLoaded(String data) {
       // //;
        parseRawTextIntoSections(data);
        giveLoadedFileToCallBacks(false); //<--pass null because no new callback is needed
    }

    static String parseASCIIOut(String text) {
        //if there IS no asci, just use default for now.
        Xml.XmlDocument document = Xml.parse(text);
        Xml.XmlElement ele = document.findElements("faq").first;
        Iterable<Xml.XmlNode> nodes = ele.findElements("ascii");
        String ret = ""; //needs to be empty so that it doesn't get used
        if(!nodes.isEmpty) ret = nodes.first.text;
        return ret;
    }

    ///take the raw text that was loaded from the file and turn it into your sections and shit
    /// looking for <section></section>, <header </header> and <body></body>
    void parseRawTextIntoSections(String text) {
        //first, i need to turn the string into a list of substrings that are a single section
        List<Xml.XmlNode> sectionStrings = FAQSection.mainTextToSubStrings(text);
        ascii = FAQFile.parseASCIIOut(text);
       // //;
        //then, I need to call a new function on that substring to turn it into a section.
        for(Xml.XmlNode tmp in sectionStrings) {
            ////;
            sections.add(new FAQSection.fromXMLDoc(tmp, ascii));
        }
    }

}


///used to hold all info needed to give a callback, useful if multiple things try to access a file that's still loading
class CallBackObject
{
    //when i am done loading, what do i call?
    LoadingCallback externalCallback;
    //need to take in an element because whatever calls me probably wants to write to page but can't without callback
    Element externalDiv;
    ///last thing i need for callback. GetWasted is in charge of making sure I dont' get called a second time while i'm still loading myself.
    GeneratedFAQ gfaq;

    CallBackObject(this.externalDiv, this.externalCallback, this.gfaq);

    void call(List<FAQSection> sections) {
        ////;
        this.externalCallback(gfaq.rand.pickFrom(sections),externalDiv, gfaq);
    }
}
