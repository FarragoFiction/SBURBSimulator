import 'package:xml/xml.dart' as Xml;
///a section of a faq, can belong to a FAQFile or a GeneratedFAQ
class FAQSection {
    ///what is the question or section name? How do I x vs How to X
    String header;
    ///  what is the content of the section?  Answer to question, anywhere from a word to a few paragraphs.
    String body;

    FAQSection(this.header, this.body);
    FAQSection.fromString(String s){
        print("gettin sections out of $s");
        Iterable<Match> headerMatches = new RegExp("<header>.*</header>", multiLine:true).allMatches(s);
        print("matches is ${headerMatches.length}");
        header = headerMatches.first.group(0);
        Iterable<Match> bodyMatches = new RegExp("<body>.*</body>", multiLine:true).allMatches(s);
        body = bodyMatches.first.group(0);
        print("created section with $header and $body");
    }

    ///assume sections start with <section> and have no ending tag cuz i am lazy
    static List<String> mainTextToSubStrings(String text) {
        print("text is $text");
        Xml.XmlDocument document = Xml.parse(text);
        print("children are ${document.children}");
        return text.split("<section>");
    }
}