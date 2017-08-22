import 'package:xml/xml.dart' as Xml;
///a section of a faq, can belong to a FAQFile or a GeneratedFAQ
class FAQSection {
    ///what is the question or section name? How do I x vs How to X
    String header;
    ///  what is the content of the section?  Answer to question, anywhere from a word to a few paragraphs.
    String body;
    /// each segment has an associated ascii header, will pick from one header at random for generated faq.
    String associatedAscii;

    FAQSection(this.header, this.body, this.associatedAscii);
    FAQSection.fromXMLDoc(Xml.XmlNode s, this.associatedAscii){
        print("making FAQSection from $s which has document of ${s.document}");
        header = s.children.where((Xml.XmlNode child) => (child is Xml.XmlElement && child.name.local == "header")).first.text;
        body = s.children.where((Xml.XmlNode child) => (child is Xml.XmlElement && child.name.local == "body")).first.text;
    }

    ///assume sections start with <section> and have no ending tag cuz i am lazy
    static List<Xml.XmlNode> mainTextToSubStrings(String text) {
        print("text is $text");
        Xml.XmlDocument document = Xml.parse(text);
        Xml.XmlElement ele = document.findElements("faq").first;
        print("document is $document, children are ${ele.children} elements that are section are: ${ele.findElements("section")}");
        return ele.findElements("section").toList();
    }
}