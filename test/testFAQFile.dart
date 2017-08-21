import "JRTestSuite.dart";
import "../web/scripts/FAQEngine/FAQFile.dart";

//this will not run as long as I reference quirk. stupid html package

//god, i hate that i can't do simple unit tests if any html gets anywhere, so can't test file loading yet.
//experimenting with different scripting bs. should only need two tags for now.
//TODO might not work for real one. \n in here breaks it, will actual new lines break it from html? either way probably should replace with <Br>
String pretendFileContents = "<section><header>+++++++++++++++++++++Question: Does this parser work?  +++++++++++++++++++++++</header><body>Apparently.</body></section><section><header>+++++++++++++++++++++Question: How bullshit is everything.+++++++++++++++++++++++</header><body>Extremely.</body></section>";

main() {
    print("Hello World");
    basicTests();
}

FAQFile setupFF() {
    return new FAQFile("Rage.txt");
}

void basicTests() {
    FAQFile f = setupFF();
    jRAssert("faqFIle object existing", f != null, true);
    jRAssert("fileName", f.fileName, "Rage.txt");
    f.parseRawTextIntoSections(pretendFileContents);
    jRAssert("number of sections", f.sections.length, 2);
}