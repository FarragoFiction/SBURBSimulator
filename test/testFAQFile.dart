import "JRTestSuite.dart";
import "../web/scripts/FAQEngine/FAQFile.dart";

//this will not run as long as I reference quirk. stupid html package

//god, i hate that i can't do simple unit tests if any html gets anywhere, so can't test file loading yet.
//experimenting with different scripting bs. should only need two tags for now.
//TODO might not work for real one. \n in here breaks it, will actual new lines break it from html? either way probably should replace with <Br>
String pretendFileContents = "<faq><section><header>Question: Does this parser work?</header><body>Apparently.</body></section><section><header>Question: How bullshit is everything.</header><body>Extremely.</body></section></faq>";

main() {
    //print("Hello World");
    basicTests();
}

FAQFile setupFF() {
    return new FAQFile("Rage.xml");
}

void basicTests() {
    FAQFile f = setupFF();
    jRAssert("faqFIle object existing", f != null, true);
    jRAssert("fileName", f.fileName, "Rage.xml");
    f.parseRawTextIntoSections(pretendFileContents);
    jRAssert("number of sections", f.sections.length, 2);
    jRAssert("section 1 header", f.sections[0].header, "Question: Does this parser work?");
    jRAssert("section 1 body", f.sections[0].body, "Apparently.");
    jRAssert("section 2 header", f.sections[1].header, "Question: How bullshit is everything.");
    jRAssert("section 2 body", f.sections[1].body, "Extremely.");
}