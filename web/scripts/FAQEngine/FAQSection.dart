import 'package:xml/xml.dart' as Xml;
///a section of a faq, can belong to a FAQFile or a GeneratedFAQ
class FAQSection {
    ///what is the question or section name? How do I x vs How to X
    String header;
    ///  what is the content of the section?  Answer to question, anywhere from a word to a few paragraphs.
    String body;
    /// each segment has an associated ascii header, will pick from one header at random for generated faq.
    /// header comes from file itself, special xml section, sibling of sections
    String associatedAscii;

    FAQSection(this.header, this.body, this.associatedAscii);
    FAQSection.fromXMLDoc(Xml.XmlNode s, this.associatedAscii){
        ////;
        header = s.children.where((Xml.XmlNode child) => (child is Xml.XmlElement && child.name.local == "header")).first.text;
        body = s.children.where((Xml.XmlNode child) => (child is Xml.XmlElement && child.name.local == "body")).first.text;
        ////;
    }

    ///assume sections start with <section> and have no ending tag cuz i am lazy
    static List<Xml.XmlNode> mainTextToSubStrings(String text) {
       // //;
        Xml.XmlDocument document = Xml.parse(text);
        Xml.XmlElement ele = document.findElements("faq").first;
       // //;
        return ele.findElements("section").toList();
    }
}