///a section of a faq, can belong to a FAQFile or a GeneratedFAQ
class FAQSection {
    ///what is the question or section name? How do I x vs How to X
    String header;
    ///  what is the content of the section?  Answer to question, anywhere from a word to a few paragraphs.
    String body;
}