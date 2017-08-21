import "JRTestSuite.dart";
import "../web/scripts/FAQEngine/FAQFile.dart";

//this will not run as long as I reference quirk. stupid html package

//god, i hate that i can't do simple unit tests if any html gets anywhere, so can't test file loading yet.
//experimenting with different scripting bs. should only need two tags for now.
String pretendFileContents = "<header>+++++++++++++++++++++Question: Does this parser work?  +++++++++++++++++++++++</header>\n<body>Apparently.\n</body>\n<header>+++++++++++++++++++++Question: How bullshit is everything.+++++++++++++++++++++++</header>\n<body>Extremely.\n</body>";

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